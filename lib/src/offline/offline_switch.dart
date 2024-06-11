part of mapbox_maps_flutter;

/// Instance that allows connecting or disconnecting the Mapbox stack to the network.
final class OfflineSwitch {
  final _OfflineSwitch _api = _OfflineSwitch();
  OfflineSwitch._() {}

  static final OfflineSwitch _shared = OfflineSwitch._();

  factory OfflineSwitch() {
    return _shared;
  }

  Future<bool> get isMapboxStackConnected {
    return _api.isMapboxStackConnected();
  }

  void setMapboxStackConnected(bool isConnected) {
    _api.setMapboxStackConnected(isConnected);
  }
}
