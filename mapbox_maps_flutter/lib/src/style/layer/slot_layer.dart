// This file is generated.
// ignore_for_file: unused_import
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../style_internal.dart';
import '../style_types.dart';
import 'layer.dart';

/// Marks the position of a slot.
final class SlotLayer extends Layer {
  SlotLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
    double? minZoom,
    double? maxZoom,
    String? slot,

    @Deprecated("This property has no effect on SlotLayer") String? sourceId,
    @Deprecated("This property has no effect on SlotLayer") String? sourceLayer,
  }) : super(
         id: id,
         visibility: visibility,
         visibilityExpression: visibilityExpression,
         filter: filter,
         maxZoom: maxZoom,
         minZoom: minZoom,
         slot: slot,
       );

  @override
  String getType() => "slot";

  /// The id of the source.
  @Deprecated("This property has no effect on SlotLayer")
  String get sourceId => "";

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  @Deprecated("This property has no effect on SlotLayer")
  String? sourceLayer;

  @override
  @internal
  Future<String> encode() async {
    var paint = {};
    var properties = {"id": id, "type": getType(), "paint": paint};
    if (minZoom != null) {
      properties["minzoom"] = minZoom!;
    }
    if (maxZoom != null) {
      properties["maxzoom"] = maxZoom!;
    }
    if (slot != null) {
      properties["slot"] = slot!;
    }
    if (filter != null) {
      properties["filter"] = filter!;
    }

    return json.encode(properties);
  }

  static SlotLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return SlotLayer(
      id: map["id"],
      minZoom: map["minzoom"]?.toDouble(),
      maxZoom: map["maxzoom"]?.toDouble(),
      slot: map["slot"],
      filter: styleOptionalCastList(map["filter"]),
    );
  }
}

// End of generated file.
