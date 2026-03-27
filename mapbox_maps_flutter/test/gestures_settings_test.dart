import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockGesturesSettingsPlatformInterface implements GesturesSettingsPlatformInterface {
  GesturesSettings? lastUpdatedSettings;
  GesturesSettings settingsToReturn = GesturesSettings();
  int getSettingsCallCount = 0;
  int updateSettingsCallCount = 0;

  @override
  Future<GesturesSettings> getSettings() async {
    getSettingsCallCount++;
    return settingsToReturn;
  }

  @override
  Future<void> updateSettings(GesturesSettings settings) async {
    updateSettingsCallCount++;
    lastUpdatedSettings = settings;
  }
}

void main() {
  late MockGesturesSettingsPlatformInterface mockImpl;
  late GesturesSettingsManager gesturesSettings;

  setUp(() {
    mockImpl = MockGesturesSettingsPlatformInterface();
    gesturesSettings = GesturesSettingsManager(mockImpl);
  });

  group('GesturesSettingsManager', () {
    test('getSettings delegates to interface', () async {
      final expected = GesturesSettings(rotateEnabled: true);
      mockImpl.settingsToReturn = expected;

      final result = await gesturesSettings.getSettings();

      expect(result, same(expected));
      expect(mockImpl.getSettingsCallCount, 1);
    });

    test('updateSettings delegates to interface', () async {
      final settings = GesturesSettings(
        rotateEnabled: true,
        pinchToZoomEnabled: false,
      );

      await gesturesSettings.updateSettings(settings);

      expect(mockImpl.updateSettingsCallCount, 1);
      expect(mockImpl.lastUpdatedSettings, same(settings));
    });

    test('getSettings can be called multiple times', () async {
      await gesturesSettings.getSettings();
      await gesturesSettings.getSettings();

      expect(mockImpl.getSettingsCallCount, 2);
    });

    test('updateSettings passes all fields correctly', () async {
      final settings = GesturesSettings(
        rotateEnabled: true,
        pinchToZoomEnabled: false,
        scrollEnabled: true,
        pitchEnabled: false,
        doubleTapToZoomInEnabled: true,
        quickZoomEnabled: false,
      );

      await gesturesSettings.updateSettings(settings);

      final updated = mockImpl.lastUpdatedSettings!;
      expect(updated.rotateEnabled, true);
      expect(updated.pinchToZoomEnabled, false);
      expect(updated.scrollEnabled, true);
      expect(updated.pitchEnabled, false);
      expect(updated.doubleTapToZoomInEnabled, true);
      expect(updated.quickZoomEnabled, false);
    });
  });
}
