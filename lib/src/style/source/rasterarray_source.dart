// This file is generated.
part of mapbox_maps_flutter;

/// A raster array source
/// @see [The online documentation](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/#raster_array)
@experimental
class RasterArraySource extends Source {
  RasterArraySource({
    required String id,
    String? url,
    List<String?>? tiles,
    List<double?>? bounds,
    double? minzoom,
    double? maxzoom,
    double? tileSize,
    String? attribution,
    TileCacheBudget? tileCacheBudget,
  }) : super(id: id) {
    _url = url;
    _tiles = tiles;
    _bounds = bounds;
    _minzoom = minzoom;
    _maxzoom = maxzoom;
    _tileSize = tileSize;
    _attribution = attribution;
    _tileCacheBudget = tileCacheBudget;
  }

  @override
  String getType() => "raster-array";

  String? _url;

  /// A URL to a TileJSON resource. Supported protocols are `http:`, `https:`, and `mapbox://<Tileset ID>`. Required if `tiles` is not provided.
  Future<String?> get url async {
    return _style?.getStyleSourceProperty(id, "url").then((value) {
      if (value.value != null) {
        return value.value as String;
      } else {
        return null;
      }
    });
  }

  List<String?>? _tiles;

  /// An array of one or more tile source URLs, as in the TileJSON spec. Required if `url` is not provided.
  Future<List<String?>?> get tiles async {
    return _style?.getStyleSourceProperty(id, "tiles").then((value) {
      if (value.value != null) {
        return (value.value as List<dynamic>).cast();
      } else {
        return null;
      }
    });
  }

  List<double?>? _bounds;

  /// An array containing the longitude and latitude of the southwest and northeast corners of the source's bounding box in the following order: `[sw.lng, sw.lat, ne.lng, ne.lat]`. When this property is included in a source, no tiles outside of the given bounds are requested by Mapbox GL.
  /// Default value: [-180,-85.051129,180,85.051129].
  Future<List<double?>?> get bounds async {
    return _style?.getStyleSourceProperty(id, "bounds").then((value) {
      if (value.value != null) {
        return (value.value as List<dynamic>).cast();
      } else {
        return null;
      }
    });
  }

  double? _minzoom;

  /// Minimum zoom level for which tiles are available, as in the TileJSON spec.
  /// Default value: 0.
  Future<double?> get minzoom async {
    return _style?.getStyleSourceProperty(id, "minzoom").then((value) {
      if (value.value != null) {
        return (value.value as num).toDouble();
      } else {
        return null;
      }
    });
  }

  double? _maxzoom;

  /// Maximum zoom level for which tiles are available, as in the TileJSON spec. Data from tiles at the maxzoom are used when displaying the map at higher zoom levels.
  /// Default value: 22.
  Future<double?> get maxzoom async {
    return _style?.getStyleSourceProperty(id, "maxzoom").then((value) {
      if (value.value != null) {
        return (value.value as num).toDouble();
      } else {
        return null;
      }
    });
  }

  double? _tileSize;

  /// The minimum visual size to display tiles for this layer. Only configurable for raster layers.
  /// Default value: 512.
  Future<double?> get tileSize async {
    return _style?.getStyleSourceProperty(id, "tileSize").then((value) {
      if (value.value != null) {
        return (value.value as num).toDouble();
      } else {
        return null;
      }
    });
  }

  String? _attribution;

  /// Contains an attribution to be displayed when the map is shown to a user.
  Future<String?> get attribution async {
    return _style?.getStyleSourceProperty(id, "attribution").then((value) {
      if (value.value != null) {
        return value.value as String;
      } else {
        return null;
      }
    });
  }

  List<RasterDataLayer?>? _rasterLayers;

  /// Contains the description of the raster data layers and the bands contained within the tiles.
  Future<List<RasterDataLayer?>?> get rasterLayers async {
    return _style?.getStyleSourceProperty(id, "rasterLayers").then((value) {
      if (value.value != null) {
        return (value.value as Map<Object?, Object?>).entries.map((entry) {
          return RasterDataLayer(
              entry.key as String, (entry.value as List).cast<String>());
        }).toList();
      } else {
        return null;
      }
    });
  }

  TileCacheBudget? _tileCacheBudget;

  /// This property defines a source-specific resource budget, either in tile units or in megabytes. Whenever the tile cache goes over the defined limit, the least recently used tile will be evicted from the in-memory cache. Note that the current implementation does not take into account resources allocated by the visible tiles.
  Future<TileCacheBudget?> get tileCacheBudget async {
    return _style
        ?.getStyleSourceProperty(id, "tile-cache-budget")
        .then((value) {
      if (value.value != null) {
        return TileCacheBudget.decode(value.value);
      } else {
        return null;
      }
    });
  }

  @override
  String _encode(bool volatile) {
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
    }

    return json.encode(properties);
  }
}

// End of generated file.
