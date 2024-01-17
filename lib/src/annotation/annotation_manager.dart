part of mapbox_maps_flutter;

class _AnnotationManager {
  final _MapboxMapsPlatform _mapboxMapsPlatform;

  _AnnotationManager({required _MapboxMapsPlatform mapboxMapsPlatform})
      : _mapboxMapsPlatform = mapboxMapsPlatform;

  /// Create a [PointAnnotationManager] to add/remove/update [PointAnnotation]s on the map.
  ///
  /// If [id] is specified, the string is used as an identifier for a layer and a source backing the create manager.
  /// Use [below] to specify the id of the layer above the annotation layer.
  Future<PointAnnotationManager> createPointAnnotationManager(
      {String? id, String? below}) async {
    return _mapboxMapsPlatform
        .createAnnotationManager('point', id: id, belowLayerId: below)
        .then((value) => PointAnnotationManager(
            id: value, messenger: _mapboxMapsPlatform.binaryMessenger));
  }

  /// Create a [CircleAnnotationManager] to add/remove/update [CircleAnnotation]s on the map.
  ///
  /// If [id] is specified, the string is used as an identifier for a layer and a source backing the create manager.
  /// Use [below] to specify the id of the layer above the annotation layer.
  Future<CircleAnnotationManager> createCircleAnnotationManager(
      {String? id, String? below}) async {
    return _mapboxMapsPlatform
        .createAnnotationManager('circle', id: id, belowLayerId: below)
        .then((value) => CircleAnnotationManager(
            id: value, messenger: _mapboxMapsPlatform.binaryMessenger));
  }

  /// Create a [PolylineAnnotationManager] to add/remove/update [PolylineAnnotation]s on the map.
  ///
  /// If [id] is specified, the string is used as an identifier for a layer and a source backing the create manager.
  /// Use [below] to specify the id of the layer above the annotation layer.
  Future<PolylineAnnotationManager> createPolylineAnnotationManager(
      {String? id, String? below}) async {
    return _mapboxMapsPlatform
        .createAnnotationManager('polyline', id: id, belowLayerId: below)
        .then((value) => PolylineAnnotationManager(
            id: value, messenger: _mapboxMapsPlatform.binaryMessenger));
  }

  /// Create a [PolygonAnnotationManager] to add/remove/update [PolygonAnnotation]s on the map.
  ///
  /// If [id] is specified, the string is used as an identifier for a layer and a source backing the create manager.
  /// Use [below] to specify the id of the layer above the annotation layer.
  Future<PolygonAnnotationManager> createPolygonAnnotationManager(
      {String? id, String? below}) async {
    return _mapboxMapsPlatform
        .createAnnotationManager('polygon', id: id, belowLayerId: below)
        .then((value) => PolygonAnnotationManager(
            id: value, messenger: _mapboxMapsPlatform.binaryMessenger));
  }

  /// Remove an [AnnotationManager] and all the annotations created by it.
  Future<void> removeAnnotationManager(BaseAnnotationManager manager) async {
    return _mapboxMapsPlatform.removeAnnotationManager(manager.id);
  }

  /// Remove an [AnnotationManager] with the specified [id] and all the annotation created by it.
  Future<void> removeAnnotationManagerById(String id) async {
    return _mapboxMapsPlatform.removeAnnotationManager(id);
  }
}

/// The super class for all AnnotationManagers.
class BaseAnnotationManager {
  BaseAnnotationManager(
      {required String id, required BinaryMessenger messenger})
      : this.id = id,
        _messenger = messenger;
  final String id;
  final BinaryMessenger _messenger;
}
