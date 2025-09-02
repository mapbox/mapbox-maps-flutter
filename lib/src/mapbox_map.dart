part of mapbox_maps_flutter;

/// Geometry for querying rendered features.
class RenderedQueryGeometry {
  @Deprecated(
      'Use RenderedQueryGeometry.fromList()/fromScreenBox()/fromScreenCoordinated() instead')
  RenderedQueryGeometry({
    required this.value,
    required this.type,
  });

  RenderedQueryGeometry.fromList(List<ScreenCoordinate> points)
      : value = jsonEncode(points.map((e) => e.toJson()).toList()),
        type = Type.LIST;

  RenderedQueryGeometry.fromScreenBox(ScreenBox box)
      : value = jsonEncode(box.toJson()),
        type = Type.SCREEN_BOX;

  RenderedQueryGeometry.fromScreenCoordinate(ScreenCoordinate point)
      : value = jsonEncode(point.toJson()),
        type = Type.SCREEN_COORDINATE;

  /// ScreenCoordinate/List<ScreenCoordinate>/ScreenBox in Json mode.
  String value;

  /// Type of the geometry encoded in [value].
  Type type;
}

/// Options for enabling debugging features in a map.
class MapWidgetDebugOptions {
  final _MapWidgetDebugOptions _option;

  const MapWidgetDebugOptions._(this._option);

  /// Edges of tile boundaries are shown as thick, red lines to help diagnose
  /// tile clipping issues.
  static const MapWidgetDebugOptions tileBorders =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.tileBorders);

  /// Each tile shows its tile coordinate (x/y/z) in the upper-left corner.
  static const MapWidgetDebugOptions parseStatus =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.parseStatus);

  /// Each tile shows a timestamps with modified and expires dates or n/a if
  /// timestamp is not available.
  static const MapWidgetDebugOptions timestamps =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.timestamps);

  /// Edges of glyphs and symbols are shown as faint, green lines to help
  /// diagnose collision and label placement issues.
  static const MapWidgetDebugOptions collision =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.collision);

  /// Each drawing operation is replaced by a translucent fill. Overlapping
  /// drawing operations appear more prominent to help diagnose overdrawing.
  static const MapWidgetDebugOptions overdraw =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.overdraw);

  /// The stencil buffer is shown instead of the color buffer.
  static const MapWidgetDebugOptions stencilClip =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.stencilClip);

  /// The depth buffer is shown instead of the color buffer.
  static const MapWidgetDebugOptions depthBuffer =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.depthBuffer);

  /// Show 3D model bounding boxes.
  static const MapWidgetDebugOptions modelBounds =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.modelBounds);

  /// Show a wireframe for terrain.
  /// Supported on Android only.
  static const MapWidgetDebugOptions terrainWireframe =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.terrainWireframe);

  /// Show a wireframe for 2D layers.
  /// Supported on Android only.
  static const MapWidgetDebugOptions layers2DWireframe =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.layers2DWireframe);

  /// Show a wireframe for 3D layers.
  /// Supported on Android only.
  static const MapWidgetDebugOptions layers3DWireframe =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.layers3DWireframe);

  /// Each tile shows its local lighting conditions in the upper-left corner.
  /// (If `lights` properties are used, otherwise they show zero.)
  static const MapWidgetDebugOptions light =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.light);

  /// Show a debug overlay with information about the CameraState
  /// including lat, long, zoom, pitch, & bearing.
  static const MapWidgetDebugOptions camera =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.camera);

  /// Draws camera padding frame.
  static const MapWidgetDebugOptions padding =
      MapWidgetDebugOptions._(_MapWidgetDebugOptions.padding);
}

extension on _MapWidgetDebugOptions {
  MapWidgetDebugOptions get widgetDebugOptions {
    switch (this) {
      case _MapWidgetDebugOptions.tileBorders:
        return MapWidgetDebugOptions.tileBorders;
      case _MapWidgetDebugOptions.parseStatus:
        return MapWidgetDebugOptions.parseStatus;
      case _MapWidgetDebugOptions.timestamps:
        return MapWidgetDebugOptions.timestamps;
      case _MapWidgetDebugOptions.collision:
        return MapWidgetDebugOptions.collision;
      case _MapWidgetDebugOptions.overdraw:
        return MapWidgetDebugOptions.overdraw;
      case _MapWidgetDebugOptions.stencilClip:
        return MapWidgetDebugOptions.stencilClip;
      case _MapWidgetDebugOptions.depthBuffer:
        return MapWidgetDebugOptions.depthBuffer;
      case _MapWidgetDebugOptions.modelBounds:
        return MapWidgetDebugOptions.modelBounds;
      case _MapWidgetDebugOptions.terrainWireframe:
        return MapWidgetDebugOptions.terrainWireframe;
      case _MapWidgetDebugOptions.layers2DWireframe:
        return MapWidgetDebugOptions.layers2DWireframe;
      case _MapWidgetDebugOptions.layers3DWireframe:
        return MapWidgetDebugOptions.layers3DWireframe;
      case _MapWidgetDebugOptions.light:
        return MapWidgetDebugOptions.light;
      case _MapWidgetDebugOptions.camera:
        return MapWidgetDebugOptions.camera;
      case _MapWidgetDebugOptions.padding:
        return MapWidgetDebugOptions.padding;
    }
  }
}

