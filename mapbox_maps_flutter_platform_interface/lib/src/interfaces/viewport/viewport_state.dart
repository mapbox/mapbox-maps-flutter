import 'package:flutter/widgets.dart';
import 'package:turf/turf.dart' as turf;

import '../../pigeons/platform_interface_data_types.dart';

/// A base class representing different ways to position the camera on a map.
///
/// The [ViewportState] class defines various strategies for controlling the camera's position,
/// orientation, and behavior within a map widget. By selecting a specific viewport state,
/// you can customize how the camera responds to user interactions or focuses on particular
/// areas of interest.
///
/// ### Supported Viewport States
///
/// - **Default Style Viewport**: Sets the camera to the parameters defined in the map style's root property.
///   This is the default state when no other viewport is specified.
///
/// - **Camera Viewport**: Allows you to directly set the camera's position using parameters like
///   [center] coordinate, [zoom], [bearing], [pitch], and [anchor].
///
/// - **Overview Viewport**: Focuses the camera on a specified geometry with the minimum zoom level
///   needed to display it entirely. This is useful for directing the user's attention to a route line
///   or area of interest.
///
/// - **Follow Puck Viewport**: Automatically tracks the user's current position on the map, keeping
///   the location indicator (puck) centered or in a specified position.
///
/// - **Idle Viewport**: Activated when the user interacts with the map (e.g., pan or zoom gestures).
///   You can also set it to interrupt ongoing viewport transition animations.
///
/// ### Setting the Viewport
///
/// You can set the viewport state via the constructor parameter of the `MapWidget`:
///
/// ```dart
/// final disneyland = Point(coordinates: Position(-117.918976, 33.812092));
///
/// MapWidget(
///   viewport: CameraViewportState(center: disneyland),
/// );
/// ```
///
/// ### See Also
///
/// - [CameraViewportState]: For directly controlling the camera's position.
/// - [OverviewViewportState]: For focusing on specific geometries.
/// - [FollowPuckViewportState]: For tracking the user's location.
/// - [IdleViewportState]: For handling user interactions.
///
/// **Note:** The [ViewportState] is a sealed class; use one of its subclasses to define the desired camera behavior.
@immutable
sealed class ViewportState {
  /// Creates a [ViewportState].
  ///
  /// This constructor is typically called by subclasses to initialize the base class.
  const ViewportState();
}

/// Manually sets camera to specified properties.
final class CameraViewportState extends ViewportState {
  /// The geographic coordinate that will be rendered at the midpoint of the map.
  final turf.Point? center;

  /// Add insets to the map, adjusting the visible region by shifting the camera's viewport.
  final EdgeInsets? padding;

  /// Point in the map's coordinate system about which `zoom` and `bearing` should be applied. Mutually exclusive with `center`.
  final Offset? anchor;

  /// The zoom level of the map.
  final double? zoom;

  /// The bearing of the map, measured in degrees clockwise from true north.
  final double? bearing;

  /// Pitch toward the horizon measured in degrees, with 0 degrees resulting in a top-down view for a two-dimensional map.
  final double? pitch;

  /// Creates a [CameraViewportState] with the specified camera properties.
  const CameraViewportState({
    this.center,
    this.padding,
    this.anchor,
    this.zoom,
    this.bearing,
    this.pitch,
  }) : super();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CameraViewportState &&
          center == other.center &&
          padding == other.padding &&
          anchor == other.anchor &&
          zoom == other.zoom &&
          bearing == other.bearing &&
          pitch == other.pitch;

  @override
  int get hashCode => Object.hash(center, padding, anchor, zoom, bearing, pitch);
}

/// A viewport state that configures the camera to display an overview of a specified geometry.
///
/// The [OverviewViewportState] adjusts the camera to ensure that the given [geometry] fits within the visible area of the map.
final class OverviewViewportState extends ViewportState {
  /// The geometry to display in the overview.
  final turf.GeometryObject geometry;

  /// Extra padding to add around the [geometry].
  ///
  /// Defaults to [EdgeInsets.all(0)].
  final EdgeInsets geometryPadding;

  /// The bearing of the map in degrees clockwise from true north.
  ///
  /// Defaults to `0.0`.
  final double? bearing;

  /// The pitch of the camera toward the horizon in degrees.
  ///
  /// A pitch of `0.0` degrees results in a top-down view.
  /// Defaults to `0.0`.
  final double? pitch;

  /// The maximum zoom level allowed when fitting the [geometry] into view.
  final double? maxZoom;

  /// The offset of the center of the geometry relative to the map's center, measured in points.
  final Offset? offset;

  /// The duration of the camera transition animation.
  ///
  /// Defaults to `Duration(seconds: 1)`.
  final Duration animationDuration;

