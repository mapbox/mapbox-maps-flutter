import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Compass settings', skip: kIsWeb, (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final compass = mapboxMap.compass;
    final ByteData bytes = await rootBundle.load(
      'assets/symbols/custom-icon.png',
    );
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
    if (Platform.isIOS) {
      expect(updatedSettings.marginLeft, 1);
      expect(updatedSettings.marginTop, 2);
    } else {
      expect(updatedSettings.enabled, true);
      expect(updatedSettings.marginLeft, 1);
      expect(updatedSettings.marginTop, 2);
      expect(updatedSettings.marginRight, 3);
      expect(updatedSettings.marginBottom, 4);
      expect(updatedSettings.clickable, true);
      expect(updatedSettings.opacity, 0.5);
      expect(updatedSettings.rotation, 10);
      expect(updatedSettings.clickable, true);
      // FIXME failing test
      // expect(updatedSettings.image, iconData);
    }
  });

  // Regression test for https://github.com/mapbox/mapbox-maps-flutter/issues/602
  // On iOS `fadeWhenFacingNorth` was ignored unless `enabled` was also passed,
  // so it must be applicable on its own and stay consistent with Android.
  testWidgets('fadeWhenFacingNorth applies without enabled',
      skip: kIsWeb,
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
}