/// Controller for a single MapboxMap instance running on the host platform.
class MapboxMap extends ChangeNotifier {
  MapboxMap._({
    required _MapboxMapsPlatform mapboxMapsPlatform,
    this.onMapTapListener,
    this.onMapLongTapListener,
    this.onMapScrollListener,
    this.onMapZoomListener,
  }) : _mapboxMapsPlatform = mapboxMapsPlatform {
    annotations = AnnotationManager._(mapboxMapsPlatform: _mapboxMapsPlatform);
    _setupGestures();
  }

  final _MapboxMapsPlatform _mapboxMapsPlatform;

  /// The currently loaded Style]object.
  late final StyleManager style = StyleManager(
      binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
      messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());

  /// The interface to set the location puck.
  late final LocationSettings location = LocationSettings._(
      _LocationComponentSettingsInterface(
          binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
          messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString()));

  late final _CameraManager _cameraManager = _CameraManager(
      binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
      messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());
  late final _MapInterface _mapInterface = _MapInterface(
      binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
      messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());
  late final _AnimationManager _animationManager = _AnimationManager(
      binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
      messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());
  late final _ViewportMessenger _viewportMessenger = _ViewportMessenger(
      binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
      messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());
  late final _PerformanceStatisticsApi _performanceStatistics =
      _PerformanceStatisticsApi(
          binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
          messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());

  /// The interface to create and set annotations.
  late final AnnotationManager annotations;

  // Keep Projection visible for users as iOS doesn't include it in MapboxMaps.
  /// The map projection of the style.
  late final Projection projection = Projection(
      binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
      messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());

  /// The interface to access the gesture settings.
  late final GesturesSettingsInterface gestures = GesturesSettingsInterface(
      binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
      messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());

  /// The interface to set the logo settings.
  late final LogoSettingsInterface logo = LogoSettingsInterface(
      binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
      messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());

  /// The interface to access the compass settings.
  late final CompassSettingsInterface compass = CompassSettingsInterface(
      binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
      messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());

  /// The interface to access the compass settings.
  late final ScaleBarSettingsInterface scaleBar = ScaleBarSettingsInterface(
      binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
      messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());

  /// The interface to access the attribution settings.
  late final AttributionSettingsInterface attribution =
      AttributionSettingsInterface(
          binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
          messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());
  late final MapboxHttpService httpService = MapboxHttpService(
      binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
      channelSuffix: _mapboxMapsPlatform.channelSuffix);
  OnMapTapListener? onMapTapListener;
  OnMapLongTapListener? onMapLongTapListener;
  OnMapScrollListener? onMapScrollListener;
  OnMapZoomListener? onMapZoomListener;

  @override
  void dispose() {
    _mapboxMapsPlatform.dispose();
    GestureListener.setUp(null,
        binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
        messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());
    PerformanceStatisticsListener.setUp(null,
        binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
        messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());
    super.dispose();
  }

  /// Convenience method that returns the `camera options` object for given parameters.
  Future<CameraOptions> cameraForCoordinatesPadding(
    List<Point> coordinates,
    CameraOptions camera,
    MbxEdgeInsets? coordinatesPadding,
    double? maxZoom,
    ScreenCoordinate? offset,
  ) =>
      _cameraManager.cameraForCoordinatesPadding(
        coordinates,
        camera,
        coordinatesPadding,
        maxZoom,
        offset,
      );

  /// Convenience method that returns the `camera options` object for given parameters.
  Future<CameraOptions> cameraForCoordinateBounds(
          CoordinateBounds bounds,
          MbxEdgeInsets padding,
          double? bearing,
          double? pitch,
          double? maxZoom,
          ScreenCoordinate? offset) =>
      _cameraManager.cameraForCoordinateBounds(
          bounds, padding, bearing, pitch, maxZoom, offset);

  /// Convenience method that returns the `camera options` object for given parameters.

  @Deprecated('Use [cameraForCoordinatesPadding] instead')
  Future<CameraOptions> cameraForCoordinates(List<Point> coordinates,
          MbxEdgeInsets padding, double? bearing, double? pitch) =>
      _cameraManager.cameraForCoordinates(coordinates, padding, bearing, pitch);

