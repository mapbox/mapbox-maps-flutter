import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Manages attribution ornament settings for the map.
class AttributionSettingsManager {
  final AttributionSettingsPlatformInterface _impl;

  @internal
  AttributionSettingsManager(this._impl);

  /// Returns the current [AttributionSettings].
  Future<AttributionSettings> getSettings() => _impl.getSettings();

  /// Applies [AttributionSettings] configuration changes.
  Future<void> updateSettings(AttributionSettings settings) =>
      _impl.updateSettings(settings);
}

/// Deprecated: Use [AttributionSettingsManager] instead.
@Deprecated('Use AttributionSettingsManager instead.')
typedef AttributionSettingsInterface = AttributionSettingsManager;
