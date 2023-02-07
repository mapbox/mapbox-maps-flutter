// This file is generated.
part of mapbox_maps_flutter;

/// The PolygonAnnotationManager to add/update/delete PolygonAnnotationAnnotations on the map.
class PolygonAnnotationManager extends BaseAnnotationManager {
  PolygonAnnotationManager(
      {required String id, required BinaryMessenger messenger})
      : super(id: id, messenger: messenger);

  late _PolygonAnnotationMessager messager =
      _PolygonAnnotationMessager(binaryMessenger: _messenger);

  /// Add a listener to receive the callback when an annotation is clicked.
  void addOnPolygonAnnotationClickListener(
      OnPolygonAnnotationClickListener listener) {
    OnPolygonAnnotationClickListener.setup(listener,
        binaryMessenger: _messenger);
  }

  /// Create a new annotation with the option.
  Future<PolygonAnnotation> create(PolygonAnnotationOptions annotation) =>
      messager.create(id, annotation);

  /// Create multi annotations with the options.
  Future<List<PolygonAnnotation?>> createMulti(
          List<PolygonAnnotationOptions> annotations) =>
      messager.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  Future<void> update(PolygonAnnotation annotation) =>
      messager.update(id, annotation);

  /// Delete an added annotation.
  Future<void> delete(PolygonAnnotation annotation) =>
      messager.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => messager.deleteAll(id);

  /// Whether or not the fill should be antialiased.
  Future<void> setFillAntialias(bool fillAntialias) =>
      messager.setFillAntialias(id, fillAntialias);

  /// Whether or not the fill should be antialiased.
  Future<bool?> getFillAntialias() => messager.getFillAntialias(id);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  Future<void> setFillTranslate(List<double?> fillTranslate) =>
      messager.setFillTranslate(id, fillTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  Future<List<double?>?> getFillTranslate() => messager.getFillTranslate(id);

  /// Controls the frame of reference for `fill-translate`.
  Future<void> setFillTranslateAnchor(
          FillTranslateAnchor fillTranslateAnchor) =>
      messager.setFillTranslateAnchor(id, fillTranslateAnchor);

  /// Controls the frame of reference for `fill-translate`.
  Future<FillTranslateAnchor?> getFillTranslateAnchor() =>
      messager.getFillTranslateAnchor(id).then(
          (value) => value != null ? FillTranslateAnchor.values[value] : null);
}
// End of generated file.
