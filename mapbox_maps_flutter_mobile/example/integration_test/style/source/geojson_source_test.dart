// This file is generated.
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

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
    var maxzoom = await source.maxzoom;
    expect(maxzoom, 1.0);

    var attribution = await source.attribution;
    expect(attribution, "abc");

    var buffer = await source.buffer;
    expect(buffer, 1.0);

    var tolerance = await source.tolerance;
    expect(tolerance, 1.0);

    var cluster = await source.cluster;
    expect(cluster, true);

    var clusterRadius = await source.clusterRadius;
    expect(clusterRadius, 1.0);

    var clusterMaxZoom = await source.clusterMaxZoom;
    expect(clusterMaxZoom, 1.0);

    var clusterMinPoints = await source.clusterMinPoints;
    expect(clusterMinPoints, 1.0);

    var clusterProperties = await source.clusterProperties;
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

    var lineMetrics = await source.lineMetrics;
    expect(lineMetrics, true);

    var generateId = await source.generateId;
    expect(generateId, true);

    var prefetchZoomDelta = await source.prefetchZoomDelta;
    expect(prefetchZoomDelta, 1.0);

    var tileCacheBudget = await source.tileCacheBudget;
    expect(tileCacheBudget?.size,
        TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)).size);
    expect(tileCacheBudget?.type,
        TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)).type);
  });
}
// End of generated file.
