// This file is generated.
part of mapbox_maps_flutter;

/// The CircleAnnotationManager to add/update/delete CircleAnnotationAnnotations on the map.
class CircleAnnotationManager extends BaseAnnotationManager {
  CircleAnnotationManager._(
      {required super.id,
      required super.messenger,
      required String channelSuffix})
      : _annotationMessenger = _CircleAnnotationMessenger(
            binaryMessenger: messenger, messageChannelSuffix: channelSuffix),
        _channelSuffix = channelSuffix,
        super._();

  final _CircleAnnotationMessenger _annotationMessenger;
  final String _channelSuffix;

  /// Add a listener to receive the callback when an annotation is clicked.
  void addOnCircleAnnotationClickListener(
      OnCircleAnnotationClickListener listener) {
    OnCircleAnnotationClickListener.setUp(listener,
        binaryMessenger: _messenger, messageChannelSuffix: _channelSuffix);
  }

  /// Create a new annotation with the option.
  Future<CircleAnnotation> create(CircleAnnotationOptions annotation) =>
      _annotationMessenger.create(id, annotation);

  /// Create multi annotations with the options.
  Future<List<CircleAnnotation?>> createMulti(
          List<CircleAnnotationOptions> annotations) =>
      _annotationMessenger.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  Future<void> update(CircleAnnotation annotation) =>
      _annotationMessenger.update(id, annotation);

  /// Delete an added annotation.
  Future<void> delete(CircleAnnotation annotation) =>
      _annotationMessenger.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => _annotationMessenger.deleteAll(id);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<void> setCircleSortKey(double circleSortKey) =>
      _annotationMessenger.setCircleSortKey(id, circleSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<double?> getCircleSortKey() =>
      _annotationMessenger.getCircleSortKey(id);

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity. Setting a negative value renders the blur as an inner glow effect. Default value: 0.
  Future<void> setCircleBlur(double circleBlur) =>
      _annotationMessenger.setCircleBlur(id, circleBlur);

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity. Setting a negative value renders the blur as an inner glow effect. Default value: 0.
  Future<double?> getCircleBlur() => _annotationMessenger.getCircleBlur(id);

  /// The fill color of the circle. Default value: "#000000".
  Future<void> setCircleColor(int circleColor) =>
      _annotationMessenger.setCircleColor(id, circleColor);

  /// The fill color of the circle. Default value: "#000000".
  Future<int?> getCircleColor() => _annotationMessenger.getCircleColor(id);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0.
  Future<void> setCircleEmissiveStrength(double circleEmissiveStrength) =>
      _annotationMessenger.setCircleEmissiveStrength(
          id, circleEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0.
  Future<double?> getCircleEmissiveStrength() =>
      _annotationMessenger.getCircleEmissiveStrength(id);

  /// The opacity at which the circle will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setCircleOpacity(double circleOpacity) =>
      _annotationMessenger.setCircleOpacity(id, circleOpacity);

  /// The opacity at which the circle will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getCircleOpacity() =>
      _annotationMessenger.getCircleOpacity(id);

  /// Orientation of circle when map is pitched. Default value: "viewport".
  Future<void> setCirclePitchAlignment(
          CirclePitchAlignment circlePitchAlignment) =>
      _annotationMessenger.setCirclePitchAlignment(id, circlePitchAlignment);

  /// Orientation of circle when map is pitched. Default value: "viewport".
  Future<CirclePitchAlignment?> getCirclePitchAlignment() =>
      _annotationMessenger.getCirclePitchAlignment(id);

  /// Controls the scaling behavior of the circle when the map is pitched. Default value: "map".
  Future<void> setCirclePitchScale(CirclePitchScale circlePitchScale) =>
      _annotationMessenger.setCirclePitchScale(id, circlePitchScale);

  /// Controls the scaling behavior of the circle when the map is pitched. Default value: "map".
  Future<CirclePitchScale?> getCirclePitchScale() =>
      _annotationMessenger.getCirclePitchScale(id);

  /// Circle radius. Default value: 5. Minimum value: 0.
  Future<void> setCircleRadius(double circleRadius) =>
      _annotationMessenger.setCircleRadius(id, circleRadius);

  /// Circle radius. Default value: 5. Minimum value: 0.
  Future<double?> getCircleRadius() => _annotationMessenger.getCircleRadius(id);

  /// The stroke color of the circle. Default value: "#000000".
  Future<void> setCircleStrokeColor(int circleStrokeColor) =>
      _annotationMessenger.setCircleStrokeColor(id, circleStrokeColor);

  /// The stroke color of the circle. Default value: "#000000".
  Future<int?> getCircleStrokeColor() =>
      _annotationMessenger.getCircleStrokeColor(id);

  /// The opacity of the circle's stroke. Default value: 1. Value range: [0, 1]
  Future<void> setCircleStrokeOpacity(double circleStrokeOpacity) =>
      _annotationMessenger.setCircleStrokeOpacity(id, circleStrokeOpacity);

  /// The opacity of the circle's stroke. Default value: 1. Value range: [0, 1]
  Future<double?> getCircleStrokeOpacity() =>
      _annotationMessenger.getCircleStrokeOpacity(id);

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`. Default value: 0. Minimum value: 0.
  Future<void> setCircleStrokeWidth(double circleStrokeWidth) =>
      _annotationMessenger.setCircleStrokeWidth(id, circleStrokeWidth);

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`. Default value: 0. Minimum value: 0.
  Future<double?> getCircleStrokeWidth() =>
      _annotationMessenger.getCircleStrokeWidth(id);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0].
  Future<void> setCircleTranslate(List<double?> circleTranslate) =>
      _annotationMessenger.setCircleTranslate(id, circleTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0].
  Future<List<double?>?> getCircleTranslate() =>
      _annotationMessenger.getCircleTranslate(id);

  /// Controls the frame of reference for `circle-translate`. Default value: "map".
  Future<void> setCircleTranslateAnchor(
          CircleTranslateAnchor circleTranslateAnchor) =>
      _annotationMessenger.setCircleTranslateAnchor(id, circleTranslateAnchor);

  /// Controls the frame of reference for `circle-translate`. Default value: "map".
  Future<CircleTranslateAnchor?> getCircleTranslateAnchor() =>
      _annotationMessenger.getCircleTranslateAnchor(id);
}
// End of generated file.
