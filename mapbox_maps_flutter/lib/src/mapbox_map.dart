import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';
import 'package:turf/turf.dart';

import 'annotations_manager.dart';
import 'attribution_settings.dart';
import 'compass_settings.dart';
import 'gestures_settings.dart';
import 'http_service.dart';
import 'indoor_selector_settings.dart';
import 'location_settings.dart';
import 'logo_settings.dart';
import 'map_recorder.dart';
import 'projection.dart';
import 'scale_bar_settings.dart';
import 'style_manager.dart';

/// User-facing controller for a Mapbox map instance.
///
/// Application code and the [MapCreatedCallback] in [MapWidget] use this class.
/// Platform packages implement [MapboxMapPlatformInterface] directly.
class MapboxMap implements MapboxMapInterface {
  final MapboxMapPlatformInterface _impl;

  @internal
  MapboxMap(this._impl);

  // ===== Sub-interfaces =====

  /// Provides access to the map's style APIs.
  late final StyleManager style = StyleManager(_impl.style);

  /// Provides access to gesture configuration.
  late final GesturesSettingsManager gestures = GesturesSettingsManager(
    _impl.gestures,
  );

  /// Provides access to the user location indicator.
  late final LocationSettingsManager location = LocationSettingsManager(
    _impl.location,
  );

  /// Provides access to the scale bar ornament settings.
  late final ScaleBarSettingsManager scaleBar = ScaleBarSettingsManager(
    _impl.scaleBar,
  );

  /// Provides access to the compass ornament settings.
  late final CompassSettingsManager compass = CompassSettingsManager(
    _impl.compass,
  );

  /// Provides access to the attribution ornament settings.
  late final AttributionSettingsManager attribution =
      AttributionSettingsManager(_impl.attribution);

  /// Provides access to the Mapbox logo ornament settings.
  late final LogoSettingsManager logo = LogoSettingsManager(_impl.logo);

  /// Provides access to the indoor floor selector settings.
  late final IndoorSelectorSettingsManager indoorSelector =
      IndoorSelectorSettingsManager(_impl.indoorSelector);

  /// Provides access to annotation manager creation.
  late final AnnotationManager annotations = AnnotationManager(
    _impl.annotations,
  );

  /// Provides access to HTTP request configuration.
  late final MapboxHttpService httpService = MapboxHttpService(
    _impl.httpService,
  );

  /// Provides access to Spherical Mercator projection math.
  late final Projection projection = Projection(_impl.projection);

  /// Provides access to recording and replaying API calls on the map.
  @experimental
  late final MapRecorder mapRecorder = MapRecorder(_impl.mapRecorder);

  // ===== Gesture listeners =====

  /// Invoked on a map tap gesture.
  OnMapTapListener? get onMapTapListener => _impl.onMapTapListener;
  set onMapTapListener(OnMapTapListener? listener) =>
      _impl.onMapTapListener = listener;

  /// Invoked on a map long-tap gesture.
  OnMapLongTapListener? get onMapLongTapListener => _impl.onMapLongTapListener;
  set onMapLongTapListener(OnMapLongTapListener? listener) =>
      _impl.onMapLongTapListener = listener;

  /// Invoked on a map scroll gesture.
  OnMapScrollListener? get onMapScrollListener => _impl.onMapScrollListener;
  set onMapScrollListener(OnMapScrollListener? listener) =>
      _impl.onMapScrollListener = listener;

  /// Invoked on a map zoom gesture.
  OnMapZoomListener? get onMapZoomListener => _impl.onMapZoomListener;
  set onMapZoomListener(OnMapZoomListener? listener) =>
      _impl.onMapZoomListener = listener;

  // ===== Style loading =====

  /// Loads the style from a given URI.
  Future<void> loadStyleURI(String styleURI) => _impl.loadStyleURI(styleURI);

  /// Loads the style from a JSON string.
  Future<void> loadStyleJson(String styleJson) =>
      _impl.loadStyleJson(styleJson);

  // ===== Camera getters / setters =====

  /// Returns the current camera state.
  Future<CameraState> getCameraState() => _impl.getCameraState();

  /// Sets the camera to the given [CameraOptions] without animation.
  Future<void> setCamera(CameraOptions cameraOptions) =>
      _impl.setCamera(cameraOptions);

