import 'package:turf/turf.dart';

import '../events.dart';
import '../pigeons/platform_interface_data_types.dart';
import 'annotations_interface.dart';
import 'http_service_interface.dart';
import 'location_interface.dart';
import 'settings_interfaces.dart';
import 'style_interface.dart';

/// Abstract per-instance controller for a Mapbox map.
///
/// Both [mapbox_maps_flutter_mobile] and [mapbox_maps_flutter_web] must
/// provide a concrete implementation that is returned via
/// [MapboxMapsFlutterPlatform.buildView]'s `onMapCreated` callback.
abstract interface class MapboxMapInterface {
  // ===== Sub-interfaces =====

  /// Provides access to the map's style APIs.
  StyleInterface get style;

  /// Provides access to gesture configuration.
  GesturesSettingsInterface get gestures;

  /// Provides access to the user location indicator.
  LocationInterface get location;

  /// Provides access to the scale bar ornament settings.
  ScaleBarSettingsInterface get scaleBar;

  /// Provides access to the compass ornament settings.
  CompassSettingsInterface get compass;

  /// Provides access to the attribution ornament settings.
  AttributionSettingsInterface get attribution;

  /// Provides access to the Mapbox logo ornament settings.
  LogoSettingsInterface get logo;

  /// Provides access to the indoor floor selector settings.
  IndoorSelectorSettingsInterface get indoorSelector;

  /// Provides access to annotation manager creation.
  AnnotationManagerInterface get annotations;

  /// Provides access to HTTP request configuration.
  MapboxHttpServiceInterface get httpService;

  // ===== Map events =====

  /// Invoked when the requested style has been fully loaded.
  OnStyleLoadedListener? get onStyleLoadedListener;
  set onStyleLoadedListener(OnStyleLoadedListener? listener);

  /// Invoked whenever the camera position changes.
  OnCameraChangeListener? get onCameraChangeListener;
  set onCameraChangeListener(OnCameraChangeListener? listener);

  /// Invoked when the map enters the idle state.
  OnMapIdleListener? get onMapIdleListener;
  set onMapIdleListener(OnMapIdleListener? listener);

  /// Invoked when the map finishes loading.
  OnMapLoadedListener? get onMapLoadedListener;
  set onMapLoadedListener(OnMapLoadedListener? listener);

  /// Invoked when the map encounters a loading error.
  OnMapLoadErrorListener? get onMapLoadErrorListener;
  set onMapLoadErrorListener(OnMapLoadErrorListener? listener);

  /// Invoked when the map starts rendering a frame.
  OnRenderFrameStartedListener? get onRenderFrameStartedListener;
  set onRenderFrameStartedListener(OnRenderFrameStartedListener? listener);

  /// Invoked when the map finishes rendering a frame.
  OnRenderFrameFinishedListener? get onRenderFrameFinishedListener;
  set onRenderFrameFinishedListener(OnRenderFrameFinishedListener? listener);

  /// Invoked when a source is added to the style.
  OnSourceAddedListener? get onSourceAddedListener;
  set onSourceAddedListener(OnSourceAddedListener? listener);

  /// Invoked when source data has been loaded.
  OnSourceDataLoadedListener? get onSourceDataLoadedListener;
  set onSourceDataLoadedListener(OnSourceDataLoadedListener? listener);

  /// Invoked when a source is removed from the style.
  OnSourceRemovedListener? get onSourceRemovedListener;
  set onSourceRemovedListener(OnSourceRemovedListener? listener);

  /// Invoked when style data has been loaded.
  OnStyleDataLoadedListener? get onStyleDataLoadedListener;
  set onStyleDataLoadedListener(OnStyleDataLoadedListener? listener);

  /// Invoked when the style has a missing image.
  OnStyleImageMissingListener? get onStyleImageMissingListener;
  set onStyleImageMissingListener(OnStyleImageMissingListener? listener);

  /// Invoked when a style image is no longer needed.
  OnStyleImageUnusedListener? get onStyleImageUnusedListener;
  set onStyleImageUnusedListener(OnStyleImageUnusedListener? listener);

  /// Invoked when the map makes a resource request.
  OnResourceRequestListener? get onResourceRequestListener;
  set onResourceRequestListener(OnResourceRequestListener? listener);

  // ===== Gesture listeners =====

  /// Invoked on a map tap gesture.
  OnMapTapListener? get onMapTapListener;
  set onMapTapListener(OnMapTapListener? listener);

  /// Invoked on a map long-tap gesture.
  OnMapLongTapListener? get onMapLongTapListener;
  set onMapLongTapListener(OnMapLongTapListener? listener);

  /// Invoked on a map scroll gesture.
  OnMapScrollListener? get onMapScrollListener;
  set onMapScrollListener(OnMapScrollListener? listener);

  /// Invoked on a map zoom gesture.
  OnMapZoomListener? get onMapZoomListener;
  set onMapZoomListener(OnMapZoomListener? listener);

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
    MbxEdgeInsets? padding,
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
  Future<List<ScreenCoordinate?>> pixelsForCoordinates(List<Point> coordinates);

  /// Converts a list of screen [pixels] to geographic coordinates.
  Future<List<Point?>> coordinatesForPixels(List<ScreenCoordinate?> pixels);

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

  // ===== Map orientation =====

  /// Sets the map's north orientation.
  Future<void> setNorthOrientation(NorthOrientation orientation);

  /// Sets the map's constrain mode.
  Future<void> setConstrainMode(ConstrainMode mode);

  /// Sets the map's viewport mode.
  Future<void> setViewportMode(ViewportMode mode);

  // ===== Lifecycle =====

  /// Releases resources held by this map instance.
  void dispose();
}
