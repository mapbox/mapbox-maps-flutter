part of mapbox_maps_flutter_mobile;

extension on DefaultViewportTransition {
  _ViewportTransitionStorage _toStorage() => _ViewportTransitionStorage(
    type: _ViewportTransitionType.defaultTransition,
    options: _DefaultViewportTransitionOptions(
      maxDurationMs: maxDuration.inMilliseconds,
    ),
  );
}
