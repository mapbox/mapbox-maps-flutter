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

  testWidgets('Add ModelLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(ModelLayer(
      id: 'layer',
      sourceId: "composite",
      sourceLayer: "building",
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      modelId: "abc",
      modelAmbientOcclusionIntensity: 1.0,
      modelCastShadows: true,
      modelColor: Colors.red.value,
      modelColorMixIntensity: 1.0,
      modelCutoffFadeRange: 1.0,
      modelEmissiveStrength: 1.0,
      modelHeightBasedEmissiveStrengthMultiplier: [0.0, 1.0, 2.0, 3.0, 4.0],
      modelOpacity: 1.0,
      modelReceiveShadows: true,
      modelRotation: [0.0, 1.0, 2.0],
      modelRoughness: 1.0,
      modelScale: [0.0, 1.0, 2.0],
      modelScaleMode: ModelScaleMode.MAP,
      modelTranslation: [0.0, 1.0, 2.0],
      modelType: ModelType.COMMON_3D,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as ModelLayer;
    expect('composite', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.modelId, "abc");
    expect(layer.modelAmbientOcclusionIntensity, 1.0);
    expect(layer.modelCastShadows, true);
    expect(layer.modelColor, Colors.red.value);
    expect(layer.modelColorMixIntensity, 1.0);
    expect(layer.modelCutoffFadeRange, 1.0);
    expect(layer.modelEmissiveStrength, 1.0);
    expect(layer.modelHeightBasedEmissiveStrengthMultiplier,
        [0.0, 1.0, 2.0, 3.0, 4.0]);
    expect(layer.modelOpacity, 1.0);
    expect(layer.modelReceiveShadows, true);
    expect(layer.modelRotation, [0.0, 1.0, 2.0]);
    expect(layer.modelRoughness, 1.0);
    expect(layer.modelScale, [0.0, 1.0, 2.0]);
    expect(layer.modelScaleMode, ModelScaleMode.MAP);
    expect(layer.modelTranslation, [0.0, 1.0, 2.0]);
    expect(layer.modelType, ModelType.COMMON_3D);
  });
}
// End of generated file.
