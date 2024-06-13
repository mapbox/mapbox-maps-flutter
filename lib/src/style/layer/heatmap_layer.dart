// This file is generated.
part of mapbox_maps_flutter;

/// A heatmap.
class HeatmapLayer extends Layer {
  HeatmapLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required String this.sourceId,
    String? this.sourceLayer,
    int? this.heatmapColor,
    List<Object>? this.heatmapColorExpression,
    double? this.heatmapIntensity,
    List<Object>? this.heatmapIntensityExpression,
    double? this.heatmapOpacity,
    List<Object>? this.heatmapOpacityExpression,
    double? this.heatmapRadius,
    List<Object>? this.heatmapRadiusExpression,
    double? this.heatmapWeight,
    List<Object>? this.heatmapWeightExpression,
  }) : super(
            id: id,
            visibility: visibility,
            visibilityExpression: visibilityExpression,
            filter: filter,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "heatmap";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Defines the color of each pixel based on its density value in a heatmap. Should be an expression that uses `["heatmap-density"]` as input.
  int? heatmapColor;

  /// Defines the color of each pixel based on its density value in a heatmap. Should be an expression that uses `["heatmap-density"]` as input.
  List<Object>? heatmapColorExpression;

  /// Similar to `heatmap-weight` but controls the intensity of the heatmap globally. Primarily used for adjusting the heatmap based on zoom level.
  double? heatmapIntensity;

  /// Similar to `heatmap-weight` but controls the intensity of the heatmap globally. Primarily used for adjusting the heatmap based on zoom level.
  List<Object>? heatmapIntensityExpression;

  /// The global opacity at which the heatmap layer will be drawn.
  double? heatmapOpacity;

  /// The global opacity at which the heatmap layer will be drawn.
  List<Object>? heatmapOpacityExpression;

  /// Radius of influence of one heatmap point in pixels. Increasing the value makes the heatmap smoother, but less detailed. `queryRenderedFeatures` on heatmap layers will return points within this radius.
  double? heatmapRadius;

  /// Radius of influence of one heatmap point in pixels. Increasing the value makes the heatmap smoother, but less detailed. `queryRenderedFeatures` on heatmap layers will return points within this radius.
  List<Object>? heatmapRadiusExpression;

  /// A measure of how much an individual point contributes to the heatmap. A value of 10 would be equivalent to having 10 points of weight 1 in the same spot. Especially useful when combined with clustering.
  double? heatmapWeight;

  /// A measure of how much an individual point contributes to the heatmap. A value of 10 would be equivalent to having 10 points of weight 1 in the same spot. Especially useful when combined with clustering.
  List<Object>? heatmapWeightExpression;

  @override
  String _encode() {
    var layout = {};
    if (visibilityExpression != null) {
      layout["visibility"] = visibilityExpression!;
    }
    if (visibility != null) {
      layout["visibility"] =
          visibility!.name.toLowerCase().replaceAll("_", "-");
    }

    var paint = {};
    if (heatmapColorExpression != null) {
      paint["heatmap-color"] = heatmapColorExpression;
    }
    if (heatmapColor != null) {
      paint["heatmap-color"] = heatmapColor?.toRGBA();
    }

    if (heatmapIntensityExpression != null) {
      paint["heatmap-intensity"] = heatmapIntensityExpression;
    }
    if (heatmapIntensity != null) {
      paint["heatmap-intensity"] = heatmapIntensity;
    }

    if (heatmapOpacityExpression != null) {
      paint["heatmap-opacity"] = heatmapOpacityExpression;
    }
    if (heatmapOpacity != null) {
      paint["heatmap-opacity"] = heatmapOpacity;
    }

    if (heatmapRadiusExpression != null) {
      paint["heatmap-radius"] = heatmapRadiusExpression;
    }
    if (heatmapRadius != null) {
      paint["heatmap-radius"] = heatmapRadius;
    }

    if (heatmapWeightExpression != null) {
      paint["heatmap-weight"] = heatmapWeightExpression;
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
    if (slot != null) {
      properties["slot"] = slot!;
    }
    if (filter != null) {
      properties["filter"] = filter!;
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
      slot: map["slot"],
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["visibility"])),
      visibilityExpression: _optionalCastList(map["layout"]["visibility"]),
      filter: _optionalCastList(map["filter"]),
      heatmapColor: (map["paint"]["heatmap-color"] as List?)?.toRGBAInt(),
      heatmapColorExpression: _optionalCastList(map["paint"]["heatmap-color"]),
      heatmapIntensity: _optionalCast(map["paint"]["heatmap-intensity"]),
      heatmapIntensityExpression:
          _optionalCastList(map["paint"]["heatmap-intensity"]),
      heatmapOpacity: _optionalCast(map["paint"]["heatmap-opacity"]),
      heatmapOpacityExpression:
          _optionalCastList(map["paint"]["heatmap-opacity"]),
      heatmapRadius: _optionalCast(map["paint"]["heatmap-radius"]),
      heatmapRadiusExpression:
          _optionalCastList(map["paint"]["heatmap-radius"]),
      heatmapWeight: _optionalCast(map["paint"]["heatmap-weight"]),
      heatmapWeightExpression:
          _optionalCastList(map["paint"]["heatmap-weight"]),
    );
  }
}

// End of generated file.
