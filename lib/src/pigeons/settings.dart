part of mapbox_maps_flutter;

enum OrnamentPosition {
  TOP_LEFT,
  TOP_RIGHT,
  BOTTOM_RIGHT,
  BOTTOM_LEFT,
}

/// Configures the directions in which the map is allowed to move during a scroll gesture.
enum ScrollMode {
  /// The map may only move horizontally.
  HORIZONTAL,

  /// The map may only move vertically.
  VERTICAL,

  /// The map may move both horizontally and vertically.
  HORIZONTAL_AND_VERTICAL,
}

/// The enum controls how the puck is oriented
enum PuckBearingSource {
  /// Orients the puck to match the direction in which the device is facing.
  HEADING,

  /// Orients the puck to match the direction in which the device is moving.
  COURSE,
}

/// Gesture configuration allows to control the user touch interaction.
class GesturesSettings {
  GesturesSettings({
    this.rotateEnabled,
    this.pinchToZoomEnabled,
    this.scrollEnabled,
    this.simultaneousRotateAndPinchToZoomEnabled,
    this.pitchEnabled,
    this.scrollMode = ScrollMode.HORIZONTAL_AND_VERTICAL,
    this.doubleTapToZoomInEnabled,
    this.doubleTouchToZoomOutEnabled,
    this.quickZoomEnabled,
    this.focalPoint,
    this.pinchToZoomDecelerationEnabled,
    this.rotateDecelerationEnabled,
    this.scrollDecelerationEnabled,
    this.increaseRotateThresholdWhenPinchingToZoom,
    this.increasePinchToZoomThresholdWhenRotating,
    this.zoomAnimationAmount,
    this.pinchPanEnabled,
  });

  /// Whether the rotate gesture is enabled.
  bool? rotateEnabled;

  /// Whether the pinch to zoom gesture is enabled.
  bool? pinchToZoomEnabled;

  /// Whether the single-touch scroll gesture is enabled.
  bool? scrollEnabled;

  /// Whether rotation is enabled for the pinch to zoom gesture.
  bool? simultaneousRotateAndPinchToZoomEnabled;

  /// Whether the pitch gesture is enabled.
  bool? pitchEnabled;

  /// Configures the directions in which the map is allowed to move during a scroll gesture.
  ScrollMode? scrollMode;

  /// Whether double tapping the map with one touch results in a zoom-in animation.
  bool? doubleTapToZoomInEnabled;

  /// Whether single tapping the map with two touches results in a zoom-out animation.
  bool? doubleTouchToZoomOutEnabled;

  /// Whether the quick zoom gesture is enabled.
  bool? quickZoomEnabled;

  /// By default, gestures rotate and zoom around the center of the gesture. Set this property to rotate and zoom around a fixed point instead.
  ScreenCoordinate? focalPoint;

  /// Whether a deceleration animation following a pinch-to-zoom gesture is enabled. True by default.
  bool? pinchToZoomDecelerationEnabled;

  /// Whether a deceleration animation following a rotate gesture is enabled. True by default.
  bool? rotateDecelerationEnabled;

  /// Whether a deceleration animation following a scroll gesture is enabled. True by default.
  bool? scrollDecelerationEnabled;

  /// Whether rotate threshold increases when pinching to zoom. true by default.
  bool? increaseRotateThresholdWhenPinchingToZoom;

  /// Whether pinch to zoom threshold increases when rotating. true by default.
  bool? increasePinchToZoomThresholdWhenRotating;

  /// The amount by which the zoom level increases or decreases during a double-tap-to-zoom-in or double-touch-to-zoom-out gesture. 1.0 by default. Must be positive.
  double? zoomAnimationAmount;

