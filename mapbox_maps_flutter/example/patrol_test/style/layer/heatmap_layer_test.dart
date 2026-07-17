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
  patrolTest('Add HeatmapLayer', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    // Empty GeoJSON source — the layer-property tests don't query features,
    // they only check the addLayer/getLayer round-trip. `lineMetrics: true`
    // is required by gl-js whenever a `line` layer sets line-gradient or
    // line-trim-* properties, so we enable it unconditionally; it's a no-op
    // for non-line layers.
    await mapboxMap.style.addSource(
      GeoJsonSource(
        id: "source",
        data: '{"type":"FeatureCollection","features":[]}',
        lineMetrics: true,
      ),
    );

    await mapboxMap.style.addLayer(
      HeatmapLayer(
        id: 'layer',
        sourceId: 'source',
        visibility: Visibility.NONE,
        minZoom: 1.0,
        maxZoom: 20.0,
        slot: LayerSlot.BOTTOM,
        heatmapColor: Colors.red.value,
        heatmapIntensity: 1.0,
        heatmapOpacity: 1.0,
        heatmapRadius: 1.0,
        heatmapWeight: 1.0,
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as HeatmapLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.heatmapColor, Colors.red.value);
    expect(layer.heatmapIntensity, 1.0);
    expect(layer.heatmapOpacity, 1.0);
    expect(layer.heatmapRadius, 1.0);
    expect(layer.heatmapWeight, 1.0);
  });

  patrolTest('Add HeatmapLayer with expressions', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    // Empty GeoJSON source — the layer-property tests don't query features,
    // they only check the addLayer/getLayer round-trip. `lineMetrics: true`
    // is required by gl-js whenever a `line` layer sets line-gradient or
    // line-trim-* properties, so we enable it unconditionally; it's a no-op
    // for non-line layers.
    await mapboxMap.style.addSource(
      GeoJsonSource(
        id: "source",
        data: '{"type":"FeatureCollection","features":[]}',
        lineMetrics: true,
      ),
    );

    await mapboxMap.style.addLayer(
      HeatmapLayer(
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
        heatmapColorExpression: ['rgba', 255, 0, 0, 1],
        heatmapIntensityExpression: ['number', 1.0],
        heatmapOpacityExpression: ['number', 1.0],
        heatmapRadiusExpression: ['number', 1.0],
        heatmapWeightExpression: ['number', 1.0],
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as HeatmapLayer;
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
    expect(layer.heatmapColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.heatmapIntensity, 1.0);
    expect(layer.heatmapOpacity, 1.0);
    expect(layer.heatmapRadius, 1.0);
    expect(layer.heatmapWeight, 1.0);
  });
}

// End of generated file.
