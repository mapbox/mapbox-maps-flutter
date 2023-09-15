part of mapbox_maps_flutter;

/// Controls the frame of reference for `fill-translate`.
enum FillTranslateAnchor {
  /// The fill is translated relative to the map.
  MAP,

  /// The fill is translated relative to the viewport.
  VIEWPORT,
}

class PolygonAnnotation {
  PolygonAnnotation({
    required this.id,
    this.geometry,
    this.fillSortKey,
    this.fillColor,
    this.fillOpacity,
    this.fillOutlineColor,
    this.fillPattern,
  });

  /// The id for annotation
  String id;

  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? fillSortKey;

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used.
  int? fillColor;

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used.
  double? fillOpacity;

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  int? fillOutlineColor;

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? fillPattern;

  Object encode() {
    return <Object?>[
      id,
      geometry,
      fillSortKey,
      fillColor,
      fillOpacity,
      fillOutlineColor,
      fillPattern,
    ];
  }

  static PolygonAnnotation decode(Object result) {
    result as List<Object?>;
    return PolygonAnnotation(
      id: result[0]! as String,
      geometry: (result[1] as Map<Object?, Object?>?)?.cast<String?, Object?>(),
      fillSortKey: result[2] as double?,
      fillColor: result[3] as int?,
      fillOpacity: result[4] as double?,
      fillOutlineColor: result[5] as int?,
      fillPattern: result[6] as String?,
    );
  }
}

class PolygonAnnotationOptions {
  PolygonAnnotationOptions({
    this.geometry,
    this.fillSortKey,
    this.fillColor,
    this.fillOpacity,
    this.fillOutlineColor,
    this.fillPattern,
  });

  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? fillSortKey;

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used.
  int? fillColor;

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used.
  double? fillOpacity;

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  int? fillOutlineColor;

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? fillPattern;

  Object encode() {
    return <Object?>[
      geometry,
      fillSortKey,
      fillColor,
      fillOpacity,
      fillOutlineColor,
      fillPattern,
    ];
  }

  static PolygonAnnotationOptions decode(Object result) {
    result as List<Object?>;
    return PolygonAnnotationOptions(
      geometry: (result[0] as Map<Object?, Object?>?)?.cast<String?, Object?>(),
      fillSortKey: result[1] as double?,
      fillColor: result[2] as int?,
      fillOpacity: result[3] as double?,
      fillOutlineColor: result[4] as int?,
      fillPattern: result[5] as String?,
    );
  }
}

class _OnPolygonAnnotationClickListenerCodec extends StandardMessageCodec {
  const _OnPolygonAnnotationClickListenerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is PolygonAnnotation) {
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
        return PolygonAnnotation.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

abstract class OnPolygonAnnotationClickListener {
  static const MessageCodec<Object?> codec =
      _OnPolygonAnnotationClickListenerCodec();

  void onPolygonAnnotationClick(PolygonAnnotation annotation);

  static void setup(OnPolygonAnnotationClickListener? api,
      {BinaryMessenger? binaryMessenger}) {
    {
      final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
          'dev.flutter.pigeon.mapbox_maps_flutter.OnPolygonAnnotationClickListener.onPolygonAnnotationClick',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.OnPolygonAnnotationClickListener.onPolygonAnnotationClick was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final PolygonAnnotation? arg_annotation =
              (args[0] as PolygonAnnotation?);
          assert(arg_annotation != null,
              'Argument for dev.flutter.pigeon.mapbox_maps_flutter.OnPolygonAnnotationClickListener.onPolygonAnnotationClick was null, expected non-null PolygonAnnotation.');
          api.onPolygonAnnotationClick(arg_annotation!);
          return;
        });
      }
    }
  }
}

class __PolygonAnnotationMessagerCodec extends StandardMessageCodec {
  const __PolygonAnnotationMessagerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is PolygonAnnotation) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is PolygonAnnotationOptions) {
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
        return PolygonAnnotation.decode(readValue(buffer)!);
      case 129:
        return PolygonAnnotationOptions.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class _PolygonAnnotationMessager {
  /// Constructor for [_PolygonAnnotationMessager].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  _PolygonAnnotationMessager({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = __PolygonAnnotationMessagerCodec();

  Future<PolygonAnnotation> create(String arg_managerId,
      PolygonAnnotationOptions arg_annotationOption) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolygonAnnotationMessager.create',
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
      return (replyList[0] as PolygonAnnotation?)!;
    }
  }

  Future<List<PolygonAnnotation?>> createMulti(String arg_managerId,
      List<PolygonAnnotationOptions?> arg_annotationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolygonAnnotationMessager.createMulti',
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
      return (replyList[0] as List<Object?>?)!.cast<PolygonAnnotation?>();
    }
  }

  Future<void> update(
      String arg_managerId, PolygonAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolygonAnnotationMessager.update',
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
      String arg_managerId, PolygonAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolygonAnnotationMessager.delete',
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
        'dev.flutter.pigeon.mapbox_maps_flutter._PolygonAnnotationMessager.deleteAll',
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

  Future<void> setFillAntialias(
      String arg_managerId, bool arg_fillAntialias) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolygonAnnotationMessager.setFillAntialias',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
        .send(<Object?>[arg_managerId, arg_fillAntialias]) as List<Object?>?;
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

  Future<bool?> getFillAntialias(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolygonAnnotationMessager.getFillAntialias',
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
      return (replyList[0] as bool?);
    }
  }

  Future<void> setFillTranslate(
      String arg_managerId, List<double?> arg_fillTranslate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolygonAnnotationMessager.setFillTranslate',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
        .send(<Object?>[arg_managerId, arg_fillTranslate]) as List<Object?>?;
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

  Future<List<double?>?> getFillTranslate(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolygonAnnotationMessager.getFillTranslate',
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

  Future<void> setFillTranslateAnchor(
      String arg_managerId, FillTranslateAnchor arg_fillTranslateAnchor) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolygonAnnotationMessager.setFillTranslateAnchor',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
            .send(<Object?>[arg_managerId, arg_fillTranslateAnchor.index])
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

  Future<int?> getFillTranslateAnchor(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.mapbox_maps_flutter._PolygonAnnotationMessager.getFillTranslateAnchor',
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
