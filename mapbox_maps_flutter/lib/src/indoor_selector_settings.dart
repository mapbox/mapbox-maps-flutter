import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Manages indoor floor selector settings for the map.
class IndoorSelectorSettingsManager {
  final IndoorSelectorSettingsPlatformInterface _impl;

  @internal
  IndoorSelectorSettingsManager(this._impl);

  /// Returns the current [IndoorSelectorSettings].
  Future<IndoorSelectorSettings> getSettings() => _impl.getSettings();

  /// Applies [IndoorSelectorSettings] configuration changes.
  Future<void> updateSettings(IndoorSelectorSettings settings) =>
      _impl.updateSettings(settings);
}

/// Deprecated: Use [IndoorSelectorSettingsManager] instead.
@Deprecated('Use IndoorSelectorSettingsManager instead.')
typedef IndoorSelectorSettingsInterface = IndoorSelectorSettingsManager;
