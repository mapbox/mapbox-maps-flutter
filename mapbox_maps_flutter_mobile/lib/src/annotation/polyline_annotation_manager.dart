// This file is generated.
part of mapbox_maps_flutter_mobile;

/// The PolylineAnnotationManager to add/update/delete PolylineAnnotationAnnotations on the map.
class PolylineAnnotationManager extends BaseAnnotationManager
    implements PolylineAnnotationManagerPlatformInterface {
  PolylineAnnotationManager._({
    required super.id,
    required super.messenger,
    required String channelSuffix,
  }) : _annotationMessenger = _PolylineAnnotationMessenger(
         binaryMessenger: messenger,
         messageChannelSuffix: channelSuffix,
       ),
       _channelSuffix = channelSuffix,
       super._();

  final _PolylineAnnotationMessenger _annotationMessenger;
  final String _channelSuffix;

  @override
  Stream<PolylineAnnotationInteractionContext> get tapInteractionStream =>
      _annotationInteractionEvents(
        instanceName: "$_channelSuffix/$id/tap",
      ).cast<PolylineAnnotationInteractionContext>();

  @override
  Stream<PolylineAnnotationInteractionContext> get longPressInteractionStream =>
      _annotationInteractionEvents(
        instanceName: "$_channelSuffix/$id/long_press",
      ).cast<PolylineAnnotationInteractionContext>();

  @override
  Stream<PolylineAnnotationInteractionContext> get dragInteractionStream =>
      _annotationInteractionEvents(
        instanceName: "$_channelSuffix/$id/drag",
      ).cast<PolylineAnnotationInteractionContext>();

  /// Get all annotations of manager.
  @override
  Future<List<PolylineAnnotation>> getAnnotations() =>
      _annotationMessenger.getAnnotations(id);

  /// Create a new annotation with the option.
  @override
  Future<PolylineAnnotation> create(PolylineAnnotationOptions annotation) =>
      _annotationMessenger.create(id, annotation);

  /// Create multi annotations with the options.
  @override
  Future<List<PolylineAnnotation?>> createMulti(
    List<PolylineAnnotationOptions> annotations,
  ) => _annotationMessenger.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  @override
  Future<void> update(PolylineAnnotation annotation) =>
      _annotationMessenger.update(id, annotation);

  /// Delete an added annotation.
  @override
  Future<void> delete(PolylineAnnotation annotation) =>
      _annotationMessenger.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  @override
  Future<void> deleteAll() => _annotationMessenger.deleteAll(id);

  /// Delete multiple annotations added by this manager.
  @override
  Future<void> deleteMulti(List<PolylineAnnotation> annotations) =>
      _annotationMessenger.deleteMulti(id, annotations);

  /// The display of line endings. Default value: "butt".
  @override
  Future<void> setLineCap(LineCap lineCap) =>
      _annotationMessenger.setLineCap(id, lineCap);

  /// The display of line endings. Default value: "butt".
  @override
  Future<LineCap?> getLineCap() => _annotationMessenger.getLineCap(id);

  /// Defines the slope of an elevated line. A value of 0 creates a horizontal line. A value of 1 creates a vertical line. Other values are currently not supported. If undefined, the line follows the terrain slope. This is an experimental property with some known issues:  - Vertical lines don't support line caps  - `line-join: round` is not supported with this property
  @experimental
  @override
  Future<void> setLineCrossSlope(double lineCrossSlope) =>
      _annotationMessenger.setLineCrossSlope(id, lineCrossSlope);

  /// Defines the slope of an elevated line. A value of 0 creates a horizontal line. A value of 1 creates a vertical line. Other values are currently not supported. If undefined, the line follows the terrain slope. This is an experimental property with some known issues:  - Vertical lines don't support line caps  - `line-join: round` is not supported with this property
  @experimental
  @override
  Future<double?> getLineCrossSlope() =>
      _annotationMessenger.getLineCrossSlope(id);

  /// Controls how much the elevation of lines with `line-elevation-reference` set to `sea` scales with terrain exaggeration. A value of 0 keeps the line at a fixed altitude above sea level. A value of 1 scales the elevation proportionally with terrain exaggeration. Default value: 0. Value range: [0, 1]
  @override
  Future<void> setLineElevationGroundScale(double lineElevationGroundScale) =>
      _annotationMessenger.setLineElevationGroundScale(
        id,
        lineElevationGroundScale,
      );

  /// Controls how much the elevation of lines with `line-elevation-reference` set to `sea` scales with terrain exaggeration. A value of 0 keeps the line at a fixed altitude above sea level. A value of 1 scales the elevation proportionally with terrain exaggeration. Default value: 0. Value range: [0, 1]
  @override
  Future<double?> getLineElevationGroundScale() =>
      _annotationMessenger.getLineElevationGroundScale(id);

  /// Selects the base of line-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  @override
  Future<void> setLineElevationReference(
    LineElevationReference lineElevationReference,
  ) => _annotationMessenger.setLineElevationReference(
    id,
    lineElevationReference,
  );

  /// Selects the base of line-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  @override
  Future<LineElevationReference?> getLineElevationReference() =>
      _annotationMessenger.getLineElevationReference(id);

  /// The display of lines when joining. Default value: "miter".
  @override
  Future<void> setLineJoin(LineJoin lineJoin) =>
      _annotationMessenger.setLineJoin(id, lineJoin);

  /// The display of lines when joining. Default value: "miter".
  @override
  Future<LineJoin?> getLineJoin() => _annotationMessenger.getLineJoin(id);

  /// Used to automatically convert miter joins to bevel joins for sharp angles. Default value: 2.
  @override
  Future<void> setLineMiterLimit(double lineMiterLimit) =>
      _annotationMessenger.setLineMiterLimit(id, lineMiterLimit);

  /// Used to automatically convert miter joins to bevel joins for sharp angles. Default value: 2.
  @override
  Future<double?> getLineMiterLimit() =>
      _annotationMessenger.getLineMiterLimit(id);

  /// Used to automatically convert round joins to miter joins for shallow angles. Default value: 1.05.
  @override
  Future<void> setLineRoundLimit(double lineRoundLimit) =>
      _annotationMessenger.setLineRoundLimit(id, lineRoundLimit);

  /// Used to automatically convert round joins to miter joins for shallow angles. Default value: 1.05.
  @override
  Future<double?> getLineRoundLimit() =>
      _annotationMessenger.getLineRoundLimit(id);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  @override
  Future<void> setLineSortKey(double lineSortKey) =>
      _annotationMessenger.setLineSortKey(id, lineSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  @override
  Future<double?> getLineSortKey() => _annotationMessenger.getLineSortKey(id);

  /// Selects the unit of line-width. The same unit is automatically used for line-blur and line-offset. Note: This is an experimental property and might be removed in a future release. Default value: "pixels".
  @experimental
  @override
  Future<void> setLineWidthUnit(LineWidthUnit lineWidthUnit) =>
      _annotationMessenger.setLineWidthUnit(id, lineWidthUnit);

  /// Selects the unit of line-width. The same unit is automatically used for line-blur and line-offset. Note: This is an experimental property and might be removed in a future release. Default value: "pixels".
  @experimental
  @override
  Future<LineWidthUnit?> getLineWidthUnit() =>
      _annotationMessenger.getLineWidthUnit(id);

  /// Vertical offset from ground, in meters. Not supported for globe projection at the moment. Default value: 0.
  @override
  Future<void> setLineZOffset(double lineZOffset) =>
      _annotationMessenger.setLineZOffset(id, lineZOffset);

  /// Vertical offset from ground, in meters. Not supported for globe projection at the moment. Default value: 0.
  @override
  Future<double?> getLineZOffset() => _annotationMessenger.getLineZOffset(id);

  /// Blur applied to the line, in pixels. Default value: 0. Minimum value: 0. The unit of lineBlur is in pixels.
  @override
  Future<void> setLineBlur(double lineBlur) =>
      _annotationMessenger.setLineBlur(id, lineBlur);

  /// Blur applied to the line, in pixels. Default value: 0. Minimum value: 0. The unit of lineBlur is in pixels.
  @override
  Future<double?> getLineBlur() => _annotationMessenger.getLineBlur(id);

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color. Default value: "rgba(0, 0, 0, 0)".
  @override
  Future<void> setLineBorderColor(int lineBorderColor) =>
      _annotationMessenger.setLineBorderColor(id, lineBorderColor);

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color. Default value: "rgba(0, 0, 0, 0)".
  @override
  Future<int?> getLineBorderColor() =>
      _annotationMessenger.getLineBorderColor(id);

  /// The width of the line border. A value of zero means no border. Default value: 0. Minimum value: 0.
  @override
  Future<void> setLineBorderWidth(double lineBorderWidth) =>
      _annotationMessenger.setLineBorderWidth(id, lineBorderWidth);

  /// The width of the line border. A value of zero means no border. Default value: 0. Minimum value: 0.
  @override
  Future<double?> getLineBorderWidth() =>
      _annotationMessenger.getLineBorderWidth(id);

  /// The color with which the line will be drawn. Default value: "#000000".
  @override
  Future<void> setLineColor(int lineColor) =>
      _annotationMessenger.setLineColor(id, lineColor);

  /// The color with which the line will be drawn. Default value: "#000000".
  @override
  Future<int?> getLineColor() => _annotationMessenger.getLineColor(id);

  /// The width of the cutout fade effect as a proportion of the cutout width. Default value: 0.4. Value range: [0, 1]
  @experimental
  @override
  Future<void> setLineCutoutFadeWidth(double lineCutoutFadeWidth) =>
      _annotationMessenger.setLineCutoutFadeWidth(id, lineCutoutFadeWidth);

  /// The width of the cutout fade effect as a proportion of the cutout width. Default value: 0.4. Value range: [0, 1]
  @experimental
  @override
  Future<double?> getLineCutoutFadeWidth() =>
      _annotationMessenger.getLineCutoutFadeWidth(id);

  /// The opacity of the aboveground objects affected by the line cutout. Cutout for tunnels isn't affected by this property, If set to 0, the cutout is fully transparent. Cutout opacity should have the same value for all layers that specify it. If all layers don't have the same value, it is not specified which value is used. Default value: 1. Value range: [0, 1]
  @experimental
  @override
  Future<void> setLineCutoutOpacity(double lineCutoutOpacity) =>
      _annotationMessenger.setLineCutoutOpacity(id, lineCutoutOpacity);

  /// The opacity of the aboveground objects affected by the line cutout. Cutout for tunnels isn't affected by this property, If set to 0, the cutout is fully transparent. Cutout opacity should have the same value for all layers that specify it. If all layers don't have the same value, it is not specified which value is used. Default value: 1. Value range: [0, 1]
  @experimental
  @override
  Future<double?> getLineCutoutOpacity() =>
      _annotationMessenger.getLineCutoutOpacity(id);

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels. Minimum value: 0. The unit of lineDasharray is in line widths.
  @override
  Future<void> setLineDasharray(List<double?> lineDasharray) =>
      _annotationMessenger.setLineDasharray(id, lineDasharray);

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels. Minimum value: 0. The unit of lineDasharray is in line widths.
  @override
  Future<List<double?>?> getLineDasharray() =>
      _annotationMessenger.getLineDasharray(id);

  /// This property is deprecated and replaced by line-occlusion-opacity. Value 0 disables occlusion, value 1 means fully occluded. Note: line-occlusion-opacity has the opposite effect - value 1 disables occlusion, value 0 means fully occluded. Default value: 1. Value range: [0, 1]
  @override
  Future<void> setLineDepthOcclusionFactor(double lineDepthOcclusionFactor) =>
      _annotationMessenger.setLineDepthOcclusionFactor(
        id,
        lineDepthOcclusionFactor,
      );

  /// This property is deprecated and replaced by line-occlusion-opacity. Value 0 disables occlusion, value 1 means fully occluded. Note: line-occlusion-opacity has the opposite effect - value 1 disables occlusion, value 0 means fully occluded. Default value: 1. Value range: [0, 1]
  @override
  Future<double?> getLineDepthOcclusionFactor() =>
      _annotationMessenger.getLineDepthOcclusionFactor(id);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of lineEmissiveStrength is in intensity.
  @override
  Future<void> setLineEmissiveStrength(double lineEmissiveStrength) =>
      _annotationMessenger.setLineEmissiveStrength(id, lineEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of lineEmissiveStrength is in intensity.
  @override
  Future<double?> getLineEmissiveStrength() =>
      _annotationMessenger.getLineEmissiveStrength(id);

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap. Default value: 0. Minimum value: 0. The unit of lineGapWidth is in pixels.
  @override
  Future<void> setLineGapWidth(double lineGapWidth) =>
      _annotationMessenger.setLineGapWidth(id, lineGapWidth);

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap. Default value: 0. Minimum value: 0. The unit of lineGapWidth is in pixels.
  @override
  Future<double?> getLineGapWidth() => _annotationMessenger.getLineGapWidth(id);

  /// Opacity multiplier (multiplies line-opacity value) of the line part that is occluded by 3D objects. Value 0 hides occluded part, value 1 means the same opacity as non-occluded part. The property is not supported when `line-opacity` has data-driven styling. Default value: 0. Value range: [0, 1]
  @override
  Future<void> setLineOcclusionOpacity(double lineOcclusionOpacity) =>
      _annotationMessenger.setLineOcclusionOpacity(id, lineOcclusionOpacity);

  /// Opacity multiplier (multiplies line-opacity value) of the line part that is occluded by 3D objects. Value 0 hides occluded part, value 1 means the same opacity as non-occluded part. The property is not supported when `line-opacity` has data-driven styling. Default value: 0. Value range: [0, 1]
  @override
  Future<double?> getLineOcclusionOpacity() =>
      _annotationMessenger.getLineOcclusionOpacity(id);

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset. Default value: 0. The unit of lineOffset is in pixels.
  @override
  Future<void> setLineOffset(double lineOffset) =>
      _annotationMessenger.setLineOffset(id, lineOffset);

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset. Default value: 0. The unit of lineOffset is in pixels.
  @override
  Future<double?> getLineOffset() => _annotationMessenger.getLineOffset(id);

  /// The opacity at which the line will be drawn. Default value: 1. Value range: [0, 1]
  @override
  Future<void> setLineOpacity(double lineOpacity) =>
      _annotationMessenger.setLineOpacity(id, lineOpacity);

  /// The opacity at which the line will be drawn. Default value: 1. Value range: [0, 1]
  @override
  Future<double?> getLineOpacity() => _annotationMessenger.getLineOpacity(id);

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  @override
  Future<void> setLinePattern(String linePattern) =>
      _annotationMessenger.setLinePattern(id, linePattern);

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  @override
  Future<String?> getLinePattern() => _annotationMessenger.getLinePattern(id);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of lineTranslate is in pixels.
  @override
  Future<void> setLineTranslate(List<double?> lineTranslate) =>
      _annotationMessenger.setLineTranslate(id, lineTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of lineTranslate is in pixels.
  @override
  Future<List<double?>?> getLineTranslate() =>
      _annotationMessenger.getLineTranslate(id);

  /// Controls the frame of reference for `line-translate`. Default value: "map".
  @override
  Future<void> setLineTranslateAnchor(
    LineTranslateAnchor lineTranslateAnchor,
  ) => _annotationMessenger.setLineTranslateAnchor(id, lineTranslateAnchor);

  /// Controls the frame of reference for `line-translate`. Default value: "map".
  @override
  Future<LineTranslateAnchor?> getLineTranslateAnchor() =>
      _annotationMessenger.getLineTranslateAnchor(id);

  /// The color to be used for rendering the trimmed line section that is defined by the `line-trim-offset` property. Default value: "transparent".
  @experimental
  @override
  Future<void> setLineTrimColor(int lineTrimColor) =>
      _annotationMessenger.setLineTrimColor(id, lineTrimColor);

  /// The color to be used for rendering the trimmed line section that is defined by the `line-trim-offset` property. Default value: "transparent".
  @experimental
  @override
  Future<int?> getLineTrimColor() => _annotationMessenger.getLineTrimColor(id);

  /// The fade range for the trim-start and trim-end points is defined by the `line-trim-offset` property. The first element of the array represents the fade range from the trim-start point toward the end of the line, while the second element defines the fade range from the trim-end point toward the beginning of the line. The fade result is achieved by interpolating between `line-trim-color` and the color specified by the `line-color` or the `line-gradient` property. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  @experimental
  @override
  Future<void> setLineTrimFadeRange(List<double?> lineTrimFadeRange) =>
      _annotationMessenger.setLineTrimFadeRange(id, lineTrimFadeRange);

  /// The fade range for the trim-start and trim-end points is defined by the `line-trim-offset` property. The first element of the array represents the fade range from the trim-start point toward the end of the line, while the second element defines the fade range from the trim-end point toward the beginning of the line. The fade result is achieved by interpolating between `line-trim-color` and the color specified by the `line-color` or the `line-gradient` property. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  @experimental
  @override
  Future<List<double?>?> getLineTrimFadeRange() =>
      _annotationMessenger.getLineTrimFadeRange(id);

  /// The line part between [trim-start, trim-end] will be painted using `line-trim-color,` which is transparent by default to produce a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0]. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  @override
  Future<void> setLineTrimOffset(List<double?> lineTrimOffset) =>
      _annotationMessenger.setLineTrimOffset(id, lineTrimOffset);

  /// The line part between [trim-start, trim-end] will be painted using `line-trim-color,` which is transparent by default to produce a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0]. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  @override
  Future<List<double?>?> getLineTrimOffset() =>
      _annotationMessenger.getLineTrimOffset(id);

  /// Stroke thickness. Default value: 1. Minimum value: 0. The unit of lineWidth is in pixels.
  @override
  Future<void> setLineWidth(double lineWidth) =>
      _annotationMessenger.setLineWidth(id, lineWidth);

  /// Stroke thickness. Default value: 1. Minimum value: 0. The unit of lineWidth is in pixels.
  @override
  Future<double?> getLineWidth() => _annotationMessenger.getLineWidth(id);
}

// End of generated file.
