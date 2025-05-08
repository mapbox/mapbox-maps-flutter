// This file is generated.
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add HillshadeLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addSource(RasterDemSource(
        id: "source", url: "mapbox://mapbox.mapbox-terrain-dem-v1"));

    await mapboxMap.style.addLayer(HillshadeLayer(
      id: 'layer',
      sourceId: 'source',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      hillshadeAccentColor: Colors.red.value,
      hillshadeEmissiveStrength: 1.0,
      hillshadeExaggeration: 1.0,
      hillshadeHighlightColor: Colors.red.value,
      hillshadeIlluminationAnchor: HillshadeIlluminationAnchor.MAP,
      hillshadeIlluminationDirection: 1.0,
      hillshadeShadowColor: Colors.red.value,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as HillshadeLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.hillshadeAccentColor, Colors.red.value);
    expect(layer.hillshadeEmissiveStrength, 1.0);
    expect(layer.hillshadeExaggeration, 1.0);
    expect(layer.hillshadeHighlightColor, Colors.red.value);
    expect(layer.hillshadeIlluminationAnchor, HillshadeIlluminationAnchor.MAP);
    expect(layer.hillshadeIlluminationDirection, 1.0);
    expect(layer.hillshadeShadowColor, Colors.red.value);
  });

  testWidgets('Add HillshadeLayer with expressions',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addSource(RasterDemSource(
        id: "source", url: "mapbox://mapbox.mapbox-terrain-dem-v1"));

    await mapboxMap.style.addLayer(HillshadeLayer(
      id: 'layer',
      sourceId: 'source',
      visibilityExpression: ['string', 'none'],
      filter: [
        "==",
        ["get", "type"],
        "Feature"
      ],
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      hillshadeAccentColorExpression: ['rgba', 255, 0, 0, 1],
      hillshadeEmissiveStrengthExpression: ['number', 1.0],
      hillshadeExaggerationExpression: ['number', 1.0],
      hillshadeHighlightColorExpression: ['rgba', 255, 0, 0, 1],
      hillshadeIlluminationAnchorExpression: ['string', 'map'],
      hillshadeIlluminationDirectionExpression: ['number', 1.0],
      hillshadeShadowColorExpression: ['rgba', 255, 0, 0, 1],
    ));
    var layer = await mapboxMap.style.getLayer('layer') as HillshadeLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.filter, [
      "==",
      ["get", "type"],
      "Feature"
    ]);
    expect(layer.hillshadeAccentColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.hillshadeEmissiveStrength, 1.0);
    expect(layer.hillshadeExaggeration, 1.0);
    expect(layer.hillshadeHighlightColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.hillshadeIlluminationAnchor, HillshadeIlluminationAnchor.MAP);
    expect(layer.hillshadeIlluminationDirection, 1.0);
    expect(layer.hillshadeShadowColorExpression, ['rgba', 255, 0, 0, 1]);
  });
}
// End of generated file.
