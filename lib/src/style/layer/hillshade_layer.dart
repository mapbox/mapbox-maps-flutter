// This file is generated.
part of mapbox_maps_flutter;

/// Client-side hillshading visualization based on DEM data. Currently, the implementation only supports Mapbox Terrain RGB and Mapzen Terrarium tiles.
class HillshadeLayer extends Layer {
  HillshadeLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required String this.sourceId,
    String? this.sourceLayer,
    int? this.hillshadeAccentColor,
    List<Object>? this.hillshadeAccentColorExpression,
    double? this.hillshadeEmissiveStrength,
    List<Object>? this.hillshadeEmissiveStrengthExpression,
    double? this.hillshadeExaggeration,
    List<Object>? this.hillshadeExaggerationExpression,
    int? this.hillshadeHighlightColor,
    List<Object>? this.hillshadeHighlightColorExpression,
    HillshadeIlluminationAnchor? this.hillshadeIlluminationAnchor,
    List<Object>? this.hillshadeIlluminationAnchorExpression,
    double? this.hillshadeIlluminationDirection,
    List<Object>? this.hillshadeIlluminationDirectionExpression,
    int? this.hillshadeShadowColor,
    List<Object>? this.hillshadeShadowColorExpression,
  }) : super(
            id: id,
            visibility: visibility,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "hillshade";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// The shading color used to accentuate rugged terrain like sharp cliffs and gorges.
  int? hillshadeAccentColor;

  /// The shading color used to accentuate rugged terrain like sharp cliffs and gorges.
  List<Object>? hillshadeAccentColorExpression;

  /// Controls the intensity of light emitted on the source features.
  double? hillshadeEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  List<Object>? hillshadeEmissiveStrengthExpression;

  /// Intensity of the hillshade
  double? hillshadeExaggeration;

  /// Intensity of the hillshade
  List<Object>? hillshadeExaggerationExpression;

  /// The shading color of areas that faces towards the light source.
  int? hillshadeHighlightColor;

  /// The shading color of areas that faces towards the light source.
  List<Object>? hillshadeHighlightColorExpression;

  /// Direction of light source when map is rotated.
  HillshadeIlluminationAnchor? hillshadeIlluminationAnchor;

  /// Direction of light source when map is rotated.
  List<Object>? hillshadeIlluminationAnchorExpression;

  /// The direction of the light source used to generate the hillshading with 0 as the top of the viewport if `hillshade-illumination-anchor` is set to `viewport` and due north if `hillshade-illumination-anchor` is set to `map` and no 3d lights enabled. If `hillshade-illumination-anchor` is set to `map` and 3d lights enabled, the direction from 3d lights is used instead.
  double? hillshadeIlluminationDirection;

  /// The direction of the light source used to generate the hillshading with 0 as the top of the viewport if `hillshade-illumination-anchor` is set to `viewport` and due north if `hillshade-illumination-anchor` is set to `map` and no 3d lights enabled. If `hillshade-illumination-anchor` is set to `map` and 3d lights enabled, the direction from 3d lights is used instead.
  List<Object>? hillshadeIlluminationDirectionExpression;

  /// The shading color of areas that face away from the light source.
  int? hillshadeShadowColor;

  /// The shading color of areas that face away from the light source.
  List<Object>? hillshadeShadowColorExpression;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.name.toLowerCase().replaceAll("_", "-");
    }
    var paint = {};
    if (hillshadeAccentColorExpression != null) {
      paint["hillshade-accent-color"] = hillshadeAccentColorExpression;
    }
    if (hillshadeAccentColor != null) {
      paint["hillshade-accent-color"] = hillshadeAccentColor?.toRGBA();
    }

    if (hillshadeEmissiveStrengthExpression != null) {
      paint["hillshade-emissive-strength"] =
          hillshadeEmissiveStrengthExpression;
    }
    if (hillshadeEmissiveStrength != null) {
      paint["hillshade-emissive-strength"] = hillshadeEmissiveStrength;
    }

    if (hillshadeExaggerationExpression != null) {
      paint["hillshade-exaggeration"] = hillshadeExaggerationExpression;
    }
    if (hillshadeExaggeration != null) {
      paint["hillshade-exaggeration"] = hillshadeExaggeration;
    }

    if (hillshadeHighlightColorExpression != null) {
      paint["hillshade-highlight-color"] = hillshadeHighlightColorExpression;
    }
    if (hillshadeHighlightColor != null) {
      paint["hillshade-highlight-color"] = hillshadeHighlightColor?.toRGBA();
    }

    if (hillshadeIlluminationAnchorExpression != null) {
      paint["hillshade-illumination-anchor"] =
          hillshadeIlluminationAnchorExpression;
    }
    if (hillshadeIlluminationAnchor != null) {
      paint["hillshade-illumination-anchor"] =
          hillshadeIlluminationAnchor?.name.toLowerCase().replaceAll("_", "-");
    }

    if (hillshadeIlluminationDirectionExpression != null) {
      paint["hillshade-illumination-direction"] =
          hillshadeIlluminationDirectionExpression;
    }
    if (hillshadeIlluminationDirection != null) {
      paint["hillshade-illumination-direction"] =
          hillshadeIlluminationDirection;
    }

    if (hillshadeShadowColorExpression != null) {
      paint["hillshade-shadow-color"] = hillshadeShadowColorExpression;
    }
    if (hillshadeShadowColor != null) {
      paint["hillshade-shadow-color"] = hillshadeShadowColor?.toRGBA();
    }

    var properties = {
      "id": id,
      "source": sourceId,
      "type": getType(),
      "layout": layout,
      "paint": paint,
    };
    if (sourceLayer != null) {
      properties["source-layer"] = sourceLayer!;
    }
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

  static HillshadeLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return HillshadeLayer(
      id: map["id"],
      sourceId: map["source"],
      sourceLayer: map["source-layer"],
      minZoom: map["minzoom"]?.toDouble(),
      maxZoom: map["maxzoom"]?.toDouble(),
      slot: map["slot"],
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["visibility"])),
      hillshadeAccentColor:
          (map["paint"]["hillshade-accent-color"] as List?)?.toRGBAInt(),
      hillshadeAccentColorExpression:
          optionalCast(map["layout"]["hillshade-accent-color"]),
      hillshadeEmissiveStrength:
          optionalCast(map["paint"]["hillshade-emissive-strength"]),
      hillshadeEmissiveStrengthExpression:
          optionalCast(map["layout"]["hillshade-emissive-strength"]),
      hillshadeExaggeration:
          optionalCast(map["paint"]["hillshade-exaggeration"]),
      hillshadeExaggerationExpression:
          optionalCast(map["layout"]["hillshade-exaggeration"]),
      hillshadeHighlightColor:
          (map["paint"]["hillshade-highlight-color"] as List?)?.toRGBAInt(),
      hillshadeHighlightColorExpression:
          optionalCast(map["layout"]["hillshade-highlight-color"]),
      hillshadeIlluminationAnchor:
          map["paint"]["hillshade-illumination-anchor"] == null
              ? null
              : HillshadeIlluminationAnchor.values.firstWhere((e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["paint"]["hillshade-illumination-anchor"])),
      hillshadeIlluminationAnchorExpression:
          optionalCast(map["layout"]["hillshade-illumination-anchor"]),
      hillshadeIlluminationDirection:
          optionalCast(map["paint"]["hillshade-illumination-direction"]),
      hillshadeIlluminationDirectionExpression:
          optionalCast(map["layout"]["hillshade-illumination-direction"]),
      hillshadeShadowColor:
          (map["paint"]["hillshade-shadow-color"] as List?)?.toRGBAInt(),
      hillshadeShadowColorExpression:
          optionalCast(map["layout"]["hillshade-shadow-color"]),
    );
  }
}

// End of generated file.
