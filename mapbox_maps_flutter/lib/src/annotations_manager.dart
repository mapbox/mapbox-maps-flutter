import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import 'annotation/circle_annotation_manager_facade.dart';
import 'annotation/point_annotation_manager_facade.dart';
import 'annotation/polygon_annotation_manager_facade.dart';
import 'annotation/polyline_annotation_manager_facade.dart';

/// Factory for creating typed annotation managers.
class AnnotationManager {
  final AnnotationManagerPlatformInterface _impl;

  @internal
  AnnotationManager(this._impl);

  /// Creates a [PointAnnotationManager] for point annotations.
  Future<PointAnnotationManager> createPointAnnotationManager({
    String? id,
    String? below,
  }) async {
    final impl = await _impl.createPointAnnotationManager(id: id, below: below);
    return PointAnnotationManager(impl);
  }

  /// Creates a [CircleAnnotationManager] for circle annotations.
  Future<CircleAnnotationManager> createCircleAnnotationManager({
    String? id,
    String? below,
  }) async {
    final impl = await _impl.createCircleAnnotationManager(
      id: id,
      below: below,
    );
    return CircleAnnotationManager(impl);
  }

  /// Creates a [PolylineAnnotationManager] for polyline annotations.
  Future<PolylineAnnotationManager> createPolylineAnnotationManager({
    String? id,
    String? below,
  }) async {
    final impl = await _impl.createPolylineAnnotationManager(
      id: id,
      below: below,
    );
    return PolylineAnnotationManager(impl);
  }

  /// Creates a [PolygonAnnotationManager] for polygon (fill) annotations.
  Future<PolygonAnnotationManager> createPolygonAnnotationManager({
    String? id,
    String? below,
  }) async {
    final impl = await _impl.createPolygonAnnotationManager(
      id: id,
      below: below,
    );
    return PolygonAnnotationManager(impl);
  }

  /// Removes an annotation manager and all annotations created by it.
  Future<void> removeAnnotationManager(BaseAnnotationManager manager) =>
      _impl.removeAnnotationManager(manager._impl);

  /// Removes the annotation manager with the given [id].
  Future<void> removeAnnotationManagerById(String id) =>
      _impl.removeAnnotationManagerById(id);
}

/// Base class for all annotation managers.
///
/// Parameterized on the platform-interface type so subclasses can read
/// [impl] already typed as their concrete `XxxAnnotationManagerPlatformInterface`
/// without holding a duplicate field.
abstract base class BaseAnnotationManager<
  T extends BaseAnnotationManagerPlatformInterface
> {
  final T _impl;

  @internal
  BaseAnnotationManager(this._impl);

  /// Platform-interface implementation backing this manager.
  ///
  /// Exposed for use by typed subclass wrappers; not part of the public
  /// customer API. Lint-flagged via [protected] when called from outside
  /// a subclass.
  @protected
  T get impl => _impl;

  /// The identifier of the annotation layer backing this manager.
  String get id => _impl.id;
}

// {Point, Circle, Polygon, Polyline}AnnotationManager wrappers live in
// the generated annotation/<kind>_annotation_manager_facade.dart files
// (ws4c-point + ws4c-rest lifts).