  // ===== Camera convenience =====

  /// Returns camera options that fit the given [coordinates] with optional padding, max zoom and offset.
  Future<CameraOptions> cameraForCoordinatesPadding(
    List<Point> coordinates,
    CameraOptions camera,
    MbxEdgeInsets? coordinatesPadding,
    double? maxZoom,
    ScreenCoordinate? offset,
  ) => _impl.cameraForCoordinatesPadding(
    coordinates,
    camera,
    coordinatesPadding,
    maxZoom,
    offset,
  );

  /// Returns camera options that fit the given coordinate [bounds].
  Future<CameraOptions> cameraForCoordinateBounds(
    CoordinateBounds bounds,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
    double? maxZoom,
    ScreenCoordinate? offset,
  ) => _impl.cameraForCoordinateBounds(
    bounds,
    padding,
    bearing,
    pitch,
    maxZoom,
    offset,
  );

  /// Returns camera options centered on the given [coordinates].
  Future<CameraOptions> cameraForCoordinates(
    List<Point> coordinates,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
  ) => _impl.cameraForCoordinates(coordinates, padding, bearing, pitch);

  /// Returns the camera options adjusted so the given [coordinates] fit
  /// inside the given [box], using the given starting [camera] state.
  Future<CameraOptions> cameraForCoordinatesCameraOptions(
    List<Point> coordinates,
    CameraOptions camera,
    ScreenBox box,
  ) => _impl.cameraForCoordinatesCameraOptions(coordinates, camera, box);

  /// Returns camera options that fit the given GeoJSON [geometry].
  Future<CameraOptions> cameraForGeometry(
    Map<String?, Object?> geometry,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
  ) => _impl.cameraForGeometry(geometry, padding, bearing, pitch);

  /// Returns the coordinate bounds that are visible for a given [camera].
  Future<CoordinateBounds> coordinateBoundsForCamera(CameraOptions camera) =>
      _impl.coordinateBoundsForCamera(camera);

  /// Returns the coordinate bounds (unwrapped) visible for a given [camera].
  Future<CoordinateBounds> coordinateBoundsForCameraUnwrapped(
    CameraOptions camera,
  ) => _impl.coordinateBoundsForCameraUnwrapped(camera);

  /// Returns the coordinate bounds and zoom for a given [camera].
  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCamera(
    CameraOptions camera,
  ) => _impl.coordinateBoundsZoomForCamera(camera);

  /// Returns the coordinate bounds (unwrapped) and zoom for a given [camera].
  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCameraUnwrapped(
    CameraOptions camera,
  ) => _impl.coordinateBoundsZoomForCameraUnwrapped(camera);

  // ===== Camera bounds =====

  /// Constrains the camera to the given bounds options.
  Future<void> setBounds(CameraBoundsOptions options) =>
      _impl.setBounds(options);

  /// Returns the current camera bounds.
  Future<CameraBounds> getBounds() => _impl.getBounds();

  // ===== Animation =====

  /// Animates the camera to [cameraOptions] using an ease animation.
  Future<void> easeTo(
    CameraOptions cameraOptions,
    MapAnimationOptions? mapAnimationOptions,
  ) => _impl.easeTo(cameraOptions, mapAnimationOptions);

  /// Animates the camera to [cameraOptions] using a fly animation.
  Future<void> flyTo(
    CameraOptions cameraOptions,
    MapAnimationOptions? mapAnimationOptions,
  ) => _impl.flyTo(cameraOptions, mapAnimationOptions);

  /// Pitches the camera by [pitch] degrees with optional animation.
  Future<void> pitchBy(
    double pitch,
    MapAnimationOptions? mapAnimationOptions,
  ) => _impl.pitchBy(pitch, mapAnimationOptions);

  /// Scales the camera by [amount] around an optional [anchor] point.
  Future<void> scaleBy(
    double amount,
    ScreenCoordinate? anchor,
    MapAnimationOptions? mapAnimationOptions,
  ) => _impl.scaleBy(amount, anchor, mapAnimationOptions);

  /// Moves the camera by a [screenCoordinate] offset.
  Future<void> moveBy(
    ScreenCoordinate screenCoordinate,
    MapAnimationOptions? mapAnimationOptions,
  ) => _impl.moveBy(screenCoordinate, mapAnimationOptions);

