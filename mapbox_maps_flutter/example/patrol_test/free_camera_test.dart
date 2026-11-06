import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'empty_map_widget.dart' as app;
import 'patrol.dart';

const _accessToken = String.fromEnvironment('ACCESS_TOKEN');

/// Tolerance for a pose that reads back on the mercator projection.
const _mercatorTolerance = 1e-9;

/// Tolerance for the ground point that the camera looks at on globe.
const _globeGroundTolerance = 1e-7;

/// Relative tolerance for the camera distance on globe.
///
/// On globe at low zoom, the map keeps the orientation and the point that
/// the camera looks at, but places the camera closer to that point.
const _globeDistanceTolerance = 0.5;

final _helsinki = Point(coordinates: Position(24.9384, 60.1699));

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(_accessToken));

  Future<MapboxMap> pumpMap(
    WidgetTester tester, {
    required StyleProjectionName projection,
    required double zoom,
  }) async {
    // A style with only a background, so the test needs no network and the
    // projection is set the same way on every platform.
    final mapboxMap = await app.pumpMap(
      tester: tester,
      viewport: CameraViewportState(center: _helsinki, zoom: zoom),
      styleJson: jsonEncode({
        'version': 8,
        'projection': {'name': projection.name},
        'sources': <String, Object>{},
        'layers': [
          {'id': 'background', 'type': 'background'},
        ],
      }),
    );
    await tester.pumpAndSettle();
    return mapboxMap;
  }

  void expectPosition(
    FreeCameraPosition? actual,
    FreeCameraPosition expected, {
    required double tolerance,
  }) {
    expect(actual, isNotNull);
    expect(actual!.x, closeTo(expected.x, tolerance));
    expect(actual.y, closeTo(expected.y, tolerance));
    expect(actual.z, closeTo(expected.z, tolerance));
  }

  void expectOrientation(
    FreeCameraOrientation? actual,
    FreeCameraOrientation expected, {
    required double tolerance,
  }) {
    expect(actual, isNotNull);
    // q and -q are the same rotation.
    final sign =
        actual!.x * expected.x +
                actual.y * expected.y +
                actual.z * expected.z +
                actual.w * expected.w <
            0
        ? -1.0
        : 1.0;
    expect(sign * actual.x, closeTo(expected.x, tolerance));
    expect(sign * actual.y, closeTo(expected.y, tolerance));
    expect(sign * actual.z, closeTo(expected.z, tolerance));
    expect(sign * actual.w, closeTo(expected.w, tolerance));
  }

  /// The point at altitude 0 that a camera at [position] with
  /// [orientation] looks at.
  FreeCameraPosition groundTarget(
    FreeCameraPosition position,
    FreeCameraOrientation orientation,
  ) {
    // Rotate the default view direction (0, 0, -1) by the orientation.
    final tx = 2 * -orientation.y;
    final ty = 2 * orientation.x;
    final fx = orientation.w * tx - orientation.z * ty;
    final fy = orientation.w * ty + orientation.z * tx;
    final fz = -1 + orientation.x * ty - orientation.y * tx;
    final t = -position.z / fz;
    return FreeCameraPosition(
      x: position.x + t * fx,
      y: position.y + t * fy,
      z: 0,
    );
  }

  patrolTest('free camera pose reads back on mercator', ($) async {
    final mapboxMap = await pumpMap(
      $.tester,
      projection: StyleProjectionName.mercator,
      zoom: 14,
    );

    final camera = const FreeCameraOptions()
        .withLocation(
          Point(coordinates: Position(24.93, 60.16)),
          altitude: 2000,
        )
        .withPitchBearing(50, 30);
    await mapboxMap.setFreeCameraOptions(camera);

    final actual = await mapboxMap.getFreeCameraOptions();
    expectPosition(
      actual.position,
      camera.position!,
      tolerance: _mercatorTolerance,
    );
    expectOrientation(
      actual.orientation,
      camera.orientation!,
      tolerance: _mercatorTolerance,
    );
  });

  patrolTest('free camera pose reads back on globe', ($) async {
    final mapboxMap = await pumpMap(
      $.tester,
      projection: StyleProjectionName.globe,
      zoom: 3,
    );

    final camera = const FreeCameraOptions()
        .withLocation(Point(coordinates: Position(20, 55)), altitude: 3000000)
        .withPitchBearing(30, 20);
    await mapboxMap.setFreeCameraOptions(camera);

    final actual = await mapboxMap.getFreeCameraOptions();
    expectOrientation(
      actual.orientation,
      camera.orientation!,
      tolerance: _mercatorTolerance,
    );
    expectPosition(
      groundTarget(actual.position!, actual.orientation!),
      groundTarget(camera.position!, camera.orientation!),
      tolerance: _globeGroundTolerance,
    );
    expect(
      actual.position!.z,
      closeTo(camera.position!.z, camera.position!.z * _globeDistanceTolerance),
    );
  });

  patrolTest('lookingAt centers the camera on the target', ($) async {
    final mapboxMap = await pumpMap(
      $.tester,
      projection: StyleProjectionName.mercator,
      zoom: 14,
    );
    final target = Point(coordinates: Position(24.95, 60.17));

    // 0.009 degrees of latitude south of the target is 1000.75 m away on
    // the ground. From 1000 m up, the camera pitch is atan(1000.75 / 1000).
    await mapboxMap.setFreeCameraOptions(
      const FreeCameraOptions()
          .withLocation(
            Point(coordinates: Position(24.95, 60.161)),
            altitude: 1000,
          )
          .lookingAt(target),
    );

    final state = await mapboxMap.getCameraState();
    expect(state.center.coordinates.lng, closeTo(24.95, 1e-6));
    expect(state.center.coordinates.lat, closeTo(60.17, 1e-6));
    expect(state.pitch, closeTo(45.02, 0.05));
    expect(state.bearing, closeTo(0, 1e-6));

    // The same view from twice the distance is one zoom level lower.
    await mapboxMap.setFreeCameraOptions(
      const FreeCameraOptions()
          .withLocation(
            Point(coordinates: Position(24.95, 60.152)),
            altitude: 2000,
          )
          .lookingAt(target),
    );

    final farState = await mapboxMap.getCameraState();
    expect(farState.zoom, closeTo(state.zoom - 1, 1e-3));
    expect(farState.pitch, closeTo(state.pitch, 0.05));
  });

  patrolTest('orientation alone keeps the camera position', ($) async {
    final mapboxMap = await pumpMap(
      $.tester,
      projection: StyleProjectionName.mercator,
      zoom: 14,
    );
    final before = await mapboxMap.getFreeCameraOptions();

    final orientation = const FreeCameraOptions()
        .withPitchBearing(40, 90)
        .orientation!;
    await mapboxMap.setFreeCameraOptions(
      FreeCameraOptions(orientation: orientation),
    );

    final after = await mapboxMap.getFreeCameraOptions();
    expectPosition(
      after.position,
      before.position!,
      tolerance: _mercatorTolerance,
    );
    expectOrientation(
      after.orientation,
      orientation,
      tolerance: _mercatorTolerance,
    );
  });
}
