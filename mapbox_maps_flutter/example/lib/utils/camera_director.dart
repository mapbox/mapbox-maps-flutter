import 'dart:math' as math;

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'track_path.dart';

/// A camera placement that the director cuts between.
enum CameraShot {
  /// Behind and above the car.
  chase,

  /// High above and behind the car, looking down the road ahead.
  overhead,

  /// On the car roof, looking down the road over the hood.
  hood,

  /// Far behind and to the side, showing the road ahead.
  wide,

  /// Low, next to the car, looking across at it.
  side,

  /// A fixed camera that turns to follow the car.
  trackside,
}

/// A stretch of the track that starts [start] meters after the start line
/// and uses [shot] until the next zone starts.
///
/// The optional values replace the values of the shot.
final class ShotZone {
  const ShotZone({
    required this.start,
    required this.shot,
    this.back,
    this.right,
    this.up,
    this.aim,
    this.camera,
    this.passRight,
    this.blendSeconds,
    this.arc,
    this.followsHeading,
  }) : assert(
         shot != CameraShot.trackside || (camera != null && up != null),
         'A trackside shot needs a camera location and height.',
       );

  final double start;
  final CameraShot shot;

  /// Distance of the camera behind the car in meters.
  final double? back;

  /// Distance of the camera to the right of the car in meters. Negative is
  /// to the left.
  final double? right;

  /// Height of the camera above the ground in meters.
  final double? up;

  /// Where the camera aims, from the car (0) to the point ahead (1).
  final double? aim;

  /// For [CameraShot.trackside]: the fixed camera location.
  final Position? camera;

  /// Which side of the car the camera passes during the cut into this
  /// zone: `true` is the right, `false` the left. Null takes the shorter
  /// way.
  final bool? passRight;

  /// Length of the cut into this zone in seconds, instead of a length from
  /// the camera move.
  final double? blendSeconds;

  /// Extra height in meters that the camera rises to in the middle of the
  /// cut into this zone, like a crane, to pass over buildings and trees.
  final double? arc;

  /// Whether the camera turns with the car instead of with the road ahead.
  /// A camera that turns with the car does not turn into a corner early.
  final bool? followsHeading;
}

/// Where a shot puts the camera, in meters relative to the car and the
/// direction the camera faces.
final class _Rig {
  const _Rig({
    required this.back,
    required this.up,
    this.right = 0,
    this.lead = 0,
    this.leadWeight = 0,
    this.targetUp = 1,
    this.cornerWeight = 1,
    this.followsHeading = false,
  });

  /// Distance behind the car. Negative is in front of the car center.
  final double back;

  /// Height above the ground.
  final double up;

  /// Distance to the right of the car.
  final double right;

  /// How far ahead along the track the camera looks, before the corner
  /// look-ahead is added.
  final double lead;

  /// Where the camera aims, from the car (0) to the point ahead (1).
  final double leadWeight;

  /// Height of the aim point above the ground.
  final double targetUp;

  /// How much of the corner look-ahead the shot uses. A camera high above
  /// the car uses less, so the car stays in the frame.
  final double cornerWeight;

  /// Whether the camera turns with the car, like a camera fixed to it,
  /// instead of with the road ahead.
  final bool followsHeading;
}

const _rigs = {
  CameraShot.chase: _Rig(
    back: 34,
    up: 13,
    lead: 20,
    leadWeight: 0.45,
    cornerWeight: 0.6,
  ),
  CameraShot.overhead: _Rig(
    back: 30,
    up: 48,
    lead: 14,
    leadWeight: 0.35,
    cornerWeight: 0.3,
  ),
  // Behind the car and just above the roof, like a camera fixed to it.
  CameraShot.hood: _Rig(
    back: 5.5,
    up: 2.8,
    lead: 9,
    leadWeight: 1,
    targetUp: 0,
    cornerWeight: 0.3,
    followsHeading: true,
  ),
  CameraShot.wide: _Rig(
    back: 110,
    up: 60,
    right: 35,
    lead: 40,
    leadWeight: 0.5,
  ),
  CameraShot.side: _Rig(
    back: 3,
    up: 3,
    right: -16,
    lead: 8,
    leadWeight: 0.1,
    cornerWeight: 0.2,
  ),
};

/// Extra look-ahead in meters per radian per meter of upcoming curvature.
const double _cornerLookAhead = 600;

/// Most look-ahead that a corner adds, in meters.
const double _maxCornerLookAhead = 35;

/// Shortest time in seconds that a cut between two shots takes.
const double _minBlendSeconds = 1.1;

