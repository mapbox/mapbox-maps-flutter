import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/src/bindings/map_bindings.dart';
import 'package:mapbox_maps_flutter_web/src/map_widget.dart';

base class MapboxMapsFlutterWeb extends MapboxMapsFlutterPlatform
    implements
        MapboxOptionsPlatformInterface,
        MapboxMapsOptionsPlatformInterface {
  /// Registers the platform implementation.
  static void registerWith(Registrar registrar) {
    MapboxMapsFlutterPlatform.instance = MapboxMapsFlutterWeb();
  }

  @override
  Widget buildView({
    required String styleUri,
    PlatformMapCreatedCallback? onMapCreated,
    ViewportState? viewport,
    ViewportTransition? viewportTransition,
    void Function(bool)? viewportTransitionCompletion,
    void Function(MapEvent)? onMapEvent,
  }) {
    return MapWebWidget(
      onMapCreated: onMapCreated,
      viewport: viewport,
      viewportTransition: viewportTransition,
      viewportTransitionCompletion: viewportTransitionCompletion,
    );
  }

  @override
  Future<String> getAccessToken() {
    return Future.value(accessToken);
  }

  @override
  void setAccessToken(String token) {
    accessToken = token;
  }

  @override
  Future<String> getBaseUrl() =>
      throw UnimplementedError('getBaseUrl() is not implemented on web.');

  @override
  void setBaseUrl(String url) =>
      throw UnimplementedError('setBaseUrl() is not implemented on web.');

  @override
  Future<String> getDataPath() =>
      throw UnimplementedError('getDataPath() is not implemented on web.');

  @override
  void setDataPath(String path) =>
      throw UnimplementedError('setDataPath() is not implemented on web.');

  @override
  Future<String> getAssetPath() =>
      throw UnimplementedError('getAssetPath() is not implemented on web.');

  @override
  void setAssetPath(String path) =>
      throw UnimplementedError('setAssetPath() is not implemented on web.');

  @override
  Future<TileStoreUsageMode> getTileStoreUsageMode() =>
      throw UnimplementedError(
          'getTileStoreUsageMode() is not implemented on web.');

  @override
  void setTileStoreUsageMode(TileStoreUsageMode mode) =>
      throw UnimplementedError(
          'setTileStoreUsageMode() is not implemented on web.');

  @override
  Future<String?> getWorldview() =>
      throw UnimplementedError('getWorldview() is not implemented on web.');

  @override
  void setWorldview(String? worldview) =>
      throw UnimplementedError('setWorldview() is not implemented on web.');

  @override
  Future<String?> getLanguage() =>
      throw UnimplementedError('getLanguage() is not implemented on web.');

  @override
  void setLanguage(String? language) =>
      throw UnimplementedError('setLanguage() is not implemented on web.');

  @override
  Future<void> clearData() =>
      throw UnimplementedError('clearData() is not implemented on web.');

  @override
  MapboxMapsOptionsPlatformInterface get mapboxMapsOptions => this;

  @override
  MapboxOptionsPlatformInterface get mapboxOptions => this;

  @override
  OfflineSwitchPlatformInterface get offlineSwitch =>
      throw UnsupportedError(
    'Offline functionalities are not supported on web.',
  );

  @override
  Future<OfflineManagerPlatformInterface> createOfflineManager() =>
      throw UnsupportedError(
        'Offline functionalities are not supported on web.',
      );

  @override
  Future<TileStorePlatformInterface> createTileStore({Uri? filePath}) =>
      throw UnsupportedError(
        'Offline functionalities are not supported on web.',
      );
}
