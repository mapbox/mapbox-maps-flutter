// This file is generated.
part of mapbox_maps_flutter;

/// The global light source.
/// Check the [online documentation](https://www.mapbox.com/mapbox-gl-style-spec/#light).
class Light {
  Light({
    this.anchor,
    this.color,
    this.colorTransition,
    this.intensity,
    this.intensityTransition,
    this.position,
    this.positionTransition,
  });

  /// Whether extruded geometries are lit relative to the map or viewport.
  Anchor? anchor;

  /// Color tint for lighting extruded geometries.
  int? color;

  /// Color tint for lighting extruded geometries.
  StyleTransition? colorTransition;

  /// Intensity of lighting (on a scale from 0 to 1). Higher numbers will present as more extreme contrast.
  double? intensity;

  /// Intensity of lighting (on a scale from 0 to 1). Higher numbers will present as more extreme contrast.
  StyleTransition? intensityTransition;

  /// Position of the light source relative to lit (extruded) geometries, in [r radial coordinate, a azimuthal angle, p polar angle] where r indicates the distance from the center of the base of an object to its light, a indicates the position of the light relative to 0° (0° when `light.anchor` is set to `viewport` corresponds to the top of the viewport, or 0° when `light.anchor` is set to `map` corresponds to due north, and degrees proceed clockwise), and p indicates the height of the light (from 0°, directly above, to 180°, directly below).
  List<double?>? position;

  /// Position of the light source relative to lit (extruded) geometries, in [r radial coordinate, a azimuthal angle, p polar angle] where r indicates the distance from the center of the base of an object to its light, a indicates the position of the light relative to 0° (0° when `light.anchor` is set to `viewport` corresponds to the top of the viewport, or 0° when `light.anchor` is set to `map` corresponds to due north, and degrees proceed clockwise), and p indicates the height of the light (from 0°, directly above, to 180°, directly below).
  StyleTransition? positionTransition;

  String encode() {
    var properties = <String, dynamic>{};
    if (anchor != null) {
      properties["anchor"] = anchor?.toString().split('.').last.toLowerCase();
    }
    if (color != null) {
      properties["color"] = color?.toRGBA();
    }
    if (colorTransition != null) {
      properties["colorTransition"] = colorTransition?.encode();
    }
    if (intensity != null) {
      properties["intensity"] = intensity;
    }
    if (intensityTransition != null) {
      properties["intensityTransition"] = intensityTransition?.encode();
    }
    if (position != null) {
      properties["position"] = position;
    }
    if (positionTransition != null) {
      properties["positionTransition"] = positionTransition?.encode();
    }

    return json.encode(properties);
  }
}

// End of generated file.