  /// Rotates the camera between two touch points.
  Future<void> rotateBy(
    ScreenCoordinate first,
    ScreenCoordinate second,
    MapAnimationOptions? mapAnimationOptions,
  ) => _impl.rotateBy(first, second, mapAnimationOptions);

  /// Cancels any in-progress camera animation.
  Future<void> cancelCameraAnimation() => _impl.cancelCameraAnimation();

  // ===== Coordinate / pixel conversion =====

  /// Converts a geographic [coordinate] to a screen [ScreenCoordinate].
  Future<ScreenCoordinate> pixelForCoordinate(Point coordinate) =>
      _impl.pixelForCoordinate(coordinate);

  /// Converts a [pixel] screen position to a geographic coordinate.
  Future<Point> coordinateForPixel(ScreenCoordinate pixel) =>
      _impl.coordinateForPixel(pixel);

  /// Converts a list of geographic [coordinates] to screen positions.
  Future<List<ScreenCoordinate?>> pixelsForCoordinates(
    List<Point> coordinates,
  ) => _impl.pixelsForCoordinates(coordinates);

  /// Converts a list of screen [pixels] to geographic coordinates.
  Future<List<Point?>> coordinatesForPixels(List<ScreenCoordinate?> pixels) =>
      _impl.coordinatesForPixels(pixels);

  // ===== Map state =====

  /// Returns the current map size in logical pixels.
  Future<Size> getSize() => _impl.getSize();

  /// Triggers a repaint of the map.
  Future<void> triggerRepaint() => _impl.triggerRepaint();

  /// Returns the elevation in meters at the given [coordinate].
  Future<double?> getElevation(Point coordinate) =>
      _impl.getElevation(coordinate);

  /// Reduces memory usage by clearing caches.
  Future<void> reduceMemoryUse() => _impl.reduceMemoryUse();

  /// Sets the tile cache budget.
  Future<void> setTileCacheBudget(
    TileCacheBudgetInMegabytes? tileCacheBudgetInMegabytes,
    TileCacheBudgetInTiles? tileCacheBudgetInTiles,
  ) => _impl.setTileCacheBudget(
    tileCacheBudgetInMegabytes,
    tileCacheBudgetInTiles,
  );

  /// Clears temporary map data for this instance, freeing resources.
  Future<void> clearData() => _impl.clearData();

  /// Returns the configured `MapOptions` for this map.
  Future<MapOptions> getMapOptions() => _impl.getMapOptions();

  /// Captures a snapshot of the current map view as PNG-encoded bytes.
  /// Returns null if the snapshot operation timed out or otherwise failed.
  Future<Uint8List?> snapshot() => _impl.snapshot();

  // ===== Gesture / animation flags =====

  /// Tells the rendering engine that a gesture is in progress so labels can
  /// switch to gesture-friendly texture filters.
  Future<void> setGestureInProgress(bool inProgress) =>
      _impl.setGestureInProgress(inProgress);

  /// Returns whether a gesture is currently in progress.
  Future<bool> isGestureInProgress() => _impl.isGestureInProgress();

  /// Tells the rendering engine that a user-driven animation is in progress
  /// so symbol placement is more stable.
  Future<void> setUserAnimationInProgress(bool inProgress) =>
      _impl.setUserAnimationInProgress(inProgress);

  /// Returns whether a user-driven animation is currently in progress.
  Future<bool> isUserAnimationInProgress() => _impl.isUserAnimationInProgress();

  /// Sets the prefetch zoom delta. When non-zero, the engine first requests
  /// tiles `delta` levels below the target zoom so the map fills in faster
  /// at lower resolution.
  Future<void> setPrefetchZoomDelta(int delta) =>
      _impl.setPrefetchZoomDelta(delta);

  /// Returns the current prefetch zoom delta.
  Future<int> getPrefetchZoomDelta() => _impl.getPrefetchZoomDelta();

  /// Dispatches a synthetic gesture event for testing purposes.
  ///
  /// For internal use only.
  @experimental
  @visibleForTesting
  Future<void> dispatch(String gesture, ScreenCoordinate screenCoordinate) =>
      _impl.dispatch(gesture, screenCoordinate);

