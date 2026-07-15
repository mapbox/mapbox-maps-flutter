import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'empty_map_widget.dart' as app;
import 'utils/image_comparison.dart';

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

    await location.updateSettings(settings);

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
    expect(updatedSettings.accuracyRingBorderColor,
        settings.accuracyRingBorderColor);
    expect(updatedSettings.accuracyRingColor, settings.accuracyRingColor);
    expect(
      await isSameImage(
          list, updatedSettings.locationPuck?.locationPuck2D?.bearingImage),
      isTrue,
    );
    expect(
      await isSameImage(
          list, updatedSettings.locationPuck?.locationPuck2D?.topImage),
      isTrue,
    );
    expect(
      await isSameImage(
          list, updatedSettings.locationPuck?.locationPuck2D?.shadowImage),
      isTrue,
    );
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
                modelScaleExpression: expression,
                modelElevationReference: ModelElevationReference.SEA)));

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
    expect(
        updatedSettings.locationPuck?.locationPuck3D?.modelElevationReference,
        settings.locationPuck?.locationPuck3D?.modelElevationReference);
  });

  testWidgets('location settings are preserved by an empty update',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    final baseline = LocationComponentSettings(
      enabled: true,
      puckBearingEnabled: true,
      puckBearing: PuckBearing.COURSE,
      pulsingEnabled: true,
      showAccuracyRing: true,
      slot: "top",
      locationPuck: LocationPuck(locationPuck2D: LocationPuck2D(opacity: 0.4)),
    );
    await location.updateSettings(baseline);
    var updatedSettings = await location.getSettings();
    expect(updatedSettings.enabled, baseline.enabled);
    expect(updatedSettings.puckBearingEnabled, baseline.puckBearingEnabled);

    await location.updateSettings(LocationComponentSettings());
    updatedSettings = await location.getSettings();
    expect(updatedSettings.enabled, baseline.enabled);
    expect(updatedSettings.puckBearingEnabled, baseline.puckBearingEnabled);
    expect(updatedSettings.puckBearing, baseline.puckBearing);
    expect(updatedSettings.pulsingEnabled, baseline.pulsingEnabled);
    expect(updatedSettings.showAccuracyRing, baseline.showAccuracyRing);
    expect(updatedSettings.slot, baseline.slot);
    expect(
      updatedSettings.locationPuck?.locationPuck2D?.opacity,
      closeTo(0.4, 1e-3),
    );
  });

  testWidgets(
      'location settings are preserved by a partial update that changes an unrelated field',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    final baseline = LocationComponentSettings(
      enabled: true,
      puckBearingEnabled: true,
      puckBearing: PuckBearing.HEADING,
    );
    await location.updateSettings(baseline);

    final partialUpdate =
        LocationComponentSettings(puckBearing: PuckBearing.COURSE);
    await location.updateSettings(partialUpdate);
    final updatedSettings = await location.getSettings();
    expect(updatedSettings.puckBearing, partialUpdate.puckBearing);
    expect(updatedSettings.enabled, baseline.enabled);
    expect(updatedSettings.puckBearingEnabled, baseline.puckBearingEnabled);
  });

  testWidgets(
      'an update that omits locationPuck does not reset the existing puck',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    final baseline = LocationComponentSettings(
      enabled: true,
      locationPuck: LocationPuck(
        locationPuck2D: LocationPuck2D(opacity: 0.7),
      ),
    );
    final baselineOpacity = baseline.locationPuck!.locationPuck2D!.opacity!;
    await location.updateSettings(baseline);
    expect(
      (await location.getSettings()).locationPuck?.locationPuck2D?.opacity,
      closeTo(baselineOpacity, 1e-3),
    );

    final unrelatedUpdate =
        LocationComponentSettings(puckBearing: PuckBearing.HEADING);
    await location.updateSettings(unrelatedUpdate);
    final updatedSettings = await location.getSettings();
    expect(updatedSettings.puckBearing, unrelatedUpdate.puckBearing);
    expect(
      updatedSettings.locationPuck?.locationPuck2D?.opacity,
      closeTo(baselineOpacity, 1e-3),
    );
  });

  testWidgets(
      'requesting DefaultLocationPuck2D resets a customized 2D puck to platform defaults',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await location.updateSettings(LocationComponentSettings(
      enabled: true,
      locationPuck: LocationPuck(locationPuck2D: LocationPuck2D(opacity: 0.4)),
    ));
    expect(
      (await location.getSettings()).locationPuck?.locationPuck2D?.opacity,
      closeTo(0.4, 1e-3),
    );

    await location.updateSettings(LocationComponentSettings(
      locationPuck: LocationPuck(locationPuck2D: DefaultLocationPuck2D()),
    ));
    final reset = await location.getSettings();
    expect(reset.locationPuck?.locationPuck2D?.opacity, closeTo(1.0, 1e-3));
  });

  testWidgets(
      'requesting DefaultLocationPuck2D after a 3D puck still resets correctly',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        locationPuck: LocationPuck(
          locationPuck3D: LocationPuck3D(
            modelUri:
                "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",
          ),
        ),
      ),
    );
    expect(
      (await location.getSettings()).locationPuck?.locationPuck3D?.modelUri,
      isNotNull,
    );

    await location.updateSettings(LocationComponentSettings(
      locationPuck: LocationPuck(locationPuck2D: DefaultLocationPuck2D()),
    ));
    final reset = await location.getSettings();
    expect(reset.locationPuck?.locationPuck3D?.modelUri, isNull);
    expect(reset.locationPuck?.locationPuck2D?.opacity, closeTo(1.0, 1e-3));
  });

  testWidgets(
      'resetting to DefaultLocationPuck2D preserves independently-set pulsing',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
      pulsingColor: Colors.amber.value,
      locationPuck: LocationPuck(locationPuck2D: LocationPuck2D(opacity: 0.4)),
    ));
    expect((await location.getSettings()).pulsingEnabled, isTrue);

    await location.updateSettings(LocationComponentSettings(
      locationPuck: LocationPuck(locationPuck2D: DefaultLocationPuck2D()),
    ));
    final reset = await location.getSettings();
    expect(reset.pulsingEnabled, isTrue);
    expect(reset.locationPuck?.locationPuck2D?.opacity, closeTo(1.0, 1e-3));
  });

  testWidgets(
      'pulsing, accuracy ring and slot update independently of locationPuck',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await location.updateSettings(LocationComponentSettings(
      enabled: true,
      locationPuck: LocationPuck(locationPuck2D: LocationPuck2D(opacity: 0.4)),
    ));

    await location
        .updateSettings(LocationComponentSettings(showAccuracyRing: true));
    await location.updateSettings(LocationComponentSettings(
      pulsingEnabled: true,
      pulsingColor: Colors.amber.value,
    ));
    await location.updateSettings(LocationComponentSettings(slot: "top"));

    final settings = await location.getSettings();
    expect(settings.showAccuracyRing, isTrue);
    expect(settings.pulsingEnabled, isTrue);
    expect(settings.slot, "top");
    expect(settings.locationPuck?.locationPuck2D?.opacity, closeTo(0.4, 1e-3));
  });

  testWidgets(
      'accuracy ring and pulsing updates do not affect an active 3D puck',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        locationPuck: LocationPuck(
          locationPuck3D: LocationPuck3D(
              modelUri:
                  "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf"),
        ),
      ),
    );

    await location
        .updateSettings(LocationComponentSettings(showAccuracyRing: true));
    await location
        .updateSettings(LocationComponentSettings(pulsingEnabled: true));

    final settings = await location.getSettings();
    expect(settings.locationPuck?.locationPuck3D?.modelUri, isNotNull);
  });

  testWidgets('hiding and showing the puck preserves its configuration',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        locationPuck: LocationPuck(
          locationPuck2D: LocationPuck2D(opacity: 0.4),
        ),
      ),
    );

    await location.updateSettings(LocationComponentSettings(enabled: false));
    expect((await location.getSettings()).enabled, isFalse);

    await location.updateSettings(LocationComponentSettings(enabled: true));
    final settings = await location.getSettings();
    expect(settings.enabled, isTrue);
    expect(settings.locationPuck?.locationPuck2D?.opacity, closeTo(0.4, 1e-3));
  });

  testWidgets('configuring the puck while hidden does not make it visible',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await location.updateSettings(LocationComponentSettings(enabled: false));
    await location.updateSettings(
      LocationComponentSettings(
        locationPuck: LocationPuck(
          locationPuck2D: LocationPuck2D(opacity: 0.6),
        ),
      ),
    );

    final settings = await location.getSettings();
    expect(settings.enabled, isFalse);
    expect(settings.locationPuck?.locationPuck2D?.opacity, closeTo(0.6, 1e-3));
  });

  testWidgets(
      'a partial 3D update that omits modelUri keeps the existing model',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        locationPuck: LocationPuck(
          locationPuck3D: LocationPuck3D(
            modelUri:
                "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",
            modelScale: [1.0, 1.0, 1.0],
          ),
        ),
      ),
    );

    await location.updateSettings(LocationComponentSettings(
      locationPuck: LocationPuck(
        locationPuck3D: LocationPuck3D(
          modelScale: [2.0, 2.0, 2.0],
        ),
      ),
    ));

    final settings = await location.getSettings();
    expect(settings.locationPuck?.locationPuck3D?.modelUri, isNotNull);
    if (Platform.isAndroid) {
      expect(
        settings.locationPuck?.locationPuck3D?.modelScale,
        [2.0, 2.0, 2.0],
      );
    }
  });

  testWidgets(
      'configuring a 3D puck for the first time without modelUri throws',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await expectLater(
      location.updateSettings(
        LocationComponentSettings(
          enabled: true,
          locationPuck: LocationPuck(
            locationPuck3D: LocationPuck3D(
              modelScale: [1.0, 1.0, 1.0],
            ),
          ),
        ),
      ),
      throwsA(anything),
    );
  });

  testWidgets(
      'switching between default and custom icon preserves pulsing and accuracy ring',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
      showAccuracyRing: true,
      locationPuck: LocationPuck(locationPuck2D: DefaultLocationPuck2D()),
    ));

    await location.updateSettings(
      LocationComponentSettings(
        locationPuck: LocationPuck(
          locationPuck2D: DefaultLocationPuck2D(),
        ),
      ),
    );
    var settings = await location.getSettings();
    expect(settings.pulsingEnabled, isTrue);
    expect(settings.showAccuracyRing, isTrue);

    await location.updateSettings(
      LocationComponentSettings(
        locationPuck: LocationPuck(
          locationPuck2D: LocationPuck2D(opacity: 0.4),
        ),
      ),
    );
    settings = await location.getSettings();
    expect(settings.pulsingEnabled, isTrue);
    expect(settings.showAccuracyRing, isTrue);
  });

  testWidgets('a 3D puck config survives a detour through a 2D puck',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        locationPuck: LocationPuck(
          locationPuck3D: LocationPuck3D(
            modelUri:
                "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",
            modelScale: [2.0, 5.0, 2.0],
          ),
        ),
      ),
    );

    await location.updateSettings(LocationComponentSettings(
      locationPuck: LocationPuck(locationPuck2D: LocationPuck2D(opacity: 0.4)),
    ));

    await location.updateSettings(LocationComponentSettings(
      locationPuck: LocationPuck(locationPuck3D: LocationPuck3D()),
    ));

    final settings = await location.getSettings();
    expect(settings.locationPuck?.locationPuck3D?.modelUri, isNotNull);
    if (Platform.isAndroid) {
      expect(
        settings.locationPuck?.locationPuck3D?.modelScale,
        [2.0, 5.0, 2.0],
      );
    }
  });

  testWidgets('a 2D puck config survives a detour through a 3D puck',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await location.updateSettings(LocationComponentSettings(
      enabled: true,
      locationPuck: LocationPuck(locationPuck2D: LocationPuck2D(opacity: 0.4)),
    ));

    await location.updateSettings(
      LocationComponentSettings(
        locationPuck: LocationPuck(
          locationPuck3D: LocationPuck3D(
              modelUri:
                  "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf"),
        ),
      ),
    );

    await location.updateSettings(LocationComponentSettings(
      locationPuck: LocationPuck(locationPuck2D: LocationPuck2D()),
    ));

    final settings = await location.getSettings();
    expect(settings.locationPuck?.locationPuck3D?.modelUri, isNull);
    expect(settings.locationPuck?.locationPuck2D?.opacity, closeTo(0.4, 1e-3));
  });

  testWidgets('pulsing and accuracy ring survive a detour through a 3D puck',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final location = mapboxMap.location;

    await location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
      showAccuracyRing: true,
      locationPuck: LocationPuck(locationPuck2D: LocationPuck2D(opacity: 0.4)),
    ));

    await location.updateSettings(
      LocationComponentSettings(
        locationPuck: LocationPuck(
          locationPuck3D: LocationPuck3D(
              modelUri:
                  "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf"),
        ),
      ),
    );

    await location.updateSettings(LocationComponentSettings(
      locationPuck: LocationPuck(locationPuck2D: DefaultLocationPuck2D()),
    ));

    final settings = await location.getSettings();
    expect(settings.locationPuck?.locationPuck3D?.modelUri, isNull);
    expect(settings.pulsingEnabled, isTrue);
    expect(settings.showAccuracyRing, isTrue);
  });
}
