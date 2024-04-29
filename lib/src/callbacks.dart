part of mapbox_maps_flutter;

/// Callback function taking a single argument.
typedef void ArgumentCallback<T>(T argument);

/// Mutable collection of [ArgumentCallback] instances, itself an [ArgumentCallback].
///
/// Additions and removals happening during a single [call] invocation do not
/// change who gets a callback until the next such invocation.
///
/// Optimized for the singleton case.
class ArgumentCallbacks<T> {
  final List<ArgumentCallback<T>> _callbacks = <ArgumentCallback<T>>[];

  /// Callback method. Invokes the corresponding method on each callback
  /// in this collection.
  ///
  /// The list of callbacks being invoked is computed at the start of the
  /// method and is unaffected by any changes subsequently made to this
  /// collection.
  void call(T argument) {
    final int length = _callbacks.length;
    if (length == 1) {
      _callbacks[0].call(argument);
    } else if (0 < length) {
      for (ArgumentCallback<T> callback
          in List<ArgumentCallback<T>>.from(_callbacks)) {
        callback(argument);
      }
    }
  }

  /// Adds a callback to this collection.
  void add(ArgumentCallback<T> callback) {
    _callbacks.add(callback);
  }

  /// Removes a callback from this collection.
  ///
  /// Does nothing, if the callback was not present.
  void remove(ArgumentCallback<T> callback) {
    _callbacks.remove(callback);
  }

  /// Whether this collection is empty.
  bool get isEmpty => _callbacks.isEmpty;

  /// Whether this collection is non-empty.
  bool get isNotEmpty => _callbacks.isNotEmpty;
}

/// Definition for listener invoked when the map is created.
typedef void MapCreatedCallback(MapboxMap controller);

/// Definition for listener invoked when the style is fully loaded.
typedef void OnStyleLoadedListener(StyleLoadedEventData styleLoadedEventData);

/// Definition for listener invoked whenever the camera position changes.
typedef void OnCameraChangeListener(
    CameraChangedEventData cameraChangedEventData);

/// Definition for listener invoked whenever the Map has entered the idle state.
typedef void OnMapIdleListener(MapIdleEventData mapIdleEventData);

/// Definition for listener invoked when the map loading finishes.
typedef void OnMapLoadedListener(MapLoadedEventData mapLoadedEventData);

/// Definition for listener invoked whenever the map load errors out.
typedef void OnMapLoadErrorListener(
    MapLoadingErrorEventData mapLoadingErrorEventData);

/// Definition for listener invoked whenever the Map started rendering a frame.
typedef void OnRenderFrameStartedListener(
    RenderFrameStartedEventData renderFrameStartedEventData);

/// Definition for listener invoked whenever the Map finished rendering a frame.
typedef void OnRenderFrameFinishedListener(
    RenderFrameFinishedEventData renderFrameFinishedEventData);

/// Definition for listener invoked whenever a source is added.
typedef void OnSourceAddedListener(SourceAddedEventData sourceAddedEventData);

/// Definition for listener invoked when the requested source data has been loaded.
typedef void OnSourceDataLoadedListener(
    SourceDataLoadedEventData sourceDataLoadedEventData);

/// Definition for listener invoked whenever a source is removed.
typedef void OnSourceRemovedListener(
    SourceRemovedEventData sourceRemovedEventData);

/// Definition for listener invoked when the requested style data has been loaded.
typedef void OnStyleDataLoadedListener(
    StyleDataLoadedEventData styleDataLoadedEventData);

/// Definition for listener invoked when the style has a missing image.
typedef void OnStyleImageMissingListener(
    StyleImageMissingEventData styleImageMissingEventData);

/// Definition for listener invoked when an image added to the Style is no longer needed.
typedef void OnStyleImageUnusedListener(
    StyleImageUnusedEventData styleImageUnusedEventData);

/// Definition for listener invoked when the map makes a resource request.
typedef void OnResourceRequestListener(ResourceEventData resourceEventData);

/// Gesture listener called on map tap.
typedef void OnMapTapListener(MapContentGestureContext context);

/// Gesture listener called on map double tap.
typedef void OnMapLongTapListener(MapContentGestureContext context);

/// Gesture listener called on map scroll.
typedef void OnMapScrollListener(MapContentGestureContext context);
