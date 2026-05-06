part of mapbox_maps_flutter_mobile;

// `extension Conversion on CameraState { CameraOptions toCameraOptions() }`
// lives in `packages/mapbox_maps_flutter/lib/src/camera_state_extensions.dart`
// (facade-only — platform-interface doesn't reference it). The
// extension's previously-unused `static CameraState fromJson(...)` was
// dropped during the lift (verified no callers in any package).

extension _MbxEdgeInsetsCodable on MbxEdgeInsets {
  static MbxEdgeInsets fromEdgeInsets(EdgeInsets edgeInsets) {
    return MbxEdgeInsets(
      top: edgeInsets.top,
      left: edgeInsets.left,
      bottom: edgeInsets.bottom,
      right: edgeInsets.right,
    );
  }
}

extension ScreenBoxToJson on ScreenBox {
  dynamic toJson() {
    return <String, dynamic>{'min': min.toJson(), 'max': max.toJson()};
  }
}

extension ScreenCoordinateToJson on ScreenCoordinate {
  dynamic toJson() {
    return <String, dynamic>{'x': x, 'y': y};
  }
}
