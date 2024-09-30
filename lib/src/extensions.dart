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

  static CameraState fromJson(Map<String, dynamic> json) {
    return CameraState(
        center: Point.fromJson(json['center']),
        padding: MbxEdgeInsetsCodable.fromJson(json['padding']),
        zoom: json['zoom'].toDouble(),
        bearing: json['bearing'].toDouble(),
        pitch: json['pitch'].toDouble());
  }
}

extension MbxEdgeInsetsCodable on MbxEdgeInsets {
  static MbxEdgeInsets fromJson(Map<String, dynamic> json) {
    return MbxEdgeInsets(
      top: json["top"].toDouble(),
      left: json["left"].toDouble(),
      bottom: json["bottom"].toDouble(),
      right: json["right"].toDouble(),
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
