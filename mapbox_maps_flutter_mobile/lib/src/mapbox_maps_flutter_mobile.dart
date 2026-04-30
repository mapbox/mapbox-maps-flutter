part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

base class MapboxMapsFlutterMobile extends MapboxMapsFlutterPlatform
    implements
        MapboxMapsOptionsPlatformInterface,
        MapboxOptionsPlatformInterface {
  @override
  Widget buildView({
    required String styleUri,
    PlatformMapCreatedCallback? onMapCreated,
    ViewportState? viewport,
    ViewportTransition? viewportTransition,
    void Function(bool)? viewportTransitionCompletion,
    void Function(MapEvent)? onMapEvent,
  }) {
    return MapWidget(
      styleUri: styleUri,
      onMapCreated: onMapCreated,
      viewport: viewport,
      viewportTransition: viewportTransition,
      viewportTransitionCompletion: viewportTransitionCompletion,
      onStyleLoadedListener: onMapEvent,
      onCameraChangeListener: onMapEvent,
      onMapIdleListener: onMapEvent,
      onMapLoadedListener: onMapEvent,
      onMapLoadErrorListener: onMapEvent,
      onRenderFrameStartedListener: onMapEvent,
      onRenderFrameFinishedListener: onMapEvent,
      onSourceAddedListener: onMapEvent,
      onSourceDataLoadedListener: onMapEvent,
      onSourceRemovedListener: onMapEvent,
      onStyleDataLoadedListener: onMapEvent,
      onStyleImageMissingListener: onMapEvent,
      onStyleImageUnusedListener: onMapEvent,
      onResourceRequestListener: onMapEvent,
    );
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
  Future<String?> getFlutterAssetPath(String? flutterAssetUri) =>
      MapboxMapsOptions.getFlutterAssetPath(flutterAssetUri);

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

  @override
  MapboxMapsOptionsPlatformInterface get mapboxMapsOptions => this;

  @override
  MapboxOptionsPlatformInterface get mapboxOptions => this;

  @override
  OfflineSwitchPlatformInterface get offlineSwitch => OfflineSwitch.shared;

  @override
  Future<OfflineManagerPlatformInterface> createOfflineManager() =>
      OfflineManager.create();

  @override
  Future<TileStorePlatformInterface> createTileStore({Uri? filePath}) =>
      filePath != null
      ? TileStore.createAt(filePath)
      : TileStore.createDefault();
}
