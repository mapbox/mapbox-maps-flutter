part of mapbox_maps_flutter;

final class OverviewViewportState extends ViewportState {
    final turf.GeometryObject geometry;
    final EdgeInsets geometryPadding;
    final double? bearing;
    final double? pitch;
    final double? maxZoom;
    final Offset? offset;
    final Duration animationDuration;
  
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
