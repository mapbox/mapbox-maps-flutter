// This file is generated.
part of mapbox_maps_flutter;

/// The PolylineAnnotationManager to add/update/delete PolylineAnnotationAnnotations on the map.
class PolylineAnnotationManager extends BaseAnnotationManager {
  PolylineAnnotationManager._(
      {required super.id,
      required super.messenger,
      required String channelSuffix})
      : _annotationMessenger = _PolylineAnnotationMessenger(
            binaryMessenger: messenger, messageChannelSuffix: channelSuffix),
        _channelSuffix = channelSuffix,
        super._();

  final _PolylineAnnotationMessenger _annotationMessenger;
  final String _channelSuffix;

  /// Add a listener to receive the callback when an annotation is clicked.
  void addOnPolylineAnnotationClickListener(
      OnPolylineAnnotationClickListener listener) {
    OnPolylineAnnotationClickListener.setUp(listener,
        binaryMessenger: _messenger, messageChannelSuffix: _channelSuffix);
  }

  /// Create a new annotation with the option.
  Future<PolylineAnnotation> create(PolylineAnnotationOptions annotation) =>
      _annotationMessenger.create(id, annotation);

  /// Create multi annotations with the options.
  Future<List<PolylineAnnotation?>> createMulti(
          List<PolylineAnnotationOptions> annotations) =>
      _annotationMessenger.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  Future<void> update(PolylineAnnotation annotation) =>
      _annotationMessenger.update(id, annotation);

  /// Delete an added annotation.
  Future<void> delete(PolylineAnnotation annotation) =>
      _annotationMessenger.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => _annotationMessenger.deleteAll(id);

  /// The display of line endings. Default value: "butt".
  Future<void> setLineCap(LineCap lineCap) =>
      _annotationMessenger.setLineCap(id, lineCap);

  /// The display of line endings. Default value: "butt".
  Future<LineCap?> getLineCap() => _annotationMessenger.getLineCap(id);

  /// The display of lines when joining. Default value: "miter".
  Future<void> setLineJoin(LineJoin lineJoin) =>
      _annotationMessenger.setLineJoin(id, lineJoin);

  /// The display of lines when joining. Default value: "miter".
  Future<LineJoin?> getLineJoin() => _annotationMessenger.getLineJoin(id);

  /// Used to automatically convert miter joins to bevel joins for sharp angles. Default value: 2.
  Future<void> setLineMiterLimit(double lineMiterLimit) =>
      _annotationMessenger.setLineMiterLimit(id, lineMiterLimit);

  /// Used to automatically convert miter joins to bevel joins for sharp angles. Default value: 2.
  Future<double?> getLineMiterLimit() =>
      _annotationMessenger.getLineMiterLimit(id);

  /// Used to automatically convert round joins to miter joins for shallow angles. Default value: 1.05.
  Future<void> setLineRoundLimit(double lineRoundLimit) =>
      _annotationMessenger.setLineRoundLimit(id, lineRoundLimit);