  /// Whether pan is enabled for the pinch gesture.
  bool? pinchPanEnabled;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['rotateEnabled'] = rotateEnabled;
    pigeonMap['pinchToZoomEnabled'] = pinchToZoomEnabled;
    pigeonMap['scrollEnabled'] = scrollEnabled;
    pigeonMap['simultaneousRotateAndPinchToZoomEnabled'] =
        simultaneousRotateAndPinchToZoomEnabled;
    pigeonMap['pitchEnabled'] = pitchEnabled;
    pigeonMap['scrollMode'] = scrollMode?.index;
    pigeonMap['doubleTapToZoomInEnabled'] = doubleTapToZoomInEnabled;
    pigeonMap['doubleTouchToZoomOutEnabled'] = doubleTouchToZoomOutEnabled;
    pigeonMap['quickZoomEnabled'] = quickZoomEnabled;
    pigeonMap['focalPoint'] = focalPoint?.encode();
    pigeonMap['pinchToZoomDecelerationEnabled'] =
        pinchToZoomDecelerationEnabled;
    pigeonMap['rotateDecelerationEnabled'] = rotateDecelerationEnabled;
    pigeonMap['scrollDecelerationEnabled'] = scrollDecelerationEnabled;
    pigeonMap['increaseRotateThresholdWhenPinchingToZoom'] =
        increaseRotateThresholdWhenPinchingToZoom;
    pigeonMap['increasePinchToZoomThresholdWhenRotating'] =
        increasePinchToZoomThresholdWhenRotating;
    pigeonMap['zoomAnimationAmount'] = zoomAnimationAmount;
    pigeonMap['pinchPanEnabled'] = pinchPanEnabled;
    return pigeonMap;
  }

  static GesturesSettings decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return GesturesSettings(
      rotateEnabled: pigeonMap['rotateEnabled'] as bool?,
      pinchToZoomEnabled: pigeonMap['pinchToZoomEnabled'] as bool?,
      scrollEnabled: pigeonMap['scrollEnabled'] as bool?,
      simultaneousRotateAndPinchToZoomEnabled:
          pigeonMap['simultaneousRotateAndPinchToZoomEnabled'] as bool?,
      pitchEnabled: pigeonMap['pitchEnabled'] as bool?,
      scrollMode: pigeonMap['scrollMode'] != null
          ? ScrollMode.values[pigeonMap['scrollMode']! as int]
          : ScrollMode.HORIZONTAL_AND_VERTICAL,
      doubleTapToZoomInEnabled: pigeonMap['doubleTapToZoomInEnabled'] as bool?,
      doubleTouchToZoomOutEnabled:
          pigeonMap['doubleTouchToZoomOutEnabled'] as bool?,
      quickZoomEnabled: pigeonMap['quickZoomEnabled'] as bool?,
      focalPoint: pigeonMap['focalPoint'] != null
          ? ScreenCoordinate.decode(pigeonMap['focalPoint']!)
          : null,
      pinchToZoomDecelerationEnabled:
          pigeonMap['pinchToZoomDecelerationEnabled'] as bool?,
      rotateDecelerationEnabled:
          pigeonMap['rotateDecelerationEnabled'] as bool?,
      scrollDecelerationEnabled:
          pigeonMap['scrollDecelerationEnabled'] as bool?,
      increaseRotateThresholdWhenPinchingToZoom:
          pigeonMap['increaseRotateThresholdWhenPinchingToZoom'] as bool?,
      increasePinchToZoomThresholdWhenRotating:
          pigeonMap['increasePinchToZoomThresholdWhenRotating'] as bool?,
      zoomAnimationAmount: pigeonMap['zoomAnimationAmount'] as double?,
      pinchPanEnabled: pigeonMap['pinchPanEnabled'] as bool?,
    );
  }
}

class LocationPuck2D {
  LocationPuck2D({
    this.topImage,
    this.bearingImage,
    this.shadowImage,
    this.scaleExpression,
  });

  /// Name of image in sprite to use as the top of the location indicator.
  Uint8List? topImage;

