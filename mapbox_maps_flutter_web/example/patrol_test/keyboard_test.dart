import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:turf/turf.dart' show Point, Position;
import 'patrol.dart';

import 'test_utils.dart';

// GL JS `KeyboardHandler.keydown()` switches on the legacy DOM `keyCode`
// values below
const _arrowLeft = 37;
const _arrowUp = 38;
const _arrowRight = 39;
const _arrowDown = 40;
const _equals = 187;
const _minus = 189;

final _viewport = CameraViewportState(
  center: Point(coordinates: Position(0, 0)),
  zoom: 5,
);

Widget _mapApp(PlatformMapCreatedCallback onCreated) => MaterialApp(
  home: Scaffold(
    body: Stack(
      children: [
        Positioned.fill(
          child: MapWebWidget(viewport: _viewport, onMapCreated: onCreated),
        ),
      ],
    ),
  ),
);

/// A snapshot of the camera immediately before a keypress, so assertions can
/// check the resulting *change* rather than hardcoding [_viewport]'s values.
({JSLngLat center, double zoom, double bearing, double pitch}) _cameraBefore(
  WidgetTester tester,
) {
  final map = currentMap(tester)!;
  return (
    center: map.getCenter(),
    zoom: map.getZoom(),
    bearing: map.getBearing(),
    pitch: map.getPitch(),
  );
}

/// Dispatches a `keydown`/`keyup` pair for [keyCode] directly on the GL JS
/// canvas container (the element GL JS's own listener is attached to,
/// bypassing any need for real DOM focus) and returns the
/// [MapKeyboardGestureContext] the `keyboardEvents` stream emits once the
/// resulting camera ease reaches `GestureState.ended`.
Future<MapKeyboardGestureContext> _pressKey(
  MapboxMapPlatformInterface controller,
  int keyCode, {
  bool shiftKey = false,
}) {
  final completer = Completer<MapKeyboardGestureContext>();
  late final StreamSubscription<MapKeyboardGestureContext> sub;
  sub = controller.gestures.keyboardEvents.listen((event) {
    if (event.gestureState == GestureState.ended && !completer.isCompleted) {
      completer.complete(event);
    }
  });

  final canvas = canvasContainer();
  canvas.dispatchEvent(keyboardEvent('keydown', keyCode, shiftKey: shiftKey));
  canvas.dispatchEvent(keyboardEvent('keyup', keyCode, shiftKey: shiftKey));

  return completer.future.timeout(
    const Duration(seconds: 3),
    onTimeout: () => fail('keyboardEvents never reached GestureState.ended'),
  )..whenComplete(sub.cancel);
}

