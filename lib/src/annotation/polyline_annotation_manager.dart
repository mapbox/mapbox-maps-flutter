// This file is generated.
part of mapbox_maps_flutter;

/// The PolylineAnnotationManager to add/update/delete PolylineAnnotationAnnotations on the map.
class PolylineAnnotationManager extends BaseAnnotationManager {
  PolylineAnnotationManager(
      {required String id, required BinaryMessenger messenger})
      : super(id: id, messenger: messenger);

  late _PolylineAnnotationMessenger messenger =
      _PolylineAnnotationMessenger(binaryMessenger: _messenger);

  /// Add a listener to receive the callback when an annotation is clicked.
  void addOnPolylineAnnotationClickListener(
      OnPolylineAnnotationClickListener listener) {
    OnPolylineAnnotationClickListener.setUp(listener,
        binaryMessenger: _messenger);
  }

  /// Create a new annotation with the option.
  Future<PolylineAnnotation> create(PolylineAnnotationOptions annotation) =>
      messenger.create(id, annotation);

  /// Create multi annotations with the options.
  Future<List<PolylineAnnotation?>> createMulti(
          List<PolylineAnnotationOptions> annotations) =>
      messenger.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  Future<void> update(PolylineAnnotation annotation) =>
      messenger.update(id, annotation);

  /// Delete an added annotation.
  Future<void> delete(PolylineAnnotation annotation) =>
      messenger.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => messenger.deleteAll(id);

  /// The display of line endings.
  Future<void> setLineCap(LineCap lineCap) => messenger.setLineCap(id, lineCap);

  /// The display of line endings.
  Future<LineCap?> getLineCap() => messenger.getLineCap(id);

  /// Used to automatically convert miter joins to bevel joins for sharp angles.
  Future<void> setLineMiterLimit(double lineMiterLimit) =>
      messenger.setLineMiterLimit(id, lineMiterLimit);

  /// Used to automatically convert miter joins to bevel joins for sharp angles.
  Future<double?> getLineMiterLimit() => messenger.getLineMiterLimit(id);

  /// Used to automatically convert round joins to miter joins for shallow angles.
  Future<void> setLineRoundLimit(double lineRoundLimit) =>
      messenger.setLineRoundLimit(id, lineRoundLimit);

  /// Used to automatically convert round joins to miter joins for shallow angles.
  Future<double?> getLineRoundLimit() => messenger.getLineRoundLimit(id);

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<void> setLineDasharray(List<double?> lineDasharray) =>
      messenger.setLineDasharray(id, lineDasharray);

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<List<double?>?> getLineDasharray() => messenger.getLineDasharray(id);

  /// Decrease line layer opacity based on occlusion from 3D objects. Value 0 disables occlusion, value 1 means fully occluded.
  Future<void> setLineDepthOcclusionFactor(double lineDepthOcclusionFactor) =>
      messenger.setLineDepthOcclusionFactor(id, lineDepthOcclusionFactor);

  /// Decrease line layer opacity based on occlusion from 3D objects. Value 0 disables occlusion, value 1 means fully occluded.
  Future<double?> getLineDepthOcclusionFactor() =>
      messenger.getLineDepthOcclusionFactor(id);

  /// Controls the intensity of light emitted on the source features.
  Future<void> setLineEmissiveStrength(double lineEmissiveStrength) =>
      messenger.setLineEmissiveStrength(id, lineEmissiveStrength);

  /// Controls the intensity of light emitted on the source features.
  Future<double?> getLineEmissiveStrength() =>
      messenger.getLineEmissiveStrength(id);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  Future<void> setLineTranslate(List<double?> lineTranslate) =>
      messenger.setLineTranslate(id, lineTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  Future<List<double?>?> getLineTranslate() => messenger.getLineTranslate(id);

  /// Controls the frame of reference for `line-translate`.
  Future<void> setLineTranslateAnchor(
          LineTranslateAnchor lineTranslateAnchor) =>
      messenger.setLineTranslateAnchor(id, lineTranslateAnchor);

  /// Controls the frame of reference for `line-translate`.
  Future<LineTranslateAnchor?> getLineTranslateAnchor() =>
      messenger.getLineTranslateAnchor(id);

  /// The line part between [trim-start, trim-end] will be marked as transparent to make a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0].
  Future<void> setLineTrimOffset(List<double?> lineTrimOffset) =>
      messenger.setLineTrimOffset(id, lineTrimOffset);

  /// The line part between [trim-start, trim-end] will be marked as transparent to make a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0].
  Future<List<double?>?> getLineTrimOffset() => messenger.getLineTrimOffset(id);
}
// End of generated file.
