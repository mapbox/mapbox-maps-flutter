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
  List<_MapEvent> _subscribedEventTypes = [];

  List<_MapEvent> get eventTypes {
    final listenersMap = {
      _onStyleLoadedListener: _MapEvent.styleLoaded,
      _onCameraChangeListener: _MapEvent.cameraChanged,
      _onMapIdleListener: _MapEvent.mapIdle,
      _onMapLoadedListener: _MapEvent.mapLoaded,
      _onMapLoadErrorListener: _MapEvent.mapLoadingError,
      _onRenderFrameFinishedListener: _MapEvent.renderFrameFinished,
      _onRenderFrameStartedListener: _MapEvent.renderFrameStarted,
      _onSourceAddedListener: _MapEvent.sourceAdded,
      _onSourceDataLoadedListener: _MapEvent.sourceDataLoaded,
      _onSourceRemovedListener: _MapEvent.sourceRemoved,
      _onStyleDataLoadedListener: _MapEvent.styleDataLoaded,
      _onStyleImageMissingListener: _MapEvent.styleImageMissing,
      _onStyleImageUnusedListener: _MapEvent.styleImageRemoveUnused,
      _onResourceRequestListener: _MapEvent.resourceRequest,
    };
    listenersMap.remove(null);

    return listenersMap.values.toList();
  }

  _MapEvents(
      {BinaryMessenger? binaryMessenger, required String channelSuffix}) {
    final pigeon_channelSuffix =
        channelSuffix.length > 0 ? '.${channelSuffix}' : '';
    _channel = MethodChannel(
        'com.mapbox.maps.flutter.map_events${pigeon_channelSuffix}',
        const StandardMethodCodec(),
        binaryMessenger);
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  void updateSubscriptions() {
    final newEventTypes = eventTypes;

    if (listEquals(newEventTypes, _subscribedEventTypes)) {
      return;
    }

    // let the native side know which events we are interested in
    _channel.invokeMethod(
        "subscribeToEvents", newEventTypes.map((e) => e.index).toList());

    _subscribedEventTypes = newEventTypes;
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
