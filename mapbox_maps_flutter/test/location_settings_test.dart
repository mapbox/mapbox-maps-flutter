import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockLocationSettingsPlatformInterface implements LocationSettingsPlatformInterface {
  LocationComponentSettings? lastUpdatedSettings;
  LocationComponentSettings settingsToReturn = LocationComponentSettings();
  int getSettingsCallCount = 0;
  int updateSettingsCallCount = 0;

  @override
  Future<LocationComponentSettings> getSettings() async {
    getSettingsCallCount++;
    return settingsToReturn;
  }

  @override
  Future<void> updateSettings(LocationComponentSettings settings) async {
    updateSettingsCallCount++;
    lastUpdatedSettings = settings;
  }
}

void main() {
  late MockLocationSettingsPlatformInterface mockImpl;
  late LocationSettingsManager locationSettings;

  setUp(() {
    mockImpl = MockLocationSettingsPlatformInterface();
    locationSettings = LocationSettingsManager(mockImpl);
  });

  group('LocationSettingsManager', () {
    test('getSettings delegates to interface', () async {
      final expected = LocationComponentSettings(enabled: true);
      mockImpl.settingsToReturn = expected;

      final result = await locationSettings.getSettings();

      expect(result, same(expected));
      expect(mockImpl.getSettingsCallCount, 1);
    });

    test('updateSettings delegates to interface', () async {
      final settings =
          LocationComponentSettings(enabled: true, pulsingEnabled: true);

      await locationSettings.updateSettings(settings);

      expect(mockImpl.updateSettingsCallCount, 1);
      expect(mockImpl.lastUpdatedSettings, same(settings));
    });

    test('getSettings can be called multiple times', () async {
      await locationSettings.getSettings();
      await locationSettings.getSettings();

      expect(mockImpl.getSettingsCallCount, 2);
    });

    test('updateSettings passes all fields correctly', () async {
      final settings = LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingColor: 0xFF0000,
        pulsingMaxRadius: 10.0,
        showAccuracyRing: true,
        puckBearingEnabled: true,
      );

      await locationSettings.updateSettings(settings);

      final updated = mockImpl.lastUpdatedSettings!;
      expect(updated.enabled, true);
      expect(updated.pulsingEnabled, true);
      expect(updated.pulsingColor, 0xFF0000);
      expect(updated.pulsingMaxRadius, 10.0);
      expect(updated.showAccuracyRing, true);
      expect(updated.puckBearingEnabled, true);
    });
  });
}
