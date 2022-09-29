
// This file is generated.

import 'package:pigeon/pigeon.dart';

/// Describes the coordinate on the screen, measured from top to bottom and from left to right.
/// Note: the `map` uses screen coordinate units measured in `platform pixels`.
class ScreenCoordinate {
    /// A value representing the x position of this coordinate.
    double x;
    /// A value representing the y position of this coordinate.
    double y;
}

enum OrnamentPosition { TOP_LEFT, TOP_RIGHT, BOTTOM_RIGHT, BOTTOM_LEFT }

/// Configures the directions in which the map is allowed to move during a scroll gesture.
enum ScrollMode {
  /// The map may only move horizontally.
  HORIZONTAL,
  /// The map may only move vertically.
  VERTICAL,
  /// The map may move both horizontally and vertically.
  HORIZONTAL_AND_VERTICAL,
}
  
/// Gesture configuration allows to control the user touch interaction.
class GesturesSettings {
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
}

/// Gesture configuration allows to control the user touch interaction.
@HostApi
abstract class GesturesSettingsInterface {
  GesturesSettings getSettings();
  void updateSettings(GesturesSettings settings);
}
/// The enum controls how the puck is oriented
enum PuckBearingSource {
  /// Orients the puck to match the direction in which the device is facing.
  HEADING,
  /// Orients the puck to match the direction in which the device is moving.
  COURSE,
}

class LocationPuck2D {
  /// Name of image in sprite to use as the top of the location indicator.
  Uint8List? topImage;
  /// Name of image in sprite to use as the middle of the location indicator.
  Uint8List? bearingImage;
  /// Name of image in sprite to use as the background of the location indicator.
  Uint8List? shadowImage;
  /// The scale expression of the images. If defined, it will be applied to all the three images.
  String? scaleExpression;
}

class LocationPuck3D {
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
}

/// Defines what the customised look of the location puck.
class LocationPuck {
  LocationPuck2D? locationPuck2D;
  LocationPuck3D? locationPuck3D;
}
  
/// Shows a location puck on the map.
class LocationComponentSettings {
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
}

/// Shows a location puck on the map.
@HostApi
abstract class LocationComponentSettingsInterface {
  LocationComponentSettings getSettings();
  void updateSettings(LocationComponentSettings settings);
}
  
/// Shows the scale bar on the map.
class ScaleBarSettings {
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
  /// configures ratio of scale bar max width compared with MapView width, default is 0.5.
  double? ratio;
  /// If set to True scale bar will be triggering onDraw depending on [ScaleBarSettings.refreshInterval] even if actual data did not change. If set to False scale bar will redraw only on demand. Defaults to False and should not be changed explicitly in most cases. Could be set to True to produce correct GPU frame metrics when running gfxinfo command.
  bool? useContinuousRendering;
}

/// Shows the scale bar on the map.
@HostApi
abstract class ScaleBarSettingsInterface {
  ScaleBarSettings getSettings();
  void updateSettings(ScaleBarSettings settings);
}
  
/// Shows the compass on the map.
class CompassSettings {
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
}

/// Shows the compass on the map.
@HostApi
abstract class CompassSettingsInterface {
  CompassSettings getSettings();
  void updateSettings(CompassSettings settings);
}
  
/// Shows the attribution icon on the map.
class AttributionSettings {
  /// Whether the attribution icon is visible on the map.
  bool? enabled;
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
}

/// Shows the attribution icon on the map.
@HostApi
abstract class AttributionSettingsInterface {
  AttributionSettings getSettings();
  void updateSettings(AttributionSettings settings);
}
  
/// Shows the Mapbox logo on the map.
class LogoSettings {
  /// Whether the logo is visible on the map.
  bool? enabled;
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
}

/// Shows the Mapbox logo on the map.
@HostApi
abstract class LogoSettingsInterface {
  LogoSettings getSettings();
  void updateSettings(LogoSettings settings);
}
// End of generated file.