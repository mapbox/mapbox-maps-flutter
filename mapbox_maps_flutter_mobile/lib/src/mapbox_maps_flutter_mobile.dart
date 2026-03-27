part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

base class MapboxMapsFlutterMobile extends MapboxMapsFlutterPlatform {
  @override
  Widget buildView({PlatformMapCreatedCallback? onMapCreated}) {
    // TODO(MAPSFLT-XXX): Forward onMapCreated once MapboxMap implements MapboxMapInterface.
    return MapWidget();
  }

  @override
  Future<String> getAccessToken() => MapboxOptions.getAccessToken();

  @override
  void setAccessToken(String token) => MapboxOptions.setAccessToken(token);

  @override
  Future<String> getBaseUrl() => MapboxMapsOptions.getBaseUrl();

  @override
  void setBaseUrl(String url) => MapboxMapsOptions.setBaseUrl(url);

  @override
  Future<String> getDataPath() => MapboxMapsOptions.getDataPath();

  @override
  void setDataPath(String path) => MapboxMapsOptions.setDataPath(path);

  @override
  Future<String> getAssetPath() => MapboxMapsOptions.getAssetPath();

  @override
  void setAssetPath(String path) => MapboxMapsOptions.setAssetPath(path);

  @override
  Future<TileStoreUsageMode> getTileStoreUsageMode() =>
      MapboxMapsOptions.getTileStoreUsageMode();

  @override
  void setTileStoreUsageMode(TileStoreUsageMode mode) =>
      MapboxMapsOptions.setTileStoreUsageMode(mode);

  @override
  Future<String?> getWorldview() => MapboxMapsOptions.getWorldview();

  @override
  void setWorldview(String? worldview) =>
      MapboxMapsOptions.setWorldview(worldview);

  @override
  Future<String?> getLanguage() => MapboxMapsOptions.getLanguage();

  @override
  void setLanguage(String? language) => MapboxMapsOptions.setLanguage(language);

  @override
  Future<void> clearData() => MapboxMapsOptions.clearData();

  /// Registers the platform implementation.
  static void registerWith() {
    MapboxMapsFlutterPlatform.instance = MapboxMapsFlutterMobile();
  }
}
