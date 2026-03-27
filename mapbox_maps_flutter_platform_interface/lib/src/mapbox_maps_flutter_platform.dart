import 'package:flutter/widgets.dart';

import 'interfaces/mapbox_map_interface.dart';
import 'interfaces/mapbox_maps_options_interface.dart';
import 'interfaces/mapbox_options_interface.dart';
import 'interfaces/offline_interface.dart';

export 'events.dart';
export 'interfaces/annotations_interface.dart';
export 'interfaces/http_service_interface.dart';
export 'interfaces/location_settings_interface.dart';
export 'interfaces/mapbox_map_interface.dart';
export 'interfaces/mapbox_maps_options_interface.dart';
export 'interfaces/mapbox_options_interface.dart';
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

  // ===== Global Configs =====

  OfflineSwitchPlatformInterface get offlineSwitch;
  MapboxOptionsPlatformInterface get mapboxOptions;
  MapboxMapsOptionsPlatformInterface get mapboxMapsOptions;

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
