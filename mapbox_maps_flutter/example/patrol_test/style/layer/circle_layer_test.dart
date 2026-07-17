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
  patrolTest('Add CircleLayer', ($) async {
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
      CircleLayer(
        id: 'layer',
        sourceId: 'source',
        visibility: Visibility.NONE,
        minZoom: 1.0,
        maxZoom: 20.0,
        slot: LayerSlot.BOTTOM,
        circleElevationReference: CircleElevationReference.NONE,
        circleSortKey: 1.0,
        circleBlur: 1.0,
        circleColor: Colors.red.value,
        circleEmissiveStrength: 1.0,
        circleOpacity: 1.0,
        circlePitchAlignment: CirclePitchAlignment.MAP,
        circlePitchScale: CirclePitchScale.MAP,
        circleRadius: 1.0,
        circleStrokeColor: Colors.red.value,
        circleStrokeOpacity: 1.0,
        circleStrokeWidth: 1.0,
        circleTranslate: [0.0, 1.0],
        circleTranslateAnchor: CircleTranslateAnchor.MAP,
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as CircleLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.circleElevationReference, CircleElevationReference.NONE);
    expect(layer.circleSortKey, 1.0);
    expect(layer.circleBlur, 1.0);
    expect(layer.circleColor, Colors.red.value);
    expect(layer.circleEmissiveStrength, 1.0);
    expect(layer.circleOpacity, 1.0);
    expect(layer.circlePitchAlignment, CirclePitchAlignment.MAP);
    expect(layer.circlePitchScale, CirclePitchScale.MAP);
    expect(layer.circleRadius, 1.0);
    expect(layer.circleStrokeColor, Colors.red.value);
    expect(layer.circleStrokeOpacity, 1.0);
    expect(layer.circleStrokeWidth, 1.0);
    expect(layer.circleTranslate, [0.0, 1.0]);
    expect(layer.circleTranslateAnchor, CircleTranslateAnchor.MAP);
  });

  patrolTest('Add CircleLayer with expressions', ($) async {
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
      CircleLayer(
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
        circleElevationReferenceExpression: ['string', 'none'],
        circleSortKeyExpression: ['number', 1.0],
        circleBlurExpression: ['number', 1.0],
        circleColorExpression: ['rgba', 255, 0, 0, 1],
        circleEmissiveStrengthExpression: ['number', 1.0],
        circleOpacityExpression: ['number', 1.0],
        circlePitchAlignmentExpression: ['string', 'map'],
        circlePitchScaleExpression: ['string', 'map'],
        circleRadiusExpression: ['number', 1.0],
        circleStrokeColorExpression: ['rgba', 255, 0, 0, 1],
        circleStrokeOpacityExpression: ['number', 1.0],
        circleStrokeWidthExpression: ['number', 1.0],
        circleTranslateExpression: [
          'literal',
          [0.0, 1.0],
        ],
        circleTranslateAnchorExpression: ['string', 'map'],
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as CircleLayer;
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
    expect(layer.circleElevationReference, CircleElevationReference.NONE);
    expect(layer.circleSortKey, 1.0);
    expect(layer.circleBlur, 1.0);
    expect(layer.circleColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.circleEmissiveStrength, 1.0);
    expect(layer.circleOpacity, 1.0);
    expect(layer.circlePitchAlignment, CirclePitchAlignment.MAP);
    expect(layer.circlePitchScale, CirclePitchScale.MAP);
    expect(layer.circleRadius, 1.0);
    expect(layer.circleStrokeColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.circleStrokeOpacity, 1.0);
    expect(layer.circleStrokeWidth, 1.0);
    expect(layer.circleTranslate, [0.0, 1.0]);
    expect(layer.circleTranslateAnchor, CircleTranslateAnchor.MAP);
  });
}

// End of generated file.
