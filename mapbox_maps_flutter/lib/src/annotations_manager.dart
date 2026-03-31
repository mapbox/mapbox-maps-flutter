import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

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
abstract class BaseAnnotationManager {
  final BaseAnnotationManagerPlatformInterface _impl;

  @internal
  BaseAnnotationManager(this._impl);

  /// The identifier of the annotation layer backing this manager.
  String get id => _impl.id;
}

/// Manages point annotations.
class PointAnnotationManager extends BaseAnnotationManager {
  @internal
  PointAnnotationManager(PointAnnotationManagerPlatformInterface super.impl);
}

/// Manages circle annotations.
class CircleAnnotationManager extends BaseAnnotationManager {
  @internal
  CircleAnnotationManager(CircleAnnotationManagerPlatformInterface super.impl);
}

/// Manages polyline annotations.
class PolylineAnnotationManager extends BaseAnnotationManager {
  @internal
  PolylineAnnotationManager(
    PolylineAnnotationManagerPlatformInterface super.impl,
  );
}

/// Manages polygon annotations.
class PolygonAnnotationManager extends BaseAnnotationManager {
  @internal
  PolygonAnnotationManager(
    PolygonAnnotationManagerPlatformInterface super.impl,
  );
}