  /// Convenience method that adjusts the provided `camera options` object for given parameters.
  ///
  /// Returns the provided `camera` options with zoom adjusted to fit `coordinates` into the `box`, so that `coordinates` on the left,
  /// top and right of the effective `camera` center at the principal point of the projection (defined by `padding`) fit into the `box`.
  /// Returns the provided `camera` options object unchanged upon an error.
  /// Note that this method may fail if the principal point of the projection is not inside the `box` or
  /// if there is no sufficient screen space, defined by principal point and the `box`, to fit the geometry.
  Future<CameraOptions> cameraForCoordinatesCameraOptions(
          List<Point> coordinates, CameraOptions camera, ScreenBox box) =>
      _cameraManager.cameraForCoordinatesCameraOptions(
          coordinates, camera, box);

  /// Convenience method that returns the `camera options` object for given parameters.
  Future<CameraOptions> cameraForGeometry(Map<String?, Object?> geometry,
          MbxEdgeInsets padding, double? bearing, double? pitch) =>
      _cameraManager.cameraForGeometry(geometry, padding, bearing, pitch);

  /// Returns the `coordinate bounds` for a given camera.
  Future<CoordinateBounds> coordinateBoundsForCamera(CameraOptions camera) =>
      _cameraManager.coordinateBoundsForCamera(camera);

  /// Returns the `coordinate bounds` for a given camera.
  Future<CoordinateBounds> coordinateBoundsForCameraUnwrapped(
          CameraOptions camera) =>
      _cameraManager.coordinateBoundsForCameraUnwrapped(camera);

  /// Returns the `coordinate bounds` and the `zoom` for a given `camera`.
  ///
  /// Note that if the given `camera` shows the antimeridian, the returned wrapped `coordinate bounds`
  /// might not represent the minimum bounding box.
  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCamera(
          CameraOptions camera) =>
      _cameraManager.coordinateBoundsZoomForCamera(camera);

  /// Returns the unwrapped `coordinate bounds` and `zoom` for a given `camera`.
  ///
  /// This method is useful if the `camera` shows the antimeridian.
  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCameraUnwrapped(
          CameraOptions camera) =>
      _cameraManager.coordinateBoundsZoomForCameraUnwrapped(camera);

  /// Calculates a `screen coordinate` that corresponds to a geographical coordinate
  /// (i.e., longitude-latitude pair).
  ///
  /// The `screen coordinate` is in `logical pixels` relative to the top left corner
  /// of the map (not of the whole screen).
  Future<ScreenCoordinate> pixelForCoordinate(Point coordinate) =>
      _cameraManager.pixelForCoordinate(coordinate);

  /// Calculates a geographical `coordinate` (i.e., longitude-latitude pair) that corresponds
  /// to a `screen coordinate`.
  ///
  /// The screen coordinate is in `logical pixels`relative to the top left corner
  /// of the map (not of the whole screen).
  Future<Point> coordinateForPixel(ScreenCoordinate pixel) =>
      _cameraManager.coordinateForPixel(pixel);

  /// Calculates `screen coordinates` that correspond to geographical `coordinates`
  /// (i.e., longitude-latitude pairs).
  ///
  /// The `screen coordinates` are in `logical pixels` relative to the top left corner
  /// of the map (not of the whole screen).
  Future<List<ScreenCoordinate?>> pixelsForCoordinates(
          List<Point> coordinates) =>
      _cameraManager.pixelsForCoordinates(coordinates);

  /// Calculates geographical `coordinates` (i.e., longitude-latitude pairs) that correspond
  /// to `screen coordinates`.
  ///
  /// The screen coordinates are in `logical pixels` relative to the top left corner
  /// of the map (not of the whole screen).
  Future<List<Point?>> coordinatesForPixels(List<ScreenCoordinate?> pixels) =>
      _cameraManager.coordinatesForPixels(pixels);

  /// Changes the map view by any combination of center, zoom, bearing, and pitch, without an animated transition.
  /// The map will retain its current values for any details not passed via the camera options argument.
  /// It is not guaranteed that the provided `camera options` will be set, the map may apply constraints resulting in a
  /// different `camera state`.
  Future<void> setCamera(CameraOptions cameraOptions) =>
      _cameraManager.setCamera(cameraOptions);

  /// Returns the current `camera state`.
  Future<CameraState> getCameraState() => _cameraManager.getCameraState();

  /// Sets the `camera bounds options` of the map. The map will retain its current values for any
  /// details not passed via the camera bounds options arguments.
  /// When camera bounds options are set, the camera center is constrained by these bounds, as well as the minimum
  /// zoom level of the camera, to prevent out of bounds areas to be visible.
  /// Note that tilting or rotating the map, or setting stricter minimum and maximum zoom within `options` may still cause some out of bounds areas to become visible.
  Future<void> setBounds(CameraBoundsOptions options) =>
      _cameraManager.setBounds(options);

  /// Returns the `camera bounds` of the map.
  Future<CameraBounds> getBounds() => _cameraManager.getBounds();

  /// Gets the size of the map.
  /// Note : not supported for iOS.
  Future<Size> getSize() => _mapInterface.getSize();