/// Longest time in seconds that a cut between two shots takes.
const double _maxBlendSeconds = 2.7;

/// Speed of the camera during a long cut, in meters per second.
const double _blendSpeed = 67;

/// Turn rate of the camera during a cut with a large turn, in degrees per
/// second.
const double _blendTurnRate = 135;

/// Time in seconds that the camera placement takes to follow a change of
/// direction. It keeps the camera calm through a series of corners.
const double _facingSmoothing = 0.33;

/// Distance from the car of the camera where a cut starts to aim at the
/// car, in meters. Closer cameras keep their own aim, so they do not tilt
/// down at the car.
const double _focusStart = 10;

/// Distance from the car of the camera where a cut aims fully at the car
/// at the middle of the blend, in meters.
const double _focusFull = 30;

/// Extra downward pitch in degrees per meter per second of dive. The camera
/// leans into a dive, like a camera on a crane that swings down. A climb
/// does not tilt the camera up, because that would lose the car below.
const double _tiltPerDiveSpeed = 0.06;

/// Most extra pitch from a dive, in degrees.
const double _maxTilt = 4;

/// Time in seconds that the climb speed takes to follow a change.
const double _climbSmoothing = 0.2;

/// Decides the camera pose for each frame: it picks the shot for the part
/// of the track, looks into upcoming corners, and blends between shots.
final class CameraDirector {
  CameraDirector({required this.track, required this.zones});

  final TrackPath track;

  /// The shots by distance from the start line, sorted by start.
  final List<ShotZone> zones;

  ShotZone? _zone;
  ShotZone? _previousZone;

  /// The camera at the start of a cut that began during another cut,
  /// relative to the car.
  _CarRelativePose? _previousPose;

  /// The camera of the last frame, relative to the car.
  _CarRelativePose? _lastPose;
  var _blend = 1.0;
  var _blendSeconds = _minBlendSeconds;

  /// How far the camera goes around the car during the current cut, in
  /// degrees. Each frame picks the turn closest to the last one, so the
  /// camera does not switch sides halfway.
  var _orbit = 0.0;

  /// The smoothed direction that the camera placements face, in degrees
  /// clockwise from north.
  double? _facing;

  /// The smoothed corner look-ahead in meters.
  double? _cornerLead;

  /// The smoothed vertical speed of the camera above the ground, in meters
  /// per second.
  var _climbSpeed = 0.0;

  /// The camera pose with the car at [distance] along the track, [dt]
  /// seconds after the previous frame.
  ///
  /// [groundElevation] is the terrain height under the car in meters.
  FreeCameraOptions update(
    double distance,
    double dt, {
    double groundElevation = 0,
  }) {
    final car = track.sample(distance);
    _updateFacing(distance, dt);
    final zone = _zoneAt(distance);
    final current = _zone;
    if (current == null) {
      _zone = zone;
    } else if (!identical(zone, current)) {
      _startCut(zone, current, car, distance, groundElevation);
    }
    _blend = math.min(1, _blend + dt / _blendSeconds);

    var pose = _pose(_zone!, car, distance, groundElevation);
    final previousZone = _previousZone;
    if (_blend < 1 && previousZone != null) {
      pose = _blendedPose(pose, previousZone, car, distance, groundElevation);
    }

    final lastAltitude = _lastPose?.up;
    _lastPose = _CarRelativePose.of(pose, car, groundElevation);
    if (lastAltitude != null && dt > 0) {
      final climb = (_lastPose!.up - lastAltitude) / dt;
      _climbSpeed +=
          (climb - _climbSpeed) * (1 - math.exp(-dt / _climbSmoothing));
    }
    return _tilted(pose).camera;
  }

  void _startCut(
    ShotZone zone,
    ShotZone current,
    TrackSample car,
    double distance,
    double ground,
  ) {
    // A cut that starts during another cut starts from where the camera is,
    // not from where the last shot would put it.
    _previousPose = _blend < 1 ? _lastPose : null;
    _previousZone = current;
    _zone = zone;
    _blend = 0;
    final from =
        _previousPose?.at(car, ground) ?? _pose(current, car, distance, ground);
    final to = _pose(zone, car, distance, ground);
    // A long move or a large turn gets more time, so it does not look like a
    // jump.
    _blendSeconds =
        zone.blendSeconds ??
        math
            .max(
              from.distanceTo(to) / _blendSpeed,
              from.turnTo(to) / _blendTurnRate,
            )
            .clamp(_minBlendSeconds, _maxBlendSeconds)
            .toDouble();
    _orbit = _orbitFor(zone, from, to, car);
  }

