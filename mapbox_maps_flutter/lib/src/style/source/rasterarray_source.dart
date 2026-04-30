// This file is generated.
// ignore_for_file: unused_import
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../style_internal.dart';
import '../style_types.dart';
import 'source.dart';

/// A raster array source
/// @see [The online documentation](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/#raster_array)
@experimental
final class RasterArraySource extends Source {
  RasterArraySource({
    required String id,
    String? url,
    List<String?>? tiles,
    List<double?>? bounds,
    double? minzoom,
    double? maxzoom,
    double? tileSize,
    String? attribution,
    bool? volatile,
    TileCacheBudget? tileCacheBudget,
  }) : super(id: id) {
    _url = url;
    _tiles = tiles;
    _bounds = bounds;
    _minzoom = minzoom;
    _maxzoom = maxzoom;
    _tileSize = tileSize;
    _attribution = attribution;
    _volatile = volatile;
    _tileCacheBudget = tileCacheBudget;
  }

  @override
  String getType() => "raster-array";

  String? _url;

  /// A URL to a TileJSON resource. Supported protocols are `http:`, `https:`, and `mapbox://<Tileset ID>`. Required if `tiles` is not provided.
  Future<String?> get url async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "url")).value;
    if (raw == null) return null;
    return raw as String;
  }

  List<String?>? _tiles;

  /// An array of one or more tile source URLs, as in the TileJSON spec. Required if `url` is not provided.
  Future<List<String?>?> get tiles async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "tiles")).value;
    if (raw == null) return null;
    return (raw as List<dynamic>).cast();
  }

  List<double?>? _bounds;

  /// An array containing the longitude and latitude of the southwest and northeast corners of the source's bounding box in the following order: `[sw.lng, sw.lat, ne.lng, ne.lat]`. When this property is included in a source, no tiles outside of the given bounds are requested by Mapbox GL.
  /// Default value: [-180,-85.051129,180,85.051129].
  Future<List<double?>?> get bounds async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "bounds")).value;
    if (raw == null) return null;
    return (raw as List<dynamic>).cast();
  }

  double? _minzoom;

  /// Minimum zoom level for which tiles are available, as in the TileJSON spec.
  /// Default value: 0.
  Future<double?> get minzoom async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "minzoom")).value;
    if (raw == null) return null;
    return (raw as num).toDouble();
  }

  double? _maxzoom;

  /// Maximum zoom level for which tiles are available, as in the TileJSON spec. Data from tiles at the maxzoom are used when displaying the map at higher zoom levels.
  /// Default value: 22.
  Future<double?> get maxzoom async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "maxzoom")).value;
    if (raw == null) return null;
    return (raw as num).toDouble();
  }

  double? _tileSize;

  /// The minimum visual size to display tiles for this layer. Only configurable for raster layers.
  /// Default value: 512. The unit of tileSize is in pixels.
  Future<double?> get tileSize async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "tileSize")).value;
    if (raw == null) return null;
    return (raw as num).toDouble();
  }

  String? _attribution;

  /// Contains an attribution to be displayed when the map is shown to a user.
  Future<String?> get attribution async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "attribution",
    )).value;
    if (raw == null) return null;
    return raw as String;
  }

  List<RasterDataLayer?>? _rasterLayers;

  /// Contains the description of the raster data layers and the bands contained within the tiles.
  Future<List<RasterDataLayer?>?> get rasterLayers async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "rasterLayers",
    )).value;
    if (raw == null) return null;
    return (raw as Map<Object?, Object?>).entries.map((entry) {
      return RasterDataLayer(
        entry.key as String,
        (entry.value as List).cast<String>(),
      );
    }).toList();
  }

  bool? _volatile;

  /// A setting to determine whether a source's tiles are cached locally.
  /// Default value: false.
  Future<bool?> get volatile async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "volatile")).value;
    if (raw == null) return null;
    return raw as bool;
  }

  TileCacheBudget? _tileCacheBudget;

  /// This property defines a source-specific resource budget, either in tile units or in megabytes. Whenever the tile cache goes over the defined limit, the least recently used tile will be evicted from the in-memory cache. Note that the current implementation does not take into account resources allocated by the visible tiles.
  Future<TileCacheBudget?> get tileCacheBudget async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "tile-cache-budget",
    )).value;
    if (raw == null) return null;
    return TileCacheBudget.decode(raw);
  }

  @override
  @internal
  String encode({required bool volatile}) {
    var properties = <String, dynamic>{};

    if (volatile) {
      if (_tileCacheBudget != null) {
        properties["tile-cache-budget"] = _tileCacheBudget;
      }
    } else {
      properties["id"] = id;
      properties["type"] = getType();
      if (_url != null) {
        properties["url"] = _url;
      }
      if (_tiles != null) {
        properties["tiles"] = _tiles;
      }
      if (_bounds != null) {
        properties["bounds"] = _bounds;
      }
      if (_minzoom != null) {
        properties["minzoom"] = _minzoom;
      }
      if (_maxzoom != null) {
        properties["maxzoom"] = _maxzoom;
      }
      if (_tileSize != null) {
        properties["tileSize"] = _tileSize;
      }
      if (_attribution != null) {
        properties["attribution"] = _attribution;
      }
      if (_rasterLayers != null) {
        properties["rasterLayers"] = _rasterLayers;
      }
      if (_volatile != null) {
        properties["volatile"] = _volatile;
      }
    }

    return json.encode(properties);
  }
}

// End of generated file.
