import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:web/web.dart' as web;

const _accessToken = String.fromEnvironment('ACCESS_TOKEN');

/// The [JSMap] instance held by the widget tree's [MapWebWidget], if any.
JSMap? currentMap(WidgetTester tester) =>
    (tester.state(find.byType(MapWebWidget)) as dynamic).currentMap as JSMap?;

/// Retrieves the [JSMap] from the widget tree and waits for it to be idle.
Future<JSMap> waitForMap(WidgetTester tester) async {
  await tester.pumpAndSettle();

  final map = currentMap(tester);
  if (map == null) fail('Map not created');

  final completer = Completer<void>();
  map.once('idle', (() => completer.complete()).toJS);
  await completer.future;

  return map;
}

/// Pumps [build]'s widget tree, wiring [onCreated] to complete once the map
/// controller is created, and waits for the map to go idle.
///
/// Use this instead of [waitForMap] directly when a test needs a widget tree
/// [MapWebWidget]'s built-in `overlay` slot can't express.
Future<MapboxMapPlatformInterface> pumpMapTree(
  WidgetTester tester,
  Widget Function(PlatformMapCreatedCallback onCreated) build,
) async {
  // MapWebWidget only kicks off GL JS's (async) script injection once it
  // mounts, in initState -- so the raw `accessToken =` setter (a plain,
  // synchronous `mapboxgl.accessToken = ...`) races that load on a freshly
  // loaded page, which is every page Patrol gives a test (it reloads per
  // test). setAccessToken() instead chains onto the same `glJsReady` future
  // MapWebWidget's own map construction awaits, so the token is set before
  // any map reads it regardless of whether GL JS was already loaded.
  MapboxMapsFlutterWeb().setAccessToken(_accessToken);
  final created = Completer<MapboxMapPlatformInterface>();
  await tester.pumpWidget(build((c) => created.complete(c)));
  // Patrol runs on a LiveTestWidgetsFlutterBinding, which (unlike `flutter
  // test`) does NOT reset the widget tree between tests. Without this, the
  // map created above stays mounted into the *next* test whenever that test
  // doesn't itself call pumpMapTree(). On CI's headless software-WebGL
  // runner a lingering, continuously-composited map stalls Patrol's
  // between-test handoff and the whole run freezes. Tearing the app back
  // down to an empty widget disposes the platform map (MapWebWidget's
  // dispose calls GL JS `map.remove()`), so every test starts from a clean
  // slate — and awaiting the frame that unmounts it (not just pumpWidget()
  // returning) ensures dispose() has actually run before the test ends.
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    await WidgetsBinding.instance.endOfFrame.timeout(
      const Duration(seconds: 5),
      onTimeout: () {},
    );
    await Future<void>.delayed(const Duration(milliseconds: 100));
  });
  await waitForMap(tester);
  return created.future.timeout(const Duration(seconds: 5));
}

/// Resolves the GL JS canvas container, the DOM node GL JS attaches its own
/// event and cursor handling to.
///
/// Earlier tests can leave detached map DOM nodes behind, so this picks the
/// most-recently-added container: the one belonging to the current test.
web.HTMLElement canvasContainer() {
  final all = web.document.querySelectorAll('.mapboxgl-canvas-container');
  expect(
    all.length,
    greaterThan(0),
    reason: 'canvas container should be in the DOM',
  );
  return all.item(all.length - 1)! as web.HTMLElement;
}

/// The client-space rect of the map container (`.mapboxgl-map`). Prefer this
/// over the canvas container's own rect, which can report a zero-height rect.
web.DOMRect mapRect() {
  final all = web.document.querySelectorAll('.mapboxgl-map');
  expect(
    all.length,
    greaterThan(0),
    reason: 'map container should be in the DOM',
  );
  return (all.item(all.length - 1)! as web.HTMLElement).getBoundingClientRect();
}

web.MouseEvent mouseEvent(String type, double x, double y) => web.MouseEvent(
  type,
  web.MouseEventInit(
    clientX: x.round(),
    clientY: y.round(),
    bubbles: true,
    cancelable: true,
  ),
);

web.WheelEvent wheelEvent(double x, double y) => web.WheelEvent(
  'wheel',
  web.WheelEventInit(
    deltaY: 120,
    clientX: x.round(),
    clientY: y.round(),
    bubbles: true,
    cancelable: true,
  ),
);

/// A `touch` [type] event at ([x], [y]). `touchend` carries no active
/// `touches` (the finger has lifted) but still reports the lifted point via
/// `changedTouches`, mirroring real browser semantics.
web.TouchEvent touchEvent(String type, double x, double y) {
  final touch = web.Touch(
    web.TouchInit(
      identifier: 0,
      target: canvasContainer(),
      clientX: x,
      clientY: y,
    ),
  );
  final active = type == 'touchend' ? const <web.Touch>[] : [touch];
  return web.TouchEvent(
    type,
    web.TouchEventInit(
      touches: active.toJS,
      changedTouches: [touch].toJS,
      bubbles: true,
      cancelable: true,
    ),
  );
}

/// A multi-touch `type` event with one active touch per point in [points],
/// identified 0, 1, 2… in list order. Keep a finger's index stable across a
/// sequence of calls (e.g. drop it from [points] to simulate that finger
/// lifting) so it keeps the same identifier throughout.
web.TouchEvent multiTouchEvent(
  String type,
  List<({double x, double y})> points,
) {
  final touches = [
    for (var i = 0; i < points.length; i++)
      web.Touch(
        web.TouchInit(
          identifier: i,
          target: canvasContainer(),
          clientX: points[i].x,
          clientY: points[i].y,
        ),
      ),
  ];
  return web.TouchEvent(
    type,
    web.TouchEventInit(
      touches: touches.toJS,
      changedTouches: touches.toJS,
      bubbles: true,
      cancelable: true,
    ),
  );
}

/// A touch event with no touch points at all: neither `touches` nor
/// `changedTouches` carries one.
web.TouchEvent emptyTouchEvent(String type) => web.TouchEvent(
  type,
  web.TouchEventInit(
    touches: const <web.Touch>[].toJS,
    changedTouches: const <web.Touch>[].toJS,
    bubbles: true,
    cancelable: true,
  ),
);

/// Dispatches [event] on the canvas container and reports whether it reached
/// a bubble-phase listener there, the phase GL JS listens on.
bool arrivesAtCanvas(web.Event event) {
  final canvas = canvasContainer();
  var arrived = false;
  void listener(web.Event _) => arrived = true;
  final jsListener = listener.toJS;
  canvas.addEventListener(event.type, jsListener);
  canvas.dispatchEvent(event);
  canvas.removeEventListener(event.type, jsListener);
  return arrived;
}
