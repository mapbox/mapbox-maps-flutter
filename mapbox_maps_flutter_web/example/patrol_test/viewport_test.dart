import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:turf/turf.dart' show Point, Polygon, Position;
import 'patrol.dart';

import 'test_utils.dart';

Widget _mapApp(ViewportState? viewport, PlatformMapCreatedCallback onCreated) =>
    MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: MapWebWidget(viewport: viewport, onMapCreated: onCreated),
            ),
          ],
        ),
      ),
    );

void main() {
  patrolTest('CameraViewportState test', ($) async {
    final cameraViewport = CameraViewportState(
      center: Point(coordinates: Position(5, 6)),
      zoom: 16.35,
      bearing: 8,
      pitch: 42,
    );
    await pumpMapTree(
      $.tester,
      (onCreated) => _mapApp(cameraViewport, onCreated),
    );
    final map = currentMap($.tester)!;
    final center = map.getCenter();

    expect(center.lng, moreOrLessEquals(5, epsilon: 0.01));
    expect(center.lat, moreOrLessEquals(6, epsilon: 0.01));
    expect(map.getZoom(), moreOrLessEquals(16.35, epsilon: 0.01));
    expect(map.getBearing(), moreOrLessEquals(8, epsilon: 0.01));
    expect(map.getPitch(), moreOrLessEquals(42, epsilon: 0.01));
  });

  patrolTest('OverviewViewportState test', ($) async {
    final overviewViewport = OverviewViewportState(
      geometry: Polygon.fromPoints(
        points: [
          [
            Point(coordinates: Position(0, 0)),
            Point(coordinates: Position(0, 10)),
            Point(coordinates: Position(10, 10)),
            Point(coordinates: Position(10, 0)),
            Point(coordinates: Position(0, 0)),
          ],
        ],
      ),
      bearing: 30.0,
      pitch: 45.0,
    );
    await pumpMapTree(
      $.tester,
      (onCreated) => _mapApp(overviewViewport, onCreated),
    );
    final map = currentMap($.tester)!;
    final center = map.getCenter();

    expect(center.lng, moreOrLessEquals(5, epsilon: 0.5));
    expect(center.lat, moreOrLessEquals(5, epsilon: 0.5));
    expect(map.getBearing(), moreOrLessEquals(30, epsilon: 0.01));
    expect(map.getPitch(), moreOrLessEquals(45, epsilon: 0.01));
  });

  patrolTest('IdleViewportState test', ($) async {
    final tester = $.tester;
    final camera = CameraViewportState(
      center: Point(coordinates: Position(5, 6)),
      zoom: 10,
    );
    await pumpMapTree(tester, (onCreated) => _mapApp(camera, onCreated));
    final map = currentMap(tester)!;
    expect(map.getZoom(), moreOrLessEquals(10, epsilon: 0.01));

    // Idle is a no-op: switching to it must not move the camera, only
    // cancel any in-flight animation. Rebuilding the same widget position
    // (no new key) updates the existing MapWebWidget rather than
    // remounting it, so onMapCreated intentionally isn't wired again here.
    await tester.pumpWidget(_mapApp(IdleViewportState(), (_) {}));
    await tester.pumpAndSettle();

    expect(map.getZoom(), moreOrLessEquals(10, epsilon: 0.01));
    expect(map.getCenter().lng, moreOrLessEquals(5, epsilon: 0.01));
    expect(map.getCenter().lat, moreOrLessEquals(6, epsilon: 0.01));
  });
}
