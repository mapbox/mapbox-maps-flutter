/// Abstract interface for configuring HTTP requests made by the Mapbox SDK.
abstract interface class MapboxHttpServicePlatformInterface {
  /// Sets custom HTTP headers that will be appended to all SDK requests.
  Future<void> setCustomHeaders(Map<String, String> headers);
}
