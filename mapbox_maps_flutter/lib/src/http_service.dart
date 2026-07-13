import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Manages HTTP service configuration for the Mapbox SDK.
class MapboxHttpService {
  final MapboxHttpServicePlatformInterface _impl;

  @internal
  MapboxHttpService(this._impl);

  /// Sets custom HTTP headers that are attached to every request the map makes,
  /// regardless of host.
  ///
  /// **Warning:** these headers are not restricted to Mapbox hosts — they are
  /// attached to every outgoing request, including requests to third-party
  /// hosts referenced by styles, sources, sprites, glyphs and tiles. Placing a
  /// credential here can therefore leak it to hosts you do not control.
  ///
  /// Use [setCustomHeadersForHost] to attach headers to a specific host only.
  ///
  /// [headers] is a map of header names to header values. Pass an empty map to
  /// clear previously set global headers.
  ///
  /// Throws a [PlatformException] if the native implementation is not available
  /// or if the operation fails.
  @Deprecated(
    'Headers set this way are attached to every host the map fetches from, '
    'including third-party hosts, which can leak credentials. Use '
    'setCustomHeadersForHost to scope headers to a specific host.',
  )
  Future<void> setCustomHeaders(Map<String, String> headers) =>
      _impl.setCustomHeaders(headers);

  /// Sets custom HTTP headers scoped to a specific [host].
  ///
  /// The headers are attached only to requests whose URL host matches [host]
  /// exactly (case-insensitive); there is no subdomain or substring matching.
  ///
  /// [host] is the target host, for example `"tiles.example.com"`.
  /// [headers] is a map of header names to header values. Passing an empty map
  /// removes any headers previously configured for [host].
  ///
  /// Calls for different hosts accumulate; calling again for the same host
  /// replaces that host's headers. This is a process-global setting that
  /// applies to all map instances.
  ///
  /// Throws a [PlatformException] if the native implementation is not available
  /// or if the operation fails.
  Future<void> setCustomHeadersForHost(
    String host,
    Map<String, String> headers,
  ) async => _impl.setCustomHeadersForHost(host, headers);

  /// Removes all custom headers previously configured via [setCustomHeaders] or
  /// [setCustomHeadersForHost].
  ///
  /// Throws a [PlatformException] if the native implementation is not available
  /// or if the operation fails.
  Future<void> clearCustomHeaders() async => _impl.clearCustomHeaders();

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
