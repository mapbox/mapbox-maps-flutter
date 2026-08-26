import '../pigeons/platform_interface_data_types.dart';

/// StylePack load progress callback.
typedef OnStylePackLoadProgressListener =
    void Function(StylePackLoadProgress progress);

/// TileRegion load progress callback.
typedef OnTileRegionLoadProgressListener =
    void Function(TileRegionLoadProgress progress);

/// TileRegion estimate progress callback.
typedef OnTileRegionEstimateProgressListener =
    void Function(TileRegionEstimateProgress progress);
