// This file is generated.
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add LocationIndicatorLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(LocationIndicatorLayer(
      id: 'layer',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      accuracyRadius: 1.0,
      accuracyRadiusBorderColor: Colors.red.value,
      accuracyRadiusColor: Colors.red.value,
      bearing: 1.0,
      bearingImage: "abc",
      bearingImageSize: 1.0,
      emphasisCircleColor: Colors.red.value,
      emphasisCircleGlowRange: [0.0, 1.0],
      emphasisCircleRadius: 1.0,
      imagePitchDisplacement: 1.0,
      location: [0.0, 1.0, 2.0],
      locationIndicatorOpacity: 1.0,
      perspectiveCompensation: 1.0,
      shadowImage: "abc",
      shadowImageSize: 1.0,
      topImage: "abc",
      topImageSize: 1.0,
    ));
    var layer =
        await mapboxMap.style.getLayer('layer') as LocationIndicatorLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.accuracyRadius, 1.0);
    expect(layer.accuracyRadiusBorderColor, Colors.red.value);
    expect(layer.accuracyRadiusColor, Colors.red.value);
    expect(layer.bearing, 1.0);
    expect(layer.bearingImage, "abc");
    expect(layer.bearingImageSize, 1.0);
    expect(layer.emphasisCircleColor, Colors.red.value);
    expect(layer.emphasisCircleGlowRange, [0.0, 1.0]);
    expect(layer.emphasisCircleRadius, 1.0);
    expect(layer.imagePitchDisplacement, 1.0);
    expect(layer.location, [0.0, 1.0, 2.0]);
    expect(layer.locationIndicatorOpacity, 1.0);
    expect(layer.perspectiveCompensation, 1.0);
    expect(layer.shadowImage, "abc");
    expect(layer.shadowImageSize, 1.0);
    expect(layer.topImage, "abc");
    expect(layer.topImageSize, 1.0);
  });

  testWidgets('Add LocationIndicatorLayer with expressions',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(LocationIndicatorLayer(
      id: 'layer',
      visibilityExpression: ['string', 'none'],
      filter: [
        "==",
        ["get", "type"],
        "Feature"
      ],
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      accuracyRadiusExpression: ['number', 1.0],
      accuracyRadiusBorderColorExpression: ['rgba', 255, 0, 0, 1],
      accuracyRadiusColorExpression: ['rgba', 255, 0, 0, 1],
      bearingExpression: ['number', 1.0],
      bearingImageExpression: ['image', "abc"],
      bearingImageSizeExpression: ['number', 1.0],
      emphasisCircleColorExpression: ['rgba', 255, 0, 0, 1],
      emphasisCircleGlowRangeExpression: [
        'literal',
        [0.0, 1.0]
      ],
      emphasisCircleRadiusExpression: ['number', 1.0],
      imagePitchDisplacementExpression: ['number', 1.0],
      locationExpression: [
        'literal',
        [0.0, 1.0, 2.0]
      ],
      locationIndicatorOpacityExpression: ['number', 1.0],
      perspectiveCompensationExpression: ['number', 1.0],
      shadowImageExpression: ['image', "abc"],
      shadowImageSizeExpression: ['number', 1.0],
      topImageExpression: ['image', "abc"],
      topImageSizeExpression: ['number', 1.0],
    ));
    var layer =
        await mapboxMap.style.getLayer('layer') as LocationIndicatorLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.filter, [
      "==",
      ["get", "type"],
      "Feature"
    ]);
    expect(layer.accuracyRadius, 1.0);
    expect(layer.accuracyRadiusBorderColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.accuracyRadiusColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.bearing, 1.0);
    expect(layer.bearingImageExpression, ['image', "abc"]);
    expect(layer.bearingImageSize, 1.0);
    expect(layer.emphasisCircleColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.emphasisCircleGlowRange, [0.0, 1.0]);
    expect(layer.emphasisCircleRadius, 1.0);
    expect(layer.imagePitchDisplacement, 1.0);
    expect(layer.location, [0.0, 1.0, 2.0]);
    expect(layer.locationIndicatorOpacity, 1.0);
    expect(layer.perspectiveCompensation, 1.0);
    expect(layer.shadowImageExpression, ['image', "abc"]);
    expect(layer.shadowImageSize, 1.0);
    expect(layer.topImageExpression, ['image', "abc"]);
    expect(layer.topImageSize, 1.0);
  });
}
// End of generated file.
