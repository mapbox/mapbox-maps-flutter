// This file is generated.
part of mapbox_maps_flutter;

/// A filled circle.
class CircleLayer extends Layer {
  CircleLayer({
    required id,
    visibility,
    minZoom,
    maxZoom,
    required this.sourceId,
    this.sourceLayer,
    this.circleSortKey,
    this.circleBlur,
    this.circleColor,
    this.circleOpacity,
    this.circlePitchAlignment,
    this.circlePitchScale,
    this.circleRadius,
    this.circleStrokeColor,
    this.circleStrokeOpacity,
    this.circleStrokeWidth,
    this.circleTranslate,
    this.circleTranslateAnchor,
  }) : super(
            id: id, visibility: visibility, maxZoom: maxZoom, minZoom: minZoom);

  @override
  String getType() => "circle";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? circleSortKey;

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity.
  double? circleBlur;

  /// The fill color of the circle.
  int? circleColor;

  /// The opacity at which the circle will be drawn.
  double? circleOpacity;

  /// Orientation of circle when map is pitched.
  CirclePitchAlignment? circlePitchAlignment;

  /// Controls the scaling behavior of the circle when the map is pitched.
  CirclePitchScale? circlePitchScale;

  /// Circle radius.
  double? circleRadius;

  /// The stroke color of the circle.
  int? circleStrokeColor;

  /// The opacity of the circle's stroke.
  double? circleStrokeOpacity;

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`.
  double? circleStrokeWidth;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  List<double?>? circleTranslate;

  /// Controls the frame of reference for `circle-translate`.
  CircleTranslateAnchor? circleTranslateAnchor;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.toString().split('.').last.toLowerCase();
    }
    if (circleSortKey != null) {
      layout["circle-sort-key"] = circleSortKey;
    }
    var paint = {};
    if (circleBlur != null) {
      paint["circle-blur"] = circleBlur;
    }
    if (circleColor != null) {
      paint["circle-color"] = circleColor?.toRGBA();
    }
    if (circleOpacity != null) {
      paint["circle-opacity"] = circleOpacity;
    }
    if (circlePitchAlignment != null) {
      paint["circle-pitch-alignment"] =
          circlePitchAlignment?.toString().split('.').last.toLowerCase();
    }
    if (circlePitchScale != null) {
      paint["circle-pitch-scale"] =
          circlePitchScale?.toString().split('.').last.toLowerCase();
    }
    if (circleRadius != null) {
      paint["circle-radius"] = circleRadius;
    }
    if (circleStrokeColor != null) {
      paint["circle-stroke-color"] = circleStrokeColor?.toRGBA();
    }
    if (circleStrokeOpacity != null) {
      paint["circle-stroke-opacity"] = circleStrokeOpacity;
    }
    if (circleStrokeWidth != null) {
      paint["circle-stroke-width"] = circleStrokeWidth;
    }
    if (circleTranslate != null) {
      paint["circle-translate"] = circleTranslate;
    }
    if (circleTranslateAnchor != null) {
      paint["circle-translate-anchor"] =
          circleTranslateAnchor?.toString().split('.').last.toLowerCase();
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

  static CircleLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return CircleLayer(
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
      circleSortKey: map["layout"]["circle-sort-key"] is num?
          ? (map["layout"]["circle-sort-key"] as num?)?.toDouble()
          : null,
      circleBlur: map["paint"]["circle-blur"] is num?
          ? (map["paint"]["circle-blur"] as num?)?.toDouble()
          : null,
      circleColor: (map["paint"]["circle-color"] as List?)?.toRGBAInt(),
      circleOpacity: map["paint"]["circle-opacity"] is num?
          ? (map["paint"]["circle-opacity"] as num?)?.toDouble()
          : null,
      circlePitchAlignment: map["paint"]["circle-pitch-alignment"] == null
          ? null
          : CirclePitchAlignment.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["paint"]["circle-pitch-alignment"])),
      circlePitchScale: map["paint"]["circle-pitch-scale"] == null
          ? null
          : CirclePitchScale.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["paint"]["circle-pitch-scale"])),
      circleRadius: map["paint"]["circle-radius"] is num?
          ? (map["paint"]["circle-radius"] as num?)?.toDouble()
          : null,
      circleStrokeColor:
          (map["paint"]["circle-stroke-color"] as List?)?.toRGBAInt(),
      circleStrokeOpacity: map["paint"]["circle-stroke-opacity"] is num?
          ? (map["paint"]["circle-stroke-opacity"] as num?)?.toDouble()
          : null,
      circleStrokeWidth: map["paint"]["circle-stroke-width"] is num?
          ? (map["paint"]["circle-stroke-width"] as num?)?.toDouble()
          : null,
      circleTranslate: (map["paint"]["circle-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      circleTranslateAnchor: map["paint"]["circle-translate-anchor"] == null
          ? null
          : CircleTranslateAnchor.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["paint"]["circle-translate-anchor"])),
    );
  }
}

// End of generated file.
