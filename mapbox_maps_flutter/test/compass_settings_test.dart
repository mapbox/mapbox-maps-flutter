import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockCompassSettingsPlatformInterface implements CompassSettingsPlatformInterface {
  CompassSettings? lastUpdatedSettings;
  CompassSettings settingsToReturn = CompassSettings();
  int getSettingsCallCount = 0;
  int updateSettingsCallCount = 0;

  @override
  Future<CompassSettings> getSettings() async {
    getSettingsCallCount++;
    return settingsToReturn;
  }

  @override
  Future<void> updateSettings(CompassSettings settings) async {
    updateSettingsCallCount++;
    lastUpdatedSettings = settings;
  }
}

void main() {
  late MockCompassSettingsPlatformInterface mockImpl;
  late CompassSettingsManager compassSettings;

  setUp(() {
    mockImpl = MockCompassSettingsPlatformInterface();
    compassSettings = CompassSettingsManager(mockImpl);
  });

  group('CompassSettingsManager', () {
    test('getSettings delegates to interface', () async {
      final expected = CompassSettings(enabled: true);
      mockImpl.settingsToReturn = expected;

      final result = await compassSettings.getSettings();

      expect(result, same(expected));
      expect(mockImpl.getSettingsCallCount, 1);
    });

    test('updateSettings delegates to interface', () async {
      final settings = CompassSettings(
        enabled: true,
        opacity: 0.8,
      );

      await compassSettings.updateSettings(settings);

      expect(mockImpl.updateSettingsCallCount, 1);
      expect(mockImpl.lastUpdatedSettings, same(settings));
    });

    test('getSettings can be called multiple times', () async {
      await compassSettings.getSettings();
      await compassSettings.getSettings();

      expect(mockImpl.getSettingsCallCount, 2);
    });

    test('updateSettings passes all fields correctly', () async {
      final settings = CompassSettings(
        enabled: true,
        marginLeft: 10.0,
        marginTop: 20.0,
        marginRight: 30.0,
        marginBottom: 40.0,
        opacity: 0.5,
        rotation: 45.0,
        fadeWhenFacingNorth: true,
        clickable: true,
      );

      await compassSettings.updateSettings(settings);

      final updated = mockImpl.lastUpdatedSettings!;
      expect(updated.enabled, true);
      expect(updated.marginLeft, 10.0);
      expect(updated.marginTop, 20.0);
      expect(updated.marginRight, 30.0);
      expect(updated.marginBottom, 40.0);
      expect(updated.opacity, 0.5);
      expect(updated.rotation, 45.0);
      expect(updated.fadeWhenFacingNorth, true);
      expect(updated.clickable, true);
    });
  });
}
