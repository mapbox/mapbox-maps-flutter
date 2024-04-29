// This file is generated.
import 'dart:convert';
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add HeatmapLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addSource(GeoJsonSource(
        id: "source",
        data:
            "https://www.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson"));

    await mapboxMap.style.addLayer(HeatmapLayer(
      id: 'layer',
      sourceId: 'source',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      heatmapColor: Colors.red.value,
      heatmapIntensity: 1.0,
      heatmapOpacity: 1.0,
      heatmapRadius: 1.0,
      heatmapWeight: 1.0,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as HeatmapLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.heatmapColor, Colors.red.value);
    expect(layer.heatmapIntensity, 1.0);
    expect(layer.heatmapOpacity, 1.0);
    expect(layer.heatmapRadius, 1.0);
    expect(layer.heatmapWeight, 1.0);
  });
}
// End of generated file.
