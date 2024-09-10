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

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<void> setFillSortKey(double fillSortKey) =>
      messenger.setFillSortKey(id, fillSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<double?> getFillSortKey() => messenger.getFillSortKey(id);

  /// Whether or not the fill should be antialiased. Default value: true.
  Future<void> setFillAntialias(bool fillAntialias) =>
      messenger.setFillAntialias(id, fillAntialias);

  /// Whether or not the fill should be antialiased. Default value: true.
  Future<bool?> getFillAntialias() => messenger.getFillAntialias(id);

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used. Default value: "#000000".
  Future<void> setFillColor(int fillColor) =>
      messenger.setFillColor(id, fillColor);

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used. Default value: "#000000".
  Future<int?> getFillColor() => messenger.getFillColor(id);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0.
  Future<void> setFillEmissiveStrength(double fillEmissiveStrength) =>
      messenger.setFillEmissiveStrength(id, fillEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0.
  Future<double?> getFillEmissiveStrength() =>
      messenger.getFillEmissiveStrength(id);

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used. Default value: 1. Value range: [0, 1]
  Future<void> setFillOpacity(double fillOpacity) =>
      messenger.setFillOpacity(id, fillOpacity);

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used. Default value: 1. Value range: [0, 1]
  Future<double?> getFillOpacity() => messenger.getFillOpacity(id);

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  Future<void> setFillOutlineColor(int fillOutlineColor) =>
      messenger.setFillOutlineColor(id, fillOutlineColor);

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  Future<int?> getFillOutlineColor() => messenger.getFillOutlineColor(id);

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<void> setFillPattern(String fillPattern) =>
      messenger.setFillPattern(id, fillPattern);

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<String?> getFillPattern() => messenger.getFillPattern(id);

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
