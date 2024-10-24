part of mapbox_maps_flutter;

sealed class ViewportTransition {
  const ViewportTransition();
}

extension on ViewportTransition {
  _ViewportTransitionStorage _toStorage() {
    return switch (this) {
      DefaultViewportTransition transition => transition._toStorage(),
      FlyViewportTransition transition => transition._toStorage(),
      EasingViewportTransition transition => transition._toStorage(),
    };
  }
}

extension on DefaultViewportTransition {
  _ViewportTransitionStorage _toStorage() => _ViewportTransitionStorage(
        type: _ViewportTransitionType.defaultTransition,
        options: _DefaultViewportTransitionOptions(
          maxDurationMs: maxDuration.inMilliseconds,
        ),
      );
}

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
