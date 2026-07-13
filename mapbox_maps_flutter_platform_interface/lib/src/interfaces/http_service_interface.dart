/// Abstract interface for configuring HTTP requests made by the Mapbox SDK.
abstract interface class MapboxHttpServicePlatformInterface {
  /// Sets custom HTTP headers that will be appended to all SDK requests.
  Future<void> setCustomHeaders(Map<String, String> headers);

  /// Sets custom HTTP headers scoped to a specific [host].
  Future<void> setCustomHeadersForHost(
    String host,
    Map<String, String> headers,
  );

  /// Removes all custom headers previously configured via [setCustomHeaders] or
  /// [setCustomHeadersForHost].
  ///
  /// Throws a [PlatformException] if the native implementation is not available
  /// or if the operation fails.
  Future<void> clearCustomHeaders();

  /// Sets the maximum number of concurrent HTTP requests per host that the
  /// underlying HTTP service may issue.
  ///
  /// [max] must be in the range 1..255.
  Future<void> setMaxRequestsPerHost(int max);
}
