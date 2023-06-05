part of mapbox_maps_flutter;

/// A MapWidget provides an embeddable map interface.
/// You use this class to display map information and to manipulate the map contents from your application.
/// You can center the map on a given coordinate, specify the size of the area you want to display,
/// and style the features of the map to fit your application's use case.
///
/// Use of MapWidget requires a Mapbox API access token.
/// Obtain an access token on the [Mapbox account page](https://www.mapbox.com/studio/account/tokens/).
///
/// <strong>Warning:</strong> Please note that you are responsible for getting permission to use the map data,
/// and for ensuring your use adheres to the relevant terms of use.
class MapWidget extends StatefulWidget {
  MapWidget({
    Key? key,
    required this.resourceOptions,
    this.mapOptions,
    this.cameraOptions,
    // FIXME Flutter 3.x has memory leak on Android using in SurfaceView mode, see https://github.com/flutter/flutter/issues/118384
    // As a workaround default is true.
    this.textureView = true,
    this.styleUri,
    this.gestureRecognizers,
    this.onMapCreated,
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
    this.onTapListener,
    this.onLongTapListener,
    this.onScrollListener,
  }) : super(key: key) {
    if (onStyleLoadedListener != null) {
      _eventTypes.add(MapEvents.STYLE_LOADED);
    }
    if (onCameraChangeListener != null) {
      _eventTypes.add(MapEvents.CAMERA_CHANGED);
    }
    if (onMapIdleListener != null) {
      _eventTypes.add(MapEvents.MAP_IDLE);
    }
    if (onMapLoadedListener != null) {
      _eventTypes.add(MapEvents.MAP_LOADED);
    }
    if (onMapLoadErrorListener != null) {
      _eventTypes.add(MapEvents.MAP_LOADING_ERROR);
    }
    if (onRenderFrameFinishedListener != null) {
      _eventTypes.add(MapEvents.RENDER_FRAME_FINISHED);
    }
    if (onRenderFrameStartedListener != null) {
      _eventTypes.add(MapEvents.RENDER_FRAME_STARTED);
    }
    if (onSourceAddedListener != null) {
      _eventTypes.add(MapEvents.SOURCE_ADDED);
    }
    if (onSourceDataLoadedListener != null) {
      _eventTypes.add(MapEvents.SOURCE_DATA_LOADED);
    }
    if (onSourceRemovedListener != null) {
      _eventTypes.add(MapEvents.SOURCE_REMOVED);
    }
    if (onStyleDataLoadedListener != null) {
      _eventTypes.add(MapEvents.STYLE_DATA_LOADED);
    }
    if (onStyleImageMissingListener != null) {
      _eventTypes.add(MapEvents.STYLE_IMAGE_MISSING);
    }
    if (onStyleImageUnusedListener != null) {
      _eventTypes.add(MapEvents.STYLE_IMAGE_REMOVE_UNUSED);
    }
  }

  /// Resource options when using a MapWidget. Access token required when using a Mapbox service. Please see [https://www.mapbox.com/help/create-api-access-token/](https://www.mapbox.com/help/create-api-access-token/) to learn how to create one.More information in this guide [https://www.mapbox.com/help/first-steps-android-sdk/#access-tokens](https://www.mapbox.com/help/first-steps-android-sdk/#access-tokens).
  final ResourceOptions resourceOptions;

  /// Describes the map options value when using a MapWidget.
  final MapOptions? mapOptions;

  /// The Initial Camera options when creating a MapWidget.
  final CameraOptions? cameraOptions;

  /// Flag indicating to use a TextureView as render surface for the MapWidget.
  /// Only works for Android.
  /// FIXME Flutter 3.x has memory leak on Android using in SurfaceView mode, see https://github.com/flutter/flutter/issues/118384
  /// As a workaround default is true.
  final bool? textureView;

  /// The styleUri will applied for the MapWidget in the onStart lifecycle event if no style is set. Default is [Style.MAPBOX_STREETS].
  final String? styleUri;

  /// Invoked when a new Map is created and return a MapboxMap instance to handle the Map.
  final MapCreatedCallback? onMapCreated;

  /// Invoked when the requested style has been fully loaded, including the style, specified sprite and sources' metadata.
  final OnStyleLoadedListener? onStyleLoadedListener;

  /// Invoked whenever camera position changes.
  final OnCameraChangeListener? onCameraChangeListener;

  /// Invoked when the Map has entered the idle state. The Map is in the idle state when there are no ongoing transitions
  /// and the Map has rendered all available tiles.
  final OnMapIdleListener? onMapIdleListener;

  /// Invoked when the Map's style has been fully loaded, and the Map has rendered all visible tiles.
  final OnMapLoadedListener? onMapLoadedListener;

  /// Invoked whenever the map load errors out.
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

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty or null, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  final _mapWidgetState = _MapWidgetState();
  final _eventTypes = [];

  final OnMapTapListener? onTapListener;
  final OnMapLongTapListener? onLongTapListener;
  final OnMapScrollListener? onScrollListener;

  @override
  State createState() {
    return _mapWidgetState;
  }

  MapboxMap? getMapboxMap() => _mapWidgetState.mapboxMap;
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<MapboxMap> _controller = Completer<MapboxMap>();

  final _MapboxMapsPlatform _mapboxMapsPlatform = _MapboxMapsPlatform();

  MapboxMap? mapboxMap;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'resourceOptions': widget.resourceOptions.encode(),
      'mapOptions': widget.mapOptions?.encode(),
      'cameraOptions': widget.cameraOptions?.encode(),
      'textureView': widget.textureView,
      'styleUri': widget.styleUri,
      'eventTypes': widget._eventTypes,
      'mapboxPluginVersion': '0.4.4'
    };

    return _mapboxMapsPlatform.buildView(
        creationParams, onPlatformViewCreated, widget.gestureRecognizers);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    if (_controller.isCompleted) {
      final controller = await _controller.future;
      controller.dispose();
    }
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void onPlatformViewCreated(int id) {
    _mapboxMapsPlatform.initPlatform();
    final MapboxMap controller = MapboxMap(
      mapboxMapsPlatform: _mapboxMapsPlatform,
      onStyleLoadedListener: widget.onStyleLoadedListener,
      onCameraChangeListener: widget.onCameraChangeListener,
      onMapIdleListener: widget.onMapIdleListener,
      onMapLoadedListener: widget.onMapLoadedListener,
      onMapLoadErrorListener: widget.onMapLoadErrorListener,
      onRenderFrameFinishedListener: widget.onRenderFrameFinishedListener,
      onRenderFrameStartedListener: widget.onRenderFrameStartedListener,
      onSourceAddedListener: widget.onSourceAddedListener,
      onSourceDataLoadedListener: widget.onSourceDataLoadedListener,
      onSourceRemovedListener: widget.onSourceRemovedListener,
      onStyleDataLoadedListener: widget.onStyleDataLoadedListener,
      onStyleImageMissingListener: widget.onStyleImageMissingListener,
      onStyleImageUnusedListener: widget.onStyleImageUnusedListener,
      onMapTapListener: widget.onTapListener,
      onMapLongTapListener: widget.onLongTapListener,
      onMapScrollListener: widget.onScrollListener,
    );
    _controller.complete(controller);
    if (widget.onMapCreated != null) {
      widget.onMapCreated!(controller);
    }
    mapboxMap = controller;
  }
}