  /// Creates an [OverviewViewportState] that configures the camera to display an overview of the specified [geometry].
  const OverviewViewportState({
    required this.geometry,
    this.geometryPadding = const EdgeInsets.all(0),
    this.bearing = 0.0,
    this.pitch = 0.0,
    this.maxZoom,
    this.offset,
    this.animationDuration = const Duration(seconds: 1),
  }) : super();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OverviewViewportState &&
          identical(geometry, other.geometry) &&
          geometryPadding == other.geometryPadding &&
          bearing == other.bearing &&
          pitch == other.pitch &&
          maxZoom == other.maxZoom &&
          offset == other.offset &&
          animationDuration == other.animationDuration;

  @override
  int get hashCode => Object.hash(
    identityHashCode(geometry),
    geometryPadding,
    bearing,
    pitch,
    maxZoom,
    offset,
    animationDuration,
  );
}

/// Specifies the different ways that [FollowPuckViewportState] can obtain values to use when
/// setting the camera's bearing.
@immutable
sealed class FollowPuckViewportStateBearing {
  /// Creates a [FollowPuckViewportStateBearing].
  const FollowPuckViewportStateBearing();
}

/// Sets the camera's bearing to a constant value.
@immutable
class FollowPuckViewportStateBearingConstant
    extends FollowPuckViewportStateBearing {
  /// The constant value to set the camera's bearing, in degrees.
  final double bearing;

  /// Creates a [FollowPuckViewportStateBearingConstant] with the given [bearing] value.
  const FollowPuckViewportStateBearingConstant(this.bearing);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FollowPuckViewportStateBearingConstant &&
          bearing == other.bearing;

  @override
  int get hashCode => bearing.hashCode;
}

/// Sets the camera's bearing based on the device's current heading.
@immutable
class FollowPuckViewportStateBearingHeading
    extends FollowPuckViewportStateBearing {
  /// Creates a [FollowPuckViewportStateBearingHeading].
  const FollowPuckViewportStateBearingHeading();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FollowPuckViewportStateBearingHeading;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Sets the camera's bearing based on the device's current course (direction of movement).
///
/// **Note:** This option is only available on iOS.
@immutable
class FollowPuckViewportStateBearingCourse
    extends FollowPuckViewportStateBearing {
  /// Creates a [FollowPuckViewportStateBearingCourse].
  const FollowPuckViewportStateBearingCourse();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FollowPuckViewportStateBearingCourse;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// A [ViewportState] that configures the camera to follow the user's location indicator (puck).
///
/// The [FollowPuckViewportState] adjusts the camera to continuously track the user's current location on the map.
///
/// **Note**: Location should be enabled to use this viewport state.
///
/// **Note:** It is recommended to use only the [DefaultViewportTransition] animation option when transitioning
/// to the [FollowPuckViewportState], as it smoothly handles the moving user location puck.
final class FollowPuckViewportState extends ViewportState {
  /// The zoom level of the map.
  ///
  /// Defaults to `16.35`.
  final double? zoom;

  /// The bearing behavior of the map.
  final FollowPuckViewportStateBearing? bearing;

  /// The pitch of the camera toward the horizon, in degrees.
  ///
  /// Defaults to `45`.
  final double? pitch;

  /// The value to use for setting CameraOptions.padding. If null, padding will not be modified by the FollowPuckViewportState.
  final MbxEdgeInsets? padding;

  /// Creates a [FollowPuckViewportState] that configures the camera to follow the user's location indicator.
  const FollowPuckViewportState({
    this.zoom = 16.35,
    this.bearing = const FollowPuckViewportStateBearingHeading(),
    this.pitch = 45,
    this.padding,
  }) : super();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FollowPuckViewportState &&
          zoom == other.zoom &&
          bearing == other.bearing &&
          pitch == other.pitch &&
          padding == other.padding;

  @override
  int get hashCode => Object.hash(zoom, bearing, pitch, padding);
}

/// Sets camera to the default camera options defined in the current style.
///
/// See more in the [Mapbox Style Specification](https://docs.mapbox.com/mapbox-gl-js/style-spec/root/#center).
final class StyleDefaultViewportState extends ViewportState {
  /// Sets camera to the default camera options defined in the current style.
  const StyleDefaultViewportState() : super();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is StyleDefaultViewportState;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Idle viewport represents the state when user freely drags the map.
///
/// Setting the [IdleViewportState] viewport results in cancelling any ongoing camera animation.
final class IdleViewportState extends ViewportState {
  /// Idle viewport represents the state when user freely drags the map.
  const IdleViewportState() : super();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is IdleViewportState;

  @override
  int get hashCode => runtimeType.hashCode;
}
