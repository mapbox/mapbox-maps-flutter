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

  testWidgets('Add FillExtrusionLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(FillExtrusionLayer(
      id: 'layer',
      sourceId: "composite",
      sourceLayer: "building",
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      fillExtrusionEdgeRadius: 1.0,
      fillExtrusionAmbientOcclusionGroundAttenuation: 1.0,
      fillExtrusionAmbientOcclusionGroundRadius: 1.0,
      fillExtrusionAmbientOcclusionIntensity: 1.0,
      fillExtrusionAmbientOcclusionRadius: 1.0,
      fillExtrusionAmbientOcclusionWallRadius: 1.0,
      fillExtrusionBase: 1.0,
      fillExtrusionColor: Colors.red.value,
      fillExtrusionCutoffFadeRange: 1.0,
      fillExtrusionEmissiveStrength: 1.0,
      fillExtrusionFloodLightColor: Colors.red.value,
      fillExtrusionFloodLightGroundAttenuation: 1.0,
      fillExtrusionFloodLightGroundRadius: 1.0,
      fillExtrusionFloodLightIntensity: 1.0,
      fillExtrusionFloodLightWallRadius: 1.0,
      fillExtrusionHeight: 1.0,
      fillExtrusionOpacity: 1.0,
      fillExtrusionPattern: "abc",
      fillExtrusionRoundedRoof: true,
      fillExtrusionTranslate: [0.0, 1.0],
      fillExtrusionTranslateAnchor: FillExtrusionTranslateAnchor.MAP,
      fillExtrusionVerticalGradient: true,
      fillExtrusionVerticalScale: 1.0,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as FillExtrusionLayer;
    expect('composite', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.fillExtrusionEdgeRadius, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionGroundAttenuation, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionGroundRadius, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionIntensity, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionRadius, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionWallRadius, 1.0);
    expect(layer.fillExtrusionBase, 1.0);
    expect(layer.fillExtrusionColor, Colors.red.value);
    expect(layer.fillExtrusionCutoffFadeRange, 1.0);
    expect(layer.fillExtrusionEmissiveStrength, 1.0);
    expect(layer.fillExtrusionFloodLightColor, Colors.red.value);
    expect(layer.fillExtrusionFloodLightGroundAttenuation, 1.0);
    expect(layer.fillExtrusionFloodLightGroundRadius, 1.0);
    expect(layer.fillExtrusionFloodLightIntensity, 1.0);
    expect(layer.fillExtrusionFloodLightWallRadius, 1.0);
    expect(layer.fillExtrusionHeight, 1.0);
    expect(layer.fillExtrusionOpacity, 1.0);
    expect(layer.fillExtrusionPattern, "abc");
    expect(layer.fillExtrusionRoundedRoof, true);
    expect(layer.fillExtrusionTranslate, [0.0, 1.0]);
    expect(
        layer.fillExtrusionTranslateAnchor, FillExtrusionTranslateAnchor.MAP);
    expect(layer.fillExtrusionVerticalGradient, true);
    expect(layer.fillExtrusionVerticalScale, 1.0);
  });
}
// End of generated file.
