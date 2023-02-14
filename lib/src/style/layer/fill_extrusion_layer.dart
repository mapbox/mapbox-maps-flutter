// This file is generated.
part of mapbox_maps_flutter;

/// An extruded (3D) polygon.
class FillExtrusionLayer extends Layer {
  FillExtrusionLayer({
    required id,
    visibility,
    minZoom,
    maxZoom,
    required this.sourceId,
    this.sourceLayer,
    this.fillExtrusionBase,
    this.fillExtrusionColor,
    this.fillExtrusionHeight,
    this.fillExtrusionOpacity,
    this.fillExtrusionPattern,
    this.fillExtrusionTranslate,
    this.fillExtrusionTranslateAnchor,
    this.fillExtrusionVerticalGradient,
  }) : super(
            id: id, visibility: visibility, maxZoom: maxZoom, minZoom: minZoom);

  @override
  String getType() => "fill-extrusion";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// The height with which to extrude the base of this layer. Must be less than or equal to `fill-extrusion-height`.
  double? fillExtrusionBase;

  /// The base color of the extruded fill. The extrusion's surfaces will be shaded differently based on this color in combination with the root `light` settings. If this color is specified as `rgba` with an alpha component, the alpha component will be ignored; use `fill-extrusion-opacity` to set layer opacity.
  int? fillExtrusionColor;

  /// The height with which to extrude this layer.
  double? fillExtrusionHeight;

  /// The opacity of the entire fill extrusion layer. This is rendered on a per-layer, not per-feature, basis, and data-driven styling is not available.
  double? fillExtrusionOpacity;

  /// Name of image in sprite to use for drawing images on extruded fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? fillExtrusionPattern;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up (on the flat plane), respectively.
  List<double?>? fillExtrusionTranslate;

  /// Controls the frame of reference for `fill-extrusion-translate`.
  FillExtrusionTranslateAnchor? fillExtrusionTranslateAnchor;

  /// Whether to apply a vertical gradient to the sides of a fill-extrusion layer. If true, sides will be shaded slightly darker farther down.
  bool? fillExtrusionVerticalGradient;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.toString().split('.').last.toLowerCase();
    }
    var paint = {};
    if (fillExtrusionBase != null) {
      paint["fill-extrusion-base"] = fillExtrusionBase;
    }
    if (fillExtrusionColor != null) {
      paint["fill-extrusion-color"] = fillExtrusionColor?.toRGBA();
    }
    if (fillExtrusionHeight != null) {
      paint["fill-extrusion-height"] = fillExtrusionHeight;
    }
    if (fillExtrusionOpacity != null) {
      paint["fill-extrusion-opacity"] = fillExtrusionOpacity;
    }
    if (fillExtrusionPattern != null) {
      paint["fill-extrusion-pattern"] = fillExtrusionPattern;
    }
    if (fillExtrusionTranslate != null) {
      paint["fill-extrusion-translate"] = fillExtrusionTranslate;
    }
    if (fillExtrusionTranslateAnchor != null) {
      paint["fill-extrusion-translate-anchor"] = fillExtrusionTranslateAnchor
          ?.toString()
          .split('.')
          .last
          .toLowerCase();
    }
    if (fillExtrusionVerticalGradient != null) {
      paint["fill-extrusion-vertical-gradient"] = fillExtrusionVerticalGradient;
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

    return json.encode(properties);
  }

  static FillExtrusionLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return FillExtrusionLayer(
      id: map["id"],
      sourceId: map["source"],
      sourceLayer: map["source-layer"],
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
      fillExtrusionBase: map["paint"]["fill-extrusion-base"] is num?
          ? (map["paint"]["fill-extrusion-base"] as num?)?.toDouble()
          : null,
      fillExtrusionColor:
          (map["paint"]["fill-extrusion-color"] as List?)?.toRGBAInt(),
      fillExtrusionHeight: map["paint"]["fill-extrusion-height"] is num?
          ? (map["paint"]["fill-extrusion-height"] as num?)?.toDouble()
          : null,
      fillExtrusionOpacity: map["paint"]["fill-extrusion-opacity"] is num?
          ? (map["paint"]["fill-extrusion-opacity"] as num?)?.toDouble()
          : null,
      fillExtrusionPattern: map["paint"]["fill-extrusion-pattern"],
      fillExtrusionTranslate:
          (map["paint"]["fill-extrusion-translate"] as List?)
              ?.map<double?>((e) => e.toDouble())
              .toList(),
      fillExtrusionTranslateAnchor:
          map["paint"]["fill-extrusion-translate-anchor"] == null
              ? null
              : FillExtrusionTranslateAnchor.values.firstWhere((e) => e
                  .toString()
                  .split('.')
                  .last
                  .toLowerCase()
                  .contains(map["paint"]["fill-extrusion-translate-anchor"])),
      fillExtrusionVerticalGradient: map["paint"]
          ["fill-extrusion-vertical-gradient"],
    );
  }
}

// End of generated file.