  /// Triggers a repaint of the map.
  Future<void> triggerRepaint() => _mapInterface.triggerRepaint();

  /// Tells the map rendering engine that there is currently a gesture in progress. This
  /// affects how the map renders labels, as it will use different texture filters if a gesture
  /// is ongoing.
  Future<void> setGestureInProgress(bool inProgress) =>
      _mapInterface.setGestureInProgress(inProgress);

  /// Returns `true` if a gesture is currently in progress.
  Future<bool> isGestureInProgress() => _mapInterface.isGestureInProgress();

  @visibleForTesting
  Future<void> dispatch(String gesture, ScreenCoordinate screenCoordinate) =>
      _mapInterface.dispatch(gesture, screenCoordinate);

  /// Tells the map rendering engine that the animation is currently performed by the
  /// user (e.g. with a `setCamera` calls series). It adjusts the engine for the animation use case.
  /// In particular, it brings more stability to symbol placement and rendering.
  Future<void> setUserAnimationInProgress(bool inProgress) =>
      _mapInterface.setUserAnimationInProgress(inProgress);

  /// Returns `true` if user animation is currently in progress.
  Future<bool> isUserAnimationInProgress() =>
      _mapInterface.isUserAnimationInProgress();

  /// When loading a map, if prefetch zoom `delta` is set to any number greater than 0,
  /// the map will first request a tile at zoom level lower than `zoom - delta`, with requested
  /// zoom level a multiple of `delta`, in an attempt to display a full map at lower resolution as quick as possible.
  Future<void> setPrefetchZoomDelta(int delta) =>
      _mapInterface.setPrefetchZoomDelta(delta);

  /// Returns the map's prefetch zoom delta.
  Future<int> getPrefetchZoomDelta() => _mapInterface.getPrefetchZoomDelta();

  /// Sets the north `orientation mode`.
  Future<void> setNorthOrientation(NorthOrientation orientation) =>
      _mapInterface.setNorthOrientation(orientation);

  /// Sets the map `constrain mode`.
  Future<void> setConstrainMode(ConstrainMode mode) =>
      _mapInterface.setConstrainMode(mode);

  /// Sets the `viewport mode`.
  Future<void> setViewportMode(ViewportMode mode) =>
      _mapInterface.setViewportMode(mode);

  /// Returns the `map options`.
  Future<MapOptions> getMapOptions() => _mapInterface.getMapOptions();

  /// The URL that points to the glyphs used by the style for rendering text labels on the map.
  ///
  /// This property allows setting a custom glyph URL at runtime, making it easier to
  /// apply custom fonts to the map without modifying the base style.
  Future<String> styleGlyphURL() => _mapInterface.styleGlyphURL();

  /// The URL that points to the glyphs used by the style for rendering text labels on the map.
  ///
  /// This property allows setting a custom glyph URL at runtime, making it easier to
  /// apply custom fonts to the map without modifying the base style.
  Future<void> setStyleGlyphURL(String glyphURL) =>
      _mapInterface.setStyleGlyphURL(glyphURL);

  /// Debug options for the widget associated with the map.
  Future<List<MapWidgetDebugOptions>> getDebugOptions() async {
    return _mapInterface.getDebugOptions().then((value) {
      return value.map((e) => e.widgetDebugOptions).toList();
    });
  }

  /// Set debug options for the widget associated with the map.
  Future<void> setDebugOptions(List<MapWidgetDebugOptions> debugOptions) {
    return _mapInterface
        .setDebugOptions(debugOptions.map((e) => e._option).toList());
  }

  /// Returns the `map debug options`.
  @Deprecated("Use 'getDebugOptions()' instead")
  Future<List<MapDebugOptions?>> getDebug() => _mapInterface.getDebug();

  /// Sets the `map debug options` and enables debug mode based on the passed value.
  @Deprecated("Use 'setDebugOptions()' instead")
  Future<void> setDebug(List<MapDebugOptions?> debugOptions, bool value) =>
      _mapInterface.setDebug(debugOptions, value);

  /// Queries the map for rendered features.
  Future<List<QueriedRenderedFeature?>> queryRenderedFeatures(
          RenderedQueryGeometry geometry, RenderedQueryOptions options) =>
      _mapInterface.queryRenderedFeatures(
          _RenderedQueryGeometry(value: geometry.value, type: geometry.type),
          options);

  /// Queries the map for rendered features with one typed featureset.
  Future<List<FeaturesetFeature>> queryRenderedFeaturesForFeatureset(
      {required FeaturesetDescriptor featureset,
      RenderedQueryGeometry? geometry,
      String? filter}) async {
    return _mapInterface.queryRenderedFeaturesForFeatureset(
        featureset,
        (geometry != null)
            ? _RenderedQueryGeometry(value: geometry.value, type: geometry.type)
            : null,
        filter);
  }

  /// Queries the map for source features.
  Future<List<QueriedSourceFeature?>> querySourceFeatures(
          String sourceId, SourceQueryOptions options) =>
      _mapInterface.querySourceFeatures(sourceId, options);

