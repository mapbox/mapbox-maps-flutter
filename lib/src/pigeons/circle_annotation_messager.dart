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
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['id'] = id;
    pigeonMap['geometry'] = geometry;
    pigeonMap['circleSortKey'] = circleSortKey;
    pigeonMap['circleBlur'] = circleBlur;
    pigeonMap['circleColor'] = circleColor;
    pigeonMap['circleOpacity'] = circleOpacity;
    pigeonMap['circleRadius'] = circleRadius;
    pigeonMap['circleStrokeColor'] = circleStrokeColor;
    pigeonMap['circleStrokeOpacity'] = circleStrokeOpacity;
    pigeonMap['circleStrokeWidth'] = circleStrokeWidth;
    return pigeonMap;
  }

  static CircleAnnotation decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return CircleAnnotation(
      id: pigeonMap['id']! as String,
      geometry: (pigeonMap['geometry'] as Map<Object?, Object?>?)
          ?.cast<String?, Object?>(),
      circleSortKey: pigeonMap['circleSortKey'] as double?,
      circleBlur: pigeonMap['circleBlur'] as double?,
      circleColor: pigeonMap['circleColor'] as int?,
      circleOpacity: pigeonMap['circleOpacity'] as double?,
      circleRadius: pigeonMap['circleRadius'] as double?,
      circleStrokeColor: pigeonMap['circleStrokeColor'] as int?,
      circleStrokeOpacity: pigeonMap['circleStrokeOpacity'] as double?,
      circleStrokeWidth: pigeonMap['circleStrokeWidth'] as double?,
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
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['geometry'] = geometry;
    pigeonMap['circleSortKey'] = circleSortKey;
    pigeonMap['circleBlur'] = circleBlur;
    pigeonMap['circleColor'] = circleColor;
    pigeonMap['circleOpacity'] = circleOpacity;
    pigeonMap['circleRadius'] = circleRadius;
    pigeonMap['circleStrokeColor'] = circleStrokeColor;
    pigeonMap['circleStrokeOpacity'] = circleStrokeOpacity;
    pigeonMap['circleStrokeWidth'] = circleStrokeWidth;
    return pigeonMap;
  }

  static CircleAnnotationOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return CircleAnnotationOptions(
      geometry: (pigeonMap['geometry'] as Map<Object?, Object?>?)
          ?.cast<String?, Object?>(),
      circleSortKey: pigeonMap['circleSortKey'] as double?,
      circleBlur: pigeonMap['circleBlur'] as double?,
      circleColor: pigeonMap['circleColor'] as int?,
      circleOpacity: pigeonMap['circleOpacity'] as double?,
      circleRadius: pigeonMap['circleRadius'] as double?,
      circleStrokeColor: pigeonMap['circleStrokeColor'] as int?,
      circleStrokeOpacity: pigeonMap['circleStrokeOpacity'] as double?,
      circleStrokeWidth: pigeonMap['circleStrokeWidth'] as double?,
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
          'dev.flutter.pigeon.OnCircleAnnotationClickListener.onCircleAnnotationClick',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.OnCircleAnnotationClickListener.onCircleAnnotationClick was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final CircleAnnotation? arg_annotation =
              (args[0] as CircleAnnotation?);
          assert(arg_annotation != null,
              'Argument for dev.flutter.pigeon.OnCircleAnnotationClickListener.onCircleAnnotationClick was null, expected non-null CircleAnnotation.');
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
        'dev.flutter.pigeon._CircleAnnotationMessager.create', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_annotationOption])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CircleAnnotation?)!;
    }
  }

  Future<List<CircleAnnotation?>> createMulti(String arg_managerId,
      List<CircleAnnotationOptions?> arg_annotationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CircleAnnotationMessager.createMulti', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_annotationOptions])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as List<Object?>?)!.cast<CircleAnnotation?>();
    }
  }

  Future<void> update(
      String arg_managerId, CircleAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CircleAnnotationMessager.update', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_annotation])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> delete(
      String arg_managerId, CircleAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CircleAnnotationMessager.delete', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_annotation])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> deleteAll(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CircleAnnotationMessager.deleteAll', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> setCirclePitchAlignment(String arg_managerId,
      CirclePitchAlignment arg_circlePitchAlignment) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CircleAnnotationMessager.setCirclePitchAlignment',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
            .send(<Object?>[arg_managerId, arg_circlePitchAlignment.index])
        as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<int?> getCirclePitchAlignment(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CircleAnnotationMessager.getCirclePitchAlignment',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as int?);
    }
  }

  Future<void> setCirclePitchScale(
      String arg_managerId, CirclePitchScale arg_circlePitchScale) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CircleAnnotationMessager.setCirclePitchScale',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_circlePitchScale.index])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<int?> getCirclePitchScale(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CircleAnnotationMessager.getCirclePitchScale',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as int?);
    }
  }

  Future<void> setCircleTranslate(
      String arg_managerId, List<double?> arg_circleTranslate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CircleAnnotationMessager.setCircleTranslate',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_circleTranslate])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<List<double?>?> getCircleTranslate(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CircleAnnotationMessager.getCircleTranslate',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as List<Object?>?)?.cast<double?>();
    }
  }

  Future<void> setCircleTranslateAnchor(String arg_managerId,
      CircleTranslateAnchor arg_circleTranslateAnchor) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CircleAnnotationMessager.setCircleTranslateAnchor',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
            .send(<Object?>[arg_managerId, arg_circleTranslateAnchor.index])
        as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<int?> getCircleTranslateAnchor(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CircleAnnotationMessager.getCircleTranslateAnchor',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as int?);
    }
  }
}
