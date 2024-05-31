// This file is generated.
part of mapbox_maps_flutter;

/// A layer to render 3D Models.
class ModelLayer extends Layer {
  ModelLayer({
    required String id,
    Visibility? visibility,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required this.sourceId,
    this.sourceLayer,
    this.modelId,
    this.modelAmbientOcclusionIntensity,
    this.modelCastShadows,
    this.modelColor,
    this.modelColorMixIntensity,
    this.modelCutoffFadeRange,
    this.modelEmissiveStrength,
    this.modelHeightBasedEmissiveStrengthMultiplier,
    this.modelOpacity,
    this.modelReceiveShadows,
    this.modelRotation,
    this.modelRoughness,
    this.modelScale,
    this.modelScaleMode,
    this.modelTranslation,
    this.modelType,
  }) : super(
            id: id,
            visibility: visibility,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "model";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Model to render.
  String? modelId;

  /// Intensity of the ambient occlusion if present in the 3D model.
  double? modelAmbientOcclusionIntensity;

  /// Enable/Disable shadow casting for this layer
  bool? modelCastShadows;

  /// The tint color of the model layer. model-color-mix-intensity (defaults to 0) defines tint(mix) intensity - this means that, this color is not used unless model-color-mix-intensity gets value greater than 0.
  int? modelColor;

  /// Intensity of model-color (on a scale from 0 to 1) in color mix with original 3D model's colors. Higher number will present a higher model-color contribution in mix.
  double? modelColorMixIntensity;

  /// This parameter defines the range for the fade-out effect before an automatic content cutoff  on pitched map views. The automatic cutoff range is calculated according to the minimum required zoom level of the source and layer. The fade range is expressed in relation to the height of the map view. A value of 1.0 indicates that the content is faded to the same extent as the map's height in pixels, while a value close to zero represents a sharp cutoff. When the value is set to 0.0, the cutoff is completely disabled. Note: The property has no effect on the map if terrain is enabled.
  double? modelCutoffFadeRange;

  /// Strength of the emission. There is no emission for value 0. For value 1.0, only emissive component (no shading) is displayed and values above 1.0 produce light contribution to surrounding area, for some of the parts (e.g. doors). Expressions that depend on measure-light are not supported when using GeoJSON or vector tile as the model layer source.
  double? modelEmissiveStrength;

  /// Emissive strength multiplier along model height (gradient begin, gradient end, value at begin, value at end, gradient curve power (logarithmic scale, curve power = pow(10, val)).
  List<double?>? modelHeightBasedEmissiveStrengthMultiplier;

  /// The opacity of the model layer.
  double? modelOpacity;

  /// Enable/Disable shadow receiving for this layer
  bool? modelReceiveShadows;

  /// The rotation of the model in euler angles [lon, lat, z].
  List<double?>? modelRotation;

  /// Material roughness. Material is fully smooth for value 0, and fully rough for value 1. Affects only layers using batched-model source.
  double? modelRoughness;

  /// The scale of the model.
  List<double?>? modelScale;

  /// Defines scaling mode. Only applies to location-indicator type layers.
  ModelScaleMode? modelScaleMode;

  /// The translation of the model in meters in form of [longitudal, latitudal, altitude] offsets.
  List<double?>? modelTranslation;

  /// Defines rendering behavior of model in respect to other 3D scene objects.
  ModelType? modelType;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.name.toLowerCase().replaceAll("_", "-");
    }
    if (modelId != null) {
      layout["model-id"] = modelId;
    }
    var paint = {};
    if (modelAmbientOcclusionIntensity != null) {
      paint["model-ambient-occlusion-intensity"] =
          modelAmbientOcclusionIntensity;
    }
    if (modelCastShadows != null) {
      paint["model-cast-shadows"] = modelCastShadows;
    }
    if (modelColor != null) {
      paint["model-color"] = modelColor?.toRGBA();
    }
    if (modelColorMixIntensity != null) {
      paint["model-color-mix-intensity"] = modelColorMixIntensity;
    }
    if (modelCutoffFadeRange != null) {
      paint["model-cutoff-fade-range"] = modelCutoffFadeRange;
    }
    if (modelEmissiveStrength != null) {
      paint["model-emissive-strength"] = modelEmissiveStrength;
    }
    if (modelHeightBasedEmissiveStrengthMultiplier != null) {
      paint["model-height-based-emissive-strength-multiplier"] =
          modelHeightBasedEmissiveStrengthMultiplier;
    }
    if (modelOpacity != null) {
      paint["model-opacity"] = modelOpacity;
    }
    if (modelReceiveShadows != null) {
      paint["model-receive-shadows"] = modelReceiveShadows;
    }
    if (modelRotation != null) {
      paint["model-rotation"] = modelRotation;
    }
    if (modelRoughness != null) {
      paint["model-roughness"] = modelRoughness;
    }
    if (modelScale != null) {
      paint["model-scale"] = modelScale;
    }
    if (modelScaleMode != null) {
      paint["model-scale-mode"] =
          modelScaleMode?.name.toLowerCase().replaceAll("_", "-");
    }
    if (modelTranslation != null) {
      paint["model-translation"] = modelTranslation;
    }
    if (modelType != null) {
      paint["model-type"] = modelType?.name.toLowerCase().replaceAll("_", "-");
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
    if (slot != null) {
      properties["slot"] = slot!;
    }

    return json.encode(properties);
  }

  static ModelLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return ModelLayer(
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
      modelId: map["layout"]["model-id"] is String?
          ? map["layout"]["model-id"] as String?
          : null,
      modelAmbientOcclusionIntensity:
          map["paint"]["model-ambient-occlusion-intensity"] is num?
              ? (map["paint"]["model-ambient-occlusion-intensity"] as num?)
                  ?.toDouble()
              : null,
      modelCastShadows: map["paint"]["model-cast-shadows"] is bool?
          ? map["paint"]["model-cast-shadows"] as bool?
          : null,
      modelColor: (map["paint"]["model-color"] as List?)?.toRGBAInt(),
      modelColorMixIntensity: map["paint"]["model-color-mix-intensity"] is num?
          ? (map["paint"]["model-color-mix-intensity"] as num?)?.toDouble()
          : null,
      modelCutoffFadeRange: map["paint"]["model-cutoff-fade-range"] is num?
          ? (map["paint"]["model-cutoff-fade-range"] as num?)?.toDouble()
          : null,
      modelEmissiveStrength: map["paint"]["model-emissive-strength"] is num?
          ? (map["paint"]["model-emissive-strength"] as num?)?.toDouble()
          : null,
      modelHeightBasedEmissiveStrengthMultiplier: (map["paint"]
              ["model-height-based-emissive-strength-multiplier"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      modelOpacity: map["paint"]["model-opacity"] is num?
          ? (map["paint"]["model-opacity"] as num?)?.toDouble()
          : null,
      modelReceiveShadows: map["paint"]["model-receive-shadows"] is bool?
          ? map["paint"]["model-receive-shadows"] as bool?
          : null,
      modelRotation: (map["paint"]["model-rotation"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      modelRoughness: map["paint"]["model-roughness"] is num?
          ? (map["paint"]["model-roughness"] as num?)?.toDouble()
          : null,
      modelScale: (map["paint"]["model-scale"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      modelScaleMode: map["paint"]["model-scale-mode"] == null
          ? null
          : ModelScaleMode.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["model-scale-mode"])),
      modelTranslation: (map["paint"]["model-translation"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      modelType: map["paint"]["model-type"] == null
          ? null
          : ModelType.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["model-type"])),
    );
  }
}

// End of generated file.
