// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';
import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('Logo settings', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    final logo = mapboxMap.logo;
    var settings = LogoSettings(
      enabled: false,
      position: OrnamentPosition.BOTTOM_LEFT,
      marginLeft: 1,
      marginTop: 2,
      marginRight: 3,
      marginBottom: 4,
    );
    await logo.updateSettings(settings);
    var getSettings = await logo.getSettings();
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
  });

  patrolTest(
    'margins are independently tracked across position changes',
    skip: kIsWeb,
    ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      final logo = mapboxMap.logo;

      await logo.updateSettings(
        LogoSettings(
          position: OrnamentPosition.BOTTOM_LEFT,
          marginLeft: 10,
          marginRight: 20,
          marginTop: 30,
          marginBottom: 40,
        ),
      );

      await logo.updateSettings(
        LogoSettings(position: OrnamentPosition.TOP_RIGHT),
      );

      final settings = await logo.getSettings();
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
      expect(
        settings.marginTop,
        30,
        reason: 'marginTop should be preserved as it is active in TOP_RIGHT',
      );
      expect(
        settings.marginRight,
        20,
        reason: 'marginRight should be preserved as it is active in TOP_RIGHT',
      );
    },
  );

  patrolTest(
    'enabled, position and margins are preserved by an empty update',
    skip: kIsWeb,
    ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      final logo = mapboxMap.logo;

      final baseline = LogoSettings(
        enabled: false,
        position: OrnamentPosition.TOP_RIGHT,
        marginRight: 11,
        marginTop: 22,
      );
      await logo.updateSettings(baseline);
      var updatedSettings = await logo.getSettings();
      expect(updatedSettings.enabled, baseline.enabled);
      expect(updatedSettings.position, baseline.position);

      await logo.updateSettings(LogoSettings());
      updatedSettings = await logo.getSettings();
      expect(updatedSettings.enabled, baseline.enabled);
      expect(updatedSettings.position, baseline.position);
      expect(updatedSettings.marginRight, baseline.marginRight);
      expect(updatedSettings.marginTop, baseline.marginTop);
    },
  );

  patrolTest(
    'enabled and position are preserved by a partial update that only changes a margin',
    skip: kIsWeb,
    ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      final logo = mapboxMap.logo;

      final baseline = LogoSettings(
        enabled: false,
        position: OrnamentPosition.TOP_RIGHT,
        marginRight: 11,
        marginTop: 22,
      );
      await logo.updateSettings(baseline);

      final partialUpdate = LogoSettings(marginRight: 99);
      await logo.updateSettings(partialUpdate);
      final updatedSettings = await logo.getSettings();
      expect(updatedSettings.marginRight, partialUpdate.marginRight);
      expect(updatedSettings.enabled, baseline.enabled);
      expect(updatedSettings.position, baseline.position);
      expect(updatedSettings.marginTop, baseline.marginTop);
    },
  );
}
