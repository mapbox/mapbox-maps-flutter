import 'dart:math' as math;

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// Meters per degree of latitude on a sphere with the mean earth radius.
const double metersPerDegree = 2 * math.pi * 6371008.8 / 360;

/// A point on a track and the direction of travel there.
final class TrackSample {
  const TrackSample({required this.position, required this.heading});

  /// The geographic position.
  final Position position;

  /// The direction of travel, in degrees clockwise from north.
  final double heading;
}

/// A closed track that can be sampled by the distance driven along it.
final class TrackPath {
  /// Creates a track from its points. The last point must equal the first.
  TrackPath(List<Position> points)
    : _lng = [for (final p in points) p.lng.toDouble()],
      _lat = [for (final p in points) p.lat.toDouble()],
      _start = List.filled(points.length, 0) {
    for (var i = 1; i < points.length; i++) {
      _start[i] = _start[i - 1] + _segmentLength(i - 1);
    }
  }

  final List<double> _lng;
  final List<double> _lat;

  /// Distance along the track at the start of each point, in meters.
  final List<double> _start;

  /// Length of one lap in meters.
  double get length => _start.last;

  /// Window, in meters, over which [sample] and [curvatureAt] measure the
  /// direction of travel. It smooths the corners between track points.
  static const double _window = 5;

  /// The point at [distance] meters along the track. Distances outside one
  /// lap wrap around.
  TrackSample sample(double distance) => TrackSample(
    position: _positionAt(distance),
    heading: bearingBetween(
      _positionAt(distance - _window),
      _positionAt(distance + _window),
    ),
  );

  /// How sharply the track turns at [distance], in radians per meter.
  double curvatureAt(double distance) {
    final behind = _positionAt(distance - 2 * _window);
    final here = _positionAt(distance);
    final ahead = _positionAt(distance + 2 * _window);
    final turn = angleBetween(
      bearingBetween(behind, here),
      bearingBetween(here, ahead),
    );
    return turn.abs() * math.pi / 180 / (2 * _window);
  }

  /// The speed in meters per second that a car can drive at [distance].
  ///
  /// The car slows down before a corner, so the speed is the lowest corner
  /// speed over the next [lookAhead] meters. [maxLateralAcceleration] in
  /// meters per second squared sets how fast the car takes a corner.
  double cornerSpeedAt(
    double distance, {
    required double minSpeed,
    required double maxSpeed,
    required double maxLateralAcceleration,
    double lookAhead = 60,
  }) {
    var speed = maxSpeed;
    for (var d = 0.0; d <= lookAhead; d += 5) {
      final curvature = curvatureAt(distance + d);
      if (curvature > 0) {
        speed = math.min(speed, math.sqrt(maxLateralAcceleration / curvature));
      }
    }
    return speed.clamp(minSpeed, maxSpeed).toDouble();
  }

  Position _positionAt(double distance) {
    final d = distance % length;
    var low = 0;
    var high = _start.length - 1;
    while (high - low > 1) {
      final mid = (low + high) >> 1;
      if (_start[mid] <= d) {
        low = mid;
      } else {
        high = mid;
      }
    }
    final segment = _start[high] - _start[low];
    final t = segment == 0 ? 0.0 : (d - _start[low]) / segment;
    return Position(
      _lng[low] + (_lng[high] - _lng[low]) * t,
      _lat[low] + (_lat[high] - _lat[low]) * t,
    );
  }

  double _segmentLength(int i) => polarBetween(
    Position(_lng[i], _lat[i]),
    Position(_lng[i + 1], _lat[i + 1]),
  ).distance;
}

/// The position [meters] away from [position] in the direction [heading],
/// in degrees clockwise from north.
Position offsetPosition(Position position, double heading, double meters) {
  final radians = heading * math.pi / 180;
  final lat = position.lat.toDouble();
  final cosLat = math.cos(lat * math.pi / 180);
  return Position(
    position.lng + meters * math.sin(radians) / (metersPerDegree * cosLat),
    lat + meters * math.cos(radians) / metersPerDegree,
  );
}

/// The direction in degrees clockwise from north, and the distance in
/// meters, from [from] to [to]. It is exact enough for distances of a few
/// kilometers.
({double bearing, double distance}) polarBetween(Position from, Position to) {
  final cosLat = math.cos(
    (from.lat.toDouble() + to.lat.toDouble()) / 2 * math.pi / 180,
  );
  final dx = (to.lng - from.lng) * metersPerDegree * cosLat;
  final dy = (to.lat - from.lat) * metersPerDegree;
  return (
    bearing: (math.atan2(dx, dy) * 180 / math.pi) % 360,
    distance: math.sqrt(dx * dx + dy * dy),
  );
}

/// The direction from [from] to [to], in degrees clockwise from north.
double bearingBetween(Position from, Position to) =>
    polarBetween(from, to).bearing;

/// The signed turn from heading [a] to heading [b], in degrees, in -180..180.
double angleBetween(double a, double b) => (b - a + 540) % 360 - 180;

/// The position a fraction [t] of the way from [a] to [b].
Position lerpPosition(Position a, Position b, double t) =>
    Position(a.lng + (b.lng - a.lng) * t, a.lat + (b.lat - a.lat) * t);

/// Eases [t] from 0 to 1 so that it starts and stops gently.
double smoothstep(double t) => t * t * (3 - 2 * t);
