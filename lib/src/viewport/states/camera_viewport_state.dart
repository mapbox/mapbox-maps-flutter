part of mapbox_maps_flutter;

final class CameraViewportState extends ViewportState {
  final Point? center;
  final EdgeInsets? padding;
  final Offset? anchor;
  final double? zoom;
  final double? bearing;
  final double? pitch;

  const CameraViewportState({
    this.center,
    this.padding,
    this.anchor,
    this.zoom,
    this.bearing,
    this.pitch,
  }) : super();
}
