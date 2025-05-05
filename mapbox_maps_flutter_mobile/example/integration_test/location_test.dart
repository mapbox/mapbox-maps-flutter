import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Location is updated puck 2d', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;
    final expression = '["interpolate",["linear"],["zoom"],8,0,24,1]';

    if (Platform.isAndroid) {
      await mapboxMap.style.addLayer(SymbolLayer(
        id: 'layer-above',
        sourceId: 'source',
      ));
      await mapboxMap.style.addLayer(SymbolLayer(
        id: 'layer-below',
        sourceId: 'source',
      ));
    }

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
        puckBearing: PuckBearing.COURSE,
        locationPuck: LocationPuck(
            locationPuck2D: LocationPuck2D(
                bearingImage: list,
                topImage: list,
                shadowImage: list,
                scaleExpression: expression,
                opacity: 0.5)));

    location.updateSettings(settings);

    final updatedSettings = await location.getSettings();
    expect(updatedSettings.enabled, settings.enabled);
    expect(updatedSettings.pulsingEnabled, settings.pulsingEnabled);
    expect(updatedSettings.pulsingMaxRadius, settings.pulsingMaxRadius);
    expect(updatedSettings.pulsingColor, settings.pulsingColor);
    if (Platform.isAndroid) {
      expect(updatedSettings.layerAbove, settings.layerAbove);
      expect(updatedSettings.layerBelow, settings.layerBelow);
    }
    expect(updatedSettings.puckBearingEnabled, settings.puckBearingEnabled);
    expect(updatedSettings.puckBearing, settings.puckBearing);
    expect(updatedSettings.showAccuracyRing, settings.showAccuracyRing);
    // FIXME bitmaps are decoded incorrectly for some reason
    expect(updatedSettings.accuracyRingBorderColor,
        settings.accuracyRingBorderColor);
    expect(updatedSettings.accuracyRingColor, settings.accuracyRingColor);
    // expect(updatedSettings.locationPuck?.locationPuck2D?.bearingImage,
    //     settings.locationPuck?.locationPuck2D?.bearingImage);
    // expect(updatedSettings.locationPuck?.locationPuck2D?.topImage,
    //     settings.locationPuck?.locationPuck2D?.bearingImage);
    // expect(updatedSettings.locationPuck?.locationPuck2D?.shadowImage,
    //     settings.locationPuck?.locationPuck2D?.bearingImage);
    expect(updatedSettings.locationPuck?.locationPuck2D?.scaleExpression,
        settings.locationPuck?.locationPuck2D?.scaleExpression);
    expect(updatedSettings.locationPuck?.locationPuck2D?.opacity,
        settings.locationPuck?.locationPuck2D?.opacity);
  });

  testWidgets('Location is updated puck 3d', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    if (Platform.isAndroid) {
      await mapboxMap.style.addLayer(SymbolLayer(
        id: 'layer-above',
        sourceId: 'source',
      ));
      await mapboxMap.style.addLayer(SymbolLayer(
        id: 'layer-below',
        sourceId: 'source',
      ));
    }

    final location = mapboxMap.location;
    final expression =
        '["interpolate",["exponential",0.5],["zoom"],0.5,["literal",[1,1,1]],22,["literal",[2,2,2]]]';

    final settings = LocationComponentSettings(
        enabled: true,
        puckBearing: PuckBearing.COURSE,
        locationPuck: LocationPuck(
            locationPuck3D: LocationPuck3D(
                modelUri:
                    "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",
                position: [1.0, 2.0, 3.0],
                modelOpacity: 0.5,
                modelRotation: [1.0, 2.0, 3.0],
                modelScale: [1.0, 5.0, 3.0],
                modelTranslation: [0.0, 1.0, 2.0],
                modelScaleExpression: expression)));

    await location.updateSettings(settings);

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
    // on iOS scale and scale expression are mutually exclusive
    if (Platform.isAndroid) {
      expect(updatedSettings.locationPuck?.locationPuck3D?.modelScale,
          settings.locationPuck?.locationPuck3D?.modelScale);
    }
    expect(updatedSettings.locationPuck?.locationPuck3D?.modelScaleExpression,
        settings.locationPuck?.locationPuck3D?.modelScaleExpression);
  });
}
