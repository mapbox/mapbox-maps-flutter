import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Manages HTTP service configuration for the Mapbox SDK.
class MapboxHttpService {
  final MapboxHttpServicePlatformInterface _impl;

  @internal
  MapboxHttpService(this._impl);

  /// Sets custom HTTP headers that will be appended to all SDK requests.
  Future<void> setCustomHeaders(Map<String, String> headers) =>
      _impl.setCustomHeaders(headers);
}
