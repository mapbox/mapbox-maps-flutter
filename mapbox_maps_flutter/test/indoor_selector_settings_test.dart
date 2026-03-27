import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockIndoorSelectorSettingsPlatformInterface
    implements IndoorSelectorSettingsPlatformInterface {
  IndoorSelectorSettings? lastUpdatedSettings;
  IndoorSelectorSettings settingsToReturn = IndoorSelectorSettings();
  int getSettingsCallCount = 0;
  int updateSettingsCallCount = 0;

  @override
  Future<IndoorSelectorSettings> getSettings() async {
    getSettingsCallCount++;
    return settingsToReturn;
  }

  @override
  Future<void> updateSettings(IndoorSelectorSettings settings) async {
    updateSettingsCallCount++;
    lastUpdatedSettings = settings;
  }
}

void main() {
  late MockIndoorSelectorSettingsPlatformInterface mockImpl;
  late IndoorSelectorSettingsManager indoorSelectorSettings;

  setUp(() {
    mockImpl = MockIndoorSelectorSettingsPlatformInterface();
    indoorSelectorSettings = IndoorSelectorSettingsManager(mockImpl);
  });

  group('IndoorSelectorSettingsManager', () {
    test('getSettings delegates to interface', () async {
      final expected = IndoorSelectorSettings(enabled: true);
      mockImpl.settingsToReturn = expected;

      final result = await indoorSelectorSettings.getSettings();

      expect(result, same(expected));
      expect(mockImpl.getSettingsCallCount, 1);
    });

    test('updateSettings delegates to interface', () async {
      final settings = IndoorSelectorSettings(
        enabled: true,
        marginLeft: 10.0,
      );

      await indoorSelectorSettings.updateSettings(settings);

      expect(mockImpl.updateSettingsCallCount, 1);
      expect(mockImpl.lastUpdatedSettings, same(settings));
    });

    test('getSettings can be called multiple times', () async {
      await indoorSelectorSettings.getSettings();
      await indoorSelectorSettings.getSettings();

      expect(mockImpl.getSettingsCallCount, 2);
    });

    test('updateSettings passes all fields correctly', () async {
      final settings = IndoorSelectorSettings(
        enabled: true,
        marginLeft: 10.0,
        marginTop: 20.0,
        marginRight: 30.0,
        marginBottom: 40.0,
      );

      await indoorSelectorSettings.updateSettings(settings);

      final updated = mockImpl.lastUpdatedSettings!;
      expect(updated.enabled, true);
      expect(updated.marginLeft, 10.0);
      expect(updated.marginTop, 20.0);
      expect(updated.marginRight, 30.0);
      expect(updated.marginBottom, 40.0);
    });
  });
}
