part of mapbox_maps_flutter;

final _SuffixesRegistry _suffixesRegistry = _SuffixesRegistry._instance();

/// A mode for platform MapView to be hosted in Flutter on Android platform.
///
/// As per https://github.com/flutter/flutter/wiki/Android-Platform-Views#selecting-a-mode
@experimental
enum AndroidPlatformViewHostingMode {
  /// Texture Layer Hybrid Composition with fallback to Virtual Display,
  /// when the current SDK version is <23 or [MapWidget.textureView] is `false`.
  ///
  /// https://github.com/flutter/flutter/wiki/Texture-Layer-Hybrid-Composition
  TLHC_VD,

  /// Use Texture Layer Hybrid Composition hosting mode with fallback to Hybrid Composition,
  /// when the current SDK version is <23 or [MapWidget.textureView] is `false`.
  ///
  /// https://github.com/flutter/flutter/wiki/Texture-Layer-Hybrid-Composition
  TLHC_HC,

  /// Always use Hybrid Composition hosting mode.
  ///
  /// https://github.com/flutter/flutter/wiki/Hybrid-Composition
  HC,

  /// Always use Virtual Display hosting mode.
  ///
  /// https://github.com/flutter/flutter/wiki/Virtual-Display
  VD,
}

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
  const MapWidget({
    super.key,
    this.mapOptions,
    this.cameraOptions,
    // FIXME Flutter 3.x has memory leak on Android using in SurfaceView mode, see https://github.com/flutter/flutter/issues/118384
    // As a workaround default is true.
    this.textureView = true,
    this.androidHostingMode = AndroidPlatformViewHostingMode.VD,
    this.styleUri = MapboxStyles.STANDARD,
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
    this.onResourceRequestListener,
    this.onTapListener,
    this.onLongTapListener,
    this.onScrollListener,
    this.viewport,
  });

  /// Describes the map options value when using a MapWidget.
  final MapOptions? mapOptions;

  /// The Initial Camera options when creating a MapWidget.
  final CameraOptions? cameraOptions;

  /// Flag indicating to use a TextureView as render surface for the MapWidget.
  /// Only works for Android.
  /// FIXME Flutter 3.x has memory leak on Android using in SurfaceView mode, see https://github.com/flutter/flutter/issues/118384
  /// As a workaround default is true.
  final bool? textureView;

  /// Controls the way the underlying MapView is being hosted by Flutter on Android.
  /// This setting has no effect on iOS.
  @experimental
  final AndroidPlatformViewHostingMode androidHostingMode;

  /// The styleUri will applied for the MapWidget in the onStart lifecycle event if no style is set. Default is [Style.MAPBOX_STREETS].
  final String styleUri;

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

  /// Invoked when map makes a request to load required resources.
  final OnResourceRequestListener? onResourceRequestListener;

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

  /// The initial camera position and behavior of the map.
  ///
  /// Use [viewport] to specify how the camera is positioned when the map is first displayed.
  /// By providing a [ViewportState] subclass, you can control the camera's initial focus,
  /// such as centering on a specific location or following the user's position.
  ///
  /// If [viewport] is not provided, the map uses its default camera settings.
  ///
  /// **Example:**
  ///
  /// ```dart
  /// MapWidget(
  ///   viewport: CameraViewportState(
  ///     center: Point(coordinates: Position(-117.918976, 33.812092)),
  ///     zoom: 15.0,
  ///   ),
  /// );
  /// ```
  final ViewportState? viewport;

  final OnMapTapListener? onTapListener;
  final OnMapLongTapListener? onLongTapListener;
  final OnMapScrollListener? onScrollListener;

  @override
  State createState() => _MapWidgetState();

  @Deprecated(
      'Subscribe to onMapCreated to receive an instance of MapboxMap instead')
  MapboxMap? getMapboxMap() => null;
}

