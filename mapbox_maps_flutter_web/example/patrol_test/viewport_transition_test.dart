import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:turf/turf.dart' show Point, Polygon, Position;
import 'patrol.dart';

import 'test_utils.dart';

Widget _mapApp(
  ViewportState viewport, {
  ViewportTransition? transition,
  void Function(bool)? completion,
  PlatformMapCreatedCallback? onCreated,
}) => MaterialApp(
  home: Scaffold(
    body: Stack(
      children: [
        Positioned.fill(
          child: MapWebWidget(
            styleUri: 'mapbox://styles/mapbox/standard',
            viewport: viewport,
            viewportTransition: transition,
            viewportTransitionCompletion: completion,
            onMapCreated: onCreated ?? (_) {},
          ),
        ),
      ],
    ),
  ),
);

CameraViewportState _camera(double lng, double lat, double zoom) =>
    CameraViewportState(
      center: Point(coordinates: Position(lng, lat)),
      zoom: zoom,
    );

/// Starts [transition] to [viewport] and returns the completion future.
///
/// The same widget position updates the existing map, so the transition
/// runs from the current camera.
Future<bool> _startTransition(
  WidgetTester tester,
  ViewportState viewport,
  ViewportTransition transition,
) async {
  final completer = Completer<bool>();
  await tester.pumpWidget(
    _mapApp(viewport, transition: transition, completion: completer.complete),
  );
  return completer.future.timeout(const Duration(seconds: 10));
}

Future<Duration> _timeTransition(
  WidgetTester tester,
  ViewportState viewport,
  ViewportTransition transition,
) async {
  final stopwatch = Stopwatch()..start();
  await _startTransition(tester, viewport, transition);
  return stopwatch.elapsed;
}

/// Returns the value at `t = 0.5` of the easing function that GL JS runs
/// for a [curve] transition from [start] to [target].
///
/// GL JS keeps the easing of the running animation in `_easeOptions`. The
/// test reads it there, because the camera position at a given time depends
/// on the frame rate of the test runner.
Future<double> _easingAtHalf(
  WidgetTester tester,
  CameraViewportState start,
  ViewportState target,
  Cubic curve,
) async {
  await tester.pumpWidget(_mapApp(start));
  await tester.pumpAndSettle();
  final completer = Completer<bool>();
  await tester.pumpWidget(
    _mapApp(
      target,
      transition: EasingViewportTransition(
        curve: curve,
        duration: const Duration(seconds: 2),
      ),
      completion: completer.complete,
    ),
  );
  final map = currentMap(tester)!;
  expect(map.isEasing(), isTrue);
  final options = (map as JSObject).getProperty<JSObject>('_easeOptions'.toJS);
  final easing = options.getProperty<JSFunction>('easing'.toJS);
  final value =
      (easing.callAsFunction(null, 0.5.toJS) as JSNumber).toDartDouble;
  await completer.future.timeout(const Duration(seconds: 10));
  return value;
}

OverviewViewportState _overview(
  double lng,
  double lat,
  double size, {
  Duration animationDuration = const Duration(seconds: 1),
}) => OverviewViewportState(
  animationDuration: animationDuration,
  geometry: Polygon.fromPoints(
    points: [
      [
        Point(coordinates: Position(lng, lat)),
        Point(coordinates: Position(lng, lat + size)),
        Point(coordinates: Position(lng + size, lat + size)),
        Point(coordinates: Position(lng + size, lat)),
        Point(coordinates: Position(lng, lat)),
      ],
    ],
  ),
);

/// Checks that the visible bounds of the map contain the [size] square
/// at [lng], [lat].
Future<void> _expectGeometryVisible(
  MapboxMapPlatformInterface platformMap,
  double lng,
  double lat,
  double size,
) async {
  final camera = await platformMap.getCameraState();
  final bounds = await platformMap.coordinateBoundsForCamera(
    CameraOptions(
      center: camera.center,
      zoom: camera.zoom,
      bearing: camera.bearing,
      pitch: camera.pitch,
    ),
  );
  final sw = bounds.southwest.coordinates;
  final ne = bounds.northeast.coordinates;
  const epsilon = 0.01;
  expect(sw.lng, lessThanOrEqualTo(lng + epsilon));
  expect(sw.lat, lessThanOrEqualTo(lat + epsilon));
  expect(ne.lng, greaterThanOrEqualTo(lng + size - epsilon));
  expect(ne.lat, greaterThanOrEqualTo(lat + size - epsilon));
}

