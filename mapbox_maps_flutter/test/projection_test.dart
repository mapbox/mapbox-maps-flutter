import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// Expected values match the native SDK results checked by the Patrol suite in
/// `packages/mapbox_maps_flutter/example/patrol_test/projection_test.dart`.
void main() {
  const projection = Projection();

  group('mobile parity', () {
    test('getMetersPerPixelAtLatitude', () async {
      final meters = await projection.getMetersPerPixelAtLatitude(1, 16);
      expect(meters.round(), 1);
      expect(meters, closeTo(1.1928, 1e-3));
    });

    test('projectedMetersForCoordinate', () async {
      final meters = await projection.projectedMetersForCoordinate(
        Point(coordinates: Position(1, 60)),
      );
      expect(meters.easting.floor(), 111195);
      expect(meters.northing.floor(), 8390350);
    });

    test('coordinateForProjectedMeters', () async {
      final point = await projection.coordinateForProjectedMeters(
        ProjectedMeters(northing: 100000, easting: 100000),
      );
      expect(point.coordinates.lng.floor(), 0);
      expect(point.coordinates.lat.floor(), 0);
      expect(point.coordinates.lng, closeTo(0.89932, 1e-5));
      expect(point.coordinates.lat, closeTo(0.89929, 1e-5));
    });

    test('unproject', () async {
      final point = await projection.unproject(
        MercatorCoordinate(x: 1, y: 1),
        16,
      );
      expect(point.coordinates.lng.floor(), -180);
      expect(point.coordinates.lat.floor(), 85);
      expect(point.coordinates.lng, closeTo(-179.95605, 1e-5));
      expect(point.coordinates.lat, closeTo(85.04734, 1e-5));
    });

    test('project', () async {
      final coordinate = await projection.project(
        Point(coordinates: Position(1, 60)),
        16,
      );
      expect(coordinate.x.floor(), 4118);
      expect(coordinate.y.floor(), 2378);
    });
  });

  group('input clamps', () {
    test('latitude is clamped to the Mercator limit', () async {
      final pole = await projection.projectedMetersForCoordinate(
        Point(coordinates: Position(0, 90)),
      );
      final limit = await projection.projectedMetersForCoordinate(
        Point(coordinates: Position(0, 85.051128779806604)),
      );
      expect(pole.northing, limit.northing);

      final southPole = await projection.projectedMetersForCoordinate(
        Point(coordinates: Position(0, -90)),
      );
      expect(southPole.northing, -limit.northing);

      final projectedPole = await projection.project(
        Point(coordinates: Position(0, 90)),
        16,
      );
      final projectedLimit = await projection.project(
        Point(coordinates: Position(0, 85.051128779806604)),
        16,
      );
      expect(projectedPole.y, projectedLimit.y);
    });

    test('longitude is clamped to 180', () async {
      final wrapped = await projection.projectedMetersForCoordinate(
        Point(coordinates: Position(200, 0)),
      );
      final limit = await projection.projectedMetersForCoordinate(
        Point(coordinates: Position(180, 0)),
      );
      expect(wrapped.easting, limit.easting);
    });

    test('zoom is clamped to [0, 25.5]', () async {
      expect(
        await projection.getMetersPerPixelAtLatitude(0, -1),
        await projection.getMetersPerPixelAtLatitude(0, 0),
      );
      expect(
        await projection.getMetersPerPixelAtLatitude(0, 30),
        await projection.getMetersPerPixelAtLatitude(0, 25.5),
      );
    });

    test('coordinateForProjectedMeters clamps to the valid range', () async {
      final point = await projection.coordinateForProjectedMeters(
        ProjectedMeters(northing: 1e9, easting: 1e9),
      );
      expect(point.coordinates.lat, 85.051128779806604);
      expect(point.coordinates.lng, 180);
    });
  });

  group('project and unproject', () {
    test('round-trip at zoomScale 16', () async {
      final original = Point(coordinates: Position(24.94, 60.17));
      final projected = await projection.project(original, 16);
      final back = await projection.unproject(projected, 16);
      expect(back.coordinates.lng, closeTo(24.94, 1e-9));
      expect(back.coordinates.lat, closeTo(60.17, 1e-9));
    });

    test('project scales linearly with zoomScale', () async {
      final point = Point(coordinates: Position(24.94, 60.17));
      final unit = await projection.project(point, 1);
      final zoomed = await projection.project(
        point,
        math.pow(2, 22).toDouble(),
      );
      expect(zoomed.x, closeTo(unit.x * math.pow(2, 22).toDouble(), 1e-6));
      expect(zoomed.y, closeTo(unit.y * math.pow(2, 22).toDouble(), 1e-6));
    });
  });
}
