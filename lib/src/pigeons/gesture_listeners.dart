part of mapbox_maps_flutter;

List<Object?> wrapResponse(
    {Object? result, PlatformException? error, bool empty = false}) {
  if (empty) {
    return <Object?>[];
  }
  if (error == null) {
    return <Object?>[result];
  }
  return <Object?>[error.code, error.message, error.details];
}

class _GestureListenerCodec extends StandardMessageCodec {
  const _GestureListenerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is ScreenCoordinate) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return ScreenCoordinate.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class GestureListener {
  static const MessageCodec<Object?> pigeonChannelCodec =
      _GestureListenerCodec();

  void onTap(ScreenCoordinate coordinate);

  void onLongTap(ScreenCoordinate coordinate);

  void onScroll(ScreenCoordinate coordinate);

  static void setup(GestureListener? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> __pigeon_channel =
          BasicMessageChannel<Object?>(
              'dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onTap',
              pigeonChannelCodec,
              binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onTap was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ScreenCoordinate? arg_coordinate =
              (args[0] as ScreenCoordinate?);
          assert(arg_coordinate != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onTap was null, expected non-null ScreenCoordinate.');
          try {
            api.onTap(arg_coordinate!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(
                error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> __pigeon_channel = BasicMessageChannel<
              Object?>(
          'dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onLongTap',
          pigeonChannelCodec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onLongTap was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ScreenCoordinate? arg_coordinate =
              (args[0] as ScreenCoordinate?);
          assert(arg_coordinate != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onLongTap was null, expected non-null ScreenCoordinate.');
          try {
            api.onLongTap(arg_coordinate!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(
                error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
    {
      final BasicMessageChannel<Object?> __pigeon_channel =
          BasicMessageChannel<Object?>(
              'dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onScroll',
              pigeonChannelCodec,
              binaryMessenger: binaryMessenger);
      if (api == null) {
        __pigeon_channel.setMessageHandler(null);
      } else {
        __pigeon_channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onScroll was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ScreenCoordinate? arg_coordinate =
              (args[0] as ScreenCoordinate?);
          assert(arg_coordinate != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onScroll was null, expected non-null ScreenCoordinate.');
          try {
            api.onScroll(arg_coordinate!);
            return wrapResponse(empty: true);
          } on PlatformException catch (e) {
            return wrapResponse(error: e);
          } catch (e) {
            return wrapResponse(
                error: PlatformException(code: 'error', message: e.toString()));
          }
        });
      }
    }
  }
}
