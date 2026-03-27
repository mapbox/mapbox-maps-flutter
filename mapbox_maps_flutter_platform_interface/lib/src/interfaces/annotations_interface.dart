/// Abstract interface for the annotation manager factory.
///
/// Provides methods for creating typed annotation managers for each
/// annotation kind supported by the Mapbox Maps SDK.
abstract interface class AnnotationManagerPlatformInterface {
  /// Creates a [PointAnnotationManager] for point annotations.
  ///
  /// [id] — optional layer/source identifier.
  /// [below] — optional id of the layer above which the annotation layer is placed.
  Future<PointAnnotationManagerPlatformInterface> createPointAnnotationManager({
    String? id,
    String? below,
  });

  /// Creates a [CircleAnnotationManager] for circle annotations.
  Future<CircleAnnotationManagerPlatformInterface> createCircleAnnotationManager({
    String? id,
    String? below,
  });

  /// Creates a [PolylineAnnotationManager] for polyline annotations.
  Future<PolylineAnnotationManagerPlatformInterface> createPolylineAnnotationManager({
    String? id,
    String? below,
  });

  /// Creates a [PolygonAnnotationManager] for polygon (fill) annotations.
  Future<PolygonAnnotationManagerPlatformInterface> createPolygonAnnotationManager({
    String? id,
    String? below,
  });

  /// Removes an annotation manager and all annotations created by it.
  Future<void> removeAnnotationManager(BaseAnnotationManagerPlatformInterface manager);

  /// Removes the annotation manager with the given [id].
  Future<void> removeAnnotationManagerById(String id);
}

/// Base interface for all annotation manager interfaces.
abstract interface class BaseAnnotationManagerPlatformInterface {
  /// The identifier of the annotation layer backing this manager.
  String get id;
}

/// Abstract interface for managing point annotations.
abstract interface class PointAnnotationManagerPlatformInterface
    implements BaseAnnotationManagerPlatformInterface {}

/// Abstract interface for managing circle annotations.
abstract interface class CircleAnnotationManagerPlatformInterface
    implements BaseAnnotationManagerPlatformInterface {}

/// Abstract interface for managing polyline annotations.
abstract interface class PolylineAnnotationManagerPlatformInterface
    implements BaseAnnotationManagerPlatformInterface {}

/// Abstract interface for managing polygon annotations.
abstract interface class PolygonAnnotationManagerPlatformInterface
    implements BaseAnnotationManagerPlatformInterface {}
