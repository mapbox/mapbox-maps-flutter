// This file is generated.
part of mapbox_maps_flutter;

/// Layer that removes 3D content from map.
@experimental
class ClipLayer extends Layer {
  ClipLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required String this.sourceId,
    String? this.sourceLayer,
    List<String?>? this.clipLayerScope,
    List<Object>? this.clipLayerScopeExpression,
    List<String?>? this.clipLayerTypes,
    List<Object>? this.clipLayerTypesExpression,
  }) : super(
            id: id,
            visibility: visibility,
            visibilityExpression: visibilityExpression,
            filter: filter,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "clip";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Removes content from layers with the specified scope. By default all layers are affected. For example specifying `basemap` will only remove content from the Mapbox Standard style layers which have the same scope
  /// Default value: [].
  @experimental
  List<String?>? clipLayerScope;

  /// Removes content from layers with the specified scope. By default all layers are affected. For example specifying `basemap` will only remove content from the Mapbox Standard style layers which have the same scope
  /// Default value: [].
  @experimental
  List<Object>? clipLayerScopeExpression;

  /// Layer types that will also be removed if fallen below this clip layer.
  /// Default value: [].
  @experimental
  List<String?>? clipLayerTypes;

  /// Layer types that will also be removed if fallen below this clip layer.
  /// Default value: [].
  @experimental
  List<Object>? clipLayerTypesExpression;

  @override
  Future<String> _encode() async {
    var layout = {};
    if (visibilityExpression != null) {
      layout["visibility"] = visibilityExpression!;
    }
    if (visibility != null) {
      layout["visibility"] =
          visibility!.name.toLowerCase().replaceAll("_", "-");
    }

    if (clipLayerScopeExpression != null) {
      layout["clip-layer-scope"] = clipLayerScopeExpression;
    }

    if (clipLayerScope != null) {
      layout["clip-layer-scope"] = clipLayerScope;
    }
    if (clipLayerTypesExpression != null) {
      layout["clip-layer-types"] = clipLayerTypesExpression;
    }

    if (clipLayerTypes != null) {
      layout["clip-layer-types"] = clipLayerTypes;
    }
    var paint = {};
    var properties = {
      "id": id,
      "source": sourceId,
      "type": getType(),
      "layout": layout,
      "paint": paint,
    };
    if (sourceLayer != null) {
      properties["source-layer"] = sourceLayer!;
    }
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

  static ClipLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return ClipLayer(
      id: map["id"],
      sourceId: map["source"],
      sourceLayer: map["source-layer"],
      minZoom: map["minzoom"]?.toDouble(),
      maxZoom: map["maxzoom"]?.toDouble(),
      slot: map["slot"],
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["visibility"])),
      visibilityExpression: _optionalCastList(map["layout"]["visibility"]),
      filter: _optionalCastList(map["filter"]),
      clipLayerScope: (map["layout"]["clip-layer-scope"] as List?)
          ?.map<String?>((e) => e.toString())
          .toList(),
      clipLayerScopeExpression:
          _optionalCastList(map["layout"]["clip-layer-scope"]),
      clipLayerTypes: (map["layout"]["clip-layer-types"] as List?)
          ?.map<String?>((e) => e.toString())
          .toList(),
      clipLayerTypesExpression:
          _optionalCastList(map["layout"]["clip-layer-types"]),
    );
  }
}

// End of generated file.
