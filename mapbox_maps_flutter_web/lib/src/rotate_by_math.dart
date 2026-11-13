import 'dart:math' as math;

/// Returns the bearing change in degrees for a `rotateBy` gesture from
/// [first] to [second].
///
/// The points and [centre] are in logical pixels. [pixelRatio] converts them
/// to physical pixels, the unit of the Android SDK.
///
/// This is the Android `rotateBy` algorithm, so that web turns by the same
/// amount. The angle is measured around the map centre. When [first] is
/// closer than 200 physical pixels to the centre, the pivot moves to
/// 200 physical pixels from [first], on the line through the centre.
double rotateByBearingDelta({
  required math.Point<double> first,
  required math.Point<double> second,
  required math.Point<double> centre,
  required double pixelRatio,
}) {
  final firstPx = first * pixelRatio;
  final secondPx = second * pixelRatio;
  var pivot = centre * pixelRatio;

  final offset = firstPx - pivot;
  if (offset.magnitude < 200) {
    const pivotOffset = -200;
    final direction = math.atan2(offset.y, offset.x);
    pivot = math.Point(
      firstPx.x + math.cos(direction) * pivotOffset,
      firstPx.y + math.sin(direction) * pivotOffset,
    );
  }

  final a = firstPx - pivot;
  final b = secondPx - pivot;
  final angle = math.atan2(a.x * b.y - a.y * b.x, a.x * b.x + a.y * b.y);
  return -angle * 180 / math.pi;
}
