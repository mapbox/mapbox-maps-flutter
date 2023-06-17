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

  void onTap(ScreenCoordinate coordinate, Map<String?, Object?> point);
  void onLongTap(ScreenCoordinate coordinate, Map<String?, Object?> point);
  void onScroll(ScreenCoordinate coordinate, Map<String?, Object?> point);

  static void setup(GestureListener? api, {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onTap', codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onTap was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ScreenCoordinate? arg_coordinate =
              (args[0] as ScreenCoordinate?);
          final Map<String?, Object?>? arg_point =
              (args[1] as Map<Object?, Object?>?)?.cast<String?, Object?>();
          assert(arg_coordinate != null || arg_point != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onTap was null, expected non-null ScreenCoordinate.');
          api.onTap(arg_coordinate!, arg_point!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onLongTap',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onLongTap was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ScreenCoordinate? arg_coordinate =
              (args[0] as ScreenCoordinate?);
          final Map<String?, Object?>? arg_point =
              (args[1] as Map<Object?, Object?>?)?.cast<String?, Object?>();
          assert(arg_coordinate != null || arg_point != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onLongTap was null, expected non-null ScreenCoordinate.');
          api.onLongTap(arg_coordinate!, arg_point!);
          return;
        });
      }
    }
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onScroll',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onScroll was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final ScreenCoordinate? arg_coordinate =
              (args[0] as ScreenCoordinate?);
          final Map<String?, Object?>? arg_point =
              (args[1] as Map<Object?, Object?>?)?.cast<String?, Object?>();
          assert(arg_coordinate != null || arg_point != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onScroll was null, expected non-null ScreenCoordinate.');
          api.onScroll(arg_coordinate!, arg_point!);
          return;
        });
      }
    }
  }
}
