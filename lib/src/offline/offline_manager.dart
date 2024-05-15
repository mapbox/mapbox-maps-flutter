part of mapbox_maps_flutter;

final _OfflineMapInstanceManager _instanceManager =
    _OfflineMapInstanceManager();

/// The [OfflineManager] provides a configuration interface and entrypoint for offline map functionality.
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

  /// Creates a new instance of [OfflineManager].
  static Future<OfflineManager> create() async {
    final manager = OfflineManager._();
    _instanceManager.setupOfflineManager(manager._suffix.toString());
    _finalizer.attach(manager, manager._suffix, detach: manager);

    return manager;
  }

  /// Loads a new style package or updates the existing one.
  ///
  /// @param styleURI: The URI of the style package's associated style
  /// @param loadOptions: The style package load options.
  ///
  /// If a style package with the given id already exists, it is updated with
  /// the values provided to the given load options. The missing resources get
  /// loaded and the expired resources get updated.
  ///
  /// If there no values provided to the given [loadOptions], the existing
  /// style package gets refreshed: the missing resources get loaded and the
  /// expired resources get updated.
  ///
  /// A failed load request can be reattempted with another [loadStylePack] call.
  ///
  /// If the style cannot be fetched for any reason, the load request is terminated.
  /// If the style is fetched but loading some of the style package resources
  /// fails, the load request proceeds trying to load the remaining style package
  /// resources.
  ///
  /// By default, users may download up to 750 tile packs for offline
  /// use across all regions. If the limit is hit, any loadRegion call
  /// will fail until excess regions are deleted. This limit is subject
  /// to change. Please contact Mapbox if you require a higher limit.
  /// Additional charges may apply.
  Future<StylePack> loadStylePack(
      String styleURI, StylePackLoadOptions loadOptions) async {
    return _api.loadStylePack(styleURI, loadOptions);
  }

  /// Removes a style package.
  ///
  /// @param styleURI: The URI of the style package's associated style
  ///
  /// Removes a style package from the existing packages list. The actual
  /// resources eviction might be deferred. All pending loading operations for
  /// the style package with the given id will fail with Canceled error.
  Future<StylePack> removeStylePack(String styleURI) async {
    return _api.removeStylePack(styleURI);
  }

  /// Returns a style package by its id.
  ///
  /// @param styleURI: The URI of the style package's associated style
  Future<StylePack> stylePack(String styleURI) async {
    return _api.stylePack(styleURI);
  }
}
