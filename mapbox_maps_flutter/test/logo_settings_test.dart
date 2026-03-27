import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockLogoSettingsPlatformInterface implements LogoSettingsPlatformInterface {
  LogoSettings? lastUpdatedSettings;
  LogoSettings settingsToReturn = LogoSettings();
  int getSettingsCallCount = 0;
  int updateSettingsCallCount = 0;

  @override
  Future<LogoSettings> getSettings() async {
    getSettingsCallCount++;
    return settingsToReturn;
  }

  @override
  Future<void> updateSettings(LogoSettings settings) async {
    updateSettingsCallCount++;
    lastUpdatedSettings = settings;
  }
}

void main() {
  late MockLogoSettingsPlatformInterface mockImpl;
  late LogoSettingsManager logoSettings;

  setUp(() {
    mockImpl = MockLogoSettingsPlatformInterface();
    logoSettings = LogoSettingsManager(mockImpl);
  });

  group('LogoSettingsManager', () {
    test('getSettings delegates to interface', () async {
      final expected = LogoSettings(enabled: true);
      mockImpl.settingsToReturn = expected;

      final result = await logoSettings.getSettings();

      expect(result, same(expected));
      expect(mockImpl.getSettingsCallCount, 1);
    });

    test('updateSettings delegates to interface', () async {
      final settings = LogoSettings(
        enabled: true,
        marginLeft: 10.0,
      );

      await logoSettings.updateSettings(settings);

      expect(mockImpl.updateSettingsCallCount, 1);
      expect(mockImpl.lastUpdatedSettings, same(settings));
    });

    test('getSettings can be called multiple times', () async {
      await logoSettings.getSettings();
      await logoSettings.getSettings();

      expect(mockImpl.getSettingsCallCount, 2);
    });

    test('updateSettings passes all fields correctly', () async {
      final settings = LogoSettings(
        enabled: true,
        marginLeft: 10.0,
        marginTop: 20.0,
        marginRight: 30.0,
        marginBottom: 40.0,
      );

      await logoSettings.updateSettings(settings);

      final updated = mockImpl.lastUpdatedSettings!;
      expect(updated.enabled, true);
      expect(updated.marginLeft, 10.0);
      expect(updated.marginTop, 20.0);
      expect(updated.marginRight, 30.0);
      expect(updated.marginBottom, 40.0);
    });
  });
}
