// This file is generated.
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add BackgroundLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(BackgroundLayer(
      id: 'layer',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      backgroundColor: Colors.red.value,
      backgroundEmissiveStrength: 1.0,
      backgroundOpacity: 1.0,
      backgroundPattern: "abc",
    ));
    var layer = await mapboxMap.style.getLayer('layer') as BackgroundLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.backgroundColor, Colors.red.value);
    expect(layer.backgroundEmissiveStrength, 1.0);
    expect(layer.backgroundOpacity, 1.0);
    expect(layer.backgroundPattern, "abc");
  });

  testWidgets('Add BackgroundLayer with expressions',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(BackgroundLayer(
      id: 'layer',
      visibilityExpression: ['string', 'none'],
      filter: [
        "==",
        ["get", "type"],
        "Feature"
      ],
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      backgroundColorExpression: ['rgba', 255, 0, 0, 1],
      backgroundEmissiveStrengthExpression: ['number', 1.0],
      backgroundOpacityExpression: ['number', 1.0],
      backgroundPatternExpression: ['image', "abc"],
    ));
    var layer = await mapboxMap.style.getLayer('layer') as BackgroundLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.filter, [
      "==",
      ["get", "type"],
      "Feature"
    ]);
    expect(layer.backgroundColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.backgroundEmissiveStrength, 1.0);
    expect(layer.backgroundOpacity, 1.0);
    expect(layer.backgroundPatternExpression, ['image', "abc"]);
  });
}
// End of generated file.
