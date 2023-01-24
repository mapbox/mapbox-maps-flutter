part of mapbox_maps_flutter;

class ModelLayer extends Layer {
  ModelLayer({
    required String id,
    required this.sourceId,
    this.modelId,
    this.visibility = Visibility.VISIBLE,
    this.modelType = ModelType.COMMON_3D,
    this.sourceLayer,
    this.opacity,
    this.color,
    this.translation,
    this.colorMixIntensity,
    this.scale,
    this.rotation,
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
  final int? color;

  /// ModelColorMixIntensity property
  final double? colorMixIntensity;

  /// The opacity of the model layer.
  final int? opacity;

  /// The rotation of the model in euler angles [lon, lat, z].
  final List<double>? rotation;

  /// The translation of the model in meters in form of [longitudal, latitudal, altitude] offsets.
  final List<double>? translation;

  /// The scale of the model.
  final List<double>? scale;

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

    if (color != null) {
      paint["model-color"] = color?.toRGBA();
    }
    if (opacity != null) {
      paint["model-opacity"] = opacity;
    }
    if (translation != null) {
      paint["model-translation"] = translation;
    }
    if (rotation != null) {
      paint['model-rotation'] = rotation;
    }
    if (scale != null) {
      paint['model-scale'] = scale;
    }
    if (colorMixIntensity != null) {
      paint['model-color-mix-intensity'] = colorMixIntensity;
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
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return ModelLayer(
      id: map['id'],
      sourceId: map['source'],
      modelId: map['layout']['model-id'],
      maxZoom: double.tryParse(map['maxzoom'].toString()),
      minZoom: double.tryParse(map['minzoom'].toString()),
    );
  }
}
