import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:turf/turf.dart';

import '../debug_options.dart';
import '../interactive_features.dart';
import '../pigeons/platform_interface_data_types.dart';
import 'annotations_interface.dart';
import 'http_service_interface.dart';
import 'location_settings_interface.dart';
import 'map_recorder_interface.dart';
import 'performance_statistics_listener.dart';
import 'projection_interface.dart';
import 'settings_interfaces.dart';
import 'style_interface.dart';

/// Marker interface for a MapboxMap instance.
abstract interface class MapboxMapInterface {}

/// Abstract per-instance controller for a Mapbox map.
///
/// Both [mapbox_maps_flutter_mobile] and [mapbox_maps_flutter_web] must
/// provide a concrete implementation that is returned via
/// [MapboxMapsFlutterPlatform.buildView]'s `onMapCreated` callback.
abstract interface class MapboxMapPlatformInterface
    implements MapboxMapInterface {
  // ===== Sub-interfaces =====

  /// Provides access to the map's style APIs.
  StylePlatformInterface get style;

  /// Provides access to gesture configuration.
  GesturesSettingsPlatformInterface get gestures;

  /// Provides access to the user location indicator.
  LocationSettingsPlatformInterface get location;

  /// Provides access to the scale bar ornament settings.
  ScaleBarSettingsPlatformInterface get scaleBar;

  /// Provides access to the compass ornament settings.
  CompassSettingsPlatformInterface get compass;

  /// Provides access to the attribution ornament settings.
  AttributionSettingsPlatformInterface get attribution;

  /// Provides access to the Mapbox logo ornament settings.
  LogoSettingsPlatformInterface get logo;

  /// Provides access to the indoor floor selector settings.
  IndoorSelectorSettingsPlatformInterface get indoorSelector;

  /// Provides access to annotation manager creation.
  AnnotationManagerPlatformInterface get annotations;

  /// Provides access to HTTP request configuration.
  MapboxHttpServicePlatformInterface get httpService;

  /// Provides access to Spherical Mercator projection math.
  ProjectionPlatformInterface get projection;

  /// Provides access to recording and replaying API calls on the map.
  @experimental
  MapRecorderPlatformInterface get mapRecorder;

  // ===== Performance statistics =====

  /// Starts collecting CPU/GPU render performance statistics with the
  /// given [options], delivering each sampled snapshot to [listener].
  /// Calling this while collection is already active replaces the
  /// previous listener; call [stopPerformanceStatisticsCollection]
  /// before restarting.
  void startPerformanceStatisticsCollection(
    PerformanceStatisticsOptions options,
    PerformanceStatisticsListener listener,
  );

  /// Stops collection started by [startPerformanceStatisticsCollection].
  /// No-op when no collection is active.
  void stopPerformanceStatisticsCollection();

  // ===== Style loading =====

  /// Loads the style from a given URI.
  Future<void> loadStyleURI(String styleURI);

  /// Loads the style from a JSON string.
  Future<void> loadStyleJson(String styleJson);

  // ===== Camera getters / setters =====

  /// Returns the current camera state.
  Future<CameraState> getCameraState();

  /// Sets the camera to the given [CameraOptions] without animation.
  Future<void> setCamera(CameraOptions cameraOptions);

  // ===== Camera convenience =====

  /// Returns camera options that fit the given [coordinates] with optional padding, max zoom and offset.
  Future<CameraOptions> cameraForCoordinatesPadding(
    List<Point> coordinates,
    CameraOptions camera,
    MbxEdgeInsets? coordinatesPadding,
    double? maxZoom,
    ScreenCoordinate? offset,
  );

  /// Returns camera options that fit the given coordinate [bounds].
  Future<CameraOptions> cameraForCoordinateBounds(
    CoordinateBounds bounds,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
    double? maxZoom,
    ScreenCoordinate? offset,
  );

  /// Returns camera options centered on the given [coordinates].
  Future<CameraOptions> cameraForCoordinates(
    List<Point> coordinates,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
  );

  /// Returns the camera options adjusted so the given [coordinates] fit
  /// inside the given [box], using the given starting [camera] state.
  Future<CameraOptions> cameraForCoordinatesCameraOptions(
    List<Point> coordinates,
    CameraOptions camera,
    ScreenBox box,
  );

  /// Returns camera options that fit the given GeoJSON [geometry].
  Future<CameraOptions> cameraForGeometry(
    Map<String?, Object?> geometry,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
  );

  /// Returns the coordinate bounds that are visible for a given [camera].
  Future<CoordinateBounds> coordinateBoundsForCamera(CameraOptions camera);

  /// Returns the coordinate bounds (unwrapped) visible for a given [camera].
  Future<CoordinateBounds> coordinateBoundsForCameraUnwrapped(
    CameraOptions camera,
  );

  /// Returns the coordinate bounds and zoom for a given [camera].
  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCamera(
    CameraOptions camera,
  );

  /// Returns the coordinate bounds (unwrapped) and zoom for a given [camera].
  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCameraUnwrapped(
    CameraOptions camera,
  );

  // ===== Camera bounds =====

  /// Constrains the camera to the given bounds options.
  Future<void> setBounds(CameraBoundsOptions options);

  /// Returns the current camera bounds.
  Future<CameraBounds> getBounds();

  // ===== Animation =====

  /// Animates the camera to [cameraOptions] using an ease animation.
  Future<void> easeTo(
    CameraOptions cameraOptions,
    MapAnimationOptions? mapAnimationOptions,
  );

  /// Animates the camera to [cameraOptions] using a fly animation.
  Future<void> flyTo(
    CameraOptions cameraOptions,
    MapAnimationOptions? mapAnimationOptions,
  );

  /// Pitches the camera by [pitch] degrees with optional animation.
  Future<void> pitchBy(double pitch, MapAnimationOptions? mapAnimationOptions);

  /// Scales the camera by [amount] around an optional [anchor] point.
  Future<void> scaleBy(
    double amount,
    ScreenCoordinate? anchor,
    MapAnimationOptions? mapAnimationOptions,
  );

  /// Moves the camera by a [screenCoordinate] offset.
  Future<void> moveBy(
    ScreenCoordinate screenCoordinate,
    MapAnimationOptions? mapAnimationOptions,
  );

  /// Rotates the camera between two touch points.
  Future<void> rotateBy(
    ScreenCoordinate first,
    ScreenCoordinate second,
    MapAnimationOptions? mapAnimationOptions,
  );

  /// Cancels any in-progress camera animation.
  Future<void> cancelCameraAnimation();

  // ===== Coordinate / pixel conversion =====

  /// Converts a geographic [coordinate] to a screen [ScreenCoordinate].
  Future<ScreenCoordinate> pixelForCoordinate(Point coordinate);

  /// Converts a [pixel] screen position to a geographic coordinate.
  Future<Point> coordinateForPixel(ScreenCoordinate pixel);

  /// Converts a list of geographic [coordinates] to screen positions.
  Future<List<ScreenCoordinate>> pixelsForCoordinates(List<Point> coordinates);

  /// Converts a list of screen [pixels] to geographic coordinates.
  Future<List<Point>> coordinatesForPixels(List<ScreenCoordinate> pixels);

  // ===== Map state =====

  /// Returns the current map size in logical pixels.
  Future<Size> getSize();

  /// Triggers a repaint of the map.
  Future<void> triggerRepaint();

  /// Returns the elevation in meters at the given [coordinate].
  Future<double?> getElevation(Point coordinate);

  /// Reduces memory usage by clearing caches.
  Future<void> reduceMemoryUse();

  /// Sets the tile cache budget.
  Future<void> setTileCacheBudget(
    TileCacheBudgetInMegabytes? tileCacheBudgetInMegabytes,
    TileCacheBudgetInTiles? tileCacheBudgetInTiles,
  );

  /// Clears temporary map data for this instance, freeing resources.
  Future<void> clearData();

  /// Returns the configured `MapOptions` for this map.
  Future<MapOptions> getMapOptions();

  /// Captures a snapshot of the current map view as PNG-encoded bytes.
  Future<Uint8List> snapshot();

  // ===== Gesture / animation flags =====

  /// Tells the rendering engine that a gesture is in progress so labels can
  /// switch to gesture-friendly texture filters.
  Future<void> setGestureInProgress(bool inProgress);

  /// Returns whether a gesture is currently in progress.
  Future<bool> isGestureInProgress();

  /// Tells the rendering engine that a user-driven animation is in progress
  /// so symbol placement is more stable.
  Future<void> setUserAnimationInProgress(bool inProgress);

  /// Returns whether a user-driven animation is currently in progress.
  Future<bool> isUserAnimationInProgress();

  /// Sets the prefetch zoom delta. When non-zero, the engine first requests
  /// tiles `delta` levels below the target zoom so the map fills in faster
  /// at lower resolution.
  Future<void> setPrefetchZoomDelta(int delta);

  /// Returns the current prefetch zoom delta.
  Future<int> getPrefetchZoomDelta();

  /// Dispatches a synthetic gesture event for testing purposes.
  ///
  /// For internal use only.
  Future<void> dispatch(String gesture, ScreenCoordinate screenCoordinate);

  // ===== Snapshotter / glyphs =====

  /// Sets whether legacy mode is used for [snapshot]. Has no effect on iOS.
  @experimental
  Future<void> setSnapshotLegacyMode(bool enabled);

  /// Returns the runtime glyph URL used for text labels.
  @experimental
  Future<String> styleGlyphURL();

  /// Sets the runtime glyph URL used for text labels.
  @experimental
  Future<void> setStyleGlyphURL(String glyphURL);

  // ===== Map orientation =====

  /// Sets the map's north orientation.
  Future<void> setNorthOrientation(NorthOrientation orientation);

  /// Sets the map's constrain mode.
  Future<void> setConstrainMode(ConstrainMode mode);

  /// Sets the map's viewport mode.
  Future<void> setViewportMode(ViewportMode mode);

  // ===== Interactions =====

  /// Adds an interaction to the map.
  ///
  /// An [interactionID] can be provided to later remove the interaction
  /// with [removeInteraction].
  void addInteraction<T extends TypedFeaturesetFeature<FeaturesetDescriptor>>(
    TypedInteraction<T> interaction, {
    String? interactionID,
  });

  /// Removes an interaction from the map by its [interactionID].
  void removeInteraction(String interactionID);

  // ===== Feature queries =====

  /// Queries the map for rendered features inside [geometry] matching the
  /// given query [options].
  Future<List<QueriedRenderedFeature?>> queryRenderedFeatures(
    RenderedQueryGeometry geometry,
    RenderedQueryOptions options,
  );

  /// Queries the source identified by [sourceId] for features matching the
  /// given query [options].
  Future<List<QueriedSourceFeature?>> querySourceFeatures(
    String sourceId,
    SourceQueryOptions options,
  );

  /// Returns the leaves (original points) of a cluster from a GeoJSON source.
  Future<FeatureExtensionValue> getGeoJsonClusterLeaves(
    String sourceIdentifier,
    Map<String?, Object?> cluster,
    int? limit,
    int? offset,
  );

  /// Returns the children of a cluster from a GeoJSON source.
  Future<FeatureExtensionValue> getGeoJsonClusterChildren(
    String sourceIdentifier,
    Map<String?, Object?> cluster,
  );

  /// Returns the zoom at which a cluster expands into multiple children.
  Future<FeatureExtensionValue> getGeoJsonClusterExpansionZoom(
    String sourceIdentifier,
    Map<String?, Object?> cluster,
  );

  /// Queries the map for rendered features matching a [featureset].
  Future<List<FeaturesetFeature>> queryRenderedFeaturesForFeatureset({
    required FeaturesetDescriptor featureset,
    RenderedQueryGeometry? geometry,
    String? filter,
  });

  // ===== Source-feature state (pre-Featureset shapes) =====

  /// Updates entries in the state map of a feature within a style source.
  Future<void> setFeatureState(
    String sourceId,
    String? sourceLayerId,
    String featureId,
    String state,
  );

  /// Returns the state map of a feature within a style source as a JSON string.
  Future<String> getFeatureState(
    String sourceId,
    String? sourceLayerId,
    String featureId,
  );

  /// Removes a single state property (or all properties) from a feature
  /// within a style source. Pass `null` for [stateKey] to remove all.
  Future<void> removeFeatureState(
    String sourceId,
    String? sourceLayerId,
    String featureId,
    String? stateKey,
  );

  // ===== Featureset state =====

  /// Updates entries in the state map of a feature within a [featureset].
  Future<void> setFeatureStateForFeaturesetDescriptor(
    FeaturesetDescriptor featureset,
    FeaturesetFeatureId featureId,
    FeatureState state,
  );

  /// Updates the state map of an individual [feature].
  Future<void> setFeatureStateForFeaturesetFeature(
    FeaturesetFeature feature,
    FeatureState state,
  );

  /// Gets the state map of a feature within a [featureset].
  Future<Map<String, Object?>> getFeatureStateForFeaturesetDescriptor(
    FeaturesetDescriptor featureset,
    FeaturesetFeatureId featureId,
  );

  /// Gets the state map of a [feature].
  Future<Map<String, Object?>> getFeatureStateForFeaturesetFeature(
    FeaturesetFeature feature,
  );

  /// Removes entries from a feature state object within a [featureset].
  Future<void> removeFeatureStateForFeaturesetDescriptor({
    required FeaturesetDescriptor featureset,
    required FeaturesetFeatureId featureId,
    String? stateKey,
  });

  /// Removes entries from a [feature] state object.
  Future<void> removeFeatureStateForFeaturesetFeature({
    required FeaturesetFeature feature,
    String? stateKey,
  });

  /// Resets all feature states within a [featureset].
  Future<void> resetFeatureStatesForFeatureset(FeaturesetDescriptor featureset);

  // ===== Debug options =====

  /// Returns the currently-enabled widget debug options for this map.
  Future<List<MapWidgetDebugOptions>> getDebugOptions();

  /// Replaces the set of enabled widget debug options with [options].
  Future<void> setDebugOptions(List<MapWidgetDebugOptions> options);

  // ===== Lifecycle =====

  /// Releases resources held by this map instance.
  void dispose();
}