  /// Used to automatically convert round joins to miter joins for shallow angles. Default value: 1.05.
  Future<double?> getLineRoundLimit() =>
      _annotationMessenger.getLineRoundLimit(id);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<void> setLineSortKey(double lineSortKey) =>
      _annotationMessenger.setLineSortKey(id, lineSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<double?> getLineSortKey() => _annotationMessenger.getLineSortKey(id);

  /// Vertical offset from ground, in meters. Defaults to 0. Not supported for globe projection at the moment.
  Future<void> setLineZOffset(double lineZOffset) =>
      _annotationMessenger.setLineZOffset(id, lineZOffset);

  /// Vertical offset from ground, in meters. Defaults to 0. Not supported for globe projection at the moment.
  Future<double?> getLineZOffset() => _annotationMessenger.getLineZOffset(id);

  /// Blur applied to the line, in pixels. Default value: 0. Minimum value: 0.
  Future<void> setLineBlur(double lineBlur) =>
      _annotationMessenger.setLineBlur(id, lineBlur);

  /// Blur applied to the line, in pixels. Default value: 0. Minimum value: 0.
  Future<double?> getLineBlur() => _annotationMessenger.getLineBlur(id);

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color. Default value: "rgba(0, 0, 0, 0)".
  Future<void> setLineBorderColor(int lineBorderColor) =>
      _annotationMessenger.setLineBorderColor(id, lineBorderColor);

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color. Default value: "rgba(0, 0, 0, 0)".
  Future<int?> getLineBorderColor() =>
      _annotationMessenger.getLineBorderColor(id);

  /// The width of the line border. A value of zero means no border. Default value: 0. Minimum value: 0.
  Future<void> setLineBorderWidth(double lineBorderWidth) =>
      _annotationMessenger.setLineBorderWidth(id, lineBorderWidth);

  /// The width of the line border. A value of zero means no border. Default value: 0. Minimum value: 0.
  Future<double?> getLineBorderWidth() =>
      _annotationMessenger.getLineBorderWidth(id);

  /// The color with which the line will be drawn. Default value: "#000000".
  Future<void> setLineColor(int lineColor) =>
      _annotationMessenger.setLineColor(id, lineColor);

  /// The color with which the line will be drawn. Default value: "#000000".
  Future<int?> getLineColor() => _annotationMessenger.getLineColor(id);

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels. Minimum value: 0.
  Future<void> setLineDasharray(List<double?> lineDasharray) =>
      _annotationMessenger.setLineDasharray(id, lineDasharray);

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels. Minimum value: 0.
  Future<List<double?>?> getLineDasharray() =>
      _annotationMessenger.getLineDasharray(id);

  /// Decrease line layer opacity based on occlusion from 3D objects. Value 0 disables occlusion, value 1 means fully occluded. Default value: 1. Value range: [0, 1]
  Future<void> setLineDepthOcclusionFactor(double lineDepthOcclusionFactor) =>
      _annotationMessenger.setLineDepthOcclusionFactor(
          id, lineDepthOcclusionFactor);

  /// Decrease line layer opacity based on occlusion from 3D objects. Value 0 disables occlusion, value 1 means fully occluded. Default value: 1. Value range: [0, 1]
  Future<double?> getLineDepthOcclusionFactor() =>
      _annotationMessenger.getLineDepthOcclusionFactor(id);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0.
  Future<void> setLineEmissiveStrength(double lineEmissiveStrength) =>
      _annotationMessenger.setLineEmissiveStrength(id, lineEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0.
  Future<double?> getLineEmissiveStrength() =>
      _annotationMessenger.getLineEmissiveStrength(id);

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap. Default value: 0. Minimum value: 0.
  Future<void> setLineGapWidth(double lineGapWidth) =>
      _annotationMessenger.setLineGapWidth(id, lineGapWidth);

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap. Default value: 0. Minimum value: 0.
  Future<double?> getLineGapWidth() => _annotationMessenger.getLineGapWidth(id);

  /// Opacity multiplier (multiplies line-opacity value) of the line part that is occluded by 3D objects. Value 0 hides occluded part, value 1 means the same opacity as non-occluded part. The property is not supported when `line-opacity` has data-driven styling. Default value: 0. Value range: [0, 1]
  Future<void> setLineOcclusionOpacity(double lineOcclusionOpacity) =>
      _annotationMessenger.setLineOcclusionOpacity(id, lineOcclusionOpacity);

  /// Opacity multiplier (multiplies line-opacity value) of the line part that is occluded by 3D objects. Value 0 hides occluded part, value 1 means the same opacity as non-occluded part. The property is not supported when `line-opacity` has data-driven styling. Default value: 0. Value range: [0, 1]
  Future<double?> getLineOcclusionOpacity() =>
      _annotationMessenger.getLineOcclusionOpacity(id);

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset. Default value: 0.
  Future<void> setLineOffset(double lineOffset) =>
      _annotationMessenger.setLineOffset(id, lineOffset);

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset. Default value: 0.
  Future<double?> getLineOffset() => _annotationMessenger.getLineOffset(id);

  /// The opacity at which the line will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setLineOpacity(double lineOpacity) =>
      _annotationMessenger.setLineOpacity(id, lineOpacity);

  /// The opacity at which the line will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getLineOpacity() => _annotationMessenger.getLineOpacity(id);

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<void> setLinePattern(String linePattern) =>
      _annotationMessenger.setLinePattern(id, linePattern);

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<String?> getLinePattern() => _annotationMessenger.getLinePattern(id);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0].
  Future<void> setLineTranslate(List<double?> lineTranslate) =>
      _annotationMessenger.setLineTranslate(id, lineTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0].
  Future<List<double?>?> getLineTranslate() =>
      _annotationMessenger.getLineTranslate(id);

  /// Controls the frame of reference for `line-translate`. Default value: "map".
  Future<void> setLineTranslateAnchor(
          LineTranslateAnchor lineTranslateAnchor) =>
      _annotationMessenger.setLineTranslateAnchor(id, lineTranslateAnchor);

  /// Controls the frame of reference for `line-translate`. Default value: "map".
  Future<LineTranslateAnchor?> getLineTranslateAnchor() =>
      _annotationMessenger.getLineTranslateAnchor(id);

  /// The color to be used for rendering the trimmed line section that is defined by the `line-trim-offset` property. Default value: "transparent".
  Future<void> setLineTrimColor(int lineTrimColor) =>
      _annotationMessenger.setLineTrimColor(id, lineTrimColor);

  /// The color to be used for rendering the trimmed line section that is defined by the `line-trim-offset` property. Default value: "transparent".
  Future<int?> getLineTrimColor() => _annotationMessenger.getLineTrimColor(id);

  /// The fade range for the trim-start and trim-end points is defined by the `line-trim-offset` property. The first element of the array represents the fade range from the trim-start point toward the end of the line, while the second element defines the fade range from the trim-end point toward the beginning of the line. The fade result is achieved by interpolating between `line-trim-color` and the color specified by the `line-color` or the `line-gradient` property. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  Future<void> setLineTrimFadeRange(List<double?> lineTrimFadeRange) =>
      _annotationMessenger.setLineTrimFadeRange(id, lineTrimFadeRange);

  /// The fade range for the trim-start and trim-end points is defined by the `line-trim-offset` property. The first element of the array represents the fade range from the trim-start point toward the end of the line, while the second element defines the fade range from the trim-end point toward the beginning of the line. The fade result is achieved by interpolating between `line-trim-color` and the color specified by the `line-color` or the `line-gradient` property. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  Future<List<double?>?> getLineTrimFadeRange() =>
      _annotationMessenger.getLineTrimFadeRange(id);

  /// The line part between [trim-start, trim-end] will be painted using `line-trim-color,` which is transparent by default to produce a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0]. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  Future<void> setLineTrimOffset(List<double?> lineTrimOffset) =>
      _annotationMessenger.setLineTrimOffset(id, lineTrimOffset);

  /// The line part between [trim-start, trim-end] will be painted using `line-trim-color,` which is transparent by default to produce a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0]. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  Future<List<double?>?> getLineTrimOffset() =>
      _annotationMessenger.getLineTrimOffset(id);

  /// Stroke thickness. Default value: 1. Minimum value: 0.
  Future<void> setLineWidth(double lineWidth) =>
      _annotationMessenger.setLineWidth(id, lineWidth);

  /// Stroke thickness. Default value: 1. Minimum value: 0.
  Future<double?> getLineWidth() => _annotationMessenger.getLineWidth(id);
}
// End of generated file.
