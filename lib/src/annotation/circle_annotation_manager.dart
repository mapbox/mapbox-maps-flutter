// This file is generated.
part of mapbox_maps_flutter;

/// The CircleAnnotationManager to add/update/delete CircleAnnotationAnnotations on the map.
class CircleAnnotationManager extends BaseAnnotationManager {
  CircleAnnotationManager(
      {required String id, required BinaryMessenger messenger})
      : super(id: id, messenger: messenger);

  late _CircleAnnotationMessager messager =
      _CircleAnnotationMessager(binaryMessenger: _messenger);

  /// Add a listener to receive the callback when an annotation is clicked.
  void addOnCircleAnnotationClickListener(
      OnCircleAnnotationClickListener listener) {
    OnCircleAnnotationClickListener.setup(listener,
        binaryMessenger: _messenger);
  }

  /// Create a new annotation with the option.
  Future<CircleAnnotation> create(CircleAnnotationOptions annotation) =>
      messager.create(id, annotation);

  /// Create multi annotations with the options.
  Future<List<CircleAnnotation?>> createMulti(
          List<CircleAnnotationOptions> annotations) =>
      messager.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  Future<void> update(CircleAnnotation annotation) =>
      messager.update(id, annotation);

  /// Delete an added annotation.
  Future<void> delete(CircleAnnotation annotation) =>
      messager.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => messager.deleteAll(id);

  /// Orientation of circle when map is pitched.
  Future<void> setCirclePitchAlignment(
          CirclePitchAlignment circlePitchAlignment) =>
      messager.setCirclePitchAlignment(id, circlePitchAlignment);

  /// Orientation of circle when map is pitched.
  Future<CirclePitchAlignment?> getCirclePitchAlignment() =>
      messager.getCirclePitchAlignment(id).then(
          (value) => value != null ? CirclePitchAlignment.values[value] : null);

  /// Controls the scaling behavior of the circle when the map is pitched.
  Future<void> setCirclePitchScale(CirclePitchScale circlePitchScale) =>
      messager.setCirclePitchScale(id, circlePitchScale);

  /// Controls the scaling behavior of the circle when the map is pitched.
  Future<CirclePitchScale?> getCirclePitchScale() => messager
      .getCirclePitchScale(id)
      .then((value) => value != null ? CirclePitchScale.values[value] : null);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  Future<void> setCircleTranslate(List<double?> circleTranslate) =>
      messager.setCircleTranslate(id, circleTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  Future<List<double?>?> getCircleTranslate() =>
      messager.getCircleTranslate(id);

  /// Controls the frame of reference for `circle-translate`.
  Future<void> setCircleTranslateAnchor(
          CircleTranslateAnchor circleTranslateAnchor) =>
      messager.setCircleTranslateAnchor(id, circleTranslateAnchor);

  /// Controls the frame of reference for `circle-translate`.
  Future<CircleTranslateAnchor?> getCircleTranslateAnchor() =>
      messager.getCircleTranslateAnchor(id).then((value) =>
          value != null ? CircleTranslateAnchor.values[value] : null);
}
// End of generated file.
