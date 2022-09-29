// This file is generated.
import 'package:pigeon/pigeon.dart';

/// The display of line endings.
enum LineCap {
  /// A cap with a squared-off end which is drawn to the exact endpoint of the line.
  BUTT,
  /// A cap with a rounded end which is drawn beyond the endpoint of the line at a radius of one-half of the line's width and centered on the endpoint of the line.
  ROUND,
  /// A cap with a squared-off end which is drawn beyond the endpoint of the line at a distance of one-half of the line's width.
  SQUARE,
}

/// The display of lines when joining.
enum LineJoin {
  /// A join with a squared-off end which is drawn beyond the endpoint of the line at a distance of one-half of the line's width.
  BEVEL,
  /// A join with a rounded end which is drawn beyond the endpoint of the line at a radius of one-half of the line's width and centered on the endpoint of the line.
  ROUND,
  /// A join with a sharp, angled corner which is drawn with the outer sides beyond the endpoint of the path until they meet.
  MITER,
}

/// Controls the frame of reference for `line-translate`.
enum LineTranslateAnchor {
  /// The line is translated relative to the map.
  MAP,
  /// The line is translated relative to the viewport.
  VIEWPORT,
}

@FlutterApi
abstract class OnPolylineAnnotationClickListener {
  void onPolylineAnnotationClick(PolylineAnnotation annotation);
}

@HostApi
abstract class _PolylineAnnotationMessager {
  @async
  PolylineAnnotation create(String managerId, PolylineAnnotationOptions annotationOption);
  @async
  List<PolylineAnnotation> createMulti(String managerId, List<PolylineAnnotationOptions> annotationOptions);
  @async
  void update(String managerId, PolylineAnnotation annotation);
  @async
  void delete(String managerId, PolylineAnnotation annotation);
  @async
  void deleteAll(String managerId);
  @async
  void setLineCap(String managerId, LineCap lineCap);
  @async
  int? getLineCap(String managerId);
  @async
  void setLineMiterLimit(String managerId, double lineMiterLimit);
  @async
  double? getLineMiterLimit(String managerId);
  @async
  void setLineRoundLimit(String managerId, double lineRoundLimit);
  @async
  double? getLineRoundLimit(String managerId);
  @async
  void setLineDasharray(String managerId, List<double?> lineDasharray);
  @async
  List<double?>? getLineDasharray(String managerId);
  @async
  void setLineTranslate(String managerId, List<double?> lineTranslate);
  @async
  List<double?>? getLineTranslate(String managerId);
  @async
  void setLineTranslateAnchor(String managerId, LineTranslateAnchor lineTranslateAnchor);
  @async
  int? getLineTranslateAnchor(String managerId);
  @async
  void setLineTrimOffset(String managerId, List<double?> lineTrimOffset);
  @async
  List<double?>? getLineTrimOffset(String managerId);
}

class PolylineAnnotation {
  /// The id for annotation
  String id;
  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;
  /// The display of lines when joining.
  LineJoin? lineJoin;
  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? lineSortKey;
  /// Blur applied to the line, in pixels.
  double? lineBlur;
  /// The color with which the line will be drawn.
  int? lineColor;
  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap.
  double? lineGapWidth;
  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset.
  double? lineOffset;
  /// The opacity at which the line will be drawn.
  double? lineOpacity;
  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? linePattern;
  /// Stroke thickness.
  double? lineWidth;
}

class PolylineAnnotationOptions {
  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;
  /// The display of lines when joining.
  LineJoin? lineJoin;
  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? lineSortKey;
  /// Blur applied to the line, in pixels.
  double? lineBlur;
  /// The color with which the line will be drawn.
  int? lineColor;
  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap.
  double? lineGapWidth;
  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset.
  double? lineOffset;
  /// The opacity at which the line will be drawn.
  double? lineOpacity;
  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? linePattern;
  /// Stroke thickness.
  double? lineWidth;
}
// End of generated file.