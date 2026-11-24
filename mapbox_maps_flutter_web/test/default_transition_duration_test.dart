import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_web/src/viewport/default_transition_duration.dart';

void main() {
  const maxDuration = Duration(seconds: 10);

  Duration compute({
    double? centerDistance,
    double currentZoom = 10,
    double? targetZoom,
    bool hasBearing = false,
    bool hasPitch = false,
    bool hasPadding = false,
    Duration max = maxDuration,
  }) => defaultTransitionDuration(
    centerDistance: centerDistance,
    currentZoom: currentZoom,
    targetZoom: targetZoom,
    hasBearing: hasBearing,
    hasPitch: hasPitch,
    hasPadding: hasPadding,
    maxDuration: max,
  );

  test('center with a small zoom in moves at 500 px per second', () {
    expect(
      compute(centerDistance: 250, targetZoom: 10.11),
      const Duration(milliseconds: 500),
    );
  });

  test('center without zoom uses the fixed high-to-low specs', () {
    expect(compute(centerDistance: 250), const Duration(milliseconds: 1800));
  });

  test('zoom in starts after half of the center duration', () {
    expect(
      compute(centerDistance: 1000, targetZoom: 14.4),
      const Duration(milliseconds: 3000),
    );
  });

  test('zoom out uses the fixed high-to-low specs', () {
    expect(
      compute(centerDistance: 1000, targetZoom: 5, hasBearing: true),
      const Duration(milliseconds: 1800),
    );
  });

  test('total above maxDuration returns maxDuration', () {
    expect(
      compute(
        centerDistance: 1000,
        targetZoom: 14.4,
        max: const Duration(seconds: 1),
      ),
      const Duration(seconds: 1),
    );
  });

  test('no camera field gives zero', () {
    expect(compute(), Duration.zero);
  });
}
