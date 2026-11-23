/// A position in normalized web mercator coordinates.
///
/// One unit is the width of the projected world. `(0, 0, 0)` is the
/// north-west corner and `(1, 1, 0)` is the south-east corner of the world.
///
/// The components are not limited to the range 0 to 1. The map repeats the
/// world to the east and the west, so [x] = 1.2 is the same place as
/// [x] = 0.2, one world to the east. A camera that looks across the
/// antimeridian or toward a pole can be outside the range.
final class FreeCameraPosition {
  /// Creates a position from its mercator components.
  const FreeCameraPosition({required this.x, required this.y, required this.z});

  /// The east-west component. It increases to the east.
  final double x;

  /// The north-south component. It increases to the south.
  final double y;

  /// The altitude above sea level, in the same units as [x] and [y], so a
  /// cube stays a cube. One unit of altitude at a latitude is the
  /// circumference of the earth at that latitude.
  final double z;

  /// Returns a copy of this position with the given components replaced.
  FreeCameraPosition copyWith({double? x, double? y, double? z}) =>
      FreeCameraPosition(x: x ?? this.x, y: y ?? this.y, z: z ?? this.z);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FreeCameraPosition &&
          x == other.x &&
          y == other.y &&
          z == other.z;

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  String toString() => 'FreeCameraPosition(x: $x, y: $y, z: $z)';
}

/// A rotation in 3D space, as a unit quaternion.
///
/// A unit quaternion has a length of 1: `x² + y² + z² + w² = 1`, so each
/// component is in the range -1 to 1. A rotation by an angle `a` around a
/// unit axis `(ax, ay, az)` is
/// `(ax · sin(a/2), ay · sin(a/2), az · sin(a/2), cos(a/2))`.
/// `q` and `-q` give the same rotation.
///
/// The identity rotation is `FreeCameraOrientation(x: 0, y: 0, z: 0, w: 1)`.
final class FreeCameraOrientation {
  /// Creates a quaternion from its components.
  ///
  /// The quaternion must have a length of 1.
  const FreeCameraOrientation({
    required this.x,
    required this.y,
    required this.z,
    required this.w,
  }) : assert(
         x * x + y * y + z * z + w * w > 1 - _unitTolerance &&
             x * x + y * y + z * z + w * w < 1 + _unitTolerance,
         'A quaternion for a rotation must have a length of 1.',
       );

  /// The identity rotation.
  static const identity = FreeCameraOrientation(x: 0, y: 0, z: 0, w: 1);

  /// Largest difference from 1 of the squared length.
  static const double _unitTolerance = 1e-6;

  /// The x component of the vector part, `ax · sin(a/2)`.
  final double x;

  /// The y component of the vector part, `ay · sin(a/2)`.
  final double y;

  /// The z component of the vector part, `az · sin(a/2)`.
  final double z;

  /// The scalar part, `cos(a/2)`.
  final double w;

  /// Returns a copy of this quaternion with the given components replaced.
  ///
  /// The result must have a length of 1.
  FreeCameraOrientation copyWith({
    double? x,
    double? y,
    double? z,
    double? w,
  }) => FreeCameraOrientation(
    x: x ?? this.x,
    y: y ?? this.y,
    z: z ?? this.z,
    w: w ?? this.w,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FreeCameraOrientation &&
          x == other.x &&
          y == other.y &&
          z == other.z &&
          w == other.w;

  @override
  int get hashCode => Object.hash(x, y, z, w);

  @override
  String toString() => 'FreeCameraOrientation(x: $x, y: $y, z: $z, w: $w)';
}

/// The position and orientation of the camera in 3D space.
///
/// Use these options to control the camera directly, for example to follow
/// a moving object. The `mapbox_maps_flutter` package adds helpers that
/// set the options from a geographic location, an altitude in meters, and a
/// target to look at.
final class FreeCameraOptions {
  /// Creates free camera options. Both values are optional. The map keeps
  /// its current value for each value that is null.
  const FreeCameraOptions({this.position, this.orientation});

  /// The position of the camera in normalized mercator coordinates.
  final FreeCameraPosition? position;

  /// The orientation of the camera in a left-handed coordinate space.
  ///
  /// Rotations are clockwise around their axes. With the identity rotation,
  /// the camera looks down the -Z axis and north is up.
  /// The map uses only the pitch and the bearing of the orientation, and
  /// ignores a roll.
  final FreeCameraOrientation? orientation;

  /// Returns a copy of these options with the given values replaced.
  ///
  /// To remove a value, create new options with the constructor.
  FreeCameraOptions copyWith({
    FreeCameraPosition? position,
    FreeCameraOrientation? orientation,
  }) => FreeCameraOptions(
    position: position ?? this.position,
    orientation: orientation ?? this.orientation,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FreeCameraOptions &&
          position == other.position &&
          orientation == other.orientation;

  @override
  int get hashCode => Object.hash(position, orientation);

  @override
  String toString() =>
      'FreeCameraOptions(position: $position, orientation: $orientation)';
}
