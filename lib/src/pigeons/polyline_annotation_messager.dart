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
    return <Object?>[
      id,
      geometry,
      lineJoin?.index,
      lineSortKey,
      lineBlur,
      lineColor,
      lineGapWidth,
      lineOffset,
      lineOpacity,
      linePattern,
      lineWidth,
    ];
  }

  static PolylineAnnotation decode(Object result) {
    result as List<Object?>;
    return PolylineAnnotation(
      id: result[0]! as String,
      geometry: (result[1] as Map<Object?, Object?>?)?.cast<String?, Object?>(),
      lineJoin: result[2] != null ? LineJoin.values[result[2]! as int] : null,
      lineSortKey: result[3] as double?,
      lineBlur: result[4] as double?,
      lineColor: result[5] as int?,
      lineGapWidth: result[6] as double?,
      lineOffset: result[7] as double?,
      lineOpacity: result[8] as double?,
      linePattern: result[9] as String?,
      lineWidth: result[10] as double?,
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
    return <Object?>[
      geometry,
      lineJoin?.index,
      lineSortKey,
      lineBlur,
      lineColor,
      lineGapWidth,
      lineOffset,
      lineOpacity,
      linePattern,
      lineWidth,
    ];
  }

  static PolylineAnnotationOptions decode(Object result) {
    result as List<Object?>;
    return PolylineAnnotationOptions(
      geometry: (result[0] as Map<Object?, Object?>?)?.cast<String?, Object?>(),
      lineJoin: result[1] != null ? LineJoin.values[result[1]! as int] : null,
      lineSortKey: result[2] as double?,
      lineBlur: result[3] as double?,
      lineColor: result[4] as int?,
      lineGapWidth: result[5] as double?,
      lineOffset: result[6] as double?,
      lineOpacity: result[7] as double?,
      linePattern: result[8] as String?,
      lineWidth: result[9] as double?,
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
          'dev.flutter.pigeon.mapbox_maps_flutter.OnPolylineAnnotationClickListener.onPolylineAnnotationClick',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.OnPolylineAnnotationClickListener.onPolylineAnnotationClick was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final PolylineAnnotation? arg_annotation =
              (args[0] as PolylineAnnotation?);
          assert(arg_annotation != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.OnPolylineAnnotationClickListener.onPolylineAnnotationClick was null, expected non-null PolylineAnnotation.');
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
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.create',
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
      return (replyList[0] as PolylineAnnotation?)!;
    }
  }

  Future<List<PolylineAnnotation?>> createMulti(String arg_managerId,
      List<PolylineAnnotationOptions?> arg_annotationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.createMulti',
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
      return (replyList[0] as List<Object?>?)!.cast<PolylineAnnotation?>();
    }
  }

  Future<void> update(
      String arg_managerId, PolylineAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.update',
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
      String arg_managerId, PolylineAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.delete',
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
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.deleteAll',
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

  Future<void> setLineCap(String arg_managerId, LineCap arg_lineCap) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.setLineCap',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
        .send(<Object?>[arg_managerId, arg_lineCap.index]) as List<Object?>?;
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

  Future<int?> getLineCap(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.getLineCap',
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

  Future<void> setLineMiterLimit(
      String arg_managerId, double arg_lineMiterLimit) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.setLineMiterLimit',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
        .send(<Object?>[arg_managerId, arg_lineMiterLimit]) as List<Object?>?;
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

  Future<double?> getLineMiterLimit(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.getLineMiterLimit',
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

  Future<void> setLineRoundLimit(
      String arg_managerId, double arg_lineRoundLimit) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.setLineRoundLimit',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
        .send(<Object?>[arg_managerId, arg_lineRoundLimit]) as List<Object?>?;
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

  Future<double?> getLineRoundLimit(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.getLineRoundLimit',
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

  Future<void> setLineDasharray(
      String arg_managerId, List<double?> arg_lineDasharray) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.setLineDasharray',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
        .send(<Object?>[arg_managerId, arg_lineDasharray]) as List<Object?>?;
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

  Future<List<double?>?> getLineDasharray(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.getLineDasharray',
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

  Future<void> setLineTranslate(
      String arg_managerId, List<double?> arg_lineTranslate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.setLineTranslate',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
        .send(<Object?>[arg_managerId, arg_lineTranslate]) as List<Object?>?;
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

  Future<List<double?>?> getLineTranslate(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.getLineTranslate',
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

  Future<void> setLineTranslateAnchor(
      String arg_managerId, LineTranslateAnchor arg_lineTranslateAnchor) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.setLineTranslateAnchor',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
            .send(<Object?>[arg_managerId, arg_lineTranslateAnchor.index])
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

  Future<int?> getLineTranslateAnchor(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.getLineTranslateAnchor',
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

  Future<void> setLineTrimOffset(
      String arg_managerId, List<double?> arg_lineTrimOffset) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.setLineTrimOffset',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
        .send(<Object?>[arg_managerId, arg_lineTrimOffset]) as List<Object?>?;
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

  Future<List<double?>?> getLineTrimOffset(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolylineAnnotationMessager.getLineTrimOffset',
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
}
