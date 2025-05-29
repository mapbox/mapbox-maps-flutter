// This file is generated.
part of mapbox_maps_flutter;

/// The PolygonAnnotationManager to add/update/delete PolygonAnnotationAnnotations on the map.
class PolygonAnnotationManager extends BaseAnnotationManager {
  PolygonAnnotationManager._(
      {required super.id,
      required super.messenger,
      required String channelSuffix})
      : _annotationMessenger = _PolygonAnnotationMessenger(
            binaryMessenger: messenger, messageChannelSuffix: channelSuffix),
        _channelSuffix = channelSuffix,
        super._();

  final _PolygonAnnotationMessenger _annotationMessenger;
  final String _channelSuffix;

  /// Add a listener to receive the callback when an annotation is clicked.
  void addOnPolygonAnnotationClickListener(
      OnPolygonAnnotationClickListener listener) {
    OnPolygonAnnotationClickListener.setUp(listener,
        binaryMessenger: _messenger, messageChannelSuffix: _channelSuffix);
  }

  /// Registers drag event callbacks for the annotations managed by this instance.
  ///
  /// - [onBegin]: Triggered when a drag gesture begins on an annotation.
  /// - [onChanged]: Triggered continuously as the annotation is being dragged.
  /// - [onEnd]: Triggered when the drag gesture ends.
  ///
  /// This method returns a [Cancelable] object that can be used to cancel
  /// the drag event listener when it's no longer needed.
  /// Example usage:
  /// ```dart
  /// manager.dragEvents(
  ///   onBegin: (annotation) {
  ///     print("Drag started for: ${annotation.id}");
  ///   },
  ///   onChanged: (annotation) {
  ///     print("Dragging at: ${annotation.geometry}");
  ///   },
  ///   onEnd: (annotation) {
  ///     print("Drag ended at: ${annotation.geometry}");
  ///   },
  /// );
  /// ```
  Cancelable dragEvents({
    Function(PolygonAnnotation)? onBegin,
    Function(PolygonAnnotation)? onChanged,
    Function(PolygonAnnotation)? onEnd,
  }) {
    return _annotationDragEvents(instanceName: "$_channelSuffix/$id")
        .cast<PolygonAnnotationInteractionContext>()
        .listen((data) {
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
  }

  /// Create a new annotation with the option.
  Future<PolygonAnnotation> create(PolygonAnnotationOptions annotation) =>
      _annotationMessenger.create(id, annotation);

  /// Create multi annotations with the options.
  Future<List<PolygonAnnotation?>> createMulti(
          List<PolygonAnnotationOptions> annotations) =>
      _annotationMessenger.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  Future<void> update(PolygonAnnotation annotation) =>
      _annotationMessenger.update(id, annotation);

  /// Delete an added annotation.
  Future<void> delete(PolygonAnnotation annotation) =>
      _annotationMessenger.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => _annotationMessenger.deleteAll(id);

  /// Determines whether bridge guard rails are added for elevated roads. Default value: "true".
  @experimental
  Future<void> setFillConstructBridgeGuardRail(
          bool fillConstructBridgeGuardRail) =>
      _annotationMessenger.setFillConstructBridgeGuardRail(
          id, fillConstructBridgeGuardRail);

  /// Determines whether bridge guard rails are added for elevated roads. Default value: "true".
  @experimental
  Future<bool?> getFillConstructBridgeGuardRail() =>
      _annotationMessenger.getFillConstructBridgeGuardRail(id);

  /// Selects the base of fill-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  @experimental
  Future<void> setFillElevationReference(
          FillElevationReference fillElevationReference) =>
      _annotationMessenger.setFillElevationReference(
          id, fillElevationReference);

  /// Selects the base of fill-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  @experimental
  Future<FillElevationReference?> getFillElevationReference() =>
      _annotationMessenger.getFillElevationReference(id);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<void> setFillSortKey(double fillSortKey) =>
      _annotationMessenger.setFillSortKey(id, fillSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<double?> getFillSortKey() => _annotationMessenger.getFillSortKey(id);

  /// Whether or not the fill should be antialiased. Default value: true.
  Future<void> setFillAntialias(bool fillAntialias) =>
      _annotationMessenger.setFillAntialias(id, fillAntialias);

  /// Whether or not the fill should be antialiased. Default value: true.
  Future<bool?> getFillAntialias() => _annotationMessenger.getFillAntialias(id);

  /// The color of bridge guard rail. Default value: "rgba(241, 236, 225, 255)".
  @experimental
  Future<void> setFillBridgeGuardRailColor(int fillBridgeGuardRailColor) =>
      _annotationMessenger.setFillBridgeGuardRailColor(
          id, fillBridgeGuardRailColor);

  /// The color of bridge guard rail. Default value: "rgba(241, 236, 225, 255)".
  @experimental
  Future<int?> getFillBridgeGuardRailColor() =>
      _annotationMessenger.getFillBridgeGuardRailColor(id);

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used. Default value: "#000000".
  Future<void> setFillColor(int fillColor) =>
      _annotationMessenger.setFillColor(id, fillColor);

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used. Default value: "#000000".
  Future<int?> getFillColor() => _annotationMessenger.getFillColor(id);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of fillEmissiveStrength is in intensity.
  Future<void> setFillEmissiveStrength(double fillEmissiveStrength) =>
      _annotationMessenger.setFillEmissiveStrength(id, fillEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of fillEmissiveStrength is in intensity.
  Future<double?> getFillEmissiveStrength() =>
      _annotationMessenger.getFillEmissiveStrength(id);

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used. Default value: 1. Value range: [0, 1]
  Future<void> setFillOpacity(double fillOpacity) =>
      _annotationMessenger.setFillOpacity(id, fillOpacity);

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used. Default value: 1. Value range: [0, 1]
  Future<double?> getFillOpacity() => _annotationMessenger.getFillOpacity(id);

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  Future<void> setFillOutlineColor(int fillOutlineColor) =>
      _annotationMessenger.setFillOutlineColor(id, fillOutlineColor);

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  Future<int?> getFillOutlineColor() =>
      _annotationMessenger.getFillOutlineColor(id);

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<void> setFillPattern(String fillPattern) =>
      _annotationMessenger.setFillPattern(id, fillPattern);

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<String?> getFillPattern() => _annotationMessenger.getFillPattern(id);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of fillTranslate is in pixels.
  Future<void> setFillTranslate(List<double?> fillTranslate) =>
      _annotationMessenger.setFillTranslate(id, fillTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of fillTranslate is in pixels.
  Future<List<double?>?> getFillTranslate() =>
      _annotationMessenger.getFillTranslate(id);

  /// Controls the frame of reference for `fill-translate`. Default value: "map".
  Future<void> setFillTranslateAnchor(
          FillTranslateAnchor fillTranslateAnchor) =>
      _annotationMessenger.setFillTranslateAnchor(id, fillTranslateAnchor);

  /// Controls the frame of reference for `fill-translate`. Default value: "map".
  Future<FillTranslateAnchor?> getFillTranslateAnchor() =>
      _annotationMessenger.getFillTranslateAnchor(id);

  /// The color of tunnel structures (tunnel entrance and tunnel walls). Default value: "rgba(241, 236, 225, 255)".
  @experimental
  Future<void> setFillTunnelStructureColor(int fillTunnelStructureColor) =>
      _annotationMessenger.setFillTunnelStructureColor(
          id, fillTunnelStructureColor);

  /// The color of tunnel structures (tunnel entrance and tunnel walls). Default value: "rgba(241, 236, 225, 255)".
  @experimental
  Future<int?> getFillTunnelStructureColor() =>
      _annotationMessenger.getFillTunnelStructureColor(id);

  /// Specifies an uniform elevation in meters. Note: If the value is zero, the layer will be rendered on the ground. Non-zero values will elevate the layer from the sea level, which can cause it to be rendered below the terrain. Default value: 0. Minimum value: 0.
  @experimental
  Future<void> setFillZOffset(double fillZOffset) =>
      _annotationMessenger.setFillZOffset(id, fillZOffset);

  /// Specifies an uniform elevation in meters. Note: If the value is zero, the layer will be rendered on the ground. Non-zero values will elevate the layer from the sea level, which can cause it to be rendered below the terrain. Default value: 0. Minimum value: 0.
  @experimental
  Future<double?> getFillZOffset() => _annotationMessenger.getFillZOffset(id);
}
// End of generated file.
