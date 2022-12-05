part of mapbox_maps_flutter;

/// The display of line endings.
enum LineCap {
  /// A cap with a squared-off end which is drawn to the exact endpoint of the line.
  BUTT,

  /// A cap with a rounded end which is drawn beyond the endpoint of the line at a radius of one-half of the line's width and centered on the endpoint of the line.
  ROUND,

  /// A cap with a squared-off end which is drawn beyond the endpoint of the line at a distance of one-half of the line's width.
  SQUARE,
}

/// The display of lines when joining.
enum LineJoin {
  /// A join with a squared-off end which is drawn beyond the endpoint of the line at a distance of one-half of the line's width.
  BEVEL,

  /// A join with a rounded end which is drawn beyond the endpoint of the line at a radius of one-half of the line's width and centered on the endpoint of the line.
  ROUND,

  /// A join with a sharp, angled corner which is drawn with the outer sides beyond the endpoint of the path until they meet.
  MITER,
}

/// Controls the frame of reference for `line-translate`.
enum LineTranslateAnchor {
  /// The line is translated relative to the map.
  MAP,

  /// The line is translated relative to the viewport.
  VIEWPORT,
}

class PolylineAnnotation {
  PolylineAnnotation({
    required this.id,
    this.geometry,
    this.lineJoin,
    this.lineSortKey,
    this.lineBlur,
    this.lineColor,
    this.lineGapWidth,
    this.lineOffset,
    this.lineOpacity,
    this.linePattern,
    this.lineWidth,
  });

  /// The id for annotation
  String id;

  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;

  /// The display of lines when joining.
  LineJoin? lineJoin;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? lineSortKey;

  /// Blur applied to the line, in pixels.
  double? lineBlur;

  /// The color with which the line will be drawn.
  int? lineColor;

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap.
  double? lineGapWidth;

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset.
  double? lineOffset;

  /// The opacity at which the line will be drawn.
  double? lineOpacity;

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? linePattern;

  /// Stroke thickness.
  double? lineWidth;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['id'] = id;
    pigeonMap['geometry'] = geometry;
    pigeonMap['lineJoin'] = lineJoin?.index;
    pigeonMap['lineSortKey'] = lineSortKey;
    pigeonMap['lineBlur'] = lineBlur;
    pigeonMap['lineColor'] = lineColor;
    pigeonMap['lineGapWidth'] = lineGapWidth;
    pigeonMap['lineOffset'] = lineOffset;
    pigeonMap['lineOpacity'] = lineOpacity;
    pigeonMap['linePattern'] = linePattern;
    pigeonMap['lineWidth'] = lineWidth;
    return pigeonMap;
  }

  static PolylineAnnotation decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return PolylineAnnotation(
      id: pigeonMap['id']! as String,
      geometry: (pigeonMap['geometry'] as Map<Object?, Object?>?)
          ?.cast<String?, Object?>(),
      lineJoin: pigeonMap['lineJoin'] != null
          ? LineJoin.values[pigeonMap['lineJoin']! as int]
          : null,
      lineSortKey: pigeonMap['lineSortKey'] as double?,
      lineBlur: pigeonMap['lineBlur'] as double?,
      lineColor: pigeonMap['lineColor'] as int?,
      lineGapWidth: pigeonMap['lineGapWidth'] as double?,
      lineOffset: pigeonMap['lineOffset'] as double?,
      lineOpacity: pigeonMap['lineOpacity'] as double?,
      linePattern: pigeonMap['linePattern'] as String?,
      lineWidth: pigeonMap['lineWidth'] as double?,
    );
  }
}

class PolylineAnnotationOptions {
  PolylineAnnotationOptions({
    this.geometry,
    this.lineJoin,
    this.lineSortKey,
    this.lineBlur,
    this.lineColor,
    this.lineGapWidth,
    this.lineOffset,
    this.lineOpacity,
    this.linePattern,
    this.lineWidth,
  });

  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;

  /// The display of lines when joining.
  LineJoin? lineJoin;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? lineSortKey;

  /// Blur applied to the line, in pixels.
  double? lineBlur;

  /// The color with which the line will be drawn.
  int? lineColor;

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap.
  double? lineGapWidth;

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset.
  double? lineOffset;

  /// The opacity at which the line will be drawn.
  double? lineOpacity;

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? linePattern;

