// This file is generated.
part of mapbox_maps_flutter;

/// Client-side hillshading visualization based on DEM data. Currently, the implementation only supports Mapbox Terrain RGB and Mapzen Terrarium tiles.
class HillshadeLayer extends Layer {
  HillshadeLayer({
    required String id,
    Visibility? visibility,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required this.sourceId,
    this.sourceLayer,
    this.hillshadeAccentColor,
    this.hillshadeEmissiveStrength,
    this.hillshadeExaggeration,
    this.hillshadeHighlightColor,
    this.hillshadeIlluminationAnchor,
    this.hillshadeIlluminationDirection,
    this.hillshadeShadowColor,
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

  /// Controls the intensity of light emitted on the source features.
  double? hillshadeEmissiveStrength;

  /// Intensity of the hillshade
  double? hillshadeExaggeration;

  /// The shading color of areas that faces towards the light source.
  int? hillshadeHighlightColor;

  /// Direction of light source when map is rotated.
  HillshadeIlluminationAnchor? hillshadeIlluminationAnchor;

  /// The direction of the light source used to generate the hillshading with 0 as the top of the viewport if `hillshade-illumination-anchor` is set to `viewport` and due north if `hillshade-illumination-anchor` is set to `map` and no 3d lights enabled. If `hillshade-illumination-anchor` is set to `map` and 3d lights enabled, the direction from 3d lights is used instead.
  double? hillshadeIlluminationDirection;

  /// The shading color of areas that face away from the light source.
  int? hillshadeShadowColor;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.name.toLowerCase().replaceAll("_", "-");
    }
    var paint = {};
    if (hillshadeAccentColor != null) {
      paint["hillshade-accent-color"] = hillshadeAccentColor?.toRGBA();
    }
    if (hillshadeEmissiveStrength != null) {
      paint["hillshade-emissive-strength"] = hillshadeEmissiveStrength;
    }
    if (hillshadeExaggeration != null) {
      paint["hillshade-exaggeration"] = hillshadeExaggeration;
    }
    if (hillshadeHighlightColor != null) {
      paint["hillshade-highlight-color"] = hillshadeHighlightColor?.toRGBA();
    }
    if (hillshadeIlluminationAnchor != null) {
      paint["hillshade-illumination-anchor"] =
          hillshadeIlluminationAnchor?.name.toLowerCase().replaceAll("_", "-");
    }
    if (hillshadeIlluminationDirection != null) {
      paint["hillshade-illumination-direction"] =
          hillshadeIlluminationDirection;
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
      hillshadeEmissiveStrength: map["paint"]["hillshade-emissive-strength"]
              is num?
          ? (map["paint"]["hillshade-emissive-strength"] as num?)?.toDouble()
          : null,
      hillshadeExaggeration: map["paint"]["hillshade-exaggeration"] is num?
          ? (map["paint"]["hillshade-exaggeration"] as num?)?.toDouble()
          : null,
      hillshadeHighlightColor:
          (map["paint"]["hillshade-highlight-color"] as List?)?.toRGBAInt(),
      hillshadeIlluminationAnchor:
          map["paint"]["hillshade-illumination-anchor"] == null
              ? null
              : HillshadeIlluminationAnchor.values.firstWhere((e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["paint"]["hillshade-illumination-anchor"])),
      hillshadeIlluminationDirection:
          map["paint"]["hillshade-illumination-direction"] is num?
              ? (map["paint"]["hillshade-illumination-direction"] as num?)
                  ?.toDouble()
              : null,
      hillshadeShadowColor:
          (map["paint"]["hillshade-shadow-color"] as List?)?.toRGBAInt(),
    );
  }
}

// End of generated file.
