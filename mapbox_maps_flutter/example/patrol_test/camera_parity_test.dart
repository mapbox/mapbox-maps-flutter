// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter_examples/platform.dart';
import 'package:turf/turf.dart' show Point, Position;
import 'patrol.dart';
import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

const _size = 400.0;
const _centre = _size / 2;

Future<MapboxMap> _pumpNorthUpMap(PatrolIntegrationTester $) async {
  final mapboxMap = await app.pumpMap(
    tester: $.tester,
    width: _size,
    height: _size,
    viewport: CameraViewportState(
      center: Point(coordinates: Position(0, 0)),
      zoom: 4,
      bearing: 0,
      pitch: 0,
    ),
  );
  await $.tester.pumpAndSettle();
  return mapboxMap;
}

Future<CameraState> _settledCameraState(
  PatrolIntegrationTester $,
  MapboxMap mapboxMap,
) async {
  await Future<void>.delayed(const Duration(milliseconds: 500));
  await $.tester.pumpAndSettle();
  return mapboxMap.getCameraState();
}

double _normalizedBearing(double bearing) => (bearing % 360 + 360) % 360;

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  // `moveBy` and `rotateBy` exist on Android and web only.
  final skip = isIOS;

  patrolTest('moveBy moves the map content by the offset', skip: skip, (
    $,
  ) async {
    final mapboxMap = await _pumpNorthUpMap($);

    await mapboxMap.moveBy(
      ScreenCoordinate(x: 100, y: 100),
      MapAnimationOptions(duration: 0),
    );

    // Content moves right and down, so the camera looks further west and north.
    final state = await _settledCameraState($, mapboxMap);
    expect(state.center.coordinates.lng, lessThan(-1));
    expect(state.center.coordinates.lat, greaterThan(1));
  });

  patrolTest(
    'rotateBy turns by the screen angle around the centre',
    skip: skip,
    ($) async {
      final mapboxMap = await _pumpNorthUpMap($);

      // From the right of the centre to below it: a quarter turn clockwise on
      // screen, which lowers the bearing by 90 degrees.
      await mapboxMap.rotateBy(
        ScreenCoordinate(x: _centre + 250, y: _centre),
        ScreenCoordinate(x: _centre, y: _centre + 250),
        MapAnimationOptions(duration: 0),
      );

      final state = await _settledCameraState($, mapboxMap);
      expect(_normalizedBearing(state.bearing), closeTo(270, 0.5));
    },
  );

  patrolTest(
    'rotateBy measures the angle around the centre for a far point',
    skip: skip,
    ($) async {
      final mapboxMap = await _pumpNorthUpMap($);

      // From the left of the centre to below it: a quarter turn counterclockwise
      // on screen, which raises the bearing by 90 degrees.
      await mapboxMap.rotateBy(
        ScreenCoordinate(x: _centre - 250, y: _centre),
        ScreenCoordinate(x: _centre, y: _centre + 250),
        MapAnimationOptions(duration: 0),
      );

      final state = await _settledCameraState($, mapboxMap);
      expect(_normalizedBearing(state.bearing), closeTo(90, 0.5));
    },
  );

  patrolTest(
    'rotateBy moves the pivot away from a point near the centre',
    skip: skip,
    ($) async {
      final mapboxMap = await _pumpNorthUpMap($);

      // Around the centre this is a quarter turn. The first point is closer than
      // 200 physical pixels, so the pivot moves and the turn is smaller.
      await mapboxMap.rotateBy(
        ScreenCoordinate(x: _centre - 50, y: _centre),
        ScreenCoordinate(x: _centre, y: _centre + 50),
        MapAnimationOptions(duration: 0),
      );

      final state = await _settledCameraState($, mapboxMap);
      final bearing = _normalizedBearing(state.bearing);
      expect(bearing, greaterThan(1));
      expect(bearing, lessThan(89));
    },
  );
}
