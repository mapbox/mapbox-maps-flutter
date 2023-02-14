// This file is generated.
part of mapbox_maps_flutter;

/// The background color or pattern of the map.
class BackgroundLayer extends Layer {
  BackgroundLayer({
    required id,
    visibility,
    minZoom,
    maxZoom,
    this.backgroundColor,
    this.backgroundOpacity,
    this.backgroundPattern,
  }) : super(
            id: id, visibility: visibility, maxZoom: maxZoom, minZoom: minZoom);

  @override
  String getType() => "background";

  /// The color with which the background will be drawn.
  int? backgroundColor;

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
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["visibility"])),
      backgroundColor: (map["paint"]["background-color"] as List?)?.toRGBAInt(),
      backgroundOpacity: map["paint"]["background-opacity"] is num?
          ? (map["paint"]["background-opacity"] as num?)?.toDouble()
          : null,
      backgroundPattern: map["paint"]["background-pattern"],
    );
  }
}

// End of generated file.
