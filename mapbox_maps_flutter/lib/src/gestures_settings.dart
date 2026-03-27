import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Manages gesture configuration for the map.
class GesturesSettingsManager {
  final GesturesSettingsPlatformInterface _impl;

  @internal
  GesturesSettingsManager(this._impl);

  /// Returns the current [GesturesSettings].
  Future<GesturesSettings> getSettings() => _impl.getSettings();

  /// Applies [GesturesSettings] configuration changes.
  Future<void> updateSettings(GesturesSettings settings) =>
      _impl.updateSettings(settings);
}

/// Deprecated: Use [GesturesSettingsManager] instead.
@Deprecated('Use GesturesSettingsManager instead.')
typedef GesturesSettingsInterface = GesturesSettingsManager;
