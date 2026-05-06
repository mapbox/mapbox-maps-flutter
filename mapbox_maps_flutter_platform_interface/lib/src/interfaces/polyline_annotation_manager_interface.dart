// This file is generated.
import 'package:meta/meta.dart';

import '../cancelable.dart';
import '../pigeons/annotation_data_types.dart';
import '../pigeons/platform_interface_data_types.dart';
import 'annotations_interface.dart';

/// Abstract interface for managing polyline annotations.
abstract interface class PolylineAnnotationManagerPlatformInterface
    implements BaseAnnotationManagerPlatformInterface {
  /// Registers tap event callbacks for the annotations managed by this manager.
  Cancelable tapEvents({required Function(PolylineAnnotation) onTap});

  /// Registers long press event callbacks for the annotations managed by this manager.
  Cancelable longPressEvents({
    required Function(PolylineAnnotation) onLongPress,
  });

  /// Registers drag event callbacks for the annotations managed by this manager.
  Cancelable dragEvents({
    Function(PolylineAnnotation)? onBegin,
    Function(PolylineAnnotation)? onChanged,
    Function(PolylineAnnotation)? onEnd,
  });

  /// Get all annotations of manager.
  Future<List<PolylineAnnotation>> getAnnotations();

  /// Create a new annotation with the option.
  Future<PolylineAnnotation> create(PolylineAnnotationOptions annotation);

  /// Create multi annotations with the options.
  Future<List<PolylineAnnotation?>> createMulti(
    List<PolylineAnnotationOptions> annotations,
  );

  /// Update an added annotation with new properties.
  Future<void> update(PolylineAnnotation annotation);

  /// Delete an added annotation.
  Future<void> delete(PolylineAnnotation annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll();

  /// Delete multiple annotations added by this manager.
  Future<void> deleteMulti(List<PolylineAnnotation> annotations);

  /// The display of line endings. Default value: "butt".
  Future<void> setLineCap(LineCap lineCap);

  /// The display of line endings. Default value: "butt".
  Future<LineCap?> getLineCap();

  /// Defines the slope of an elevated line. A value of 0 creates a horizontal line. A value of 1 creates a vertical line. Other values are currently not supported. If undefined, the line follows the terrain slope. This is an experimental property with some known issues:  - Vertical lines don't support line caps  - `line-join: round` is not supported with this property
  @experimental
  Future<void> setLineCrossSlope(double lineCrossSlope);

  /// Defines the slope of an elevated line. A value of 0 creates a horizontal line. A value of 1 creates a vertical line. Other values are currently not supported. If undefined, the line follows the terrain slope. This is an experimental property with some known issues:  - Vertical lines don't support line caps  - `line-join: round` is not supported with this property
  @experimental
  Future<double?> getLineCrossSlope();

  /// Controls how much the elevation of lines with `line-elevation-reference` set to `sea` scales with terrain exaggeration. A value of 0 keeps the line at a fixed altitude above sea level. A value of 1 scales the elevation proportionally with terrain exaggeration. Default value: 0. Value range: [0, 1]
  Future<void> setLineElevationGroundScale(double lineElevationGroundScale);

  /// Controls how much the elevation of lines with `line-elevation-reference` set to `sea` scales with terrain exaggeration. A value of 0 keeps the line at a fixed altitude above sea level. A value of 1 scales the elevation proportionally with terrain exaggeration. Default value: 0. Value range: [0, 1]
  Future<double?> getLineElevationGroundScale();

  /// Selects the base of line-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  Future<void> setLineElevationReference(
    LineElevationReference lineElevationReference,
  );

  /// Selects the base of line-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  Future<LineElevationReference?> getLineElevationReference();

  /// The display of lines when joining. Default value: "miter".
  Future<void> setLineJoin(LineJoin lineJoin);

  /// The display of lines when joining. Default value: "miter".
  Future<LineJoin?> getLineJoin();

  /// Used to automatically convert miter joins to bevel joins for sharp angles. Default value: 2.
  Future<void> setLineMiterLimit(double lineMiterLimit);

  /// Used to automatically convert miter joins to bevel joins for sharp angles. Default value: 2.
  Future<double?> getLineMiterLimit();

  /// Used to automatically convert round joins to miter joins for shallow angles. Default value: 1.05.
  Future<void> setLineRoundLimit(double lineRoundLimit);

  /// Used to automatically convert round joins to miter joins for shallow angles. Default value: 1.05.
  Future<double?> getLineRoundLimit();

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<void> setLineSortKey(double lineSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<double?> getLineSortKey();

  /// Selects the unit of line-width. The same unit is automatically used for line-blur and line-offset. Note: This is an experimental property and might be removed in a future release. Default value: "pixels".
  @experimental
  Future<void> setLineWidthUnit(LineWidthUnit lineWidthUnit);

  /// Selects the unit of line-width. The same unit is automatically used for line-blur and line-offset. Note: This is an experimental property and might be removed in a future release. Default value: "pixels".
  @experimental
  Future<LineWidthUnit?> getLineWidthUnit();

  /// Vertical offset from ground, in meters. Not supported for globe projection at the moment. Default value: 0.
  Future<void> setLineZOffset(double lineZOffset);

  /// Vertical offset from ground, in meters. Not supported for globe projection at the moment. Default value: 0.
  Future<double?> getLineZOffset();

  /// Blur applied to the line, in pixels. Default value: 0. Minimum value: 0. The unit of lineBlur is in pixels.
  Future<void> setLineBlur(double lineBlur);

  /// Blur applied to the line, in pixels. Default value: 0. Minimum value: 0. The unit of lineBlur is in pixels.
  Future<double?> getLineBlur();

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color. Default value: "rgba(0, 0, 0, 0)".
  Future<void> setLineBorderColor(int lineBorderColor);

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color. Default value: "rgba(0, 0, 0, 0)".
  Future<int?> getLineBorderColor();

  /// The width of the line border. A value of zero means no border. Default value: 0. Minimum value: 0.
  Future<void> setLineBorderWidth(double lineBorderWidth);

  /// The width of the line border. A value of zero means no border. Default value: 0. Minimum value: 0.
  Future<double?> getLineBorderWidth();

  /// The color with which the line will be drawn. Default value: "#000000".
  Future<void> setLineColor(int lineColor);

  /// The color with which the line will be drawn. Default value: "#000000".
  Future<int?> getLineColor();

  /// The width of the cutout fade effect as a proportion of the cutout width. Default value: 0.4. Value range: [0, 1]
  @experimental
  Future<void> setLineCutoutFadeWidth(double lineCutoutFadeWidth);

  /// The width of the cutout fade effect as a proportion of the cutout width. Default value: 0.4. Value range: [0, 1]
  @experimental
  Future<double?> getLineCutoutFadeWidth();

  /// The opacity of the aboveground objects affected by the line cutout. Cutout for tunnels isn't affected by this property, If set to 0, the cutout is fully transparent. Cutout opacity should have the same value for all layers that specify it. If all layers don't have the same value, it is not specified which value is used. Default value: 1. Value range: [0, 1]
  @experimental
  Future<void> setLineCutoutOpacity(double lineCutoutOpacity);

  /// The opacity of the aboveground objects affected by the line cutout. Cutout for tunnels isn't affected by this property, If set to 0, the cutout is fully transparent. Cutout opacity should have the same value for all layers that specify it. If all layers don't have the same value, it is not specified which value is used. Default value: 1. Value range: [0, 1]
  @experimental
  Future<double?> getLineCutoutOpacity();

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels. Minimum value: 0. The unit of lineDasharray is in line widths.
  Future<void> setLineDasharray(List<double?> lineDasharray);

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels. Minimum value: 0. The unit of lineDasharray is in line widths.
  Future<List<double?>?> getLineDasharray();

  /// This property is deprecated and replaced by line-occlusion-opacity. Value 0 disables occlusion, value 1 means fully occluded. Note: line-occlusion-opacity has the opposite effect - value 1 disables occlusion, value 0 means fully occluded. Default value: 1. Value range: [0, 1]
  Future<void> setLineDepthOcclusionFactor(double lineDepthOcclusionFactor);

  /// This property is deprecated and replaced by line-occlusion-opacity. Value 0 disables occlusion, value 1 means fully occluded. Note: line-occlusion-opacity has the opposite effect - value 1 disables occlusion, value 0 means fully occluded. Default value: 1. Value range: [0, 1]
  Future<double?> getLineDepthOcclusionFactor();

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of lineEmissiveStrength is in intensity.
  Future<void> setLineEmissiveStrength(double lineEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of lineEmissiveStrength is in intensity.
  Future<double?> getLineEmissiveStrength();

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap. Default value: 0. Minimum value: 0. The unit of lineGapWidth is in pixels.
  Future<void> setLineGapWidth(double lineGapWidth);

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap. Default value: 0. Minimum value: 0. The unit of lineGapWidth is in pixels.
  Future<double?> getLineGapWidth();

  /// Opacity multiplier (multiplies line-opacity value) of the line part that is occluded by 3D objects. Value 0 hides occluded part, value 1 means the same opacity as non-occluded part. The property is not supported when `line-opacity` has data-driven styling. Default value: 0. Value range: [0, 1]
  Future<void> setLineOcclusionOpacity(double lineOcclusionOpacity);

  /// Opacity multiplier (multiplies line-opacity value) of the line part that is occluded by 3D objects. Value 0 hides occluded part, value 1 means the same opacity as non-occluded part. The property is not supported when `line-opacity` has data-driven styling. Default value: 0. Value range: [0, 1]
  Future<double?> getLineOcclusionOpacity();

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset. Default value: 0. The unit of lineOffset is in pixels.
  Future<void> setLineOffset(double lineOffset);

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset. Default value: 0. The unit of lineOffset is in pixels.
  Future<double?> getLineOffset();

  /// The opacity at which the line will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setLineOpacity(double lineOpacity);

  /// The opacity at which the line will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getLineOpacity();

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<void> setLinePattern(String linePattern);

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<String?> getLinePattern();

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of lineTranslate is in pixels.
  Future<void> setLineTranslate(List<double?> lineTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of lineTranslate is in pixels.
  Future<List<double?>?> getLineTranslate();

  /// Controls the frame of reference for `line-translate`. Default value: "map".
  Future<void> setLineTranslateAnchor(LineTranslateAnchor lineTranslateAnchor);

  /// Controls the frame of reference for `line-translate`. Default value: "map".
  Future<LineTranslateAnchor?> getLineTranslateAnchor();

  /// The color to be used for rendering the trimmed line section that is defined by the `line-trim-offset` property. Default value: "transparent".
  @experimental
  Future<void> setLineTrimColor(int lineTrimColor);

  /// The color to be used for rendering the trimmed line section that is defined by the `line-trim-offset` property. Default value: "transparent".
  @experimental
  Future<int?> getLineTrimColor();

  /// The fade range for the trim-start and trim-end points is defined by the `line-trim-offset` property. The first element of the array represents the fade range from the trim-start point toward the end of the line, while the second element defines the fade range from the trim-end point toward the beginning of the line. The fade result is achieved by interpolating between `line-trim-color` and the color specified by the `line-color` or the `line-gradient` property. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  @experimental
  Future<void> setLineTrimFadeRange(List<double?> lineTrimFadeRange);

  /// The fade range for the trim-start and trim-end points is defined by the `line-trim-offset` property. The first element of the array represents the fade range from the trim-start point toward the end of the line, while the second element defines the fade range from the trim-end point toward the beginning of the line. The fade result is achieved by interpolating between `line-trim-color` and the color specified by the `line-color` or the `line-gradient` property. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  @experimental
  Future<List<double?>?> getLineTrimFadeRange();

  /// The line part between [trim-start, trim-end] will be painted using `line-trim-color,` which is transparent by default to produce a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0]. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  Future<void> setLineTrimOffset(List<double?> lineTrimOffset);

  /// The line part between [trim-start, trim-end] will be painted using `line-trim-color,` which is transparent by default to produce a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0]. Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  Future<List<double?>?> getLineTrimOffset();

  /// Stroke thickness. Default value: 1. Minimum value: 0. The unit of lineWidth is in pixels.
  Future<void> setLineWidth(double lineWidth);

  /// Stroke thickness. Default value: 1. Minimum value: 0. The unit of lineWidth is in pixels.
  Future<double?> getLineWidth();
}

// End of generated file.
