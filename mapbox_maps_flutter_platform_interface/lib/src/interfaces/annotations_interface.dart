import 'circle_annotation_manager_interface.dart';
import 'point_annotation_manager_interface.dart';
import 'polygon_annotation_manager_interface.dart';
import 'polyline_annotation_manager_interface.dart';

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
  Future<CircleAnnotationManagerPlatformInterface>
  createCircleAnnotationManager({String? id, String? below});

  /// Creates a [PolylineAnnotationManager] for polyline annotations.
  Future<PolylineAnnotationManagerPlatformInterface>
  createPolylineAnnotationManager({String? id, String? below});

  /// Creates a [PolygonAnnotationManager] for polygon (fill) annotations.
  Future<PolygonAnnotationManagerPlatformInterface>
  createPolygonAnnotationManager({String? id, String? below});

  /// Removes an annotation manager and all annotations created by it.
  Future<void> removeAnnotationManager(
    BaseAnnotationManagerPlatformInterface manager,
  );

  /// Removes the annotation manager with the given [id].
  Future<void> removeAnnotationManagerById(String id);
}

/// Base interface for all annotation manager interfaces.
abstract interface class BaseAnnotationManagerPlatformInterface {
  /// The identifier of the annotation layer backing this manager.
  String get id;
}

// {Point, Circle, Polygon, Polyline}AnnotationManagerPlatformInterface
// live in the generated <kind>_annotation_manager_interface.dart files
// (ws4c-point + ws4c-rest lifts).
