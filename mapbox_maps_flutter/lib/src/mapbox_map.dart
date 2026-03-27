import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart';

import 'annotations_manager.dart';
import 'attribution_settings.dart';
import 'compass_settings.dart';
import 'gestures_settings.dart';
import 'http_service.dart';
import 'indoor_selector_settings.dart';
import 'location_settings.dart';
import 'logo_settings.dart';
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

  // ===== Lifecycle =====

  /// Releases resources held by this map instance.
  void dispose() => _impl.dispose();
}
