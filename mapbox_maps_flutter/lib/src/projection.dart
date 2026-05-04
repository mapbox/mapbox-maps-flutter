import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart';

/// Collection of [Spherical Mercator](http://docs.openlayers.org/library/spherical_mercator.html)
/// projection methods.
class Projection {
  final ProjectionPlatformInterface _impl;

  @internal
  Projection(this._impl);

  /// Distance in meters spanned by one pixel at [latitude] and [zoom].
  Future<double> getMetersPerPixelAtLatitude(double latitude, double zoom) =>
      _impl.getMetersPerPixelAtLatitude(latitude, zoom);

  /// Converts a longitude-latitude pair to Spherical Mercator projected meters.
  Future<ProjectedMeters> projectedMetersForCoordinate(Point coordinate) =>
      _impl.projectedMetersForCoordinate(coordinate);

  /// Converts Spherical Mercator projected meters to a longitude-latitude pair.
  Future<Point> coordinateForProjectedMeters(ProjectedMeters projectedMeters) =>
      _impl.coordinateForProjectedMeters(projectedMeters);

  /// Converts a coordinate to a Mercator-projected point at [zoomScale].
  Future<MercatorCoordinate> project(Point coordinate, double zoomScale) =>
      _impl.project(coordinate, zoomScale);

  /// Converts a Mercator-projected point back to a longitude-latitude pair.
  Future<Point> unproject(MercatorCoordinate coordinate, double zoomScale) =>
      _impl.unproject(coordinate, zoomScale);
}