  /// Name of image in sprite to use as the middle of the location indicator.
  Uint8List? bearingImage;

  /// Name of image in sprite to use as the background of the location indicator.
  Uint8List? shadowImage;

  /// The scale expression of the images. If defined, it will be applied to all the three images.
  String? scaleExpression;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['topImage'] = topImage;
    pigeonMap['bearingImage'] = bearingImage;
    pigeonMap['shadowImage'] = shadowImage;
    pigeonMap['scaleExpression'] = scaleExpression;
    return pigeonMap;
  }

  static LocationPuck2D decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return LocationPuck2D(
      topImage: pigeonMap['topImage'] as Uint8List?,
      bearingImage: pigeonMap['bearingImage'] as Uint8List?,
      shadowImage: pigeonMap['shadowImage'] as Uint8List?,
      scaleExpression: pigeonMap['scaleExpression'] as String?,
    );
  }
}

class LocationPuck3D {
  LocationPuck3D({
    this.modelUri,
    this.position,
    this.modelOpacity,
    this.modelScale,
    this.modelScaleExpression,
    this.modelTranslation,
    this.modelRotation,
  });

  /// An URL for the model file in gltf format.
  String? modelUri;

  /// The position of the model.
  List<double?>? position;

  /// The opacity of the model.
  double? modelOpacity;

  /// The scale of the model.
  List<double?>? modelScale;

  /// The scale expression of the model, which will overwrite the default scale expression that keeps the model size constant during zoom.
  String? modelScaleExpression;

  /// The translation of the model [lon, lat, z]
  List<double?>? modelTranslation;

  /// The rotation of the model.
  List<double?>? modelRotation;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['modelUri'] = modelUri;
    pigeonMap['position'] = position;
    pigeonMap['modelOpacity'] = modelOpacity;
    pigeonMap['modelScale'] = modelScale;
    pigeonMap['modelScaleExpression'] = modelScaleExpression;
    pigeonMap['modelTranslation'] = modelTranslation;
    pigeonMap['modelRotation'] = modelRotation;
    return pigeonMap;
  }

  static LocationPuck3D decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return LocationPuck3D(
      modelUri: pigeonMap['modelUri'] as String?,
      position: (pigeonMap['position'] as List<Object?>?)?.cast<double?>(),
      modelOpacity: pigeonMap['modelOpacity'] as double?,
      modelScale: (pigeonMap['modelScale'] as List<Object?>?)?.cast<double?>(),
      modelScaleExpression: pigeonMap['modelScaleExpression'] as String?,
      modelTranslation:
          (pigeonMap['modelTranslation'] as List<Object?>?)?.cast<double?>(),
      modelRotation:
          (pigeonMap['modelRotation'] as List<Object?>?)?.cast<double?>(),
    );
  }
}

/// Defines what the customised look of the location puck.
class LocationPuck {
  LocationPuck({
    this.locationPuck2D,
    this.locationPuck3D,
  });

  LocationPuck2D? locationPuck2D;
  LocationPuck3D? locationPuck3D;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['locationPuck2D'] = locationPuck2D?.encode();
    pigeonMap['locationPuck3D'] = locationPuck3D?.encode();
    return pigeonMap;
  }

  static LocationPuck decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return LocationPuck(
      locationPuck2D: pigeonMap['locationPuck2D'] != null
          ? LocationPuck2D.decode(pigeonMap['locationPuck2D']!)
          : null,
      locationPuck3D: pigeonMap['locationPuck3D'] != null
          ? LocationPuck3D.decode(pigeonMap['locationPuck3D']!)
          : null,
    );
  }
}

/// Shows a location puck on the map.
class LocationComponentSettings {
  LocationComponentSettings({
    this.enabled,
    this.pulsingEnabled,
    this.pulsingColor,
    this.pulsingMaxRadius,
    this.showAccuracyRing,
    this.accuracyRingColor,
    this.accuracyRingBorderColor,
    this.layerAbove,
    this.layerBelow,
    this.puckBearingEnabled,
    this.puckBearingSource,
    this.locationPuck,
  });

