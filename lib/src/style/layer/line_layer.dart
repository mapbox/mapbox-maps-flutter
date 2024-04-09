// This file is generated.
part of mapbox_maps_flutter;

/// A stroked line.
class LineLayer extends Layer {
  LineLayer({
    required String id,
    Visibility? visibility,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required this.sourceId,
    this.sourceLayer,
    this.lineCap,
    this.lineJoin,
    this.lineMiterLimit,
    this.lineRoundLimit,
    this.lineSortKey,
    this.lineBlur,
    this.lineBorderColor,
    this.lineBorderWidth,
    this.lineColor,
    this.lineDasharray,
    this.lineDepthOcclusionFactor,
    this.lineEmissiveStrength,
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
            id: id,
            visibility: visibility,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

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

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color.
  int? lineBorderColor;

  /// The width of the line border. A value of zero means no border.
  double? lineBorderWidth;

  /// The color with which the line will be drawn.
  int? lineColor;

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  List<double?>? lineDasharray;

  /// Decrease line layer opacity based on occlusion from 3D objects. Value 0 disables occlusion, value 1 means fully occluded.
  double? lineDepthOcclusionFactor;

  /// Controls the intensity of light emitted on the source features.
  double? lineEmissiveStrength;

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap.
  double? lineGapWidth;

  /// A gradient used to color a line feature at various distances along its length. Defined using a `step` or `interpolate` expression which outputs a color for each corresponding `line-progress` input value. `line-progress` is a percentage of the line feature's total length as measured on the webmercator projected coordinate plane (a `number` between `0` and `1`). Can only be used with GeoJSON sources that specify `"lineMetrics": true`.
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

  /// The line part between [trim-start, trim-end] will be marked as transparent to make a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0].
  List<double?>? lineTrimOffset;

  /// Stroke thickness.
  double? lineWidth;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.name.toLowerCase().replaceAll("_", "-");
    }
    if (lineCap != null) {
      layout["line-cap"] = lineCap?.name.toLowerCase().replaceAll("_", "-");
    }
    if (lineJoin != null) {
      layout["line-join"] = lineJoin?.name.toLowerCase().replaceAll("_", "-");
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
    if (lineBorderColor != null) {
      paint["line-border-color"] = lineBorderColor?.toRGBA();
    }
    if (lineBorderWidth != null) {
      paint["line-border-width"] = lineBorderWidth;
    }
    if (lineColor != null) {
      paint["line-color"] = lineColor?.toRGBA();
    }
    if (lineDasharray != null) {
      paint["line-dasharray"] = lineDasharray;
    }
    if (lineDepthOcclusionFactor != null) {
      paint["line-depth-occlusion-factor"] = lineDepthOcclusionFactor;
    }
    if (lineEmissiveStrength != null) {
      paint["line-emissive-strength"] = lineEmissiveStrength;
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
          lineTranslateAnchor?.name.toLowerCase().replaceAll("_", "-");
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
    if (slot != null) {
      properties["slot"] = slot!;
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
      slot: map["slot"],
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["visibility"])),
      lineCap: map["layout"]["line-cap"] == null
          ? null
          : LineCap.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["line-cap"])),
      lineJoin: map["layout"]["line-join"] == null
          ? null
          : LineJoin.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
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
      lineBorderColor:
          (map["paint"]["line-border-color"] as List?)?.toRGBAInt(),
      lineBorderWidth: map["paint"]["line-border-width"] is num?
          ? (map["paint"]["line-border-width"] as num?)?.toDouble()
          : null,
      lineColor: (map["paint"]["line-color"] as List?)?.toRGBAInt(),
      lineDasharray: (map["paint"]["line-dasharray"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      lineDepthOcclusionFactor: map["paint"]["line-depth-occlusion-factor"]
              is num?
          ? (map["paint"]["line-depth-occlusion-factor"] as num?)?.toDouble()
          : null,
      lineEmissiveStrength: map["paint"]["line-emissive-strength"] is num?
          ? (map["paint"]["line-emissive-strength"] as num?)?.toDouble()
          : null,
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
      linePattern: map["paint"]["line-pattern"] is String?
          ? map["paint"]["line-pattern"] as String?
          : null,
      lineTranslate: (map["paint"]["line-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      lineTranslateAnchor: map["paint"]["line-translate-anchor"] == null
          ? null
          : LineTranslateAnchor.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
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
