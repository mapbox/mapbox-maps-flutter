// This file is generated.
import 'package:pigeon/pigeon.dart';

/// Orientation of circle when map is pitched.
enum CirclePitchAlignment {
  /// The circle is aligned to the plane of the map.
  MAP,
  /// The circle is aligned to the plane of the viewport.
  VIEWPORT,
}

/// Controls the scaling behavior of the circle when the map is pitched.
enum CirclePitchScale {
  /// Circles are scaled according to their apparent distance to the camera.
  MAP,
  /// Circles are not scaled.
  VIEWPORT,
}

/// Controls the frame of reference for `circle-translate`.
enum CircleTranslateAnchor {
  /// The circle is translated relative to the map.
  MAP,
  /// The circle is translated relative to the viewport.
  VIEWPORT,
}

@FlutterApi
abstract class OnCircleAnnotationClickListener {
  void onCircleAnnotationClick(CircleAnnotation annotation);
}

@HostApi
abstract class _CircleAnnotationMessager {
  @async
  CircleAnnotation create(String managerId, CircleAnnotationOptions annotationOption);
  @async
  List<CircleAnnotation> createMulti(String managerId, List<CircleAnnotationOptions> annotationOptions);
  @async
  void update(String managerId, CircleAnnotation annotation);
  @async
  void delete(String managerId, CircleAnnotation annotation);
  @async
  void deleteAll(String managerId);
  @async
  void setCirclePitchAlignment(String managerId, CirclePitchAlignment circlePitchAlignment);
  @async
  int? getCirclePitchAlignment(String managerId);
  @async
  void setCirclePitchScale(String managerId, CirclePitchScale circlePitchScale);
  @async
  int? getCirclePitchScale(String managerId);
  @async
  void setCircleTranslate(String managerId, List<double?> circleTranslate);
  @async
  List<double?>? getCircleTranslate(String managerId);
  @async
  void setCircleTranslateAnchor(String managerId, CircleTranslateAnchor circleTranslateAnchor);
  @async
  int? getCircleTranslateAnchor(String managerId);
}

class CircleAnnotation {
  /// The id for annotation
  String id;
  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;
  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? circleSortKey;
  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity.
  double? circleBlur;
  /// The fill color of the circle.
  int? circleColor;
  /// The opacity at which the circle will be drawn.
  double? circleOpacity;
  /// Circle radius.
  double? circleRadius;
  /// The stroke color of the circle.
  int? circleStrokeColor;
  /// The opacity of the circle's stroke.
  double? circleStrokeOpacity;
  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`.
  double? circleStrokeWidth;
}

class CircleAnnotationOptions {
  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;
  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? circleSortKey;
  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity.
  double? circleBlur;
  /// The fill color of the circle.
  int? circleColor;
  /// The opacity at which the circle will be drawn.
  double? circleOpacity;
  /// Circle radius.
  double? circleRadius;
  /// The stroke color of the circle.
  int? circleStrokeColor;
  /// The opacity of the circle's stroke.
  double? circleStrokeOpacity;
  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`.
  double? circleStrokeWidth;
}
// End of generated file.