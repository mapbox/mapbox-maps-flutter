// This file is generated.
// ignore_for_file: unused_import
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../style_internal.dart';
import '../style_types.dart';
import 'source.dart';

/// An image data source.
/// @see [The online documentation](https://docs.mapbox.com/mapbox-gl-js/style-spec/sources/#image)
final class ImageSource extends Source {
  ImageSource({
    required String id,
    String? url,
    List<List<double?>?>? coordinates,
    double? prefetchZoomDelta,
  }) : super(id: id) {
    _url = url;
    _coordinates = coordinates;
    _prefetchZoomDelta = prefetchZoomDelta;
  }

  @override
  String getType() => "image";

  String? _url;

  /// URL that points to an image. If the URL is not specified, the image is expected to be loaded directly during runtime.
  Future<String?> get url async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(id, "url")).value;
    if (raw == null) return null;
    return raw as String;
  }

  List<List<double?>?>? _coordinates;

  /// Corners of image specified in longitude, latitude pairs. Note: When using globe projection, the image will be centered at the North or South Pole in the respective hemisphere if the average latitude value exceeds 85 degrees or falls below -85 degrees.
  Future<List<List<double?>?>?> get coordinates async {
    final localStyle = style;
    if (localStyle == null) return null;
    final raw = (await localStyle.getStyleSourceProperty(
      id,
      "coordinates",
    )).value;
    if (raw == null) return null;
    return List<List<double>>.from(
      (raw as List<dynamic>).map((e) => List<double>.from(e as List<dynamic>)),
    );
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

  /// Updates the image of an image style source.
  ///
  /// See [https://docs.mapbox.com/mapbox-gl-js/style-spec/#sources-image](https://docs.mapbox.com/mapbox-gl-js/style-spec/#sources-image)
  Future<void>? updateImage(MbxImage image) {
    return style?.updateStyleImageSourceImage(id, image);
  }

  @override
  @internal
  String encode({required bool volatile}) {
    var properties = <String, dynamic>{};

    if (volatile) {
      if (_prefetchZoomDelta != null) {
        properties["prefetch-zoom-delta"] = _prefetchZoomDelta;
      }
    } else {
      properties["id"] = id;
      properties["type"] = getType();
      if (_url != null) {
        properties["url"] = _url;
      }
      if (_coordinates != null) {
        properties["coordinates"] = _coordinates;
      }
    }

    return json.encode(properties);
  }
}

// End of generated file.
