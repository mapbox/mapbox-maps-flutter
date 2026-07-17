// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:mapbox_maps_flutter_examples/platform.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';
import 'empty_map_widget.dart' as app;

// Skipped on Android: MAPBOX_INDOOR_SELECTOR_PLUGIN_ID is not part of
// MapInitOptions.defaultPluginList and the Flutter platform view factory
// doesn't register it either, so `mapView.indoorSelector` throws a
// NullPointerException there.
final skipTests = kIsWeb || isAndroid;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('IndoorSelector settings', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    final indoorSelector = mapboxMap.indoorSelector;
    var settings = IndoorSelectorSettings(
      enabled: false,
      position: OrnamentPosition.BOTTOM_LEFT,
      marginLeft: 1,
      marginTop: 2,
      marginRight: 3,
      marginBottom: 4,
    );
    await indoorSelector.updateSettings(settings);
    var getSettings = await indoorSelector.getSettings();
    expect(getSettings.position, OrnamentPosition.BOTTOM_LEFT);
    expect(getSettings.enabled, isFalse);
    expect(
      getSettings.marginLeft,
      1,
      reason: 'marginLeft should be preserved as it is active in BOTTOM_LEFT',
    );
    expect(
      getSettings.marginBottom,
      4,
      reason: 'marginBottom should be preserved as it is active in BOTTOM_LEFT',
    );
    expect(
      getSettings.marginTop,
      2,
      reason:
          'marginTop should be preserved even though it is not active in BOTTOM_LEFT',
    );
    expect(
      getSettings.marginRight,
      3,
      reason:
          'marginRight should be preserved even though it is not active in BOTTOM_LEFT',
    );
  }, skip: skipTests);

  patrolTest('margins are independently tracked across position changes', (
    $,
  ) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    final indoorSelector = mapboxMap.indoorSelector;

    await indoorSelector.updateSettings(
      IndoorSelectorSettings(
        position: OrnamentPosition.BOTTOM_LEFT,
        marginLeft: 10,
        marginRight: 20,
        marginTop: 30,
        marginBottom: 40,
      ),
    );

    await indoorSelector.updateSettings(
      IndoorSelectorSettings(position: OrnamentPosition.TOP_RIGHT),
    );

    final settings = await indoorSelector.getSettings();
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
  }, skip: skipTests);

  patrolTest(
    'enabled, position and margins are preserved by an empty update',
    ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      final indoorSelector = mapboxMap.indoorSelector;

      final baseline = IndoorSelectorSettings(
        enabled: false,
        position: OrnamentPosition.TOP_RIGHT,
        marginRight: 11,
        marginTop: 22,
      );
      await indoorSelector.updateSettings(baseline);
      var updatedSettings = await indoorSelector.getSettings();
      expect(updatedSettings.enabled, baseline.enabled);
      expect(updatedSettings.position, baseline.position);

      await indoorSelector.updateSettings(IndoorSelectorSettings());
      updatedSettings = await indoorSelector.getSettings();
      expect(updatedSettings.enabled, baseline.enabled);
      expect(updatedSettings.position, baseline.position);
      expect(updatedSettings.marginRight, baseline.marginRight);
      expect(updatedSettings.marginTop, baseline.marginTop);
    },
    skip: skipTests,
  );

  patrolTest(
    'enabled and position are preserved by a partial update that only changes a margin',
    ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      final indoorSelector = mapboxMap.indoorSelector;

      final baseline = IndoorSelectorSettings(
        enabled: false,
        position: OrnamentPosition.TOP_RIGHT,
        marginRight: 11,
        marginTop: 22,
      );
      await indoorSelector.updateSettings(baseline);

      final partialUpdate = IndoorSelectorSettings(marginRight: 99);
      await indoorSelector.updateSettings(partialUpdate);
      final updatedSettings = await indoorSelector.getSettings();
      expect(updatedSettings.marginRight, partialUpdate.marginRight);
      expect(updatedSettings.enabled, baseline.enabled);
      expect(updatedSettings.position, baseline.position);
      expect(updatedSettings.marginTop, baseline.marginTop);
    },
    skip: skipTests,
  );
}
