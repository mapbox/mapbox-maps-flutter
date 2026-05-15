/// Abstract interface for configuring HTTP requests made by the Mapbox SDK.
abstract interface class MapboxHttpServicePlatformInterface {
  /// Sets custom HTTP headers that will be appended to all SDK requests.
  Future<void> setCustomHeaders(Map<String, String> headers);

  /// Sets the maximum number of concurrent HTTP requests per host that the
  /// underlying HTTP service may issue.
  ///
  /// [max] must be in the range 1..255.
  Future<void> setMaxRequestsPerHost(int max);
}
