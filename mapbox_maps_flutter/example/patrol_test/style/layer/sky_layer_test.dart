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
  patrolTest('Add SkyLayer', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    await mapboxMap.style.addLayer(
      SkyLayer(
        id: 'layer',
        visibility: Visibility.NONE,
        minZoom: 1.0,
        maxZoom: 20.0,
        slot: LayerSlot.BOTTOM,
        skyAtmosphereColor: Colors.red.value,
        skyAtmosphereHaloColor: Colors.red.value,
        skyAtmosphereSun: [180.0, 90.0],
        skyAtmosphereSunIntensity: 1.0,
        skyGradient: Colors.red.value,
        skyGradientCenter: [180.0, 90.0],
        skyGradientRadius: 1.0,
        skyOpacity: 1.0,
        skyType: SkyType.GRADIENT,
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as SkyLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.skyAtmosphereColor, Colors.red.value);
    expect(layer.skyAtmosphereHaloColor, Colors.red.value);
    expect(layer.skyAtmosphereSun, [180.0, 90.0]);
    expect(layer.skyAtmosphereSunIntensity, 1.0);
    expect(layer.skyGradient, Colors.red.value);
    expect(layer.skyGradientCenter, [180.0, 90.0]);
    expect(layer.skyGradientRadius, 1.0);
    expect(layer.skyOpacity, 1.0);
    expect(layer.skyType, SkyType.GRADIENT);
  });

  patrolTest('Add SkyLayer with expressions', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    await mapboxMap.style.addLayer(
      SkyLayer(
        id: 'layer',
        visibilityExpression: ['string', 'none'],
        filter: [
          "==",
          ["get", "type"],
          "Feature",
        ],
        minZoom: 1.0,
        maxZoom: 20.0,
        slot: LayerSlot.BOTTOM,
        skyAtmosphereColor: Colors.red.value,
        skyAtmosphereHaloColor: Colors.red.value,
        skyAtmosphereSunExpression: [
          'literal',
          [180.0, 90.0],
        ],
        skyAtmosphereSunIntensity: 1.0,
        skyGradientExpression: ['rgba', 255, 0, 0, 1],
        skyGradientCenterExpression: [
          'literal',
          [180.0, 90.0],
        ],
        skyGradientRadiusExpression: ['number', 1.0],
        skyOpacityExpression: ['number', 1.0],
        skyTypeExpression: ['string', 'gradient'],
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as SkyLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    // gl-js's base StyleLayer constructor skips `filter` for sourceless
    // layer types (background/sky/slot — style_layer.ts:127), so the
    // filter we set is dropped before serialize() and the readback is
    // null. gl-native preserves it; gate just this assertion on web.
    if (!kIsWeb) {
      expect(layer.filter, [
        "==",
        ["get", "type"],
        "Feature",
      ]);
    }
    expect(layer.skyAtmosphereColor, Colors.red.value);
    expect(layer.skyAtmosphereHaloColor, Colors.red.value);
    expect(layer.skyAtmosphereSun, [180.0, 90.0]);
    expect(layer.skyAtmosphereSunIntensity, 1.0);
    expect(layer.skyGradientExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.skyGradientCenter, [180.0, 90.0]);
    expect(layer.skyGradientRadius, 1.0);
    expect(layer.skyOpacity, 1.0);
    expect(layer.skyType, SkyType.GRADIENT);
  });
}

// End of generated file.
