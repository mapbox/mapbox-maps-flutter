import '../pigeons/platform_interface_data_types.dart';

// ===== Abstract interfaces =====

/// Abstract interface for managing offline style packages.
abstract interface class OfflineManagerPlatformInterface {
  /// Loads or updates a style package.
  Future<StylePack> loadStylePack(
    String styleURI,
    StylePackLoadOptions loadOptions,
    OnStylePackLoadProgressListener? progressListener,
  );

  /// Removes a style package.
  Future<StylePack> removeStylePack(String styleURI);

  /// Returns a style package by its style URI.
  Future<StylePack> stylePack(String styleURI);

  /// Returns the metadata associated with a style package.
  Future<Map<String, Object>> stylePackMetadata(String styleURI);

  /// Returns all existing style packages.
  Future<List<StylePack>> allStylePacks();
}

/// Abstract interface for managing tile store downloads.
abstract interface class TileStorePlatformInterface {
  /// Loads or updates a tile region.
  Future<TileRegion> loadTileRegion(
    String id,
    TileRegionLoadOptions loadOptions,
    OnTileRegionLoadProgressListener? progressListener,
  );

  /// Estimates the storage and transfer size of a tile region.
  Future<TileRegionEstimateResult> estimateTileRegion(
    String id,
    TileRegionLoadOptions loadOptions,
    TileRegionEstimateOptions? estimateOptions,
    OnTileRegionEstimateProgressListener? progressListener,
  );

  /// Returns all existing tile regions.
  Future<List<TileRegion>> allTileRegions();

  /// Returns a tile region by its id.
  Future<TileRegion> tileRegion(String id);

  /// Returns whether a tile region contains all tilesets from the given descriptors.
  Future<bool> tileRegionContainsDescriptor(
    String id,
    List<TilesetDescriptorOptions> options,
  );

  /// Returns the metadata associated with a tile region.
  Future<Map<String, Object>> tileRegionMetadata(String id);

  /// Removes a tile region.
  Future<TileRegion> removeRegion(String id);

  /// Sets the maximum disk quota.
  Future<void> setDiskQuota(int? quota, {TileDataDomain? domain});

  /// Sets the Mapbox API base URL.
  Future<void> setMapboxAPIUrl(Uri? url, {TileDataDomain? domain});

  /// Sets a tile URL template.
  Future<void> setTileUrlTemplate(String? template, {TileDataDomain? domain});

  Future<void> setOptionForKey(
    String key, {
    TileDataDomain? domain,
    Object? value,
  });
}

/// Abstract interface for controlling the Mapbox network stack connectivity.
abstract interface class OfflineSwitchPlatformInterface {
  /// Returns whether the Mapbox network stack is connected.
  Future<bool> get isMapboxStackConnected;

  /// Enables or disables the Mapbox network stack.
  Future<void> setMapboxStackConnected(bool isConnected);
}

// ===== Progress listener typedefs =====

/// StylePack load progress callback.
typedef OnStylePackLoadProgressListener =
    void Function(StylePackLoadProgress progress);

/// TileRegion load progress callback.
typedef OnTileRegionLoadProgressListener =
    void Function(TileRegionLoadProgress progress);

/// TileRegion estimate progress callback.
typedef OnTileRegionEstimateProgressListener =
    void Function(TileRegionEstimateProgress progress);