  /// Whether the user location is visible on the map.
  bool? enabled;

  /// Whether the location puck is pulsing on the map. Works for 2D location puck only.
  bool? pulsingEnabled;

  /// The color of the pulsing circle. Works for 2D location puck only.
  int? pulsingColor;

  /// The maximum radius of the pulsing circle. Works for 2D location puck only. This property is specified in pixels.
  double? pulsingMaxRadius;

  /// Whether show accuracy ring with location puck. Works for 2D location puck only.
  bool? showAccuracyRing;

  /// The color of the accuracy ring. Works for 2D location puck only.
  int? accuracyRingColor;

  /// The color of the accuracy ring border. Works for 2D location puck only.
  int? accuracyRingBorderColor;

  /// Sets the id of the layer that's added above to when placing the component on the map.
  String? layerAbove;

  /// Sets the id of the layer that's added below to when placing the component on the map.
  String? layerBelow;

  /// Whether the puck rotates to track the bearing source.
  bool? puckBearingEnabled;

  /// The enum controls how the puck is oriented
  PuckBearingSource? puckBearingSource;

  /// Defines what the customised look of the location puck.
  LocationPuck? locationPuck;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['enabled'] = enabled;
    pigeonMap['pulsingEnabled'] = pulsingEnabled;
    pigeonMap['pulsingColor'] = pulsingColor;
    pigeonMap['pulsingMaxRadius'] = pulsingMaxRadius;
    pigeonMap['showAccuracyRing'] = showAccuracyRing;
    pigeonMap['accuracyRingColor'] = accuracyRingColor;
    pigeonMap['accuracyRingBorderColor'] = accuracyRingBorderColor;
    pigeonMap['layerAbove'] = layerAbove;
    pigeonMap['layerBelow'] = layerBelow;
    pigeonMap['puckBearingEnabled'] = puckBearingEnabled;
    pigeonMap['puckBearingSource'] = puckBearingSource?.index;
    pigeonMap['locationPuck'] = locationPuck?.encode();
    return pigeonMap;
  }

  static LocationComponentSettings decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return LocationComponentSettings(
      enabled: pigeonMap['enabled'] as bool?,
      pulsingEnabled: pigeonMap['pulsingEnabled'] as bool?,
      pulsingColor: pigeonMap['pulsingColor'] as int?,
      pulsingMaxRadius: pigeonMap['pulsingMaxRadius'] as double?,
      showAccuracyRing: pigeonMap['showAccuracyRing'] as bool?,
      accuracyRingColor: pigeonMap['accuracyRingColor'] as int?,
      accuracyRingBorderColor: pigeonMap['accuracyRingBorderColor'] as int?,
      layerAbove: pigeonMap['layerAbove'] as String?,
      layerBelow: pigeonMap['layerBelow'] as String?,
      puckBearingEnabled: pigeonMap['puckBearingEnabled'] as bool?,
      puckBearingSource: pigeonMap['puckBearingSource'] != null
          ? PuckBearingSource.values[pigeonMap['puckBearingSource']! as int]
          : null,
      locationPuck: pigeonMap['locationPuck'] != null
          ? LocationPuck.decode(pigeonMap['locationPuck']!)
          : null,
    );
  }
}

/// Shows the scale bar on the map.
class ScaleBarSettings {
  ScaleBarSettings({
    this.enabled,
    this.position,
    this.marginLeft,
    this.marginTop,
    this.marginRight,
    this.marginBottom,
    this.textColor,
    this.primaryColor,
    this.secondaryColor,
    this.borderWidth,
    this.height,
    this.textBarMargin,
    this.textBorderWidth,
    this.textSize,
    this.isMetricUnits,
    this.refreshInterval,
    this.showTextBorder,
    this.ratio,
    this.useContinuousRendering,
  });

