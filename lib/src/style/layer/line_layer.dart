// This file is generated.
part of mapbox_maps_flutter;

/// A stroked line.
class LineLayer extends Layer {
  LineLayer({
    required id,
    visibility,
    minZoom,
    maxZoom,
    required this.sourceId,
    this.sourceLayer,
    this.lineCap,
    this.lineJoin,
    this.lineMiterLimit,
    this.lineRoundLimit,
    this.lineSortKey,
    this.lineBlur,
    this.lineColor,
    this.lineDasharray,
    this.lineGapWidth,
    this.lineGradient,
    this.lineOffset,
    this.lineOpacity,
    this.linePattern,
    this.lineTranslate,
    this.lineTranslateAnchor,
    this.lineTrimOffset,
    this.lineWidth,
  }) : super(
            id: id, visibility: visibility, maxZoom: maxZoom, minZoom: minZoom);

  @override
  String getType() => "line";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// The display of line endings.
  LineCap? lineCap;

  /// The display of lines when joining.
  LineJoin? lineJoin;

  /// Used to automatically convert miter joins to bevel joins for sharp angles.
  double? lineMiterLimit;

  /// Used to automatically convert round joins to miter joins for shallow angles.
  double? lineRoundLimit;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? lineSortKey;

  /// Blur applied to the line, in pixels.
  double? lineBlur;

  /// The color with which the line will be drawn.
  int? lineColor;

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  List<double?>? lineDasharray;

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap.
  double? lineGapWidth;

  /// Defines a gradient with which to color a line feature. Can only be used with GeoJSON sources that specify `"lineMetrics": true`.
  int? lineGradient;

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset.
  double? lineOffset;

  /// The opacity at which the line will be drawn.
  double? lineOpacity;

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? linePattern;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  List<double?>? lineTranslate;

  /// Controls the frame of reference for `line-translate`.
  LineTranslateAnchor? lineTranslateAnchor;

  /// The line trim-off percentage range based on the whole line gradinet range [0.0, 1.0]. The line part between [trim-start, trim-end] will be marked as transparent to make a route vanishing effect. If either 'trim-start' or 'trim-end' offset is out of valid range, the default range will be set.
  List<double?>? lineTrimOffset;

  /// Stroke thickness.
  double? lineWidth;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.toString().split('.').last.toLowerCase();
    }
    if (lineCap != null) {
      layout["line-cap"] = lineCap?.toString().split('.').last.toLowerCase();
    }
    if (lineJoin != null) {
      layout["line-join"] = lineJoin?.toString().split('.').last.toLowerCase();
    }
    if (lineMiterLimit != null) {
      layout["line-miter-limit"] = lineMiterLimit;
    }
    if (lineRoundLimit != null) {
      layout["line-round-limit"] = lineRoundLimit;
    }
    if (lineSortKey != null) {
      layout["line-sort-key"] = lineSortKey;
    }
    var paint = {};
    if (lineBlur != null) {
      paint["line-blur"] = lineBlur;
    }
    if (lineColor != null) {
      paint["line-color"] = lineColor?.toRGBA();
    }
    if (lineDasharray != null) {
      paint["line-dasharray"] = lineDasharray;
    }
    if (lineGapWidth != null) {
      paint["line-gap-width"] = lineGapWidth;
    }
    if (lineGradient != null) {
      paint["line-gradient"] = lineGradient?.toRGBA();
    }
    if (lineOffset != null) {
      paint["line-offset"] = lineOffset;
    }
    if (lineOpacity != null) {
      paint["line-opacity"] = lineOpacity;
    }
    if (linePattern != null) {
      paint["line-pattern"] = linePattern;
    }
    if (lineTranslate != null) {
      paint["line-translate"] = lineTranslate;
    }
    if (lineTranslateAnchor != null) {
      paint["line-translate-anchor"] =
          lineTranslateAnchor?.toString().split('.').last.toLowerCase();
    }
    if (lineTrimOffset != null) {
      paint["line-trim-offset"] = lineTrimOffset;
    }
    if (lineWidth != null) {
      paint["line-width"] = lineWidth;
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

  static LineLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return LineLayer(
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
      lineCap: map["layout"]["line-cap"] == null
          ? null
          : LineCap.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["line-cap"])),
      lineJoin: map["layout"]["line-join"] == null
          ? null
          : LineJoin.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["line-join"])),
      lineMiterLimit: map["layout"]["line-miter-limit"] is num?
          ? (map["layout"]["line-miter-limit"] as num?)?.toDouble()
          : null,
      lineRoundLimit: map["layout"]["line-round-limit"] is num?
          ? (map["layout"]["line-round-limit"] as num?)?.toDouble()
          : null,
      lineSortKey: map["layout"]["line-sort-key"] is num?
          ? (map["layout"]["line-sort-key"] as num?)?.toDouble()
          : null,
      lineBlur: map["paint"]["line-blur"] is num?
          ? (map["paint"]["line-blur"] as num?)?.toDouble()
          : null,
      lineColor: (map["paint"]["line-color"] as List?)?.toRGBAInt(),
      lineDasharray: (map["paint"]["line-dasharray"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      lineGapWidth: map["paint"]["line-gap-width"] is num?
          ? (map["paint"]["line-gap-width"] as num?)?.toDouble()
          : null,
      lineGradient: (map["paint"]["line-gradient"] as List?)?.toRGBAInt(),
      lineOffset: map["paint"]["line-offset"] is num?
          ? (map["paint"]["line-offset"] as num?)?.toDouble()
          : null,
      lineOpacity: map["paint"]["line-opacity"] is num?
          ? (map["paint"]["line-opacity"] as num?)?.toDouble()
          : null,
      linePattern: map["paint"]["line-pattern"],
      lineTranslate: (map["paint"]["line-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      lineTranslateAnchor: map["paint"]["line-translate-anchor"] == null
          ? null
          : LineTranslateAnchor.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["paint"]["line-translate-anchor"])),
      lineTrimOffset: (map["paint"]["line-trim-offset"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      lineWidth: map["paint"]["line-width"] is num?
          ? (map["paint"]["line-width"] as num?)?.toDouble()
          : null,
    );
  }
}

// End of generated file.
