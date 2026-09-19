/// Abstract interface for managing the Mapbox access token.
abstract interface class MapboxOptionsPlatformInterface {
  /// The access token used to access Mapbox services.
  Future<String> getAccessToken();

  /// Sets the access token used to access Mapbox services.
  void setAccessToken(String token);
}
