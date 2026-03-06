part of mapbox_maps_flutter;

/// Instance that allows connecting or disconnecting the Mapbox stack to the network.
final class OfflineSwitch {
  final _OfflineSwitch _api = _OfflineSwitch();
  OfflineSwitch._() {}

  static final OfflineSwitch shared = OfflineSwitch._();

  Future<bool> get isMapboxStackConnected {
    return _api.isMapboxStackConnected();
  }

  Future<void> setMapboxStackConnected(bool isConnected) {
    return _api.setMapboxStackConnected(isConnected);
  }
}
