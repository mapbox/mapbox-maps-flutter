import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockScaleBarSettingsPlatformInterface implements ScaleBarSettingsPlatformInterface {
  ScaleBarSettings? lastUpdatedSettings;
  ScaleBarSettings settingsToReturn = ScaleBarSettings();
  int getSettingsCallCount = 0;
  int updateSettingsCallCount = 0;

  @override
  Future<ScaleBarSettings> getSettings() async {
    getSettingsCallCount++;
    return settingsToReturn;
  }

  @override
  Future<void> updateSettings(ScaleBarSettings settings) async {
    updateSettingsCallCount++;
    lastUpdatedSettings = settings;
  }
}

void main() {
  late MockScaleBarSettingsPlatformInterface mockImpl;
  late ScaleBarSettingsManager scaleBarSettings;

  setUp(() {
    mockImpl = MockScaleBarSettingsPlatformInterface();
    scaleBarSettings = ScaleBarSettingsManager(mockImpl);
  });

  group('ScaleBarSettingsManager', () {
    test('getSettings delegates to interface', () async {
      final expected = ScaleBarSettings(enabled: true);
      mockImpl.settingsToReturn = expected;

      final result = await scaleBarSettings.getSettings();

      expect(result, same(expected));
      expect(mockImpl.getSettingsCallCount, 1);
    });

    test('updateSettings delegates to interface', () async {
      final settings = ScaleBarSettings(
        enabled: true,
        marginLeft: 10.0,
      );

      await scaleBarSettings.updateSettings(settings);

      expect(mockImpl.updateSettingsCallCount, 1);
      expect(mockImpl.lastUpdatedSettings, same(settings));
    });

    test('getSettings can be called multiple times', () async {
      await scaleBarSettings.getSettings();
      await scaleBarSettings.getSettings();

      expect(mockImpl.getSettingsCallCount, 2);
    });

    test('updateSettings passes all fields correctly', () async {
      final settings = ScaleBarSettings(
        enabled: true,
        marginLeft: 10.0,
        marginTop: 20.0,
        marginRight: 30.0,
        marginBottom: 40.0,
        textColor: 0xFF0000,
        height: 5.0,
        isMetricUnits: true,
      );

      await scaleBarSettings.updateSettings(settings);

      final updated = mockImpl.lastUpdatedSettings!;
      expect(updated.enabled, true);
      expect(updated.marginLeft, 10.0);
      expect(updated.marginTop, 20.0);
      expect(updated.marginRight, 30.0);
      expect(updated.marginBottom, 40.0);
      expect(updated.textColor, 0xFF0000);
      expect(updated.height, 5.0);
      expect(updated.isMetricUnits, true);
    });
  });
}
