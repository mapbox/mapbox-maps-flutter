part of mapbox_maps_flutter;

class __SnapshotterMessagerCodec extends StandardMessageCodec {
  const __SnapshotterMessagerCodec();

  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CameraOptions) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is CameraState) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBounds) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is MbxEdgeInsets) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is MbxImage) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is Size) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CameraOptions.decode(readValue(buffer)!);
      case 129:
        return CameraState.decode(readValue(buffer)!);
      case 130:
        return CoordinateBounds.decode(readValue(buffer)!);
      case 131:
        return MbxEdgeInsets.decode(readValue(buffer)!);
      case 132:
        return MbxImage.decode(readValue(buffer)!);
      case 133:
        return ScreenCoordinate.decode(readValue(buffer)!);
      case 134:
        return Size.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class _SnapshotterMessager {
  /// Constructor for [_SnapshotterMessager].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  _SnapshotterMessager({BinaryMessenger? binaryMessenger})
      : __pigeon_binaryMessenger = binaryMessenger;
  final BinaryMessenger? __pigeon_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = __SnapshotterMessagerCodec();

  Future<void> cancel(String id) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.cancel';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[id]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> destroy(String id) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.destroy';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[id]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> setCamera(String id, CameraOptions cameraOptions) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.setCamera';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[id, cameraOptions]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> setStyleUri(String id, String styleUri) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.setStyleUri';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[id, styleUri]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> setStyleJson(String id, String styleJson) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.setStyleJson';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[id, styleJson]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> setSize(String id, Size size) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.setSize';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[id, size]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return;
    }
  }

  Future<CameraOptions> cameraForCoordinates(String id, List<Map<String?, Object?>?> coordinates,
      MbxEdgeInsets padding, double? bearing, double? pitch) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.cameraForCoordinates';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList = await __pigeon_channel
        .send(<Object?>[id, coordinates, padding, bearing, pitch]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as CameraOptions?)!;
    }
  }

  Future<CoordinateBounds> coordinateBoundsForCamera(String id, CameraOptions camera) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.coordinateBoundsForCamera';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[id, camera]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as CoordinateBounds?)!;
    }
  }

  Future<CameraState> getCameraState(String id) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.getCameraState';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[id]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as CameraState?)!;
    }
  }

  Future<Size> getSize(String id) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.getSize';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[id]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as Size?)!;
    }
  }

  Future<String> getStyleJson(String id) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.getStyleJson';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[id]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as String?)!;
    }
  }

  Future<String> getStyleUri(String id) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.getStyleUri';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[id]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (__pigeon_replyList[0] as String?)!;
    }
  }

  Future<MbxImage?> start(String id) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapshotterMessager.start';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[id]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as MbxImage?);
    }
  }
}

abstract class OnSnapshotStyleListener {
  static const MessageCodec<Object?> pigeonChannelCodec = StandardMessageCodec();

  void onDidFinishLoadingStyle();

  void onDidFullyLoadStyle();

  void onDidFailLoadingStyle(String message);

  void onStyleImageMissing(String imageId);

  static void setup(OnSnapshotStyleListener? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.mapbox_maps_flutter.OnSnapshotStyleListener.onDidFinishLoadingStyle',
          pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          try {
            api.onDidFinishLoadingStyle();
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.mapbox_maps_flutter.OnSnapshotStyleListener.onDidFullyLoadStyle',
          pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          try {
            api.onDidFullyLoadStyle();
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.mapbox_maps_flutter.OnSnapshotStyleListener.onDidFailLoadingStyle',
          pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.OnSnapshotStyleListener.onDidFailLoadingStyle was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_message = (args[0] as String?);
          assert(arg_message != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.OnSnapshotStyleListener.onDidFailLoadingStyle was null, expected non-null String.');
          try {
            api.onDidFailLoadingStyle(arg_message!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.mapbox_maps_flutter.OnSnapshotStyleListener.onStyleImageMissing',
          pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.OnSnapshotStyleListener.onStyleImageMissing was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final String? arg_imageId = (args[0] as String?);
          assert(arg_imageId != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.OnSnapshotStyleListener.onStyleImageMissing was null, expected non-null String.');
          try {
            api.onStyleImageMissing(arg_imageId!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}

class MapSnapshotOptions {
  MapSnapshotOptions({
    required this.size,
    required this.pixelRatio,
  });

  Size size;

  double pixelRatio;

  Object encode() {
    return <Object?>[
      size.encode(),
      pixelRatio,
    ];
  }

  static MapSnapshotOptions decode(Object result) {
    result as List<Object?>;
    return MapSnapshotOptions(
      size: Size.decode(result[0]! as List<Object?>),
      pixelRatio: result[1]! as double,
    );
  }
}

class SnapshotOverlayOptions {
  SnapshotOverlayOptions({
    this.showLogo = true,
    this.showAttributes = true,
  });

  bool showLogo;

  bool showAttributes;

  Object encode() {
    return <Object?>[
      showLogo,
      showAttributes,
    ];
  }

  static SnapshotOverlayOptions decode(Object result) {
    result as List<Object?>;
    return SnapshotOverlayOptions(
      showLogo: result[0]! as bool,
      showAttributes: result[1]! as bool,
    );
  }
}

class __SnapShotManagerCodec extends StandardMessageCodec {
  const __SnapShotManagerCodec();

  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is MapSnapshotOptions) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is MbxImage) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is Size) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is SnapshotOverlayOptions) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return MapSnapshotOptions.decode(readValue(buffer)!);
      case 129:
        return MbxImage.decode(readValue(buffer)!);
      case 130:
        return Size.decode(readValue(buffer)!);
      case 131:
        return SnapshotOverlayOptions.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class _SnapShotManager {
  /// Constructor for [_SnapShotManager].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  _SnapShotManager({BinaryMessenger? binaryMessenger}) : __pigeon_binaryMessenger = binaryMessenger;
  final BinaryMessenger? __pigeon_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec = __SnapShotManagerCodec();

  Future<SnapShotter> create(
      MapSnapshotOptions options, SnapshotOverlayOptions overlayOptions) async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapShotManager.create';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList =
        await __pigeon_channel.send(<Object?>[options, overlayOptions]) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else if (__pigeon_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      final id = (__pigeon_replyList[0] as String?)!;
      return SnapShotter(id, __pigeon_binaryMessenger!);
    }
  }

  Future<MbxImage?> snapshot() async {
    const String __pigeon_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._SnapShotManager.snapshot';
    final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<Object?>(
      __pigeon_channelName,
      pigeonChannelCodec,
      binaryMessenger: __pigeon_binaryMessenger,
    );
    final List<Object?>? __pigeon_replyList = await __pigeon_channel.send(null) as List<Object?>?;
    if (__pigeon_replyList == null) {
      throw _createConnectionError(__pigeon_channelName);
    } else if (__pigeon_replyList.length > 1) {
      throw PlatformException(
        code: __pigeon_replyList[0]! as String,
        message: __pigeon_replyList[1] as String?,
        details: __pigeon_replyList[2],
      );
    } else {
      return (__pigeon_replyList[0] as MbxImage?);
    }
  }
}
