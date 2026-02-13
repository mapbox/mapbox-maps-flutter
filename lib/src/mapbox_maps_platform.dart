part of mapbox_maps_flutter;

typedef OnPlatformViewCreatedCallback = void Function(int);

class _MapboxMapsPlatform {
  late final MethodChannel _channel = MethodChannel(
      'plugins.flutter.io.${channelSuffix.toString()}',
      const StandardMethodCodec(),
      binaryMessenger);
  final BinaryMessenger binaryMessenger;
  final int channelSuffix;

  // HTTP interceptor callbacks
  HttpRequestInterceptor? _requestInterceptor;
  HttpResponseInterceptor? _responseInterceptor;
  bool _isInterceptorEnabled = false;

  _MapboxMapsPlatform(
      {required this.binaryMessenger, required this.channelSuffix}) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  _MapboxMapsPlatform.instance(int channelSuffix)
      : this(
            binaryMessenger: ServicesBinding.instance.defaultBinaryMessenger,
            channelSuffix: channelSuffix);

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'http#onRequest':
        if (_requestInterceptor != null) {
          final requestMap = call.arguments as Map<dynamic, dynamic>;
          final request = HttpInterceptorRequest.fromMap(requestMap);
          final modifiedRequest = await _requestInterceptor!(request);
          if (modifiedRequest != null) {
            return modifiedRequest.toMap();
          }
        }
        return null;
      case 'http#onResponse':
        if (_responseInterceptor != null) {
          try {
            final responseMap = call.arguments as Map<dynamic, dynamic>;
            final response = HttpInterceptorResponse.fromMap(responseMap);
            await _responseInterceptor!(response);
          } catch (e) {
            print('Error handling http#onResponse: $e');
            print('Arguments: ${call.arguments}');
          }
        }
        return null;
      default:
        print(
            "Handle method call ${call.method}, arguments: ${call.arguments} not supported");
        return null;
    }
  }

  Widget buildView(
      AndroidPlatformViewHostingMode androidHostingMode,
      Map<String, dynamic> creationParams,
      OnPlatformViewCreatedCallback onPlatformViewCreated,
      Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
      {Key? key}) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      switch (androidHostingMode) {
        case AndroidPlatformViewHostingMode.TLHC_VD:
        case AndroidPlatformViewHostingMode.TLHC_HC:
        case AndroidPlatformViewHostingMode.HC:
          return PlatformViewLink(
            key: key,
            viewType: "plugins.flutter.io/mapbox_maps",
            surfaceFactory: (context, controller) {
              return AndroidViewSurface(
                  controller: controller as AndroidViewController,
                  hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                  gestureRecognizers: gestureRecognizers ?? {});
            },
            onCreatePlatformView: (params) {
              final AndroidViewController controller =
                  _androidViewControllerFactoryForMode(androidHostingMode)(
                id: params.id,
                viewType: 'plugins.flutter.io/mapbox_maps',
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const MapInterfaces_PigeonCodec(),
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
            key: key,
            viewType: 'plugins.flutter.io/mapbox_maps',
            onPlatformViewCreated: onPlatformViewCreated,
            gestureRecognizers: gestureRecognizers,
            creationParams: creationParams,
            creationParamsCodec: const MapInterfaces_PigeonCodec(),
          );
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        key: key,
        viewType: 'plugins.flutter.io/mapbox_maps',
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const MapInterfaces_PigeonCodec(),
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
        throw "Unexpected hosting mode(VD) when selecting an android view controller";
    }
  }

  Future<void> submitViewSizeHint(
      {required double width, required double height}) {
    return _channel
        .invokeMethod('mapView#submitViewSizeHint', <String, dynamic>{
      'width': width,
      'height': height,
    });
  }

  void dispose() async {
    try {
      await _channel.invokeMethod('platform#releaseMethodChannels');
    } catch (e) {
      print("Error releasing method channels: $e");
    }

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

  Future<dynamic> addInteractionsListeners(
      _Interaction interaction, String interactionID) async {
    var interactionPigeon = _InteractionPigeon(
        featuresetDescriptor:
            interaction.featuresetDescriptor?.encode() as List<Object?>?,
        stopPropagation: interaction.stopPropagation,
        interactionType: interaction.interactionType.name,
        identifier: interactionID,
        radius: interaction.radius,
        filter: interaction.filter);
    try {
      return _channel
          .invokeMethod('interactions#add_interaction', <String, dynamic>{
        'interaction': interactionPigeon.encode(),
      });
    } on PlatformException catch (e) {
      return new Future.error(e);
    }
  }

  Future<dynamic> removeInteractionsListeners(String interactionID) async {
    try {
      return _channel.invokeMethod('interactions#remove_interaction',
          <String, dynamic>{'identifier': interactionID});
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

  Future<Uint8List> snapshot() async {
    try {
      final List<int> data = await _channel.invokeMethod('map#snapshot');
      return Uint8List.fromList(data);
    } on PlatformException catch (e) {
      return new Future.error(e);
    }
  }

  /// Sets custom headers for all Mapbox HTTP requests.
  ///
  /// These headers are applied statically to all requests.
  Future<void> setCustomHeaders(Map<String, String> headers) async {
    await _channel.invokeMethod('map#setCustomHeaders', {'headers': headers});
  }

  /// Sets a callback to intercept HTTP requests before they are sent.
  Future<void> setHttpRequestInterceptor(
      HttpRequestInterceptor? interceptor) async {
    _requestInterceptor = interceptor;
    await _updateInterceptorState();
  }

  /// Sets a callback to intercept HTTP responses after they are received.
  Future<void> setHttpResponseInterceptor(
      HttpResponseInterceptor? interceptor) async {
    _responseInterceptor = interceptor;
    await _updateInterceptorState();
  }

  /// Updates the native interceptor state based on whether any interceptors are set.
  Future<void> _updateInterceptorState() async {
    final shouldEnable =
        _requestInterceptor != null || _responseInterceptor != null;
    final interceptRequests = _requestInterceptor != null;
    final interceptResponses = _responseInterceptor != null;

    // Always update native side when interceptor configuration changes
    // (not just when enabled/disabled state changes)
    await _channel.invokeMethod('map#setHttpInterceptorEnabled', {
      'enabled': shouldEnable,
      'interceptRequests': interceptRequests,
      'interceptResponses': interceptResponses,
    });
    _isInterceptorEnabled = shouldEnable;
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
