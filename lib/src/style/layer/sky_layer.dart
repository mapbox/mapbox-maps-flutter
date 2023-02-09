// This file is generated.
part of mapbox_maps_flutter;

/// A spherical dome around the map that is always rendered behind all other layers.
class SkyLayer extends Layer {
  SkyLayer({
    required id,
    visibility,
    minZoom,
    maxZoom,
    this.skyAtmosphereColor,
    this.skyAtmosphereHaloColor,
    this.skyAtmosphereSun,
    this.skyAtmosphereSunIntensity,
    this.skyGradient,
    this.skyGradientCenter,
    this.skyGradientRadius,
    this.skyOpacity,
    this.skyType,
  }) : super(
            id: id, visibility: visibility, maxZoom: maxZoom, minZoom: minZoom);

  @override
  String getType() => "sky";

  /// A color used to tweak the main atmospheric scattering coefficients. Using white applies the default coefficients giving the natural blue color to the atmosphere. This color affects how heavily the corresponding wavelength is represented during scattering. The alpha channel describes the density of the atmosphere, with 1 maximum density and 0 no density.
  int? skyAtmosphereColor;

  /// A color applied to the atmosphere sun halo. The alpha channel describes how strongly the sun halo is represented in an atmosphere sky layer.
  int? skyAtmosphereHaloColor;

  /// Position of the sun center [a azimuthal angle, p polar angle]. The azimuthal angle indicates the position of the sun relative to 0° north, where degrees proceed clockwise. The polar angle indicates the height of the sun, where 0° is directly above, at zenith, and 90° at the horizon. When this property is ommitted, the sun center is directly inherited from the light position.
  List<double?>? skyAtmosphereSun;

  /// Intensity of the sun as a light source in the atmosphere (on a scale from 0 to a 100). Setting higher values will brighten up the sky.
  double? skyAtmosphereSunIntensity;

  /// Defines a radial color gradient with which to color the sky. The color values can be interpolated with an expression using `sky-radial-progress`. The range [0, 1] for the interpolant covers a radial distance (in degrees) of [0, `sky-gradient-radius`] centered at the position specified by `sky-gradient-center`.
  int? skyGradient;

  /// Position of the gradient center [a azimuthal angle, p polar angle]. The azimuthal angle indicates the position of the gradient center relative to 0° north, where degrees proceed clockwise. The polar angle indicates the height of the gradient center, where 0° is directly above, at zenith, and 90° at the horizon.
  List<double?>? skyGradientCenter;

  /// The angular distance (measured in degrees) from `sky-gradient-center` up to which the gradient extends. A value of 180 causes the gradient to wrap around to the opposite direction from `sky-gradient-center`.
  double? skyGradientRadius;

  /// The opacity of the entire sky layer.
  double? skyOpacity;

  /// The type of the sky
  SkyType? skyType;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.toString().split('.').last.toLowerCase();
    }
    var paint = {};
    if (skyAtmosphereColor != null) {
      paint["sky-atmosphere-color"] = skyAtmosphereColor?.toRGBA();
    }
    if (skyAtmosphereHaloColor != null) {
      paint["sky-atmosphere-halo-color"] = skyAtmosphereHaloColor?.toRGBA();
    }
    if (skyAtmosphereSun != null) {
      paint["sky-atmosphere-sun"] = skyAtmosphereSun;
    }
    if (skyAtmosphereSunIntensity != null) {
      paint["sky-atmosphere-sun-intensity"] = skyAtmosphereSunIntensity;
    }
    if (skyGradient != null) {
      paint["sky-gradient"] = skyGradient?.toRGBA();
    }
    if (skyGradientCenter != null) {
      paint["sky-gradient-center"] = skyGradientCenter;
    }
    if (skyGradientRadius != null) {
      paint["sky-gradient-radius"] = skyGradientRadius;
    }
    if (skyOpacity != null) {
      paint["sky-opacity"] = skyOpacity;
    }
    if (skyType != null) {
      paint["sky-type"] = skyType?.toString().split('.').last.toLowerCase();
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
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["visibility"])),
      skyAtmosphereColor:
          (map["paint"]["sky-atmosphere-color"] as List?)?.toRGBAInt(),
      skyAtmosphereHaloColor:
          (map["paint"]["sky-atmosphere-halo-color"] as List?)?.toRGBAInt(),
      skyAtmosphereSun: (map["paint"]["sky-atmosphere-sun"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      skyAtmosphereSunIntensity: map["paint"]["sky-atmosphere-sun-intensity"]
              is num?
          ? (map["paint"]["sky-atmosphere-sun-intensity"] as num?)?.toDouble()
          : null,
      skyGradient: (map["paint"]["sky-gradient"] as List?)?.toRGBAInt(),
      skyGradientCenter: (map["paint"]["sky-gradient-center"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      skyGradientRadius: map["paint"]["sky-gradient-radius"] is num?
          ? (map["paint"]["sky-gradient-radius"] as num?)?.toDouble()
          : null,
      skyOpacity: map["paint"]["sky-opacity"] is num?
          ? (map["paint"]["sky-opacity"] as num?)?.toDouble()
          : null,
      skyType: map["paint"]["sky-type"] == null
          ? null
          : SkyType.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["paint"]["sky-type"])),
    );
  }
}

// End of generated file.
