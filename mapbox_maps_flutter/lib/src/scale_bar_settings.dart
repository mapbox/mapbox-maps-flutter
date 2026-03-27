import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Manages scale bar ornament settings for the map.
class ScaleBarSettingsManager {
  final ScaleBarSettingsPlatformInterface _impl;

  @internal
  ScaleBarSettingsManager(this._impl);

  /// Returns the current [ScaleBarSettings].
  Future<ScaleBarSettings> getSettings() => _impl.getSettings();

  /// Applies [ScaleBarSettings] configuration changes.
  Future<void> updateSettings(ScaleBarSettings settings) =>
      _impl.updateSettings(settings);
}

/// Deprecated: Use [ScaleBarSettingsManager] instead.
@Deprecated('Use ScaleBarSettingsManager instead.')
typedef ScaleBarSettingsInterface = ScaleBarSettingsManager;
