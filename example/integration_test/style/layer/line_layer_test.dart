// This file is generated.
import 'dart:convert';
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add LineLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    var line =
        LineString(coordinates: [Position(1.0, 2.0), Position(10.0, 20.0)]);
    await mapboxMap.style
        .addSource(GeoJsonSource(id: "source", data: json.encode(line)));

    await mapboxMap.style.addLayer(LineLayer(
      id: 'layer',
      sourceId: 'source',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      lineCap: LineCap.BUTT,
      lineJoin: LineJoin.BEVEL,
      lineMiterLimit: 1.0,
      lineRoundLimit: 1.0,
      lineSortKey: 1.0,
      lineZOffset: 1.0,
      lineBlur: 1.0,
      lineBorderColor: Colors.red.value,
      lineBorderWidth: 1.0,
      lineColor: Colors.red.value,
      lineDasharray: [1.0, 2.0],
      lineDepthOcclusionFactor: 1.0,
      lineEmissiveStrength: 1.0,
      lineGapWidth: 1.0,
      lineGradient: Colors.red.value,
      lineOcclusionOpacity: 1.0,
      lineOffset: 1.0,
      lineOpacity: 1.0,
      linePattern: "abc",
      lineTranslate: [0.0, 1.0],
      lineTranslateAnchor: LineTranslateAnchor.MAP,
      lineTrimColor: Colors.red.value,
      lineTrimFadeRange: [0.0, 1.0],
      lineTrimOffset: [0.0, 1.0],
      lineWidth: 1.0,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as LineLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.lineCap, LineCap.BUTT);
    expect(layer.lineJoin, LineJoin.BEVEL);
    expect(layer.lineMiterLimit, 1.0);
    expect(layer.lineRoundLimit, 1.0);
    expect(layer.lineSortKey, 1.0);
    expect(layer.lineZOffset, 1.0);
    expect(layer.lineBlur, 1.0);
    expect(layer.lineBorderColor, Colors.red.value);
    expect(layer.lineBorderWidth, 1.0);
    expect(layer.lineColor, Colors.red.value);
    expect(layer.lineDasharray, [1.0, 2.0]);
    expect(layer.lineDepthOcclusionFactor, 1.0);
    expect(layer.lineEmissiveStrength, 1.0);
    expect(layer.lineGapWidth, 1.0);
    expect(layer.lineGradient, Colors.red.value);
    expect(layer.lineOcclusionOpacity, 1.0);
    expect(layer.lineOffset, 1.0);
    expect(layer.lineOpacity, 1.0);
    expect(layer.linePattern, "abc");
    expect(layer.lineTranslate, [0.0, 1.0]);
    expect(layer.lineTranslateAnchor, LineTranslateAnchor.MAP);
    expect(layer.lineTrimColor, Colors.red.value);
    expect(layer.lineTrimFadeRange, [0.0, 1.0]);
    expect(layer.lineTrimOffset, [0.0, 1.0]);
    expect(layer.lineWidth, 1.0);
  });

  testWidgets('Add LineLayer with expressions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    final line =
        LineString(coordinates: [Position(1.0, 2.0), Position(10.0, 20.0)]);
    await mapboxMap.style
        .addSource(GeoJsonSource(id: "source", data: json.encode(line)));

    await mapboxMap.style.addLayer(LineLayer(
      id: 'layer',
      sourceId: 'source',
      visibilityExpression: ['string', 'none'],
      filter: [
        "==",
        ["get", "type"],
        "Feature"
      ],
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      lineCapExpression: ['string', 'butt'],
      lineJoinExpression: ['string', 'bevel'],
      lineMiterLimitExpression: ['number', 1.0],
      lineRoundLimitExpression: ['number', 1.0],
      lineSortKeyExpression: ['number', 1.0],
      lineZOffsetExpression: ['number', 1.0],
      lineBlurExpression: ['number', 1.0],
      lineBorderColorExpression: ['rgba', 255, 0, 0, 1],
      lineBorderWidthExpression: ['number', 1.0],
      lineColorExpression: ['rgba', 255, 0, 0, 1],
      lineDasharrayExpression: [
        'literal',
        [1.0, 2.0]
      ],
      lineDepthOcclusionFactorExpression: ['number', 1.0],
      lineEmissiveStrengthExpression: ['number', 1.0],
      lineGapWidthExpression: ['number', 1.0],
      lineGradientExpression: ['rgba', 255, 0, 0, 1],
      lineOcclusionOpacityExpression: ['number', 1.0],
      lineOffsetExpression: ['number', 1.0],
      lineOpacityExpression: ['number', 1.0],
      linePatternExpression: ['image', "abc"],
      lineTranslateExpression: [
        'literal',
        [0.0, 1.0]
      ],
      lineTranslateAnchorExpression: ['string', 'map'],
      lineTrimColorExpression: ['rgba', 255, 0, 0, 1],
      lineTrimFadeRangeExpression: [
        'literal',
        [0.0, 1.0]
      ],
      lineTrimOffsetExpression: [
        'literal',
        [0.0, 1.0]
      ],
      lineWidthExpression: ['number', 1.0],
    ));
    var layer = await mapboxMap.style.getLayer('layer') as LineLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.filter, [
      "==",
      ["get", "type"],
      "Feature"
    ]);
    expect(layer.lineCap, LineCap.BUTT);
    expect(layer.lineJoin, LineJoin.BEVEL);
    expect(layer.lineMiterLimit, 1.0);
    expect(layer.lineRoundLimit, 1.0);
    expect(layer.lineSortKey, 1.0);
    expect(layer.lineZOffset, 1.0);
    expect(layer.lineBlur, 1.0);
    expect(layer.lineBorderColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.lineBorderWidth, 1.0);
    expect(layer.lineColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.lineDasharray, [1.0, 2.0]);
    expect(layer.lineDepthOcclusionFactor, 1.0);
    expect(layer.lineEmissiveStrength, 1.0);
    expect(layer.lineGapWidth, 1.0);
    expect(layer.lineGradientExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.lineOcclusionOpacity, 1.0);
    expect(layer.lineOffset, 1.0);
    expect(layer.lineOpacity, 1.0);
    expect(layer.linePatternExpression, ['image', "abc"]);
    expect(layer.lineTranslate, [0.0, 1.0]);
    expect(layer.lineTranslateAnchor, LineTranslateAnchor.MAP);
    expect(layer.lineTrimColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.lineTrimFadeRange, [0.0, 1.0]);
    expect(layer.lineTrimOffset, [0.0, 1.0]);
    expect(layer.lineWidth, 1.0);
  });
}
// End of generated file.
