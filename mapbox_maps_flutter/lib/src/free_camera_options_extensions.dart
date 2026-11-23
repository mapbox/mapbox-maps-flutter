import 'dart:math' as math;

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart'
    show FreeCameraOptions, FreeCameraPosition, FreeCameraOrientation;
import 'package:turf/turf.dart';

/// Mean earth radius in meters, as used by the map renderer.
const double _earthRadius = 6371008.8;

const double _earthCircumference = 2 * math.pi * _earthRadius;

/// Highest latitude that the web mercator projection shows, in degrees.
const double _maxMercatorLatitude = 85.051129;

const double _degToRad = math.pi / 180;

/// A direction in normalized mercator coordinates.
typedef _Direction = ({double x, double y, double z});

/// Helpers that set [FreeCameraOptions] from geographic values.
///
/// The helpers are pure math and give the same result on all platforms.
/// Each helper returns new options and does not change these options.
///
/// ```dart
/// final camera = const FreeCameraOptions()
///     .withLocation(Point(coordinates: Position(7.4246, 43.7384)), altitude: 300)
///     .lookingAt(Point(coordinates: Position(7.4290, 43.7350)));
/// ```
extension FreeCameraOptionsGeography on FreeCameraOptions {
  /// The geographic location of the camera, or null if
  /// [FreeCameraOptions.position] is null.
  Point? get location {
    final position = this.position;
    if (position == null) {
      return null;
    }
    return Point(
      coordinates: Position(
        _lngFromMercatorX(position.x),
        _latFromMercatorY(position.y),
      ),
    );
  }

  /// The altitude of the camera above sea level in meters, or null if
  /// [FreeCameraOptions.position] is null.
  double? get altitude {
    final position = this.position;
    if (position == null) {
      return null;
    }
    return position.z * _circumferenceAtLatitude(_latFromMercatorY(position.y));
  }

  /// Returns options with the camera at the geographic [location] and
  /// [altitude] in meters above sea level.
  ///
  /// If [altitude] is null, the camera keeps its current altitude, or uses
  /// 0 if [FreeCameraOptions.position] is null. Latitudes beyond ±85.051129 are
  /// clamped. The orientation does not change.
  FreeCameraOptions withLocation(Point location, {double? altitude}) =>
      copyWith(position: _toMercator(location, altitude ?? this.altitude ?? 0));

  /// Returns options with the camera at [altitude] meters above sea level.
  /// The location and the orientation do not change.
  ///
  /// Throws a [StateError] if [FreeCameraOptions.position] is null, because
  /// the altitude in mercator units depends on the latitude. Use
  /// [withLocation] to set both values.
  FreeCameraOptions withAltitude(double altitude) {
    final position = this.position;
    if (position == null) {
      throw StateError('Set the camera location before the altitude.');
    }
    return copyWith(
      position: position.copyWith(
        z: altitude / _circumferenceAtLatitude(_latFromMercatorY(position.y)),
      ),
    );
  }

  /// Returns options with the camera turned to a [pitch] and a [bearing] in
  /// degrees. The position does not change.
  FreeCameraOptions withPitchBearing(double pitch, double bearing) => copyWith(
    orientation: _orientationFromPitchBearing(
      pitch * _degToRad,
      -bearing * _degToRad,
    ),
  );

  /// Returns options with the camera turned to look at [target]. The
  /// position does not change.
  ///
  /// [altitude] is the altitude of the target in meters. The helper does not
  /// read terrain, so to look at the ground on terrain, pass the elevation
  /// of the target.
  ///
  /// [up] is the up direction of the camera, as a vector in mercator
  /// coordinates. Its length has no effect. Use it when the view direction
  /// alone does not give a bearing, for example when the camera looks
  /// straight down. The default points straight up. An [up] that points
  /// down is flipped to point up.
  ///
  /// The orientation of the result is null if [FreeCameraOptions.position]
  /// is null, or if no orientation with only a pitch and a bearing can look
  /// at [target].
  FreeCameraOptions lookingAt(
    Point target, {
    double altitude = 0,
    FreeCameraPosition up = const FreeCameraPosition(x: 0, y: 0, z: 1),
  }) {
    final position = this.position;
    if (position == null) {
      return const FreeCameraOptions();
    }

    final targetPosition = _toMercator(target, altitude);
    final forward = (
      x: targetPosition.x - position.x,
      y: targetPosition.y - position.y,
      z: targetPosition.z - position.z,
    );

    return FreeCameraOptions(
      position: position,
      orientation: _orientationFromFrame(forward, (
        x: up.x,
        y: up.y,
        z: up.z.abs(),
      )),
    );
  }
}

FreeCameraPosition _toMercator(Point location, double altitude) {
  final lng = location.coordinates.lng.toDouble();
  final lat = location.coordinates.lat.toDouble().clamp(
    -_maxMercatorLatitude,
    _maxMercatorLatitude,
  );
  return FreeCameraPosition(
    x: (180 + lng) / 360,
    y:
        (180 -
            math.log(math.tan(math.pi / 4 + lat * _degToRad / 2)) / _degToRad) /
        360,
    z: altitude / _circumferenceAtLatitude(lat),
  );
}

double _circumferenceAtLatitude(double latitude) =>
    _earthCircumference * math.cos(latitude * _degToRad);

double _lngFromMercatorX(double x) => x * 360 - 180;

double _latFromMercatorY(double y) {
  final y2 = 180 - y * 360;
  return 2 / _degToRad * math.atan(math.exp(y2 * _degToRad)) - 90;
}

/// Converts clockwise [pitch] and [bearing] rotations in radians to a
/// quaternion in the left-handed camera space.
FreeCameraOrientation _orientationFromPitchBearing(
  double pitch,
  double bearing,
) {
  final z = math.sin(-bearing * 0.5);
  final w = math.cos(-bearing * 0.5);
  final bx = math.sin(-pitch * 0.5);
  final bw = math.cos(-pitch * 0.5);
  return FreeCameraOrientation(x: w * bx, y: z * bx, z: z * bw, w: w * bw);
}

/// Finds the orientation that looks along [forward] with [up] as the up
/// direction. The roll is removed from [up] first.
///
/// Returns null if [forward] and [up] do not give a right direction.
FreeCameraOrientation? _orientationFromFrame(
  _Direction forward,
  _Direction up,
) {
  const epsilon = 1e-15;
  final horizontalLength = math.sqrt(
    forward.x * forward.x + forward.y * forward.y,
  );

  if (horizontalLength >= epsilon) {
    // Project the up vector on the horizontal forward direction to remove
    // the roll.
    final dirX = forward.x / horizontalLength;
    final dirY = forward.y / horizontalLength;
    final dot = up.x * dirX + up.y * dirY;
    up = (x: dirX * dot, y: dirY * dot, z: up.z);
  }

  final right = (
    x: up.y * forward.z - up.z * forward.y,
    y: up.z * forward.x - up.x * forward.z,
    z: up.x * forward.y - up.y * forward.x,
  );
  if (math.sqrt(right.x * right.x + right.y * right.y + right.z * right.z) <
      epsilon) {
    return null;
  }

  final bearing = math.atan2(-right.y, right.x);
  final pitch = math.atan2(horizontalLength, -forward.z);
  return _orientationFromPitchBearing(pitch, bearing);
}
