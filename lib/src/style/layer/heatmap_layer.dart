// This file is generated.
part of mapbox_maps_flutter;

/// A heatmap.
class HeatmapLayer extends Layer {
  HeatmapLayer({
    required id,
    visibility,
    minZoom,
    maxZoom,
    required this.sourceId,
    this.sourceLayer,
    this.heatmapColor,
    this.heatmapIntensity,
    this.heatmapOpacity,
    this.heatmapRadius,
    this.heatmapWeight,
  }) : super(
            id: id, visibility: visibility, maxZoom: maxZoom, minZoom: minZoom);

  @override
  String getType() => "heatmap";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Defines the color of each pixel based on its density value in a heatmap.  Should be an expression that uses `["heatmap-density"]` as input.
  int? heatmapColor;

  /// Similar to `heatmap-weight` but controls the intensity of the heatmap globally. Primarily used for adjusting the heatmap based on zoom level.
  double? heatmapIntensity;

  /// The global opacity at which the heatmap layer will be drawn.
  double? heatmapOpacity;

  /// Radius of influence of one heatmap point in pixels. Increasing the value makes the heatmap smoother, but less detailed.
  double? heatmapRadius;

  /// A measure of how much an individual point contributes to the heatmap. A value of 10 would be equivalent to having 10 points of weight 1 in the same spot. Especially useful when combined with clustering.
  double? heatmapWeight;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.toString().split('.').last.toLowerCase();
    }
    var paint = {};
    if (heatmapColor != null) {
      paint["heatmap-color"] = heatmapColor?.toRGBA();
    }
    if (heatmapIntensity != null) {
      paint["heatmap-intensity"] = heatmapIntensity;
    }
    if (heatmapOpacity != null) {
      paint["heatmap-opacity"] = heatmapOpacity;
    }
    if (heatmapRadius != null) {
      paint["heatmap-radius"] = heatmapRadius;
    }
    if (heatmapWeight != null) {
      paint["heatmap-weight"] = heatmapWeight;
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

  static HeatmapLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return HeatmapLayer(
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
      heatmapColor: (map["paint"]["heatmap-color"] as List?)?.toRGBAInt(),
      heatmapIntensity: map["paint"]["heatmap-intensity"] is num?
          ? (map["paint"]["heatmap-intensity"] as num?)?.toDouble()
          : null,
      heatmapOpacity: map["paint"]["heatmap-opacity"] is num?
          ? (map["paint"]["heatmap-opacity"] as num?)?.toDouble()
          : null,
      heatmapRadius: map["paint"]["heatmap-radius"] is num?
          ? (map["paint"]["heatmap-radius"] as num?)?.toDouble()
          : null,
      heatmapWeight: map["paint"]["heatmap-weight"] is num?
          ? (map["paint"]["heatmap-weight"] as num?)?.toDouble()
          : null,
    );
  }
}

// End of generated file.
