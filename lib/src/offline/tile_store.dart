part of mapbox_maps_flutter;

final _TileStoreInstanceManager _tileStoreInstanceManager =
    _TileStoreInstanceManager();

/// [TileStore] manages downloads and storage for requests to tile-related API endpoints, enforcing a disk usage
/// quota: tiles available on disk may be deleted to make room for a new download. This interface can be used by an
/// app developer to set the disk quota. The rest of TileStore API is intended for native SDK consumption only.
final class TileStore {
  final int _suffix = _suffixesRegistry.getSuffix();
  static final Finalizer<int> _finalizer = Finalizer((suffix) {
    try {
      _tileStoreInstanceManager
          .tearDownTileStore("tilestore/${suffix.toString()}");
      _suffixesRegistry.releaseSuffix(suffix);
    } catch (e) {}
  });

  late final _TileStore _api;

  TileStore._() {
    final messenger =
        ProxyBinaryMessenger(suffix: "tilestore/${_suffix.toString()}");
    _api = _TileStore(binaryMessenger: messenger);
  }

  /// Returns a shared [TileStore] at the given storage [filePath].
  /// If the given path is empty, the tile store at the default location is returned.
  /// On iOS, this storage path is excluded from automatic cloud backup.
  /// @param filePath: The path on disk where tiles and metadata will be stored.
  static Future<TileStore> createAt(Uri filePath) async {
    final tileStore = TileStore._();
    await _tileStoreInstanceManager.setupTileStore(
        "tilestore/${tileStore._suffix.toString()}", filePath.path);
    _finalizer.attach(tileStore, tileStore._suffix, detach: tileStore);
    return tileStore;
  }

  /// Returns a shared [TileStore] at the default location.
  /// See [TileStore.createAt]
  static Future<TileStore> createDefault() async {
    final tileStore = TileStore._();
    await _tileStoreInstanceManager.setupTileStore(
        "tilestore/${tileStore._suffix.toString()}", null);
    _finalizer.attach(tileStore, tileStore._suffix, detach: tileStore);
    return tileStore;
  }

  /// Loads a new tile region or updates the existing one.
  ///
  /// @param id: The tile region identifier.
  /// @param loadOptions: The tile region load options.
  /// @param progressListener: Invokes when loading progress is updated.
  ///
  /// Creating of a new region requires providing both geometry and tileset
  /// descriptors to the given load options, otherwise the load request fails
  /// with `RegionNotFound` error.
  ///
  /// If a tile region with the given id already exists, it gets updated with
  /// the values provided to the given load options. The missing resources get
  /// loaded and the expired resources get updated.
  ///
  /// If there are no values provided to the given load options, the existing tile
  /// region gets refreshed: the missing resources get loaded and the expired
  /// resources get updated.
  ///
  /// A failed load request can be re-attempted with another [TileStore.loadTileRegion] call.
  ///
  /// If there is already a pending loading operation for the tile region with
  /// the given id, the pending loading operation will fail with an error of
  /// `Canceled` type.
  ///
  /// - Note:
  ///     The user-provided callbacks will be executed on a
  ///     TileStore-controlled worker thread; it is the responsibility of the
  ///     user to dispatch to a user-controlled thread.
  ///
  /// - Important:
  ///     By default, users may download up to 750 tile packs for offline
  ///     use across all regions. If the limit is hit, any loadRegion call
  ///     will fail until excess regions are deleted. This limit is subject
  ///     to change. Please contact Mapbox if you require a higher limit.
  ///     Additional charges may apply.
  Future<TileRegion> loadTileRegion(
      String id,
      TileRegionLoadOptions loadOptions,
      OnTileRegionLoadProgressListener? progressListener) async {
    if (progressListener != null) {
      await _api.addTileRegionLoadProgressListener(id);
      final eventChannel =
          EventChannel("com.mapbox.maps.flutter/tilestore/tile-region-${id}");
      eventChannel.receiveBroadcastStream().listen((event) {
        progressListener(TileRegionLoadProgress.decode(event));
      });
    }
    return _api.loadTileRegion(id, loadOptions);
  }