class _MapWidgetState extends State<MapWidget> {
  late final _MapboxMapsPlatform _mapboxMapsPlatform =
      _MapboxMapsPlatform.instance(_suffix);
  final int _suffix = _suffixesRegistry.getSuffix();
  late final _MapEvents _events;
  bool _needsStateUpdate = false;
  MapboxMap? mapboxMap;
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'mapOptions': widget.mapOptions,
      'cameraOptions': widget.cameraOptions,
      'textureView': widget.textureView,
      'styleUri': widget.styleUri,
      'channelSuffix': _mapboxMapsPlatform.channelSuffix,
      'mapboxPluginVersion': '2.5.0-beta.1',
      'eventTypes': _events.eventTypes.map((e) => e.index).toList(),
    };

    return _mapboxMapsPlatform.buildView(widget.androidHostingMode,
        creationParams, onPlatformViewCreated, widget.gestureRecognizers,
        key: key);
  }

  @override
  void dispose() {
    mapboxMap?.dispose();
    _suffixesRegistry.releaseSuffix(_suffix);
    _events.dispose();
    _needsStateUpdate = false;

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    LogConfiguration._setupDebugLoggingIfNeeded();
    _events = _MapEvents(
        binaryMessenger: _mapboxMapsPlatform.binaryMessenger,
        channelSuffix: _suffix.toString());

    _updateEventListeners();
    // Here we mark the state as needing an update to ensure
    // the widget configuration is propagated to the platform side.
    //
    // No need to call _updateStateIfNeeded() here as the platform view is not yet created.
    _markNeedsStateUpdate();
  }

  void _markNeedsStateUpdate() {
    _needsStateUpdate = true;
  }

  void _updateStateIfNeeded({MapWidget? oldWidget}) {
    if (!_needsStateUpdate) {
      return;
    }
    _updateViewportState(oldWidget);
    _updateEventListeners();
    _events.updateSubscriptions();
    _needsStateUpdate = false;
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Widget properties have changed, mark the state as needing an update
    // and update the state(if platform view has been created already).
    _markNeedsStateUpdate();
    _updateStateIfNeeded(oldWidget: oldWidget);
  }

  void _updateViewportState(MapWidget? oldWidget) async {
    final mapboxMap = this.mapboxMap;
    if (mapboxMap == null) {
      return;
    }
    final currentViewport = widget.viewport;
    if (currentViewport == oldWidget?.viewport || currentViewport == null) {
      return;
    }
    final viewportAnimation = _viewportTransition;
    _viewportTransition = null;
    final completion = _viewportTransitionCompletion;

    final result = await mapboxMap._viewportMessenger.transition(
        currentViewport._toStorage(), viewportAnimation?._toStorage());

    if (_viewportTransitionCompletion == completion) {
      _viewportTransitionCompletion = null;
      if (mounted) {
        completion?.call(result);
      }
    }
  }

  void _updateEventListeners() {
    _events._onStyleLoadedListener = widget.onStyleLoadedListener;
    _events._onCameraChangeListener = widget.onCameraChangeListener;
    _events._onMapIdleListener = widget.onMapIdleListener;
    _events._onMapLoadedListener = widget.onMapLoadedListener;
    _events._onMapLoadErrorListener = widget.onMapLoadErrorListener;
    _events._onRenderFrameFinishedListener =
        widget.onRenderFrameFinishedListener;
    _events._onRenderFrameStartedListener = widget.onRenderFrameStartedListener;
    _events._onSourceAddedListener = widget.onSourceAddedListener;
    _events._onSourceDataLoadedListener = widget.onSourceDataLoadedListener;
    _events._onSourceRemovedListener = widget.onSourceRemovedListener;
    _events._onStyleDataLoadedListener = widget.onStyleDataLoadedListener;
    _events._onStyleImageMissingListener = widget.onStyleImageMissingListener;
    _events._onStyleImageUnusedListener = widget.onStyleImageUnusedListener;
    _events._onResourceRequestListener = widget.onResourceRequestListener;
  }

  Future<void> onPlatformViewCreated(int id) async {
    final MapboxMap controller = MapboxMap._(
      mapboxMapsPlatform: _mapboxMapsPlatform,
      onMapTapListener: widget.onTapListener,
      onMapLongTapListener: widget.onLongTapListener,
      onMapScrollListener: widget.onScrollListener,
    );
    if (widget.onMapCreated != null) {
      widget.onMapCreated!(controller);
    }
    mapboxMap = controller;

    // WARNING: Because platform view is not sized at this moment on iOS,
    // it is not safe to call methods that depend on the size of the platform view,
    // e.g. `setCamera` or any high-level API built on top of it(animations, viewport).
    //
    // As a way to address this we pass the size hint to the view upon creation.
    final size = key.currentContext?.size;
    if (size != null) {
      await _mapboxMapsPlatform.submitViewSizeHint(
          width: size.width, height: size.height);
    }

    // The platform view is created, update the state if there were any requests.
    _updateStateIfNeeded();
  }
}
