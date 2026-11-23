import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

import 'http_headers_registry.dart';

/// Web HTTP service. Stores the custom headers in [HttpHeadersRegistry],
/// which every map reads for each request.
final class HttpServiceWeb implements MapboxHttpServicePlatformInterface {
  /// Creates the service. [registry] defaults to
  /// [HttpHeadersRegistry.instance].
  HttpServiceWeb({HttpHeadersRegistry? registry})
    : _registry = registry ?? HttpHeadersRegistry.instance;

  final HttpHeadersRegistry _registry;

  @override
  Future<void> setCustomHeaders(Map<String, String> headers) async =>
      _registry.setGlobalHeaders(headers);

  @override
  Future<void> setCustomHeadersForHost(
    String host,
    Map<String, String> headers,
  ) async {
    if (host.isEmpty) {
      throw ArgumentError.value(host, 'host', 'must not be empty');
    }
    _registry.setHeadersForHost(host, headers);
  }

  @override
  Future<void> clearCustomHeaders() async => _registry.clear();

  // The browser controls the number of requests per host.
  @override
  Future<void> setMaxRequestsPerHost(int max) async {}
}
