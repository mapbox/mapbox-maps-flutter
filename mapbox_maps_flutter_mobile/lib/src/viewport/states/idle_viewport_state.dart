part of mapbox_maps_flutter_mobile;

extension on IdleViewportState {
  _ViewportStateStorage _toStorage() =>
      _ViewportStateStorage(type: _ViewportStateType.idle, options: null);
}
