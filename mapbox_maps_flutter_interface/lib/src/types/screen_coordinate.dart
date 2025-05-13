import 'package:flutter/foundation.dart';

/// Describes the coordinate on the screen, measured from top to bottom and from left to right.
///
/// Note: The `map` uses screen coordinate units measured in `logical pixels`.
@immutable
class ScreenCoordinate {
  final double x;
  final double y;

  /// Creates a [ScreenCoordinate] instance.
  const ScreenCoordinate({
    required this.x,
    required this.y,
  });

  @override
  String toString() => 'ScreenCoordinate(x: $x, y: $y)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenCoordinate &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
