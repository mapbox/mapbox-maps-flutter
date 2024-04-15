part of mapbox_maps_flutter;

typedef OnPlatformViewCreatedCallback = void Function(int);

final _SuffixesRegistry _suffixesRegistry = _SuffixesRegistry._instance();

class _MapboxMapsPlatform {
  final onStyleLoadedPlatform = ArgumentCallbacks<StyleLoadedEventData>();
  final onCameraChangeListenerPlatform =
      ArgumentCallbacks<CameraChangedEventData>();
  final onMapIdlePlatform = ArgumentCallbacks<MapIdleEventData>();
  final onMapLoadedPlatform = ArgumentCallbacks<MapLoadedEventData>();
  final onMapLoadErrorPlatform = ArgumentCallbacks<MapLoadingErrorEventData>();
  final onRenderFrameFinishedPlatform =
      ArgumentCallbacks<RenderFrameFinishedEventData>();
  final onRenderFrameStartedPlatform =
      ArgumentCallbacks<RenderFrameStartedEventData>();
  final onSourceAddedPlatform = ArgumentCallbacks<SourceAddedEventData>();
  final onSourceDataLoadedPlatform =
      ArgumentCallbacks<SourceDataLoadedEventData>();
  final onSourceRemovedPlatform = ArgumentCallbacks<SourceRemovedEventData>();
  final onStyleDataLoadedPlatform =
      ArgumentCallbacks<StyleDataLoadedEventData>();
  final onStyleImageMissingPlatform =
      ArgumentCallbacks<StyleImageMissingEventData>();
  final onStyleImageUnusedPlatform =
      ArgumentCallbacks<StyleImageUnusedEventData>();
  final onResourceRequestPlatform = ArgumentCallbacks<ResourceEventData>();

