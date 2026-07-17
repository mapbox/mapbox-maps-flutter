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
  patrolTest('Add ModelLayer', ($) async {
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
      ModelLayer(
        id: 'layer',
        sourceId: "composite",
        sourceLayer: "building",
        visibility: Visibility.NONE,
        minZoom: 1.0,
        maxZoom: 20.0,
        slot: LayerSlot.BOTTOM,
        modelAllowDensityReduction: true,
        modelId: "abc",
        modelAmbientOcclusionIntensity: 1.0,
        modelCastShadows: true,
        modelColor: Colors.red.value,
        modelColorMixIntensity: 1.0,
        modelCutoffFadeRange: 1.0,
        modelElevationReference: ModelElevationReference.SEA,
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
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as ModelLayer;
    expect('composite', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.modelAllowDensityReduction, true);
    expect(layer.modelId, "abc");
    expect(layer.modelAmbientOcclusionIntensity, 1.0);
    expect(layer.modelCastShadows, true);
    expect(layer.modelColor, Colors.red.value);
    expect(layer.modelColorMixIntensity, 1.0);
    expect(layer.modelCutoffFadeRange, 1.0);
    expect(layer.modelElevationReference, ModelElevationReference.SEA);
    expect(layer.modelEmissiveStrength, 1.0);
    expect(layer.modelHeightBasedEmissiveStrengthMultiplier, [
      0.0,
      1.0,
      2.0,
      3.0,
      4.0,
    ]);
    expect(layer.modelOpacity, 1.0);
    expect(layer.modelReceiveShadows, true);
    expect(layer.modelRotation, [0.0, 1.0, 2.0]);
    expect(layer.modelRoughness, 1.0);
    expect(layer.modelScale, [0.0, 1.0, 2.0]);
    if (!kIsWeb) {
      expect(layer.modelScaleMode, ModelScaleMode.MAP);
    }
    expect(layer.modelTranslation, [0.0, 1.0, 2.0]);
    expect(layer.modelType, ModelType.COMMON_3D);
  });

  patrolTest('Add ModelLayer with expressions', ($) async {
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
      ModelLayer(
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
        modelAllowDensityReduction: true,
        modelIdExpression: ['string', "abc"],
        modelAmbientOcclusionIntensityExpression: ['number', 1.0],
        modelCastShadows: true,
        modelColorExpression: ['rgba', 255, 0, 0, 1],
        modelColorMixIntensityExpression: ['number', 1.0],
        modelCutoffFadeRangeExpression: ['number', 1.0],
        modelElevationReferenceExpression: ['string', 'sea'],
        modelEmissiveStrengthExpression: ['number', 1.0],
        modelHeightBasedEmissiveStrengthMultiplierExpression: [
          'literal',
          [0.0, 1.0, 2.0, 3.0, 4.0],
        ],
        modelOpacityExpression: ['number', 1.0],
        modelReceiveShadows: true,
        modelRotationExpression: [
          'literal',
          [0.0, 1.0, 2.0],
        ],
        modelRoughnessExpression: ['number', 1.0],
        modelScaleExpression: [
          'literal',
          [0.0, 1.0, 2.0],
        ],
        modelScaleMode: ModelScaleMode.MAP,
        modelTranslationExpression: [
          'literal',
          [0.0, 1.0, 2.0],
        ],
        modelType: ModelType.COMMON_3D,
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as ModelLayer;
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
    expect(layer.modelAllowDensityReduction, true);
    expect(layer.modelId, "abc");
    expect(layer.modelAmbientOcclusionIntensity, 1.0);
    expect(layer.modelCastShadows, true);
    expect(layer.modelColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.modelColorMixIntensity, 1.0);
    expect(layer.modelCutoffFadeRange, 1.0);
    expect(layer.modelElevationReference, ModelElevationReference.SEA);
    expect(layer.modelEmissiveStrength, 1.0);
    expect(layer.modelHeightBasedEmissiveStrengthMultiplier, [
      0.0,
      1.0,
      2.0,
      3.0,
      4.0,
    ]);
    expect(layer.modelOpacity, 1.0);
    expect(layer.modelReceiveShadows, true);
    expect(layer.modelRotation, [0.0, 1.0, 2.0]);
    expect(layer.modelRoughness, 1.0);
    expect(layer.modelScale, [0.0, 1.0, 2.0]);
    if (!kIsWeb) {
      expect(layer.modelScaleMode, ModelScaleMode.MAP);
    }
    expect(layer.modelTranslation, [0.0, 1.0, 2.0]);
    expect(layer.modelType, ModelType.COMMON_3D);
  });
}

// End of generated file.
