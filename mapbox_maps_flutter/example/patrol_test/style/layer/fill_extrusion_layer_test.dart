// This file is generated.
// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../patrol.dart';

import '../../empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  // These generated addLayer/getLayer tests run on web too. Only a limited
  // set of known Mapbox GL JS parity gaps are gated: some properties are
  // excluded from round-trip assertions, and a few unsupported layer types
  // may still be skipped separately by the template.
  patrolTest('Add FillExtrusionLayer', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    // gl-js's Standard style keeps `composite` inside the Streets import
    // and doesn't expose it at the top level the way gl-native does, so
    // addLayer with sourceId "composite" fails validation on web. Provide
    // it explicitly when it isn't already present (no-op on platforms
    // where the Standard import already publishes it).
    if (!await mapboxMap.style.styleSourceExists("composite")) {
      await mapboxMap.style.addSource(
        VectorSource(id: "composite", url: "mapbox://mapbox.mapbox-streets-v8"),
      );
    }

    await mapboxMap.style.addLayer(
      FillExtrusionLayer(
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
        fillExtrusionBaseAlignment: FillExtrusionBaseAlignment.TERRAIN,
        fillExtrusionCastShadows: true,
        fillExtrusionColor: Colors.red.value,
        fillExtrusionCutoffFadeRange: 1.0,
        fillExtrusionEmissiveStrength: 1.0,
        fillExtrusionFloodLightColor: Colors.red.value,
        fillExtrusionFloodLightGroundAttenuation: 1.0,
        fillExtrusionFloodLightGroundRadius: 1.0,
        fillExtrusionFloodLightIntensity: 1.0,
        fillExtrusionFloodLightWallRadius: 1.0,
        fillExtrusionHeight: 1.0,
        fillExtrusionHeightAlignment: FillExtrusionHeightAlignment.TERRAIN,
        fillExtrusionLineWidth: 1.0,
        fillExtrusionOpacity: 1.0,
        fillExtrusionPattern: "abc",
        fillExtrusionRoundedRoof: true,
        fillExtrusionTranslate: [0.0, 1.0],
        fillExtrusionTranslateAnchor: FillExtrusionTranslateAnchor.MAP,
        fillExtrusionVerticalGradient: true,
        fillExtrusionVerticalScale: 1.0,
      ),
    );
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
    expect(
      layer.fillExtrusionBaseAlignment,
      FillExtrusionBaseAlignment.TERRAIN,
    );
    expect(layer.fillExtrusionCastShadows, true);
    expect(layer.fillExtrusionColor, Colors.red.value);
    expect(layer.fillExtrusionCutoffFadeRange, 1.0);
    expect(layer.fillExtrusionEmissiveStrength, 1.0);
    expect(layer.fillExtrusionFloodLightColor, Colors.red.value);
    expect(layer.fillExtrusionFloodLightGroundAttenuation, 1.0);
    expect(layer.fillExtrusionFloodLightGroundRadius, 1.0);
    expect(layer.fillExtrusionFloodLightIntensity, 1.0);
    expect(layer.fillExtrusionFloodLightWallRadius, 1.0);
    expect(layer.fillExtrusionHeight, 1.0);
    expect(
      layer.fillExtrusionHeightAlignment,
      FillExtrusionHeightAlignment.TERRAIN,
    );
    expect(layer.fillExtrusionLineWidth, 1.0);
    expect(layer.fillExtrusionOpacity, 1.0);
    expect(layer.fillExtrusionPattern, "abc");
    expect(layer.fillExtrusionRoundedRoof, true);
    expect(layer.fillExtrusionTranslate, [0.0, 1.0]);
    expect(
      layer.fillExtrusionTranslateAnchor,
      FillExtrusionTranslateAnchor.MAP,
    );
    expect(layer.fillExtrusionVerticalGradient, true);
    expect(layer.fillExtrusionVerticalScale, 1.0);
  });

  patrolTest('Add FillExtrusionLayer with expressions', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    // gl-js's Standard style keeps `composite` inside the Streets import
    // and doesn't expose it at the top level the way gl-native does, so
    // addLayer with sourceId "composite" fails validation on web. Provide
    // it explicitly when it isn't already present (no-op on platforms
    // where the Standard import already publishes it).
    if (!await mapboxMap.style.styleSourceExists("composite")) {
      await mapboxMap.style.addSource(
        VectorSource(id: "composite", url: "mapbox://mapbox.mapbox-streets-v8"),
      );
    }

    await mapboxMap.style.addLayer(
      FillExtrusionLayer(
        id: 'layer',
        sourceId: "composite",
        sourceLayer: "building",
        visibilityExpression: ['string', 'none'],
        filter: [
          "==",
          ["get", "type"],
          "Feature",
        ],
        minZoom: 1.0,
        maxZoom: 20.0,
        slot: LayerSlot.BOTTOM,
        fillExtrusionEdgeRadiusExpression: ['number', 1.0],
        fillExtrusionAmbientOcclusionGroundAttenuationExpression: [
          'number',
          1.0,
        ],
        fillExtrusionAmbientOcclusionGroundRadiusExpression: ['number', 1.0],
        fillExtrusionAmbientOcclusionIntensityExpression: ['number', 1.0],
        fillExtrusionAmbientOcclusionRadiusExpression: ['number', 1.0],
        fillExtrusionAmbientOcclusionWallRadiusExpression: ['number', 1.0],
        fillExtrusionBaseExpression: ['number', 1.0],
        fillExtrusionBaseAlignment: FillExtrusionBaseAlignment.TERRAIN,
        fillExtrusionCastShadows: true,
        fillExtrusionColorExpression: ['rgba', 255, 0, 0, 1],
        fillExtrusionCutoffFadeRangeExpression: ['number', 1.0],
        fillExtrusionEmissiveStrengthExpression: ['number', 1.0],
        fillExtrusionFloodLightColorExpression: ['rgba', 255, 0, 0, 1],
        fillExtrusionFloodLightGroundAttenuationExpression: ['number', 1.0],
        fillExtrusionFloodLightGroundRadiusExpression: ['number', 1.0],
        fillExtrusionFloodLightIntensityExpression: ['number', 1.0],
        fillExtrusionFloodLightWallRadiusExpression: ['number', 1.0],
        fillExtrusionHeightExpression: ['number', 1.0],
        fillExtrusionHeightAlignment: FillExtrusionHeightAlignment.TERRAIN,
        fillExtrusionLineWidthExpression: ['number', 1.0],
        fillExtrusionOpacityExpression: ['number', 1.0],
        fillExtrusionPatternExpression: ['image', "abc"],
        fillExtrusionRoundedRoofExpression: ['==', true, true],
        fillExtrusionTranslateExpression: [
          'literal',
          [0.0, 1.0],
        ],
        fillExtrusionTranslateAnchorExpression: ['string', 'map'],
        fillExtrusionVerticalGradientExpression: ['==', true, true],
        fillExtrusionVerticalScaleExpression: ['number', 1.0],
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as FillExtrusionLayer;
    expect('composite', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.filter, [
      "==",
      ["get", "type"],
      "Feature",
    ]);
    expect(layer.fillExtrusionEdgeRadius, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionGroundAttenuation, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionGroundRadius, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionIntensity, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionRadius, 1.0);
    expect(layer.fillExtrusionAmbientOcclusionWallRadius, 1.0);
    expect(layer.fillExtrusionBase, 1.0);
    expect(
      layer.fillExtrusionBaseAlignment,
      FillExtrusionBaseAlignment.TERRAIN,
    );
    expect(layer.fillExtrusionCastShadows, true);
    expect(layer.fillExtrusionColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.fillExtrusionCutoffFadeRange, 1.0);
    expect(layer.fillExtrusionEmissiveStrength, 1.0);
    expect(layer.fillExtrusionFloodLightColorExpression, [
      'rgba',
      255,
      0,
      0,
      1,
    ]);
    expect(layer.fillExtrusionFloodLightGroundAttenuation, 1.0);
    expect(layer.fillExtrusionFloodLightGroundRadius, 1.0);
    expect(layer.fillExtrusionFloodLightIntensity, 1.0);
    expect(layer.fillExtrusionFloodLightWallRadius, 1.0);
    expect(layer.fillExtrusionHeight, 1.0);
    expect(
      layer.fillExtrusionHeightAlignment,
      FillExtrusionHeightAlignment.TERRAIN,
    );
    expect(layer.fillExtrusionLineWidth, 1.0);
    expect(layer.fillExtrusionOpacity, 1.0);
    expect(layer.fillExtrusionPatternExpression, ['image', "abc"]);
    expect(layer.fillExtrusionRoundedRoof, true);
    expect(layer.fillExtrusionTranslate, [0.0, 1.0]);
    expect(
      layer.fillExtrusionTranslateAnchor,
      FillExtrusionTranslateAnchor.MAP,
    );
    expect(layer.fillExtrusionVerticalGradient, true);
    expect(layer.fillExtrusionVerticalScale, 1.0);
  });
}

// End of generated file.
