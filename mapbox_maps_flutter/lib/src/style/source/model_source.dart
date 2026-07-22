// This file is generated.
// ignore_for_file: unused_import
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../style_internal.dart';
import '../style_types.dart';
import 'model.dart';
import 'source.dart';

/// A collection of 3D models
/// @see [The online documentation](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/#model)
final class ModelSource extends Source {
  ModelSource({
    required super.id,
    this.batched = false,
    String? url,
    double? maxzoom,
    double? minzoom,
    List<String?>? tiles,
    List<ModelSourceModel>? models,
  }) {
    _url = url;
    _maxzoom = maxzoom;
    _minzoom = minzoom;
    _tiles = tiles;
    _models = models;
  }

  /// Whether this source represents a `batched-model` source instead of a
  /// `model` source (the default). A `model` source is a small, explicit
  /// list of models passed via [models], each with its own position and
  /// orientation. A `batched-model` source is a tiled source, like a vector
  /// tileset, for covering a wide area with many models, configured via
  /// [url]/[tiles] and [minzoom]/[maxzoom] instead of [models].
  bool batched;

  @override
  String getType() => batched ? "batched-model" : "model";

  String? _url;

  /// A URL to a TileJSON resource. Supported protocols are `http:`, `https:`, and `mapbox://<Tileset ID>`. Required if `tiles` is not provided.
  Future<String?> get url async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "url")).value;
    if (raw == null) return null;
    return raw as String;
  }

  double? _maxzoom;

  /// Maximum zoom level at which to create batched model tiles. Data from tiles at the maxzoom are used when displaying the map at higher zoom levels.
  /// Default value: 18.
  Future<double?> get maxzoom async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "maxzoom")).value;
    if (raw == null) return null;
    return (raw as num).toDouble();
  }

  double? _minzoom;

  /// Minimum zoom level for which batched-model tiles are available
  /// Default value: 0.
  Future<double?> get minzoom async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "minzoom")).value;
    if (raw == null) return null;
    return (raw as num).toDouble();
  }

  List<String?>? _tiles;

  /// An array of one or more tile source URLs, as in the TileJSON spec. Requires `batched-model` source type.
  Future<List<String?>?> get tiles async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "tiles")).value;
    if (raw == null) return null;
    return (raw as List<dynamic>).cast();
  }

  List<ModelSourceModel>? _models;

  /// Defines properties of 3D models in collection. Requires `model` source type.
  Future<List<ModelSourceModel>?> get models async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "models")).value;
    if (raw == null) return null;
    return (raw as Map<Object?, Object?>).entries.map((entry) {
      return ModelSourceModel.fromJson(
        entry.key as String,
        Map<String, dynamic>.from(entry.value as Map),
      );
    }).toList();
  }

  @override
  @internal
  String encode({required bool volatile}) {
    var properties = <String, dynamic>{};

    if (volatile) {
    } else {
      properties["id"] = id;
      properties["type"] = getType();
      if (_url != null) {
        properties["url"] = _url;
      }
      if (_maxzoom != null) {
        properties["maxzoom"] = _maxzoom;
      }
      if (_minzoom != null) {
        properties["minzoom"] = _minzoom;
      }
      if (_tiles != null) {
        properties["tiles"] = _tiles;
      }
      if (_models != null) {
        properties["models"] = {
          for (final model in _models!) model.id: model.toJson(),
        };
      }
    }

    return json.encode(properties);
  }
}

// End of generated file.
