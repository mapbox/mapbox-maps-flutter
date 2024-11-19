part of mapbox_maps_flutter;

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
/// ### Updating the Viewport
///
/// You can update the viewport state at any time, with or without animations, to change how the camera
/// behaves in response to user interactions or application events. Here's how you might implement this
/// in a stateful widget:
///
/// ```dart
/// class MyWidgetState extends State<SimpleMapExample> {
///   ViewportState _viewport = CameraViewportState(center: disneyland);
///
///   @override
///   Widget build(BuildContext context) {
///     return Column(children: [
///       MapWidget(viewport: _viewport),
///       TextButton(
///         onPressed: () {
///           setState(() {
///             _viewport = CameraViewportState(
///               center: Point(coordinates: Position(48.868, 2.782)),
///               zoom: 12,
///             );
///           });
///         },
///         child: Text("Jump to Paris Disneyland"),
///       ),
///       TextButton(
///         onPressed: () {
///           setStateWithViewportAnimation(() {
///             _viewport = FollowPuckViewportState(
///               zoom: 16,
///               bearing: FollowPuckViewportStateBearingHeading(),
///               pitch: 60,
///             );
///           });
///         },
///         child: Text("Animate to User"),
///       ),
///     ]);
///   }
/// }
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
///
/// By leveraging different viewport states, you can create dynamic and responsive map experiences
/// tailored to your application's needs.
sealed class ViewportState {
  /// Creates a [ViewportState].
  ///
  /// This constructor is typically called by subclasses to initialize the base class.
  const ViewportState();
}

extension on ViewportState {
  _ViewportStateStorage _toStorage() {
    return switch (this) {
      OverviewViewportState state => state._toStorage(),
      FollowPuckViewportState state => state._toStorage(),
      StyleDefaultViewportState state => state._toStorage(),
      CameraViewportState state => state._toStorage(),
      IdleViewportState state => state._toStorage(),
    };
  }
}

extension on OverviewViewportState {
  _ViewportStateStorage _toStorage() => _ViewportStateStorage(
        type: _ViewportStateType.overview,
        options: _OverviewViewportStateOptions(
          geometry: jsonEncode(geometry),
          geometryPadding: geometryPadding._toMbxEdgeInsets,
          bearing: bearing,
          pitch: pitch,
          maxZoom: maxZoom,
          offset: offset?._toScreenCoordinate,
          animationDurationMs: animationDuration.inMilliseconds,
        ),
      );
}

extension on FollowPuckViewportState {
  _ViewportStateStorage _toStorage() {
    final internalBearing = bearing?._internalBearing;
    return _ViewportStateStorage(
      type: _ViewportStateType.followPuck,
      options: _FollowPuckViewportStateOptions(
        zoom: zoom,
        bearing: internalBearing?.$1,
        bearingValue: internalBearing?.$2,
        pitch: pitch,
      ),
    );
  }
}

extension on StyleDefaultViewportState {
  _ViewportStateStorage _toStorage() => _ViewportStateStorage(
        type: _ViewportStateType.styleDefault,
        options: null,
      );
}

extension on CameraViewportState {
  _ViewportStateStorage _toStorage() => _ViewportStateStorage(
        type: _ViewportStateType.camera,
        options: CameraOptions(
          center: center,
          padding: padding?._toMbxEdgeInsets,
          anchor: anchor?._toScreenCoordinate,
          zoom: zoom,
          bearing: bearing,
          pitch: pitch,
        ),
      );
}

extension on IdleViewportState {
  _ViewportStateStorage _toStorage() => _ViewportStateStorage(
        type: _ViewportStateType.idle,
        options: null,
      );
}

extension on EdgeInsets {
  MbxEdgeInsets get _toMbxEdgeInsets =>
      _MbxEdgeInsetsCodable.fromEdgeInsets(this);
}

extension on Offset {
  ScreenCoordinate get _toScreenCoordinate => ScreenCoordinate(x: dx, y: dy);
}
