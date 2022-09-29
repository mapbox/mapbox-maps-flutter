part of mapbox_maps;

class _AnnotationManager {
  final _MapboxMapsPlatform _mapboxMapsPlatform;

  _AnnotationManager({required _MapboxMapsPlatform mapboxMapsPlatform})
      : _mapboxMapsPlatform = mapboxMapsPlatform;

  /// Create a PointAnnotationManager to add/remove/update PointAnnotations on the map.
  Future<PointAnnotationManager> createPointAnnotationManager() async {
    return _mapboxMapsPlatform
        .createAnnotationManager('point')
        .then((value) => PointAnnotationManager(id: value));
  }

  /// Create a CircleAnnotationManager to add/remove/update CircleAnnotations on the map.
  Future<CircleAnnotationManager> createCircleAnnotationManager() async {
    return _mapboxMapsPlatform
        .createAnnotationManager('circle')
        .then((value) => CircleAnnotationManager(id: value));
  }

  /// Create a PolylineAnnotationManager to add/remove/update PolylineAnnotations on the map.
  Future<PolylineAnnotationManager> createPolylineAnnotationManager() async {
    return _mapboxMapsPlatform
        .createAnnotationManager('polyline')
        .then((value) => PolylineAnnotationManager(id: value));
  }

  /// Create a PolygonAnnotationManager to add/remove/update PolygonAnnotations on the map.
  Future<PolygonAnnotationManager> createPolygonAnnotationManager() async {
    return _mapboxMapsPlatform
        .createAnnotationManager('polygon')
        .then((value) => PolygonAnnotationManager(id: value));
  }

  /// Remove an AnnotationManager and all the annotations created by it.
  Future<void> removeAnnotationManager(BaseAnnotationManager manager) async {
    _mapboxMapsPlatform.removeAnnotationManager(manager.id);
  }
}

/// The super class for all AnnotationManagers.
class BaseAnnotationManager {
  BaseAnnotationManager({required String id}) : this.id = id;
  final String id;
}
