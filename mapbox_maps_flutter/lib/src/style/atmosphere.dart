// This file is generated.
// ignore_for_file: experimental_member_use
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import 'style_internal.dart';
import 'style_types.dart';

/// A global effect that fades layers and markers based on their distance to the camera. The fog can be used to approximate the effect of atmosphere on distant objects and enhance the depth perception of the map when used with terrain or 3D features. Note: fog is renamed to atmosphere in the Android and iOS SDKs and planned to be changed in GL-JS v.3.0.0.
///
/// @see [The online documentation](https://docs.mapbox.com/style-spec/reference/fog/)
@experimental
final class Atmosphere {
  Atmosphere({
    this.color,
    this.colorExpression,
    this.colorUseTheme,
    this.colorUseThemeExpression,
    this.highColor,
    this.highColorExpression,
    this.highColorUseTheme,
    this.highColorUseThemeExpression,
    this.horizonBlend,
    this.horizonBlendExpression,
    this.range,
    this.rangeExpression,
    this.spaceColor,
    this.spaceColorExpression,
    this.spaceColorUseTheme,
    this.spaceColorUseThemeExpression,
    this.starIntensity,
    this.starIntensityExpression,
    this.verticalRange,
    this.verticalRangeExpression,
  });

  /// The color of the atmosphere region immediately below the horizon and within the `range` and above the horizon and within `horizon-blend`. Using opacity is recommended only for smoothly transitioning fog on/off as anything less than 100% opacity results in more tiles loaded and drawn.
  /// Default value: "#ffffff".
  int? color;

  /// The color of the atmosphere region immediately below the horizon and within the `range` and above the horizon and within `horizon-blend`. Using opacity is recommended only for smoothly transitioning fog on/off as anything less than 100% opacity results in more tiles loaded and drawn.
  /// Default value: "#ffffff".
  List<Object>? colorExpression;

  /// Sets if the color theme of the style changes `color`. If you do not set this property, the color theme changes the color.
  ColorUseTheme? colorUseTheme;

  /// Sets if the color theme of the style changes `color`. If you do not set this property, the color theme changes the color.
  List<Object>? colorUseThemeExpression;

  /// The color of the atmosphere region above the horizon, `high-color` extends further above the horizon than the `color` property and its spread can be controlled with `horizon-blend`. The opacity can be set to `0` to remove the high atmosphere color contribution.
  /// Default value: "#245cdf".
  int? highColor;

  /// The color of the atmosphere region above the horizon, `high-color` extends further above the horizon than the `color` property and its spread can be controlled with `horizon-blend`. The opacity can be set to `0` to remove the high atmosphere color contribution.
  /// Default value: "#245cdf".
  List<Object>? highColorExpression;

  /// Sets if the color theme of the style changes `highColor`. If you do not set this property, the color theme changes the color.
  ColorUseTheme? highColorUseTheme;

  /// Sets if the color theme of the style changes `highColor`. If you do not set this property, the color theme changes the color.
  List<Object>? highColorUseThemeExpression;

  /// Horizon blend applies a smooth fade from the color of the atmosphere to the color of space. A value of zero leaves a sharp transition from atmosphere to space. Increasing the value blends the color of atmosphere into increasingly high angles of the sky.
  /// Default value: "["interpolate",["linear"],["zoom"],4,0.2,7,0.1]". Value range: [0, 1]
  double? horizonBlend;

  /// Horizon blend applies a smooth fade from the color of the atmosphere to the color of space. A value of zero leaves a sharp transition from atmosphere to space. Increasing the value blends the color of atmosphere into increasingly high angles of the sky.
  /// Default value: "["interpolate",["linear"],["zoom"],4,0.2,7,0.1]". Value range: [0, 1]
  List<Object>? horizonBlendExpression;

  /// The start and end distance range in which fog fades from fully transparent to fully opaque. The distance to the point at the center of the map is defined as zero, so that negative range values are closer to the camera, and positive values are farther away.
  /// Default value: [0.5,10]. Value range: [-20, 20]
  List<double?>? range;

  /// The start and end distance range in which fog fades from fully transparent to fully opaque. The distance to the point at the center of the map is defined as zero, so that negative range values are closer to the camera, and positive values are farther away.
  /// Default value: [0.5,10]. Value range: [-20, 20]
  List<Object>? rangeExpression;

  /// The color of the region above the horizon and after the end of the `horizon-blend` contribution. The opacity can be set to `0` to have a transparent background.
  /// Default value: "["interpolate",["linear"],["zoom"],4,"#010b19",7,"#367ab9"]".
  int? spaceColor;

