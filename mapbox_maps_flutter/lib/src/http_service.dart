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

  /// Sets the maximum number of concurrent HTTP requests per host that the
  /// underlying HTTP service may issue.
  ///
  /// Lowering this value reduces the chance of hitting per-token rate limits
  /// when downloading large amounts of data (for example, offline tile
  /// regions), at the cost of slower throughput.
  ///
  /// This is a global setting that applies to all Mapbox HTTP requests across
  /// the process; calling it on any map instance updates it for all of them.
  ///
  /// [max] must be in the range 1..255.
  Future<void> setMaxRequestsPerHost(int max) =>
      _impl.setMaxRequestsPerHost(max);
}
