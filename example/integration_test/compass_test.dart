import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'empty_map_widget.dart' as app;
import 'utils/image_comparison.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Compass settings', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final compass = mapboxMap.compass;
    final ByteData bytes =
        await rootBundle.load('assets/symbols/custom-icon.png');
    final Uint8List iconData = bytes.buffer.asUint8List();
    var settings = CompassSettings(
      enabled: true,
      position: OrnamentPosition.TOP_LEFT,
      marginLeft: 1,
      marginTop: 2,
      marginRight: 3,
      marginBottom: 4,
      opacity: 0.5,
      rotation: 10,
      visibility: true,
      fadeWhenFacingNorth: true,
      clickable: true,
      image: iconData,
    );
    await compass.updateSettings(settings);
    var updatedSettings = await compass.getSettings();
    expect(updatedSettings.position, OrnamentPosition.TOP_LEFT);
    expect(updatedSettings.fadeWhenFacingNorth, true);
    expect(updatedSettings.visibility, true);
    expect(updatedSettings.enabled, true);

    expect(
      updatedSettings.marginLeft,
      1,
      reason: 'marginLeft should be preserved as it is active in TOP_LEFT',
    );
    expect(
      updatedSettings.marginBottom,
      4,
      reason:
          'marginBottom should be preserved even though it is not active in TOP_LEFT',
    );
    expect(
      updatedSettings.marginTop,
      2,
      reason: 'marginTop should be preserved as it is active in TOP_LEFT',
    );
    expect(
      updatedSettings.marginRight,
      3,
      reason:
          'marginRight should be preserved even though it is not active in TOP_LEFT',
    );
    if (Platform.isAndroid) {
      expect(updatedSettings.clickable, true);
      expect(updatedSettings.opacity, 0.5);
      expect(updatedSettings.rotation, 10);
    }
    expect(await isSameImage(iconData, updatedSettings.image), isTrue);
  });

  testWidgets('getSettings enabled reflects a disabled compass',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final compass = mapboxMap.compass;

    await compass.updateSettings(CompassSettings(enabled: true));
    expect((await compass.getSettings()).enabled, isTrue);

    await compass.updateSettings(CompassSettings(enabled: false));
    expect((await compass.getSettings()).enabled, isFalse);
  });

  testWidgets('margins are independently tracked across position changes',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final compass = mapboxMap.compass;

    await compass.updateSettings(CompassSettings(
      position: OrnamentPosition.BOTTOM_LEFT,
      marginLeft: 10,
      marginRight: 20,
      marginTop: 30,
      marginBottom: 40,
    ));

    await compass.updateSettings(
      CompassSettings(position: OrnamentPosition.TOP_RIGHT),
    );

    final settings = await compass.getSettings();
    expect(settings.marginRight, 20);
    expect(settings.marginTop, 30);
    expect(
      settings.marginLeft,
      10,
      reason:
          'marginLeft should be preserved even though it is not active in TOP_RIGHT',
    );
    expect(
      settings.marginBottom,
      40,
      reason:
          'marginBottom should be preserved even though it is not active in TOP_RIGHT',
    );
  });

  // Regression test for https://github.com/mapbox/mapbox-maps-flutter/issues/602
  // On iOS `fadeWhenFacingNorth` was ignored unless `enabled` was also passed,
  // so it must be applicable on its own and stay consistent with Android.
  testWidgets('fadeWhenFacingNorth applies without enabled',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final compass = mapboxMap.compass;

    // Start from a known visible + fading state.
    await compass.updateSettings(
        CompassSettings(enabled: true, fadeWhenFacingNorth: true));
    expect((await compass.getSettings()).fadeWhenFacingNorth, true);
    expect((await compass.getSettings()).visibility, true);

    // Passing only `fadeWhenFacingNorth: false` must stop the fade (iOS:
    // .visible) while keeping the compass visible.
    await compass.updateSettings(CompassSettings(fadeWhenFacingNorth: false));
    var updatedSettings = await compass.getSettings();
    expect(updatedSettings.fadeWhenFacingNorth, false);
    expect(updatedSettings.visibility, true);

    // Passing only `fadeWhenFacingNorth: true` must re-enable the fade (iOS:
    // .adaptive) without hiding the compass.
    await compass.updateSettings(CompassSettings(fadeWhenFacingNorth: true));
    updatedSettings = await compass.getSettings();
    expect(updatedSettings.fadeWhenFacingNorth, true);
    expect(updatedSettings.visibility, true);
  });

  testWidgets('position and margins are preserved by an empty update',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final compass = mapboxMap.compass;

    final baseline = CompassSettings(
      position: OrnamentPosition.BOTTOM_LEFT,
      marginLeft: 11,
      marginBottom: 22,
    );
    await compass.updateSettings(baseline);
    expect((await compass.getSettings()).position, baseline.position);

    await compass.updateSettings(CompassSettings());
    final updatedSettings = await compass.getSettings();
    expect(updatedSettings.position, baseline.position);
    expect(updatedSettings.marginLeft, baseline.marginLeft);
    expect(updatedSettings.marginBottom, baseline.marginBottom);
  });

  testWidgets(
      'position and margins are preserved by a partial update that changes an unrelated field',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final compass = mapboxMap.compass;

    final baseline = CompassSettings(
      position: OrnamentPosition.BOTTOM_LEFT,
      marginLeft: 11,
      marginBottom: 22,
      fadeWhenFacingNorth: false,
    );
    await compass.updateSettings(baseline);

    final partialUpdate = CompassSettings(fadeWhenFacingNorth: true);
    await compass.updateSettings(partialUpdate);
    final updatedSettings = await compass.getSettings();
    expect(
      updatedSettings.fadeWhenFacingNorth,
      partialUpdate.fadeWhenFacingNorth,
    );
    expect(updatedSettings.position, baseline.position);
    expect(updatedSettings.marginLeft, baseline.marginLeft);
    expect(updatedSettings.marginBottom, baseline.marginBottom);
  });
}
