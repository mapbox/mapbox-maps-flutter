part of mapbox_maps_flutter;

/// Orientation of circle when map is pitched.
enum CirclePitchAlignment {
  /// The circle is aligned to the plane of the map.
  MAP,

  /// The circle is aligned to the plane of the viewport.
  VIEWPORT,
}

/// Controls the scaling behavior of the circle when the map is pitched.
enum CirclePitchScale {
  /// Circles are scaled according to their apparent distance to the camera.
  MAP,

  /// Circles are not scaled.
  VIEWPORT,
}

/// Controls the frame of reference for `circle-translate`.
enum CircleTranslateAnchor {
  /// The circle is translated relative to the map.
  MAP,

  /// The circle is translated relative to the viewport.
  VIEWPORT,
}

class CircleAnnotation {
  CircleAnnotation({
    required this.id,
    this.geometry,
    this.circleSortKey,
    this.circleBlur,
    this.circleColor,
    this.circleOpacity,
    this.circleRadius,
    this.circleStrokeColor,
    this.circleStrokeOpacity,
    this.circleStrokeWidth,
  });

  /// The id for annotation
  String id;

  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? circleSortKey;

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity.
  double? circleBlur;

  /// The fill color of the circle.
  int? circleColor;

  /// The opacity at which the circle will be drawn.
  double? circleOpacity;

  /// Circle radius.
  double? circleRadius;

  /// The stroke color of the circle.
  int? circleStrokeColor;

  /// The opacity of the circle's stroke.
  double? circleStrokeOpacity;

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`.
  double? circleStrokeWidth;

  Object encode() {
    return <Object?>[
      id,
      geometry,
      circleSortKey,
      circleBlur,
      circleColor,
      circleOpacity,
      circleRadius,
      circleStrokeColor,
      circleStrokeOpacity,
      circleStrokeWidth,
    ];
  }

  static CircleAnnotation decode(Object result) {
    result as List<Object?>;
    return CircleAnnotation(
      id: result[0]! as String,
      geometry: (result[1] as Map<Object?, Object?>?)?.cast<String?, Object?>(),
      circleSortKey: result[2] as double?,
      circleBlur: result[3] as double?,
      circleColor: result[4] as int?,
      circleOpacity: result[5] as double?,
      circleRadius: result[6] as double?,
      circleStrokeColor: result[7] as int?,
      circleStrokeOpacity: result[8] as double?,
      circleStrokeWidth: result[9] as double?,
    );
  }
}

class CircleAnnotationOptions {
  CircleAnnotationOptions({
    this.geometry,
    this.circleSortKey,
    this.circleBlur,
    this.circleColor,
    this.circleOpacity,
    this.circleRadius,
    this.circleStrokeColor,
    this.circleStrokeOpacity,
    this.circleStrokeWidth,
  });

  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? circleSortKey;

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity.
  double? circleBlur;

  /// The fill color of the circle.
  int? circleColor;

  /// The opacity at which the circle will be drawn.
  double? circleOpacity;

  /// Circle radius.
  double? circleRadius;

  /// The stroke color of the circle.
  int? circleStrokeColor;

  /// The opacity of the circle's stroke.
  double? circleStrokeOpacity;

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`.
  double? circleStrokeWidth;

  Object encode() {
    return <Object?>[
      geometry,
      circleSortKey,
      circleBlur,
      circleColor,
      circleOpacity,
      circleRadius,
      circleStrokeColor,
      circleStrokeOpacity,
      circleStrokeWidth,
    ];
  }

  static CircleAnnotationOptions decode(Object result) {
    result as List<Object?>;
    return CircleAnnotationOptions(
      geometry: (result[0] as Map<Object?, Object?>?)?.cast<String?, Object?>(),
      circleSortKey: result[1] as double?,
      circleBlur: result[2] as double?,
      circleColor: result[3] as int?,
      circleOpacity: result[4] as double?,
      circleRadius: result[5] as double?,
      circleStrokeColor: result[6] as int?,
      circleStrokeOpacity: result[7] as double?,
      circleStrokeWidth: result[8] as double?,
    );
  }
}

