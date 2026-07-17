import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class Events {
  var onMapIdle = Completer();
  var onMapLoaded = Completer();
  var onStyleLoaded = Completer();
  var onStyleDataLoaded = Completer();
  var onSourceDataLoaded = Completer();
  var onCameraChanged = Completer();
  List<MapContentGestureContext> mapInteractions = [];
  var sourceDataIDs = [""];

  void resetOnMapLoaded() => onMapLoaded = Completer();
  void resetOnStyleLoaded() => onStyleLoaded = Completer();
  void resetOnStyleDataLoaded() => onStyleDataLoaded = Completer();
  void resetOnSourceDataLoaded() => {
    sourceDataIDs.clear(),
    onSourceDataLoaded = Completer(),
  };
  void resetOnCameraChanged() => onCameraChanged = Completer();
  void resetOnMapIdle() => onMapIdle = Completer();
  void resetMapInteractions() => mapInteractions.clear();
}

var events = Events();

// Named pumpMap (not `main`) because Dart forbids required named parameters
// on a `main` entrypoint.
Future<MapboxMap> pumpMap({
  // Patrol recommends pumping the app through the test binding instead of
  // calling runApp() (https://patrol.leancode.co/documentation): pumped trees
  // are tracked by the binding, so build/layout exceptions are attributed to
  // the test. Pass `$.tester` from the patrolTest callback.
  required WidgetTester tester,
  double? width,
  double? height,
  ViewportState? viewport,
  Alignment alignment = Alignment.topLeft,
  String styleUri = MapboxStyles.STANDARD,
  String? styleJson,
  bool isOpaque = true,
  bool textureView = true,
  Color? background,
}) async {
  final mapboxMap = await _pumpMapApp(
    tester: tester,
    width: width,
    height: height,
    viewport: viewport,
    alignment: alignment,
    styleUri: styleUri,
    styleJson: styleJson,
    isOpaque: isOpaque,
    textureView: textureView,
    background: background,
    waitForLoad: true,
  );
  return mapboxMap!;
}

/// Pumps the map app over a [MapWidget] already mounted by [pumpMap], with
/// new properties (e.g. a different [viewport]).
///
/// Because every mounted MapWidget shares the same ValueKey, Flutter updates
/// the existing widget in place instead of creating a new platform map — so
/// no onMapCreated/onStyleLoaded fires and there is nothing to wait for
/// (awaiting them, as [pumpMap] does, would time out).
Future<void> pumpMapUpdate({
  required WidgetTester tester,
  double? width,
  double? height,
  ViewportState? viewport,
  Alignment alignment = Alignment.topLeft,
  String styleUri = MapboxStyles.STANDARD,
  String? styleJson,
  bool isOpaque = true,
  bool textureView = true,
  Color? background,
}) => _pumpMapApp(
  tester: tester,
  width: width,
  height: height,
  viewport: viewport,
  alignment: alignment,
  styleUri: styleUri,
  styleJson: styleJson,
  isOpaque: isOpaque,
  textureView: textureView,
  background: background,
  waitForLoad: false,
);

