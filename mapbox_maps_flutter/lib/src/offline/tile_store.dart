import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// [TileStore] manages downloads and storage for requests to tile-related API endpoints, enforcing a disk usage
/// quota: tiles available on disk may be deleted to make room for a new download. This interface can be used by an
/// app developer to set the disk quota. The rest of TileStore API is intended for native SDK consumption only.
///
/// {@macro supported_platforms_mobile}
final class TileStore {
  final TileStorePlatformInterface _impl;

  @internal
  TileStore(this._impl);

  /// Returns a shared [TileStore] at the default location.
  ///
  /// See [TileStore.createAt].
  static Future<TileStore> createDefault() async {
    final impl = await MapboxMapsFlutterPlatform.instance.createTileStore();
    return TileStore(impl);
  }

  /// Returns a shared [TileStore] at the given storage [filePath].
  ///
  /// If the given path is empty, the tile store at the default location is returned.
  /// On iOS, this storage path is excluded from automatic cloud backup.
  /// On Android, please exclude the storage path in your Manifest.
  /// Please refer to the [Android Documentation](https://developer.android.com/guide/topics/data/autobackup.html#IncludingFiles) for detailed information.
  ///
  /// [filePath]: The path on disk where tiles and metadata will be stored.
  static Future<TileStore> createAt(Uri filePath) async {
    final impl = await MapboxMapsFlutterPlatform.instance.createTileStore(
      filePath: filePath,
    );
    return TileStore(impl);
  }

  /// Loads a new tile region or updates the existing one.
  ///
  /// [id]: The tile region identifier.
  /// [loadOptions]: The tile region load options.
  /// [progressListener]: Invoked when loading progress is updated.
  ///
  /// Creating a new region requires providing both geometry and tileset
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
    OnTileRegionLoadProgressListener? progressListener,
  ) => _impl.loadTileRegion(id, loadOptions, progressListener);

  /// Estimates the storage and transfer size of a tile region.
  ///
  /// [id]: The tile region identifier.
  /// [loadOptions]: The tile region load options.
  /// [estimateOptions]: The options for the estimate operation. Optional, default values will be applied if null.
  /// [progressListener]: Invoked multiple times to report progress of the estimate operation.
  ///
  /// This can be used for estimating existing or new tile regions. For new tile
  /// regions, both geometry and tileset descriptors need to be provided to the
  /// given load options. If a tile region with the given id already exists, its
  /// geometry and tileset descriptors are reused unless a different value is
  /// provided in the region load options.
  ///
  /// Estimating a tile region does not mutate existing tile regions on the tile store.
  Future<TileRegionEstimateResult> estimateTileRegion(
    String id,
    TileRegionLoadOptions loadOptions,
    TileRegionEstimateOptions? estimateOptions,
    OnTileRegionEstimateProgressListener? progressListener,
  ) => _impl.estimateTileRegion(
    id,
    loadOptions,
    estimateOptions,
    progressListener,
  );

  /// Fetches the array of the existing tile regions.
  Future<List<TileRegion>> allTileRegions() => _impl.allTileRegions();

  /// Returns a tile region given its id.
  ///
  /// [id]: The tile region id.
  Future<TileRegion> tileRegion(String id) => _impl.tileRegion(id);

  /// Checks if a tile region with the given id contains all tilesets from all
  /// of the given tileset descriptors.
  ///
  /// [id]: The tile region identifier.
  /// [options]: The array of [TilesetDescriptorOptions].
  Future<bool> tileRegionContainsDescriptor(
    String id,
    List<TilesetDescriptorOptions> options,
  ) => _impl.tileRegionContainsDescriptor(id, options);

  /// Fetches a tile region's associated metadata.
  ///
  /// The region's associated metadata that a user previously set for this region.
  /// [id]: The tile region id.
  Future<Map<String, Object>> tileRegionMetadata(String id) =>
      _impl.tileRegionMetadata(id);

  /// On successful tile region removal, this will complete with the removed tile region.
  /// Otherwise, this will complete with an error.
  /// [id]: The tile region id.
  Future<TileRegion> removeRegion(String id) => _impl.removeRegion(id);

  /// Sets the maximum amount of bytes [TileStore] can use to store files.
  /// If the new value causes the quota to be exceeded, request will fail and data will be evicted to enforce the quota.
  /// Accepts a (positive) number of bytes, or null for resetting to the default value.
  Future<void> setDiskQuota(int? quota, {TileDataDomain? domain}) =>
      _impl.setDiskQuota(quota, domain: domain);

  /// Sets the base URL to use for requests to the Mapbox API. Defaults to "https://api.mapbox.com".
  /// Accepts a string, or null for resetting to the default value.
  Future<void> setMapboxAPIUrl(Uri? url, {TileDataDomain? domain}) =>
      _impl.setMapboxAPIUrl(url, domain: domain);

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
  Future<void> setTileUrlTemplate(String? template, {TileDataDomain? domain}) =>
      _impl.setTileUrlTemplate(template, domain: domain);

  /// Sets additional options for this [TileStore] that are specific to a data type.
  ///
  /// @param key The configuration option that should be changed.
  /// @param domain The domain this setting should be applied for.
  /// @param value The value for the configuration option, or null if it should be reset.
  Future<void> setOptionForKey(
    String key, {
    TileDataDomain? domain,
    Object? value,
  }) => _impl.setOptionForKey(key, domain: domain, value: value);
}
