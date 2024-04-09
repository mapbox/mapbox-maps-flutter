// This file is generated.
part of mapbox_maps_flutter;

/// The background color or pattern of the map.
class BackgroundLayer extends Layer {
  BackgroundLayer({
    required id,
    visibility,
    visibilityAsExpression,
    minZoom,
    maxZoom,
    slot,
    this.backgroundColor,
    this.backgroundColorExpression,
    this.backgroundEmissiveStrength,
    this.backgroundEmissiveStrengthExpression,
    this.backgroundOpacity,
    this.backgroundPattern,
  }) : super(
            id: id,
            visibility: visibility,
            visibilityAsExpression: visibilityAsExpression,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "background";

  /// The color with which the background will be drawn.
  int? backgroundColor;

  /// The color with which the background will be drawn.
  List<Object>? backgroundColorExpression;

  /// Controls the intensity of light emitted on the source features. This property works only with 3D light, i.e. when `lights` root property is defined.
  double? backgroundEmissiveStrength;

  /// Controls the intensity of light emitted on the source features. This property works only with 3D light, i.e. when `lights` root property is defined.
  List<Object>? backgroundEmissiveStrengthExpression;

  /// The opacity at which the background will be drawn.
  double? backgroundOpacity;

  /// Name of image in sprite to use for drawing an image background. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? backgroundPattern;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.toString().split('.').last.toLowerCase();
    }
    var paint = {};
    if (backgroundColor != null) {
      paint["background-color"] = backgroundColor?.toRGBA();
    }
    if (backgroundColorExpression != null) {
      paint["background-color"] = backgroundColorExpression;
    }
    if (backgroundEmissiveStrength != null) {
      paint["background-emissive-strength"] = backgroundEmissiveStrength;
    }
    if (backgroundOpacity != null) {
      paint["background-opacity"] = backgroundOpacity;
    }
    if (backgroundPattern != null) {
      paint["background-pattern"] = backgroundPattern;
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

    return json.encode(properties);
  }

  static BackgroundLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return BackgroundLayer(
      id: map["id"],
      minZoom: map["minzoom"]?.toDouble(),
      maxZoom: map["maxzoom"]?.toDouble(),
      slot: map["slot"],
      visibility: map["layout"]["visibility"] is String
          ? Layer._normalizedVisibilityNames.contains(map["layout"]["visibility"])
          : Visibility.VISIBLE,
      visibilityAsExpression: map["layout"]["visibility"].optionalCast(),
      backgroundColor: (map["paint"]["background-color"] as List?)?.toRGBAInt(),
      backgroundColorExpression: map["paint"]["background-color"].optionalCast(),
      backgroundEmissiveStrength: map["paint"]["background-emissive-strength"].optionalCast(),
      backgroundEmissiveStrengthExpression: map["paint"]["background-emissive-strength"].optionalCast(),
      backgroundOpacity: map["paint"]["background-opacity"] is num?
          ? (map["paint"]["background-opacity"] as num?)?.toDouble()
          : null,
      backgroundPattern: map["paint"]["background-pattern"] is String?
          ? map["paint"]["background-pattern"] as String?
          : null,
    );
  }
}

extension on dynamic {
  T? optionalCast<T>() => this is T ? this : null;
}
// End of generated file.
