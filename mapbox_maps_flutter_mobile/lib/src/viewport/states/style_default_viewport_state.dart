part of mapbox_maps_flutter_mobile;

extension on StyleDefaultViewportState {
  _ViewportStateStorage _toStorage() => _ViewportStateStorage(
    type: _ViewportStateType.styleDefault,
    options: null,
  );
}
