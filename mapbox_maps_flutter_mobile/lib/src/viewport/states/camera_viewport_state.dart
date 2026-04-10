part of mapbox_maps_flutter_mobile;

extension on CameraViewportState {
  _ViewportStateStorage _toStorage() => _ViewportStateStorage(
    type: _ViewportStateType.camera,
    options: CameraOptions(
      center: center != null
          ? Point(coordinates: center!.coordinates, bbox: center!.bbox)
          : null,
      padding: padding?._toMbxEdgeInsets,
      anchor: anchor?._toScreenCoordinate,
      zoom: zoom,
      bearing: bearing,
      pitch: pitch,
    ),
  );
}
