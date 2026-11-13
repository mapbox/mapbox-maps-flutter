import 'dart:math' show Point;

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_web/src/rotate_by_math.dart';

void main() {
  const centre = Point<double>(200, 200);

  test('turns by the screen angle around the centre for a far first point', () {
    // A quarter turn clockwise on screen lowers the bearing by 90 degrees.
    final delta = rotateByBearingDelta(
      first: const Point(450, 200),
      second: const Point(200, 450),
      centre: centre,
      pixelRatio: 1,
    );

    expect(delta, closeTo(-90, 1e-9));
  });

  test('pivots 200 px from a first point near the centre', () {
    // Pivot moves to (250, 200), so the angle is atan2(-30000, 10000).
    final delta = rotateByBearingDelta(
      first: const Point(50, 200),
      second: const Point(200, 350),
      centre: centre,
      pixelRatio: 1,
    );

    expect(delta, closeTo(71.56505, 1e-5));
  });

  test('measures the 200 px threshold in physical pixels', () {
    // 150 logical px is 300 physical px at ratio 2, so the pivot stays at the
    // centre and the turn is a quarter turn counterclockwise.
    final delta = rotateByBearingDelta(
      first: const Point(50, 200),
      second: const Point(200, 350),
      centre: centre,
      pixelRatio: 2,
    );

    expect(delta, closeTo(90, 1e-9));
  });

  test('does not rotate when both points are the same', () {
    final delta = rotateByBearingDelta(
      first: const Point(300, 250),
      second: const Point(300, 250),
      centre: centre,
      pixelRatio: 1,
    );

    expect(delta, closeTo(0, 1e-9));
  });
}