  /// Returns all the leaves (original points) of a cluster (given its cluster_id) from a GeoJsonSource, with pagination support: limit is the number of leaves
  /// to return (set to Infinity for all points), and offset is the amount of points to skip (for pagination).
  ///
  /// Requires configuring the source as a cluster by calling [GeoJsonSource.Builder#cluster(boolean)].
  Future<FeatureExtensionValue> getGeoJsonClusterLeaves(String sourceIdentifier,
          Map<String?, Object?> cluster, int? limit, int? offset) =>
      _mapInterface.getGeoJsonClusterLeaves(
          sourceIdentifier, cluster, limit, offset);

  /// Returns the children (original points or clusters) of a cluster (on the next zoom level)
  /// given its id (cluster_id value from feature properties) from a GeoJsonSource.
  ///
  /// Requires configuring the source as a cluster by calling [GeoJsonSource.Builder#cluster(boolean)].
  Future<FeatureExtensionValue> getGeoJsonClusterChildren(
          String sourceIdentifier, Map<String?, Object?> cluster) =>
      _mapInterface.getGeoJsonClusterChildren(sourceIdentifier, cluster);

  /// Returns the zoom on which the cluster expands into several children (useful for "click to zoom" feature)
  /// given the cluster's cluster_id (cluster_id value from feature properties) from a GeoJsonSource.
  ///
  /// Requires configuring the source as a cluster by calling [GeoJsonSource.Builder#cluster(boolean)].
  Future<FeatureExtensionValue> getGeoJsonClusterExpansionZoom(
          String sourceIdentifier, Map<String?, Object?> cluster) =>
      _mapInterface.getGeoJsonClusterExpansionZoom(sourceIdentifier, cluster);

  /// Updates the state object of a feature within a style source.
  ///
  /// Update entries in the `state` object of a given feature within a style source. Only properties of the
  /// `state` object will be updated. A property in the feature `state` object that is not listed in `state` will
  /// retain its previous value.
  ///
  /// Note that updates to feature `state` are asynchronous, so changes made by this method might not be
  /// immediately visible using `getStateFeature`.
  Future<void> setFeatureState(String sourceId, String? sourceLayerId,
          String featureId, String state) =>
      _mapInterface.setFeatureState(sourceId, sourceLayerId, featureId, state);

  /// Update the state map of a feature within a featureset.
  /// Update entries in the state map of a given feature within a style source. Only entries listed in the state map
  /// will be updated. An entry in the feature state map that is not listed in `state` will retain its previous value.
  Future<void> setFeatureStateForFeaturesetDescriptor(
          FeaturesetDescriptor featureset,
          FeaturesetFeatureId featureId,
          FeatureState state) =>
      _mapInterface.setFeatureStateForFeaturesetDescriptor(
          featureset, featureId, state.map);

  /// Update the state map of an individual feature.
  ///
  /// The feature should have a non-nil ``FeaturesetFeatureType/id``. Otherwise,
  /// the operation will be no-op and callback will receive an error.
  Future<void> setFeatureStateForFeaturesetFeature(
          FeaturesetFeature feature, FeatureState state) =>
      _mapInterface.setFeatureStateForFeaturesetFeature(feature, state.map);

  /// Gets the state map of a feature within a style source.
  ///
  /// Note that updates to feature state are asynchronous, so changes made by other methods might not be
  /// immediately visible.
  Future<String> getFeatureState(
          String sourceId, String? sourceLayerId, String featureId) =>
      _mapInterface.getFeatureState(sourceId, sourceLayerId, featureId);

  /// Get the state map of a feature within a style source.
  Future<Map<String, Object?>> getFeatureStateForFeaturesetDescriptor(
          FeaturesetDescriptor featureset, FeaturesetFeatureId featureId) =>
      _mapInterface.getFeatureStateForFeaturesetDescriptor(
          featureset, featureId);

  /// Get the state map of a feature within a style source.
  Future<Map<String, Object?>> getFeatureStateForFeaturesetFeature(
          FeaturesetFeature feature) =>
      _mapInterface.getFeatureStateForFeaturesetFeature(feature);

  /// Removes entries from a feature state object.
  ///
  /// Remove a specified property or all property from a feature's state object, depending on the value of
  /// `stateKey`.
  ///
  /// Note that updates to feature state are asynchronous, so changes made by this method might not be
  /// immediately visible using `getStateFeature`.
  Future<void> removeFeatureState(String sourceId, String? sourceLayerId,
          String featureId, String? stateKey) =>
      _mapInterface.removeFeatureState(
          sourceId, sourceLayerId, featureId, stateKey);

  /// Removes entries from a feature state object of a feature in the specified featureset.
  /// Remove a specified property or all property from a feature's state object, depending on the value of `stateKey`.
  Future<void> removeFeatureStateForFeaturesetDescriptor(
          {required FeaturesetDescriptor featureset,
          required FeaturesetFeatureId featureId,
          String? stateKey}) =>
      _mapInterface.removeFeatureStateForFeaturesetDescriptor(
          featureset, featureId, stateKey);

