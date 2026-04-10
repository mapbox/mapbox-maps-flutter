part of mapbox_maps_flutter_mobile;

extension on FlyViewportTransition {
  _ViewportTransitionStorage _toStorage() {
    return _ViewportTransitionStorage(
      type: _ViewportTransitionType.fly,
      options: _FlyViewportTransitionOptions(
        durationMs: duration?.inMilliseconds,
      ),
    );
  }
}
