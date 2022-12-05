part of mapbox_maps_flutter;

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
  static const MessageCodec<Object?> codec = _GestureListenerCodec();

  void onTap(ScreenCoordinate coordinate);
  void onLongTap(ScreenCoordinate coordinate);
  void onScroll(ScreenCoordinate coordinate);
  static void setup(GestureListener? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.GestureListener.onTap', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.GestureListener.onTap was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ScreenCoordinate? arg_coordinate =
              (args[0] as ScreenCoordinate?);
          assert(arg_coordinate != null,
              'Argument for dev.flutter.pigeon.GestureListener.onTap was null, expected non-null ScreenCoordinate.');
          api.onTap(arg_coordinate!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.GestureListener.onLongTap', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.GestureListener.onLongTap was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ScreenCoordinate? arg_coordinate =
              (args[0] as ScreenCoordinate?);
          assert(arg_coordinate != null,
              'Argument for dev.flutter.pigeon.GestureListener.onLongTap was null, expected non-null ScreenCoordinate.');
          api.onLongTap(arg_coordinate!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.GestureListener.onScroll', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.GestureListener.onScroll was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ScreenCoordinate? arg_coordinate =
              (args[0] as ScreenCoordinate?);
          assert(arg_coordinate != null,
              'Argument for dev.flutter.pigeon.GestureListener.onScroll was null, expected non-null ScreenCoordinate.');
          api.onScroll(arg_coordinate!);
          return;
        });
      }
    }
  }
}
