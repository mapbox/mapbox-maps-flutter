// This file is generated.
// ignore_for_file: unused_import
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../style_internal.dart';
import '../style_types.dart';
import 'layer.dart';

/// A spherical dome around the map that is always rendered behind all other layers.
final class SkyLayer extends Layer {
  SkyLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
    double? minZoom,
    double? maxZoom,
    String? slot,

    int? this.skyAtmosphereColor,
    List<Object>? this.skyAtmosphereColorExpression,
    int? this.skyAtmosphereHaloColor,
    List<Object>? this.skyAtmosphereHaloColorExpression,
    List<double?>? this.skyAtmosphereSun,
    List<Object>? this.skyAtmosphereSunExpression,
    double? this.skyAtmosphereSunIntensity,
    List<Object>? this.skyAtmosphereSunIntensityExpression,
    int? this.skyGradient,
    List<Object>? this.skyGradientExpression,
    List<double?>? this.skyGradientCenter,
    List<Object>? this.skyGradientCenterExpression,
    double? this.skyGradientRadius,
    List<Object>? this.skyGradientRadiusExpression,
    double? this.skyOpacity,
    List<Object>? this.skyOpacityExpression,
    SkyType? this.skyType,
    List<Object>? this.skyTypeExpression,
  }) : super(
         id: id,
         visibility: visibility,
         visibilityExpression: visibilityExpression,
         filter: filter,
         maxZoom: maxZoom,
         minZoom: minZoom,
         slot: slot,
       );

  @override
  String getType() => "sky";

  /// A color used to tweak the main atmospheric scattering coefficients. Using white applies the default coefficients giving the natural blue color to the atmosphere. This color affects how heavily the corresponding wavelength is represented during scattering. The alpha channel describes the density of the atmosphere, with 1 maximum density and 0 no density.
  /// Default value: "white".
  int? skyAtmosphereColor;

  /// A color used to tweak the main atmospheric scattering coefficients. Using white applies the default coefficients giving the natural blue color to the atmosphere. This color affects how heavily the corresponding wavelength is represented during scattering. The alpha channel describes the density of the atmosphere, with 1 maximum density and 0 no density.
  /// Default value: "white".
  List<Object>? skyAtmosphereColorExpression;

  /// A color applied to the atmosphere sun halo. The alpha channel describes how strongly the sun halo is represented in an atmosphere sky layer.
  /// Default value: "white".
  int? skyAtmosphereHaloColor;

  /// A color applied to the atmosphere sun halo. The alpha channel describes how strongly the sun halo is represented in an atmosphere sky layer.
  /// Default value: "white".
  List<Object>? skyAtmosphereHaloColorExpression;

  /// Position of the sun center [a azimuthal angle, p polar angle]. The azimuthal angle indicates the position of the sun relative to 0 degree north, where degrees proceed clockwise. The polar angle indicates the height of the sun, where 0 degree is directly above, at zenith, and 90 degree at the horizon. When this property is ommitted, the sun center is directly inherited from the light position.
  /// Minimum value: [0,0]. Maximum value: [360,180]. The unit of skyAtmosphereSun is in degrees.
  List<double?>? skyAtmosphereSun;

  /// Position of the sun center [a azimuthal angle, p polar angle]. The azimuthal angle indicates the position of the sun relative to 0 degree north, where degrees proceed clockwise. The polar angle indicates the height of the sun, where 0 degree is directly above, at zenith, and 90 degree at the horizon. When this property is ommitted, the sun center is directly inherited from the light position.
  /// Minimum value: [0,0]. Maximum value: [360,180]. The unit of skyAtmosphereSun is in degrees.
  List<Object>? skyAtmosphereSunExpression;

  /// Intensity of the sun as a light source in the atmosphere (on a scale from 0 to a 100). Setting higher values will brighten up the sky.
  /// Default value: 10. Value range: [0, 100]
  double? skyAtmosphereSunIntensity;

  /// Intensity of the sun as a light source in the atmosphere (on a scale from 0 to a 100). Setting higher values will brighten up the sky.
  /// Default value: 10. Value range: [0, 100]
  List<Object>? skyAtmosphereSunIntensityExpression;

  /// Defines a radial color gradient with which to color the sky. The color values can be interpolated with an expression using `sky-radial-progress`. The range [0, 1] for the interpolant covers a radial distance (in degrees) of [0, `sky-gradient-radius`] centered at the position specified by `sky-gradient-center`.
  /// Default value: ["interpolate",["linear"],["sky-radial-progress"],0.8,"#87ceeb",1,"white"].
  int? skyGradient;

  /// Defines a radial color gradient with which to color the sky. The color values can be interpolated with an expression using `sky-radial-progress`. The range [0, 1] for the interpolant covers a radial distance (in degrees) of [0, `sky-gradient-radius`] centered at the position specified by `sky-gradient-center`.
  /// Default value: ["interpolate",["linear"],["sky-radial-progress"],0.8,"#87ceeb",1,"white"].
  List<Object>? skyGradientExpression;

  /// Position of the gradient center [a azimuthal angle, p polar angle]. The azimuthal angle indicates the position of the gradient center relative to 0 degree north, where degrees proceed clockwise. The polar angle indicates the height of the gradient center, where 0 degree is directly above, at zenith, and 90 degree at the horizon.
  /// Default value: [0,0]. Minimum value: [0,0]. Maximum value: [360,180]. The unit of skyGradientCenter is in degrees.
  List<double?>? skyGradientCenter;

  /// Position of the gradient center [a azimuthal angle, p polar angle]. The azimuthal angle indicates the position of the gradient center relative to 0 degree north, where degrees proceed clockwise. The polar angle indicates the height of the gradient center, where 0 degree is directly above, at zenith, and 90 degree at the horizon.
  /// Default value: [0,0]. Minimum value: [0,0]. Maximum value: [360,180]. The unit of skyGradientCenter is in degrees.
  List<Object>? skyGradientCenterExpression;

  /// The angular distance (measured in degrees) from `sky-gradient-center` up to which the gradient extends. A value of 180 causes the gradient to wrap around to the opposite direction from `sky-gradient-center`.
  /// Default value: 90. Value range: [0, 180]
  double? skyGradientRadius;

  /// The angular distance (measured in degrees) from `sky-gradient-center` up to which the gradient extends. A value of 180 causes the gradient to wrap around to the opposite direction from `sky-gradient-center`.
  /// Default value: 90. Value range: [0, 180]
  List<Object>? skyGradientRadiusExpression;

  /// The opacity of the entire sky layer.
  /// Default value: 1. Value range: [0, 1]
  double? skyOpacity;

  /// The opacity of the entire sky layer.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? skyOpacityExpression;

  /// The type of the sky
  /// Default value: "atmosphere".
  SkyType? skyType;

  /// The type of the sky
  /// Default value: "atmosphere".
  List<Object>? skyTypeExpression;

  @override
  @internal
  Future<String> encode() async {
    var layout = {};
    if (visibilityExpression != null) {
      layout["visibility"] = visibilityExpression!;
    }
    if (visibility != null) {
      layout["visibility"] = visibility!.name.toLowerCase().replaceAll(
        "_",
        "-",
      );
    }

    var paint = {};
    if (skyAtmosphereColorExpression != null) {
      paint["sky-atmosphere-color"] = skyAtmosphereColorExpression;
    } else if (skyAtmosphereColor != null) {
      paint["sky-atmosphere-color"] = skyAtmosphereColor?.toRGBA();
    }

    if (skyAtmosphereHaloColorExpression != null) {
      paint["sky-atmosphere-halo-color"] = skyAtmosphereHaloColorExpression;
    } else if (skyAtmosphereHaloColor != null) {
      paint["sky-atmosphere-halo-color"] = skyAtmosphereHaloColor?.toRGBA();
    }

    if (skyAtmosphereSunExpression != null) {
      paint["sky-atmosphere-sun"] = skyAtmosphereSunExpression;
    } else if (skyAtmosphereSun != null) {
      paint["sky-atmosphere-sun"] = skyAtmosphereSun;
    }

    if (skyAtmosphereSunIntensityExpression != null) {
      paint["sky-atmosphere-sun-intensity"] =
          skyAtmosphereSunIntensityExpression;
    } else if (skyAtmosphereSunIntensity != null) {
      paint["sky-atmosphere-sun-intensity"] = skyAtmosphereSunIntensity;
    }

    if (skyGradientExpression != null) {
      paint["sky-gradient"] = skyGradientExpression;
    } else if (skyGradient != null) {
      paint["sky-gradient"] = skyGradient?.toRGBA();
    }

    if (skyGradientCenterExpression != null) {
      paint["sky-gradient-center"] = skyGradientCenterExpression;
    } else if (skyGradientCenter != null) {
      paint["sky-gradient-center"] = skyGradientCenter;
    }

    if (skyGradientRadiusExpression != null) {
      paint["sky-gradient-radius"] = skyGradientRadiusExpression;
    } else if (skyGradientRadius != null) {
      paint["sky-gradient-radius"] = skyGradientRadius;
    }

    if (skyOpacityExpression != null) {
      paint["sky-opacity"] = skyOpacityExpression;
    } else if (skyOpacity != null) {
      paint["sky-opacity"] = skyOpacity;
    }

    if (skyTypeExpression != null) {
      paint["sky-type"] = skyTypeExpression;
    } else if (skyType != null) {
      paint["sky-type"] = skyType?.name.toLowerCase().replaceAll("_", "-");
    }

    var properties = {
      "id": id,
      "type": getType(),
      "layout": layout,
      "paint": paint,
    };
    if (minZoom != null) {
      properties["minzoom"] = minZoom!;
    }
    if (maxZoom != null) {
      properties["maxzoom"] = maxZoom!;
    }
    if (slot != null) {
      properties["slot"] = slot!;
    }
    if (filter != null) {
      properties["filter"] = filter!;
    }

    return json.encode(properties);
  }

  static SkyLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return SkyLayer(
      id: map["id"],
      minZoom: map["minzoom"]?.toDouble(),
      maxZoom: map["maxzoom"]?.toDouble(),
      slot: map["slot"],
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere(
              (e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["layout"]["visibility"]),
            ),
      visibilityExpression: styleOptionalCastList(map["layout"]["visibility"]),
      filter: styleOptionalCastList(map["filter"]),
      skyAtmosphereColor: (map["paint"]["sky-atmosphere-color"] as List?)
          ?.toRGBAInt(),
      skyAtmosphereColorExpression: styleOptionalCastList(
        map["paint"]["sky-atmosphere-color"],
      ),
      skyAtmosphereHaloColor:
          (map["paint"]["sky-atmosphere-halo-color"] as List?)?.toRGBAInt(),
      skyAtmosphereHaloColorExpression: styleOptionalCastList(
        map["paint"]["sky-atmosphere-halo-color"],
      ),
      skyAtmosphereSun: (map["paint"]["sky-atmosphere-sun"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      skyAtmosphereSunExpression: styleOptionalCastList(
        map["paint"]["sky-atmosphere-sun"],
      ),
      skyAtmosphereSunIntensity: styleOptionalCast(
        map["paint"]["sky-atmosphere-sun-intensity"],
      ),
      skyAtmosphereSunIntensityExpression: styleOptionalCastList(
        map["paint"]["sky-atmosphere-sun-intensity"],
      ),
      skyGradient: (map["paint"]["sky-gradient"] as List?)?.toRGBAInt(),
      skyGradientExpression: styleOptionalCastList(
        map["paint"]["sky-gradient"],
      ),
      skyGradientCenter: (map["paint"]["sky-gradient-center"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      skyGradientCenterExpression: styleOptionalCastList(
        map["paint"]["sky-gradient-center"],
      ),
      skyGradientRadius: styleOptionalCast(map["paint"]["sky-gradient-radius"]),
      skyGradientRadiusExpression: styleOptionalCastList(
        map["paint"]["sky-gradient-radius"],
      ),
      skyOpacity: styleOptionalCast(map["paint"]["sky-opacity"]),
      skyOpacityExpression: styleOptionalCastList(map["paint"]["sky-opacity"]),
      skyType: map["paint"]["sky-type"] == null
          ? null
          : SkyType.values.firstWhere(
              (e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["paint"]["sky-type"]),
            ),
      skyTypeExpression: styleOptionalCastList(map["paint"]["sky-type"]),
    );
  }
}

// End of generated file.
