import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Manages offline tile region downloads and storage.
class TileStore {
  final TileStorePlatformInterface _impl;

  @internal
  TileStore(this._impl);

  /// Loads or updates a tile region.
  Future<TileRegion> loadTileRegion(
    String id,
    TileRegionLoadOptions loadOptions,
    OnTileRegionLoadProgressListener? progressListener,
  ) =>
      _impl.loadTileRegion(id, loadOptions, progressListener);

  /// Estimates the storage and transfer size of a tile region.
  Future<TileRegionEstimateResult> estimateTileRegion(
    String id,
    TileRegionLoadOptions loadOptions,
    TileRegionEstimateOptions? estimateOptions,
    OnTileRegionEstimateProgressListener? progressListener,
  ) =>
      _impl.estimateTileRegion(id, loadOptions, estimateOptions,
          progressListener);

  /// Returns all existing tile regions.
  Future<List<TileRegion>> allTileRegions() => _impl.allTileRegions();

  /// Returns a tile region by its id.
  Future<TileRegion> tileRegion(String id) => _impl.tileRegion(id);

  /// Returns whether a tile region contains all tilesets from the given descriptors.
  Future<bool> tileRegionContainsDescriptor(
    String id,
    List<TilesetDescriptorOptions> options,
  ) =>
      _impl.tileRegionContainsDescriptor(id, options);

  /// Returns the metadata associated with a tile region.
  Future<Map<String, Object>> tileRegionMetadata(String id) =>
      _impl.tileRegionMetadata(id);

  /// Removes a tile region.
  Future<TileRegion> removeRegion(String id) => _impl.removeRegion(id);

  /// Sets the maximum disk quota.
  void setDiskQuota(int? quota, {TileDataDomain? domain}) =>
      _impl.setDiskQuota(quota, domain: domain);

  /// Sets the Mapbox API base URL.
  void setMapboxAPIUrl(Uri? url, {TileDataDomain? domain}) =>
      _impl.setMapboxAPIUrl(url, domain: domain);

  /// Sets a tile URL template.
  void setTileUrlTemplate(String? template, {TileDataDomain? domain}) =>
      _impl.setTileUrlTemplate(template, domain: domain);
}