  /// Whether the scale is visible on the map.
  bool? enabled;

  /// Defines where the scale bar is positioned on the map
  OrnamentPosition? position;

  /// Defines the margin to the left that the scale bar honors. This property is specified in pixels.
  double? marginLeft;

  /// Defines the margin to the top that the scale bar honors. This property is specified in pixels.
  double? marginTop;

  /// Defines the margin to the right that the scale bar honors. This property is specified in pixels.
  double? marginRight;

  /// Defines the margin to the bottom that the scale bar honors. This property is specified in pixels.
  double? marginBottom;

  /// Defines text color of the scale bar.
  int? textColor;

  /// Defines primary color of the scale bar.
  int? primaryColor;

  /// Defines secondary color of the scale bar.
  int? secondaryColor;

  /// Defines width of the border for the scale bar. This property is specified in pixels.
  double? borderWidth;

  /// Defines height of the scale bar. This property is specified in pixels.
  double? height;

  /// Defines margin of the text bar of the scale bar. This property is specified in pixels.
  double? textBarMargin;

  /// Defines text border width of the scale bar. This property is specified in pixels.
  double? textBorderWidth;

  /// Defines text size of the scale bar. This property is specified in pixels.
  double? textSize;

  /// Whether the scale bar is using metric unit. True if the scale bar is using metric system, false if the scale bar is using imperial units.
  bool? isMetricUnits;

  /// Configures minimum refresh interval, in millisecond, default is 15.
  int? refreshInterval;

  /// Configures whether to show the text border or not, default is true.
  bool? showTextBorder;

  /// configures ratio of scale bar max width compared with MapWidget width, default is 0.5.
  double? ratio;

  /// If set to True scale bar will be triggering onDraw depending on [ScaleBarSettings.refreshInterval] even if actual data did not change. If set to False scale bar will redraw only on demand. Defaults to False and should not be changed explicitly in most cases. Could be set to True to produce correct GPU frame metrics when running gfxinfo command.
  bool? useContinuousRendering;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['enabled'] = enabled;
    pigeonMap['position'] = position?.index;
    pigeonMap['marginLeft'] = marginLeft;
    pigeonMap['marginTop'] = marginTop;
    pigeonMap['marginRight'] = marginRight;
    pigeonMap['marginBottom'] = marginBottom;
    pigeonMap['textColor'] = textColor;
    pigeonMap['primaryColor'] = primaryColor;
    pigeonMap['secondaryColor'] = secondaryColor;
    pigeonMap['borderWidth'] = borderWidth;
    pigeonMap['height'] = height;
    pigeonMap['textBarMargin'] = textBarMargin;
    pigeonMap['textBorderWidth'] = textBorderWidth;
    pigeonMap['textSize'] = textSize;
    pigeonMap['isMetricUnits'] = isMetricUnits;
    pigeonMap['refreshInterval'] = refreshInterval;
    pigeonMap['showTextBorder'] = showTextBorder;
    pigeonMap['ratio'] = ratio;
    pigeonMap['useContinuousRendering'] = useContinuousRendering;
    return pigeonMap;
  }

  static ScaleBarSettings decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return ScaleBarSettings(
      enabled: pigeonMap['enabled'] as bool?,
      position: pigeonMap['position'] != null
          ? OrnamentPosition.values[pigeonMap['position']! as int]
          : null,
      marginLeft: pigeonMap['marginLeft'] as double?,
      marginTop: pigeonMap['marginTop'] as double?,
      marginRight: pigeonMap['marginRight'] as double?,
      marginBottom: pigeonMap['marginBottom'] as double?,
      textColor: pigeonMap['textColor'] as int?,
      primaryColor: pigeonMap['primaryColor'] as int?,
      secondaryColor: pigeonMap['secondaryColor'] as int?,
      borderWidth: pigeonMap['borderWidth'] as double?,
      height: pigeonMap['height'] as double?,
      textBarMargin: pigeonMap['textBarMargin'] as double?,
      textBorderWidth: pigeonMap['textBorderWidth'] as double?,
      textSize: pigeonMap['textSize'] as double?,
      isMetricUnits: pigeonMap['isMetricUnits'] as bool?,
      refreshInterval: pigeonMap['refreshInterval'] as int?,
      showTextBorder: pigeonMap['showTextBorder'] as bool?,
      ratio: pigeonMap['ratio'] as double?,
      useContinuousRendering: pigeonMap['useContinuousRendering'] as bool?,
    );
  }
}

