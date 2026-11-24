import 'dart:math' as math;

/// Returns the total duration of a default viewport transition.
///
/// The values are the same as the native default transition. When the target
/// zoom is above [currentZoom], the low-to-high-zoom specs apply. Otherwise,
/// the high-to-low-zoom specs apply.
///
/// [centerDistance] is the screen distance in pixels from the current center
/// to the target center, or `null` if the target has no center.
/// [targetZoom] is `null` if the target has no zoom. The other flags tell
/// which camera fields the target sets.
///
/// The total is the longest delay plus duration of all specs. If the total is
/// above [maxDuration], the function returns [maxDuration].
Duration defaultTransitionDuration({
  required double? centerDistance,
  required double currentZoom,
  required double? targetZoom,
  required bool hasBearing,
  required bool hasPitch,
  required bool hasPadding,
  required Duration maxDuration,
}) {
  final isZoomingIn = targetZoom != null && targetZoom > currentZoom;
  final seconds = isZoomingIn
      ? _lowToHighZoomSeconds(
          centerDistance: centerDistance,
          zoomDelta: targetZoom - currentZoom,
          hasBearing: hasBearing,
          hasPitchOrPadding: hasPitch || hasPadding,
        )
      : _highToLowZoomSeconds(
          hasCenter: centerDistance != null,
          hasZoom: targetZoom != null,
          hasBearing: hasBearing,
          hasPitch: hasPitch,
          hasPadding: hasPadding,
        );
  final total = Duration(microseconds: (seconds * 1000000).round());
  return total > maxDuration ? maxDuration : total;
}

double _lowToHighZoomSeconds({
  required double? centerDistance,
  required double zoomDelta,
  required bool hasBearing,
  required bool hasPitchOrPadding,
}) {
  const specMaxSeconds = 3.0;
  const centerPixelsPerSecond = 500.0;
  const zoomLevelsPerSecond = 2.2;
  const bearingSeconds = 1.8;
  const pitchAndPaddingSeconds = 1.2;

  var total = 0.0;
  var centerSeconds = 0.0;
  if (centerDistance != null) {
    centerSeconds = math.min(
      centerDistance / centerPixelsPerSecond,
      specMaxSeconds,
    );
    total = centerSeconds;
  }

  // The caller only uses this branch when the target has a zoom.
  final zoomDelay = centerSeconds / 2;
  final zoomSeconds = math.min(zoomDelta / zoomLevelsPerSecond, specMaxSeconds);
  final zoomEnd = zoomDelay + zoomSeconds;
  total = math.max(total, zoomEnd);

  if (hasBearing) {
    final delay = math.max(zoomEnd - bearingSeconds, 0.0);
    total = math.max(total, delay + bearingSeconds);
  }
  if (hasPitchOrPadding) {
    final delay = math.max(zoomEnd - pitchAndPaddingSeconds + 0.1, 0.0);
    total = math.max(total, delay + pitchAndPaddingSeconds);
  }
  return total;
}

double _highToLowZoomSeconds({
  required bool hasCenter,
  required bool hasZoom,
  required bool hasBearing,
  required bool hasPitch,
  required bool hasPadding,
}) {
  var total = 0.0;
  if (hasCenter) total = math.max(total, 0.8 + 1.0);
  if (hasZoom) total = math.max(total, 1.8);
  if (hasBearing) total = math.max(total, 0.6 + 1.2);
  if (hasPitch) total = math.max(total, 1.0);
  if (hasPadding) total = math.max(total, 1.2);
  return total;
}
