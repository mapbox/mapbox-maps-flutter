// This file is generated.
// ignore_for_file: unused_import
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../style_internal.dart';
import '../style_types.dart';
import 'source.dart';

/// A GeoJSON data source.
/// @see [The online documentation](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/#geojson)
final class GeoJsonSource extends Source {
  GeoJsonSource({
    required super.id,
    String? data = "",
    double? maxzoom,
    String? attribution,
    double? buffer,
    double? tolerance,
    bool? cluster,
    double? clusterRadius,
    double? clusterMaxZoom,
    double? clusterMinPoints,
    Map<String, dynamic>? clusterProperties,
    bool? lineMetrics,
    bool? generateId,
    bool? autoMaxZoom,
    double? prefetchZoomDelta,
    TileCacheBudget? tileCacheBudget,
  }) {
    _data = data;
    _maxzoom = maxzoom;
    _attribution = attribution;
    _buffer = buffer;
    _tolerance = tolerance;
    _cluster = cluster;
    _clusterRadius = clusterRadius;
    _clusterMaxZoom = clusterMaxZoom;
    _clusterMinPoints = clusterMinPoints;
    _clusterProperties = clusterProperties;
    _lineMetrics = lineMetrics;
    _generateId = generateId;
    _autoMaxZoom = autoMaxZoom;
    _prefetchZoomDelta = prefetchZoomDelta;
    _tileCacheBudget = tileCacheBudget;
  }

  @override
  String getType() => "geojson";

  String? _data;

