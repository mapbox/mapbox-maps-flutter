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
  patrolTest('Add RasterParticleLayer', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    // gl-js requires a `raster-array` source for `raster-particle` layers.
    await mapboxMap.style.addSource(
      RasterArraySource(id: "source", tiles: ["a", "b", "c"]),
    );

    await mapboxMap.style.addLayer(
      RasterParticleLayer(
        id: 'layer',
        sourceId: 'source',
        visibility: Visibility.NONE,
        minZoom: 1.0,
        maxZoom: 20.0,
        slot: LayerSlot.BOTTOM,
        rasterParticleArrayBand: "abc",
        rasterParticleColor: Colors.red.value,
        rasterParticleCount: 1.0,
        rasterParticleFadeOpacityFactor: 1.0,
        rasterParticleMaxSpeed: 1.0,
        rasterParticleResetRateFactor: 1.0,
        rasterParticleSpeedFactor: 1.0,
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as RasterParticleLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.rasterParticleArrayBand, "abc");
    expect(layer.rasterParticleColor, Colors.red.value);
    expect(layer.rasterParticleCount, 1.0);
    expect(layer.rasterParticleFadeOpacityFactor, 1.0);
    expect(layer.rasterParticleMaxSpeed, 1.0);
    expect(layer.rasterParticleResetRateFactor, 1.0);
    expect(layer.rasterParticleSpeedFactor, 1.0);
  });

  patrolTest('Add RasterParticleLayer with expressions', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    // gl-js requires a `raster-array` source for `raster-particle` layers.
    await mapboxMap.style.addSource(
      RasterArraySource(id: "source", tiles: ["a", "b", "c"]),
    );

    await mapboxMap.style.addLayer(
      RasterParticleLayer(
        id: 'layer',
        sourceId: 'source',
        visibilityExpression: ['string', 'none'],
        filter: [
          "==",
          ["get", "type"],
          "Feature",
        ],
        minZoom: 1.0,
        maxZoom: 20.0,
        slot: LayerSlot.BOTTOM,
        rasterParticleArrayBand: "abc",
        rasterParticleColorExpression: ['rgba', 255, 0, 0, 1],
        rasterParticleCount: 1.0,
        rasterParticleFadeOpacityFactorExpression: ['number', 1.0],
        rasterParticleMaxSpeed: 1.0,
        rasterParticleResetRateFactor: 1.0,
        rasterParticleSpeedFactorExpression: ['number', 1.0],
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as RasterParticleLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.filter, [
      "==",
      ["get", "type"],
      "Feature",
    ]);
    expect(layer.rasterParticleArrayBand, "abc");
    expect(layer.rasterParticleColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.rasterParticleCount, 1.0);
    expect(layer.rasterParticleFadeOpacityFactor, 1.0);
    expect(layer.rasterParticleMaxSpeed, 1.0);
    expect(layer.rasterParticleResetRateFactor, 1.0);
    expect(layer.rasterParticleSpeedFactor, 1.0);
  });
}

// End of generated file.
