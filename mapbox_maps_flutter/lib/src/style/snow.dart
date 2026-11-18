// This file is generated.
// ignore_for_file: experimental_member_use
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import 'style_internal.dart';
import 'style_types.dart';

/// Snow particles over the map
///
/// @see [The online documentation](https://docs.mapbox.com/style-spec/reference/snow/)
@experimental
final class Snow {
  Snow({
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
    this.flakeSize,
    this.flakeSizeExpression,
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

  /// Thinning factor of snow particles from center. 0 - no thinning. 1 - maximal central area thinning.
  /// Default value: 0.4. Value range: [0, 1]
  double? centerThinning;

  /// Thinning factor of snow particles from center. 0 - no thinning. 1 - maximal central area thinning.
  /// Default value: 0.4. Value range: [0, 1]
  List<Object>? centerThinningExpression;

  /// Snow particles color.
  /// Default value: "#ffffff".
  int? color;

  /// Snow particles color.
  /// Default value: "#ffffff".
  List<Object>? colorExpression;

  /// Sets if the color theme of the style changes `color`. If you do not set this property, the color theme changes the color.
  ///
  /// Supported platforms: Android, iOS.
  ColorUseTheme? colorUseTheme;

  /// Sets if the color theme of the style changes `color`. If you do not set this property, the color theme changes the color.
  ///
  /// Supported platforms: Android, iOS.
  List<Object>? colorUseThemeExpression;

  /// Snow particles density. Controls the overall particles number.
  /// Default value: "["interpolate",["linear"],["zoom"],11,0,13,0.85]". Value range: [0, 1]
  double? density;

  /// Snow particles density. Controls the overall particles number.
  /// Default value: "["interpolate",["linear"],["zoom"],11,0,13,0.85]". Value range: [0, 1]
  List<Object>? densityExpression;

  /// Main snow particles direction. Azimuth and polar angles
  /// Default value: [0,50]. Value range: [0, 360]
  List<double?>? direction;

  /// Main snow particles direction. Azimuth and polar angles
  /// Default value: [0,50]. Value range: [0, 360]
  List<Object>? directionExpression;

  /// Snow flake particle size. Correlates with individual particle screen size
  /// Default value: 0.71. Value range: [0, 5]
  double? flakeSize;

  /// Snow flake particle size. Correlates with individual particle screen size
  /// Default value: 0.71. Value range: [0, 5]
  List<Object>? flakeSizeExpression;

  /// Snow particles movement factor. Controls the overall particles movement speed.
  /// Default value: 1. Value range: [0, 1]
  double? intensity;

  /// Snow particles movement factor. Controls the overall particles movement speed.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? intensityExpression;

  /// Snow particles opacity.
  /// Default value: 1. Value range: [0, 1]
  double? opacity;

  /// Snow particles opacity.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? opacityExpression;

  /// Snow vignette screen-space effect. Adds snow tint to screen corners
  /// Default value: "["interpolate",["linear"],["zoom"],11,0,13,0.3]". Value range: [0, 1]
  double? vignette;

  /// Snow vignette screen-space effect. Adds snow tint to screen corners
  /// Default value: "["interpolate",["linear"],["zoom"],11,0,13,0.3]". Value range: [0, 1]
  List<Object>? vignetteExpression;

  /// Snow vignette screen-space corners tint color.
  /// Default value: "#ffffff".
  int? vignetteColor;

  /// Snow vignette screen-space corners tint color.
  /// Default value: "#ffffff".
  List<Object>? vignetteColorExpression;

  /// Sets if the color theme of the style changes `vignetteColor`. If you do not set this property, the color theme changes the color.
  ///
  /// Supported platforms: Android, iOS.
  ColorUseTheme? vignetteColorUseTheme;

  /// Sets if the color theme of the style changes `vignetteColor`. If you do not set this property, the color theme changes the color.
  ///
  /// Supported platforms: Android, iOS.
  List<Object>? vignetteColorUseThemeExpression;

  /// The style specification names of all Snow properties.
  @internal
  static const List<String> propertyNames = [
    "center-thinning",
    "color",
    "color-use-theme",
    "density",
    "direction",
    "flake-size",
    "intensity",
    "opacity",
    "vignette",
    "vignette-color",
    "vignette-color-use-theme",
  ];

  /// Converts this Snow to its style specification JSON.
  @internal
  Map<String, Object> toJson() => {
    "center-thinning": ?(centerThinningExpression ?? centerThinning),
    "color": ?(colorExpression ?? color?.toRGBA()),
    "color-use-theme": ?(colorUseThemeExpression ?? colorUseTheme?.value),
    "density": ?(densityExpression ?? density),
    "direction": ?(directionExpression ?? direction),
    "flake-size": ?(flakeSizeExpression ?? flakeSize),
    "intensity": ?(intensityExpression ?? intensity),
    "opacity": ?(opacityExpression ?? opacity),
    "vignette": ?(vignetteExpression ?? vignette),
    "vignette-color": ?(vignetteColorExpression ?? vignetteColor?.toRGBA()),
    "vignette-color-use-theme":
        ?(vignetteColorUseThemeExpression ?? vignetteColorUseTheme?.value),
  };

  /// Creates a Snow from its style specification JSON.
  @internal
  static Snow fromJson(Map<String, Object?> json) {
    return Snow(
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
      flakeSize: styleOptionalCast(json["flake-size"]),
      flakeSizeExpression: styleExpressionFromJson(json["flake-size"]),
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