/// Shows the compass on the map.
class CompassSettings {
  CompassSettings({
    this.enabled,
    this.position,
    this.marginLeft,
    this.marginTop,
    this.marginRight,
    this.marginBottom,
    this.opacity,
    this.rotation,
    this.visibility,
    this.fadeWhenFacingNorth,
    this.clickable,
    this.image,
  });

  /// Whether the compass is visible on the map.
  bool? enabled;

  /// Defines where the compass is positioned on the map
  OrnamentPosition? position;

  /// Defines the margin to the left that the compass icon honors. This property is specified in pixels.
  double? marginLeft;

  /// Defines the margin to the top that the compass icon honors. This property is specified in pixels.
  double? marginTop;

  /// Defines the margin to the right that the compass icon honors. This property is specified in pixels.
  double? marginRight;

  /// Defines the margin to the bottom that the compass icon honors. This property is specified in pixels.
  double? marginBottom;

  /// The alpha channel value of the compass image
  double? opacity;

  /// The clockwise rotation value in degrees of the compass.
  double? rotation;

  /// Whether the compass is displayed.
  bool? visibility;

  /// Whether the compass fades out to invisible when facing north direction.
  bool? fadeWhenFacingNorth;

  /// Whether the compass can be clicked and click events can be registered.
  bool? clickable;

  /// The compass image, the visual representation of the compass.
  Uint8List? image;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['enabled'] = enabled;
    pigeonMap['position'] = position?.index;
    pigeonMap['marginLeft'] = marginLeft;
    pigeonMap['marginTop'] = marginTop;
    pigeonMap['marginRight'] = marginRight;
    pigeonMap['marginBottom'] = marginBottom;
    pigeonMap['opacity'] = opacity;
    pigeonMap['rotation'] = rotation;
    pigeonMap['visibility'] = visibility;
    pigeonMap['fadeWhenFacingNorth'] = fadeWhenFacingNorth;
    pigeonMap['clickable'] = clickable;
    pigeonMap['image'] = image;
    return pigeonMap;
  }

  static CompassSettings decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return CompassSettings(
      enabled: pigeonMap['enabled'] as bool?,
      position: pigeonMap['position'] != null
          ? OrnamentPosition.values[pigeonMap['position']! as int]
          : null,
      marginLeft: pigeonMap['marginLeft'] as double?,
      marginTop: pigeonMap['marginTop'] as double?,
      marginRight: pigeonMap['marginRight'] as double?,
      marginBottom: pigeonMap['marginBottom'] as double?,
      opacity: pigeonMap['opacity'] as double?,
      rotation: pigeonMap['rotation'] as double?,
      visibility: pigeonMap['visibility'] as bool?,
      fadeWhenFacingNorth: pigeonMap['fadeWhenFacingNorth'] as bool?,
      clickable: pigeonMap['clickable'] as bool?,
      image: pigeonMap['image'] as Uint8List?,
    );
  }
}

/// Shows the attribution icon on the map.
class AttributionSettings {
  AttributionSettings({
    this.iconColor,
    this.position,
    this.marginLeft,
    this.marginTop,
    this.marginRight,
    this.marginBottom,
    this.clickable,
  });

  /// Defines text color of the attribution icon.
  int? iconColor;

