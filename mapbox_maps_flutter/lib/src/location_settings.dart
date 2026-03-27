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

  /// Accepts an instance of [LocationComponentSettings] allowing to apply location
  /// indicator configuration changes.
  Future<void> updateSettings(LocationComponentSettings settings) =>
      _impl.updateSettings(settings);
}

/// Deprecated: Use [LocationSettingsManager] instead.
@Deprecated('Use LocationSettingsManager instead.')
typedef LocationSettings = LocationSettingsManager;
