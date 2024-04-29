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

  testWidgets('Add FillLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    var polygon = Polygon(coordinates: [
      [
        Position(-3.363937, -10.733102),
        Position(1.754703, -19.716317),
        Position(-15.747196, -21.085074),
        Position(-3.363937, -10.733102)
      ]
    ]);
    await mapboxMap.style
        .addSource(GeoJsonSource(id: "source", data: json.encode(polygon)));

    await mapboxMap.style.addLayer(FillLayer(
      id: 'layer',
      sourceId: 'source',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      fillSortKey: 1.0,
      fillAntialias: true,
      fillColor: Colors.red.value,
      fillEmissiveStrength: 1.0,
      fillOpacity: 1.0,
      fillOutlineColor: Colors.red.value,
      fillPattern: "abc",
      fillTranslate: [0.0, 1.0],
      fillTranslateAnchor: FillTranslateAnchor.MAP,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as FillLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.fillSortKey, 1.0);
    expect(layer.fillAntialias, true);
    expect(layer.fillColor, Colors.red.value);
    expect(layer.fillEmissiveStrength, 1.0);
    expect(layer.fillOpacity, 1.0);
    expect(layer.fillOutlineColor, Colors.red.value);
    expect(layer.fillPattern, "abc");
    expect(layer.fillTranslate, [0.0, 1.0]);
    expect(layer.fillTranslateAnchor, FillTranslateAnchor.MAP);
  });
}
// End of generated file.
