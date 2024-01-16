part of mapbox_maps_flutter;

class _AnnotationManager {
  final _MapboxMapsPlatform _mapboxMapsPlatform;

  _AnnotationManager({required _MapboxMapsPlatform mapboxMapsPlatform})
      : _mapboxMapsPlatform = mapboxMapsPlatform;

  /// Create a PointAnnotationManager to add/remove/update PointAnnotations on the map.
  Future<PointAnnotationManager> createPointAnnotationManager(
      {String? id, String? belowLayerId}) async {
    return _mapboxMapsPlatform
        .createAnnotationManager('point', id: id, belowLayerId: belowLayerId)
        .then((value) => PointAnnotationManager(
            id: value, messenger: _mapboxMapsPlatform.binaryMessenger));
  }

  /// Create a CircleAnnotationManager to add/remove/update CircleAnnotations on the map.
  Future<CircleAnnotationManager> createCircleAnnotationManager(
      {String? id, String? belowLayerId}) async {
    return _mapboxMapsPlatform
        .createAnnotationManager('circle', id: id, belowLayerId: belowLayerId)
        .then((value) => CircleAnnotationManager(
            id: value, messenger: _mapboxMapsPlatform.binaryMessenger));
  }

  /// Create a PolylineAnnotationManager to add/remove/update PolylineAnnotations on the map.
  Future<PolylineAnnotationManager> createPolylineAnnotationManager(
      {String? id, String? belowLayerId}) async {
    return _mapboxMapsPlatform
        .createAnnotationManager('polyline', id: id, belowLayerId: belowLayerId)
        .then((value) => PolylineAnnotationManager(
            id: value, messenger: _mapboxMapsPlatform.binaryMessenger));
  }

  /// Create a PolygonAnnotationManager to add/remove/update PolygonAnnotations on the map.
  Future<PolygonAnnotationManager> createPolygonAnnotationManager(
      {String? id, String? belowLayerId}) async {
    return _mapboxMapsPlatform
        .createAnnotationManager('polygon', id: id, belowLayerId: belowLayerId)
        .then((value) => PolygonAnnotationManager(
            id: value, messenger: _mapboxMapsPlatform.binaryMessenger));
  }

  /// Remove an AnnotationManager and all the annotations created by it.
  Future<void> removeAnnotationManager(BaseAnnotationManager manager) async {
    _mapboxMapsPlatform.removeAnnotationManager(manager.id);
  }

  /// Remove an [AnnotationManager] with the specified [id] and all the annotation created by it.
  Future<void> removeAnnotationManagerById(String id) async {
    _mapboxMapsPlatform.removeAnnotationManager(id);
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
