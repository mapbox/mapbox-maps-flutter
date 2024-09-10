// This file is generated.
part of mapbox_maps_flutter;

/// The CircleAnnotationManager to add/update/delete CircleAnnotationAnnotations on the map.
class CircleAnnotationManager extends BaseAnnotationManager {
  CircleAnnotationManager(
      {required String id, required BinaryMessenger messenger})
      : super(id: id, messenger: messenger);

  late _CircleAnnotationMessenger messenger =
      _CircleAnnotationMessenger(binaryMessenger: _messenger);

  /// Add a listener to receive the callback when an annotation is clicked.
  void addOnCircleAnnotationClickListener(
      OnCircleAnnotationClickListener listener) {
    OnCircleAnnotationClickListener.setUp(listener,
        binaryMessenger: _messenger);
  }

  /// Create a new annotation with the option.
  Future<CircleAnnotation> create(CircleAnnotationOptions annotation) =>
      messenger.create(id, annotation);

  /// Create multi annotations with the options.
  Future<List<CircleAnnotation?>> createMulti(
          List<CircleAnnotationOptions> annotations) =>
      messenger.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  Future<void> update(CircleAnnotation annotation) =>
      messenger.update(id, annotation);

  /// Delete an added annotation.
  Future<void> delete(CircleAnnotation annotation) =>
      messenger.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => messenger.deleteAll(id);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<void> setCircleSortKey(double circleSortKey) =>
      messenger.setCircleSortKey(id, circleSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<double?> getCircleSortKey() => messenger.getCircleSortKey(id);

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity. Setting a negative value renders the blur as an inner glow effect. Default value: 0.
  Future<void> setCircleBlur(double circleBlur) =>
      messenger.setCircleBlur(id, circleBlur);

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity. Setting a negative value renders the blur as an inner glow effect. Default value: 0.
  Future<double?> getCircleBlur() => messenger.getCircleBlur(id);

  /// The fill color of the circle. Default value: "#000000".
  Future<void> setCircleColor(int circleColor) =>
      messenger.setCircleColor(id, circleColor);

  /// The fill color of the circle. Default value: "#000000".
  Future<int?> getCircleColor() => messenger.getCircleColor(id);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0.
  Future<void> setCircleEmissiveStrength(double circleEmissiveStrength) =>
      messenger.setCircleEmissiveStrength(id, circleEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0.
  Future<double?> getCircleEmissiveStrength() =>
      messenger.getCircleEmissiveStrength(id);

  /// The opacity at which the circle will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setCircleOpacity(double circleOpacity) =>
      messenger.setCircleOpacity(id, circleOpacity);

  /// The opacity at which the circle will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getCircleOpacity() => messenger.getCircleOpacity(id);

  /// Orientation of circle when map is pitched. Default value: "viewport".
  Future<void> setCirclePitchAlignment(
          CirclePitchAlignment circlePitchAlignment) =>
      messenger.setCirclePitchAlignment(id, circlePitchAlignment);

  /// Orientation of circle when map is pitched. Default value: "viewport".
  Future<CirclePitchAlignment?> getCirclePitchAlignment() =>
      messenger.getCirclePitchAlignment(id);

  /// Controls the scaling behavior of the circle when the map is pitched. Default value: "map".
  Future<void> setCirclePitchScale(CirclePitchScale circlePitchScale) =>
      messenger.setCirclePitchScale(id, circlePitchScale);

  /// Controls the scaling behavior of the circle when the map is pitched. Default value: "map".
  Future<CirclePitchScale?> getCirclePitchScale() =>
      messenger.getCirclePitchScale(id);

  /// Circle radius. Default value: 5. Minimum value: 0.
  Future<void> setCircleRadius(double circleRadius) =>
      messenger.setCircleRadius(id, circleRadius);

  /// Circle radius. Default value: 5. Minimum value: 0.
  Future<double?> getCircleRadius() => messenger.getCircleRadius(id);

  /// The stroke color of the circle. Default value: "#000000".
  Future<void> setCircleStrokeColor(int circleStrokeColor) =>
      messenger.setCircleStrokeColor(id, circleStrokeColor);

  /// The stroke color of the circle. Default value: "#000000".
  Future<int?> getCircleStrokeColor() => messenger.getCircleStrokeColor(id);

  /// The opacity of the circle's stroke. Default value: 1. Value range: [0, 1]
  Future<void> setCircleStrokeOpacity(double circleStrokeOpacity) =>
      messenger.setCircleStrokeOpacity(id, circleStrokeOpacity);

  /// The opacity of the circle's stroke. Default value: 1. Value range: [0, 1]
  Future<double?> getCircleStrokeOpacity() =>
      messenger.getCircleStrokeOpacity(id);

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`. Default value: 0. Minimum value: 0.
  Future<void> setCircleStrokeWidth(double circleStrokeWidth) =>
      messenger.setCircleStrokeWidth(id, circleStrokeWidth);

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`. Default value: 0. Minimum value: 0.
  Future<double?> getCircleStrokeWidth() => messenger.getCircleStrokeWidth(id);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0].
  Future<void> setCircleTranslate(List<double?> circleTranslate) =>
      messenger.setCircleTranslate(id, circleTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0].
  Future<List<double?>?> getCircleTranslate() =>
      messenger.getCircleTranslate(id);

  /// Controls the frame of reference for `circle-translate`. Default value: "map".
  Future<void> setCircleTranslateAnchor(
          CircleTranslateAnchor circleTranslateAnchor) =>
      messenger.setCircleTranslateAnchor(id, circleTranslateAnchor);

  /// Controls the frame of reference for `circle-translate`. Default value: "map".
  Future<CircleTranslateAnchor?> getCircleTranslateAnchor() =>
      messenger.getCircleTranslateAnchor(id);
}
// End of generated file.
