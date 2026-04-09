part of mapbox_maps_flutter_mobile;

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
  List<_MapEvent> subscribedEventTypes = [];

  List<_MapEvent> get eventTypes {
    return [
      if (_onStyleLoadedListener != null) _MapEvent.styleLoaded,
      if (_onCameraChangeListener != null) _MapEvent.cameraChanged,
      if (_onMapIdleListener != null) _MapEvent.mapIdle,
      if (_onMapLoadedListener != null) _MapEvent.mapLoaded,
      if (_onMapLoadErrorListener != null) _MapEvent.mapLoadingError,
      if (_onRenderFrameFinishedListener != null) _MapEvent.renderFrameFinished,
      if (_onRenderFrameStartedListener != null) _MapEvent.renderFrameStarted,
      if (_onSourceAddedListener != null) _MapEvent.sourceAdded,
      if (_onSourceDataLoadedListener != null) _MapEvent.sourceDataLoaded,
      if (_onSourceRemovedListener != null) _MapEvent.sourceRemoved,
      if (_onStyleDataLoadedListener != null) _MapEvent.styleDataLoaded,
      if (_onStyleImageMissingListener != null) _MapEvent.styleImageMissing,
      if (_onStyleImageUnusedListener != null) _MapEvent.styleImageRemoveUnused,
      if (_onResourceRequestListener != null) _MapEvent.resourceRequest,
    ];
  }

  _MapEvents({
    BinaryMessenger? binaryMessenger,
    required String channelSuffix,
  }) {
    final pigeon_channelSuffix = channelSuffix.length > 0
        ? '.${channelSuffix}'
        : '';
    _channel = MethodChannel(
      'com.mapbox.maps.flutter.map_events${pigeon_channelSuffix}',
      const StandardMethodCodec(),
      binaryMessenger,
    );
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  void updateSubscriptions() {
    final newEventTypes = eventTypes;

    if (listEquals(newEventTypes, subscribedEventTypes)) {
      return;
    }

    // let the native side know which events we are interested in
    _channel.invokeMethod(
      "subscribeToEvents",
      newEventTypes.map((e) => e.index).toList(),
    );

    subscribedEventTypes = newEventTypes;
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
        "Handle method call ${call.method}, arguments: ${call.arguments} with error: $error",
      );
    }
  }

  void _handleEvents(MethodCall call) {
    final eventType = _MapEvent.values[int.parse(call.method.split("#")[1])];
    switch (eventType) {
      case _MapEvent.styleLoaded:
        _onStyleLoadedListener?.call(
          StyleLoadedEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.cameraChanged:
        _onCameraChangeListener?.call(
          CameraChangedEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.mapIdle:
        _onMapIdleListener?.call(
          MapIdleEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.mapLoaded:
        _onMapLoadedListener?.call(
          MapLoadedEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.mapLoadingError:
        _onMapLoadErrorListener?.call(
          MapLoadingErrorEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.renderFrameFinished:
        _onRenderFrameFinishedListener?.call(
          RenderFrameFinishedEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.renderFrameStarted:
        _onRenderFrameStartedListener?.call(
          RenderFrameStartedEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.sourceAdded:
        _onSourceAddedListener?.call(
          SourceAddedEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.sourceRemoved:
        _onSourceRemovedListener?.call(
          SourceRemovedEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.sourceDataLoaded:
        _onSourceDataLoadedListener?.call(
          SourceDataLoadedEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.styleDataLoaded:
        _onStyleDataLoadedListener?.call(
          StyleDataLoadedEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.styleImageMissing:
        _onStyleImageMissingListener?.call(
          StyleImageMissingEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.styleImageRemoveUnused:
        _onStyleImageUnusedListener?.call(
          StyleImageUnusedEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
      case _MapEvent.resourceRequest:
        _onResourceRequestListener?.call(
          ResourceEventData.fromJson(jsonDecode(call.arguments)),
        );
        break;
    }
  }
}
