part of mapbox_maps_flutter;

/// Controller for a single MapboxMap instance running on the host platform.
class MapboxMap extends ChangeNotifier {
  MapboxMap({
    required _MapboxMapsPlatform mapboxMapsPlatform,
    this.onStyleLoadedListener,
    this.onCameraChangeListener,
    this.onMapIdleListener,
    this.onMapLoadedListener,
    this.onMapLoadErrorListener,
    this.onRenderFrameStartedListener,
    this.onRenderFrameFinishedListener,
    this.onSourceAddedListener,
    this.onSourceDataLoadedListener,
    this.onSourceRemovedListener,
    this.onStyleDataLoadedListener,
    this.onStyleImageMissingListener,
    this.onStyleImageUnusedListener,
    this.onMapTapListener,
    this.onMapLongTapListener,
    this.onMapScrollListener,
  }) : _mapboxMapsPlatform = mapboxMapsPlatform {
    _proxyBinaryMessenger = _mapboxMapsPlatform.binaryMessenger;

    annotations = _AnnotationManager(mapboxMapsPlatform: _mapboxMapsPlatform);
    if (onStyleLoadedListener != null) {
      _mapboxMapsPlatform.onStyleLoadedPlatform.add((argument) {
        onStyleLoadedListener?.call(argument);
      });
    }
    if (onCameraChangeListener != null) {
      _mapboxMapsPlatform.onCameraChangeListenerPlatform.add((argument) {
        onCameraChangeListener?.call(argument);
      });
    }
    if (onMapIdleListener != null) {
      _mapboxMapsPlatform.onMapIdlePlatform.add((argument) {
        onMapIdleListener?.call(argument);
      });
    }
    if (onMapLoadedListener != null) {
      _mapboxMapsPlatform.onMapLoadedPlatform.add((argument) {
        onMapLoadedListener?.call(argument);
      });
    }
    if (onMapLoadErrorListener != null) {
      _mapboxMapsPlatform.onMapLoadErrorPlatform.add((argument) {
        onMapLoadErrorListener?.call(argument);
      });
    }
    if (onRenderFrameFinishedListener != null) {
      _mapboxMapsPlatform.onRenderFrameFinishedPlatform.add((argument) {
        onRenderFrameFinishedListener?.call(argument);
      });
    }
    if (onRenderFrameStartedListener != null) {
      _mapboxMapsPlatform.onRenderFrameStartedPlatform.add((argument) {
        onRenderFrameStartedListener?.call(argument);
      });
    }
    if (onSourceAddedListener != null) {
      _mapboxMapsPlatform.onSourceAddedPlatform.add((argument) {
        onSourceAddedListener?.call(argument);
      });
    }
    if (onSourceDataLoadedListener != null) {
      _mapboxMapsPlatform.onSourceDataLoadedPlatform.add((argument) {
        onSourceDataLoadedListener?.call(argument);
      });
    }
    if (onSourceRemovedListener != null) {
      _mapboxMapsPlatform.onSourceRemovedPlatform.add((argument) {
        onSourceRemovedListener?.call(argument);
      });
    }
    if (onStyleDataLoadedListener != null) {
      _mapboxMapsPlatform.onStyleDataLoadedPlatform.add((argument) {
        onStyleDataLoadedListener?.call(argument);
      });
    }
    if (onStyleImageMissingListener != null) {
      _mapboxMapsPlatform.onStyleImageMissingPlatform.add((argument) {
        onStyleImageMissingListener?.call(argument);
      });
    }
    if (onStyleImageUnusedListener != null) {
      _mapboxMapsPlatform.onStyleImageUnusedPlatform.add((argument) {
        onStyleImageUnusedListener?.call(argument);
      });
    }
    _setupGestures();
  }

  final _MapboxMapsPlatform _mapboxMapsPlatform;

  /// Invoked when the requested style has been fully loaded, including the style, specified sprite and sources' metadata.
  final OnStyleLoadedListener? onStyleLoadedListener;

  /// Invoked whenever camera position changes.
  final OnCameraChangeListener? onCameraChangeListener;

