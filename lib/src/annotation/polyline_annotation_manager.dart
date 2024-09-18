// This file is generated.
part of mapbox_maps_flutter;

/// The PolylineAnnotationManager to add/update/delete PolylineAnnotationAnnotations on the map.
class PolylineAnnotationManager extends BaseAnnotationManager {
  PolylineAnnotationManager(
      {required String id, required BinaryMessenger messenger})
      : super(id: id, messenger: messenger);

  late _PolylineAnnotationMessenger messenger =
      _PolylineAnnotationMessenger(binaryMessenger: _messenger);

  /// Add a listener to receive the callback when an annotation is clicked.
  void addOnPolylineAnnotationClickListener(
      OnPolylineAnnotationClickListener listener) {
    OnPolylineAnnotationClickListener.setUp(listener,
        binaryMessenger: _messenger);
  }

  /// Create a new annotation with the option.
  Future<PolylineAnnotation> create(PolylineAnnotationOptions annotation) =>
      messenger.create(id, annotation);

  /// Create multi annotations with the options.
  Future<List<PolylineAnnotation?>> createMulti(
          List<PolylineAnnotationOptions> annotations) =>
      messenger.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  Future<void> update(PolylineAnnotation annotation) =>
      messenger.update(id, annotation);

  /// Delete an added annotation.
  Future<void> delete(PolylineAnnotation annotation) =>
      messenger.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => messenger.deleteAll(id);

  /// The display of line endings. Default value: "butt".
  Future<void> setLineCap(LineCap lineCap) => messenger.setLineCap(id, lineCap);

  /// The display of line endings. Default value: "butt".
  Future<LineCap?> getLineCap() => messenger.getLineCap(id);

  /// The display of lines when joining. Default value: "miter".
  Future<void> setLineJoin(LineJoin lineJoin) =>
      messenger.setLineJoin(id, lineJoin);

  /// The display of lines when joining. Default value: "miter".
  Future<LineJoin?> getLineJoin() => messenger.getLineJoin(id);

  /// Used to automatically convert miter joins to bevel joins for sharp angles. Default value: 2.
  Future<void> setLineMiterLimit(double lineMiterLimit) =>
      messenger.setLineMiterLimit(id, lineMiterLimit);

  /// Used to automatically convert miter joins to bevel joins for sharp angles. Default value: 2.
  Future<double?> getLineMiterLimit() => messenger.getLineMiterLimit(id);

  /// Used to automatically convert round joins to miter joins for shallow angles. Default value: 1.05.
  Future<void> setLineRoundLimit(double lineRoundLimit) =>
      messenger.setLineRoundLimit(id, lineRoundLimit);

