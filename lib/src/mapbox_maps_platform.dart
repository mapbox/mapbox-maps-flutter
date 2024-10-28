part of mapbox_maps_flutter;

typedef OnPlatformViewCreatedCallback = void Function(int);

class _MapboxMapsPlatform {
  late final MethodChannel _channel = MethodChannel(
      'plugins.flutter.io', const StandardMethodCodec(), binaryMessenger);
late final MethodChannel _nativeMapChannel = MethodChannel(
      'nativeMapChannel', const StandardMethodCodec(), binaryMessenger);

  final BinaryMessenger binaryMessenger;

  _MapboxMapsPlatform({required this.binaryMessenger}) {
    _channel.setMethodCallHandler(_handleMethodCall);
    _nativeMapChannel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method.startsWith("nativeMapHandle")) {
      final int handle = call.arguments;
      await runOnPlatformThread(() {
        Context.init("dart.framework/dart");
        print("Running on platform thread");
        final NativeMap nativeMap = MapMarshaller.toDart(Pointer<Void>.fromAddress(handle));
        print("Map created, attempting to call 'render' method");
        nativeMap.render();
        print("Render method called");
      });
    }
  }

  Widget buildView(
      AndroidPlatformViewHostingMode androidHostingMode,
      Map<String, dynamic> creationParams,
      OnPlatformViewCreatedCallback onPlatformViewCreated,
      Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers) {
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
            viewType: 'plugins.flutter.io/mapbox_maps',
            onPlatformViewCreated: onPlatformViewCreated,
            gestureRecognizers: gestureRecognizers,
            creationParams: creationParams,
            creationParamsCodec: const MapInterfaces_PigeonCodec(),
          );
      }
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
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