class _OnCircleAnnotationClickListenerCodec extends StandardMessageCodec {
  const _OnCircleAnnotationClickListenerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CircleAnnotation) {
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
        return CircleAnnotation.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class OnCircleAnnotationClickListener {
  static const MessageCodec<Object?> codec =
      _OnCircleAnnotationClickListenerCodec();

  void onCircleAnnotationClick(CircleAnnotation annotation);

  static void setup(OnCircleAnnotationClickListener? api,
      {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.mapbox_maps_flutter.OnCircleAnnotationClickListener.onCircleAnnotationClick',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.OnCircleAnnotationClickListener.onCircleAnnotationClick was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final CircleAnnotation? arg_annotation =
              (args[0] as CircleAnnotation?);
          assert(arg_annotation != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.OnCircleAnnotationClickListener.onCircleAnnotationClick was null, expected non-null CircleAnnotation.');
          api.onCircleAnnotationClick(arg_annotation!);
          return;
        });
      }
    }
  }
}

class __CircleAnnotationMessagerCodec extends StandardMessageCodec {
  const __CircleAnnotationMessagerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CircleAnnotation) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is CircleAnnotationOptions) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CircleAnnotation.decode(readValue(buffer)!);
      case 129:
        return CircleAnnotationOptions.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class _CircleAnnotationMessager {
  /// Constructor for [_CircleAnnotationMessager].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  _CircleAnnotationMessager({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = __CircleAnnotationMessagerCodec();

  Future<CircleAnnotation> create(String arg_managerId,
      CircleAnnotationOptions arg_annotationOption) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.create',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
        .send(<Object?>[arg_managerId, arg_annotationOption]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as CircleAnnotation?)!;
    }
  }

  Future<List<CircleAnnotation?>> createMulti(String arg_managerId,
      List<CircleAnnotationOptions?> arg_annotationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.createMulti',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_managerId, arg_annotationOptions])
            as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as List<Object?>?)!.cast<CircleAnnotation?>();
    }
  }

  Future<void> update(
      String arg_managerId, CircleAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.update',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
        .send(<Object?>[arg_managerId, arg_annotation]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> delete(
      String arg_managerId, CircleAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.delete',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
        .send(<Object?>[arg_managerId, arg_annotation]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> deleteAll(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.deleteAll',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_managerId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<void> setCircleEmissiveStrength(
      String arg_managerId, double arg_circleEmissiveStrength) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.setCircleEmissiveStrength',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_managerId, arg_circleEmissiveStrength])
            as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<double?> getCircleEmissiveStrength(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.getCircleEmissiveStrength',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_managerId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return (replyList[0] as double?);
    }
  }

  Future<void> setCirclePitchAlignment(String arg_managerId,
      CirclePitchAlignment arg_circlePitchAlignment) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.setCirclePitchAlignment',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
            .send(<Object?>[arg_managerId, arg_circlePitchAlignment.index])
        as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<int?> getCirclePitchAlignment(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.getCirclePitchAlignment',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_managerId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return (replyList[0] as int?);
    }
  }

  Future<void> setCirclePitchScale(
      String arg_managerId, CirclePitchScale arg_circlePitchScale) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.setCirclePitchScale',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_managerId, arg_circlePitchScale.index])
            as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<int?> getCirclePitchScale(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.getCirclePitchScale',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_managerId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return (replyList[0] as int?);
    }
  }

  Future<void> setCircleTranslate(
      String arg_managerId, List<double?> arg_circleTranslate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.setCircleTranslate',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
        .send(<Object?>[arg_managerId, arg_circleTranslate]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<List<double?>?> getCircleTranslate(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.getCircleTranslate',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_managerId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return (replyList[0] as List<Object?>?)?.cast<double?>();
    }
  }

  Future<void> setCircleTranslateAnchor(String arg_managerId,
      CircleTranslateAnchor arg_circleTranslateAnchor) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.setCircleTranslateAnchor',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
            .send(<Object?>[arg_managerId, arg_circleTranslateAnchor.index])
        as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return;
    }
  }

  Future<int?> getCircleTranslateAnchor(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._CircleAnnotationMessager.getCircleTranslateAnchor',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList =
        await channel.send(<Object?>[arg_managerId]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return (replyList[0] as int?);
    }
  }
}