Future<MapboxMap?> _pumpMapApp({
  required WidgetTester tester,
  double? width,
  double? height,
  ViewportState? viewport,
  Alignment alignment = Alignment.topLeft,
  String styleUri = MapboxStyles.STANDARD,
  // Raw style JSON applied in onMapCreated instead of [styleUri], so no
  // default style flashes before it loads.
  String? styleJson,
  bool isOpaque = true,
  bool textureView = true,
  // Solid backdrop placed behind the map, useful for asserting on
  // transparency of the map surface itself.
  Color? background,
  required bool waitForLoad,
}) async {
  final completer = Completer<MapboxMap>();

  events = Events();

  // Patrol runs on a LiveTestWidgetsFlutterBinding, which (unlike `flutter
  // test`) does NOT reset the widget tree between tests. Without this, the
  // MapWidget created below stays mounted into the *next* test whenever that
  // test doesn't itself call `pumpMap()` (e.g. the annotation-event or interaction
  // unit tests). On CI's headless software-WebGL runner a lingering,
  // continuously-composited map stalls Patrol's between-test handoff and the
  // whole run freezes. Tearing the app back down to an empty widget disposes
  // the platform map (see mapbox_maps_flutter_web map_widget.dart dispose ->
  // GL JS `map.remove()`), so every test starts from a clean slate.
  addTearDown(() async {
    await runEmpty(tester);
    // Wait for the frame that unmounts the MapWidget to actually render — a
    // bare delay can elapse without any frame being built when the main
    // thread is busy (e.g. CI's headless software-WebGL renderer), leaving a
    // live map for the next test to trip over. dispose() must have run (on
    // web it calls GL JS `map.remove()`) before the test is marked done.
    await WidgetsBinding.instance.endOfFrame.timeout(
      const Duration(seconds: 5),
      onTimeout: () {},
    );
    await Future<void>.delayed(const Duration(milliseconds: 100));
  });

  final mapWidget = MapWidget(
    key: const ValueKey("mapWidget"),
    viewport: viewport,
    styleUri: styleJson == null ? styleUri : '',
    isOpaque: isOpaque,
    textureView: textureView,
    onMapCreated: (MapboxMap mapboxMap) async {
      if (styleJson != null) {
        await mapboxMap.style.setStyleJSON(styleJson);
      }
      completer.complete(mapboxMap);
    },
    onMapLoadedListener: (MapLoadedEventData data) {
      if (!events.onMapLoaded.isCompleted) {
        events.onMapLoaded.complete();
      }
    },
    onStyleLoadedListener: (StyleLoadedEventData data) {
      if (!events.onStyleLoaded.isCompleted) {
        events.onStyleLoaded.complete();
      }
    },
    onStyleDataLoadedListener: (StyleDataLoadedEventData data) {
      if (!events.onStyleDataLoaded.isCompleted) {
        events.onStyleDataLoaded.complete();
      }
    },
    onSourceDataLoadedListener: (SourceDataLoadedEventData data) {
      final dataID = data.dataId;
      if (dataID != null) {
        events.sourceDataIDs.add(dataID);
      }
      if (!events.onSourceDataLoaded.isCompleted) {
        events.onSourceDataLoaded.complete();
      }
    },
    onCameraChangeListener: (CameraChangedEventData data) {
      if (!events.onCameraChanged.isCompleted) {
        events.onCameraChanged.complete();
      }
    },
    onMapIdleListener: (MapIdleEventData data) {
      if (!events.onMapIdle.isCompleted) {
        events.onMapIdle.complete();
      }
    },
  );

  await tester.pumpWidget(
    MaterialApp(
      home: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          height: height,
          child: background == null
              ? mapWidget
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(color: background),
                    mapWidget,
                  ],
                ),
        ),
      ),
    ),
  );

  if (!waitForLoad) {
    return null;
  }

  // Pump while waiting (see waitForEvent) and bound the wait so a map that
  // never finishes creating/loading its style fails the individual test with
  // a clear message instead of hanging the whole suite until the CI job
  // timeout.
  final results = await waitForEvent(
    tester,
    Future.wait([completer.future, events.onStyleLoaded.future]),
    description: () =>
        'app.pumpMap() timed out waiting for the map to load '
        '(onMapCreated=${completer.isCompleted}, '
        'onStyleLoaded=${events.onStyleLoaded.isCompleted})',
  );
  return results.first as MapboxMap;
}

Future<void> runEmpty(WidgetTester tester) =>
    tester.pumpWidget(const MaterialApp());

/// Awaits [future] while pumping frames.
///
/// Use this instead of directly awaiting a map-event future ([Events]). On
/// mobile the platform view is composited by Flutter frames; a widget tree
/// pumped via `tester.pumpWidget` schedules no frames while the test sits on
/// a bare `await`, so the map is never re-drawn and draw-dependent events
/// (MapLoaded, MapIdle) never fire — the await hangs until the test times
/// out. Pumping while waiting keeps the map rendering.
Future<T> waitForEvent<T>(
  WidgetTester tester,
  Future<T> future, {
  Duration timeout = const Duration(seconds: 30),
  // Evaluated lazily so the message can report state at timeout time.
  String Function()? description,
}) async {
  var done = false;
  late T result;
  Object? error;
  StackTrace? stackTrace;
  unawaited(
    future.then(
      (value) {
        result = value;
        done = true;
      },
      onError: (Object e, StackTrace s) {
        error = e;
        stackTrace = s;
        done = true;
      },
    ),
  );
  final deadline = DateTime.now().add(timeout);
  while (!done) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException(
        description?.call() ?? 'waitForEvent timed out after $timeout',
      );
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
  if (error != null) {
    Error.throwWithStackTrace(error!, stackTrace!);
  }
  return result;
}

extension CompleterExpect<T> on Completer<T> {
  void ensureCompletedOnce([FutureOr<T>? value, String? description]) {
    if (completeOnce(value)) return;
    fail(description ?? "Completer was already completed");
  }

  bool completeOnce([FutureOr<T>? value]) {
    if (isCompleted) return false;

    complete(value);
    return true;
  }

  void completeWhen(bool condition, [String? description, FutureOr<T>? value]) {
    if (isCompleted) return;
    if (condition) {
      complete(value);
    } else {
      completeError(
        description ?? 'Completer completed before condition was met',
      );
    }
  }
}
