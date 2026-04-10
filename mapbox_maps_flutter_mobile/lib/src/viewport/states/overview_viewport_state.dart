part of mapbox_maps_flutter_mobile;

extension on OverviewViewportState {
  _ViewportStateStorage _toStorage() => _ViewportStateStorage(
    type: _ViewportStateType.overview,
    options: _OverviewViewportStateOptions(
      geometry: jsonEncode(geometry),
      geometryPadding: geometryPadding._toMbxEdgeInsets,
      bearing: bearing,
      pitch: pitch,
      maxZoom: maxZoom,
      offset: offset?._toScreenCoordinate,
      animationDurationMs: animationDuration.inMilliseconds,
    ),
  );
}
