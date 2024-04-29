// This file is generated.
import 'dart:convert';
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

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
      bearingImage: "abc",
      shadowImage: "abc",
      topImage: "abc",
      accuracyRadius: 1.0,
      accuracyRadiusBorderColor: Colors.red.value,
      accuracyRadiusColor: Colors.red.value,
      bearing: 1.0,
      bearingImageSize: 1.0,
      emphasisCircleColor: Colors.red.value,
      emphasisCircleRadius: 1.0,
      imagePitchDisplacement: 1.0,
      location: [0.0, 1.0, 2.0],
      locationIndicatorOpacity: 1.0,
      perspectiveCompensation: 1.0,
      shadowImageSize: 1.0,
      topImageSize: 1.0,
    ));
    var layer =
        await mapboxMap.style.getLayer('layer') as LocationIndicatorLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.bearingImage, "abc");
    expect(layer.shadowImage, "abc");
    expect(layer.topImage, "abc");
    expect(layer.accuracyRadius, 1.0);
    expect(layer.accuracyRadiusBorderColor, Colors.red.value);
    expect(layer.accuracyRadiusColor, Colors.red.value);
    expect(layer.bearing, 1.0);
    expect(layer.bearingImageSize, 1.0);
    expect(layer.emphasisCircleColor, Colors.red.value);
    expect(layer.emphasisCircleRadius, 1.0);
    expect(layer.imagePitchDisplacement, 1.0);
    expect(layer.location, [0.0, 1.0, 2.0]);
    expect(layer.locationIndicatorOpacity, 1.0);
    expect(layer.perspectiveCompensation, 1.0);
    expect(layer.shadowImageSize, 1.0);
    expect(layer.topImageSize, 1.0);
  });
}
// End of generated file.