  // ===== Legacy gesture listener aliases (v2 surface) =====

  /// Legacy alias for `MapWidget.onScrollListener`. Stores the callback;
  /// it fires on map scroll gestures.
  void setOnMapMoveListener(OnMapScrollListener? listener) {
    _impl.onMapScrollListener = listener;
  }

  /// Legacy alias for `MapWidget.onZoomListener`. Stores the callback;
  /// it fires on map zoom gestures.
  void setOnMapZoomListener(OnMapZoomListener? listener) {
    _impl.onMapZoomListener = listener;
  }

  // ===== Snapshotter / glyphs =====

  /// Sets whether legacy mode is used for [snapshot]. Has no effect on iOS.
  @experimental
  Future<void> setSnapshotLegacyMode(bool enabled) =>
      _impl.setSnapshotLegacyMode(enabled);

  /// Returns the runtime glyph URL used for text labels.
  @experimental
  Future<String> styleGlyphURL() => _impl.styleGlyphURL();

  /// Sets the runtime glyph URL used for text labels.
  @experimental
  Future<void> setStyleGlyphURL(String glyphURL) =>
      _impl.setStyleGlyphURL(glyphURL);

  // ===== Map orientation =====

  /// Sets the map's north orientation.
  Future<void> setNorthOrientation(NorthOrientation orientation) =>
      _impl.setNorthOrientation(orientation);

  /// Sets the map's constrain mode.
  Future<void> setConstrainMode(ConstrainMode mode) =>
      _impl.setConstrainMode(mode);

  /// Sets the map's viewport mode.
  Future<void> setViewportMode(ViewportMode mode) =>
      _impl.setViewportMode(mode);

  // ===== Interactions =====

  /// Adds an interaction to the map.
  ///
  /// An [interactionID] can be provided to later remove the interaction
  /// with [removeInteraction].
  void addInteraction<T extends TypedFeaturesetFeature<FeaturesetDescriptor>>(
    TypedInteraction<T> interaction, {
    String? interactionID,
  }) => _impl.addInteraction(interaction, interactionID: interactionID);

  /// Removes an interaction from the map by its [interactionID].
  void removeInteraction(String interactionID) =>
      _impl.removeInteraction(interactionID);

  // ===== Feature queries =====

  /// Queries the map for rendered features inside [geometry] matching the
  /// given query [options].
  Future<List<QueriedRenderedFeature?>> queryRenderedFeatures(
    RenderedQueryGeometry geometry,
    RenderedQueryOptions options,
  ) => _impl.queryRenderedFeatures(geometry, options);

  /// Queries the source identified by [sourceId] for features matching the
  /// given query [options].
  Future<List<QueriedSourceFeature?>> querySourceFeatures(
    String sourceId,
    SourceQueryOptions options,
  ) => _impl.querySourceFeatures(sourceId, options);

  /// Returns the leaves (original points) of a cluster from a GeoJSON source.
  Future<FeatureExtensionValue> getGeoJsonClusterLeaves(
    String sourceIdentifier,
    Map<String?, Object?> cluster,
    int? limit,
    int? offset,
  ) => _impl.getGeoJsonClusterLeaves(sourceIdentifier, cluster, limit, offset);

  /// Returns the children of a cluster from a GeoJSON source.
  Future<FeatureExtensionValue> getGeoJsonClusterChildren(
    String sourceIdentifier,
    Map<String?, Object?> cluster,
  ) => _impl.getGeoJsonClusterChildren(sourceIdentifier, cluster);

  /// Returns the zoom at which a cluster expands into multiple children.
  Future<FeatureExtensionValue> getGeoJsonClusterExpansionZoom(
    String sourceIdentifier,
    Map<String?, Object?> cluster,
  ) => _impl.getGeoJsonClusterExpansionZoom(sourceIdentifier, cluster);

  /// Queries the map for rendered features matching a [featureset].
  Future<List<FeaturesetFeature>> queryRenderedFeaturesForFeatureset({
    required FeaturesetDescriptor featureset,
    RenderedQueryGeometry? geometry,
    String? filter,
  }) => _impl.queryRenderedFeaturesForFeatureset(
    featureset: featureset,
    geometry: geometry,
    filter: filter,
  );