  _Pose _blendedPose(
    _Pose pose,
    ShotZone previousZone,
    TrackSample car,
    double distance,
    double ground,
  ) {
    final previous =
        _previousPose?.at(car, ground) ??
        _pose(previousZone, car, distance, ground);
    final t = smoothstep(_blend);
    final turn = previous.orbitTo(car.position, pose);
    _orbit = [
      turn - 360,
      turn,
      turn + 360,
    ].reduce((a, b) => (a - _orbit).abs() <= (b - _orbit).abs() ? a : b);
    var blended = previous.lerpAround(car.position, pose, t, _orbit);
    final arc = _zone!.arc;
    if (arc != null) blended = blended.raisedBy(arc * math.sin(math.pi * t));
    // Pull the aim toward the car in the middle of the cut, where the two
    // shots agree the least. Close cameras keep their own aim.
    final near =
        ((blended.distanceToPoint(car.position) - _focusStart) /
                (_focusFull - _focusStart))
            .clamp(0.0, 1.0);
    return blended.aimedAt(
      car.position,
      ground + 1,
      smoothstep(near) * math.sin(math.pi * t),
    );
  }

  /// The pose with its aim moved down while the camera dives.
  _Pose _tilted(_Pose pose) {
    final tilt = (_climbSpeed * _tiltPerDiveSpeed).clamp(-_maxTilt, 0.0);
    final reach = polarBetween(pose.location, pose.target).distance;
    return pose.copyWith(
      targetAltitude:
          pose.targetAltitude + reach * math.tan(tilt * math.pi / 180),
    );
  }

  ShotZone _zoneAt(double distance) {
    final d = distance % track.length;
    // Before the first zone, the last zone of the lap continues.
    var current = zones.last;
    for (final zone in zones) {
      if (zone.start > d) break;
      current = zone;
    }
    return current;
  }

  _Pose _pose(ShotZone zone, TrackSample car, double distance, double ground) {
    if (zone.shot == CameraShot.trackside) {
      return _Pose(
        location: zone.camera!,
        altitude: ground + zone.up!,
        target: car.position,
        targetAltitude: ground + 1,
      );
    }

    final rig = _rigs[zone.shot]!;
    final lead =
        rig.lead + rig.cornerWeight * (_cornerLead ?? _cornerAhead(distance));
    final ahead = track.sample(distance + lead).position;
    final facing = zone.followsHeading ?? rig.followsHeading
        ? car.heading
        : _facing ?? bearingBetween(car.position, ahead);

    final behind = offsetPosition(
      car.position,
      facing + 180,
      zone.back ?? rig.back,
    );
    return _Pose(
      location: offsetPosition(behind, facing + 90, zone.right ?? rig.right),
      altitude: ground + (zone.up ?? rig.up),
      target: lerpPosition(car.position, ahead, zone.aim ?? rig.leadWeight),
      targetAltitude: ground + rig.targetUp,
    );
  }

  /// Moves the smoothed facing toward the direction of the road ahead.
  void _updateFacing(double distance, double dt) {
    final k = 1 - math.exp(-dt / _facingSmoothing);
    final corner = _cornerAhead(distance);
    final cornerLead =
        (_cornerLead ?? corner) + (corner - (_cornerLead ?? corner)) * k;
    _cornerLead = cornerLead;

    final car = track.sample(distance).position;
    final raw = bearingBetween(
      car,
      track.sample(distance + 25 + cornerLead).position,
    );
    final facing = _facing;
    _facing = facing == null
        ? raw
        : (facing + angleBetween(facing, raw) * k) % 360;
  }

  /// The turn in degrees around the car for a cut from [from] to [to],
  /// positive clockwise.
  double _orbitFor(ShotZone zone, _Pose from, _Pose to, TrackSample car) {
    final shorter = from.orbitTo(car.position, to);
    final passRight = zone.passRight;
    if (passRight == null) return shorter;
    final longer = shorter > 0 ? shorter - 360 : shorter + 360;
    // The middle of the turn should be on the asked side of the car.
    final side = car.heading + (passRight ? 90 : -90);
    double miss(double turn) => angleBetween(
      polarBetween(car.position, from.location).bearing + turn / 2,
      side,
    ).abs();
    return miss(shorter) <= miss(longer) ? shorter : longer;
  }

