part of mapbox_maps_flutter;

class OverviewViewportStateOptions {
  final turf.GeometryObject geometry;
  final EdgeInsets geometryPadding;
  final double? bearing;
  final double? pitch;
  final EdgeInsets? padding;
  final double? maxZoom;
  final ScreenCoordinate? offset;
  final Duration animationDuration;

  OverviewViewportStateOptions({
    required this.geometry,
    this.geometryPadding = const EdgeInsets.all(0),
    this.bearing = 0,
    this.pitch = 0,
    this.padding,
    this.maxZoom,
    this.offset,
    this.animationDuration = const Duration(seconds: 1),
  });
}

class OverviewViewportState implements ViewportState {
  final OverviewViewportStateOptions options;

  OverviewViewportState._(this.options);
  
  @override
  Cancelable observeDataSource(OnViewportCameraChange cameraChangeHandler) {
    // TODO: implement observeDataSource
    throw UnimplementedError();
  }
  
  @override
  void startUpdatingCamera() {
    // TODO: implement startUpdatingCamera
  }
  
  @override
  void stopUpdatingCamera() {
    // TODO: implement stopUpdatingCamera
  }
}
