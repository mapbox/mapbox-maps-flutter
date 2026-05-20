part of mapbox_maps_flutter_mobile;

extension on ViewportTransition {
  _ViewportTransitionStorage? _toStorage() {
    return switch (this) {
      DefaultViewportTransition transition => transition._toStorage(),
      FlyViewportTransition transition => transition._toStorage(),
      EasingViewportTransition transition => transition._toStorage(),
      ImmediateViewportTransition() => null,
    };
  }
}
