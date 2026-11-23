// This file is generated.
// ignore_for_file: experimental_member_use
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import 'style_internal.dart';
import 'style_types.dart';

/// Rain particles over the map
///
/// @see [The online documentation](https://docs.mapbox.com/style-spec/reference/rain/)
@experimental
final class Rain {
  Rain({
    this.centerThinning,
    this.centerThinningExpression,
    this.color,
    this.colorExpression,
    this.colorUseTheme,
    this.colorUseThemeExpression,
    this.density,
    this.densityExpression,
    this.direction,
    this.directionExpression,
    this.distortionStrength,
    this.distortionStrengthExpression,
    this.dropletSize,
    this.dropletSizeExpression,
    this.intensity,
    this.intensityExpression,
    this.opacity,
    this.opacityExpression,
    this.vignette,
    this.vignetteExpression,
    this.vignetteColor,
    this.vignetteColorExpression,
    this.vignetteColorUseTheme,
    this.vignetteColorUseThemeExpression,
  });

  /// Thinning factor of rain particles from center. 0 - no thinning. 1 - maximal central area thinning.
  /// Default value: 0.57. Value range: [0, 1]
  double? centerThinning;

  /// Thinning factor of rain particles from center. 0 - no thinning. 1 - maximal central area thinning.
  /// Default value: 0.57. Value range: [0, 1]
  List<Object>? centerThinningExpression;

  /// Individual rain particle dorplets color.
  /// Default value: "["interpolate",["linear"],["measure-light","brightness"],0,"#03113d",0.3,"#a8adbc"]".
  int? color;

  /// Individual rain particle dorplets color.
  /// Default value: "["interpolate",["linear"],["measure-light","brightness"],0,"#03113d",0.3,"#a8adbc"]".
  List<Object>? colorExpression;

  /// Sets if the color theme of the style changes `color`. If you do not set this property, the color theme changes the color.
  ///
  /// Supported platforms: Android, iOS.
  ColorUseTheme? colorUseTheme;

  /// Sets if the color theme of the style changes `color`. If you do not set this property, the color theme changes the color.
  ///
  /// Supported platforms: Android, iOS.
  List<Object>? colorUseThemeExpression;

  /// Rain particles density. Controls the overall screen density of the rain.
  /// Default value: "["interpolate",["linear"],["zoom"],11,0,13,0.5]". Value range: [0, 1]
  double? density;

  /// Rain particles density. Controls the overall screen density of the rain.
  /// Default value: "["interpolate",["linear"],["zoom"],11,0,13,0.5]". Value range: [0, 1]
  List<Object>? densityExpression;

  /// Main rain particles direction. Azimuth and polar angles.
  /// Default value: [0,80]. Value range: [0, 360]
  List<double?>? direction;

  /// Main rain particles direction. Azimuth and polar angles.
  /// Default value: [0,80]. Value range: [0, 360]
  List<Object>? directionExpression;

  /// Rain particles screen-space distortion strength.
  /// Default value: 0.7. Value range: [0, 1]
  double? distortionStrength;

  /// Rain particles screen-space distortion strength.
  /// Default value: 0.7. Value range: [0, 1]
  List<Object>? distortionStrengthExpression;

  /// Rain droplet size. x - normal to direction, y - along direction
  /// Default value: [2.6,18.2]. Value range: [0, 50]
  List<double?>? dropletSize;

  /// Rain droplet size. x - normal to direction, y - along direction
  /// Default value: [2.6,18.2]. Value range: [0, 50]
  List<Object>? dropletSizeExpression;

  /// Rain particles movement factor. Controls the overall rain particles speed
  /// Default value: 1. Value range: [0, 1]
  double? intensity;

  /// Rain particles movement factor. Controls the overall rain particles speed
  /// Default value: 1. Value range: [0, 1]
  List<Object>? intensityExpression;

  /// Rain particles opacity.
  /// Default value: "["interpolate",["linear"],["measure-light","brightness"],0,0.88,1,0.7]". Value range: [0, 1]
  double? opacity;

  /// Rain particles opacity.
  /// Default value: "["interpolate",["linear"],["measure-light","brightness"],0,0.88,1,0.7]". Value range: [0, 1]
  List<Object>? opacityExpression;

  /// Screen-space vignette rain tinting effect intensity.
  /// Default value: "["interpolate",["linear"],["zoom"],11,0,13,1]". Value range: [0, 1]
  double? vignette;