  /// A URL to a GeoJSON file, or inline GeoJSON.
  Future<String?> get data async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "data")).value;
    if (raw == null) return null;
    return raw as String;
  }

  double? _maxzoom;

  /// Maximum zoom level at which to create vector tiles (higher means greater detail at high zoom levels).
  /// Default value: 18.
  Future<double?> get maxzoom async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "maxzoom")).value;
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

  double? _buffer;

  /// Size of the tile buffer on each side. A value of 0 produces no buffer. A value of 512 produces a buffer as wide as the tile itself. Larger values produce fewer rendering artifacts near tile edges and slower performance.
  /// Default value: 128. Value range: [0, 512]
  Future<double?> get buffer async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "buffer")).value;
    if (raw == null) return null;
    return (raw as num).toDouble();
  }

  double? _tolerance;

  /// Douglas-Peucker simplification tolerance (higher means simpler geometries and faster performance).
  /// Default value: 0.375.
  Future<double?> get tolerance async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "tolerance",
    )).value;
    if (raw == null) return null;
    return (raw as num).toDouble();
  }

  bool? _cluster;

  /// If the data is a collection of point features, setting this to true clusters the points by radius into groups. Cluster groups become new `Point` features in the source with additional properties:
  ///  - `cluster` Is `true` if the point is a cluster
  ///  - `cluster_id` A unqiue id for the cluster to be used in conjunction with the [cluster inspection methods](https://www.mapbox.com/mapbox-gl-js/api/#geojsonsource#getclusterexpansionzoom)
  ///  - `point_count` Number of original points grouped into this cluster
  ///  - `point_count_abbreviated` An abbreviated point count
  /// Default value: false.
  Future<bool?> get cluster async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "cluster")).value;
    if (raw == null) return null;
    return raw as bool;
  }

  double? _clusterRadius;

  /// Radius of each cluster if clustering is enabled. A value of 512 indicates a radius equal to the width of a tile.
  /// Default value: 50. Minimum value: 0.
  Future<double?> get clusterRadius async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "clusterRadius",
    )).value;
    if (raw == null) return null;
    return (raw as num).toDouble();
  }

  double? _clusterMaxZoom;

  /// Max zoom on which to cluster points if clustering is enabled. Defaults to one zoom less than maxzoom (so that last zoom features are not clustered). Clusters are re-evaluated at integer zoom levels so setting clusterMaxZoom to 14 means the clusters will be displayed until z15.
  Future<double?> get clusterMaxZoom async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "clusterMaxZoom",
    )).value;
    if (raw == null) return null;
    return (raw as num).toDouble();
  }

  double? _clusterMinPoints;

  /// Minimum number of points necessary to form a cluster if clustering is enabled. Defaults to `2`.
  Future<double?> get clusterMinPoints async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "clusterMinPoints",
    )).value;
    if (raw == null) return null;
    return (raw as num).toDouble();
  }

  Map<String, dynamic>? _clusterProperties;

  /// An object defining custom properties on the generated clusters if clustering is enabled, aggregating values from clustered points. Has the form `{"property_name": [operator, map_expression]}`. `operator` is any expression function that accepts at least 2 operands (e.g. `"+"` or `"max"`) — it accumulates the property value from clusters/points the cluster contains; `map_expression` produces the value of a single point.
  ///
  /// Example: `{"sum": ["+", ["get", "scalerank"]]}`.
  ///
  /// For more advanced use cases, in place of `operator`, you can use a custom reduce expression that references a special `["accumulated"]` value, e.g.:
  /// `{"sum": [["+", ["accumulated"], ["get", "sum"]], ["get", "scalerank"]]}`
  Future<Map<String, dynamic>?> get clusterProperties async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "clusterProperties",
    )).value;
    if (raw == null) return null;
    return Map<String, dynamic>.from(
      raw as Map<dynamic, dynamic>,
    ).cast<String, dynamic>();
  }

  bool? _lineMetrics;

  /// Whether to calculate line distance metrics. This is required for line layers that specify `line-gradient` values.
  /// Default value: false.
  Future<bool?> get lineMetrics async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "lineMetrics",
    )).value;
    if (raw == null) return null;
    return raw as bool;
  }

  bool? _generateId;

  /// Whether to generate ids for the GeoJSON features. When enabled, the `feature.id` property will be auto assigned based on its index in the `features` array, over-writing any previous values.
  /// Default value: false.
  Future<bool?> get generateId async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "generateId",
    )).value;
    if (raw == null) return null;
    return raw as bool;
  }

  bool? _autoMaxZoom;

  /// When set to true, the maxZoom property is ignored and is instead calculated automatically based on the largest bounding box from the geojson features. This resolves rendering artifacts for features that use wide blur (e.g. fill extrusion ground flood light or circle layer) and would bring performance improvement on lower zoom levels, especially for geoJSON sources that update data frequently. However, it can lead to flickering and precision loss on zoom levels above 19. This option is not supported in combination with clustering.
  /// Default value: false.
  Future<bool?> get autoMaxZoom async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "autoMaxZoom",
    )).value;
    if (raw == null) return null;
    return raw as bool;
  }

  double? _prefetchZoomDelta;

  /// When loading a map, if PrefetchZoomDelta is set to any number greater than 0, the map will first request a tile at zoom level lower than zoom - delta, but so that the zoom level is multiple of delta, in an attempt to display a full map at lower resolution as quick as possible. It will get clamped at the tile source minimum zoom.
  /// Default value: 4.
  Future<double?> get prefetchZoomDelta async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "prefetch-zoom-delta",
    )).value;
    if (raw == null) return null;
    return (raw as num).toDouble();
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

  /// Update this GeojsonSource with a URL to a GeoJSON file, or inline GeoJSON.
  Future<void>? updateGeoJSON(String geoJson) async {
    return style?.setStyleSourceProperty(id, "data", geoJson);
  }

  @override
  @internal
  Future<void> addToStyle(StylePlatformInterface platformStyle) async {
    // GeoJson sources cannot accept inline data in the initial add payload;
    // it must be set as a volatile property post-add. When [data] was
    // provided to the constructor we clear it to keep the initial payload
    // minimal, add the source via the base addToStyle, then push the data
    // via updateGeoJSON.
    final initialData = _data;
    if (initialData != null && initialData.isNotEmpty) {
      _data = "";
      await super.addToStyle(platformStyle);
      await updateGeoJSON(initialData);
    } else {
      await super.addToStyle(platformStyle);
    }
  }

  @override
  @internal
  String encode({required bool volatile}) {
    var properties = <String, dynamic>{};

    if (volatile) {
      if (_prefetchZoomDelta != null) {
        properties["prefetch-zoom-delta"] = _prefetchZoomDelta;
      }
      if (_tileCacheBudget != null) {
        properties["tile-cache-budget"] = _tileCacheBudget;
      }
    } else {
      properties["id"] = id;
      properties["type"] = getType();
      if (_data != null) {
        properties["data"] = _data;
      }
      if (_maxzoom != null) {
        properties["maxzoom"] = _maxzoom;
      }
      if (_attribution != null) {
        properties["attribution"] = _attribution;
      }
      if (_buffer != null) {
        properties["buffer"] = _buffer;
      }
      if (_tolerance != null) {
        properties["tolerance"] = _tolerance;
      }
      if (_cluster != null) {
        properties["cluster"] = _cluster;
      }
      if (_clusterRadius != null) {
        properties["clusterRadius"] = _clusterRadius;
      }
      if (_clusterMaxZoom != null) {
        properties["clusterMaxZoom"] = _clusterMaxZoom;
      }
      if (_clusterMinPoints != null) {
        properties["clusterMinPoints"] = _clusterMinPoints;
      }
      if (_clusterProperties != null) {
        properties["clusterProperties"] = _clusterProperties;
      }
      if (_lineMetrics != null) {
        properties["lineMetrics"] = _lineMetrics;
      }
      if (_generateId != null) {
        properties["generateId"] = _generateId;
      }
      if (_autoMaxZoom != null) {
        properties["autoMaxZoom"] = _autoMaxZoom;
      }
    }

    return json.encode(properties);
  }
}

// End of generated file.
