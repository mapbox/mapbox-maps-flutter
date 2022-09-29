// This file is generated.
import 'package:pigeon/pigeon.dart';

/// Controls the frame of reference for `fill-translate`.
enum FillTranslateAnchor {
  /// The fill is translated relative to the map.
  MAP,
  /// The fill is translated relative to the viewport.
  VIEWPORT,
}

@FlutterApi
abstract class OnPolygonAnnotationClickListener {
  void onPolygonAnnotationClick(PolygonAnnotation annotation);
}

@HostApi
abstract class _PolygonAnnotationMessager {
  @async
  PolygonAnnotation create(String managerId, PolygonAnnotationOptions annotationOption);
  @async
  List<PolygonAnnotation> createMulti(String managerId, List<PolygonAnnotationOptions> annotationOptions);
  @async
  void update(String managerId, PolygonAnnotation annotation);
  @async
  void delete(String managerId, PolygonAnnotation annotation);
  @async
  void deleteAll(String managerId);
  @async
  void setFillAntialias(String managerId, bool fillAntialias);
  @async
  bool? getFillAntialias(String managerId);
  @async
  void setFillTranslate(String managerId, List<double?> fillTranslate);
  @async
  List<double?>? getFillTranslate(String managerId);
  @async
  void setFillTranslateAnchor(String managerId, FillTranslateAnchor fillTranslateAnchor);
  @async
  int? getFillTranslateAnchor(String managerId);
}

class PolygonAnnotation {
  /// The id for annotation
  String id;
  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;
  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? fillSortKey;
  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used.
  int? fillColor;
  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used.
  double? fillOpacity;
  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  int? fillOutlineColor;
  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? fillPattern;
}

class PolygonAnnotationOptions {
  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;
  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? fillSortKey;
  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used.
  int? fillColor;
  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used.
  double? fillOpacity;
  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  int? fillOutlineColor;
  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? fillPattern;
}
// End of generated file.