  /// Removes entries from a specified Feature.
  /// Remove a specified property or all property from a feature's state object, depending on the value of `stateKey`.
  Future<void> removeFeatureStateForFeaturesetFeature(
          {required FeaturesetFeature feature, String? stateKey}) =>
      _mapInterface.removeFeatureStateForFeaturesetFeature(feature, stateKey);

  /// Reset all the feature states within a featureset.
  ///
  /// Note that updates to feature state are asynchronous, so changes made by this method might not be
  /// immediately visible using ``MapboxMap/getFeatureState(_:callback:)``.
  Future<void> resetFeatureStatesForFeatureset(
          FeaturesetDescriptor featureset) =>
      _mapInterface.resetFeatureStatesForFeatureset(featureset);

  /// References for all interactions added to the map.
  final _InteractionsMap _interactionsMap = _InteractionsMap(interactions: {});

  /// Add an interaction to the map
  /// An identifier can be provided, which you can use to remove
  /// the interaction with `.removeInteraction(interactionID)`
  void addInteraction<T extends TypedFeaturesetFeature<FeaturesetDescriptor>>(
      TypedInteraction<T> interaction,
      {String? interactionID}) {
    final id = interactionID ?? UniqueKey().toString();
    _interactionsMap.interactions[id] = _InteractionListener<T>(
      onInteractionListener: interaction.action,
      interactionID: id,
    );
    _InteractionsListener.setUp(_interactionsMap,
        binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
        messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());
    _mapboxMapsPlatform.addInteractionsListeners(interaction, id);
  }

  /// Remove an interaction from the map with the given interactionID
  /// that was passed with `.addInteraction(interaction, interactionID)`
  void removeInteraction(String interactionID) {
    _interactionsMap.interactions.remove(interactionID);
    _mapboxMapsPlatform.removeInteractionsListeners(interactionID);
  }

  /// Reduces memory use. Useful to call when the application gets paused or sent to background.
  Future<void> reduceMemoryUse() => _mapInterface.reduceMemoryUse();

  /// Gets elevation for the given coordinate.
  /// Note: Elevation is only available for the visible region on the screen and with terrain enabled.
  Future<double?> getElevation(Point coordinate) =>
      _mapInterface.getElevation(coordinate);

  /// Will load a new map style asynchronous from the specified URI.
  ///
  /// URI can take the following forms:
  ///
  /// - **Constants**: load one of the bundled styles in [Style].
  ///
  /// - **`mapbox://styles/<user>/<style>`**:
  /// loads the style from a [Mapbox account](https://www.mapbox.com/account/).
  /// *user* is your username. *style* is the ID of your custom
  /// style created in [Mapbox Studio](https://www.mapbox.com/studio).
  ///
  /// - **`http://...` or `https://...`**:
  /// loads the style over the Internet from any web server.
  ///
  /// - **`asset://...`**:
  /// loads the style from the APK *assets* directory.
  /// This is used to load a style bundled with your app.
  ///
  /// - **`file://...`**:
  /// loads the style from a file path. This is used to load a style from disk.
  ///
  /// Will load an empty json `{}` if the styleUri is empty.
  Future<void> loadStyleURI(String styleURI) =>
      _mapInterface.loadStyleURI(styleURI);

  /// Loads a style from a JSON string, calling a completion closure when the
  /// style is fully loaded or there has been an error during load.
  Future<void> loadStyleJson(String styleJson) =>
      _mapInterface.loadStyleJson(styleJson);

  /// Clears temporary map data.
  ///
  /// Clears temporary map data from the data path defined in the given resource options.
  /// Useful to reduce the disk usage or in case the disk cache contains invalid data.
  ///
  /// Note that calling this API will affect all maps that use the same data path and does not
  /// affect persistent map data like offline style packages.
  Future<void> clearData() => _mapInterface.clearData();

  /// The memory budget hint to be used by the map. The budget can be given in
  /// tile units or in megabytes. A Map will do the best effort to keep memory
  /// allocations for a non essential resources within the budget.
  ///
  /// The memory budget distribution and resource
  /// eviction logic is a subject to change. Current implementation sets memory budget
  /// hint per data source.
  ///
  /// If null is set, the memory budget in tile units will be dynamically calculated based on
  /// the current viewport size.
  Future<void> setTileCacheBudget(
          TileCacheBudgetInMegabytes? tileCacheBudgetInMegabytes,
          TileCacheBudgetInTiles? tileCacheBudgetInTiles) =>
      _mapInterface.setTileCacheBudget(
          tileCacheBudgetInMegabytes, tileCacheBudgetInTiles);

