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
        padding: _MbxEdgeInsetsCodable.fromJson(json['padding']),
        zoom: json['zoom'].toDouble(),
        bearing: json['bearing'].toDouble(),
        pitch: json['pitch'].toDouble());
  }
}

extension _MbxEdgeInsetsCodable on MbxEdgeInsets {
  static MbxEdgeInsets fromJson(Map<String, dynamic> json) {
    return MbxEdgeInsets(
      top: json["top"].toDouble(),
      left: json["left"].toDouble(),
      bottom: json["bottom"].toDouble(),
      right: json["right"].toDouble(),
    );
  }

  static MbxEdgeInsets fromEdgeInsets(EdgeInsets edgeInsets) {
    return MbxEdgeInsets(
      top: edgeInsets.top,
      left: edgeInsets.left,
      bottom: edgeInsets.bottom,
      right: edgeInsets.right,
    );
  }

  EdgeInsets toEdgeInsets() {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
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
