import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;
import 'package:turf/helpers.dart';

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

  testWidgets('Add Model layer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await addDelay(1000);

    await mapboxMap.style.addModel(modelId,
        'https://docs.mapbox.com/mapbox-gl-js/assets/34M_17/34M_17.gltf');

    var geoJsonSource = GeoJsonSource(
        id: sourceId,
        data: jsonEncode(FeatureCollection(features: [
          Feature(
              id: "feature1",
              geometry: Point(coordinates: Position(50.0249701, 26.1992264)),
              properties: {modelIdKey: modelId}),
        ]).toJson()));
    await mapboxMap.style.addSource(geoJsonSource);

    var modelLayer = ModelLayer(
        id: layerId,
        maxZoom: 20,
        minZoom: 1,
        visibility: Visibility.NONE,
        sourceId: sourceId,
        modelId: modelId,
        scale: [1.0, 1.0, 1.0]);
    await mapboxMap.style.addLayer(modelLayer);
    var layer = await mapboxMap.style.getLayer(layerId) as ModelLayer;
    expect(sourceId, layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);

  });
}