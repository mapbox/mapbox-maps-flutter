import 'dart:js_interop';
import 'dart:typed_data';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart' show Point, Position;

import 'bindings/map_bindings.dart';
import 'unsupported_sub_interfaces.dart';

/// Web [MapboxMapPlatformInterface] implementation backed by Mapbox GL JS.
///
/// The WS2.5 scope is deliberately narrow: this class exists to give
/// `onMapCreated` a non-null controller so the facade integration suite can
/// run on Chrome. Only the handful of methods used by the passing tests
/// (camera read/write, style load) are backed by GL JS. Everything else
/// throws [UnimplementedError] for "GL JS has an analogue we haven't wired
/// yet" or [UnsupportedError] for "web does not support this by design".
///
/// Sub-interface getters return the throwing stubs in
/// [unsupported_sub_interfaces.dart]. Gesture listener slots round-trip the
/// caller's value but never fire — GL JS has gesture events we could adapt,
/// but wiring them is web-parity follow-up work.
base class MapboxMapWeb implements MapboxMapPlatformInterface {
  final JSMap _map;

  MapboxMapWeb(this._map);

  // ===== Sub-interfaces =====

  @override
  late final StylePlatformInterface style = UnsupportedStyleWeb();
  @override
  late final GesturesSettingsPlatformInterface gestures =
      UnsupportedGesturesSettingsWeb();
  @override
  late final LocationSettingsPlatformInterface location =
      UnsupportedLocationSettingsWeb();
  @override
  late final ScaleBarSettingsPlatformInterface scaleBar =
      UnsupportedScaleBarSettingsWeb();
  @override
  late final CompassSettingsPlatformInterface compass =
      UnsupportedCompassSettingsWeb();
  @override
  late final AttributionSettingsPlatformInterface attribution =
      UnsupportedAttributionSettingsWeb();
  @override
  late final LogoSettingsPlatformInterface logo = UnsupportedLogoSettingsWeb();
  @override
  late final IndoorSelectorSettingsPlatformInterface indoorSelector =
      UnsupportedIndoorSelectorSettingsWeb();
  @override
  late final AnnotationManagerPlatformInterface annotations =
      UnsupportedAnnotationManagerWeb();
  @override
  late final MapboxHttpServicePlatformInterface httpService =
      UnsupportedHttpServiceWeb();
  @override
  late final ProjectionPlatformInterface projection =
      UnsupportedProjectionWeb();
  @override
  late final MapRecorderPlatformInterface mapRecorder =
      UnsupportedMapRecorderWeb();

  // ===== Performance statistics =====
  //
  // GL JS exposes a performance API but wiring it up sits in the
  // web-parity follow-up epic; throw until then.

  @override
  void startPerformanceStatisticsCollection(
    PerformanceStatisticsOptions options,
    PerformanceStatisticsListener listener,
  ) => throw UnimplementedError(
    'startPerformanceStatisticsCollection is not yet implemented on web.',
  );

  @override
  void stopPerformanceStatisticsCollection() => throw UnimplementedError(
    'stopPerformanceStatisticsCollection is not yet implemented on web.',
  );

  // ===== Gesture listeners =====
  //
  // Storage-only: setters latch the caller's listener, getters return it.
  // The web adapter never invokes them because GL JS gesture events are not
  // yet wired into the platform-interface MapContentGestureContext shape.

  @override
  OnMapTapListener? onMapTapListener;
  @override
  OnMapLongTapListener? onMapLongTapListener;
  @override
  OnMapScrollListener? onMapScrollListener;
  @override
  OnMapZoomListener? onMapZoomListener;

  // ===== Style loading =====

  @override
  Future<void> loadStyleURI(String styleURI) async {
    _map.setStyle(styleURI.toJS);
  }

  @override
  Future<void> loadStyleJson(String styleJson) =>
      throw UnimplementedError('loadStyleJson is not yet implemented on web.');

  // ===== Camera =====

  @override
  Future<CameraState> getCameraState() async {
    final center = _map.getCenter();
    return CameraState(
      center: Point(coordinates: Position(center.lng, center.lat)),
      padding: MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
      zoom: _map.getZoom(),
      bearing: _map.getBearing(),
      pitch: _map.getPitch(),
    );
  }

  @override
  Future<void> setCamera(CameraOptions cameraOptions) async {
    final center = cameraOptions.center;
    _map.jumpTo(
      JSCameraOptions(
        center: center == null
            ? null
            : <JSAny>[
                center.coordinates.lng.toDouble().toJS,
                center.coordinates.lat.toDouble().toJS,
              ].toJS,
        zoom: cameraOptions.zoom,
        bearing: cameraOptions.bearing,
        pitch: cameraOptions.pitch,
      ),
    );
  }

  // ===== Camera convenience =====

  @override
  Future<CameraOptions> cameraForCoordinatesPadding(
    List<Point> coordinates,
    CameraOptions camera,
    MbxEdgeInsets? coordinatesPadding,
    double? maxZoom,
    ScreenCoordinate? offset,
  ) => throw _ni('cameraForCoordinatesPadding');

  @override
  Future<CameraOptions> cameraForCoordinateBounds(
    CoordinateBounds bounds,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
    double? maxZoom,
    ScreenCoordinate? offset,
  ) => throw _ni('cameraForCoordinateBounds');

  @override
  Future<CameraOptions> cameraForCoordinates(
    List<Point> coordinates,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
  ) => throw _ni('cameraForCoordinates');

  @override
  Future<CameraOptions> cameraForCoordinatesCameraOptions(
    List<Point> coordinates,
    CameraOptions camera,
    ScreenBox box,
  ) => throw _ni('cameraForCoordinatesCameraOptions');

  @override
  Future<CameraOptions> cameraForGeometry(
    Map<String?, Object?> geometry,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
  ) => throw _ni('cameraForGeometry');

  @override
  Future<CoordinateBounds> coordinateBoundsForCamera(CameraOptions camera) =>
      throw _ni('coordinateBoundsForCamera');

  @override
  Future<CoordinateBounds> coordinateBoundsForCameraUnwrapped(
    CameraOptions camera,
  ) => throw _ni('coordinateBoundsForCameraUnwrapped');

  @override
  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCamera(
    CameraOptions camera,
  ) => throw _ni('coordinateBoundsZoomForCamera');

  @override
  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCameraUnwrapped(
    CameraOptions camera,
  ) => throw _ni('coordinateBoundsZoomForCameraUnwrapped');

  // ===== Camera bounds =====

  @override
  Future<void> setBounds(CameraBoundsOptions options) => throw _ni('setBounds');

  @override
  Future<CameraBounds> getBounds() => throw _ni('getBounds');

  // ===== Animation =====

  @override
  Future<void> easeTo(
    CameraOptions cameraOptions,
    MapAnimationOptions? mapAnimationOptions,
  ) => throw _ni('easeTo');

  @override
  Future<void> flyTo(
    CameraOptions cameraOptions,
    MapAnimationOptions? mapAnimationOptions,
  ) => throw _ni('flyTo');

  @override
  Future<void> pitchBy(
    double pitch,
    MapAnimationOptions? mapAnimationOptions,
  ) => throw _ni('pitchBy');

  @override
  Future<void> scaleBy(
    double amount,
    ScreenCoordinate? anchor,
    MapAnimationOptions? mapAnimationOptions,
  ) => throw _ni('scaleBy');

  @override
  Future<void> moveBy(
    ScreenCoordinate screenCoordinate,
    MapAnimationOptions? mapAnimationOptions,
  ) => throw _ni('moveBy');

  @override
  Future<void> rotateBy(
    ScreenCoordinate first,
    ScreenCoordinate second,
    MapAnimationOptions? mapAnimationOptions,
  ) => throw _ni('rotateBy');

  @override
  Future<void> cancelCameraAnimation() => throw _ni('cancelCameraAnimation');

  // ===== Coordinate / pixel conversion =====

  @override
  Future<ScreenCoordinate> pixelForCoordinate(Point coordinate) =>
      throw _ni('pixelForCoordinate');

  @override
  Future<Point> coordinateForPixel(ScreenCoordinate pixel) =>
      throw _ni('coordinateForPixel');

  @override
  Future<List<ScreenCoordinate?>> pixelsForCoordinates(
    List<Point> coordinates,
  ) => throw _ni('pixelsForCoordinates');

  @override
  Future<List<Point?>> coordinatesForPixels(List<ScreenCoordinate?> pixels) =>
      throw _ni('coordinatesForPixels');

  // ===== Map state =====

  @override
  Future<Size> getSize() => throw _ni('getSize');

  @override
  Future<void> triggerRepaint() => throw _ni('triggerRepaint');

  @override
  Future<double?> getElevation(Point coordinate) => throw _ni('getElevation');

  @override
  Future<void> reduceMemoryUse() => throw _ni('reduceMemoryUse');

  @override
  Future<void> setTileCacheBudget(
    TileCacheBudgetInMegabytes? tileCacheBudgetInMegabytes,
    TileCacheBudgetInTiles? tileCacheBudgetInTiles,
  ) => throw _ni('setTileCacheBudget');

  @override
  Future<void> clearData() => throw _ni('clearData');

  @override
  Future<MapOptions> getMapOptions() => throw _ni('getMapOptions');

  @override
  Future<Uint8List?> snapshot() => throw _ni('snapshot');

  // ===== Gesture / animation flags =====

  @override
  Future<void> setGestureInProgress(bool inProgress) =>
      throw _ni('setGestureInProgress');

  @override
  Future<bool> isGestureInProgress() => throw _ni('isGestureInProgress');

  @override
  Future<void> setUserAnimationInProgress(bool inProgress) =>
      throw _ni('setUserAnimationInProgress');

  @override
  Future<bool> isUserAnimationInProgress() =>
      throw _ni('isUserAnimationInProgress');

  @override
  Future<void> setPrefetchZoomDelta(int delta) =>
      throw _ni('setPrefetchZoomDelta');

  @override
  Future<int> getPrefetchZoomDelta() => throw _ni('getPrefetchZoomDelta');

  // ===== Snapshotter / glyphs =====

  @override
  Future<void> setSnapshotLegacyMode(bool enabled) =>
      throw _ni('setSnapshotLegacyMode');

  @override
  Future<String> styleGlyphURL() => throw _ni('styleGlyphURL');

  @override
  Future<void> setStyleGlyphURL(String glyphURL) =>
      throw _ni('setStyleGlyphURL');

  // ===== Orientation =====

  @override
  Future<void> setNorthOrientation(NorthOrientation orientation) =>
      throw _ni('setNorthOrientation');

  @override
  Future<void> setConstrainMode(ConstrainMode mode) =>
      throw _ni('setConstrainMode');

  @override
  Future<void> setViewportMode(ViewportMode mode) =>
      throw _ni('setViewportMode');

  // ===== Interactions =====

  @override
  void addInteraction<T extends TypedFeaturesetFeature<FeaturesetDescriptor>>(
    TypedInteraction<T> interaction, {
    String? interactionID,
  }) => throw _ni('addInteraction');

  @override
  void removeInteraction(String interactionID) =>
      throw _ni('removeInteraction');

  // ===== Feature queries =====

  @override
  Future<List<QueriedRenderedFeature?>> queryRenderedFeatures(
    RenderedQueryGeometry geometry,
    RenderedQueryOptions options,
  ) => throw _ni('queryRenderedFeatures');

  @override
  Future<List<QueriedSourceFeature?>> querySourceFeatures(
    String sourceId,
    SourceQueryOptions options,
  ) => throw _ni('querySourceFeatures');

  @override
  Future<FeatureExtensionValue> getGeoJsonClusterLeaves(
    String sourceIdentifier,
    Map<String?, Object?> cluster,
    int? limit,
    int? offset,
  ) => throw _ni('getGeoJsonClusterLeaves');

  @override
  Future<FeatureExtensionValue> getGeoJsonClusterChildren(
    String sourceIdentifier,
    Map<String?, Object?> cluster,
  ) => throw _ni('getGeoJsonClusterChildren');

  @override
  Future<FeatureExtensionValue> getGeoJsonClusterExpansionZoom(
    String sourceIdentifier,
    Map<String?, Object?> cluster,
  ) => throw _ni('getGeoJsonClusterExpansionZoom');

  @override
  Future<List<FeaturesetFeature>> queryRenderedFeaturesForFeatureset({
    required FeaturesetDescriptor featureset,
    RenderedQueryGeometry? geometry,
    String? filter,
  }) => throw _ni('queryRenderedFeaturesForFeatureset');

  // ===== Source-feature state (pre-Featureset shapes) =====

  @override
  Future<void> setFeatureState(
    String sourceId,
    String? sourceLayerId,
    String featureId,
    String state,
  ) => throw _ni('setFeatureState');

  @override
  Future<String> getFeatureState(
    String sourceId,
    String? sourceLayerId,
    String featureId,
  ) => throw _ni('getFeatureState');

  @override
  Future<void> removeFeatureState(
    String sourceId,
    String? sourceLayerId,
    String featureId,
    String? stateKey,
  ) => throw _ni('removeFeatureState');

  // ===== Featureset state =====

  @override
  Future<void> setFeatureStateForFeaturesetDescriptor(
    FeaturesetDescriptor featureset,
    FeaturesetFeatureId featureId,
    FeatureState state,
  ) => throw _ni('setFeatureStateForFeaturesetDescriptor');

  @override
  Future<void> setFeatureStateForFeaturesetFeature(
    FeaturesetFeature feature,
    FeatureState state,
  ) => throw _ni('setFeatureStateForFeaturesetFeature');

  @override
  Future<Map<String, Object?>> getFeatureStateForFeaturesetDescriptor(
    FeaturesetDescriptor featureset,
    FeaturesetFeatureId featureId,
  ) => throw _ni('getFeatureStateForFeaturesetDescriptor');

  @override
  Future<Map<String, Object?>> getFeatureStateForFeaturesetFeature(
    FeaturesetFeature feature,
  ) => throw _ni('getFeatureStateForFeaturesetFeature');

  @override
  Future<void> removeFeatureStateForFeaturesetDescriptor({
    required FeaturesetDescriptor featureset,
    required FeaturesetFeatureId featureId,
    String? stateKey,
  }) => throw _ni('removeFeatureStateForFeaturesetDescriptor');

  @override
  Future<void> removeFeatureStateForFeaturesetFeature({
    required FeaturesetFeature feature,
    String? stateKey,
  }) => throw _ni('removeFeatureStateForFeaturesetFeature');

  @override
  Future<void> resetFeatureStatesForFeatureset(
    FeaturesetDescriptor featureset,
  ) => throw _ni('resetFeatureStatesForFeatureset');

  // ===== Debug options =====

  @override
  Future<List<MapWidgetDebugOptions>> getDebugOptions() =>
      throw UnsupportedError('MapWidgetDebugOptions is not supported on web.');

  @override
  Future<void> setDebugOptions(List<MapWidgetDebugOptions> options) =>
      throw UnsupportedError('MapWidgetDebugOptions is not supported on web.');

  // ===== Lifecycle =====

  @override
  void dispose() {
    // The JSMap instance is owned by `_MapWebWidgetState` and torn down in
    // its own `dispose()` (see map_widget.dart). Nothing to release here.
  }
}

UnimplementedError _ni(String method) =>
    UnimplementedError('MapboxMap.$method is not yet implemented on web.');
