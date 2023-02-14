// This file is generated.
part of mapbox_maps_flutter;

/// A filled polygon with an optional stroked border.
class FillLayer extends Layer {
  FillLayer({
    required id,
    visibility,
    minZoom,
    maxZoom,
    required this.sourceId,
    this.sourceLayer,
    this.fillSortKey,
    this.fillAntialias,
    this.fillColor,
    this.fillOpacity,
    this.fillOutlineColor,
    this.fillPattern,
    this.fillTranslate,
    this.fillTranslateAnchor,
  }) : super(
            id: id, visibility: visibility, maxZoom: maxZoom, minZoom: minZoom);

  @override
  String getType() => "fill";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? fillSortKey;

  /// Whether or not the fill should be antialiased.
  bool? fillAntialias;

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used.
  int? fillColor;

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used.
  double? fillOpacity;

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  int? fillOutlineColor;

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? fillPattern;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  List<double?>? fillTranslate;

  /// Controls the frame of reference for `fill-translate`.
  FillTranslateAnchor? fillTranslateAnchor;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.toString().split('.').last.toLowerCase();
    }
    if (fillSortKey != null) {
      layout["fill-sort-key"] = fillSortKey;
    }
    var paint = {};
    if (fillAntialias != null) {
      paint["fill-antialias"] = fillAntialias;
    }
    if (fillColor != null) {
      paint["fill-color"] = fillColor?.toRGBA();
    }
    if (fillOpacity != null) {
      paint["fill-opacity"] = fillOpacity;
    }
    if (fillOutlineColor != null) {
      paint["fill-outline-color"] = fillOutlineColor?.toRGBA();
    }
    if (fillPattern != null) {
      paint["fill-pattern"] = fillPattern;
    }
    if (fillTranslate != null) {
      paint["fill-translate"] = fillTranslate;
    }
    if (fillTranslateAnchor != null) {
      paint["fill-translate-anchor"] =
          fillTranslateAnchor?.toString().split('.').last.toLowerCase();
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

  static FillLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return FillLayer(
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
      fillSortKey: map["layout"]["fill-sort-key"] is num?
          ? (map["layout"]["fill-sort-key"] as num?)?.toDouble()
          : null,
      fillAntialias: map["paint"]["fill-antialias"],
      fillColor: (map["paint"]["fill-color"] as List?)?.toRGBAInt(),
      fillOpacity: map["paint"]["fill-opacity"] is num?
          ? (map["paint"]["fill-opacity"] as num?)?.toDouble()
          : null,
      fillOutlineColor:
          (map["paint"]["fill-outline-color"] as List?)?.toRGBAInt(),
      fillPattern: map["paint"]["fill-pattern"],
      fillTranslate: (map["paint"]["fill-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      fillTranslateAnchor: map["paint"]["fill-translate-anchor"] == null
          ? null
          : FillTranslateAnchor.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["paint"]["fill-translate-anchor"])),
    );
  }
}

// End of generated file.
