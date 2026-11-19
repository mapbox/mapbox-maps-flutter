import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:turf/turf.dart';

/// Collection of [Spherical Mercator](http://docs.openlayers.org/library/spherical_mercator.html)
/// projection methods.
///
/// The methods are pure Dart and give the same results on all platforms. They
/// use no map state: the style projection, terrain and camera do not change
/// the results. A latitude outside ±85.051128779806604 is clamped to that
/// range.
class Projection {
  @internal
  const Projection();

  static const double _earthRadius = 6371008.8;
  static const double _latitudeMax = 85.051128779806604;
  static const double _longitudeMax = 180;
  static const double _zoomMin = 0;
  static const double _zoomMax = 25.5;
  static const double _tileSize = 512;
  static const double _deg2rad = math.pi / 180;
  static const double _rad2deg = 180 / math.pi;

  /// Keeps `sin(latitude)` away from ±1, where the northing formula divides
  /// by zero.
  static const double _sinLimit = 1 - 1e-15;

  /// Distance in meters spanned by one pixel at [latitude] and [zoom].
  Future<double> getMetersPerPixelAtLatitude(
    double latitude,
    double zoom,
  ) async {
    final lat = _clampLatitude(latitude);
    final worldSize =
        _tileSize * math.pow(2, zoom.clamp(_zoomMin, _zoomMax).toDouble());
    return math.cos(lat * _deg2rad) * 2 * math.pi * _earthRadius / worldSize;
  }

  /// Converts a longitude-latitude pair to Spherical Mercator projected meters.
  Future<ProjectedMeters> projectedMetersForCoordinate(Point coordinate) async {
    final lat = _clampLatitude(coordinate.coordinates.lat.toDouble());
    final lng = _clampLongitude(coordinate.coordinates.lng.toDouble());
    final f = math.sin(lat * _deg2rad).clamp(-_sinLimit, _sinLimit).toDouble();
    return ProjectedMeters(
      northing: 0.5 * _earthRadius * math.log((1 + f) / (1 - f)),
      easting: _earthRadius * lng * _deg2rad,
    );
  }

  /// Converts Spherical Mercator projected meters to a longitude-latitude pair.
  Future<Point> coordinateForProjectedMeters(
    ProjectedMeters projectedMeters,
  ) async {
    final lat =
        (2 * math.atan(math.exp(projectedMeters.northing / _earthRadius)) -
            math.pi / 2) *
        _rad2deg;
    final lng = projectedMeters.easting * _rad2deg / _earthRadius;
    return Point(
      coordinates: Position(_clampLongitude(lng), _clampLatitude(lat)),
    );
  }

  /// Converts a coordinate to a Mercator-projected point at [zoomScale].
  Future<MercatorCoordinate> project(Point coordinate, double zoomScale) async {
    final lat = _clampLatitude(coordinate.coordinates.lat.toDouble());
    final lng = coordinate.coordinates.lng.toDouble();
    final scale = _tileSize * zoomScale / 360;
    return MercatorCoordinate(
      x: (180 + lng) * scale,
      y:
          (180 -
              _rad2deg *
                  math.log(math.tan(math.pi / 4 + lat * math.pi / 360))) *
          scale,
    );
  }

  /// Converts a Mercator-projected point back to a longitude-latitude pair.
  Future<Point> unproject(
    MercatorCoordinate coordinate,
    double zoomScale,
  ) async {
    final scale = 360 / (_tileSize * zoomScale);
    final x = coordinate.x * scale;
    final y = coordinate.y * scale;
    final lat = 360 / math.pi * math.atan(math.exp((180 - y) * _deg2rad)) - 90;
    return Point(coordinates: Position(x - 180, lat));
  }

  static double _clampLatitude(double latitude) =>
      latitude.clamp(-_latitudeMax, _latitudeMax).toDouble();

  static double _clampLongitude(double longitude) =>
      longitude.clamp(-_longitudeMax, _longitudeMax).toDouble();
}