void main() {
  patrolTest('ArrowRight pans the map (keyboard)', ($) async {
    final controller = await pumpMapTree($.tester, _mapApp);
    final before = _cameraBefore($.tester);

    final event = await _pressKey(controller, _arrowRight);

    final camera = event.cameraState;
    expect(
      camera.center.coordinates.lng,
      isNot(closeTo(before.center.lng, 0.0001)),
    );
    expect(camera.center.coordinates.lat, closeTo(before.center.lat, 0.0001));
    expect(camera.zoom, closeTo(before.zoom, 0.0001));
    expect(camera.bearing, closeTo(before.bearing, 0.0001));
    expect(camera.pitch, closeTo(before.pitch, 0.0001));
  });

  patrolTest('ArrowLeft pans the map (keyboard)', ($) async {
    final controller = await pumpMapTree($.tester, _mapApp);
    final before = _cameraBefore($.tester);

    final event = await _pressKey(controller, _arrowLeft);

    final camera = event.cameraState;
    expect(
      camera.center.coordinates.lng,
      isNot(closeTo(before.center.lng, 0.0001)),
    );
    expect(camera.center.coordinates.lat, closeTo(before.center.lat, 0.0001));
    expect(camera.zoom, closeTo(before.zoom, 0.0001));
    expect(camera.bearing, closeTo(before.bearing, 0.0001));
    expect(camera.pitch, closeTo(before.pitch, 0.0001));
  });

  patrolTest('ArrowUp pans the map (keyboard)', ($) async {
    final controller = await pumpMapTree($.tester, _mapApp);
    final before = _cameraBefore($.tester);

    final event = await _pressKey(controller, _arrowUp);

    final camera = event.cameraState;
    expect(camera.center.coordinates.lng, closeTo(before.center.lng, 0.0001));
    expect(
      camera.center.coordinates.lat,
      isNot(closeTo(before.center.lat, 0.0001)),
    );
    expect(camera.zoom, closeTo(before.zoom, 0.0001));
    expect(camera.bearing, closeTo(before.bearing, 0.0001));
    expect(camera.pitch, closeTo(before.pitch, 0.0001));
  });

  patrolTest('ArrowDown pans the map (keyboard)', ($) async {
    final controller = await pumpMapTree($.tester, _mapApp);
    final before = _cameraBefore($.tester);

    final event = await _pressKey(controller, _arrowDown);

    final camera = event.cameraState;
    expect(camera.center.coordinates.lng, closeTo(before.center.lng, 0.0001));
    expect(
      camera.center.coordinates.lat,
      isNot(closeTo(before.center.lat, 0.0001)),
    );
    expect(camera.zoom, closeTo(before.zoom, 0.0001));
    expect(camera.bearing, closeTo(before.bearing, 0.0001));
    expect(camera.pitch, closeTo(before.pitch, 0.0001));
  });

  patrolTest("'=' zooms in (keyboard)", ($) async {
    final controller = await pumpMapTree($.tester, _mapApp);
    final before = _cameraBefore($.tester);

    final event = await _pressKey(controller, _equals);

    final camera = event.cameraState;
    expect(camera.zoom, closeTo(before.zoom + 1, 0.0001));
    expect(camera.center.coordinates.lng, closeTo(before.center.lng, 0.0001));
    expect(camera.center.coordinates.lat, closeTo(before.center.lat, 0.0001));
    expect(camera.bearing, closeTo(before.bearing, 0.0001));
    expect(camera.pitch, closeTo(before.pitch, 0.0001));
  });

  patrolTest("'-' zooms out (keyboard)", ($) async {
    final controller = await pumpMapTree($.tester, _mapApp);
    final before = _cameraBefore($.tester);

    final event = await _pressKey(controller, _minus);

    final camera = event.cameraState;
    expect(camera.zoom, closeTo(before.zoom - 1, 0.0001));
    expect(camera.center.coordinates.lng, closeTo(before.center.lng, 0.0001));
    expect(camera.center.coordinates.lat, closeTo(before.center.lat, 0.0001));
    expect(camera.bearing, closeTo(before.bearing, 0.0001));
    expect(camera.pitch, closeTo(before.pitch, 0.0001));
  });

  patrolTest('Shift+ArrowRight rotates the map (keyboard)', ($) async {
    final controller = await pumpMapTree($.tester, _mapApp);
    final before = _cameraBefore($.tester);

    final event = await _pressKey(controller, _arrowRight, shiftKey: true);

    final camera = event.cameraState;
    expect(camera.bearing, closeTo(before.bearing + 15, 0.0001));
    expect(camera.center.coordinates.lng, closeTo(before.center.lng, 0.0001));
    expect(camera.center.coordinates.lat, closeTo(before.center.lat, 0.0001));
    expect(camera.zoom, closeTo(before.zoom, 0.0001));
    expect(camera.pitch, closeTo(before.pitch, 0.0001));
  });

  patrolTest('Shift+ArrowLeft rotates the map (keyboard)', ($) async {
    final controller = await pumpMapTree($.tester, _mapApp);
    final before = _cameraBefore($.tester);

    final event = await _pressKey(controller, _arrowLeft, shiftKey: true);

    final camera = event.cameraState;
    expect(camera.bearing, closeTo(before.bearing - 15, 0.0001));
    expect(camera.center.coordinates.lng, closeTo(before.center.lng, 0.0001));
    expect(camera.center.coordinates.lat, closeTo(before.center.lat, 0.0001));
    expect(camera.zoom, closeTo(before.zoom, 0.0001));
    expect(camera.pitch, closeTo(before.pitch, 0.0001));
  });

  patrolTest('Shift+ArrowUp pitches the map (keyboard)', ($) async {
    final controller = await pumpMapTree($.tester, _mapApp);
    final before = _cameraBefore($.tester);

    final event = await _pressKey(controller, _arrowUp, shiftKey: true);

    final camera = event.cameraState;
    expect(camera.pitch, closeTo(before.pitch + 10, 0.0001));
    expect(camera.center.coordinates.lng, closeTo(before.center.lng, 0.0001));
    expect(camera.center.coordinates.lat, closeTo(before.center.lat, 0.0001));
    expect(camera.zoom, closeTo(before.zoom, 0.0001));
    expect(camera.bearing, closeTo(before.bearing, 0.0001));
  });

  patrolTest('Shift+ArrowDown levels the pitch (keyboard)', ($) async {
    // Pitch down from a non-zero pitch: GL JS clamps pitch to >= 0, so
    // starting at 0 and pressing shift+down would be a no-op (nothing to
    // assert). Start pitched up instead, then confirm shift+down reduces it.
    final pitchedViewport = CameraViewportState(
      center: Point(coordinates: Position(0, 0)),
      zoom: 5,
      pitch: 20,
    );
    final controller = await pumpMapTree(
      $.tester,
      (onCreated) => MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: MapWebWidget(
                  viewport: pitchedViewport,
                  onMapCreated: onCreated,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final before = _cameraBefore($.tester);

    final event = await _pressKey(controller, _arrowDown, shiftKey: true);

    final camera = event.cameraState;
    expect(camera.pitch, closeTo(before.pitch - 10, 0.0001));
    expect(camera.center.coordinates.lng, closeTo(before.center.lng, 0.0001));
    expect(camera.center.coordinates.lat, closeTo(before.center.lat, 0.0001));
    expect(camera.zoom, closeTo(before.zoom, 0.0001));
    expect(camera.bearing, closeTo(before.bearing, 0.0001));
  });

  patrolTest('Alt/Ctrl/Meta-modified keys are ignored (keyboard)', ($) async {
    final controller = await pumpMapTree($.tester, _mapApp);
    final events = <MapKeyboardGestureContext>[];
    final sub = controller.gestures.keyboardEvents.listen(events.add);

    final canvas = canvasContainer();
    canvas.dispatchEvent(keyboardEvent('keydown', _arrowRight, altKey: true));
    canvas.dispatchEvent(keyboardEvent('keydown', _arrowRight, ctrlKey: true));
    canvas.dispatchEvent(keyboardEvent('keydown', _arrowRight, metaKey: true));
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await sub.cancel();

    expect(events, isEmpty);
  });
}