  /// Ease the map camera to a given camera options and animation options
  Future<void> easeTo(CameraOptions cameraOptions,
          MapAnimationOptions? mapAnimationOptions) =>
      _animationManager.easeTo(cameraOptions, mapAnimationOptions);

  /// Fly the map camera to a given camera options.
  Future<void> flyTo(CameraOptions cameraOptions,
          MapAnimationOptions? mapAnimationOptions) =>
      _animationManager.flyTo(cameraOptions, mapAnimationOptions);

  /// Pitch the map by with optional animation.
  Future<void> pitchBy(
          double pitch, MapAnimationOptions? mapAnimationOptions) =>
      _animationManager.pitchBy(pitch, mapAnimationOptions);

  /// Scale the map by with optional animation.
  Future<void> scaleBy(double amount, ScreenCoordinate? screenCoordinate,
          MapAnimationOptions? mapAnimationOptions) =>
      _animationManager.scaleBy(amount, screenCoordinate, mapAnimationOptions);

  /// Move the map by a given screen coordinate with optional animation.
  Future<void> moveBy(ScreenCoordinate screenCoordinate,
          MapAnimationOptions? mapAnimationOptions) =>
      _animationManager.moveBy(screenCoordinate, mapAnimationOptions);

  /// Rotate the map by with optional animation.
  Future<void> rotateBy(ScreenCoordinate first, ScreenCoordinate second,
          MapAnimationOptions? mapAnimationOptions) =>
      _animationManager.rotateBy(first, second, mapAnimationOptions);

  /// Cancel the ongoing camera animation if there is one.
  Future<void> cancelCameraAnimation() =>
      _animationManager.cancelCameraAnimation();

  void _setupGestures() {
    if (onMapTapListener != null ||
        onMapLongTapListener != null ||
        onMapScrollListener != null ||
        onMapZoomListener != null) {
      GestureListener.setUp(
          _GestureListener(
            onMapTapListener: onMapTapListener,
            onMapLongTapListener: onMapLongTapListener,
            onMapScrollListener: onMapScrollListener,
            onMapZoomListener: onMapZoomListener,
          ),
          binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
          messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());
      _mapboxMapsPlatform.addGestureListeners();
    }
  }

  /// Collects CPU and GPU resource usage, as well as timings of layers and rendering groups, over a user-configurable sampling duration.
  /// Use the collected information to identify layers or rendering groups that may be performing poorly.
  ///
  /// Use ``PerformanceStatisticsOptions`` to configure the following collection behaviours:
  ///     - Which types of sampling to perform, whether cumulative, per-frame, or both.
  ///     - Duration of sampling in milliseconds. A value of 0 forces the collection of performance statistics every frame.
  ///
  /// The statistics collection can be canceled by calling [stopPerformanceStatisticsCollection]. Canceling collection will prevent the listener
  /// callback from being called. Collection can be restarted by calling [startPerformanceStatisticsCollection] again.
  ///
  /// The callback function will be called every time the configured sampling duration [PerformanceStatisticsOptions.samplingDurationMillis] has elapsed.
  ///
  /// - Parameters:
  ///   - options The statistics collection options to collect.
  ///   - callback The callback to be invoked when performance statistics are available.
  /// Enable real-time collection of map rendering performance statistics, for development purposes. Use after `render()` has
  /// been called for the first time.
  ///
  /// Collects CPU, GPU resource usage and timings of layers and rendering groups over a user-configurable sampling duration.
  /// Use the collected information to find which layers or rendering groups might be performing poorly. Use
  /// [PerformanceStatisticsOptions] to configure the following statistics collection behaviors:
  /// <ul>
  ///     <li>Specify the types of sampling: cumulative, per-frame, or both.</li>
  ///     <li>Define the minimum amount of time over which to perform sampling.</li>
  /// </ul>
  ///
  /// Utilize [PerformanceStatisticsListener] to observe the collected performance statistics. The callback function is invoked
  /// after the configured sampling duration has elapsed. The collection process is continuous; without user-input,
  /// it restarts after each callback invocation. Note: Specifying a negative sampling duration
  /// or omitting the callback function will result in no operation, which will be logged for visibility.
  ///
  /// In order to stop the collection process, call [stopPerformanceStatisticsCollection].
  /// After calling [startPerformanceStatisticsCollection], [stopPerformanceStatisticsCollection] must be called before collection can be
  /// restarted.
  @experimental
  void startPerformanceStatisticsCollection(
      PerformanceStatisticsOptions options,
      PerformanceStatisticsListener listener) {
    PerformanceStatisticsListener.setUp(listener,
        binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
        messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());

    _performanceStatistics.startPerformanceStatisticsCollection(options);
  }

  /// Disable performance statistics collection.
  ///
  /// Calling [stopPerformanceStatisticsCollection] when no collection is enabled is a no-op. After calling
  /// [startPerformanceStatisticsCollection], [stopPerformanceStatisticsCollection] must be called before collection can be
  /// restarted.
  @experimental
  void stopPerformanceStatisticsCollection() {
    _performanceStatistics.stopPerformanceStatisticsCollection();

    PerformanceStatisticsListener.setUp(null,
        binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
        messageChannelSuffix: _mapboxMapsPlatform.channelSuffix.toString());
  }

