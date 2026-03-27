import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Controls the Mapbox network stack connectivity.
class OfflineSwitch {
  final OfflineSwitchPlatformInterface _impl;

  @internal
  OfflineSwitch(this._impl);

  /// Returns whether the Mapbox network stack is connected.
  Future<bool> get isMapboxStackConnected => _impl.isMapboxStackConnected;

  /// Enables or disables the Mapbox network stack.
  Future<void> setMapboxStackConnected(bool isConnected) =>
      _impl.setMapboxStackConnected(isConnected);
}
