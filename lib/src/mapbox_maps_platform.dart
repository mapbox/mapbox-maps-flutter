part of mapbox_maps_flutter;

typedef OnPlatformViewCreatedCallback = void Function(int);

class _MapboxMapsPlatform {
  late final MethodChannel _channel = MethodChannel(
      'plugins.flutter.io.${channelSuffix.toString()}',
      const StandardMethodCodec(),
      binaryMessenger);
  final BinaryMessenger binaryMessenger;
  final int channelSuffix;

  _MapboxMapsPlatform(
      {required this.binaryMessenger, required this.channelSuffix}) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  _MapboxMapsPlatform.instance(int channelSuffix)
      : this(
            binaryMessenger: ServicesBinding.instance.defaultBinaryMessenger,
            channelSuffix: channelSuffix);

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    print(
        "Handle method call ${call.method}, arguments: ${call.arguments} not supported");
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
        throw "Unexpected hostring mode(VD) when selecting an android view controller";
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
