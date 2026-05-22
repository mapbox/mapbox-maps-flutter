// This file is generated.
// ignore_for_file: experimental_member_use
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // These generated addLayer/getLayer tests run on web too. Only a limited
  // set of known Mapbox GL JS parity gaps are gated: some properties are
  // excluded from round-trip assertions, and a few unsupported layer types
  // may still be skipped separately by the template.
  testWidgets('Add FillLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

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
      FillLayer(
        id: 'layer',
        sourceId: 'source',
        visibility: Visibility.NONE,
        minZoom: 1.0,
        maxZoom: 20.0,
        slot: LayerSlot.BOTTOM,
        fillConstructBridgeGuardRail: true,
        fillElevationReference: FillElevationReference.NONE,
        fillSortKey: 1.0,
        fillAntialias: true,
        fillBridgeGuardRailColor: Colors.red.value,
        fillColor: Colors.red.value,
        fillEmissiveStrength: 1.0,
        fillOpacity: 1.0,
        fillOutlineColor: Colors.red.value,
        fillPattern: "abc",
        fillTranslate: [0.0, 1.0],
        fillTranslateAnchor: FillTranslateAnchor.MAP,
        fillTunnelStructureColor: Colors.red.value,
        fillZOffset: 1.0,
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as FillLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.fillConstructBridgeGuardRail, true);
    expect(layer.fillElevationReference, FillElevationReference.NONE);
    expect(layer.fillSortKey, 1.0);
    expect(layer.fillAntialias, true);
    expect(layer.fillBridgeGuardRailColor, Colors.red.value);
    expect(layer.fillColor, Colors.red.value);
    expect(layer.fillEmissiveStrength, 1.0);
    expect(layer.fillOpacity, 1.0);
    expect(layer.fillOutlineColor, Colors.red.value);
    expect(layer.fillPattern, "abc");
    expect(layer.fillTranslate, [0.0, 1.0]);
    expect(layer.fillTranslateAnchor, FillTranslateAnchor.MAP);
    expect(layer.fillTunnelStructureColor, Colors.red.value);
    expect(layer.fillZOffset, 1.0);
  });

  testWidgets('Add FillLayer with expressions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

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
      FillLayer(
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
        fillConstructBridgeGuardRailExpression: ['==', true, true],
        fillElevationReferenceExpression: ['string', 'none'],
        fillSortKeyExpression: ['number', 1.0],
        fillAntialiasExpression: ['==', true, true],
        fillBridgeGuardRailColorExpression: ['rgba', 255, 0, 0, 1],
        fillColorExpression: ['rgba', 255, 0, 0, 1],
        fillEmissiveStrengthExpression: ['number', 1.0],
        fillOpacityExpression: ['number', 1.0],
        fillOutlineColorExpression: ['rgba', 255, 0, 0, 1],
        fillPatternExpression: ['image', "abc"],
        fillTranslateExpression: [
          'literal',
          [0.0, 1.0],
        ],
        fillTranslateAnchorExpression: ['string', 'map'],
        fillTunnelStructureColorExpression: ['rgba', 255, 0, 0, 1],
        fillZOffsetExpression: ['number', 1.0],
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as FillLayer;
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
    expect(layer.fillConstructBridgeGuardRail, true);
    expect(layer.fillElevationReference, FillElevationReference.NONE);
    expect(layer.fillSortKey, 1.0);
    expect(layer.fillAntialias, true);
    expect(layer.fillBridgeGuardRailColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.fillColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.fillEmissiveStrength, 1.0);
    expect(layer.fillOpacity, 1.0);
    expect(layer.fillOutlineColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.fillPatternExpression, ['image', "abc"]);
    expect(layer.fillTranslate, [0.0, 1.0]);
    expect(layer.fillTranslateAnchor, FillTranslateAnchor.MAP);
    expect(layer.fillTunnelStructureColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.fillZOffset, 1.0);
  });
}

// End of generated file.
