part of mapbox_maps_flutter_mobile;

/// Instance that allows connecting or disconnecting the Mapbox stack to the network.
final class OfflineSwitch implements OfflineSwitchPlatformInterface {
  final _OfflineSwitch _api = _OfflineSwitch();
  OfflineSwitch._();

  static final OfflineSwitch shared = OfflineSwitch._();

  @override
  Future<bool> get isMapboxStackConnected {
    return _api.isMapboxStackConnected();
  }

  @override
  Future<void> setMapboxStackConnected(bool isConnected) {
    return _api.setMapboxStackConnected(isConnected);
  }
}
