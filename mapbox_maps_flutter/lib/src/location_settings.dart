import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Shows a location puck on the map.
class LocationSettingsManager {
  final LocationSettingsPlatformInterface _impl;

  @internal
  LocationSettingsManager(this._impl);

  /// Returns [LocationComponentSettings] allowing to show location indicator on the map,
  /// customize indicator's appearance and position.
  Future<LocationComponentSettings> getSettings() => _impl.getSettings();

  /// Accepts an instance of [LocationComponentSettings] allowing to apply
  /// location indicator configuration changes. Fields and the platforms
  /// each applies to:
  ///
  /// ```dart
  /// LocationComponentSettings(
  ///   enabled: true,                       // Android, iOS, web
  ///   pulsingEnabled: true,                // Android, iOS  (web: always on)
  ///   pulsingColor: 0xFFFF0000,            // Android, iOS
  ///   pulsingMaxRadius: 20.0,              // Android, iOS
  ///   showAccuracyRing: true,              // Android, iOS, web
  ///   accuracyRingColor: 0xFF00FF00,       // Android, iOS
  ///   accuracyRingBorderColor: 0xFF000000, // Android, iOS
  ///   layerAbove: 'some-layer',            // Android
  ///   layerBelow: 'some-layer',            // Android
  ///   puckBearingEnabled: true,            // Android, iOS, web
  ///   puckBearing: PuckBearing.HEADING,    // Android, iOS  (web: always HEADING)
  ///   slot: 'top',                         // Android, iOS
  ///   locationPuck: LocationPuck(...),     // Android, iOS
  /// )
  /// ```
  Future<void> updateSettings(LocationComponentSettings settings) =>
      _impl.updateSettings(settings);
}

/// Deprecated: Use [LocationSettingsManager] instead.
@Deprecated('Use LocationSettingsManager instead.')
typedef LocationSettings = LocationSettingsManager;
