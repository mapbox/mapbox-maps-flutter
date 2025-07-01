part of '../mapbox_maps_flutter_mobile.dart';

@Deprecated(
    'This is deprecated and will be removed in future releases. Use annotations [tapEvents] instead.')
abstract class OnCircleAnnotationClickListener {
  static const MessageCodec<Object?> pigeonChannelCodec =
      CircleAnnotationMessenger_PigeonCodec();

  void onCircleAnnotationClick(CircleAnnotation annotation);

  static final _cancelables = <String, Cancelable>{};

  static void setUp(
    OnCircleAnnotationClickListener? api, {
    BinaryMessenger? binaryMessenger,
    String messageChannelSuffix = '',
  }) {
    var channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter_mobile.OnCircleAnnotationClickListener.onCircleAnnotationClick';
    if (messageChannelSuffix.isNotEmpty) {
      channelName += '.$messageChannelSuffix';
    }

    if (api == null) {
      _cancelables[channelName]?.cancel();
      _cancelables.remove(channelName);
    }
  }

  static void _withCancelable(
      Cancelable cancelable, String messageChannelSuffix) {
    var channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter_mobile.OnCircleAnnotationClickListener.onCircleAnnotationClick';
    if (messageChannelSuffix.isNotEmpty) {
      channelName += '.$messageChannelSuffix';
    }
    _cancelables[channelName] = cancelable;
  }
}

@Deprecated(
    'This is deprecated and will be removed in future releases. Use annotations [tapEvents] instead.')
abstract class OnPointAnnotationClickListener {
  static const MessageCodec<Object?> pigeonChannelCodec =
      PointAnnotationMessenger_PigeonCodec();

  void onPointAnnotationClick(PointAnnotation annotation);

  static final _cancelables = <String, Cancelable>{};

  static void setUp(
    OnPointAnnotationClickListener? api, {
    BinaryMessenger? binaryMessenger,
    String messageChannelSuffix = '',
  }) {
    var channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter_mobile.OnPointAnnotationClickListener.onPointAnnotationClick';
    if (messageChannelSuffix.isNotEmpty) {
      channelName += '.$messageChannelSuffix';
    }

    if (api == null) {
      _cancelables[channelName]?.cancel();
      _cancelables.remove(channelName);
    }
  }

  static void _withCancelable(
      Cancelable cancelable, String messageChannelSuffix) {
    var channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter.OnCircleAnnotationClickListener.onCircleAnnotationClick';
    if (messageChannelSuffix.isNotEmpty) {
      channelName += '.$messageChannelSuffix';
    }
    _cancelables[channelName] = cancelable;
  }
}

@Deprecated(
    'This is deprecated and will be removed in future releases. Use annotations [tapEvents] instead.')
abstract class OnPolygonAnnotationClickListener {
  static const MessageCodec<Object?> pigeonChannelCodec =
      PolygonAnnotationMessenger_PigeonCodec();

  void onPolygonAnnotationClick(PolygonAnnotation annotation);

  static final _cancelables = <String, Cancelable>{};

  static void setUp(
    OnPolygonAnnotationClickListener? api, {
    BinaryMessenger? binaryMessenger,
    String messageChannelSuffix = '',
  }) {
    var channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter_mobile.OnPolygonAnnotationClickListener.onPolygonAnnotationClick';
    if (messageChannelSuffix.isNotEmpty) {
      channelName += '.$messageChannelSuffix';
    }

    if (api == null) {
      _cancelables[channelName]?.cancel();
      _cancelables.remove(channelName);
    }
  }

  static void _withCancelable(
      Cancelable cancelable, String messageChannelSuffix) {
    var channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter_mobile.OnCircleAnnotationClickListener.onCircleAnnotationClick';
    if (messageChannelSuffix.isNotEmpty) {
      channelName += '.$messageChannelSuffix';
    }
    _cancelables[channelName] = cancelable;
  }
}

@Deprecated(
    'This is deprecated and will be removed in future releases. Use annotations [tapEvents] instead.')
abstract class OnPolylineAnnotationClickListener {
  static const MessageCodec<Object?> pigeonChannelCodec =
      PolylineAnnotationMessenger_PigeonCodec();

  void onPolylineAnnotationClick(PolylineAnnotation annotation);

  static final _cancelables = <String, Cancelable>{};

  static void setUp(
    OnPolylineAnnotationClickListener? api, {
    BinaryMessenger? binaryMessenger,
    String messageChannelSuffix = '',
  }) {
    var channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter_mobile.OnPolylineAnnotationClickListener.onPolylineAnnotationClick';
    if (messageChannelSuffix.isNotEmpty) {
      channelName += '.$messageChannelSuffix';
    }

    if (api == null) {
      _cancelables[channelName]?.cancel();
      _cancelables.remove(channelName);
    }
  }

  static void _withCancelable(
      Cancelable cancelable, String messageChannelSuffix) {
    var channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter_mobile.OnCircleAnnotationClickListener.onCircleAnnotationClick';
    if (messageChannelSuffix.isNotEmpty) {
      channelName += '.$messageChannelSuffix';
    }
    _cancelables[channelName] = cancelable;
  }
}
