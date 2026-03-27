import 'package:flutter/widgets.dart';

import 'interfaces/mapbox_map_interface.dart';
import 'pigeons/platform_interface_data_types.dart';

export 'events.dart';
export 'interfaces/annotations_interface.dart';
export 'interfaces/http_service_interface.dart';
export 'interfaces/location_settings_interface.dart';
export 'interfaces/mapbox_map_interface.dart';
export 'interfaces/offline_interface.dart';
export 'interfaces/settings_interfaces.dart';
export 'interfaces/snapshotter_interface.dart';
export 'interfaces/style_interface.dart';

abstract base class MapboxMapsFlutterPlatform {
  static MapboxMapsFlutterPlatform? _instance;

  /// The default instance of [MapboxMapsFlutterPlatform] to use.
  ///
  /// This is the default instance that will be used by the [MapboxMapsFlutterPlatform] class.
  static MapboxMapsFlutterPlatform get instance {
    if (_instance == null) {
      throw AssertionError(
        'No default instance of MapboxMapsFlutterPlatform has been set. '
        'Ensure that you have called MapboxMapsFlutterPlatform.setInstance() '
        'before using the MapboxMapsFlutterPlatform instance.',
      );
    }
    return _instance!;
  }

  static set instance(MapboxMapsFlutterPlatform instance) {
    _instance = instance;
  }

  /// Constructs a MapboxMapsFlutterPlatform.
  MapboxMapsFlutterPlatform();

  // ===== MapboxOptions =====

  /// The access token used to access Mapbox services.
  Future<String> getAccessToken();

  /// Sets the access token used to access Mapbox services.
  void setAccessToken(String token);

  // ===== MapboxMapsOptions =====

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

  // ===== Widget =====

  /// Builds a platform-specific widget for displaying the map.
  ///
  /// [onMapCreated] is called once the underlying map view is ready, providing
  /// a [MapboxMapPlatformInterface] that callers use to interact with the map.
  Widget buildView({PlatformMapCreatedCallback? onMapCreated});
}

/// Callback signature invoked when a map instance is ready.
typedef MapboxMapCreatedCallback<T extends MapboxMapInterface> =
    void Function(T mapboxMap);
typedef PlatformMapCreatedCallback =
    MapboxMapCreatedCallback<MapboxMapPlatformInterface>;
