part of mapbox_maps_flutter;

/// A viewport state that configures the camera to display an overview of a specified geometry.
///
/// The [OverviewViewportState] adjusts the camera to ensure that the given [geometry] fits within the visible area of the map. This is particularly useful for zooming out to show an entire route, area, or any geometric shape.
///
/// You can customize the camera's orientation using [bearing] and [pitch], and control the zoom level with [maxZoom]. The [geometryPadding] adds extra space around the geometry so it doesn't touch the edges of the map. Use [offset] to shift the center of the geometry relative to the map's center. The [animationDuration] defines the length of the camera transition animation.
///
/// Example usage:
///
/// ```dart
/// final viewportState = OverviewViewportState(
///   geometry: myGeometry,
///   geometryPadding: EdgeInsets.all(20.0),
///   bearing: 30.0,
///   pitch: 45.0,
///   maxZoom: 15.0,
///   offset: Offset(0, -100),
///   animationDuration: Duration(milliseconds: 800),
/// );
/// ```
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
  ///
  /// The camera adjusts to fit the [geometry] within the map view, applying any specified [geometryPadding] around it. You can set the map's orientation using [bearing] and [pitch], and limit the zoom level with [maxZoom]. The [offset] parameter shifts the center of the geometry relative to the map's center, which can be useful for accommodating UI elements. The [animationDuration] controls how long the camera transition animation takes.
  ///
  /// All parameters are optional except for [geometry], which is required.
  const OverviewViewportState({
    required this.geometry,
    this.geometryPadding = const EdgeInsets.all(0),
    this.bearing = 0.0,
    this.pitch = 0.0,
    this.maxZoom,
    this.offset,
    this.animationDuration = const Duration(seconds: 1),
  }) : super();
}
