import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockAttributionSettingsPlatformInterface
    implements AttributionSettingsPlatformInterface {
  AttributionSettings? lastUpdatedSettings;
  AttributionSettings settingsToReturn = AttributionSettings();
  int getSettingsCallCount = 0;
  int updateSettingsCallCount = 0;

  @override
  Future<AttributionSettings> getSettings() async {
    getSettingsCallCount++;
    return settingsToReturn;
  }

  @override
  Future<void> updateSettings(AttributionSettings settings) async {
    updateSettingsCallCount++;
    lastUpdatedSettings = settings;
  }
}

void main() {
  late MockAttributionSettingsPlatformInterface mockImpl;
  late AttributionSettingsManager attributionSettings;

  setUp(() {
    mockImpl = MockAttributionSettingsPlatformInterface();
    attributionSettings = AttributionSettingsManager(mockImpl);
  });

  group('AttributionSettingsManager', () {
    test('getSettings delegates to interface', () async {
      final expected = AttributionSettings(enabled: true);
      mockImpl.settingsToReturn = expected;

      final result = await attributionSettings.getSettings();

      expect(result, same(expected));
      expect(mockImpl.getSettingsCallCount, 1);
    });

    test('updateSettings delegates to interface', () async {
      final settings = AttributionSettings(
        enabled: true,
        iconColor: 0xFF0000,
      );

      await attributionSettings.updateSettings(settings);

      expect(mockImpl.updateSettingsCallCount, 1);
      expect(mockImpl.lastUpdatedSettings, same(settings));
    });

    test('getSettings can be called multiple times', () async {
      await attributionSettings.getSettings();
      await attributionSettings.getSettings();

      expect(mockImpl.getSettingsCallCount, 2);
    });

    test('updateSettings passes all fields correctly', () async {
      final settings = AttributionSettings(
        enabled: true,
        iconColor: 0xFF0000,
        marginLeft: 10.0,
        marginTop: 20.0,
        marginRight: 30.0,
        marginBottom: 40.0,
        clickable: true,
      );

      await attributionSettings.updateSettings(settings);

      final updated = mockImpl.lastUpdatedSettings!;
      expect(updated.enabled, true);
      expect(updated.iconColor, 0xFF0000);
      expect(updated.marginLeft, 10.0);
      expect(updated.marginTop, 20.0);
      expect(updated.marginRight, 30.0);
      expect(updated.marginBottom, 40.0);
      expect(updated.clickable, true);
    });
  });
}
