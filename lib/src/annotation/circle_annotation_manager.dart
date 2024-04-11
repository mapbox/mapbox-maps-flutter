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
    OnCircleAnnotationClickListener.setup(listener,
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

  /// Controls the intensity of light emitted on the source features.
  Future<void> setCircleEmissiveStrength(double circleEmissiveStrength) =>
      messenger.setCircleEmissiveStrength(id, circleEmissiveStrength);

  /// Controls the intensity of light emitted on the source features.
  Future<double?> getCircleEmissiveStrength() =>
      messenger.getCircleEmissiveStrength(id);

  /// Orientation of circle when map is pitched.
  Future<void> setCirclePitchAlignment(
          CirclePitchAlignment circlePitchAlignment) =>
      messenger.setCirclePitchAlignment(id, circlePitchAlignment);

  /// Orientation of circle when map is pitched.
  Future<CirclePitchAlignment?> getCirclePitchAlignment() =>
      messenger.getCirclePitchAlignment(id);

  /// Controls the scaling behavior of the circle when the map is pitched.
  Future<void> setCirclePitchScale(CirclePitchScale circlePitchScale) =>
      messenger.setCirclePitchScale(id, circlePitchScale);

  /// Controls the scaling behavior of the circle when the map is pitched.
  Future<CirclePitchScale?> getCirclePitchScale() =>
      messenger.getCirclePitchScale(id);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  Future<void> setCircleTranslate(List<double?> circleTranslate) =>
      messenger.setCircleTranslate(id, circleTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  Future<List<double?>?> getCircleTranslate() =>
      messenger.getCircleTranslate(id);

  /// Controls the frame of reference for `circle-translate`.
  Future<void> setCircleTranslateAnchor(
          CircleTranslateAnchor circleTranslateAnchor) =>
      messenger.setCircleTranslateAnchor(id, circleTranslateAnchor);

  /// Controls the frame of reference for `circle-translate`.
  Future<CircleTranslateAnchor?> getCircleTranslateAnchor() =>
      messenger.getCircleTranslateAnchor(id);
}
// End of generated file.
