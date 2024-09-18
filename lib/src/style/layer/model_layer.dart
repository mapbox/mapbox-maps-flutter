// This file is generated.
part of mapbox_maps_flutter;

/// A layer to render 3D Models.
@experimental
class ModelLayer extends Layer {
  ModelLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required String this.sourceId,
    String? this.sourceLayer,
    String? this.modelId,
    List<Object>? this.modelIdExpression,
    double? this.modelAmbientOcclusionIntensity,
    List<Object>? this.modelAmbientOcclusionIntensityExpression,
    bool? this.modelCastShadows,
    List<Object>? this.modelCastShadowsExpression,
    int? this.modelColor,
    List<Object>? this.modelColorExpression,
    double? this.modelColorMixIntensity,
    List<Object>? this.modelColorMixIntensityExpression,
    double? this.modelCutoffFadeRange,
    List<Object>? this.modelCutoffFadeRangeExpression,
    double? this.modelEmissiveStrength,
    List<Object>? this.modelEmissiveStrengthExpression,
    List<double?>? this.modelHeightBasedEmissiveStrengthMultiplier,
    List<Object>? this.modelHeightBasedEmissiveStrengthMultiplierExpression,
    double? this.modelOpacity,
    List<Object>? this.modelOpacityExpression,
    bool? this.modelReceiveShadows,
    List<Object>? this.modelReceiveShadowsExpression,
    List<double?>? this.modelRotation,
    List<Object>? this.modelRotationExpression,
    double? this.modelRoughness,
    List<Object>? this.modelRoughnessExpression,
    List<double?>? this.modelScale,
    List<Object>? this.modelScaleExpression,
    ModelScaleMode? this.modelScaleMode,
    List<Object>? this.modelScaleModeExpression,
    List<double?>? this.modelTranslation,
    List<Object>? this.modelTranslationExpression,
    ModelType? this.modelType,
    List<Object>? this.modelTypeExpression,
  }) : super(
            id: id,
            visibility: visibility,
            visibilityExpression: visibilityExpression,
            filter: filter,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "model";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Model to render. It can be either a string referencing an element to the models root property or an internal or external URL
  /// Default value: "".
  @experimental
  String? modelId;

  /// Model to render. It can be either a string referencing an element to the models root property or an internal or external URL
  /// Default value: "".
  @experimental
  List<Object>? modelIdExpression;

  /// Intensity of the ambient occlusion if present in the 3D model.
  /// Default value: 1. Value range: [0, 1]
  @experimental
  double? modelAmbientOcclusionIntensity;

  /// Intensity of the ambient occlusion if present in the 3D model.
  /// Default value: 1. Value range: [0, 1]
  @experimental
  List<Object>? modelAmbientOcclusionIntensityExpression;

  /// Enable/Disable shadow casting for this layer
  /// Default value: true.
  @experimental
  bool? modelCastShadows;

  /// Enable/Disable shadow casting for this layer
  /// Default value: true.
  @experimental
  List<Object>? modelCastShadowsExpression;

  /// The tint color of the model layer. model-color-mix-intensity (defaults to 0) defines tint(mix) intensity - this means that, this color is not used unless model-color-mix-intensity gets value greater than 0.
  /// Default value: "#ffffff".
  @experimental
  int? modelColor;

  /// The tint color of the model layer. model-color-mix-intensity (defaults to 0) defines tint(mix) intensity - this means that, this color is not used unless model-color-mix-intensity gets value greater than 0.
  /// Default value: "#ffffff".
  @experimental
  List<Object>? modelColorExpression;

  /// Intensity of model-color (on a scale from 0 to 1) in color mix with original 3D model's colors. Higher number will present a higher model-color contribution in mix.
  /// Default value: 0. Value range: [0, 1]
  @experimental
  double? modelColorMixIntensity;

  /// Intensity of model-color (on a scale from 0 to 1) in color mix with original 3D model's colors. Higher number will present a higher model-color contribution in mix.
  /// Default value: 0. Value range: [0, 1]
  @experimental
  List<Object>? modelColorMixIntensityExpression;

  /// This parameter defines the range for the fade-out effect before an automatic content cutoff  on pitched map views. The automatic cutoff range is calculated according to the minimum required zoom level of the source and layer. The fade range is expressed in relation to the height of the map view. A value of 1.0 indicates that the content is faded to the same extent as the map's height in pixels, while a value close to zero represents a sharp cutoff. When the value is set to 0.0, the cutoff is completely disabled. Note: The property has no effect on the map if terrain is enabled.
  /// Default value: 0. Value range: [0, 1]
  @experimental
  double? modelCutoffFadeRange;

  /// This parameter defines the range for the fade-out effect before an automatic content cutoff  on pitched map views. The automatic cutoff range is calculated according to the minimum required zoom level of the source and layer. The fade range is expressed in relation to the height of the map view. A value of 1.0 indicates that the content is faded to the same extent as the map's height in pixels, while a value close to zero represents a sharp cutoff. When the value is set to 0.0, the cutoff is completely disabled. Note: The property has no effect on the map if terrain is enabled.
  /// Default value: 0. Value range: [0, 1]
  @experimental
  List<Object>? modelCutoffFadeRangeExpression;

  /// Strength of the emission. There is no emission for value 0. For value 1.0, only emissive component (no shading) is displayed and values above 1.0 produce light contribution to surrounding area, for some of the parts (e.g. doors). Expressions that depend on measure-light are not supported when using GeoJSON or vector tile as the model layer source.
  /// Default value: 0. Value range: [0, 5]
  @experimental
  double? modelEmissiveStrength;

  /// Strength of the emission. There is no emission for value 0. For value 1.0, only emissive component (no shading) is displayed and values above 1.0 produce light contribution to surrounding area, for some of the parts (e.g. doors). Expressions that depend on measure-light are not supported when using GeoJSON or vector tile as the model layer source.
  /// Default value: 0. Value range: [0, 5]
  @experimental
  List<Object>? modelEmissiveStrengthExpression;

  /// Emissive strength multiplier along model height (gradient begin, gradient end, value at begin, value at end, gradient curve power (logarithmic scale, curve power = pow(10, val)).
  /// Default value: [1,1,1,1,0].
  @experimental
  List<double?>? modelHeightBasedEmissiveStrengthMultiplier;

  /// Emissive strength multiplier along model height (gradient begin, gradient end, value at begin, value at end, gradient curve power (logarithmic scale, curve power = pow(10, val)).
  /// Default value: [1,1,1,1,0].
  @experimental
  List<Object>? modelHeightBasedEmissiveStrengthMultiplierExpression;

  /// The opacity of the model layer.
  /// Default value: 1. Value range: [0, 1]
  @experimental
  double? modelOpacity;

  /// The opacity of the model layer.
  /// Default value: 1. Value range: [0, 1]
  @experimental
  List<Object>? modelOpacityExpression;

  /// Enable/Disable shadow receiving for this layer
  /// Default value: true.
  @experimental
  bool? modelReceiveShadows;

  /// Enable/Disable shadow receiving for this layer
  /// Default value: true.
  @experimental
  List<Object>? modelReceiveShadowsExpression;

  /// The rotation of the model in euler angles [lon, lat, z].
  /// Default value: [0,0,0].
  @experimental
  List<double?>? modelRotation;

  /// The rotation of the model in euler angles [lon, lat, z].
  /// Default value: [0,0,0].
  @experimental
  List<Object>? modelRotationExpression;

  /// Material roughness. Material is fully smooth for value 0, and fully rough for value 1. Affects only layers using batched-model source.
  /// Default value: 1. Value range: [0, 1]
  @experimental
  double? modelRoughness;

  /// Material roughness. Material is fully smooth for value 0, and fully rough for value 1. Affects only layers using batched-model source.
  /// Default value: 1. Value range: [0, 1]
  @experimental
  List<Object>? modelRoughnessExpression;

  /// The scale of the model.
  /// Default value: [1,1,1].
  @experimental
  List<double?>? modelScale;

  /// The scale of the model.
  /// Default value: [1,1,1].
  @experimental
  List<Object>? modelScaleExpression;

  /// Defines scaling mode. Only applies to location-indicator type layers.
  /// Default value: "map".
  @experimental
  ModelScaleMode? modelScaleMode;

  /// Defines scaling mode. Only applies to location-indicator type layers.
  /// Default value: "map".
  @experimental
  List<Object>? modelScaleModeExpression;

  /// The translation of the model in meters in form of [longitudal, latitudal, altitude] offsets.
  /// Default value: [0,0,0].
  @experimental
  List<double?>? modelTranslation;

  /// The translation of the model in meters in form of [longitudal, latitudal, altitude] offsets.
  /// Default value: [0,0,0].
  @experimental
  List<Object>? modelTranslationExpression;

  /// Defines rendering behavior of model in respect to other 3D scene objects.
  /// Default value: "common-3d".
  @experimental
  ModelType? modelType;

  /// Defines rendering behavior of model in respect to other 3D scene objects.
  /// Default value: "common-3d".
  @experimental
  List<Object>? modelTypeExpression;

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

    if (modelIdExpression != null) {
      layout["model-id"] = modelIdExpression;
    }

    if (modelId != null) {
      layout["model-id"] =
          await MapboxMapsOptions._getFlutterAssetPath(modelId);
    }
    var paint = {};
    if (modelAmbientOcclusionIntensityExpression != null) {
      paint["model-ambient-occlusion-intensity"] =
          modelAmbientOcclusionIntensityExpression;
    }
    if (modelAmbientOcclusionIntensity != null) {
      paint["model-ambient-occlusion-intensity"] =
          modelAmbientOcclusionIntensity;
    }

    if (modelCastShadowsExpression != null) {
      paint["model-cast-shadows"] = modelCastShadowsExpression;
    }
    if (modelCastShadows != null) {
      paint["model-cast-shadows"] = modelCastShadows;
    }

    if (modelColorExpression != null) {
      paint["model-color"] = modelColorExpression;
    }
    if (modelColor != null) {
      paint["model-color"] = modelColor?.toRGBA();
    }

    if (modelColorMixIntensityExpression != null) {
      paint["model-color-mix-intensity"] = modelColorMixIntensityExpression;
    }
    if (modelColorMixIntensity != null) {
      paint["model-color-mix-intensity"] = modelColorMixIntensity;
    }

    if (modelCutoffFadeRangeExpression != null) {
      paint["model-cutoff-fade-range"] = modelCutoffFadeRangeExpression;
    }
    if (modelCutoffFadeRange != null) {
      paint["model-cutoff-fade-range"] = modelCutoffFadeRange;
    }

    if (modelEmissiveStrengthExpression != null) {
      paint["model-emissive-strength"] = modelEmissiveStrengthExpression;
    }
    if (modelEmissiveStrength != null) {
      paint["model-emissive-strength"] = modelEmissiveStrength;
    }

    if (modelHeightBasedEmissiveStrengthMultiplierExpression != null) {
      paint["model-height-based-emissive-strength-multiplier"] =
          modelHeightBasedEmissiveStrengthMultiplierExpression;
    }
    if (modelHeightBasedEmissiveStrengthMultiplier != null) {
      paint["model-height-based-emissive-strength-multiplier"] =
          modelHeightBasedEmissiveStrengthMultiplier;
    }

    if (modelOpacityExpression != null) {
      paint["model-opacity"] = modelOpacityExpression;
    }
    if (modelOpacity != null) {
      paint["model-opacity"] = modelOpacity;
    }

    if (modelReceiveShadowsExpression != null) {
      paint["model-receive-shadows"] = modelReceiveShadowsExpression;
    }
    if (modelReceiveShadows != null) {
      paint["model-receive-shadows"] = modelReceiveShadows;
    }

    if (modelRotationExpression != null) {
      paint["model-rotation"] = modelRotationExpression;
    }
    if (modelRotation != null) {
      paint["model-rotation"] = modelRotation;
    }

    if (modelRoughnessExpression != null) {
      paint["model-roughness"] = modelRoughnessExpression;
    }
    if (modelRoughness != null) {
      paint["model-roughness"] = modelRoughness;
    }

    if (modelScaleExpression != null) {
      paint["model-scale"] = modelScaleExpression;
    }
    if (modelScale != null) {
      paint["model-scale"] = modelScale;
    }

    if (modelScaleModeExpression != null) {
      paint["model-scale-mode"] = modelScaleModeExpression;
    }
    if (modelScaleMode != null) {
      paint["model-scale-mode"] =
          modelScaleMode?.name.toLowerCase().replaceAll("_", "-");
    }

    if (modelTranslationExpression != null) {
      paint["model-translation"] = modelTranslationExpression;
    }
    if (modelTranslation != null) {
      paint["model-translation"] = modelTranslation;
    }

    if (modelTypeExpression != null) {
      paint["model-type"] = modelTypeExpression;
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
    if (filter != null) {
      properties["filter"] = filter!;
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
      visibilityExpression: _optionalCastList(map["layout"]["visibility"]),
      filter: _optionalCastList(map["filter"]),
      modelId: _optionalCast(map["layout"]["model-id"]),
      modelIdExpression: _optionalCastList(map["layout"]["model-id"]),
      modelAmbientOcclusionIntensity:
          _optionalCast(map["paint"]["model-ambient-occlusion-intensity"]),
      modelAmbientOcclusionIntensityExpression:
          _optionalCastList(map["paint"]["model-ambient-occlusion-intensity"]),
      modelCastShadows: _optionalCast(map["paint"]["model-cast-shadows"]),
      modelCastShadowsExpression:
          _optionalCastList(map["paint"]["model-cast-shadows"]),
      modelColor: (map["paint"]["model-color"] as List?)?.toRGBAInt(),
      modelColorExpression: _optionalCastList(map["paint"]["model-color"]),
      modelColorMixIntensity:
          _optionalCast(map["paint"]["model-color-mix-intensity"]),
      modelColorMixIntensityExpression:
          _optionalCastList(map["paint"]["model-color-mix-intensity"]),
      modelCutoffFadeRange:
          _optionalCast(map["paint"]["model-cutoff-fade-range"]),
      modelCutoffFadeRangeExpression:
          _optionalCastList(map["paint"]["model-cutoff-fade-range"]),
      modelEmissiveStrength:
          _optionalCast(map["paint"]["model-emissive-strength"]),
      modelEmissiveStrengthExpression:
          _optionalCastList(map["paint"]["model-emissive-strength"]),
      modelHeightBasedEmissiveStrengthMultiplier: (map["paint"]
              ["model-height-based-emissive-strength-multiplier"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      modelHeightBasedEmissiveStrengthMultiplierExpression: _optionalCastList(
          map["paint"]["model-height-based-emissive-strength-multiplier"]),
      modelOpacity: _optionalCast(map["paint"]["model-opacity"]),
      modelOpacityExpression: _optionalCastList(map["paint"]["model-opacity"]),
      modelReceiveShadows: _optionalCast(map["paint"]["model-receive-shadows"]),
      modelReceiveShadowsExpression:
          _optionalCastList(map["paint"]["model-receive-shadows"]),
      modelRotation: (map["paint"]["model-rotation"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      modelRotationExpression:
          _optionalCastList(map["paint"]["model-rotation"]),
      modelRoughness: _optionalCast(map["paint"]["model-roughness"]),
      modelRoughnessExpression:
          _optionalCastList(map["paint"]["model-roughness"]),
      modelScale: (map["paint"]["model-scale"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      modelScaleExpression: _optionalCastList(map["paint"]["model-scale"]),
      modelScaleMode: map["paint"]["model-scale-mode"] == null
          ? null
          : ModelScaleMode.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["model-scale-mode"])),
      modelScaleModeExpression:
          _optionalCastList(map["paint"]["model-scale-mode"]),
      modelTranslation: (map["paint"]["model-translation"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      modelTranslationExpression:
          _optionalCastList(map["paint"]["model-translation"]),
      modelType: map["paint"]["model-type"] == null
          ? null
          : ModelType.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["model-type"])),
      modelTypeExpression: _optionalCastList(map["paint"]["model-type"]),
    );
  }
}

// End of generated file.
