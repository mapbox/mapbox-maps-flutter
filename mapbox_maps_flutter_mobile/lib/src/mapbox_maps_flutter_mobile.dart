// AndroidPlatformViewHostingMode is @experimental; mobile threads it
// through buildView as a routine plumbing param.
// ignore_for_file: experimental_member_use

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
    MapOptions? mapOptions,
    bool? textureView,
    AndroidPlatformViewHostingMode androidHostingMode =
        AndroidPlatformViewHostingMode.VD,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
    bool? isOpaque = true,
  }) {
    return MapWidget(
      styleUri: styleUri,
      mapOptions: mapOptions,
      textureView: textureView ?? true,
      androidHostingMode: androidHostingMode,
      gestureRecognizers: gestureRecognizers,
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
      isOpaque: isOpaque,
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
  LogConfigurationPlatformInterface get logConfiguration =>
      LogConfiguration.shared;

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

  @override
  Future<SnapshotterPlatformInterface> createSnapshotter({
    required MapSnapshotOptions options,
    OnStyleLoadedListener? onStyleLoadedListener,
    OnMapLoadErrorListener? onMapLoadErrorListener,
    OnStyleDataLoadedListener? onStyleDataLoadedListener,
    OnStyleImageMissingListener? onStyleImageMissingListener,
  }) =>
      Snapshotter.create(
        options: options,
        onStyleLoadedListener: onStyleLoadedListener,
        onMapLoadErrorListener: onMapLoadErrorListener,
        onStyleDataLoadedListener: onStyleDataLoadedListener,
        onStyleImageMissingListener: onStyleImageMissingListener,
      );
}
