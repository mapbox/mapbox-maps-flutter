part of mapbox_maps_flutter;

class ModelLayer extends Layer {
  ModelLayer({
    required String id,
    required this.sourceId,
             this.modelId,
             this.visibility = Visibility.VISIBLE,
             this.modelType = ModelType.COMMON_3D,
             this.sourceLayer,
             this.modelOpacity,
             this.modelColor,
             this.modelTranslation,
             this.modelColorMixIntensity,
             this.modelScale,
             this.modelRotation,
             this.minZoom,
             this.maxZoom,
  }) : super(id: id);

  /// The id of the source.
  final String sourceId;

  /// Model to render.
  final String? modelId;

  /// A source layer is an individual layer of data within a vector source.
  /// A vector source can have multiple source layers.
  final String? sourceLayer;

  ///  Whether this layer is displayed.
  final Visibility? visibility;

  /// The minimum zoom level for the layer. At zoom levels less than the minzoom, the layer will be hidden.
  final double? minZoom;

  ///  The maximum zoom level for the layer. At zoom levels equal to or greater than the maxzoom, the layer will be hidden.
  final double? maxZoom;

  /// The tint color of the model layer
  final int? modelColor;

  /// ModelColorMixIntensity property
  final double? modelColorMixIntensity;

  /// The opacity of the model layer.
  final double? modelOpacity;

  /// The rotation of the model in euler angles [lon, lat, z].
  final List<double?>? modelRotation;

  /// The translation of the model in meters in form of [longitudal, latitudal, altitude] offsets.
  final List<double?>? modelTranslation;

  /// The scale of the model.
  final List<double?>? modelScale;

  ///  Defines rendering behavior of model in respect to other 3D scene objects.
  final ModelType? modelType;

  @override
  String getType() => "model";

  @override
  String _encode() {
    var layout = {};

    if (visibility != null) {
      layout["visibility"] =
          visibility?.toString().split('.').last.toLowerCase();
    }
    if (modelId != null) {
      layout["model-id"] = modelId;
    }

    var paint = {};

    if (modelColor != null) {
      paint["model-color"] = modelColor?.toRGBA();
    }
    if (modelOpacity != null) {
      paint["model-opacity"] = modelOpacity;
    }
    if (modelTranslation != null) {
      paint["model-translation"] = modelTranslation;
    }
    if (modelRotation != null) {
      paint['model-rotation'] = modelRotation;
    }
    if (modelScale != null) {
      paint['model-scale'] = modelScale;
    }
    if (modelColorMixIntensity != null) {
      paint['model-color-mix-intensity'] = modelColorMixIntensity;
    }

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
    return json.encode(properties);
  }

  static Layer? decode(String properties) {
    var map = json.decode(properties);

    return ModelLayer(
      id: map['id'],
      modelType: ModelType.COMMON_3D,
      sourceId: map['source'],
      modelId: map['layout']['model-id'],
      maxZoom: double.tryParse(map['maxzoom'].toString()),
      minZoom: double.tryParse(map['minzoom'].toString()),
      modelRotation: (map["paint"]["model-rotation"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      modelTranslation: (map["paint"]["model-translation"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      modelScale: (map["paint"]["model-scale"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      modelColorMixIntensity: map["paint"]["model-color-mix-intensity"] is num?
          ? (map["paint"]["model-color-mix-intensity"] as num?)?.toDouble()
          : null,
      modelColor: (map["paint"]["model-color"] as List?)?.toRGBAInt(),
      modelOpacity: map["paint"]["model-opacity"] is num?
          ? (map["paint"]["model-opacity"] as num?)?.toDouble()
          : null,
    );
  }
}
