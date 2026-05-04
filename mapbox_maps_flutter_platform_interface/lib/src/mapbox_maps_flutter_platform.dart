import 'package:flutter/widgets.dart';

import 'events.dart' show MapEvent;
import 'interfaces/log_configuration_interface.dart';
import 'interfaces/mapbox_map_interface.dart';
import 'interfaces/mapbox_maps_options_interface.dart';
import 'interfaces/mapbox_options_interface.dart';
import 'interfaces/offline_interface.dart';
import 'interfaces/viewport/viewport_state.dart';
import 'interfaces/viewport/viewport_transition.dart';

export 'debug_options.dart';
export 'events.dart';
export 'interactive_features.dart';
export 'interfaces/annotations_interface.dart';
export 'interfaces/http_service_interface.dart';
export 'interfaces/location_settings_interface.dart';
export 'interfaces/log_configuration_interface.dart';
export 'interfaces/map_recorder_interface.dart';
export 'interfaces/mapbox_map_interface.dart';
export 'interfaces/mapbox_maps_options_interface.dart';
export 'interfaces/mapbox_options_interface.dart';
export 'interfaces/offline_interface.dart';
export 'interfaces/performance_statistics_listener.dart';
export 'interfaces/projection_interface.dart';
export 'interfaces/settings_interfaces.dart';
export 'interfaces/snapshotter_interface.dart';
export 'interfaces/style_interface.dart';
export 'interfaces/viewport/viewport_interface.dart';
export 'interfaces/viewport/viewport_state.dart';
export 'interfaces/viewport/viewport_transition.dart';

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
  LogConfigurationPlatformInterface get logConfiguration;

  // ===== Offline Interfaces =====

  Future<OfflineManagerPlatformInterface> createOfflineManager();
  Future<TileStorePlatformInterface> createTileStore({Uri filePath});

  // ===== Widget =====

  /// Builds a platform-specific widget for displaying the map.
  ///
  /// [styleUri] is the URI of the map style to load.
  /// [onMapCreated] is called once the underlying map view is ready, providing
  /// a [MapboxMapPlatformInterface] that callers use to interact with the map.
  Widget buildView({
    required String styleUri,
    PlatformMapCreatedCallback? onMapCreated,
    ViewportState? viewport,
    ViewportTransition? viewportTransition,
    void Function(bool)? viewportTransitionCompletion,
    void Function(MapEvent)? onMapEvent,
  });
}

/// Callback signature invoked when a map instance is ready.
typedef MapboxMapCreatedCallback<T extends MapboxMapInterface> =
    void Function(T mapboxMap);
typedef PlatformMapCreatedCallback =
    MapboxMapCreatedCallback<MapboxMapPlatformInterface>;
