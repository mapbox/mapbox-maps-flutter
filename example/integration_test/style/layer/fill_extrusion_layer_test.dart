// This file is generated.
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

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
      fillExtrusionLineWidth: 1.0,
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
    expect(layer.fillExtrusionLineWidth, 1.0);
    expect(layer.fillExtrusionOpacity, 1.0);
    expect(layer.fillExtrusionPattern, "abc");
    expect(layer.fillExtrusionRoundedRoof, true);
    expect(layer.fillExtrusionTranslate, [0.0, 1.0]);
    expect(
        layer.fillExtrusionTranslateAnchor, FillExtrusionTranslateAnchor.MAP);
    expect(layer.fillExtrusionVerticalGradient, true);
    expect(layer.fillExtrusionVerticalScale, 1.0);
  });

  testWidgets('Add FillExtrusionLayer with expressions',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(FillExtrusionLayer(
      id: 'layer',
      sourceId: "composite",
      sourceLayer: "building",
      visibilityExpression: ['string', 'none'],
      filter: [
        "==",
        ["get", "type"],
        "Feature"
      ],
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      fillExtrusionEdgeRadiusExpression: ['number', 1.0],
      fillExtrusionAmbientOcclusionGroundAttenuationExpression: ['number', 1.0],
      fillExtrusionAmbientOcclusionGroundRadiusExpression: ['number', 1.0],
      fillExtrusionAmbientOcclusionIntensityExpression: ['number', 1.0],
      fillExtrusionAmbientOcclusionRadiusExpression: ['number', 1.0],
      fillExtrusionAmbientOcclusionWallRadiusExpression: ['number', 1.0],
      fillExtrusionBaseExpression: ['number', 1.0],
      fillExtrusionColorExpression: ['rgba', 255, 0, 0, 1],
      fillExtrusionCutoffFadeRangeExpression: ['number', 1.0],
      fillExtrusionEmissiveStrengthExpression: ['number', 1.0],
      fillExtrusionFloodLightColorExpression: ['rgba', 255, 0, 0, 1],
      fillExtrusionFloodLightGroundAttenuationExpression: ['number', 1.0],
      fillExtrusionFloodLightGroundRadiusExpression: ['number', 1.0],
      fillExtrusionFloodLightIntensityExpression: ['number', 1.0],
      fillExtrusionFloodLightWallRadiusExpression: ['number', 1.0],
      fillExtrusionHeightExpression: ['number', 1.0],
      fillExtrusionLineWidthExpression: ['number', 1.0],
      fillExtrusionOpacityExpression: ['number', 1.0],
      fillExtrusionPatternExpression: ['image', "abc"],
      fillExtrusionRoundedRoofExpression: ['==', true, true],
      fillExtrusionTranslateExpression: [
        'literal',
        [0.0, 1.0]
      ],
      fillExtrusionTranslateAnchorExpression: ['string', 'map'],
      fillExtrusionVerticalGradientExpression: ['==', true, true],
      fillExtrusionVerticalScaleExpression: ['number', 1.0],
    ));
    var layer = await mapboxMap.style.getLayer('layer') as FillExtrusionLayer;
    expect('composite', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.filter, [
      "==",
      ["get", "type"],
      "Feature"
    ]);
    expect(layer.fillExtrusionEdgeRadius, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionGroundAttenuation, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionGroundRadius, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionIntensity, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionRadius, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionWallRadius, 1.0);
    expect(layer.fillExtrusionBase, 1.0);
    expect(layer.fillExtrusionColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.fillExtrusionCutoffFadeRange, 1.0);
    expect(layer.fillExtrusionEmissiveStrength, 1.0);
    expect(
        layer.fillExtrusionFloodLightColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.fillExtrusionFloodLightGroundAttenuation, 1.0);
    expect(layer.fillExtrusionFloodLightGroundRadius, 1.0);
    expect(layer.fillExtrusionFloodLightIntensity, 1.0);
    expect(layer.fillExtrusionFloodLightWallRadius, 1.0);
    expect(layer.fillExtrusionHeight, 1.0);
    expect(layer.fillExtrusionLineWidth, 1.0);
    expect(layer.fillExtrusionOpacity, 1.0);
    expect(layer.fillExtrusionPatternExpression, ['image', "abc"]);
    expect(layer.fillExtrusionRoundedRoof, true);
    expect(layer.fillExtrusionTranslate, [0.0, 1.0]);
    expect(
        layer.fillExtrusionTranslateAnchor, FillExtrusionTranslateAnchor.MAP);
    expect(layer.fillExtrusionVerticalGradient, true);
    expect(layer.fillExtrusionVerticalScale, 1.0);
  });
}
// End of generated file.
