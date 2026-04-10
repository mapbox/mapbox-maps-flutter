part of mapbox_maps_flutter_mobile;

extension on EasingViewportTransition {
  _ViewportTransitionStorage _toStorage() {
    return _ViewportTransitionStorage(
      type: _ViewportTransitionType.easing,
      options: _EasingViewportTransitionOptions(
        durationMs: duration.inMilliseconds,
        a: curve.a,
        b: curve.b,
        c: curve.c,
        d: curve.d,
      ),
    );
  }
}
