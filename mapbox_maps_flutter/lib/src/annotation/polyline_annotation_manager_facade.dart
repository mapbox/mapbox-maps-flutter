// This file is generated.
import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../annotations_manager.dart' show BaseAnnotationManager;

/// Manages polyline annotations.
final class PolylineAnnotationManager
    extends BaseAnnotationManager<PolylineAnnotationManagerPlatformInterface> {
  @internal
  PolylineAnnotationManager(
    PolylineAnnotationManagerPlatformInterface super.impl,
  );

  /// Registers tap event callbacks for the annotations managed by this manager.
  Cancelable tapEvents({required Function(PolylineAnnotation) onTap}) =>
      impl.tapEvents(onTap: onTap);

  /// Registers long press event callbacks for the annotations managed by this manager.
  Cancelable longPressEvents({
    required Function(PolylineAnnotation) onLongPress,
  }) => impl.longPressEvents(onLongPress: onLongPress);

  /// Registers drag event callbacks for the annotations managed by this manager.
  Cancelable dragEvents({
    Function(PolylineAnnotation)? onBegin,
    Function(PolylineAnnotation)? onChanged,
    Function(PolylineAnnotation)? onEnd,
  }) => impl.dragEvents(onBegin: onBegin, onChanged: onChanged, onEnd: onEnd);

  /// Get all annotations of manager.
  Future<List<PolylineAnnotation>> getAnnotations() => impl.getAnnotations();

  /// Create a new annotation with the option.
  Future<PolylineAnnotation> create(PolylineAnnotationOptions annotation) =>
      impl.create(annotation);

  /// Create multi annotations with the options.
  Future<List<PolylineAnnotation?>> createMulti(
    List<PolylineAnnotationOptions> annotations,
  ) => impl.createMulti(annotations);

  /// Update an added annotation with new properties.
  Future<void> update(PolylineAnnotation annotation) => impl.update(annotation);

  /// Delete an added annotation.
  Future<void> delete(PolylineAnnotation annotation) => impl.delete(annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => impl.deleteAll();

  /// Delete multiple annotations added by this manager.
  Future<void> deleteMulti(List<PolylineAnnotation> annotations) =>
      impl.deleteMulti(annotations);

  /// The display of line endings. Default value: "butt".
  Future<void> setLineCap(LineCap lineCap) => impl.setLineCap(lineCap);

  /// The display of line endings. Default value: "butt".
  Future<LineCap?> getLineCap() => impl.getLineCap();

  /// Defines the slope of an elevated line. A value of 0 creates a horizontal line. A value of 1 creates a vertical line. Other values are currently not supported. If undefined, the line follows the terrain slope. This is an experimental property with some known issues:  - Vertical lines don't support line caps  - `line-join: round` is not supported with this property
  @experimental
  Future<void> setLineCrossSlope(double lineCrossSlope) =>
      impl.setLineCrossSlope(lineCrossSlope);

  /// Defines the slope of an elevated line. A value of 0 creates a horizontal line. A value of 1 creates a vertical line. Other values are currently not supported. If undefined, the line follows the terrain slope. This is an experimental property with some known issues:  - Vertical lines don't support line caps  - `line-join: round` is not supported with this property
  @experimental
  Future<double?> getLineCrossSlope() => impl.getLineCrossSlope();

  /// Controls how much the elevation of lines with `line-elevation-reference` set to `sea` scales with terrain exaggeration. A value of 0 keeps the line at a fixed altitude above sea level. A value of 1 scales the elevation proportionally with terrain exaggeration. Default value: 0. Value range: [0, 1]
  Future<void> setLineElevationGroundScale(double lineElevationGroundScale) =>
      impl.setLineElevationGroundScale(lineElevationGroundScale);

  /// Controls how much the elevation of lines with `line-elevation-reference` set to `sea` scales with terrain exaggeration. A value of 0 keeps the line at a fixed altitude above sea level. A value of 1 scales the elevation proportionally with terrain exaggeration. Default value: 0. Value range: [0, 1]
  Future<double?> getLineElevationGroundScale() =>
      impl.getLineElevationGroundScale();

  /// Selects the base of line-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  Future<void> setLineElevationReference(
    LineElevationReference lineElevationReference,
  ) => impl.setLineElevationReference(lineElevationReference);

  /// Selects the base of line-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  Future<LineElevationReference?> getLineElevationReference() =>
      impl.getLineElevationReference();

  /// The display of lines when joining. Default value: "miter".
  Future<void> setLineJoin(LineJoin lineJoin) => impl.setLineJoin(lineJoin);

  /// The display of lines when joining. Default value: "miter".
  Future<LineJoin?> getLineJoin() => impl.getLineJoin();

  /// Used to automatically convert miter joins to bevel joins for sharp angles. Default value: 2.
  Future<void> setLineMiterLimit(double lineMiterLimit) =>
      impl.setLineMiterLimit(lineMiterLimit);

  /// Used to automatically convert miter joins to bevel joins for sharp angles. Default value: 2.
  Future<double?> getLineMiterLimit() => impl.getLineMiterLimit();

  /// Used to automatically convert round joins to miter joins for shallow angles. Default value: 1.05.
  Future<void> setLineRoundLimit(double lineRoundLimit) =>
      impl.setLineRoundLimit(lineRoundLimit);

  /// Used to automatically convert round joins to miter joins for shallow angles. Default value: 1.05.
  Future<double?> getLineRoundLimit() => impl.getLineRoundLimit();

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<void> setLineSortKey(double lineSortKey) =>
      impl.setLineSortKey(lineSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<double?> getLineSortKey() => impl.getLineSortKey();

  /// Selects the unit of line-width. The same unit is automatically used for line-blur and line-offset. Note: This is an experimental property and might be removed in a future release. Default value: "pixels".
  @experimental
  Future<void> setLineWidthUnit(LineWidthUnit lineWidthUnit) =>
      impl.setLineWidthUnit(lineWidthUnit);

  /// Selects the unit of line-width. The same unit is automatically used for line-blur and line-offset. Note: This is an experimental property and might be removed in a future release. Default value: "pixels".
  @experimental
  Future<LineWidthUnit?> getLineWidthUnit() => impl.getLineWidthUnit();

  /// Vertical offset from ground, in meters. Not supported for globe projection at the moment. Default value: 0.
  Future<void> setLineZOffset(double lineZOffset) =>
      impl.setLineZOffset(lineZOffset);

  /// Vertical offset from ground, in meters. Not supported for globe projection at the moment. Default value: 0.
  Future<double?> getLineZOffset() => impl.getLineZOffset();

  /// Blur applied to the line, in pixels. Default value: 0. Minimum value: 0. The unit of lineBlur is in pixels.
  Future<void> setLineBlur(double lineBlur) => impl.setLineBlur(lineBlur);

  /// Blur applied to the line, in pixels. Default value: 0. Minimum value: 0. The unit of lineBlur is in pixels.
  Future<double?> getLineBlur() => impl.getLineBlur();

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color. Default value: "rgba(0, 0, 0, 0)".
  Future<void> setLineBorderColor(int lineBorderColor) =>
      impl.setLineBorderColor(lineBorderColor);

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color. Default value: "rgba(0, 0, 0, 0)".
  Future<int?> getLineBorderColor() => impl.getLineBorderColor();

  /// The width of the line border. A value of zero means no border. Default value: 0. Minimum value: 0.
  Future<void> setLineBorderWidth(double lineBorderWidth) =>
      impl.setLineBorderWidth(lineBorderWidth);

  /// The width of the line border. A value of zero means no border. Default value: 0. Minimum value: 0.
  Future<double?> getLineBorderWidth() => impl.getLineBorderWidth();

  /// The color with which the line will be drawn. Default value: "#000000".
  Future<void> setLineColor(int lineColor) => impl.setLineColor(lineColor);

  /// The color with which the line will be drawn. Default value: "#000000".
  Future<int?> getLineColor() => impl.getLineColor();

  /// The width of the cutout fade effect as a proportion of the cutout width. Default value: 0.4. Value range: [0, 1]
  @experimental
  Future<void> setLineCutoutFadeWidth(double lineCutoutFadeWidth) =>
      impl.setLineCutoutFadeWidth(lineCutoutFadeWidth);

  /// The width of the cutout fade effect as a proportion of the cutout width. Default value: 0.4. Value range: [0, 1]
  @experimental
  Future<double?> getLineCutoutFadeWidth() => impl.getLineCutoutFadeWidth();

  /// The opacity of the aboveground objects affected by the line cutout. Cutout for tunnels isn't affected by this property, If set to 0, the cutout is fully transparent. Cutout opacity should have the same value for all layers that specify it. If all layers don't have the same value, it is not specified which value is used. Default value: 1. Value range: [0, 1]
  @experimental
  Future<void> setLineCutoutOpacity(double lineCutoutOpacity) =>
      impl.setLineCutoutOpacity(lineCutoutOpacity);

  /// The opacity of the aboveground objects affected by the line cutout. Cutout for tunnels isn't affected by this property, If set to 0, the cutout is fully transparent. Cutout opacity should have the same value for all layers that specify it. If all layers don't have the same value, it is not specified which value is used. Default value: 1. Value range: [0, 1]
  @experimental
  Future<double?> getLineCutoutOpacity() => impl.getLineCutoutOpacity();

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels. Minimum value: 0. The unit of lineDasharray is in line widths.
  Future<void> setLineDasharray(List<double?> lineDasharray) =>
      impl.setLineDasharray(lineDasharray);

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels. Minimum value: 0. The unit of lineDasharray is in line widths.
  Future<List<double?>?> getLineDasharray() => impl.getLineDasharray();

  /// This property is deprecated and replaced by line-occlusion-opacity. Value 0 disables occlusion, value 1 means fully occluded. Note: line-occlusion-opacity has the opposite effect - value 1 disables occlusion, value 0 means fully occluded. Default value: 1. Value range: [0, 1]
  Future<void> setLineDepthOcclusionFactor(double lineDepthOcclusionFactor) =>
      impl.setLineDepthOcclusionFactor(lineDepthOcclusionFactor);

  /// This property is deprecated and replaced by line-occlusion-opacity. Value 0 disables occlusion, value 1 means fully occluded. Note: line-occlusion-opacity has the opposite effect - value 1 disables occlusion, value 0 means fully occluded. Default value: 1. Value range: [0, 1]
  Future<double?> getLineDepthOcclusionFactor() =>
      impl.getLineDepthOcclusionFactor();

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of lineEmissiveStrength is in intensity.
  Future<void> setLineEmissiveStrength(double lineEmissiveStrength) =>
      impl.setLineEmissiveStrength(lineEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of lineEmissiveStrength is in intensity.
  Future<double?> getLineEmissiveStrength() => impl.getLineEmissiveStrength();

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap. Default value: 0. Minimum value: 0. The unit of lineGapWidth is in pixels.
  Future<void> setLineGapWidth(double lineGapWidth) =>
      impl.setLineGapWidth(lineGapWidth);

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap. Default value: 0. Minimum value: 0. The unit of lineGapWidth is in pixels.
  Future<double?> getLineGapWidth() => impl.getLineGapWidth();

  /// Opacity multiplier (multiplies line-opacity value) of the line part that is occluded by 3D objects. Value 0 hides occluded part, value 1 means the same opacity as non-occluded part. The property is not supported when `line-opacity` has data-driven styling. Default value: 0. Value range: [0, 1]
  Future<void> setLineOcclusionOpacity(double lineOcclusionOpacity) =>
      impl.setLineOcclusionOpacity(lineOcclusionOpacity);

  /// Opacity multiplier (multiplies line-opacity value) of the line part that is occluded by 3D objects. Value 0 hides occluded part, value 1 means the same opacity as non-occluded part. The property is not supported when `line-opacity` has data-driven styling. Default value: 0. Value range: [0, 1]
  Future<double?> getLineOcclusionOpacity() => impl.getLineOcclusionOpacity();

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset. Default value: 0. The unit of lineOffset is in pixels.
  Future<void> setLineOffset(double lineOffset) =>
      impl.setLineOffset(lineOffset);

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset. Default value: 0. The unit of lineOffset is in pixels.
  Future<double?> getLineOffset() => impl.getLineOffset();

  /// The opacity at which the line will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setLineOpacity(double lineOpacity) =>
      impl.setLineOpacity(lineOpacity);

  /// The opacity at which the line will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getLineOpacity() => impl.getLineOpacity();

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<void> setLinePattern(String linePattern) =>
      impl.setLinePattern(linePattern);

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<String?> getLinePattern() => impl.getLinePattern();

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of lineTranslate is in pixels.
  Future<void> setLineTranslate(List<double?> lineTranslate) =>
      impl.setLineTranslate(lineTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of lineTranslate is in pixels.
  Future<List<double?>?> getLineTranslate() => impl.getLineTranslate();

  /// Controls the frame of reference for `line-translate`. Default value: "map".
  Future<void> setLineTranslateAnchor(
    LineTranslateAnchor lineTranslateAnchor,
  ) => impl.setLineTranslateAnchor(lineTranslateAnchor);

  /// Controls the frame of reference for `line-translate`. Default value: "map".
  Future<LineTranslateAnchor?> getLineTranslateAnchor() =>
      impl.getLineTranslateAnchor();

  /// The color to be used for rendering the trimmed line section that is defined by the `line-trim-offset` property. Default value: "transparent".
  @experimental
  Future<void> setLineTrimColor(int lineTrimColor) =>
      impl.setLineTrimColor(lineTrimColor);

  /// The color to be used for rendering the trimmed line section that is defined by the `line-trim-offset` property. Default value: "transparent".
  @experimental
  Future<int?> getLineTrimColor() => impl.getLineTrimColor();

  /// The fade range for the trim-start and trim-end points is defined by the `line-trim-offset` property. The first element of the array represents the fade range from the trim-start point toward the end of the line, while the second element defines the fade range from the trim-end point toward the beginning of the line. The fade result is achieved by interpolating between `line-trim-color` and the color specified by the `line-color` or the `line-gradient` property. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  @experimental
  Future<void> setLineTrimFadeRange(List<double?> lineTrimFadeRange) =>
      impl.setLineTrimFadeRange(lineTrimFadeRange);

  /// The fade range for the trim-start and trim-end points is defined by the `line-trim-offset` property. The first element of the array represents the fade range from the trim-start point toward the end of the line, while the second element defines the fade range from the trim-end point toward the beginning of the line. The fade result is achieved by interpolating between `line-trim-color` and the color specified by the `line-color` or the `line-gradient` property. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  @experimental
  Future<List<double?>?> getLineTrimFadeRange() => impl.getLineTrimFadeRange();

  /// The line part between [trim-start, trim-end] will be painted using `line-trim-color,` which is transparent by default to produce a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0]. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  Future<void> setLineTrimOffset(List<double?> lineTrimOffset) =>
      impl.setLineTrimOffset(lineTrimOffset);

  /// The line part between [trim-start, trim-end] will be painted using `line-trim-color,` which is transparent by default to produce a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0]. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  Future<List<double?>?> getLineTrimOffset() => impl.getLineTrimOffset();

  /// Stroke thickness. Default value: 1. Minimum value: 0. The unit of lineWidth is in pixels.
  Future<void> setLineWidth(double lineWidth) => impl.setLineWidth(lineWidth);

  /// Stroke thickness. Default value: 1. Minimum value: 0. The unit of lineWidth is in pixels.
  Future<double?> getLineWidth() => impl.getLineWidth();
}

// End of generated file.
