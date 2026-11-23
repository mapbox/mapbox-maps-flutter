import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

/// A base class for defining custom viewport transitions.
///
/// The [ViewportTransition] class serves as an abstract foundation for various types of animations
/// that can be applied when transitioning between different viewport states in a map.
///
/// See also:
/// - [DefaultViewportTransition], which provides the default animation for viewport transitions.
/// - [EasingViewportTransition], which animates transitions using an easing curve.
/// - [FlyViewportTransition], which performs a fly-over animation.
/// - [ImmediateViewportTransition], which applies the new state instantly without animation.
@immutable
sealed class ViewportTransition {
  /// Creates a [ViewportTransition].
  const ViewportTransition();
}

/// A [ViewportTransition] that provides a default animation for viewport changes.
///
/// The [DefaultViewportTransition] offers smooth and visually appealing animations for all viewport transitions.
/// It automatically determines the best animation settings to ensure a consistent and polished user experience.
///
/// **Note:** It is recommended to use the default animation with the [FollowPuckViewportState] viewport,
/// as it supports moving animation targets like the user location puck.
final class DefaultViewportTransition extends ViewportTransition {
  /// The maximum duration of the animation.
  ///
  /// Defaults to `Duration(milliseconds: 3500)`.
  final Duration maxDuration;

  /// Creates a [DefaultViewportTransition] with an optional [maxDuration].
  const DefaultViewportTransition({
    this.maxDuration = const Duration(milliseconds: 3500),
  }) : super();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefaultViewportTransition && maxDuration == other.maxDuration;

  @override
  int get hashCode => maxDuration.hashCode;
}

/// A [ViewportTransition] that performs a fly animation over a specified duration.
///
/// The [FlyViewportTransition] animates the camera using a flight path that typically follows a zoom-out,
/// flight, and zoom-in pattern.
final class FlyViewportTransition extends ViewportTransition {
  /// The duration of the fly animation.
  ///
  /// If not provided, a default duration will be used by the system.
  final Duration? duration;

  /// Creates a [FlyViewportTransition] with an optional [duration].
  const FlyViewportTransition({this.duration}) : super();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlyViewportTransition && duration == other.duration;

  @override
  int get hashCode => duration.hashCode;
}

/// A [ViewportTransition] that animates viewport changes using an easing curve.
///
/// The [EasingViewportTransition] allows you to define smooth animations between different viewport states
/// by specifying a [curve] and a [duration].
final class EasingViewportTransition extends ViewportTransition {
  /// The easing curve to use for the animation.
  ///
  /// Defaults to [Curves.easeInOut].
  final Cubic curve;

  /// The duration of the animation.
  final Duration duration;

  /// Creates an [EasingViewportTransition] with the specified [curve] and [duration].
  const EasingViewportTransition({
    this.curve = Curves.easeInOut,
    required this.duration,
  }) : super();

  /// Creates an [EasingViewportTransition] with a linear easing curve.
  const EasingViewportTransition.linear({required Duration duration})
    : this(curve: const Cubic(0, 0, 1, 1), duration: duration);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EasingViewportTransition &&
          curve == other.curve &&
          duration == other.duration;

  @override
  int get hashCode => Object.hash(curve, duration);
}

/// A [ViewportTransition] that applies the new viewport state instantly,
/// with no animation.
final class ImmediateViewportTransition extends ViewportTransition {
  /// Creates an [ImmediateViewportTransition].
  const ImmediateViewportTransition() : super();
}