  /// Used to automatically convert round joins to miter joins for shallow angles. Default value: 1.05.
  Future<double?> getLineRoundLimit() => messenger.getLineRoundLimit(id);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<void> setLineSortKey(double lineSortKey) =>
      messenger.setLineSortKey(id, lineSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<double?> getLineSortKey() => messenger.getLineSortKey(id);

  /// Vertical offset from ground, in meters. Defaults to 0. Not supported for globe projection at the moment.
  Future<void> setLineZOffset(double lineZOffset) =>
      messenger.setLineZOffset(id, lineZOffset);

  /// Vertical offset from ground, in meters. Defaults to 0. Not supported for globe projection at the moment.
  Future<double?> getLineZOffset() => messenger.getLineZOffset(id);

  /// Blur applied to the line, in pixels. Default value: 0. Minimum value: 0.
  Future<void> setLineBlur(double lineBlur) =>
      messenger.setLineBlur(id, lineBlur);

  /// Blur applied to the line, in pixels. Default value: 0. Minimum value: 0.
  Future<double?> getLineBlur() => messenger.getLineBlur(id);

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color. Default value: "rgba(0, 0, 0, 0)".
  Future<void> setLineBorderColor(int lineBorderColor) =>
      messenger.setLineBorderColor(id, lineBorderColor);

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color. Default value: "rgba(0, 0, 0, 0)".
  Future<int?> getLineBorderColor() => messenger.getLineBorderColor(id);

  /// The width of the line border. A value of zero means no border. Default value: 0. Minimum value: 0.
  Future<void> setLineBorderWidth(double lineBorderWidth) =>
      messenger.setLineBorderWidth(id, lineBorderWidth);

  /// The width of the line border. A value of zero means no border. Default value: 0. Minimum value: 0.
  Future<double?> getLineBorderWidth() => messenger.getLineBorderWidth(id);

  /// The color with which the line will be drawn. Default value: "#000000".
  Future<void> setLineColor(int lineColor) =>
      messenger.setLineColor(id, lineColor);

  /// The color with which the line will be drawn. Default value: "#000000".
  Future<int?> getLineColor() => messenger.getLineColor(id);

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels. Minimum value: 0.
  Future<void> setLineDasharray(List<double?> lineDasharray) =>
      messenger.setLineDasharray(id, lineDasharray);

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels. Minimum value: 0.
  Future<List<double?>?> getLineDasharray() => messenger.getLineDasharray(id);

  /// Decrease line layer opacity based on occlusion from 3D objects. Value 0 disables occlusion, value 1 means fully occluded. Default value: 1. Value range: [0, 1]
  Future<void> setLineDepthOcclusionFactor(double lineDepthOcclusionFactor) =>
      messenger.setLineDepthOcclusionFactor(id, lineDepthOcclusionFactor);

  /// Decrease line layer opacity based on occlusion from 3D objects. Value 0 disables occlusion, value 1 means fully occluded. Default value: 1. Value range: [0, 1]
  Future<double?> getLineDepthOcclusionFactor() =>
      messenger.getLineDepthOcclusionFactor(id);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0.
  Future<void> setLineEmissiveStrength(double lineEmissiveStrength) =>
      messenger.setLineEmissiveStrength(id, lineEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0.
  Future<double?> getLineEmissiveStrength() =>
      messenger.getLineEmissiveStrength(id);

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap. Default value: 0. Minimum value: 0.
  Future<void> setLineGapWidth(double lineGapWidth) =>
      messenger.setLineGapWidth(id, lineGapWidth);

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap. Default value: 0. Minimum value: 0.
  Future<double?> getLineGapWidth() => messenger.getLineGapWidth(id);

  /// Opacity multiplier (multiplies line-opacity value) of the line part that is occluded by 3D objects. Value 0 hides occluded part, value 1 means the same opacity as non-occluded part. The property is not supported when `line-opacity` has data-driven styling. Default value: 0. Value range: [0, 1]
  Future<void> setLineOcclusionOpacity(double lineOcclusionOpacity) =>
      messenger.setLineOcclusionOpacity(id, lineOcclusionOpacity);

  /// Opacity multiplier (multiplies line-opacity value) of the line part that is occluded by 3D objects. Value 0 hides occluded part, value 1 means the same opacity as non-occluded part. The property is not supported when `line-opacity` has data-driven styling. Default value: 0. Value range: [0, 1]
  Future<double?> getLineOcclusionOpacity() =>
      messenger.getLineOcclusionOpacity(id);

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset. Default value: 0.
  Future<void> setLineOffset(double lineOffset) =>
      messenger.setLineOffset(id, lineOffset);

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset. Default value: 0.
  Future<double?> getLineOffset() => messenger.getLineOffset(id);

  /// The opacity at which the line will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setLineOpacity(double lineOpacity) =>
      messenger.setLineOpacity(id, lineOpacity);

  /// The opacity at which the line will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getLineOpacity() => messenger.getLineOpacity(id);

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<void> setLinePattern(String linePattern) =>
      messenger.setLinePattern(id, linePattern);

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<String?> getLinePattern() => messenger.getLinePattern(id);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0].
  Future<void> setLineTranslate(List<double?> lineTranslate) =>
      messenger.setLineTranslate(id, lineTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0].
  Future<List<double?>?> getLineTranslate() => messenger.getLineTranslate(id);

  /// Controls the frame of reference for `line-translate`. Default value: "map".
  Future<void> setLineTranslateAnchor(
          LineTranslateAnchor lineTranslateAnchor) =>
      messenger.setLineTranslateAnchor(id, lineTranslateAnchor);

  /// Controls the frame of reference for `line-translate`. Default value: "map".
  Future<LineTranslateAnchor?> getLineTranslateAnchor() =>
      messenger.getLineTranslateAnchor(id);

  /// The color to be used for rendering the trimmed line section that is defined by the `line-trim-offset` property. Default value: "transparent".
  Future<void> setLineTrimColor(int lineTrimColor) =>
      messenger.setLineTrimColor(id, lineTrimColor);

  /// The color to be used for rendering the trimmed line section that is defined by the `line-trim-offset` property. Default value: "transparent".
  Future<int?> getLineTrimColor() => messenger.getLineTrimColor(id);

  /// The fade range for the trim-start and trim-end points is defined by the `line-trim-offset` property. The first element of the array represents the fade range from the trim-start point toward the end of the line, while the second element defines the fade range from the trim-end point toward the beginning of the line. The fade result is achieved by interpolating between `line-trim-color` and the color specified by the `line-color` or the `line-gradient` property. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  Future<void> setLineTrimFadeRange(List<double?> lineTrimFadeRange) =>
      messenger.setLineTrimFadeRange(id, lineTrimFadeRange);

  /// The fade range for the trim-start and trim-end points is defined by the `line-trim-offset` property. The first element of the array represents the fade range from the trim-start point toward the end of the line, while the second element defines the fade range from the trim-end point toward the beginning of the line. The fade result is achieved by interpolating between `line-trim-color` and the color specified by the `line-color` or the `line-gradient` property. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  Future<List<double?>?> getLineTrimFadeRange() =>
      messenger.getLineTrimFadeRange(id);

  /// The line part between [trim-start, trim-end] will be painted using `line-trim-color,` which is transparent by default to produce a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0]. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  Future<void> setLineTrimOffset(List<double?> lineTrimOffset) =>
      messenger.setLineTrimOffset(id, lineTrimOffset);

  /// The line part between [trim-start, trim-end] will be painted using `line-trim-color,` which is transparent by default to produce a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0]. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  Future<List<double?>?> getLineTrimOffset() => messenger.getLineTrimOffset(id);

  /// Stroke thickness. Default value: 1. Minimum value: 0.
  Future<void> setLineWidth(double lineWidth) =>
      messenger.setLineWidth(id, lineWidth);

  /// Stroke thickness. Default value: 1. Minimum value: 0.
  Future<double?> getLineWidth() => messenger.getLineWidth(id);
}
// End of generated file.
