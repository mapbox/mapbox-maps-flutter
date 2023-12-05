// This file is generated.
part of mapbox_maps_flutter;

/// An indirect light affecting all objects in the map adding a constant amount of light on them. It has no explicit direction and cannot cast shadows.
/// Check the [online documentation](https://www.mapbox.com/mapbox-gl-style-spec/#light).
class AmbientLight {
  AmbientLight({
    this.id,
    this.color,
    this.colorTransition,
    this.intensity,
    this.intensityTransition,
  });

  final String id;
  final String lightType = "ambient"
  /// Color of the ambient light.
  int? color;
  /// Color of the ambient light.
  StyleTransition? colorTransition;
  /// A multiplier for the color of the ambient light.
  double? intensity;
  /// A multiplier for the color of the ambient light.
  StyleTransition? intensityTransition;

  String encode() {
    var properties = <String, dynamic>{};
    properties["id"] = id;
    properties["type"] = lightType;
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

    return json.encode(properties);
  }
}

// End of generated file.
