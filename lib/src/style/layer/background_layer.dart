// This file is generated.
part of mapbox_maps_flutter;

/// The background color or pattern of the map.
class BackgroundLayer extends Layer {
  BackgroundLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
    double? minZoom,
    double? maxZoom,
    String? slot,
    int? this.backgroundColor,
    List<Object>? this.backgroundColorExpression,
    double? this.backgroundEmissiveStrength,
    List<Object>? this.backgroundEmissiveStrengthExpression,
    double? this.backgroundOpacity,
    List<Object>? this.backgroundOpacityExpression,
    String? this.backgroundPattern,
    List<Object>? this.backgroundPatternExpression,
  }) : super(
            id: id,
            visibility: visibility,
            visibilityExpression: visibilityExpression,
            filter: filter,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "background";

  /// The color with which the background will be drawn.
  /// Default value: "#000000".
  int? backgroundColor;

  /// The color with which the background will be drawn.
  /// Default value: "#000000".
  List<Object>? backgroundColorExpression;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0.
  double? backgroundEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0.
  List<Object>? backgroundEmissiveStrengthExpression;

  /// The opacity at which the background will be drawn.
  /// Default value: 1. Value range: [0, 1]
  double? backgroundOpacity;

  /// The opacity at which the background will be drawn.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? backgroundOpacityExpression;

  /// Name of image in sprite to use for drawing an image background. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? backgroundPattern;

  /// Name of image in sprite to use for drawing an image background. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  List<Object>? backgroundPatternExpression;

  @override
  Future<String> _encode() async {
    var layout = {};
    if (visibilityExpression != null) {
      layout["visibility"] = visibilityExpression!;
    }
    if (visibility != null) {
      layout["visibility"] =
          visibility!.name.toLowerCase().replaceAll("_", "-");
    }

    var paint = {};
    if (backgroundColorExpression != null) {
      paint["background-color"] = backgroundColorExpression;
    }
    if (backgroundColor != null) {
      paint["background-color"] = backgroundColor?.toRGBA();
    }

    if (backgroundEmissiveStrengthExpression != null) {
      paint["background-emissive-strength"] =
          backgroundEmissiveStrengthExpression;
    }
    if (backgroundEmissiveStrength != null) {
      paint["background-emissive-strength"] = backgroundEmissiveStrength;
    }

    if (backgroundOpacityExpression != null) {
      paint["background-opacity"] = backgroundOpacityExpression;
    }
    if (backgroundOpacity != null) {
      paint["background-opacity"] = backgroundOpacity;
    }

    if (backgroundPatternExpression != null) {
      paint["background-pattern"] = backgroundPatternExpression;
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
    if (filter != null) {
      properties["filter"] = filter!;
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
      visibilityExpression: _optionalCastList(map["layout"]["visibility"]),
      filter: _optionalCastList(map["filter"]),
      backgroundColor: (map["paint"]["background-color"] as List?)?.toRGBAInt(),
      backgroundColorExpression:
          _optionalCastList(map["paint"]["background-color"]),
      backgroundEmissiveStrength:
          _optionalCast(map["paint"]["background-emissive-strength"]),
      backgroundEmissiveStrengthExpression:
          _optionalCastList(map["paint"]["background-emissive-strength"]),
      backgroundOpacity: _optionalCast(map["paint"]["background-opacity"]),
      backgroundOpacityExpression:
          _optionalCastList(map["paint"]["background-opacity"]),
      backgroundPattern: _optionalCast(map["paint"]["background-pattern"]),
      backgroundPatternExpression:
          _optionalCastList(map["paint"]["background-pattern"]),
    );
  }
}

// End of generated file.
