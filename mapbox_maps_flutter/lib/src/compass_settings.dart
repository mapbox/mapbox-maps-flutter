import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Manages compass ornament settings for the map.
class CompassSettingsManager {
  final CompassSettingsPlatformInterface _impl;

  @internal
  CompassSettingsManager(this._impl);

  /// Returns the current [CompassSettings].
  Future<CompassSettings> getSettings() => _impl.getSettings();

  /// Applies [CompassSettings] configuration changes.
  Future<void> updateSettings(CompassSettings settings) =>
      _impl.updateSettings(settings);
}

/// Deprecated: Use [CompassSettingsManager] instead.
@Deprecated('Use CompassSettingsManager instead.')
typedef CompassSettingsInterface = CompassSettingsManager;