  /// Invoked when the Map has entered the idle state. The Map is in the idle state when there are no ongoing transitions
  /// and the Map has rendered all available tiles.
  final OnMapIdleListener? onMapIdleListener;

  /// Invoked when the Map's style has been fully loaded, and the Map has rendered all visible tiles.
  final OnMapLoadedListener? onMapLoadedListener;

  /// Invoked whenever the map load errors out
  final OnMapLoadErrorListener? onMapLoadErrorListener;

  /// Invoked whenever the Map finished rendering a frame.
  /// The render-mode value tells whether the Map has all data ("full") required to render the visible viewport.
  /// The needs-repaint value provides information about ongoing transitions that trigger Map repaint.
  /// The placement-changed value tells if the symbol placement has been changed in the visible viewport.
  final OnRenderFrameFinishedListener? onRenderFrameFinishedListener;

  /// Invoked whenever the Map started rendering a frame.
  final OnRenderFrameStartedListener? onRenderFrameStartedListener;

  /// Invoked whenever the Source has been added with StyleManager#addStyleSource runtime API.
  final OnSourceAddedListener? onSourceAddedListener;

  /// Invoked when the requested source data has been loaded.
  final OnSourceDataLoadedListener? onSourceDataLoadedListener;

  /// Invoked whenever the Source has been removed with StyleManager#removeStyleSource runtime API.
  final OnSourceRemovedListener? onSourceRemovedListener;

  /// Invoked when the requested style data has been loaded.
  final OnStyleDataLoadedListener? onStyleDataLoadedListener;

  /// Invoked whenever a style has a missing image. This event is emitted when the Map renders visible tiles and
  /// one of the required images is missing in the sprite sheet. Subscriber has to provide the missing image
  /// by calling StyleManager#addStyleImage method.
  final OnStyleImageMissingListener? onStyleImageMissingListener;

  /// Invoked whenever an image added to the Style is no longer needed and can be removed using StyleManager#removeStyleImage method.
  final OnStyleImageUnusedListener? onStyleImageUnusedListener;

  /// The currently loaded Style]object.
  late StyleManager style =
      StyleManager(binaryMessenger: _proxyBinaryMessenger);

  /// The interface to set the location puck.
  late LocationComponentSettingsInterface location =
      LocationComponentSettingsInterface(
          binaryMessenger: _proxyBinaryMessenger);

  late BinaryMessenger _proxyBinaryMessenger;

  late _CameraManager _cameraManager =
      _CameraManager(binaryMessenger: _proxyBinaryMessenger);
  late _MapInterface _mapInterface =
      _MapInterface(binaryMessenger: _proxyBinaryMessenger);
  late _AnimationManager _animationManager =
      _AnimationManager(binaryMessenger: _proxyBinaryMessenger);

  /// The interface to create and set annotations.
  late final _AnnotationManager annotations;

  // Keep Projection visible for users as iOS doesn't include it in MapboxMaps.
  /// The map projection of the style.
  late Projection projection =
      Projection(binaryMessenger: _proxyBinaryMessenger);

  /// The interface to access the gesture settings.
  late GesturesSettingsInterface gestures =
      GesturesSettingsInterface(binaryMessenger: _proxyBinaryMessenger);

  /// The interface to set the logo settings.
  late LogoSettingsInterface logo =
      LogoSettingsInterface(binaryMessenger: _proxyBinaryMessenger);

  /// The interface to access the compass settings.
  late CompassSettingsInterface compass =
      CompassSettingsInterface(binaryMessenger: _proxyBinaryMessenger);

  /// The interface to access the compass settings.
  late ScaleBarSettingsInterface scaleBar =
      ScaleBarSettingsInterface(binaryMessenger: _proxyBinaryMessenger);

  /// The interface to access the attribution settings.
  late AttributionSettingsInterface attribution =
      AttributionSettingsInterface(binaryMessenger: _proxyBinaryMessenger);

  OnMapTapListener? onMapTapListener;
  OnMapLongTapListener? onMapLongTapListener;
  OnMapScrollListener? onMapScrollListener;

  @override
  void dispose() {
    super.dispose();
    _mapboxMapsPlatform.dispose();
    _observersMap.clear();
    GestureListener.setup(null, binaryMessenger: _proxyBinaryMessenger);
  }