  final int _channelSuffix = _suffixesRegistry.getSuffix();
  late MethodChannel _channel;
  late BinaryMessenger binaryMessenger;

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      if (call.method.startsWith("event")) {
        handleEvents(call);
      } else {
        throw MissingPluginException();
      }
    } catch (error) {
      print(
          "Handle method call ${call.method}, arguments: ${call.arguments} with error: $error");
    }
  }

  void handleEvents(MethodCall call) {
    final eventType = _MapEvent.values[int.parse(call.method.split("#")[1])];
    switch (eventType) {
      case _MapEvent.styleLoaded:
        onStyleLoadedPlatform(
            StyleLoadedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.cameraChanged:
        onCameraChangeListenerPlatform(
            CameraChangedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.mapIdle:
        onMapIdlePlatform(
            MapIdleEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.mapLoaded:
        onMapLoadedPlatform(
            MapLoadedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.mapLoadingError:
        onMapLoadErrorPlatform(
            MapLoadingErrorEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.renderFrameFinished:
        onRenderFrameFinishedPlatform(
            RenderFrameFinishedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.renderFrameStarted:
        onRenderFrameStartedPlatform(
            RenderFrameStartedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.sourceAdded:
        onSourceAddedPlatform(
            SourceAddedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.sourceRemoved:
        onSourceRemovedPlatform(
            SourceRemovedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.sourceDataLoaded:
        onSourceDataLoadedPlatform(
            SourceDataLoadedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.styleDataLoaded:
        onStyleDataLoadedPlatform(
            StyleDataLoadedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.styleImageMissing:
        onStyleImageMissingPlatform(
            StyleImageMissingEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.styleImageRemoveUnused:
        onStyleImageUnusedPlatform(
            StyleImageUnusedEventData.fromJson(jsonDecode(call.arguments)));
        break;
      case _MapEvent.resourceRequest:
        onResourceRequestPlatform(
            ResourceEventData.fromJson(jsonDecode(call.arguments)));
        break;
      default:
        throw MissingPluginException();
    }
  }

  void initPlatform() {
    this.binaryMessenger = ProxyBinaryMessenger(suffix: "/map_$_channelSuffix");
    _channel = MethodChannel('plugins.flutter.io', const StandardMethodCodec(),
        this.binaryMessenger);
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Widget buildView(
      AndroidPlatformViewHostingMode androidHostingMode,
      Map<String, dynamic> creationParams,
      OnPlatformViewCreatedCallback onPlatformViewCreated,
      Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers) {
    creationParams['channelSuffix'] = _channelSuffix;

    if (defaultTargetPlatform == TargetPlatform.android) {
      switch (androidHostingMode) {
        case AndroidPlatformViewHostingMode.TLHC_VD:
        case AndroidPlatformViewHostingMode.TLHC_HC:
        case AndroidPlatformViewHostingMode.HC:
          return PlatformViewLink(
            viewType: "plugins.flutter.io/mapbox_maps",
            surfaceFactory: (context, controller) {
              return AndroidViewSurface(
                  controller: controller as AndroidViewController,
                  hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                  gestureRecognizers: gestureRecognizers ?? Set());
            },
            onCreatePlatformView: (params) {
              final AndroidViewController controller =
                  _androidViewControllerFactoryForMode(androidHostingMode)(
                id: params.id,
                viewType: 'plugins.flutter.io/mapbox_maps',
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () => params.onFocusChanged(true),
              );
              controller.addOnPlatformViewCreatedListener(
                params.onPlatformViewCreated,
              );
              controller.addOnPlatformViewCreatedListener(
                onPlatformViewCreated,
              );

              controller.create();
              return controller;
            },
          );
        case AndroidPlatformViewHostingMode.VD:
          return AndroidView(
            viewType: 'plugins.flutter.io/mapbox_maps',
            onPlatformViewCreated: onPlatformViewCreated,
            gestureRecognizers: gestureRecognizers,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
          );
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'plugins.flutter.io/mapbox_maps',
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the maps plugin');
  }

  AndroidViewController Function(
          {required int id,
          required String viewType,
          required TextDirection layoutDirection,
          dynamic creationParams,
          MessageCodec<dynamic>? creationParamsCodec,
          VoidCallback? onFocus})
      _androidViewControllerFactoryForMode(
          AndroidPlatformViewHostingMode hostingMode) {
    switch (hostingMode) {
      case AndroidPlatformViewHostingMode.TLHC_VD:
        return PlatformViewsService.initAndroidView;
      case AndroidPlatformViewHostingMode.TLHC_HC:
        return PlatformViewsService.initSurfaceAndroidView;
      case AndroidPlatformViewHostingMode.HC:
        return PlatformViewsService.initExpensiveAndroidView;
      case AndroidPlatformViewHostingMode.VD:
        throw "Unexpected hostring mode(VD) when selecting an android view controller";
    }
  }

  void dispose() async {
    await _channel.invokeMethod('platform#releaseMethodChannels');

    _suffixesRegistry.releaseSuffix(_channelSuffix);
    _channel.setMethodCallHandler(null);
  }

  Future<dynamic> createAnnotationManager(String type,
      {String? id, String? belowLayerId}) async {
    try {
      return _channel
          .invokeMethod('annotation#create_manager', <String, dynamic>{
        'type': type,
        'id': id,
        'belowLayerId': belowLayerId,
      });
    } on PlatformException catch (e) {
      return new Future.error(e);
    }
  }

  Future<void> removeAnnotationManager(String id) {
    try {
      return _channel.invokeMethod(
          'annotation#remove_manager', <String, dynamic>{'id': id});
    } on PlatformException catch (e) {
      return new Future.error(e);
    }
  }

  Future<dynamic> addGestureListeners() async {
    try {
      return _channel.invokeMethod('gesture#add_listeners');
    } on PlatformException catch (e) {
      return new Future.error(e);
    }
  }

  Future<dynamic> removeGestureListeners() async {
    try {
      return _channel.invokeMethod('gesture#remove_listeners');
    } on PlatformException catch (e) {
      return new Future.error(e);
    }
  }
}

/// A registry to hold suffixes for Channels.
///
class _SuffixesRegistry {
  _SuffixesRegistry._instance();

  int _suffix = -1;
  final Set<int> suffixesInUse = {};
  final Set<int> suffixesAvailable = {};

  int getSuffix() {
    int suffix;

    if (suffixesAvailable.isEmpty) {
      _suffix++;
      suffix = _suffix;
    } else {
      suffix = suffixesAvailable.first;
      suffixesAvailable.remove(suffix);
    }
    suffixesInUse.add(suffix);

    return suffix;
  }

  void releaseSuffix(int suffix) {
    suffixesInUse.remove(suffix);
    suffixesAvailable.add(suffix);
  }
}
