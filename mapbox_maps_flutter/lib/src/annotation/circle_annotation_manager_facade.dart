// This file is generated.
import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../annotations_manager.dart' show BaseAnnotationManager;

/// Manages circle annotations.
final class CircleAnnotationManager
    extends BaseAnnotationManager<CircleAnnotationManagerPlatformInterface> {
  @internal
  CircleAnnotationManager(CircleAnnotationManagerPlatformInterface super.impl);

  /// Registers tap event callbacks for the annotations managed by this manager.
  ///
  /// Note: Tap events will now not propagate to annotations below the topmost one. If you tap on overlapping annotations, only the top annotation's tap event will be triggered.
  Cancelable tapEvents({required Function(CircleAnnotation) onTap}) => impl
      .tapInteractionStream
      .listen((data) => onTap(data.annotation))
      .asCancelable();

  /// Registers long press event callbacks for the annotations managed by this manager.
  ///
  /// Note: This event will be triggered simultaneously with the [dragEvents] `onBegin` if the annotation is draggable.
  Cancelable longPressEvents({
    required Function(CircleAnnotation) onLongPress,
  }) => impl.longPressInteractionStream
      .listen((data) => onLongPress(data.annotation))
      .asCancelable();

  /// Registers drag event callbacks for the annotations managed by this manager.
  ///
  /// - [onBegin]: Triggered when a drag gesture begins on an annotation.
  /// - [onChanged]: Triggered continuously as the annotation is being dragged.
  /// - [onEnd]: Triggered when the drag gesture ends.
  ///
  /// This method returns a [Cancelable] object that can be used to cancel
  /// the drag event listener when it's no longer needed.
  Cancelable dragEvents({
    Function(CircleAnnotation)? onBegin,
    Function(CircleAnnotation)? onChanged,
    Function(CircleAnnotation)? onEnd,
  }) => impl.dragInteractionStream.listen((data) {
    switch (data.gestureState) {
      case GestureState.started when onBegin != null:
        onBegin(data.annotation);
      case GestureState.changed when onChanged != null:
        onChanged(data.annotation);
      case GestureState.ended when onEnd != null:
        onEnd(data.annotation);
      default:
        break;
    }
  }).asCancelable();

  /// Get all annotations of manager.
  Future<List<CircleAnnotation>> getAnnotations() => impl.getAnnotations();

  /// Create a new annotation with the option.
  Future<CircleAnnotation> create(CircleAnnotationOptions annotation) =>
      impl.create(annotation);

  /// Create multi annotations with the options.
  Future<List<CircleAnnotation?>> createMulti(
    List<CircleAnnotationOptions> annotations,
  ) => impl.createMulti(annotations);

  /// Update an added annotation with new properties.
  Future<void> update(CircleAnnotation annotation) => impl.update(annotation);

  /// Delete an added annotation.
  Future<void> delete(CircleAnnotation annotation) => impl.delete(annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => impl.deleteAll();

  /// Delete multiple annotations added by this manager.
  Future<void> deleteMulti(List<CircleAnnotation> annotations) =>
      impl.deleteMulti(annotations);

  /// Selects the base of circle-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  @experimental
  Future<void> setCircleElevationReference(
    CircleElevationReference circleElevationReference,
  ) => impl.setCircleElevationReference(circleElevationReference);

  /// Selects the base of circle-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  @experimental
  Future<CircleElevationReference?> getCircleElevationReference() =>
      impl.getCircleElevationReference();

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<void> setCircleSortKey(double circleSortKey) =>
      impl.setCircleSortKey(circleSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<double?> getCircleSortKey() => impl.getCircleSortKey();

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity. Setting a negative value renders the blur as an inner glow effect. Default value: 0.
  Future<void> setCircleBlur(double circleBlur) =>
      impl.setCircleBlur(circleBlur);

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity. Setting a negative value renders the blur as an inner glow effect. Default value: 0.
  Future<double?> getCircleBlur() => impl.getCircleBlur();

  /// The fill color of the circle. Default value: "#000000".
  Future<void> setCircleColor(int circleColor) =>
      impl.setCircleColor(circleColor);

  /// The fill color of the circle. Default value: "#000000".
  Future<int?> getCircleColor() => impl.getCircleColor();

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of circleEmissiveStrength is in intensity.
  Future<void> setCircleEmissiveStrength(double circleEmissiveStrength) =>
      impl.setCircleEmissiveStrength(circleEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of circleEmissiveStrength is in intensity.
  Future<double?> getCircleEmissiveStrength() =>
      impl.getCircleEmissiveStrength();

  /// The opacity at which the circle will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setCircleOpacity(double circleOpacity) =>
      impl.setCircleOpacity(circleOpacity);

  /// The opacity at which the circle will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getCircleOpacity() => impl.getCircleOpacity();

  /// Orientation of circle when map is pitched. Default value: "viewport".
  Future<void> setCirclePitchAlignment(
    CirclePitchAlignment circlePitchAlignment,
  ) => impl.setCirclePitchAlignment(circlePitchAlignment);

  /// Orientation of circle when map is pitched. Default value: "viewport".
  Future<CirclePitchAlignment?> getCirclePitchAlignment() =>
      impl.getCirclePitchAlignment();

  /// Controls the scaling behavior of the circle when the map is pitched. Default value: "map".
  Future<void> setCirclePitchScale(CirclePitchScale circlePitchScale) =>
      impl.setCirclePitchScale(circlePitchScale);

  /// Controls the scaling behavior of the circle when the map is pitched. Default value: "map".
  Future<CirclePitchScale?> getCirclePitchScale() => impl.getCirclePitchScale();

  /// Circle radius. Default value: 5. Minimum value: 0. The unit of circleRadius is in pixels.
  Future<void> setCircleRadius(double circleRadius) =>
      impl.setCircleRadius(circleRadius);

  /// Circle radius. Default value: 5. Minimum value: 0. The unit of circleRadius is in pixels.
  Future<double?> getCircleRadius() => impl.getCircleRadius();

  /// The stroke color of the circle. Default value: "#000000".
  Future<void> setCircleStrokeColor(int circleStrokeColor) =>
      impl.setCircleStrokeColor(circleStrokeColor);

  /// The stroke color of the circle. Default value: "#000000".
  Future<int?> getCircleStrokeColor() => impl.getCircleStrokeColor();

  /// The opacity of the circle's stroke. Default value: 1. Value range: [0, 1]
  Future<void> setCircleStrokeOpacity(double circleStrokeOpacity) =>
      impl.setCircleStrokeOpacity(circleStrokeOpacity);

  /// The opacity of the circle's stroke. Default value: 1. Value range: [0, 1]
  Future<double?> getCircleStrokeOpacity() => impl.getCircleStrokeOpacity();

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`. Default value: 0. Minimum value: 0. The unit of circleStrokeWidth is in pixels.
  Future<void> setCircleStrokeWidth(double circleStrokeWidth) =>
      impl.setCircleStrokeWidth(circleStrokeWidth);

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`. Default value: 0. Minimum value: 0. The unit of circleStrokeWidth is in pixels.
  Future<double?> getCircleStrokeWidth() => impl.getCircleStrokeWidth();

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of circleTranslate is in pixels.
  Future<void> setCircleTranslate(List<double?> circleTranslate) =>
      impl.setCircleTranslate(circleTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of circleTranslate is in pixels.
  Future<List<double?>?> getCircleTranslate() => impl.getCircleTranslate();

  /// Controls the frame of reference for `circle-translate`. Default value: "map".
  Future<void> setCircleTranslateAnchor(
    CircleTranslateAnchor circleTranslateAnchor,
  ) => impl.setCircleTranslateAnchor(circleTranslateAnchor);

  /// Controls the frame of reference for `circle-translate`. Default value: "map".
  Future<CircleTranslateAnchor?> getCircleTranslateAnchor() =>
      impl.getCircleTranslateAnchor();
}

// End of generated file.
