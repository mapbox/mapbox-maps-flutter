part of mapbox_maps_flutter;

/// A base class for defining custom viewport transitions.
///
/// The [ViewportTransition] class serves as an abstract foundation for various types of animations
/// that can be applied when transitioning between different viewport states in a map. Subclasses of
/// [ViewportTransition] implement specific animation behaviors, such as easing animations, fly animations,
/// or default system animations.
///
/// See also:
/// - [DefaultViewportTransition], which provides the default animation for viewport transitions.
/// - [EasingViewportTransition], which animates transitions using an easing curve.
/// - [FlyViewportTransition], which performs a fly-over animation.
sealed class ViewportTransition {
  /// Creates a [ViewportTransition].
  ///
  /// This constructor is typically called by subclasses to initialize the base class.
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
