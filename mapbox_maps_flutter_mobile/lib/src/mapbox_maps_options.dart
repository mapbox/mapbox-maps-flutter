part of mapbox_maps_flutter;

/// Class for Mapbox SDK settings management
final class MapboxOptions {
  static _MapboxOptions _options = () {
    LogConfiguration._setupDebugLoggingIfNeeded();
    return _MapboxOptions();
  }();

  /// The access token that is used to access resources provided by Mapbox services.
  static Future<String> getAccessToken() {
    return _options.getAccessToken();
  }

  /// The access token that is used to access resources provided by Mapbox services.
  static void setAccessToken(String token) {
    _options.setAccessToken(token);
  }
}

/// Configurations for the external resources that are used by Maps API object,
/// such as maps data directory and base URL.
///
/// The Maps API objects include instances of Map, Snapshotter, OfflineManager and OfflineRegionManager classes.
///
/// The resource options changes are taken into consideration by the Maps API objects during their construction phase.
/// Any changes made to the resource options during runtime will not impact objects that have already been created.
///
/// Every resource option has a default value, which does not have to be overridden by the client most of the time.
/// If the default resource options need to be overridden, it is recommended to do it once at the application start and
/// before any of the Maps API objects are constructed. Although it is technically possible to run Maps API objects that use different
/// resource options, such a setup might cause performance implications.
final class MapboxMapsOptions {
  static _MapboxMapsOptions _options = _MapboxMapsOptions();

  MapboxMapsOptions._() {}

  /// The base URL that would be used by the Maps engine to make HTTP requests.
  /// By default the engine uses the base URL `https://api.mapbox.com`
  static Future<String> getBaseUrl() {
    return _options.getBaseUrl();
  }

  /// The base URL that would be used by the Maps engine to make HTTP requests.
  static void setBaseUrl(String url) {
    _options.setBaseUrl(url);
  }

  /// The path to the Maps data folder.
  ///
  /// The engine will use this folder for storing offline style packages and temporary data.
  /// The application must have sufficient permissions to create files within the provided directory. If a data path is not provided, the default location will be used.
  static Future<String> getDataPath() {
    return _options.getDataPath();
  }

  /// The path to the Maps data folder.
  ///
  /// The engine will use this folder for storing offline style packages and temporary data.
  /// The application must have sufficient permissions to create files within the provided directory. If a data path is not provided, the default location will be used.
  static void setDataPath(String path) {
    _options.setDataPath(path);
  }

  /// The path to the Maps asset folder. Default is application's main bundle path.
  ///
  /// This option is ignored for Android platform.
  ///
  /// The path to the folder where application assets are located. Resources whose protocol is `asset://`
  /// will be fetched from an asset folder or asset management system provided by respective platform.
  static Future<String> getAssetPath() {
    return _options.getAssetPath();
  }

  /// The path to the Maps asset folder. Default is application's main bundle path.
  ///
  /// This option is ignored for Android platform.
  ///
  /// The path to the folder where application assets are located. Resources whose protocol is `asset://`
  /// will be fetched from an asset folder or asset management system provided by respective platform.
  static void setAssetPath(String path) {
    _options.setAssetPath(path);
  }

  static Future<String?> _getFlutterAssetPath(String? flutterAssetUri) {
    return _options.getFlutterAssetPath(flutterAssetUri);
  }

  /// The tile store usage mode for the Maps API objects. Default is `readOnly`.
  static Future<TileStoreUsageMode> getTileStoreUsageMode() {
    return _options.getTileStoreUsageMode();
  }

  /// The tile store usage mode for the Maps API objects.
  static void setTileStoreUsageMode(TileStoreUsageMode mode) {
    _options.setTileStoreUsageMode(mode);
  }

  /// Current worldview preference for Mapbox products.
  ///
  /// Represented as a ISO 3166-1 alpha-2 country code.
  @experimental
  static Future<String?> getWorldview() {
    return _options.getWorldview();
  }

  /// Set preferred worldview for Mapbox products as a ISO 3166-1 alpha-2 country code.
  ///
  /// Learn more about Mapbox worldviews at https://docs.mapbox.com/help/glossary/worldview/#available-worldviews.
  @experimental
  static void setWorldview(String? worldview) {
    _options.setWorldview(worldview);
  }

  /// Current language preference for Mapbox products.
  ///
  /// Represented as a bcp-47 tag.
  @experimental
  static Future<String?> getLanguage() {
    return _options.getLanguage();
  }

  /// Set preferred language for Mapbox products with a bcp-47 tag.
  @experimental
  static void setLanguage(String? language) {
    _options.setLanguage(language);
  }

  static Future<void> clearData() {
    return _options.clearData();
  }
}
