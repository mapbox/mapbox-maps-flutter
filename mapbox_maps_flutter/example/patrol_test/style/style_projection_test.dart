// ignore_for_file: experimental_member_use

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../empty_map_widget.dart' as app;
import '../patrol.dart';

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

const _styleJson = '{"version": 8, "sources": {}, "layers": []}';

const _albersStyleJson = '''
{
  "version": 8,
  "projection": {"name": "albers"},
  "sources": {},
  "layers": []
}
''';

Future<MapboxMap> _setupMap(WidgetTester tester, String styleJson) async {
  final mapboxMap = await app.pumpMap(tester: tester, styleJson: styleJson);
  await tester.pumpAndSettle();
  if (!app.events.onStyleLoaded.isCompleted) {
    await app.waitForEvent(
      tester,
      app.events.onStyleLoaded.future,
      description: () => 'style never finished loading',
    );
  }
  return mapboxMap;
}

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('a style without projection', ($) async {
    final mapboxMap = await _setupMap($.tester, _styleJson);

    final projection = await mapboxMap.getProjection();

    // GL JS falls back to Mercator.
    expect(projection, kIsWeb ? StyleProjection.mercator : null);
  });

  patrolTest('getProjection returns the style projection', ($) async {
    final mapboxMap = await _setupMap($.tester, _albersStyleJson);

    final projection = await mapboxMap.getProjection();

    expect(
      projection,
      StyleProjection.albers(
        center: projection!.center!.also((center) {
          expect(center.coordinates.lng, inInclusiveRange(-180, 180));
          expect(center.coordinates.lat, inInclusiveRange(-90, 90));
        }),
        parallels: projection.parallels!.also((parallels) {
          expect(parallels.start, inInclusiveRange(-90, 90));
          expect(parallels.end, inInclusiveRange(-90, 90));
        }),
      ),
    );
  });

  patrolTest('setProjection sets each projection', ($) async {
    final mapboxMap = await _setupMap($.tester, _styleJson);

    final projections = [
      StyleProjection.mercator,
      StyleProjection.globe,
      StyleProjection.albers(
        center: Point(coordinates: Position(10, 50)),
        parallels: (start: 43, end: 62),
      ),
    ];
    for (final projection in projections) {
      await mapboxMap.setProjection(projection);

      expect(await mapboxMap.getProjection(), projection);
    }

    await mapboxMap.setProjection(StyleProjection.albers());

    final projection = await mapboxMap.getProjection();
    expect(
      projection,
      StyleProjection.albers(
        center: projection!.center!.also((center) {
          expect(center.coordinates.lng, inInclusiveRange(-180, 180));
          expect(center.coordinates.lat, inInclusiveRange(-90, 90));
        }),
        parallels: projection.parallels!.also((parallels) {
          expect(parallels.start, inInclusiveRange(-90, 90));
          expect(parallels.end, inInclusiveRange(-90, 90));
        }),
      ),
    );
  });
}
