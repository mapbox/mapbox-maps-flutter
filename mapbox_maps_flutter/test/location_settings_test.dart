import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

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

  Map<String, Object?>? lastExternalLocation;
  int clearExternalLocationCallCount = 0;

  @override
  Future<void> setExternalLocation({
    required double latitude,
    required double longitude,
    double? accuracy,
    double? heading,
    double? headingAccuracy,
    int? floor,
    DateTime? timestamp,
  }) async {
    lastExternalLocation = {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'heading': heading,
      'headingAccuracy': headingAccuracy,
      'floor': floor,
      'timestamp': timestamp,
    };
  }

  @override
  Future<void> clearExternalLocation() async {
    clearExternalLocationCallCount++;
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

  test('setExternalLocation forwards every field to the platform impl', () async {
    final timestamp = DateTime.utc(2026, 1, 1, 12);
    await locationSettings.setExternalLocation(
      latitude: 1.5,
      longitude: 2.5,
      accuracy: 5.0,
      heading: 90.0,
      headingAccuracy: 3.0,
      floor: 2,
      timestamp: timestamp,
    );

    expect(mockImpl.lastExternalLocation, {
      'latitude': 1.5,
      'longitude': 2.5,
      'accuracy': 5.0,
      'heading': 90.0,
      'headingAccuracy': 3.0,
      'floor': 2,
      'timestamp': timestamp,
    });
  });

  test('setExternalLocation leaves omitted optional fields null', () async {
    await locationSettings.setExternalLocation(latitude: 1.5, longitude: 2.5);

    expect(mockImpl.lastExternalLocation!['accuracy'], isNull);
    expect(mockImpl.lastExternalLocation!['heading'], isNull);
    expect(mockImpl.lastExternalLocation!['headingAccuracy'], isNull);
    expect(mockImpl.lastExternalLocation!['floor'], isNull);
    expect(mockImpl.lastExternalLocation!['timestamp'], isNull);
  });

  test('clearExternalLocation delegates to the platform impl', () async {
    await locationSettings.clearExternalLocation();

    expect(mockImpl.clearExternalLocationCallCount, 1);
  });
}
