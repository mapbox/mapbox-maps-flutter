part of mapbox_maps_flutter;

extension Conversion on CameraState {
  CameraOptions toCameraOptions() {
    return CameraOptions(
      center: center,
      padding: padding,
      zoom: zoom,
      bearing: bearing,
      pitch: pitch,
    );
  }
}

extension ScreenBoxToJson on ScreenBox {
  dynamic toJson() {
    return <String, dynamic>{
      'min': min.toJson(),
      'max': max.toJson(),
    };
  }
}

extension ScreenCoordinateToJson on ScreenCoordinate {
  dynamic toJson() {
    return <String, dynamic>{
      'x': x,
      'y': y,
    };
  }
}
