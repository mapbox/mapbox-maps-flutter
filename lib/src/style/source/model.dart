// This file is generated.
part of mapbox_maps_flutter;

/// Defines a single 3D model within a `ModelSource`.
/// @see [The online documentation](https://docs.mapbox.com/style-spec/reference/types#modelSourceModels)
class ModelSourceModel {
  ModelSourceModel({
    required this.id,
    this.featureProperties,
    this.materialOverrideNames,
    this.materialOverrides,
    this.nodeOverrideNames,
    this.nodeOverrides,
    this.orientation,
    this.position,
    this.uri,
  });

  /// The model's identifier.
  String id;

  /// An object defining custom properties of the model. Properties are accessible as feature properties in expressions.
  ///
  /// Arbitrary key/value data, not predefined override fields, for feeding a
  /// data-driven `ModelLayer` property. For example, add a `{"scale": [...]}`
  /// entry here and set `modelScaleExpression` to `["get", "scale"]` to give
  /// each model its own scale. Like [nodeOverrides] and [materialOverrides],
  /// it's fixed once set; use `MapboxMap.setFeatureState` for values that
  /// change often.
  Map<String, dynamic>? featureProperties;

  /// An array of one or more model material names whose properties will be overridden from model layer paint properties.
  ///
  /// Only declares which materials are addressable; it holds no values itself.
  /// Pair it with a data-driven `ModelLayer` property such as
  /// `modelColorExpression`, matching `["get", "part"]` to a
  /// `["feature-state", key]` per name, then call `MapboxMap.setFeatureState`
  /// (keyed by this model's own [id]) to supply values. Cheaper and
  /// mergeable, unlike resending [materialOverrides].
  List<String>? materialOverrideNames;

  /// A collection of material overrides.
  ///
  /// A fixed value baked into the model. Changing it means re-sending the
  /// whole `models` source property, so use this for a value that shouldn't
  /// change once set. For frequent or interactive updates, use
  /// [materialOverrideNames] with a data-driven `ModelLayer` property and
  /// `MapboxMap.setFeatureState`, which merges and is cheap to call often.
  List<ModelMaterialOverride>? materialOverrides;

  /// An array of one or more model node names whose transform will be overridden from model layer paint properties.
  ///
  /// Only declares which nodes are addressable; it holds no values itself.
  /// Pair it with a data-driven `ModelLayer` property such as
  /// `modelRotationExpression`, matching `["get", "part"]` to a
  /// `["feature-state", key]` per name, then call `MapboxMap.setFeatureState`
  /// (keyed by this model's own [id]) to supply values. Cheaper and
  /// mergeable, unlike resending [nodeOverrides].
  List<String>? nodeOverrideNames;

  /// A collection of node overrides.
  ///
  /// A fixed value baked into the model. Changing it means re-sending the
  /// whole `models` source property, so use this for a value that shouldn't
  /// change once set. For frequent or interactive updates, use
  /// [nodeOverrideNames] with a data-driven `ModelLayer` property and
  /// `MapboxMap.setFeatureState`, which merges and is cheap to call often.
  List<ModelNodeOverride>? nodeOverrides;

  /// Orientation of the model in euler angles [x, y, z].
  /// Default value: [0,0,0]. The unit of orientation is in degrees.
  List<double?>? orientation;

  /// Position of the model in longitude and latitude [lng, lat].
  /// Default value: [0,0]. Minimum value: [-180,-90]. Maximum value: [180,90].
  List<double?>? position;

  /// A URL to a model resource. Supported protocols are `http:`, `https:`, and `mapbox://<Model ID>`.
  String? uri;