  var _observersMap = Map<String, List<Observer>>();

  /// Subscribes an `observer` to a provided array of event types.
  /// The `observable` will hold a strong reference to an `observer` instance, therefore,
  /// in order to stop receiving notifications, caller must call `unsubscribe` with an
  /// `observer` instance used for an initial subscription.
  void subscribe(Observer observer, List<String> events) {
    events.forEach((element) {
      _mapboxMapsPlatform.addEventListener(element);
      if (_observersMap[element] == null) {
        // Haven't subscribed this event
        _observersMap[element] = [observer];
      } else {
        // Have subscribed this event, just add observer to ths list
        _observersMap[element]!.add(observer);
      }
    });
    _mapboxMapsPlatform.observers.add((argument) {
      // Notify all the observers registered with this event.
      _observersMap[argument.type]?.forEach((element) {
        element(argument);
      });
    });
  }

  /// Unsubscribes an `observer` from a provided array of event types.
  void unsubscribe(Observer observer, List<String> events) {
    events.forEach((element) {
      _observersMap[element]!.remove(observer);
    });
  }

  /// Unsubscribes an `observer` from all events.
  void unsubscribeAll(Observer observer) {
    _observersMap.forEach((key, value) {
      if (value.contains(observer)) {
        value.remove(observer);
      }
    });
  }

  /// Convenience method that returns the `camera options` object for given parameters.
  Future<CameraOptions> cameraForCoordinateBounds(CoordinateBounds bounds,
          MbxEdgeInsets padding, double? bearing, double? pitch) =>
      _cameraManager.cameraForCoordinateBounds(bounds, padding, bearing, pitch);

  /// Convenience method that returns the `camera options` object for given parameters.
  Future<CameraOptions> cameraForCoordinates(
          List<Map<String?, Object?>?> coordinates,
          MbxEdgeInsets padding,
          double? bearing,
          double? pitch) =>
      _cameraManager.cameraForCoordinates(coordinates, padding, bearing, pitch);

  /// Convenience method that adjusts the provided `camera options` object for given parameters.
  ///
  /// Returns the provided `camera` options with zoom adjusted to fit `coordinates` into the `box`, so that `coordinates` on the left,
  /// top and right of the effective `camera` center at the principal point of the projection (defined by `padding`) fit into the `box`.
  /// Returns the provided `camera` options object unchanged upon an error.
  /// Note that this method may fail if the principal point of the projection is not inside the `box` or
  /// if there is no sufficient screen space, defined by principal point and the `box`, to fit the geometry.
  Future<CameraOptions> cameraForCoordinatesCameraOptions(
          List<Map<String?, Object?>?> coordinates,
          CameraOptions camera,
          ScreenBox box) =>
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
  /// The `screen coordinate` is in `platform pixels` relative to the top left corner
  /// of the map (not of the whole screen).
  Future<ScreenCoordinate> pixelForCoordinate(
          Map<String?, Object?> coordinate) =>
      _cameraManager.pixelForCoordinate(coordinate);

  /// Calculates a geographical `coordinate` (i.e., longitude-latitude pair) that corresponds
  /// to a `screen coordinate`.
  ///
  /// The screen coordinate is in `platform pixels`relative to the top left corner
  /// of the map (not of the whole screen).
  Future<Map<String?, Object?>> coordinateForPixel(ScreenCoordinate pixel) =>
      _cameraManager.coordinateForPixel(pixel);

  /// Calculates `screen coordinates` that correspond to geographical `coordinates`
  /// (i.e., longitude-latitude pairs).
  ///
  /// The `screen coordinates` are in `platform pixels` relative to the top left corner
  /// of the map (not of the whole screen).
  Future<List<ScreenCoordinate?>> pixelsForCoordinates(
          List<Map<String?, Object?>?> coordinates) =>
      _cameraManager.pixelsForCoordinates(coordinates);

  /// Calculates geographical `coordinates` (i.e., longitude-latitude pairs) that correspond
  /// to `screen coordinates`.
  ///
  /// The screen coordinates are in `platform pixels` relative to the top left corner
  /// of the map (not of the whole screen).
  Future<List<Map<String?, Object?>?>> coordinatesForPixels(
          List<ScreenCoordinate?> pixels) =>
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

