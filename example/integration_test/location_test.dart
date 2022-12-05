import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Location is updated puck 2d', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;
    final expression =
        '["interpolate",["exponential",0.5],["zoom"],0.5,["literal",[147518.93133555033,147518.93133555033,147518.93133555033]],22.0,["literal",[0.04973966441190734,0.04973966441190734,0.04973966441190734]]]';

    final ByteData bytes =
        await rootBundle.load('assets/symbols/custom-icon.png');
    final Uint8List list = bytes.buffer.asUint8List();
    final settings = LocationComponentSettings(
        enabled: true,
        showAccuracyRing: true,
        accuracyRingColor: Colors.red.value,
        accuracyRingBorderColor: Colors.black.value,
        pulsingColor: Colors.amber.value,
        pulsingEnabled: true,
        pulsingMaxRadius: 20.0,
        puckBearingEnabled: true,
        layerAbove: "layer-above",
        layerBelow: "layer-below",
        puckBearingSource: PuckBearingSource.COURSE,
        locationPuck: LocationPuck(
            locationPuck2D: LocationPuck2D(
                bearingImage: list,
                topImage: list,
                shadowImage: list,
                scaleExpression: expression)));

    location.updateSettings(settings);

    final updatedSettings = await location.getSettings();
    expect(updatedSettings.enabled, settings.enabled);
    if (Platform.isAndroid) {
      expect(updatedSettings.pulsingEnabled, settings.pulsingEnabled);
      expect(updatedSettings.pulsingMaxRadius, settings.pulsingMaxRadius);
      // expect(updatedSettings.pulsingColor, settings.pulsingColor);
      expect(updatedSettings.layerAbove, settings.layerAbove);
      expect(updatedSettings.layerBelow, settings.layerBelow);
    }
    expect(updatedSettings.puckBearingEnabled, settings.puckBearingEnabled);
    expect(updatedSettings.puckBearingSource, settings.puckBearingSource);
    expect(updatedSettings.showAccuracyRing, settings.showAccuracyRing);
    // expect(updatedSettings.accuracyRingBorderColor,
    //     settings.accuracyRingBorderColor);
    // expect(updatedSettings.accuracyRingColor, settings.accuracyRingColor);
    expect(updatedSettings.locationPuck?.locationPuck2D?.bearingImage,
        settings.locationPuck?.locationPuck2D?.bearingImage);
    expect(updatedSettings.locationPuck?.locationPuck2D?.topImage,
        settings.locationPuck?.locationPuck2D?.bearingImage);
    expect(updatedSettings.locationPuck?.locationPuck2D?.shadowImage,
        settings.locationPuck?.locationPuck2D?.bearingImage);
    expect(updatedSettings.locationPuck?.locationPuck2D?.scaleExpression,
        settings.locationPuck?.locationPuck2D?.scaleExpression);
  });

  testWidgets('Location is updated puck 3d', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;
    final expression =
        '["interpolate",["exponential",0.5],["zoom"],0.5,["literal",[147518.93133555033,147518.93133555033,147518.93133555033]],22.0,["literal",[0.04973966441190734,0.04973966441190734,0.04973966441190734]]]';

    final settings = LocationComponentSettings(
        enabled: true,
        puckBearingSource: PuckBearingSource.COURSE,
        locationPuck: LocationPuck(
            locationPuck3D: LocationPuck3D(
                modelUri:
                    "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",
                position: [1.0, 2.0, 3.0],
                modelOpacity: 1.0,
                modelRotation: [1, 2, 3],
                modelScale: [1.0, 5.0, 3.0],
                modelTranslation: [0.0, 1.0, 2.0],
                modelScaleExpression: expression)));

    location.updateSettings(settings);

    final updatedSettings = await location.getSettings();
    expect(updatedSettings.enabled, settings.enabled);
    if (Platform.isAndroid) {
      expect(updatedSettings.locationPuck?.locationPuck3D?.modelTranslation,
          settings.locationPuck?.locationPuck3D?.modelTranslation);
    }
    expect(updatedSettings.locationPuck?.locationPuck3D?.modelUri,
        settings.locationPuck?.locationPuck3D?.modelUri);
    expect(updatedSettings.locationPuck?.locationPuck3D?.position,
        settings.locationPuck?.locationPuck3D?.position);
    expect(updatedSettings.locationPuck?.locationPuck3D?.modelOpacity,
        settings.locationPuck?.locationPuck3D?.modelOpacity);
    expect(updatedSettings.locationPuck?.locationPuck3D?.modelRotation,
        settings.locationPuck?.locationPuck3D?.modelRotation);
    expect(updatedSettings.locationPuck?.locationPuck3D?.modelScale,
        settings.locationPuck?.locationPuck3D?.modelScale);
    expect(updatedSettings.locationPuck?.locationPuck3D?.modelScaleExpression,
        settings.locationPuck?.locationPuck3D?.modelScaleExpression);
  });
}