  /// Converts this ModelSourceModel to its JSON representation, keyed by id.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (featureProperties != null) {
      json["featureProperties"] = featureProperties;
    }
    if (materialOverrideNames != null) {
      json["materialOverrideNames"] = materialOverrideNames;
    }
    if (materialOverrides != null) {
      json["materialOverrides"] = {
        for (final override in materialOverrides!)
          override.name: override.toJson()
      };
    }
    if (nodeOverrideNames != null) {
      json["nodeOverrideNames"] = nodeOverrideNames;
    }
    if (nodeOverrides != null) {
      json["nodeOverrides"] = {
        for (final override in nodeOverrides!) override.name: override.toJson()
      };
    }
    if (orientation != null) {
      json["orientation"] = orientation;
    }
    if (position != null) {
      json["position"] = position;
    }
    if (uri != null) {
      json["uri"] = uri;
    }
    return json;
  }

  /// Creates a ModelSourceModel from its id and a decoded JSON object.
  static ModelSourceModel fromJson(String id, Map<String, dynamic> json) {
    return ModelSourceModel(
      id: id,
      featureProperties:
          (json["featureProperties"] as Map?)?.cast<String, dynamic>(),
      materialOverrideNames: (json["materialOverrideNames"] as List?)?.cast(),
      materialOverrides: (json["materialOverrides"] as Map?)
          ?.entries
          .map((entry) => ModelMaterialOverride.fromJson(entry.key as String,
              Map<String, dynamic>.from(entry.value as Map)))
          .toList(),
      nodeOverrideNames: (json["nodeOverrideNames"] as List?)?.cast(),
      nodeOverrides: (json["nodeOverrides"] as Map?)
          ?.entries
          .map((entry) => ModelNodeOverride.fromJson(entry.key as String,
              Map<String, dynamic>.from(entry.value as Map)))
          .toList(),
      orientation: (json["orientation"] as List?)
          ?.map((e) => (e as num?)?.toDouble())
          .toList(),
      position: (json["position"] as List?)
          ?.map((e) => (e as num?)?.toDouble())
          .toList(),
      uri: json["uri"] as String?,
    );
  }
}

/// Overrides a material of a 3D model.
/// @see [The online documentation](https://docs.mapbox.com/style-spec/reference/types#modelMaterialOverrides)
class ModelMaterialOverride {
  ModelMaterialOverride({
    required this.name,
    this.modelColor,
    this.modelColorMixIntensity,
    this.modelEmissiveStrength,
    this.modelOpacity,
  });

  /// The material name to override.
  String name;

  /// Override the tint color of the material.
  int? modelColor;

  /// Override the intensity of model-color (on a scale from 0 to 1) in color mix with original 3D model's colors.
  double? modelColorMixIntensity;

  /// Override strength of the emission of material.
  /// The unit of modelEmissiveStrength is in intensity.
  double? modelEmissiveStrength;

  /// Override the opacity of the material.
  double? modelOpacity;

  /// Converts this ModelMaterialOverride to its JSON representation, keyed by name.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (modelColor != null) {
      json["model-color"] = modelColor?.toRGBA();
    }
    if (modelColorMixIntensity != null) {
      json["model-color-mix-intensity"] = modelColorMixIntensity;
    }
    if (modelEmissiveStrength != null) {
      json["model-emissive-strength"] = modelEmissiveStrength;
    }
    if (modelOpacity != null) {
      json["model-opacity"] = modelOpacity;
    }
    return json;
  }

  /// Creates a ModelMaterialOverride from its name and a decoded JSON object.
  static ModelMaterialOverride fromJson(
      String name, Map<String, dynamic> json) {
    return ModelMaterialOverride(
      name: name,
      modelColor: (json["model-color"] as String?)?.toRGBAInt(),
      modelColorMixIntensity: json["model-color-mix-intensity"] as double?,
      modelEmissiveStrength: json["model-emissive-strength"] as double?,
      modelOpacity: json["model-opacity"] as double?,
    );
  }
}

/// Overrides a node of a 3D model.
/// @see [The online documentation](https://docs.mapbox.com/style-spec/reference/types#modelNodeOverrides)
class ModelNodeOverride {
  ModelNodeOverride({
    required this.name,
    this.orientation,
  });

  /// The node name to override.
  String name;

  /// Override the orientation of the model node in euler angles [x, y, z].
  /// Default value: [0,0,0]. The unit of orientation is in degrees.
  List<double?>? orientation;

  /// Converts this ModelNodeOverride to its JSON representation, keyed by name.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (orientation != null) {
      json["orientation"] = orientation;
    }
    return json;
  }

  /// Creates a ModelNodeOverride from its name and a decoded JSON object.
  static ModelNodeOverride fromJson(String name, Map<String, dynamic> json) {
    return ModelNodeOverride(
      name: name,
      orientation: (json["orientation"] as List?)
          ?.map((e) => (e as num?)?.toDouble())
          .toList(),
    );
  }
}

// End of generated file.
