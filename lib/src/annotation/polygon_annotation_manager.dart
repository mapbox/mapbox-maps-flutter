// This file is generated.
part of mapbox_maps_flutter;

/// The PolygonAnnotationManager to add/update/delete PolygonAnnotationAnnotations on the map.
class PolygonAnnotationManager extends BaseAnnotationManager {
  PolygonAnnotationManager(
      {required String id, required BinaryMessenger messenger})
      : super(id: id, messenger: messenger);

  late _PolygonAnnotationMessenger messenger =
      _PolygonAnnotationMessenger(binaryMessenger: _messenger);

  /// Add a listener to receive the callback when an annotation is clicked.
  void addOnPolygonAnnotationClickListener(
      OnPolygonAnnotationClickListener listener) {
    OnPolygonAnnotationClickListener.setUp(listener,
        binaryMessenger: _messenger);
  }

  /// Create a new annotation with the option.
  Future<PolygonAnnotation> create(PolygonAnnotationOptions annotation) =>
      messenger.create(id, annotation);

  /// Create multi annotations with the options.
  Future<List<PolygonAnnotation?>> createMulti(
          List<PolygonAnnotationOptions> annotations) =>
      messenger.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  Future<void> update(PolygonAnnotation annotation) =>
      messenger.update(id, annotation);

  /// Delete an added annotation.
  Future<void> delete(PolygonAnnotation annotation) =>
      messenger.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => messenger.deleteAll(id);

  /// Whether or not the fill should be antialiased. Default value: true.
  Future<void> setFillAntialias(bool fillAntialias) =>
      messenger.setFillAntialias(id, fillAntialias);

  /// Whether or not the fill should be antialiased. Default value: true.
  Future<bool?> getFillAntialias() => messenger.getFillAntialias(id);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0.
  Future<void> setFillEmissiveStrength(double fillEmissiveStrength) =>
      messenger.setFillEmissiveStrength(id, fillEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0.
  Future<double?> getFillEmissiveStrength() =>
      messenger.getFillEmissiveStrength(id);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0].
  Future<void> setFillTranslate(List<double?> fillTranslate) =>
      messenger.setFillTranslate(id, fillTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0].
  Future<List<double?>?> getFillTranslate() => messenger.getFillTranslate(id);

  /// Controls the frame of reference for `fill-translate`. Default value: "map".
  Future<void> setFillTranslateAnchor(
          FillTranslateAnchor fillTranslateAnchor) =>
      messenger.setFillTranslateAnchor(id, fillTranslateAnchor);

  /// Controls the frame of reference for `fill-translate`. Default value: "map".
  Future<FillTranslateAnchor?> getFillTranslateAnchor() =>
      messenger.getFillTranslateAnchor(id);
}
// End of generated file.
