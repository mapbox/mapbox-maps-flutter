// This file is generated.
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;
import '../../utils/retry.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add GeoJsonSource', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await app.events.onMapLoaded.future;

    await mapboxMap.style.addSource(GeoJsonSource(
      id: "source",
      data: json.encode(Point(coordinates: Position(-77.032667, 38.913175))),
      maxzoom: 1.0,
      attribution: "abc",
      buffer: 1.0,
      tolerance: 1.0,
      cluster: true,
      clusterRadius: 1.0,
      clusterMaxZoom: 1.0,
      clusterMinPoints: 1.0,
      clusterProperties: {
        "sum": [
          [
            "+",
            [
              "number",
              ["accumulated"]
            ],
            [
              "number",
              ["get", "sum"]
            ]
          ],
          1.0
        ]
      },
      lineMetrics: true,
      generateId: true,
      prefetchZoomDelta: 1.0,
      tileCacheBudget:
          TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)),
    ));

    var source = await mapboxMap.style.getSource('source') as GeoJsonSource;
    expect(source.id, 'source');

    final maxzoom = await source.maxzoom;
    expect(maxzoom, 1.0);
    final attribution = await source.attribution;
    expect(attribution, "abc");
    final buffer = await source.buffer;
    expect(buffer, 1.0);
    final tolerance = await source.tolerance;
    expect(tolerance, 1.0);
    final cluster = await source.cluster;
    expect(cluster, true);
    final clusterRadius = await source.clusterRadius;
    expect(clusterRadius, 1.0);
    final clusterMaxZoom = await source.clusterMaxZoom;
    expect(clusterMaxZoom, 1.0);
    final clusterMinPoints = await source.clusterMinPoints;
    expect(clusterMinPoints, 1.0);
    final clusterProperties = await source.clusterProperties;
    expect(clusterProperties, {
      "sum": [
        [
          "+",
          [
            "number",
            ["accumulated"]
          ],
          [
            "number",
            ["get", "sum"]
          ]
        ],
        1.0
      ]
    });
    final lineMetrics = await source.lineMetrics;
    expect(lineMetrics, true);
    final generateId = await source.generateId;
    expect(generateId, true);
    await retry(2, () async {
      await expectLater(source.prefetchZoomDelta, completion(1.0));
    });
    await retry(2, () async {
      await expectLater(
          source.tileCacheBudget,
          completion(TileCacheBudget.inMegabytes(
              TileCacheBudgetInMegabytes(size: 3))));
    });
  });
}
// End of generated file.
