import 'package:turf/turf.dart';

import '../pigeons/platform_interface_data_types.dart';

/// Collection of [Spherical Mercator](http://docs.openlayers.org/library/spherical_mercator.html)
/// projection methods.
abstract interface class ProjectionPlatformInterface {
  /// Distance in meters spanned by one pixel at [latitude] and [zoom].
  Future<double> getMetersPerPixelAtLatitude(double latitude, double zoom);

  /// Converts a longitude-latitude pair to Spherical Mercator projected meters.
  Future<ProjectedMeters> projectedMetersForCoordinate(Point coordinate);

  /// Converts Spherical Mercator projected meters to a longitude-latitude pair.
  Future<Point> coordinateForProjectedMeters(ProjectedMeters projectedMeters);

  /// Converts a coordinate to a Mercator-projected point at [zoomScale].
  Future<MercatorCoordinate> project(Point coordinate, double zoomScale);

  /// Converts a Mercator-projected point back to a longitude-latitude pair.
  Future<Point> unproject(MercatorCoordinate coordinate, double zoomScale);
}
