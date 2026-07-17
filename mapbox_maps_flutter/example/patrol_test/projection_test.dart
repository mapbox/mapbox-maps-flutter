// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';

import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

// Projection APIs are not yet wired to GL JS on web; the web stub throws
// UnimplementedError. Skip the whole suite on web until MapboxStyleWeb's
// projection math lands as part of the web-parity epic.
void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  if (kIsWeb) return;

  patrolTest('getMetersPerPixelAtLatitude', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    var meters = await mapboxMap.projection.getMetersPerPixelAtLatitude(
      1.0,
      16.0,
    );
    expect(meters.round(), 1);
  });

  patrolTest('projectedMetersForCoordinate', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    var projectedMeters = await mapboxMap.projection
        .projectedMetersForCoordinate(Point(coordinates: Position(1.0, 60)));
    expect(projectedMeters.easting.floor(), 111195);
    expect(projectedMeters.northing.floor(), 8390350);
  });

  patrolTest('coordinateForProjectedMeters', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    final point = await mapboxMap.projection.coordinateForProjectedMeters(
      ProjectedMeters(northing: 100000.0, easting: 100000.0),
    );
    expect((point.coordinates.lng as double).floor(), 0);
    expect((point.coordinates.lat as double).floor(), 0);
  });

  patrolTest('unproject', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    final point = await mapboxMap.projection.unproject(
      MercatorCoordinate(x: 1.0, y: 1.0),
      16,
    );
    expect((point.coordinates.lng as double).floor(), -180);
    expect((point.coordinates.lat as double).floor(), 85);
  });

  patrolTest('project', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    var mercatorCoordinate = await mapboxMap.projection.project(
      Point(coordinates: Position(1.0, 60)),
      16,
    );
    expect(mercatorCoordinate.x.floor(), 4118);
    expect(mercatorCoordinate.y.floor(), 2378);
  });
}
