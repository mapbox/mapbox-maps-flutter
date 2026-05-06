import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Configurations for the external resources used by Maps API objects
/// (Map, Snapshotter, OfflineManager, OfflineRegionManager).
///
/// Resource option changes are read at construction time. Apply them
/// once at startup, before any Maps API objects are constructed.
final class MapboxMapsOptions {
  MapboxMapsOptions._();

  static MapboxMapsOptionsPlatformInterface get _impl =>
      MapboxMapsFlutterPlatform.instance.mapboxMapsOptions;

  /// Base URL used by the Maps engine for HTTP requests
  /// (default `https://api.mapbox.com`).
  static Future<String> getBaseUrl() => _impl.getBaseUrl();

  /// Sets the base URL used by the Maps engine.
  static void setBaseUrl(String url) => _impl.setBaseUrl(url);

  /// Path to the Maps data folder (offline style packages, temporary data).
  static Future<String> getDataPath() => _impl.getDataPath();

  /// Sets the path to the Maps data folder.
  static void setDataPath(String path) => _impl.setDataPath(path);

  /// Path to the Maps asset folder. Ignored on Android.
  static Future<String> getAssetPath() => _impl.getAssetPath();

  /// Sets the path to the Maps asset folder.
  static void setAssetPath(String path) => _impl.setAssetPath(path);

  /// Resolves a Flutter asset URI to a platform-native path usable by the
  /// Maps runtime.
  static Future<String?> getFlutterAssetPath(String? flutterAssetUri) =>
      _impl.getFlutterAssetPath(flutterAssetUri);

  /// Tile store usage mode (default `readOnly`).
  static Future<TileStoreUsageMode> getTileStoreUsageMode() =>
      _impl.getTileStoreUsageMode();

  /// Sets the tile store usage mode.
  static void setTileStoreUsageMode(TileStoreUsageMode mode) =>
      _impl.setTileStoreUsageMode(mode);

  /// Worldview preference (ISO 3166-1 alpha-2 country code), if set.
  static Future<String?> getWorldview() => _impl.getWorldview();

  /// Sets the worldview preference (ISO 3166-1 alpha-2 country code).
  static void setWorldview(String? worldview) => _impl.setWorldview(worldview);

  /// Language preference (BCP-47 tag), if set.
  static Future<String?> getLanguage() => _impl.getLanguage();

  /// Sets the language preference (BCP-47 tag).
  static void setLanguage(String? language) => _impl.setLanguage(language);

  /// Clears all temporary map data from the data path.
  static Future<void> clearData() => _impl.clearData();
}