  /// Estimates the storage and transfer size of a tile region.
  ///
  /// @param id The tile region identifier.
  /// @param loadOptions The tile region load options.
  /// @param estimateOptions The options for the estimate operation. Optional, default values will be applied if null.
  /// @param progressListener Invoked multiple times to report progress of the estimate operation.
  ///
  /// This can be used for estimating existing or new tile regions. For new tile
  /// regions, both geometry and tileset descriptors need to be provided to the
  /// given load options.  If a tile region with the given id already exists, its
  /// geometry and tileset descriptors are reused unless a different value is
  /// provided in the region load options.
  ///
  /// Estimating a tile region does not mutate existing tile regions on the tile store.
  Future<TileRegionEstimateResult> estimateTileRegion(
      String id,
      TileRegionLoadOptions loadOptions,
      TileRegionEstimateOptions? estimateOptions,
      OnTileRegionEstimateProgressListenter? progressListener) async {
    if (progressListener != null) {
      await _api.addTileRegionEstimateProgressListener(id);
      final eventChannel = EventChannel(
          "com.mapbox.maps.flutter/tilestore/tile-region-estimate-${id}");
      eventChannel.receiveBroadcastStream().listen((event) {
        progressListener(TileRegionEstimateProgress.decode(event));
      });
    }
    return _api.estimateTileRegion(id, loadOptions, estimateOptions);
  }

  /// Fetch the array of the existing tile regions.
  Future<List<TileRegion>> allTileRegions() {
    return _api.allTileRegions().then((value) => value.nonNulls.toList());
  }

  /// Returns a tile region given its id.
  ///
  /// -@param id: The tile region id.
  Future<TileRegion> tileRegion(String id) {
    return _api.tileRegion(id);
  }

  /// Checks if a tile region with the given id contains all tilesets from all
  /// of the given tileset descriptors.
  ///
  /// @param id: The tile region identifier.
  /// @param descriptors: The array of [TilesetDescriptorOptions].
  Future<bool> tileRegionContainsDescriptor(
      String id, List<TilesetDescriptorOptions> options) {
    return _api.tileRegionContainsDescriptor(id, options);
  }

  /// Fetch a tile region's associated metadata
  ///
  /// The region's associated metadata that a user previously set for this region.
  /// @param id: The tile region id.
  Future<Map<String, Object>> tileRegionMetadata(String id) {
    return _api.tileRegionMetadata(id).then((value) => Map.from(value));
  }

  /// On successful tile region removal, this will complete with the removed tile region.
  /// Otherwise, this will complete with an error.
  /// @param id: The tile region id.
  Future<TileRegion> removeRegion(String id) {
    return _api.removeRegion(id);
  }

  /// Sets the maximum amount of bytes [TileStore] can use to store files.
  /// If the new value causes the quota to be exceed, request will fail and data will be evicted to enforce the quota.
  /// Accepts a (positive) number of bytes, or null for resetting to the default value.
  void setDiskQuota(int? quota, {TileDataDomain? domain = null}) {
    _api.setOptionForKey(_TileStoreOptionsKey.DISK_QUOTA, domain, quota);
  }

  /// Sets the base URL to use for requests to the Mapbox API. Defaults to "https://api.mapbox.com".
  /// Accepts a string, or null for resetting to the default value.
  void setMapboxAPIUrl(Uri? url, {TileDataDomain? domain = null}) {
    _api.setOptionForKey(_TileStoreOptionsKey.MAPBOX_API_URL, domain, url);
  }

  /// Sets the URL template for making tile requests. Defaults to the Mapbox API endpoints.
  /// Accepts a string, or null for resetting to the default value.
  ///
  /// The template string for the URL, which may contain the following placeholders:
  /// - {mapbox_api_url}: The globally set Mapbox API URL, or the default endpoint if none is set.
  /// - {mapbox_access_token}: The access token, or an empty string if none is set.
  /// - {mapbox_sku_token}: The Mapbox SKU token for the tile.
  /// - {domain}: A lowercase string representing the data domain, e.g. 'maps', or 'navigation'.
  /// - {dataset}: The dataset of the tile to be loaded, e.g. 'mapbox.mapbox-streets-v8'.
  /// - {version}: The dataset version of the tile to be loaded, if applicable.
  /// - {level}: The level of the Navigation tile to be loaded.
  /// - {graph_id}: The graph ID suffix of the Navigation tile to be loaded. E.g. '002/958/221'
  /// - {z}: The zoom level of the Map tile to be loaded.
  /// - {x}: The x coordinate of the Map tile to be loaded.
  /// - {y}: The y coordinate of the Map tile to be loaded.
  /// - {z_min}: The zoom range minimum of the Map tile to be loaded.
  /// - {z_max}: The zoom range maximum of the Map tile to be loaded.
  void setTileUrlTemplate(String? template, {TileDataDomain? domain = null}) {
    _api.setOptionForKey(
        _TileStoreOptionsKey.TILE_URL_TEMPLATE, domain, template);
  }
}
