// Autogenerated from Pigeon (v25.2.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import, no_leading_underscores_for_local_identifiers

part of mapbox_maps_flutter;

enum _ViewportTransitionType {
  defaultTransition,
  fly,
  easing,
}

enum _FollowPuckViewportStateBearing {
  constant,
  heading,
  course,
}

enum _ViewportStateType {
  idle,
  overview,
  followPuck,
  styleDefault,
  camera,
}

class _DefaultViewportTransitionOptions {
  _DefaultViewportTransitionOptions({
    required this.maxDurationMs,
  });

  int maxDurationMs;

  List<Object?> _toList() {
    return <Object?>[
      maxDurationMs,
    ];
  }

  Object encode() {
    return _toList();
  }

  static _DefaultViewportTransitionOptions decode(Object result) {
    result as List<Object?>;
    return _DefaultViewportTransitionOptions(
      maxDurationMs: result[0]! as int,
    );
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is! _DefaultViewportTransitionOptions ||
        other.runtimeType != runtimeType) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return maxDurationMs == other.maxDurationMs;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hashAll(_toList());
}

class _FlyViewportTransitionOptions {
  _FlyViewportTransitionOptions({
    this.durationMs,
  });

  int? durationMs;

  List<Object?> _toList() {
    return <Object?>[
      durationMs,
    ];
  }

  Object encode() {
    return _toList();
  }

  static _FlyViewportTransitionOptions decode(Object result) {
    result as List<Object?>;
    return _FlyViewportTransitionOptions(
      durationMs: result[0] as int?,
    );
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is! _FlyViewportTransitionOptions ||
        other.runtimeType != runtimeType) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return durationMs == other.durationMs;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hashAll(_toList());
}