  /// Defines where the attribution icon is positioned on the map
  OrnamentPosition? position;

  /// Defines the margin to the left that the attribution icon honors. This property is specified in pixels.
  double? marginLeft;

  /// Defines the margin to the top that the attribution icon honors. This property is specified in pixels.
  double? marginTop;

  /// Defines the margin to the right that the attribution icon honors. This property is specified in pixels.
  double? marginRight;

  /// Defines the margin to the bottom that the attribution icon honors. This property is specified in pixels.
  double? marginBottom;

  /// Whether the attribution can be clicked and click events can be registered.
  bool? clickable;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['iconColor'] = iconColor;
    pigeonMap['position'] = position?.index;
    pigeonMap['marginLeft'] = marginLeft;
    pigeonMap['marginTop'] = marginTop;
    pigeonMap['marginRight'] = marginRight;
    pigeonMap['marginBottom'] = marginBottom;
    pigeonMap['clickable'] = clickable;
    return pigeonMap;
  }

  static AttributionSettings decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return AttributionSettings(
      iconColor: pigeonMap['iconColor'] as int?,
      position: pigeonMap['position'] != null
          ? OrnamentPosition.values[pigeonMap['position']! as int]
          : null,
      marginLeft: pigeonMap['marginLeft'] as double?,
      marginTop: pigeonMap['marginTop'] as double?,
      marginRight: pigeonMap['marginRight'] as double?,
      marginBottom: pigeonMap['marginBottom'] as double?,
      clickable: pigeonMap['clickable'] as bool?,
    );
  }
}

/// Shows the Mapbox logo on the map.
class LogoSettings {
  LogoSettings({
    this.position,
    this.marginLeft,
    this.marginTop,
    this.marginRight,
    this.marginBottom,
  });

  /// Defines where the logo is positioned on the map
  OrnamentPosition? position;

  /// Defines the margin to the left that the attribution icon honors. This property is specified in pixels.
  double? marginLeft;

  /// Defines the margin to the top that the attribution icon honors. This property is specified in pixels.
  double? marginTop;

  /// Defines the margin to the right that the attribution icon honors. This property is specified in pixels.
  double? marginRight;

  /// Defines the margin to the bottom that the attribution icon honors. This property is specified in pixels.
  double? marginBottom;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['position'] = position?.index;
    pigeonMap['marginLeft'] = marginLeft;
    pigeonMap['marginTop'] = marginTop;
    pigeonMap['marginRight'] = marginRight;
    pigeonMap['marginBottom'] = marginBottom;
    return pigeonMap;
  }

  static LogoSettings decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return LogoSettings(
      position: pigeonMap['position'] != null
          ? OrnamentPosition.values[pigeonMap['position']! as int]
          : null,
      marginLeft: pigeonMap['marginLeft'] as double?,
      marginTop: pigeonMap['marginTop'] as double?,
      marginRight: pigeonMap['marginRight'] as double?,
      marginBottom: pigeonMap['marginBottom'] as double?,
    );
  }
}

class _GesturesSettingsInterfaceCodec extends StandardMessageCodec {
  const _GesturesSettingsInterfaceCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is GesturesSettings) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
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
        return GesturesSettings.decode(readValue(buffer)!);

      case 129:
        return ScreenCoordinate.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class GesturesSettingsInterface {
  /// Constructor for [GesturesSettingsInterface].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  GesturesSettingsInterface({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _GesturesSettingsInterfaceCodec();

  Future<GesturesSettings> getSettings() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.GesturesSettingsInterface.getSettings', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
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
      return (replyMap['result'] as GesturesSettings?)!;
    }
  }

  Future<void> updateSettings(GesturesSettings arg_settings) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.GesturesSettingsInterface.updateSettings', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_settings]) as Map<Object?, Object?>?;
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
}