  /// Stroke thickness.
  double? lineWidth;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['geometry'] = geometry;
    pigeonMap['lineJoin'] = lineJoin?.index;
    pigeonMap['lineSortKey'] = lineSortKey;
    pigeonMap['lineBlur'] = lineBlur;
    pigeonMap['lineColor'] = lineColor;
    pigeonMap['lineGapWidth'] = lineGapWidth;
    pigeonMap['lineOffset'] = lineOffset;
    pigeonMap['lineOpacity'] = lineOpacity;
    pigeonMap['linePattern'] = linePattern;
    pigeonMap['lineWidth'] = lineWidth;
    return pigeonMap;
  }

  static PolylineAnnotationOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return PolylineAnnotationOptions(
      geometry: (pigeonMap['geometry'] as Map<Object?, Object?>?)
          ?.cast<String?, Object?>(),
      lineJoin: pigeonMap['lineJoin'] != null
          ? LineJoin.values[pigeonMap['lineJoin']! as int]
          : null,
      lineSortKey: pigeonMap['lineSortKey'] as double?,
      lineBlur: pigeonMap['lineBlur'] as double?,
      lineColor: pigeonMap['lineColor'] as int?,
      lineGapWidth: pigeonMap['lineGapWidth'] as double?,
      lineOffset: pigeonMap['lineOffset'] as double?,
      lineOpacity: pigeonMap['lineOpacity'] as double?,
      linePattern: pigeonMap['linePattern'] as String?,
      lineWidth: pigeonMap['lineWidth'] as double?,
    );
  }
}

class _OnPolylineAnnotationClickListenerCodec extends StandardMessageCodec {
  const _OnPolylineAnnotationClickListenerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is PolylineAnnotation) {
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
        return PolylineAnnotation.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class OnPolylineAnnotationClickListener {
  static const MessageCodec<Object?> codec =
      _OnPolylineAnnotationClickListenerCodec();

  void onPolylineAnnotationClick(PolylineAnnotation annotation);
  static void setup(OnPolylineAnnotationClickListener? api,
      {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.OnPolylineAnnotationClickListener.onPolylineAnnotationClick',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.OnPolylineAnnotationClickListener.onPolylineAnnotationClick was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final PolylineAnnotation? arg_annotation =
              (args[0] as PolylineAnnotation?);
          assert(arg_annotation != null,
              'Argument for dev.flutter.pigeon.OnPolylineAnnotationClickListener.onPolylineAnnotationClick was null, expected non-null PolylineAnnotation.');
          api.onPolylineAnnotationClick(arg_annotation!);
          return;
        });
      }
    }
  }
}

class __PolylineAnnotationMessagerCodec extends StandardMessageCodec {
  const __PolylineAnnotationMessagerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is PolylineAnnotation) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is PolylineAnnotationOptions) {
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
        return PolylineAnnotation.decode(readValue(buffer)!);

      case 129:
        return PolylineAnnotationOptions.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class _PolylineAnnotationMessager {
  /// Constructor for [_PolylineAnnotationMessager].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  _PolylineAnnotationMessager({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec =
      __PolylineAnnotationMessagerCodec();

  Future<PolylineAnnotation> create(String arg_managerId,
      PolylineAnnotationOptions arg_annotationOption) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.create', codec,
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
      return (replyMap['result'] as PolylineAnnotation?)!;
    }
  }

  Future<List<PolylineAnnotation?>> createMulti(String arg_managerId,
      List<PolylineAnnotationOptions?> arg_annotationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.createMulti', codec,
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
      return (replyMap['result'] as List<Object?>?)!
          .cast<PolylineAnnotation?>();
    }
  }

  Future<void> update(
      String arg_managerId, PolylineAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.update', codec,
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
      String arg_managerId, PolylineAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.delete', codec,
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
        'dev.flutter.pigeon._PolylineAnnotationMessager.deleteAll', codec,
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

  Future<void> setLineCap(String arg_managerId, LineCap arg_lineCap) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.setLineCap', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_lineCap.index])
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

  Future<int?> getLineCap(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.getLineCap', codec,
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

  Future<void> setLineMiterLimit(
      String arg_managerId, double arg_lineMiterLimit) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.setLineMiterLimit',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_lineMiterLimit])
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

  Future<double?> getLineMiterLimit(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.getLineMiterLimit',
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
      return (replyMap['result'] as double?);
    }
  }

  Future<void> setLineRoundLimit(
      String arg_managerId, double arg_lineRoundLimit) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.setLineRoundLimit',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_lineRoundLimit])
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

  Future<double?> getLineRoundLimit(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.getLineRoundLimit',
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
      return (replyMap['result'] as double?);
    }
  }

  Future<void> setLineDasharray(
      String arg_managerId, List<double?> arg_lineDasharray) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.setLineDasharray',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_lineDasharray])
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

  Future<List<double?>?> getLineDasharray(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.getLineDasharray',
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

  Future<void> setLineTranslate(
      String arg_managerId, List<double?> arg_lineTranslate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.setLineTranslate',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_lineTranslate])
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

  Future<List<double?>?> getLineTranslate(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.getLineTranslate',
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

  Future<void> setLineTranslateAnchor(
      String arg_managerId, LineTranslateAnchor arg_lineTranslateAnchor) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.setLineTranslateAnchor',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
            .send(<Object?>[arg_managerId, arg_lineTranslateAnchor.index])
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

  Future<int?> getLineTranslateAnchor(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.getLineTranslateAnchor',
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

  Future<void> setLineTrimOffset(
      String arg_managerId, List<double?> arg_lineTrimOffset) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.setLineTrimOffset',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_lineTrimOffset])
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

  Future<List<double?>?> getLineTrimOffset(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolylineAnnotationMessager.getLineTrimOffset',
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
}
