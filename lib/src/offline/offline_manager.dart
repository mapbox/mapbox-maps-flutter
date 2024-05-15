part of mapbox_maps_flutter;

final _OfflineMapInstanceManager _instanceManager =
    _OfflineMapInstanceManager();

final class OfflineManager {
  final int _suffix = _suffixesRegistry.getSuffix();
  late final _OfflineManager _api;

  static final Finalizer<int> _finalizer = Finalizer((suffix) {
    try {
      _instanceManager.tearDownOfflineManager(suffix.toString());
      _suffixesRegistry.releaseSuffix(suffix);
    } catch (e) {}
  });

  OfflineManager._() {
    _api = _OfflineManager(
        binaryMessenger: _instanceManager.__pigeon_binaryMessenger);
  }

  static Future<OfflineManager> create() async {
    final manager = OfflineManager._();
    _instanceManager.setupOfflineManager(manager._suffix.toString());
    _finalizer.attach(manager, manager._suffix, detach: manager);

    return manager;
  }

  Future<StylePack> loadStylePack(
      String styleURI, StylePackLoadOptions loadOptions) async {
    return _api.loadStylePack(styleURI, loadOptions);
  }
}
