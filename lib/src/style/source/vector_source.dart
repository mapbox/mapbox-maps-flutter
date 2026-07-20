// This file is generated.
part of mapbox_maps_flutter;

/// A vector tile source.
/// @see [The online documentation](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/#vector)
class VectorSource extends Source {
  VectorSource({
    required String id,
    String? url,
    List<String?>? tiles,
    List<double?>? bounds,
    Scheme? scheme,
    double? minzoom,
    double? maxzoom,
    String? attribution,
    bool? volatile,
    double? prefetchZoomDelta,
    TileCacheBudget? tileCacheBudget,
    double? minimumTileUpdateInterval,
    double? maxOverscaleFactorForParentTiles,
    double? tileRequestsDelay,
    double? tileNetworkRequestsDelay,
  }) : super(id: id) {
    _url = url;
    _tiles = tiles;
    _bounds = bounds;
    _scheme = scheme;
    _minzoom = minzoom;
    _maxzoom = maxzoom;
    _attribution = attribution;
    _volatile = volatile;
    _prefetchZoomDelta = prefetchZoomDelta;
    _tileCacheBudget = tileCacheBudget;
    _minimumTileUpdateInterval = minimumTileUpdateInterval;
    _maxOverscaleFactorForParentTiles = maxOverscaleFactorForParentTiles;
    _tileRequestsDelay = tileRequestsDelay;
    _tileNetworkRequestsDelay = tileNetworkRequestsDelay;
  }

  @override
  String getType() => "vector";

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

  Scheme? _scheme;

  /// Influences the y direction of the tile coordinates. The global-mercator (aka Spherical Mercator) profile is assumed.
  /// Default value: "xyz".
  Future<Scheme?> get scheme async {
    return _style?.getStyleSourceProperty(id, "scheme").then((value) {
      if (value.value != null) {
        return Scheme.values.firstWhere((e) => e
            .toString()
            .split('.')
            .last
            .toLowerCase()
            .contains(value.value as String));
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

  bool? _volatile;

  /// A setting to determine whether a source's tiles are cached locally.
  /// Default value: false.
  Future<bool?> get volatile async {
    return _style?.getStyleSourceProperty(id, "volatile").then((value) {
      if (value.value != null) {
        return value.value as bool;
      } else {
        return null;
      }
    });
  }

  double? _prefetchZoomDelta;

  /// When loading a map, if PrefetchZoomDelta is set to any number greater than 0, the map will first request a tile at zoom level lower than zoom - delta, but so that the zoom level is multiple of delta, in an attempt to display a full map at lower resolution as quick as possible. It will get clamped at the tile source minimum zoom.
  /// Default value: 4.
  Future<double?> get prefetchZoomDelta async {
    return _style
        ?.getStyleSourceProperty(id, "prefetch-zoom-delta")
        .then((value) {
      if (value.value != null) {
        return (value.value as num).toDouble();
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

  double? _minimumTileUpdateInterval;

  /// Minimum tile update interval in seconds, which is used to throttle the tile update network requests. If the given source supports loading tiles from a server, sets the minimum tile update interval. Update network requests that are more frequent than the minimum tile update interval are suppressed.
  /// Default value: 0.
  Future<double?> get minimumTileUpdateInterval async {
    return _style
        ?.getStyleSourceProperty(id, "minimum-tile-update-interval")
        .then((value) {
      if (value.value != null) {
        return (value.value as num).toDouble();
      } else {
        return null;
      }
    });
  }

  double? _maxOverscaleFactorForParentTiles;

  /// When a set of tiles for a current zoom level is being rendered and some of the ideal tiles that cover the screen are not yet loaded, parent tile could be used instead. This might introduce unwanted rendering side-effects, especially for raster tiles that are overscaled multiple times. This property sets the maximum limit for how much a parent tile can be overscaled.
  Future<double?> get maxOverscaleFactorForParentTiles async {
    return _style
        ?.getStyleSourceProperty(id, "max-overscale-factor-for-parent-tiles")
        .then((value) {
      if (value.value != null) {
        return (value.value as num).toDouble();
      } else {
        return null;
      }
    });
  }

  double? _tileRequestsDelay;

  /// For the tiled sources, this property sets the tile requests delay. The given delay comes in action only during an ongoing animation or gestures. It helps to avoid loading, parsing and rendering of the transient tiles and thus to improve the rendering performance, especially on low-end devices.
  /// Default value: 0.
  Future<double?> get tileRequestsDelay async {
    return _style
        ?.getStyleSourceProperty(id, "tile-requests-delay")
        .then((value) {
      if (value.value != null) {
        return (value.value as num).toDouble();
      } else {
        return null;
      }
    });
  }

  double? _tileNetworkRequestsDelay;

  /// For the tiled sources, this property sets the tile network requests delay. The given delay comes in action only during an ongoing animation or gestures. It helps to avoid loading the transient tiles from the network and thus to avoid redundant network requests. Note that tile-network-requests-delay value is superseded with tile-requests-delay property value, if both are provided.
  /// Default value: 0.
  Future<double?> get tileNetworkRequestsDelay async {
    return _style
        ?.getStyleSourceProperty(id, "tile-network-requests-delay")
        .then((value) {
      if (value.value != null) {
        return (value.value as num).toDouble();
      } else {
        return null;
      }
    });
  }

  @override
  String _encode(bool volatile) {
    var properties = <String, dynamic>{};

    if (volatile) {
      if (_prefetchZoomDelta != null) {
        properties["prefetch-zoom-delta"] = _prefetchZoomDelta;
      }
      if (_tileCacheBudget != null) {
        properties["tile-cache-budget"] = _tileCacheBudget;
      }
      if (_minimumTileUpdateInterval != null) {
        properties["minimum-tile-update-interval"] = _minimumTileUpdateInterval;
      }
      if (_maxOverscaleFactorForParentTiles != null) {
        properties["max-overscale-factor-for-parent-tiles"] =
            _maxOverscaleFactorForParentTiles;
      }
      if (_tileRequestsDelay != null) {
        properties["tile-requests-delay"] = _tileRequestsDelay;
      }
      if (_tileNetworkRequestsDelay != null) {
        properties["tile-network-requests-delay"] = _tileNetworkRequestsDelay;
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
      if (_scheme != null) {
        properties["scheme"] = _scheme?.name.toLowerCase().replaceAll("_", "-");
      }
      if (_minzoom != null) {
        properties["minzoom"] = _minzoom;
      }
      if (_maxzoom != null) {
        properties["maxzoom"] = _maxzoom;
      }
      if (_attribution != null) {
        properties["attribution"] = _attribution;
      }
      if (_volatile != null) {
        properties["volatile"] = _volatile;
      }
    }

    return json.encode(properties);
  }
}

// End of generated file.