  /// Look-ahead in meters for the corners in the next stretch of track.
  double _cornerAhead(double distance) {
    var curvature = 0.0;
    for (var d = 0.0; d <= 60; d += 10) {
      curvature = math.max(curvature, track.curvatureAt(distance + d));
    }
    return math.min(_maxCornerLookAhead, curvature * _cornerLookAhead);
  }
}

/// A camera pose stored relative to the car, so it moves with the car.
final class _CarRelativePose {
  const _CarRelativePose({
    required this.angle,
    required this.radius,
    required this.up,
    required this.targetAngle,
    required this.targetRadius,
    required this.targetUp,
  });

  factory _CarRelativePose.of(_Pose pose, TrackSample car, double ground) {
    final camera = polarBetween(car.position, pose.location);
    final target = polarBetween(car.position, pose.target);
    return _CarRelativePose(
      angle: camera.bearing - car.heading,
      radius: camera.distance,
      up: pose.altitude - ground,
      targetAngle: target.bearing - car.heading,
      targetRadius: target.distance,
      targetUp: pose.targetAltitude - ground,
    );
  }

  final double angle;
  final double radius;
  final double up;
  final double targetAngle;
  final double targetRadius;
  final double targetUp;

  /// The pose for [car] on terrain [ground] meters high.
  _Pose at(TrackSample car, double ground) => _Pose(
    location: offsetPosition(car.position, car.heading + angle, radius),
    altitude: ground + up,
    target: offsetPosition(
      car.position,
      car.heading + targetAngle,
      targetRadius,
    ),
    targetAltitude: ground + targetUp,
  );
}

/// Where the camera is and the point that it aims at.
final class _Pose {
  const _Pose({
    required this.location,
    required this.altitude,
    required this.target,
    required this.targetAltitude,
  });

  final Position location;
  final double altitude;
  final Position target;
  final double targetAltitude;

  FreeCameraOptions get camera => const FreeCameraOptions()
      .withLocation(Point(coordinates: location), altitude: altitude)
      .lookingAt(Point(coordinates: target), altitude: targetAltitude);

  _Pose copyWith({
    Position? location,
    double? altitude,
    Position? target,
    double? targetAltitude,
  }) => _Pose(
    location: location ?? this.location,
    altitude: altitude ?? this.altitude,
    target: target ?? this.target,
    targetAltitude: targetAltitude ?? this.targetAltitude,
  );

  /// The straight-line distance between the two camera locations, in
  /// meters.
  double distanceTo(_Pose other) {
    final ground = polarBetween(location, other.location).distance;
    final dz = other.altitude - altitude;
    return math.sqrt(ground * ground + dz * dz);
  }

  /// The horizontal distance from the camera to [point], in meters.
  double distanceToPoint(Position point) =>
      polarBetween(point, location).distance;

  /// The shorter turn in degrees around [center] from this camera location
  /// to the location of [other]. Positive is clockwise.
  double orbitTo(Position center, _Pose other) => angleBetween(
    polarBetween(center, location).bearing,
    polarBetween(center, other.location).bearing,
  );

  /// The angle in degrees that the camera turns from this pose to [other].
  double turnTo(_Pose other) {
    final a = camera.orientation!;
    final b = other.camera.orientation!;
    final dot = (a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w).abs();
    return 2 * math.acos(math.min(1.0, dot)) * 180 / math.pi;
  }

  /// The pose a fraction [t] of the way from this pose to [other].
  ///
  /// The camera moves around [center] by angle, distance and height, not on
  /// a straight line, so it never flies over [center] during a cut.
  /// [turn] is the full turn around [center] in degrees, positive
  /// clockwise.
  _Pose lerpAround(Position center, _Pose other, double t, double turn) {
    final from = polarBetween(center, location);
    final toRadius = polarBetween(center, other.location).distance;
    return _Pose(
      location: offsetPosition(
        center,
        from.bearing + turn * t,
        from.distance + (toRadius - from.distance) * t,
      ),
      altitude: altitude + (other.altitude - altitude) * t,
      target: lerpPosition(target, other.target, t),
      targetAltitude:
          targetAltitude + (other.targetAltitude - targetAltitude) * t,
    );
  }

  /// The same pose with the camera [meters] higher.
  _Pose raisedBy(double meters) => copyWith(altitude: altitude + meters);

  /// The same camera, with its aim moved a fraction [t] of the way to
  /// [point] at [pointAltitude].
  _Pose aimedAt(Position point, double pointAltitude, double t) => copyWith(
    target: lerpPosition(target, point, t),
    targetAltitude: targetAltitude + (pointAltitude - targetAltitude) * t,
  );
}