void main() {
  patrolTest('default transition for a small move is short', ($) async {
    final tester = $.tester;
    await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(0, 0, 10), onCreated: onCreated),
    );

    final elapsed = await _timeTransition(
      tester,
      _camera(0.01, 0.01, 10.5),
      const DefaultViewportTransition(),
    );

    expect(elapsed.inMilliseconds, greaterThan(100));
    expect(elapsed.inMilliseconds, lessThan(2500));
    expect(
      currentMap(tester)!.getZoom(),
      moreOrLessEquals(10.5, epsilon: 0.01),
    );
  });

  patrolTest('default transition across the antimeridian is short', ($) async {
    final tester = $.tester;
    await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(179.5, 0, 8), onCreated: onCreated),
    );

    final elapsed = await _timeTransition(
      tester,
      _camera(-179.5, 0, 8.5),
      const DefaultViewportTransition(),
    );

    expect(elapsed.inMilliseconds, lessThan(2500));
  });

  patrolTest('default transition uses maxDuration as a cap', ($) async {
    final tester = $.tester;
    await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(0, 0, 3), onCreated: onCreated),
    );

    final elapsed = await _timeTransition(
      tester,
      // The target keeps the latitude. A latitude change makes the zoom that
      // GL JS reports depend on frame timing.
      _camera(100, 0, 12),
      const DefaultViewportTransition(maxDuration: Duration(milliseconds: 500)),
    );

    expect(elapsed.inMilliseconds, greaterThan(200));
    expect(elapsed.inMilliseconds, lessThan(2000));
    expect(currentMap(tester)!.getZoom(), moreOrLessEquals(12, epsilon: 0.05));
  });

  patrolTest('easing transition applies the curve', ($) async {
    final tester = $.tester;
    await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(-1, 0, 2), onCreated: onCreated),
    );

    final value = await _easingAtHalf(
      tester,
      _camera(1, 0, 2),
      _camera(1, 0, 6),
      Curves.easeIn,
    );

    expect(value, moreOrLessEquals(Curves.easeIn.transform(0.5)));
  });

  patrolTest('camera viewport anchor keeps its coordinate', ($) async {
    final tester = $.tester;
    final platformMap = await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(10, 20, 4), onCreated: onCreated),
    );
    const anchor = Offset(100, 100);
    final pixel = ScreenCoordinate(x: anchor.dx, y: anchor.dy);
    final before = await platformMap.coordinateForPixel(pixel);

    await _startTransition(
      tester,
      CameraViewportState(zoom: 6, anchor: anchor),
      EasingViewportTransition(duration: const Duration(milliseconds: 300)),
    );

    final after = await platformMap.coordinateForPixel(pixel);
    expect(currentMap(tester)!.getZoom(), moreOrLessEquals(6, epsilon: 0.01));
    expect(
      after.coordinates.lng,
      moreOrLessEquals(before.coordinates.lng.toDouble(), epsilon: 0.01),
    );
    expect(
      after.coordinates.lat,
      moreOrLessEquals(before.coordinates.lat.toDouble(), epsilon: 0.01),
    );
  });

  patrolTest('setCamera anchor keeps its coordinate', ($) async {
    final tester = $.tester;
    final platformMap = await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(10, 20, 4), onCreated: onCreated),
    );
    final pixel = ScreenCoordinate(x: 100, y: 100);
    final before = await platformMap.coordinateForPixel(pixel);

    await platformMap.setCamera(CameraOptions(zoom: 6, anchor: pixel));

    final after = await platformMap.coordinateForPixel(pixel);
    expect(currentMap(tester)!.getZoom(), moreOrLessEquals(6, epsilon: 0.01));
    expect(
      after.coordinates.lng,
      moreOrLessEquals(before.coordinates.lng.toDouble(), epsilon: 0.01),
    );
    expect(
      after.coordinates.lat,
      moreOrLessEquals(before.coordinates.lat.toDouble(), epsilon: 0.01),
    );
  });

  patrolTest('setCamera center takes precedence over the anchor', ($) async {
    final tester = $.tester;
    final platformMap = await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(10, 20, 4), onCreated: onCreated),
    );

    await platformMap.setCamera(
      CameraOptions(
        center: Point(coordinates: Position(30, 40)),
        zoom: 6,
        anchor: ScreenCoordinate(x: 100, y: 100),
      ),
    );

    final center = currentMap(tester)!.getCenter();
    expect(center.lng, moreOrLessEquals(30, epsilon: 0.001));
    expect(center.lat, moreOrLessEquals(40, epsilon: 0.001));
  });

  patrolTest('camera viewport center takes precedence over the anchor', (
    $,
  ) async {
    final tester = $.tester;
    await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(10, 20, 4), onCreated: onCreated),
    );

    await _startTransition(
      tester,
      CameraViewportState(
        center: Point(coordinates: Position(30, 40)),
        zoom: 6,
        anchor: const Offset(100, 100),
      ),
      EasingViewportTransition(duration: const Duration(milliseconds: 300)),
    );

    final center = currentMap(tester)!.getCenter();
    expect(center.lng, moreOrLessEquals(30, epsilon: 0.001));
    expect(center.lat, moreOrLessEquals(40, epsilon: 0.001));
  });

  patrolTest('overview easing transition applies the curve', ($) async {
    final tester = $.tester;
    await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(-20, 0, 2), onCreated: onCreated),
    );

    final value = await _easingAtHalf(
      tester,
      _camera(20, 0, 2),
      _overview(20, 0, 1),
      Curves.easeIn,
    );

    expect(value, moreOrLessEquals(Curves.easeIn.transform(0.5)));
  });

  patrolTest('overview default transition to a near geometry is short', (
    $,
  ) async {
    final tester = $.tester;
    await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(0.05, 0.05, 10), onCreated: onCreated),
    );

    final elapsed = await _timeTransition(
      tester,
      _overview(0, 0, 0.1),
      const DefaultViewportTransition(),
    );

    expect(elapsed.inMilliseconds, lessThan(2500));
  });

  patrolTest('default transition that does not move completes', ($) async {
    final tester = $.tester;
    await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(0, 0, 3), onCreated: onCreated),
    );

    final finished = await _startTransition(
      tester,
      const CameraViewportState(zoom: 3),
      const DefaultViewportTransition(),
    );

    expect(finished, isTrue);
  });

  patrolTest('overview transition that interrupts an animation waits for '
      'its own end', ($) async {
    final tester = $.tester;
    final platformMap = await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(0, 0, 2), onCreated: onCreated),
    );
    unawaited(
      _startTransition(
        tester,
        _camera(60, 0, 2),
        EasingViewportTransition(duration: const Duration(seconds: 5)),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final finished = await _startTransition(
      tester,
      _overview(10, 10, 2),
      EasingViewportTransition(duration: const Duration(seconds: 1)),
    );

    expect(finished, isTrue);
    await _expectGeometryVisible(platformMap, 10, 10, 2);
  });

  patrolTest('overview immediate transition ignores the animation duration', (
    $,
  ) async {
    final tester = $.tester;
    await pumpMapTree(
      tester,
      (onCreated) => _mapApp(_camera(0, 0, 2), onCreated: onCreated),
    );

    final elapsed = await _timeTransition(
      tester,
      _overview(40, 40, 2, animationDuration: const Duration(seconds: 5)),
      const ImmediateViewportTransition(),
    );

    expect(elapsed.inMilliseconds, lessThan(2500));
  });

  for (final (name, transition) in [
    (
      'easing',
      EasingViewportTransition(duration: const Duration(milliseconds: 500)),
    ),
    ('default', const DefaultViewportTransition()),
    ('fly', const FlyViewportTransition()),
    ('immediate', const ImmediateViewportTransition()),
  ]) {
    patrolTest('overview $name transition shows the geometry', ($) async {
      final tester = $.tester;
      final platformMap = await pumpMapTree(
        tester,
        (onCreated) => _mapApp(_camera(0, 0, 2), onCreated: onCreated),
      );

      await _startTransition(tester, _overview(10, 10, 2), transition);

      await _expectGeometryVisible(platformMap, 10, 10, 2);
    });
  }
}
