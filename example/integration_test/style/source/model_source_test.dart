// This file is generated.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;
import 'package:turf/turf.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> addDelay(int ms) async {
    await Future<void>.delayed(Duration(milliseconds: ms));
  }

  final name = "modelName";
  final key = "model-id-key";
  final modelIdKey = "model-id-key";
  final sourceId = "source-id";
  final modelId = "model-id";
  final layerId = 'model-layer-id';

  testWidgets('Add ModelSource', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await addDelay(1000);

    await mapboxMap.style.addModel(modelId,
        'https://docs.mapbox.com/mapbox-gl-js/assets/34M_17/34M_17.gltf');

    var geoJsonSource = GeoJsonSource(
        id: sourceId,
        maxzoom: 18,
        data: jsonEncode(FeatureCollection(features: [
          Feature(
              id: "feature1",
              geometry: Point(coordinates: Position(50.0249701, 26.1992264)),
              properties: {modelIdKey: modelId}),
        ]).toJson()));
    await mapboxMap.style.addSource(geoJsonSource);
    var source = await mapboxMap.style.getSource(sourceId) as GeoJsonSource;
    expect(sourceId, source.id);
    expect(18.0, await source.maxzoom);

  });
}
// End of generated file.
