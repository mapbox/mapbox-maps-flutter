part of mapbox_maps_flutter;

/// Specifies the different ways that [FollowPuckViewportState] can obtain values to use when
/// setting the camera's bearing.
///
/// This class serves as a base for different bearing behaviors when the camera follows the user's location indicator (puck).
sealed class FollowPuckViewportStateBearing {
  /// Creates a [FollowPuckViewportStateBearing].
  const FollowPuckViewportStateBearing();
}

/// Sets the camera's bearing to a constant value.
///
/// When used, the camera's bearing will be fixed to the specified [bearing], regardless of the device's orientation or movement.
///
/// Example:
///
/// ```dart
/// final bearingOption = FollowPuckViewportStateBearingConstant(90.0);
/// ```
class FollowPuckViewportStateBearingConstant
    extends FollowPuckViewportStateBearing {
  /// The constant value to set the camera's bearing, in degrees.
  final double bearing;

  /// Creates a [FollowPuckViewportStateBearingConstant] with the given [bearing] value.
  ///
  /// - [bearing]: The fixed bearing angle in degrees that the camera should maintain.
  const FollowPuckViewportStateBearingConstant(this.bearing);
}

/// Sets the camera's bearing based on the device's current heading.
///
/// The camera rotates to match the direction the device is facing, providing an experience where the map orients itself according to the user's physical orientation.
class FollowPuckViewportStateBearingHeading
    extends FollowPuckViewportStateBearing {
  /// Creates a [FollowPuckViewportStateBearingHeading].
  ///
  /// This option enables the camera to update its bearing automatically based on the device's heading information.
  const FollowPuckViewportStateBearingHeading();
}

/// Sets the camera's bearing based on the device's current course (direction of movement).
///
/// The camera rotates to align with the user's movement direction, which is useful in navigation scenarios where the map should reflect the path ahead.
///
/// **Note:** This option is only available on iOS.
class FollowPuckViewportStateBearingCourse
    extends FollowPuckViewportStateBearing {
  /// Creates a [FollowPuckViewportStateBearingCourse].
  ///
  /// **Note:** This option is only supported on iOS devices. On other platforms, it may have no effect.
  const FollowPuckViewportStateBearingCourse();
}

/// A [ViewportState] that configures the camera to follow the user's location indicator (puck).
///
/// The [FollowPuckViewportState] adjusts the camera to continuously track the user's current location on the map.
/// This is ideal for applications that require real-time user positioning, such as navigation or fitness apps.
///
/// You can customize the camera's behavior using the [zoom], [bearing], and [pitch] parameters:
///
/// - The [zoom] level determines how close the camera is to the map's surface. Higher values result in a closer view.
/// - The [bearing] controls the rotation of the map and can be set to follow the user's heading or a custom value using [FollowPuckViewportStateBearing].
/// - The [pitch] adjusts the angle of the camera toward the horizon, providing a 3D perspective when set above zero.
///
/// **Note**: Location should be enabled to use this viewport state.
///
/// **Note:** It is recommended to use only the [DefaultViewportTransition] animation option when transitioning to the [FollowPuckViewportState], as it smoothly handles the moving user location puck. Other animation options like [EasingViewportTransition] and [FlyViewportTransition] are not supported and may result in undesired behavior.
///
/// ### Example
///
/// ```dart
/// final viewportState = FollowPuckViewportState(
///   zoom: 16.0,
///   bearing: FollowPuckViewportStateBearingHeading(),
///   pitch: 45.0,
/// );
/// ```
final class FollowPuckViewportState extends ViewportState {
  /// The zoom level of the map.
  ///
  /// Determines how close the camera is to the map's surface. Higher values zoom in closer.
  ///
  /// Defaults to `16.35`.
  final double? zoom;

  /// The bearing behavior of the map.
  ///
  /// Defines how the map rotates in relation to the user's movement or orientation. By default, it uses [FollowPuckViewportStateBearingHeading], which rotates the map to match the device's heading.
  final FollowPuckViewportStateBearing? bearing;

  /// The pitch of the camera toward the horizon, in degrees.
  ///
  /// A value of `0` results in a top-down view. Increasing this value tilts the camera to provide a three-dimensional perspective.
  ///
  /// Defaults to `45`.
  final double? pitch;

  /// Creates a [FollowPuckViewportState] that configures the camera to follow the user's location indicator.
  ///
  /// The camera will continuously track the user's position on the map, adjusting its position and orientation based on the provided [zoom], [bearing], and [pitch] values.
  ///
  /// **Note:** It is recommended to use only the [DefaultViewportTransition] animation option when transitioning to this viewport state, as it smoothly handles the moving user location puck. Other animation options are not supported.
  ///
  /// - [zoom]: The zoom level of the map. Defaults to `16.35`.
  /// - [bearing]: The bearing behavior of the map. Defaults to [FollowPuckViewportStateBearingHeading].
  /// - [pitch]: The pitch of the camera toward the horizon, in degrees. Defaults to `45`.
  const FollowPuckViewportState({
    this.zoom = 16.35,
    this.bearing = const FollowPuckViewportStateBearingHeading(),
    this.pitch = 45,
  }) : super();
}

extension on FollowPuckViewportStateBearing {
  (_FollowPuckViewportStateBearing, double?) get _internalBearing {
    switch (this) {
      case FollowPuckViewportStateBearingConstant(bearing: var bearingConstant):
        return (_FollowPuckViewportStateBearing.constant, bearingConstant);
      case FollowPuckViewportStateBearingHeading():
        return (_FollowPuckViewportStateBearing.heading, null);
      case FollowPuckViewportStateBearingCourse():
        return (_FollowPuckViewportStateBearing.course, null);
    }
  }
}
