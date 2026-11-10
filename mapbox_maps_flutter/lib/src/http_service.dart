import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

/// Configures the HTTP requests of the Mapbox SDK.
///
/// The settings apply only to the requests that the Mapbox SDK sends: the
/// requests of all maps, and on Android and iOS also offline downloads. Other
/// HTTP requests of your app do not change. Use [MapboxHttpService.instance].
/// A map is not necessary, so you can set headers before the first map loads
/// its style.
///
/// Call `WidgetsFlutterBinding.ensureInitialized()` before you use the
/// service in `main`.
///
/// ```dart
/// await MapboxHttpService.instance.setCustomHeadersForHost(
///   'tiles.example.com',
///   {'Authorization': 'Basic $credentials'},
/// );
/// ```
///
/// On web, the browser applies CORS to requests with custom headers:
///
/// * The server must allow the custom headers in its CORS response
///   (`Access-Control-Allow-Headers`). Each new URL with custom headers
///   causes one extra preflight request.
/// * The CORS response of the Mapbox tile endpoints (`api.mapbox.com/v4`)
///   does not allow custom headers, so the browser blocks these tile requests
///   if they have custom headers. Set custom headers only for your own hosts.
///   Android and iOS do not apply CORS, so the same headers work there.
///
/// On all platforms, a header change does not reload the tiles that are
/// already in the cache.
class MapboxHttpService {
  /// The process-wide HTTP service.
  static final MapboxHttpService instance = MapboxHttpService(
    MapboxMapsFlutterPlatform.instance.httpService,
  );

  final MapboxHttpServicePlatformInterface _impl;

  @visibleForTesting
  MapboxHttpService(this._impl);

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
  /// replaces that host's headers.
  ///
  /// Throws if [host] is empty.
  Future<void> setCustomHeadersForHost(
    String host,
    Map<String, String> headers,
  ) async => _impl.setCustomHeadersForHost(host, headers);

  /// Removes all custom headers previously configured via
  /// [setCustomHeadersForHost].
  Future<void> clearCustomHeaders() async => _impl.clearCustomHeaders();

  /// Sets the maximum number of concurrent HTTP requests per host that the
  /// underlying HTTP service may issue.
  ///
  /// Lowering this value reduces the chance of hitting per-token rate limits
  /// when downloading large amounts of data (for example, offline tile
  /// regions), at the cost of slower throughput.
  ///
  /// A [max] outside the range 1..255 is clamped to that range. On Android,
  /// a value above 127 acts as 127. On web, this call has no effect, because
  /// the browser controls the number of requests per host.
  Future<void> setMaxRequestsPerHost(int max) =>
      _impl.setMaxRequestsPerHost(max.clamp(1, 255));
}
