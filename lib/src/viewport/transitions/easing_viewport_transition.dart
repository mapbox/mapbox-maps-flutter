part of mapbox_maps_flutter;

/// A [ViewportTransition] that animates viewport changes using an easing curve.
///
/// The [EasingViewportTransition] allows you to define smooth animations between different viewport states
/// by specifying a [curve] and a [duration]. This provides a customizable way to control how camera
/// transitions occur in your application.
///
/// ### Example
///
/// ```dart
/// // Using the default easing curve (easeInOut)
/// final transition = EasingViewportTransition(
///   duration: Duration(seconds: 2),
/// );
///
/// // Using a custom easing curve
/// final transition = EasingViewportTransition(
///   curve: Curves.fastOutSlowIn,
///   duration: Duration(milliseconds: 1500),
/// );
///
/// // Using a linear easing curve
/// final transition = EasingViewportTransition.linear(
///   duration: Duration(seconds: 1),
/// );
/// ```
///
/// In these examples, different easing curves and durations are used to animate the viewport transitions.
final class EasingViewportTransition extends ViewportTransition {
  /// The easing curve to use for the animation.
  ///
  /// This defines the rate of change of the animation over time. You can use any [Cubic] curve,
  /// including predefined curves from [Curves] like [Curves.easeInOut], [Curves.linear], etc.
  ///
  /// Defaults to [Curves.easeInOut].
  final Cubic curve;

  /// The duration of the animation.
  ///
  /// Specifies how long the animation should take to complete.
  final Duration duration;

  /// Creates an [EasingViewportTransition] with the specified [curve] and [duration].
  ///
  /// The [curve] parameter defines the easing function to use for the animation, and the [duration]
  /// specifies the length of time the animation should run.
  ///
  /// - [curve]: The easing curve to use for the animation. Defaults to [Curves.easeInOut].
  /// - [duration]: The duration of the animation.
  const EasingViewportTransition({
    this.curve = Curves.easeInOut,
    required this.duration,
  }) : super();

  /// Creates an [EasingViewportTransition] with a linear easing curve.
  ///
  /// This constructor sets the [curve] to a linear curve (`Cubic(0, 0, 1, 1)`), resulting in a constant animation speed.
  ///
  /// - [duration]: The duration of the animation.
  const EasingViewportTransition.linear({
    required Duration duration,
  }) : this(curve: const Cubic(0, 0, 1, 1), duration: duration);
}