class _LocationComponentSettingsInterfaceCodec extends StandardMessageCodec {
  const _LocationComponentSettingsInterfaceCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is LocationComponentSettings) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is LocationPuck) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is LocationPuck2D) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is LocationPuck3D) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return LocationComponentSettings.decode(readValue(buffer)!);

      case 129:
        return LocationPuck.decode(readValue(buffer)!);

      case 130:
        return LocationPuck2D.decode(readValue(buffer)!);

      case 131:
        return LocationPuck3D.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class LocationComponentSettingsInterface {
  /// Constructor for [LocationComponentSettingsInterface].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  LocationComponentSettingsInterface({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec =
      _LocationComponentSettingsInterfaceCodec();

  Future<LocationComponentSettings> getSettings() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.LocationComponentSettingsInterface.getSettings',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
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
      return (replyMap['result'] as LocationComponentSettings?)!;
    }
  }

  Future<void> updateSettings(LocationComponentSettings arg_settings) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.LocationComponentSettingsInterface.updateSettings',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_settings]) as Map<Object?, Object?>?;
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
}

class _ScaleBarSettingsInterfaceCodec extends StandardMessageCodec {
  const _ScaleBarSettingsInterfaceCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is ScaleBarSettings) {
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
        return ScaleBarSettings.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class ScaleBarSettingsInterface {
  /// Constructor for [ScaleBarSettingsInterface].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  ScaleBarSettingsInterface({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _ScaleBarSettingsInterfaceCodec();

  Future<ScaleBarSettings> getSettings() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.ScaleBarSettingsInterface.getSettings', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
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
      return (replyMap['result'] as ScaleBarSettings?)!;
    }
  }

  Future<void> updateSettings(ScaleBarSettings arg_settings) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.ScaleBarSettingsInterface.updateSettings', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_settings]) as Map<Object?, Object?>?;
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
}

class _CompassSettingsInterfaceCodec extends StandardMessageCodec {
  const _CompassSettingsInterfaceCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CompassSettings) {
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
        return CompassSettings.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class CompassSettingsInterface {
  /// Constructor for [CompassSettingsInterface].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  CompassSettingsInterface({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _CompassSettingsInterfaceCodec();

  Future<CompassSettings> getSettings() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.CompassSettingsInterface.getSettings', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
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
      return (replyMap['result'] as CompassSettings?)!;
    }
  }

  Future<void> updateSettings(CompassSettings arg_settings) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.CompassSettingsInterface.updateSettings', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_settings]) as Map<Object?, Object?>?;
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
}

class _AttributionSettingsInterfaceCodec extends StandardMessageCodec {
  const _AttributionSettingsInterfaceCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is AttributionSettings) {
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
        return AttributionSettings.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class AttributionSettingsInterface {
  /// Constructor for [AttributionSettingsInterface].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  AttributionSettingsInterface({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec =
      _AttributionSettingsInterfaceCodec();

  Future<AttributionSettings> getSettings() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.AttributionSettingsInterface.getSettings', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
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
      return (replyMap['result'] as AttributionSettings?)!;
    }
  }

  Future<void> updateSettings(AttributionSettings arg_settings) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.AttributionSettingsInterface.updateSettings', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_settings]) as Map<Object?, Object?>?;
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
}

class _LogoSettingsInterfaceCodec extends StandardMessageCodec {
  const _LogoSettingsInterfaceCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is LogoSettings) {
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
        return LogoSettings.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class LogoSettingsInterface {
  /// Constructor for [LogoSettingsInterface].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  LogoSettingsInterface({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _LogoSettingsInterfaceCodec();

  Future<LogoSettings> getSettings() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.LogoSettingsInterface.getSettings', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
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
      return (replyMap['result'] as LogoSettings?)!;
    }
  }

  Future<void> updateSettings(LogoSettings arg_settings) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.LogoSettingsInterface.updateSettings', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_settings]) as Map<Object?, Object?>?;
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
}