  /// The color of the region above the horizon and after the end of the `horizon-blend` contribution. The opacity can be set to `0` to have a transparent background.
  /// Default value: "["interpolate",["linear"],["zoom"],4,"#010b19",7,"#367ab9"]".
  List<Object>? spaceColorExpression;

  /// Sets if the color theme of the style changes `spaceColor`. If you do not set this property, the color theme changes the color.
  ColorUseTheme? spaceColorUseTheme;

  /// Sets if the color theme of the style changes `spaceColor`. If you do not set this property, the color theme changes the color.
  List<Object>? spaceColorUseThemeExpression;

  /// A value controlling the star intensity where `0` will show no stars and `1` will show stars at their maximum intensity.
  /// Default value: "["interpolate",["linear"],["zoom"],5,0.35,6,0]". Value range: [0, 1]
  double? starIntensity;

  /// A value controlling the star intensity where `0` will show no stars and `1` will show stars at their maximum intensity.
  /// Default value: "["interpolate",["linear"],["zoom"],5,0.35,6,0]". Value range: [0, 1]
  List<Object>? starIntensityExpression;

  /// An array of two number values, specifying the vertical range over which the fog should gradually fade out. When both parameters are set to zero, the fog will be rendered without any vertical constraints.
  /// Default value: [0,0]. Minimum value: 0. The unit of verticalRange is in meters.
  List<double?>? verticalRange;

  /// An array of two number values, specifying the vertical range over which the fog should gradually fade out. When both parameters are set to zero, the fog will be rendered without any vertical constraints.
  /// Default value: [0,0]. Minimum value: 0. The unit of verticalRange is in meters.
  List<Object>? verticalRangeExpression;

  /// The style specification names of all Atmosphere properties.
  @internal
  static const List<String> propertyNames = [
    "color",
    "color-use-theme",
    "high-color",
    "high-color-use-theme",
    "horizon-blend",
    "range",
    "space-color",
    "space-color-use-theme",
    "star-intensity",
    "vertical-range",
  ];

  /// Converts this Atmosphere to its style specification JSON.
  @internal
  Map<String, Object> toJson() => {
    "color": ?(colorExpression ?? color?.toRGBA()),
    "color-use-theme": ?(colorUseThemeExpression ?? colorUseTheme?.value),
    "high-color": ?(highColorExpression ?? highColor?.toRGBA()),
    "high-color-use-theme":
        ?(highColorUseThemeExpression ?? highColorUseTheme?.value),
    "horizon-blend": ?(horizonBlendExpression ?? horizonBlend),
    "range": ?(rangeExpression ?? range),
    "space-color": ?(spaceColorExpression ?? spaceColor?.toRGBA()),
    "space-color-use-theme":
        ?(spaceColorUseThemeExpression ?? spaceColorUseTheme?.value),
    "star-intensity": ?(starIntensityExpression ?? starIntensity),
    "vertical-range": ?(verticalRangeExpression ?? verticalRange),
  };

  /// Creates a Atmosphere from its style specification JSON.
  @internal
  static Atmosphere fromJson(Map<String, Object?> json) {
    return Atmosphere(
      color: styleColorFromJson(json["color"]),
      colorExpression: styleExpressionFromJson(json["color"]),
      colorUseTheme: ColorUseTheme.fromValue(json["color-use-theme"]),
      colorUseThemeExpression: styleExpressionFromJson(json["color-use-theme"]),
      highColor: styleColorFromJson(json["high-color"]),
      highColorExpression: styleExpressionFromJson(json["high-color"]),
      highColorUseTheme: ColorUseTheme.fromValue(json["high-color-use-theme"]),
      highColorUseThemeExpression: styleExpressionFromJson(
        json["high-color-use-theme"],
      ),
      horizonBlend: styleOptionalCast(json["horizon-blend"]),
      horizonBlendExpression: styleExpressionFromJson(json["horizon-blend"]),
      range: styleNumberListFromJson(json["range"]),
      rangeExpression: styleExpressionFromJson(json["range"]),
      spaceColor: styleColorFromJson(json["space-color"]),
      spaceColorExpression: styleExpressionFromJson(json["space-color"]),
      spaceColorUseTheme: ColorUseTheme.fromValue(
        json["space-color-use-theme"],
      ),
      spaceColorUseThemeExpression: styleExpressionFromJson(
        json["space-color-use-theme"],
      ),
      starIntensity: styleOptionalCast(json["star-intensity"]),
      starIntensityExpression: styleExpressionFromJson(json["star-intensity"]),
      verticalRange: styleNumberListFromJson(json["vertical-range"]),
      verticalRangeExpression: styleExpressionFromJson(json["vertical-range"]),
    );
  }
}

// End of generated file.
