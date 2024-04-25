part of mapbox_maps_flutter;

final class _MapEvents {
  OnStyleLoadedListener? _onStyleLoadedListener;
  OnCameraChangeListener? _onCameraChangeListener;
  OnMapIdleListener? _onMapIdleListener;
  OnMapLoadedListener? _onMapLoadedListener;
  OnMapLoadErrorListener? _onMapLoadErrorListener;
  OnRenderFrameFinishedListener? _onRenderFrameFinishedListener;
  OnRenderFrameStartedListener? _onRenderFrameStartedListener;
  OnSourceAddedListener? _onSourceAddedListener;
  OnSourceDataLoadedListener? _onSourceDataLoadedListener;
  OnSourceRemovedListener? _onSourceRemovedListener;
  OnStyleDataLoadedListener? _onStyleDataLoadedListener;
  OnStyleImageMissingListener? _onStyleImageMissingListener;
  OnStyleImageUnusedListener? _onStyleImageUnusedListener;
  OnResourceRequestListener? _onResourceRequestListener;
  late final MethodChannel _channel;
  List<_MapEvent> _eventTypes = [];

  _MapEvents({BinaryMessenger? binaryMessenger, String? suffix}) {
    _channel = MethodChannel('com.mapbox.maps.flutter.map_events',
        const StandardMethodCodec(), binaryMessenger);
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  void updateSubscriptions({
    OnStyleLoadedListener? onStyleLoadedListener,
    OnCameraChangeListener? onCameraChangeListener,
    OnMapIdleListener? onMapIdleListener,
    OnMapLoadedListener? onMapLoadedListener,
    OnMapLoadErrorListener? onMapLoadErrorListener,
    OnRenderFrameFinishedListener? onRenderFrameFinishedListener,
    OnRenderFrameStartedListener? onRenderFrameStartedListener,
    OnSourceAddedListener? onSourceAddedListener,
    OnSourceDataLoadedListener? onSourceDataLoadedListener,
    OnSourceRemovedListener? onSourceRemovedListener,
    OnStyleDataLoadedListener? onStyleDataLoadedListener,
    OnStyleImageMissingListener? onStyleImageMissingListener,
    OnStyleImageUnusedListener? onStyleImageUnusedListener,
    OnResourceRequestListener? onResourceRequestListener,
  }) {
    final listenersMap = {
      onStyleLoadedListener: _MapEvent.styleLoaded,
      onCameraChangeListener: _MapEvent.cameraChanged,
      onMapIdleListener: _MapEvent.mapIdle,
      onMapLoadedListener: _MapEvent.mapLoaded,
      onMapLoadErrorListener: _MapEvent.mapLoadingError,
      onRenderFrameFinishedListener: _MapEvent.renderFrameFinished,
      onRenderFrameStartedListener: _MapEvent.renderFrameStarted,
      onSourceAddedListener: _MapEvent.sourceAdded,
      onSourceDataLoadedListener: _MapEvent.sourceDataLoaded,
      onSourceRemovedListener: _MapEvent.sourceRemoved,
      onStyleDataLoadedListener: _MapEvent.styleDataLoaded,
      onStyleImageMissingListener: _MapEvent.styleImageMissing,
      onStyleImageUnusedListener: _MapEvent.styleImageRemoveUnused,
      onResourceRequestListener: _MapEvent.resourceRequest,
    };
    listenersMap.remove(null);

    final newEventTypes = listenersMap.values.toList();

    if (listEquals(newEventTypes, _eventTypes)) {
      return;
    }

    // let the native side know which events we are interested in
    _channel.invokeMethod(
        "subscribeToEvents", newEventTypes.map((e) => e.index).toList());

    _onStyleLoadedListener = onStyleLoadedListener;
    _onCameraChangeListener = onCameraChangeListener;
    _onMapIdleListener = onMapIdleListener;
    _onMapLoadedListener = onMapLoadedListener;
    _onMapLoadErrorListener = onMapLoadErrorListener;
    _onRenderFrameFinishedListener = onRenderFrameFinishedListener;
    _onRenderFrameStartedListener = onRenderFrameStartedListener;
    _onSourceAddedListener = onSourceAddedListener;
    _onSourceDataLoadedListener = onSourceDataLoadedListener;
    _onSourceRemovedListener = onSourceRemovedListener;
    _onStyleDataLoadedListener = onStyleDataLoadedListener;
    _onStyleImageMissingListener = onStyleImageMissingListener;
    _onStyleImageUnusedListener = onStyleImageUnusedListener;
    _onResourceRequestListener = onResourceRequestListener;

    _eventTypes = newEventTypes;
  }

  void dispose() {
    _channel.setMethodCallHandler(null);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      if (call.method.startsWith("event")) {
        _handleEvents(call);
      } else {
        throw MissingPluginException();
      }
    } catch (error) {
      print(
          "Handle method call ${call.method}, arguments: ${call.arguments} with error: $error");
    }
  }

  void _handleEvents(MethodCall call) {
    final eventType = _MapEvent.values[int.parse(call.method.split("#")[1])];
    switch (eventType) {
      case _MapEvent.styleLoaded:
        _onStyleLoadedListener
            ?.call(StyleLoadedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.cameraChanged:
        _onCameraChangeListener
            ?.call(CameraChangedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.mapIdle:
        _onMapIdleListener
            ?.call(MapIdleEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.mapLoaded:
        _onMapLoadedListener
            ?.call(MapLoadedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.mapLoadingError:
        _onMapLoadErrorListener?.call(
            MapLoadingErrorEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.renderFrameFinished:
        _onRenderFrameFinishedListener?.call(
            RenderFrameFinishedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.renderFrameStarted:
        _onRenderFrameStartedListener?.call(
            RenderFrameStartedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.sourceAdded:
        _onSourceAddedListener
            ?.call(SourceAddedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.sourceRemoved:
        _onSourceRemovedListener
            ?.call(SourceRemovedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.sourceDataLoaded:
        _onSourceDataLoadedListener?.call(
            SourceDataLoadedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.styleDataLoaded:
        _onStyleDataLoadedListener?.call(
            StyleDataLoadedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.styleImageMissing:
        _onStyleImageMissingListener?.call(
            StyleImageMissingEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.styleImageRemoveUnused:
        _onStyleImageUnusedListener?.call(
            StyleImageUnusedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.resourceRequest:
        _onResourceRequestListener
            ?.call(ResourceEventData.fromJson(jsonDecode(call.arguments)));
        break;
    }
  }
}