  // ===== Source-feature state (pre-Featureset shapes) =====

  /// Updates entries in the state map of a feature within a style source.
  Future<void> setFeatureState(
    String sourceId,
    String? sourceLayerId,
    String featureId,
    String state,
  ) => _impl.setFeatureState(sourceId, sourceLayerId, featureId, state);

  /// Returns the state map of a feature within a style source as a JSON string.
  Future<String> getFeatureState(
    String sourceId,
    String? sourceLayerId,
    String featureId,
  ) => _impl.getFeatureState(sourceId, sourceLayerId, featureId);

  /// Removes a single state property (or all properties) from a feature
  /// within a style source. Pass `null` for [stateKey] to remove all.
  Future<void> removeFeatureState(
    String sourceId,
    String? sourceLayerId,
    String featureId,
    String? stateKey,
  ) => _impl.removeFeatureState(sourceId, sourceLayerId, featureId, stateKey);

  // ===== Featureset state =====

  /// Updates entries in the state map of a feature within a [featureset].
  Future<void> setFeatureStateForFeaturesetDescriptor(
    FeaturesetDescriptor featureset,
    FeaturesetFeatureId featureId,
    FeatureState state,
  ) => _impl.setFeatureStateForFeaturesetDescriptor(
    featureset,
    featureId,
    state,
  );

  /// Updates the state map of an individual [feature].
  Future<void> setFeatureStateForFeaturesetFeature(
    FeaturesetFeature feature,
    FeatureState state,
  ) => _impl.setFeatureStateForFeaturesetFeature(feature, state);

  /// Gets the state map of a feature within a [featureset].
  Future<Map<String, Object?>> getFeatureStateForFeaturesetDescriptor(
    FeaturesetDescriptor featureset,
    FeaturesetFeatureId featureId,
  ) => _impl.getFeatureStateForFeaturesetDescriptor(featureset, featureId);

  /// Gets the state map of a [feature].
  Future<Map<String, Object?>> getFeatureStateForFeaturesetFeature(
    FeaturesetFeature feature,
  ) => _impl.getFeatureStateForFeaturesetFeature(feature);

  /// Removes entries from a feature state object within a [featureset].
  Future<void> removeFeatureStateForFeaturesetDescriptor({
    required FeaturesetDescriptor featureset,
    required FeaturesetFeatureId featureId,
    String? stateKey,
  }) => _impl.removeFeatureStateForFeaturesetDescriptor(
    featureset: featureset,
    featureId: featureId,
    stateKey: stateKey,
  );

  /// Removes entries from a [feature] state object.
  Future<void> removeFeatureStateForFeaturesetFeature({
    required FeaturesetFeature feature,
    String? stateKey,
  }) => _impl.removeFeatureStateForFeaturesetFeature(
    feature: feature,
    stateKey: stateKey,
  );

  /// Resets all feature states within a [featureset].
  Future<void> resetFeatureStatesForFeatureset(
    FeaturesetDescriptor featureset,
  ) => _impl.resetFeatureStatesForFeatureset(featureset);

  // ===== Performance statistics =====

  /// Starts collecting CPU/GPU render performance statistics with the
  /// given [options], delivering each sampled snapshot to [listener].
  /// Calling this while collection is already active replaces the previous
  /// listener; call [stopPerformanceStatisticsCollection] before restarting.
  @experimental
  void startPerformanceStatisticsCollection(
    PerformanceStatisticsOptions options,
    PerformanceStatisticsListener listener,
  ) => _impl.startPerformanceStatisticsCollection(options, listener);

  /// Stops collection started by [startPerformanceStatisticsCollection].
  /// No-op when no collection is active.
  @experimental
  void stopPerformanceStatisticsCollection() =>
      _impl.stopPerformanceStatisticsCollection();

  // ===== Debug options =====

  /// Returns the currently-enabled widget debug options for this map.
  Future<List<MapWidgetDebugOptions>> getDebugOptions() =>
      _impl.getDebugOptions();

  /// Replaces the set of enabled widget debug options with [options].
  Future<void> setDebugOptions(List<MapWidgetDebugOptions> options) =>
      _impl.setDebugOptions(options);

  // ===== Lifecycle =====

  /// Releases resources held by this map instance.
  void dispose() => _impl.dispose();
}
