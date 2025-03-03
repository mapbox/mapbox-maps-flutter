part of mapbox_maps_flutter;

/// Manually sets camera to specified properties.
final class CameraViewportState extends ViewportState {
  /// The geographic coordinate that will be rendered at the midpoint of the map.
  final Point? center;

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
  ///
  /// This constructor allows you to manually set the camera's position and orientation on the map. You can specify the [center] coordinate to render at the midpoint of the map, or use an [anchor] point in the map's coordinate system about which [zoom] and [bearing] transformations are applied. Note that [center] and [anchor] are mutually exclusive; you should provide only one of them.
  ///
  /// The [zoom] parameter sets the zoom level of the map, controlling how close or far the camera is from the Earth's surface. The [bearing] parameter defines the rotation of the map, measured in degrees clockwise from true north, allowing you to orient the map to a specific direction.
  ///
  /// With the [pitch] parameter, you can adjust the angle of the camera toward the horizon, measured in degrees. A [pitch] of 0 degrees results in a top-down view, while higher values tilt the map to provide a three-dimensional perspective.
  ///
  /// You can also specify [padding] to add insets to the map, adjusting the visible region by shifting the camera's viewport.
  const CameraViewportState({
    this.center,
    this.padding,
    this.anchor,
    this.zoom,
    this.bearing,
    this.pitch,
  }) : super();
}