  /// Prepares the drag gesture to use the provided screen coordinate as a pivot `point`. This function should be called each time when user starts a dragging action (e.g. by clicking on the map). The following dragging will be relative to the pivot.
  Future<void> dragStart(ScreenCoordinate point) =>
      _cameraManager.dragStart(point);

  /// Calculates target point where camera should move after drag. The method should be called after `dragStart` and before `dragEnd`.
  Future<CameraOptions> getDragCameraOptions(
          ScreenCoordinate fromPoint, ScreenCoordinate toPoint) =>
      _cameraManager.getDragCameraOptions(fromPoint, toPoint);

  /// Ends the ongoing drag gesture. This function should be called always after the user has ended a drag gesture initiated by `dragStart`.
  Future<void> dragEnd() => _cameraManager.dragEnd();

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

  /// Returns the `map debug options`.
  Future<List<MapDebugOptions?>> getDebug() => _mapInterface.getDebug();

  /// Sets the `map debug options` and enables debug mode based on the passed value.
  Future<void> setDebug(List<MapDebugOptions?> debugOptions, bool value) =>
      _mapInterface.setDebug(debugOptions, value);

  /// Queries the map for rendered features.
  Future<List<QueriedFeature?>> queryRenderedFeatures(
          RenderedQueryGeometry geometry, RenderedQueryOptions options) =>
      _mapInterface.queryRenderedFeatures(geometry, options);

  /// Queries the map for source features.
  Future<List<QueriedFeature?>> querySourceFeatures(
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

  /// Gets the state map of a feature within a style source.
  ///
  /// Note that updates to feature state are asynchronous, so changes made by other methods might not be
  /// immediately visible.
  Future<String> getFeatureState(
          String sourceId, String? sourceLayerId, String featureId) =>
      _mapInterface.getFeatureState(sourceId, sourceLayerId, featureId);

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

  /// Reduces memory use. Useful to call when the application gets paused or sent to background.
  Future<void> reduceMemoryUse() => _mapInterface.reduceMemoryUse();

  /// Gets the resource options for the map.
  ///
  /// All optional fields of the returned object are initialized with the actual values.
  ///
  /// Note that result of this method is different from the `resource options` that were provided to the map's constructor.
  Future<ResourceOptions> getResourceOptions() =>
      _mapInterface.getResourceOptions();

  /// Gets elevation for the given coordinate.
  /// Note: Elevation is only available for the visible region on the screen and with terrain enabled.
  Future<double?> getElevation(Map<String?, Object?> coordinate) =>
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
  Future<void> setMemoryBudget(
          MapMemoryBudgetInMegabytes? mapMemoryBudgetInMegabytes,
          MapMemoryBudgetInTiles? mapMemoryBudgetInTiles) =>
      _mapInterface.setMemoryBudget(
          mapMemoryBudgetInMegabytes, mapMemoryBudgetInTiles);

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
        onMapScrollListener != null) {
      GestureListener.setup(
          _GestureListener(
            onMapTapListener: onMapTapListener,
            onMapLongTapListener: onMapLongTapListener,
            onMapScrollListener: onMapScrollListener,
          ),
          binaryMessenger: _mapboxMapsPlatform.binaryMessenger);
      _mapboxMapsPlatform.addGestureListeners();
    }
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
}

class _GestureListener extends GestureListener {
  _GestureListener({
    this.onMapTapListener,
    this.onMapLongTapListener,
    this.onMapScrollListener,
  });

  final OnMapTapListener? onMapTapListener;
  final OnMapLongTapListener? onMapLongTapListener;
  final OnMapScrollListener? onMapScrollListener;

  @override
  void onTap(ScreenCoordinate coordinate) {
    onMapTapListener?.call(coordinate);
  }

  @override
  void onLongTap(ScreenCoordinate coordinate) {
    onMapLongTapListener?.call(coordinate);
  }

  @override
  void onScroll(ScreenCoordinate coordinate) {
    onMapScrollListener?.call(coordinate);
  }
}