class _EasingViewportTransitionOptions {
  _EasingViewportTransitionOptions({
    required this.durationMs,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  int durationMs;

  double a;

  double b;

  double c;

  double d;

  List<Object?> _toList() {
    return <Object?>[
      durationMs,
      a,
      b,
      c,
      d,
    ];
  }

  Object encode() {
    return _toList();
  }

  static _EasingViewportTransitionOptions decode(Object result) {
    result as List<Object?>;
    return _EasingViewportTransitionOptions(
      durationMs: result[0]! as int,
      a: result[1]! as double,
      b: result[2]! as double,
      c: result[3]! as double,
      d: result[4]! as double,
    );
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is! _EasingViewportTransitionOptions ||
        other.runtimeType != runtimeType) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return durationMs == other.durationMs &&
        a == other.a &&
        b == other.b &&
        c == other.c &&
        d == other.d;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hashAll(_toList());
}

class _ViewportTransitionStorage {
  _ViewportTransitionStorage({
    required this.type,
    this.options,
  });

  _ViewportTransitionType type;

  Object? options;

  List<Object?> _toList() {
    return <Object?>[
      type,
      options,
    ];
  }

  Object encode() {
    return _toList();
  }

  static _ViewportTransitionStorage decode(Object result) {
    result as List<Object?>;
    return _ViewportTransitionStorage(
      type: result[0]! as _ViewportTransitionType,
      options: result[1],
    );
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is! _ViewportTransitionStorage ||
        other.runtimeType != runtimeType) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return type == other.type && options == other.options;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hashAll(_toList());
}

class _OverviewViewportStateOptions {
  _OverviewViewportStateOptions({
    required this.geometry,
    required this.geometryPadding,
    this.bearing,
    this.pitch,
    this.padding,
    this.maxZoom,
    this.offset,
    required this.animationDurationMs,
  });

  String geometry;

  MbxEdgeInsets geometryPadding;

  double? bearing;

  double? pitch;

  MbxEdgeInsets? padding;

  double? maxZoom;

  ScreenCoordinate? offset;

  int animationDurationMs;

  List<Object?> _toList() {
    return <Object?>[
      geometry,
      geometryPadding,
      bearing,
      pitch,
      padding,
      maxZoom,
      offset,
      animationDurationMs,
    ];
  }

  Object encode() {
    return _toList();
  }

  static _OverviewViewportStateOptions decode(Object result) {
    result as List<Object?>;
    return _OverviewViewportStateOptions(
      geometry: result[0]! as String,
      geometryPadding: result[1]! as MbxEdgeInsets,
      bearing: result[2] as double?,
      pitch: result[3] as double?,
      padding: result[4] as MbxEdgeInsets?,
      maxZoom: result[5] as double?,
      offset: result[6] as ScreenCoordinate?,
      animationDurationMs: result[7]! as int,
    );
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is! _OverviewViewportStateOptions ||
        other.runtimeType != runtimeType) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return geometry == other.geometry &&
        geometryPadding == other.geometryPadding &&
        bearing == other.bearing &&
        pitch == other.pitch &&
        padding == other.padding &&
        maxZoom == other.maxZoom &&
        offset == other.offset &&
        animationDurationMs == other.animationDurationMs;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hashAll(_toList());
}

class _FollowPuckViewportStateOptions {
  _FollowPuckViewportStateOptions({
    this.zoom,
    this.bearingValue,
    this.bearing,
    this.pitch,
  });

  double? zoom;

  double? bearingValue;

  _FollowPuckViewportStateBearing? bearing;

  double? pitch;

  List<Object?> _toList() {
    return <Object?>[
      zoom,
      bearingValue,
      bearing,
      pitch,
    ];
  }

  Object encode() {
    return _toList();
  }

  static _FollowPuckViewportStateOptions decode(Object result) {
    result as List<Object?>;
    return _FollowPuckViewportStateOptions(
      zoom: result[0] as double?,
      bearingValue: result[1] as double?,
      bearing: result[2] as _FollowPuckViewportStateBearing?,
      pitch: result[3] as double?,
    );
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is! _FollowPuckViewportStateOptions ||
        other.runtimeType != runtimeType) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return zoom == other.zoom &&
        bearingValue == other.bearingValue &&
        bearing == other.bearing &&
        pitch == other.pitch;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hashAll(_toList());
}

class _ViewportStateStorage {
  _ViewportStateStorage({
    required this.type,
    this.options,
  });

  _ViewportStateType type;

  Object? options;

  List<Object?> _toList() {
    return <Object?>[
      type,
      options,
    ];
  }

  Object encode() {
    return _toList();
  }

  static _ViewportStateStorage decode(Object result) {
    result as List<Object?>;
    return _ViewportStateStorage(
      type: result[0]! as _ViewportStateType,
      options: result[1],
    );
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is! _ViewportStateStorage || other.runtimeType != runtimeType) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return type == other.type && options == other.options;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hashAll(_toList());
}

class ViewportInternal_PigeonCodec extends StandardMessageCodec {
  const ViewportInternal_PigeonCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is int) {
      buffer.putUint8(4);
      buffer.putInt64(value);
    } else if (value is _ViewportTransitionType) {
      buffer.putUint8(129);
      writeValue(buffer, value.index);
    } else if (value is _FollowPuckViewportStateBearing) {
      buffer.putUint8(130);
      writeValue(buffer, value.index);
    } else if (value is _ViewportStateType) {
      buffer.putUint8(131);
      writeValue(buffer, value.index);
    } else if (value is MbxEdgeInsets) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is CameraOptions) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else if (value is Point) {
      buffer.putUint8(135);
      writeValue(buffer, value.encode());
    } else if (value is _DefaultViewportTransitionOptions) {
      buffer.putUint8(136);
      writeValue(buffer, value.encode());
    } else if (value is _FlyViewportTransitionOptions) {
      buffer.putUint8(137);
      writeValue(buffer, value.encode());
    } else if (value is _EasingViewportTransitionOptions) {
      buffer.putUint8(138);
      writeValue(buffer, value.encode());
    } else if (value is _ViewportTransitionStorage) {
      buffer.putUint8(139);
      writeValue(buffer, value.encode());
    } else if (value is _OverviewViewportStateOptions) {
      buffer.putUint8(140);
      writeValue(buffer, value.encode());
    } else if (value is _FollowPuckViewportStateOptions) {
      buffer.putUint8(141);
      writeValue(buffer, value.encode());
    } else if (value is _ViewportStateStorage) {
      buffer.putUint8(142);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 129:
        final int? value = readValue(buffer) as int?;
        return value == null ? null : _ViewportTransitionType.values[value];
      case 130:
        final int? value = readValue(buffer) as int?;
        return value == null
            ? null
            : _FollowPuckViewportStateBearing.values[value];
      case 131:
        final int? value = readValue(buffer) as int?;
        return value == null ? null : _ViewportStateType.values[value];
      case 132:
        return MbxEdgeInsets.decode(readValue(buffer)!);
      case 133:
        return ScreenCoordinate.decode(readValue(buffer)!);
      case 134:
        return CameraOptions.decode(readValue(buffer)!);
      case 135:
        return Point.decode(readValue(buffer)!);
      case 136:
        return _DefaultViewportTransitionOptions.decode(readValue(buffer)!);
      case 137:
        return _FlyViewportTransitionOptions.decode(readValue(buffer)!);
      case 138:
        return _EasingViewportTransitionOptions.decode(readValue(buffer)!);
      case 139:
        return _ViewportTransitionStorage.decode(readValue(buffer)!);
      case 140:
        return _OverviewViewportStateOptions.decode(readValue(buffer)!);
      case 141:
        return _FollowPuckViewportStateOptions.decode(readValue(buffer)!);
      case 142:
        return _ViewportStateStorage.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class _ViewportMessenger {
  /// Constructor for [_ViewportMessenger].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  _ViewportMessenger(
      {BinaryMessenger? binaryMessenger, String messageChannelSuffix = ''})
      : pigeonVar_binaryMessenger = binaryMessenger,
        pigeonVar_messageChannelSuffix =
            messageChannelSuffix.isNotEmpty ? '.$messageChannelSuffix' : '';
  final BinaryMessenger? pigeonVar_binaryMessenger;

  static const MessageCodec<Object?> pigeonChannelCodec =
      ViewportInternal_PigeonCodec();

  final String pigeonVar_messageChannelSuffix;

  Future<bool> transition(_ViewportStateStorage stateStorage,
      _ViewportTransitionStorage? transitionStorage) async {
    final String pigeonVar_channelName =
        'dev.flutter.pigeon.mapbox_maps_flutter._ViewportMessenger.transition$pigeonVar_messageChannelSuffix';
    final BasicMessageChannel<Object?> pigeonVar_channel =
        BasicMessageChannel<Object?>(
      pigeonVar_channelName,
      pigeonChannelCodec,
      binaryMessenger: pigeonVar_binaryMessenger,
    );
    final Future<Object?> pigeonVar_sendFuture =
        pigeonVar_channel.send(<Object?>[stateStorage, transitionStorage]);
    final List<Object?>? pigeonVar_replyList =
        await pigeonVar_sendFuture as List<Object?>?;
    if (pigeonVar_replyList == null) {
      throw _createConnectionError(pigeonVar_channelName);
    } else if (pigeonVar_replyList.length > 1) {
      throw PlatformException(
        code: pigeonVar_replyList[0]! as String,
        message: pigeonVar_replyList[1] as String?,
        details: pigeonVar_replyList[2],
      );
    } else if (pigeonVar_replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (pigeonVar_replyList[0] as bool?)!;
    }
  }
}
