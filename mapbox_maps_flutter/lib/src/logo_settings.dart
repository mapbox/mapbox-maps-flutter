import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Manages logo ornament settings for the map.
class LogoSettingsManager {
  final LogoSettingsPlatformInterface _impl;

  @internal
  LogoSettingsManager(this._impl);

  /// Returns the current [LogoSettings].
  Future<LogoSettings> getSettings() => _impl.getSettings();

  /// Applies [LogoSettings] configuration changes.
  Future<void> updateSettings(LogoSettings settings) =>
      _impl.updateSettings(settings);
}

/// Deprecated: Use [LogoSettingsManager] instead.
@Deprecated('Use LogoSettingsManager instead.')
typedef LogoSettingsInterface = LogoSettingsManager;
