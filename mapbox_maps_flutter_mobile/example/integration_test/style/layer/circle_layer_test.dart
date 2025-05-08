// This file is generated.
import 'dart:convert';
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add CircleLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    final point = Point(coordinates: Position(-77.032667, 38.913175));
    await mapboxMap.style
        .addSource(GeoJsonSource(id: "source", data: json.encode(point)));

    await mapboxMap.style.addLayer(CircleLayer(
      id: 'layer',
      sourceId: 'source',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
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
    ));
    var layer = await mapboxMap.style.getLayer('layer') as CircleLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
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

  testWidgets('Add CircleLayer with expressions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    final point = Point(coordinates: Position(-77.032667, 38.913175));
    await mapboxMap.style
        .addSource(GeoJsonSource(id: "source", data: json.encode(point)));

    await mapboxMap.style.addLayer(CircleLayer(
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
        [0.0, 1.0]
      ],
      circleTranslateAnchorExpression: ['string', 'map'],
    ));
    var layer = await mapboxMap.style.getLayer('layer') as CircleLayer;
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
