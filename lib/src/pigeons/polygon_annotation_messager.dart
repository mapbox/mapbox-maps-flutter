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
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['id'] = id;
    pigeonMap['geometry'] = geometry;
    pigeonMap['fillSortKey'] = fillSortKey;
    pigeonMap['fillColor'] = fillColor;
    pigeonMap['fillOpacity'] = fillOpacity;
    pigeonMap['fillOutlineColor'] = fillOutlineColor;
    pigeonMap['fillPattern'] = fillPattern;
    return pigeonMap;
  }

  static PolygonAnnotation decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return PolygonAnnotation(
      id: pigeonMap['id']! as String,
      geometry: (pigeonMap['geometry'] as Map<Object?, Object?>?)
          ?.cast<String?, Object?>(),
      fillSortKey: pigeonMap['fillSortKey'] as double?,
      fillColor: pigeonMap['fillColor'] as int?,
      fillOpacity: pigeonMap['fillOpacity'] as double?,
      fillOutlineColor: pigeonMap['fillOutlineColor'] as int?,
      fillPattern: pigeonMap['fillPattern'] as String?,
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
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['geometry'] = geometry;
    pigeonMap['fillSortKey'] = fillSortKey;
    pigeonMap['fillColor'] = fillColor;
    pigeonMap['fillOpacity'] = fillOpacity;
    pigeonMap['fillOutlineColor'] = fillOutlineColor;
    pigeonMap['fillPattern'] = fillPattern;
    return pigeonMap;
  }

  static PolygonAnnotationOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return PolygonAnnotationOptions(
      geometry: (pigeonMap['geometry'] as Map<Object?, Object?>?)
          ?.cast<String?, Object?>(),
      fillSortKey: pigeonMap['fillSortKey'] as double?,
      fillColor: pigeonMap['fillColor'] as int?,
      fillOpacity: pigeonMap['fillOpacity'] as double?,
      fillOutlineColor: pigeonMap['fillOutlineColor'] as int?,
      fillPattern: pigeonMap['fillPattern'] as String?,
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
          'dev.flutter.pigeon.OnPolygonAnnotationClickListener.onPolygonAnnotationClick',
          codec,
          binaryMessenger: binaryMessenger);
      if (api == null) {
        channel.setMessageHandler(null);
      } else {
        channel.setMessageHandler((Object? message) async {
          assert(message != null,
              'Argument for dev.flutter.pigeon.OnPolygonAnnotationClickListener.onPolygonAnnotationClick was null.');
          final List<Object?> args = (message as List<Object?>?)!;
          final PolygonAnnotation? arg_annotation =
              (args[0] as PolygonAnnotation?);
          assert(arg_annotation != null,
              'Argument for dev.flutter.pigeon.OnPolygonAnnotationClickListener.onPolygonAnnotationClick was null, expected non-null PolygonAnnotation.');
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
        'dev.flutter.pigeon._PolygonAnnotationMessager.create', codec,
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
      return (replyMap['result'] as PolygonAnnotation?)!;
    }
  }

  Future<List<PolygonAnnotation?>> createMulti(String arg_managerId,
      List<PolygonAnnotationOptions?> arg_annotationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolygonAnnotationMessager.createMulti', codec,
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
      return (replyMap['result'] as List<Object?>?)!.cast<PolygonAnnotation?>();
    }
  }

  Future<void> update(
      String arg_managerId, PolygonAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolygonAnnotationMessager.update', codec,
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
      String arg_managerId, PolygonAnnotation arg_annotation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolygonAnnotationMessager.delete', codec,
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
        'dev.flutter.pigeon._PolygonAnnotationMessager.deleteAll', codec,
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

  Future<void> setFillAntialias(
      String arg_managerId, bool arg_fillAntialias) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolygonAnnotationMessager.setFillAntialias', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_fillAntialias])
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

  Future<bool?> getFillAntialias(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolygonAnnotationMessager.getFillAntialias', codec,
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
      return (replyMap['result'] as bool?);
    }
  }

  Future<void> setFillTranslate(
      String arg_managerId, List<double?> arg_fillTranslate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolygonAnnotationMessager.setFillTranslate', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_managerId, arg_fillTranslate])
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

  Future<List<double?>?> getFillTranslate(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolygonAnnotationMessager.getFillTranslate', codec,
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

  Future<void> setFillTranslateAnchor(
      String arg_managerId, FillTranslateAnchor arg_fillTranslateAnchor) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolygonAnnotationMessager.setFillTranslateAnchor',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
            .send(<Object?>[arg_managerId, arg_fillTranslateAnchor.index])
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

  Future<int?> getFillTranslateAnchor(String arg_managerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._PolygonAnnotationMessager.getFillTranslateAnchor',
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
