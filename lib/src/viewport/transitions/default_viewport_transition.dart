part of mapbox_maps_flutter;

/// A [ViewportTransition] that provides a default animation for viewport changes.
///
/// The [DefaultViewportTransition] offers smooth and visually appealing animations for all viewport transitions.
/// It automatically determines the best animation settings to ensure a consistent and polished user experience.
///
/// **Note:** It is recommended to use the default animation with the [FollowPuckViewportState] viewport,
/// as it supports moving animation targets like the user location puck. Other animation options may not
/// handle moving targets as smoothly.
///
/// ### Example
///
/// ```dart
/// final viewportTransition = DefaultViewportTransition(
///   maxDuration: Duration(milliseconds: 3500),
/// );
/// ```
///
/// This creates a default viewport transition with a maximum animation duration of 3.5 seconds.
final class DefaultViewportTransition extends ViewportTransition {
  /// The maximum duration of the animation.
  ///
  /// The animation will not exceed this duration, regardless of the changes in the viewport.
  /// Defaults to `Duration(milliseconds: 3500)`.
  final Duration maxDuration;

  /// Creates a [DefaultViewportTransition] with an optional [maxDuration].
  ///
  /// The [maxDuration] parameter allows you to specify the maximum duration for the animation.
  /// By default, it is set to 3.5 seconds.
  const DefaultViewportTransition({
    this.maxDuration = const Duration(milliseconds: 3500),
  }) : super();
}
