// This file is generated.
part of mapbox_maps_flutter;

/// A light that has a direction and is located at infinite, so its rays are parallel. Simulates the sun light and it can cast shadows
/// Check the [online documentation](https://www.mapbox.com/mapbox-gl-style-spec/#light).
class DirectionalLight {
  DirectionalLight({
    this.id,
    this.castShadows,
    this.color,
    this.colorTransition,
    this.direction,
    this.directionTransition,
    this.intensity,
    this.intensityTransition,
    this.shadowIntensity,
    this.shadowIntensityTransition,
  });

  final String id;
  final String lightType = .Directional
  /// Enable/Disable shadow casting for this light
  bool? castShadows;
  /// Color of the directional light.
  int? color;
  /// Color of the directional light.
  StyleTransition? colorTransition;
  /// Direction of the light source specified as [a azimuthal angle, p polar angle] where a indicates the azimuthal angle of the light relative to north (in degrees and proceeding clockwise), and p indicates polar angle of the light (from 0°, directly above, to 180°, directly below).
  List<double?>? direction;
  /// Direction of the light source specified as [a azimuthal angle, p polar angle] where a indicates the azimuthal angle of the light relative to north (in degrees and proceeding clockwise), and p indicates polar angle of the light (from 0°, directly above, to 180°, directly below).
  StyleTransition? directionTransition;
  /// A multiplier for the color of the directional light.
  double? intensity;
  /// A multiplier for the color of the directional light.
  StyleTransition? intensityTransition;
  /// Determines the shadow strength, affecting the shadow receiver surfaces final color. Values near 0.0 reduce the shadow contribution to the final color. Values near to 1.0 make occluded surfaces receive almost no directional light. Designed to be used mostly for transitioning between values 0 and 1.
  double? shadowIntensity;
  /// Determines the shadow strength, affecting the shadow receiver surfaces final color. Values near 0.0 reduce the shadow contribution to the final color. Values near to 1.0 make occluded surfaces receive almost no directional light. Designed to be used mostly for transitioning between values 0 and 1.
  StyleTransition? shadowIntensityTransition;

  String encode() {
    var properties = <String, dynamic>{};
    if (castShadows != null) {
      properties["cast-shadows"] = castShadows;
    }
    if (color != null) {
      properties["color"] = color?.toRGBA();
    }
    if (colorTransition != null) {
       properties["colorTransition"] = colorTransition?.encode();
    }
    if (direction != null) {
      properties["direction"] = direction;
    }
    if (directionTransition != null) {
       properties["directionTransition"] = directionTransition?.encode();
    }
    if (intensity != null) {
      properties["intensity"] = intensity;
    }
    if (intensityTransition != null) {
       properties["intensityTransition"] = intensityTransition?.encode();
    }
    if (shadowIntensity != null) {
      properties["shadow-intensity"] = shadowIntensity;
    }
    if (shadowIntensityTransition != null) {
       properties["shadow-intensityTransition"] = shadowIntensityTransition?.encode();
    }

    return json.encode(properties);
  }
}

// End of generated file.
