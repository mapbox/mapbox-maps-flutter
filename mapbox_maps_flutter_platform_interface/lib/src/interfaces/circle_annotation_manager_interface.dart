// This file is generated.
import 'package:meta/meta.dart';

import '../cancelable.dart';
import '../pigeons/annotation_data_types.dart';
import '../pigeons/platform_interface_data_types.dart';
import 'annotations_interface.dart';

/// Abstract interface for managing circle annotations.
abstract interface class CircleAnnotationManagerPlatformInterface
    implements BaseAnnotationManagerPlatformInterface {
  /// Registers tap event callbacks for the annotations managed by this manager.
  Cancelable tapEvents({required Function(CircleAnnotation) onTap});

  /// Registers long press event callbacks for the annotations managed by this manager.
  Cancelable longPressEvents({required Function(CircleAnnotation) onLongPress});

  /// Registers drag event callbacks for the annotations managed by this manager.
  Cancelable dragEvents({
    Function(CircleAnnotation)? onBegin,
    Function(CircleAnnotation)? onChanged,
    Function(CircleAnnotation)? onEnd,
  });

  /// Get all annotations of manager.
  Future<List<CircleAnnotation>> getAnnotations();

  /// Create a new annotation with the option.
  Future<CircleAnnotation> create(CircleAnnotationOptions annotation);

  /// Create multi annotations with the options.
  Future<List<CircleAnnotation?>> createMulti(
    List<CircleAnnotationOptions> annotations,
  );

  /// Update an added annotation with new properties.
  Future<void> update(CircleAnnotation annotation);

  /// Delete an added annotation.
  Future<void> delete(CircleAnnotation annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll();

  /// Delete multiple annotations added by this manager.
  Future<void> deleteMulti(List<CircleAnnotation> annotations);

  /// Selects the base of circle-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  @experimental
  Future<void> setCircleElevationReference(
    CircleElevationReference circleElevationReference,
  );

  /// Selects the base of circle-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  @experimental
  Future<CircleElevationReference?> getCircleElevationReference();

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<void> setCircleSortKey(double circleSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<double?> getCircleSortKey();

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity. Setting a negative value renders the blur as an inner glow effect. Default value: 0.
  Future<void> setCircleBlur(double circleBlur);

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity. Setting a negative value renders the blur as an inner glow effect. Default value: 0.
  Future<double?> getCircleBlur();

  /// The fill color of the circle. Default value: "#000000".
  Future<void> setCircleColor(int circleColor);

  /// The fill color of the circle. Default value: "#000000".
  Future<int?> getCircleColor();

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of circleEmissiveStrength is in intensity.
  Future<void> setCircleEmissiveStrength(double circleEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of circleEmissiveStrength is in intensity.
  Future<double?> getCircleEmissiveStrength();

  /// The opacity at which the circle will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setCircleOpacity(double circleOpacity);

  /// The opacity at which the circle will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getCircleOpacity();

  /// Orientation of circle when map is pitched. Default value: "viewport".
  Future<void> setCirclePitchAlignment(
    CirclePitchAlignment circlePitchAlignment,
  );

  /// Orientation of circle when map is pitched. Default value: "viewport".
  Future<CirclePitchAlignment?> getCirclePitchAlignment();

  /// Controls the scaling behavior of the circle when the map is pitched. Default value: "map".
  Future<void> setCirclePitchScale(CirclePitchScale circlePitchScale);

  /// Controls the scaling behavior of the circle when the map is pitched. Default value: "map".
  Future<CirclePitchScale?> getCirclePitchScale();

  /// Circle radius. Default value: 5. Minimum value: 0. The unit of circleRadius is in pixels.
  Future<void> setCircleRadius(double circleRadius);

  /// Circle radius. Default value: 5. Minimum value: 0. The unit of circleRadius is in pixels.
  Future<double?> getCircleRadius();

  /// The stroke color of the circle. Default value: "#000000".
  Future<void> setCircleStrokeColor(int circleStrokeColor);

  /// The stroke color of the circle. Default value: "#000000".
  Future<int?> getCircleStrokeColor();

  /// The opacity of the circle's stroke. Default value: 1. Value range: [0, 1]
  Future<void> setCircleStrokeOpacity(double circleStrokeOpacity);

  /// The opacity of the circle's stroke. Default value: 1. Value range: [0, 1]
  Future<double?> getCircleStrokeOpacity();

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`. Default value: 0. Minimum value: 0. The unit of circleStrokeWidth is in pixels.
  Future<void> setCircleStrokeWidth(double circleStrokeWidth);

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`. Default value: 0. Minimum value: 0. The unit of circleStrokeWidth is in pixels.
  Future<double?> getCircleStrokeWidth();

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of circleTranslate is in pixels.
  Future<void> setCircleTranslate(List<double?> circleTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of circleTranslate is in pixels.
  Future<List<double?>?> getCircleTranslate();

  /// Controls the frame of reference for `circle-translate`. Default value: "map".
  Future<void> setCircleTranslateAnchor(
    CircleTranslateAnchor circleTranslateAnchor,
  );

  /// Controls the frame of reference for `circle-translate`. Default value: "map".
  Future<CircleTranslateAnchor?> getCircleTranslateAnchor();
}

// End of generated file.