  void setOnMapTapListener(OnMapTapListener? onMapTapListener) {
    this.onMapTapListener = onMapTapListener;
    _setupGestures();
  }

  void setOnMapLongTapListener(OnMapLongTapListener? onMapLongTapListener) {
    this.onMapLongTapListener = onMapLongTapListener;
    _setupGestures();
  }

  void setOnMapMoveListener(OnMapScrollListener? onMapScrollListener) {
    this.onMapScrollListener = onMapScrollListener;
    _setupGestures();
  }

  void setOnMapZoomListener(OnMapZoomListener? onMapZoomListener) {
    this.onMapZoomListener = onMapZoomListener;
    _setupGestures();
  }

  /// Returns a snapshot of the map.
  /// The snapshot is taken from the current state of the map.
  Future<Uint8List> snapshot() => _mapboxMapsPlatform.snapshot();

  /// Set whether legacy mode should be used for [snapshot].
  ///
  /// Legacy mode is not that efficient (as it blocks map rendering when making the snapshot)
  /// but may help with vendor specific issues like described in
  /// https://github.com/mapbox/mapbox-maps-android/issues/2280.
  ///
  /// Note: This method has no effect on iOS platform.
  @experimental
  Future<void> setSnapshotLegacyMode(bool enable) =>
      _mapInterface.setSnapshotLegacyMode(enable);

  /// Set custom headers for all Mapbox HTTP requests
  ///
  /// [headers] is a map of header names to header values
  ///
  /// Throws a [PlatformException] if the native implementation is not available
  /// or if the operation fails
  ///
  /// Example:
  /// ```dart
  /// MapboxMap.setCustomHeaders({
  ///   "Authorization": "Bearer your_secret_token",
  /// });
  /// ```
  ///
  /// Throws a [PlatformException] if the native implementation is not available
  /// or if the operation fails
  Future<void> setCustomHeaders(Map<String, String> headers) =>
      MapboxHttpService(
              binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
              channelSuffix: _mapboxMapsPlatform.channelSuffix)
          .setCustomHeaders(headers);
}

class _GestureListener extends GestureListener {
  _GestureListener({
    this.onMapTapListener,
    this.onMapLongTapListener,
    this.onMapScrollListener,
    this.onMapZoomListener,
  });

  final OnMapTapListener? onMapTapListener;
  final OnMapLongTapListener? onMapLongTapListener;
  final OnMapScrollListener? onMapScrollListener;
  final OnMapZoomListener? onMapZoomListener;

  @override
  void onTap(MapContentGestureContext context) {
    onMapTapListener?.call(context);
  }

  @override
  void onLongTap(MapContentGestureContext context) {
    onMapLongTapListener?.call(context);
  }

  @override
  void onScroll(MapContentGestureContext context) {
    onMapScrollListener?.call(context);
  }

  @override
  void onZoom(MapContentGestureContext context) {
    onMapZoomListener?.call(context);
  }
}

/// Listen for a single interaction added to the map, identified by its id
class _InteractionListener<T extends FeaturesetFeature>
    extends _InteractionsListener {
  _InteractionListener({
    required this.interactionID,
    required this.onInteractionListener,
  });

  String interactionID;

  final OnInteraction<T> onInteractionListener;

  @override
  void onInteraction(FeaturesetFeature? feature,
      MapContentGestureContext context, String interactionID) {
    final featuresetID = feature?.featureset.featuresetId;
    T? typedFeature;

    if (feature != null) {
      if (featuresetID == "buildings") {
        typedFeature =
            TypedFeaturesetFeature<StandardBuildings>.fromFeaturesetFeature(
                feature) as T;
      } else if (featuresetID == "poi") {
        typedFeature =
            TypedFeaturesetFeature<StandardPOIs>.fromFeaturesetFeature(feature)
                as T;
      } else if (featuresetID == "place-labels") {
        typedFeature =
            TypedFeaturesetFeature<StandardPlaceLabels>.fromFeaturesetFeature(
                feature) as T;
      } else {
        typedFeature =
            TypedFeaturesetFeature.fromFeaturesetFeature(feature) as T;
      }
      onInteractionListener.call(typedFeature, context);
    } else {
      onInteractionListener.call(null, context);
    }
  }
}

/// Listen to all interactions on the map, determine which interaction to call
class _InteractionsMap<T extends FeaturesetFeature>
    extends _InteractionsListener {
  _InteractionsMap({
    required this.interactions,
  });

  Map<String, _InteractionListener> interactions;

  @override
  void onInteraction(FeaturesetFeature? feature,
      MapContentGestureContext context, String interactionID) {
    interactions[interactionID]?.onInteraction(feature, context, interactionID);
  }
}
