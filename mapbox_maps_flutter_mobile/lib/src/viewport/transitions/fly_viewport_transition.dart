part of mapbox_maps_flutter;

/// A [ViewportTransition] that performs a fly animation over a specified duration.
///
/// The [FlyViewportTransition] animates the camera using a flight path that typically follows a zoom-out,
/// flight, and zoom-in pattern. This creates a dynamic and engaging transition between different viewport
/// states, giving users a sense of movement across the map.
///
/// ### Example
///
/// ```dart
/// final flyTransition = FlyViewportTransition(
///   duration: Duration(seconds: 5),
/// );
/// ```
///
/// In this example, the fly animation will occur over 5 seconds. If [duration] is not specified,
/// the transition will use a default duration determined by the system.
final class FlyViewportTransition extends ViewportTransition {
  /// The duration of the fly animation.
  ///
  /// Specifies how long the fly animation should take to complete. If not provided, a default duration
  /// will be used by the system.
  final Duration? duration;

  /// Creates a [FlyViewportTransition] with an optional [duration].
  ///
  /// - [duration]: The duration of the animation. If null, a default duration is used.
  const FlyViewportTransition({this.duration}) : super();
}