  /// Screen-space vignette rain tinting effect intensity.
  /// Default value: "["interpolate",["linear"],["zoom"],11,0,13,1]". Value range: [0, 1]
  List<Object>? vignetteExpression;

  /// Rain vignette screen-space corners tint color.
  /// Default value: "["interpolate",["linear"],["measure-light","brightness"],0,"#001736",0.3,"#464646"]".
  int? vignetteColor;

  /// Rain vignette screen-space corners tint color.
  /// Default value: "["interpolate",["linear"],["measure-light","brightness"],0,"#001736",0.3,"#464646"]".
  List<Object>? vignetteColorExpression;

  /// Sets if the color theme of the style changes `vignetteColor`. If you do not set this property, the color theme changes the color.
  ///
  /// Supported platforms: Android, iOS.
  ColorUseTheme? vignetteColorUseTheme;

  /// Sets if the color theme of the style changes `vignetteColor`. If you do not set this property, the color theme changes the color.
  ///
  /// Supported platforms: Android, iOS.
  List<Object>? vignetteColorUseThemeExpression;

  /// The style specification names of all Rain properties.
  @internal
  static const List<String> propertyNames = [
    "center-thinning",
    "color",
    "color-use-theme",
    "density",
    "direction",
    "distortion-strength",
    "droplet-size",
    "intensity",
    "opacity",
    "vignette",
    "vignette-color",
    "vignette-color-use-theme",
  ];

  /// Converts this Rain to its style specification JSON.
  @internal
  Map<String, Object> toJson() => {
    "center-thinning": ?(centerThinningExpression ?? centerThinning),
    "color": ?(colorExpression ?? color?.toRGBA()),
    "color-use-theme": ?(colorUseThemeExpression ?? colorUseTheme?.value),
    "density": ?(densityExpression ?? density),
    "direction": ?(directionExpression ?? direction),
    "distortion-strength":
        ?(distortionStrengthExpression ?? distortionStrength),
    "droplet-size": ?(dropletSizeExpression ?? dropletSize),
    "intensity": ?(intensityExpression ?? intensity),
    "opacity": ?(opacityExpression ?? opacity),
    "vignette": ?(vignetteExpression ?? vignette),
    "vignette-color": ?(vignetteColorExpression ?? vignetteColor?.toRGBA()),
    "vignette-color-use-theme":
        ?(vignetteColorUseThemeExpression ?? vignetteColorUseTheme?.value),
  };

  /// Creates a Rain from its style specification JSON.
  @internal
  static Rain fromJson(Map<String, Object?> json) {
    return Rain(
      centerThinning: styleOptionalCast(json["center-thinning"]),
      centerThinningExpression: styleExpressionFromJson(
        json["center-thinning"],
      ),
      color: styleColorFromJson(json["color"]),
      colorExpression: styleExpressionFromJson(json["color"]),
      colorUseTheme: ColorUseTheme.fromValue(json["color-use-theme"]),
      colorUseThemeExpression: styleExpressionFromJson(json["color-use-theme"]),
      density: styleOptionalCast(json["density"]),
      densityExpression: styleExpressionFromJson(json["density"]),
      direction: styleNumberListFromJson(json["direction"]),
      directionExpression: styleExpressionFromJson(json["direction"]),
      distortionStrength: styleOptionalCast(json["distortion-strength"]),
      distortionStrengthExpression: styleExpressionFromJson(
        json["distortion-strength"],
      ),
      dropletSize: styleNumberListFromJson(json["droplet-size"]),
      dropletSizeExpression: styleExpressionFromJson(json["droplet-size"]),
      intensity: styleOptionalCast(json["intensity"]),
      intensityExpression: styleExpressionFromJson(json["intensity"]),
      opacity: styleOptionalCast(json["opacity"]),
      opacityExpression: styleExpressionFromJson(json["opacity"]),
      vignette: styleOptionalCast(json["vignette"]),
      vignetteExpression: styleExpressionFromJson(json["vignette"]),
      vignetteColor: styleColorFromJson(json["vignette-color"]),
      vignetteColorExpression: styleExpressionFromJson(json["vignette-color"]),
      vignetteColorUseTheme: ColorUseTheme.fromValue(
        json["vignette-color-use-theme"],
      ),
      vignetteColorUseThemeExpression: styleExpressionFromJson(
        json["vignette-color-use-theme"],
      ),
    );
  }
}

// End of generated file.
