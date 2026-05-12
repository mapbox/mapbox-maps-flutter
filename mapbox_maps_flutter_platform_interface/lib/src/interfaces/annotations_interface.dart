/// Abstract interface for the annotation manager factory.
///
/// Provides methods for creating typed annotation managers for each
/// annotation kind supported by the Mapbox Maps SDK.
abstract interface class AnnotationManagerInterface {
  /// Creates a [PointAnnotationManager] for point annotations.
  ///
  /// [id] — optional layer/source identifier.
  /// [below] — optional id of the layer above which the annotation layer is placed.
  Future<PointAnnotationManagerInterface> createPointAnnotationManager({
    String? id,
    String? below,
  });

  /// Creates a [CircleAnnotationManager] for circle annotations.
  Future<CircleAnnotationManagerInterface> createCircleAnnotationManager({
    String? id,
    String? below,
  });

  /// Creates a [PolylineAnnotationManager] for polyline annotations.
  Future<PolylineAnnotationManagerInterface> createPolylineAnnotationManager({
    String? id,
    String? below,
  });

  /// Creates a [PolygonAnnotationManager] for polygon (fill) annotations.
  Future<PolygonAnnotationManagerInterface> createPolygonAnnotationManager({
    String? id,
    String? below,
  });

  /// Removes an annotation manager and all annotations created by it.
  Future<void> removeAnnotationManager(BaseAnnotationManagerInterface manager);

  /// Removes the annotation manager with the given [id].
  Future<void> removeAnnotationManagerById(String id);
}

/// Base interface for all annotation manager interfaces.
abstract interface class BaseAnnotationManagerInterface {
  /// The identifier of the annotation layer backing this manager.
  String get id;
}

/// Abstract interface for managing point annotations.
abstract interface class PointAnnotationManagerInterface
    implements BaseAnnotationManagerInterface {}

/// Abstract interface for managing circle annotations.
abstract interface class CircleAnnotationManagerInterface
    implements BaseAnnotationManagerInterface {}

/// Abstract interface for managing polyline annotations.
abstract interface class PolylineAnnotationManagerInterface
    implements BaseAnnotationManagerInterface {}

/// Abstract interface for managing polygon annotations.
abstract interface class PolygonAnnotationManagerInterface
    implements BaseAnnotationManagerInterface {}
