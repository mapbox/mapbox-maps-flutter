// This file is generated.
part of mapbox_maps_flutter;

/// The background color or pattern of the map.
class BackgroundLayer extends Layer {
  BackgroundLayer({
    required String id,
    Visibility? visibility,
    double? minZoom,
    double? maxZoom,
    String? slot,
    this.backgroundColor,
    this.backgroundEmissiveStrength,
    this.backgroundOpacity,
    this.backgroundPattern,
  }) : super(
            id: id,
            visibility: visibility,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "background";

  /// The color with which the background will be drawn.
  int? backgroundColor;

  /// Controls the intensity of light emitted on the source features.
  double? backgroundEmissiveStrength;

  /// The opacity at which the background will be drawn.
  double? backgroundOpacity;

  /// Name of image in sprite to use for drawing an image background. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? backgroundPattern;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.name.toLowerCase().replaceAll("_", "-");
    }
    var paint = {};
    if (backgroundColor != null) {
      paint["background-color"] = backgroundColor?.toRGBA();
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
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["visibility"])),
      backgroundColor: (map["paint"]["background-color"] as List?)?.toRGBAInt(),
      backgroundEmissiveStrength: map["paint"]["background-emissive-strength"]
              is num?
          ? (map["paint"]["background-emissive-strength"] as num?)?.toDouble()
          : null,
      backgroundOpacity: map["paint"]["background-opacity"] is num?
          ? (map["paint"]["background-opacity"] as num?)?.toDouble()
          : null,
      backgroundPattern: map["paint"]["background-pattern"] is String?
          ? map["paint"]["background-pattern"] as String?
          : null,
    );
  }
}

// End of generated file.
