import '../pigeons/platform_interface_data_types.dart';

/// Abstract interface for managing global Mapbox Maps configuration options.
abstract interface class MapboxMapsOptionsPlatformInterface {
  /// The base URL used for Mapbox HTTP requests. Defaults to `https://api.mapbox.com`.
  Future<String> getBaseUrl();

  /// Sets the base URL used for Mapbox HTTP requests.
  void setBaseUrl(String url);

  /// The path to the Maps data directory used for offline storage.
  Future<String> getDataPath();

  /// Sets the path to the Maps data directory.
  void setDataPath(String path);

  /// The path to the Maps asset directory. Ignored on Android.
  Future<String> getAssetPath();

  /// Sets the path to the Maps asset directory.
  void setAssetPath(String path);

  /// The tile store usage mode. Defaults to [TileStoreUsageMode.READ_ONLY].
  Future<TileStoreUsageMode> getTileStoreUsageMode();

  /// Sets the tile store usage mode.
  void setTileStoreUsageMode(TileStoreUsageMode mode);

  /// The ISO 3166-1 alpha-2 worldview preference, if set.
  Future<String?> getWorldview();

  /// Sets the worldview preference as an ISO 3166-1 alpha-2 country code.
  void setWorldview(String? worldview);

  /// The BCP-47 language preference, if set.
  Future<String?> getLanguage();

  /// Sets the language preference as a BCP-47 tag.
  void setLanguage(String? language);

  /// Clears all temporary map data from the data path.
  Future<void> clearData();
}
