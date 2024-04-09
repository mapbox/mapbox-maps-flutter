// This file is generated.
part of mapbox_maps_flutter;

/// An extruded (3D) polygon.
class FillExtrusionLayer extends Layer {
  FillExtrusionLayer({
    required String id,
    Visibility? visibility,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required this.sourceId,
    this.sourceLayer,
    this.fillExtrusionEdgeRadius,
    this.fillExtrusionAmbientOcclusionGroundAttenuation,
    this.fillExtrusionAmbientOcclusionGroundRadius,
    this.fillExtrusionAmbientOcclusionIntensity,
    this.fillExtrusionAmbientOcclusionRadius,
    this.fillExtrusionAmbientOcclusionWallRadius,
    this.fillExtrusionBase,
    this.fillExtrusionColor,
    this.fillExtrusionCutoffFadeRange,
    this.fillExtrusionEmissiveStrength,
    this.fillExtrusionFloodLightColor,
    this.fillExtrusionFloodLightGroundAttenuation,
    this.fillExtrusionFloodLightGroundRadius,
    this.fillExtrusionFloodLightIntensity,
    this.fillExtrusionFloodLightWallRadius,
    this.fillExtrusionHeight,
    this.fillExtrusionOpacity,
    this.fillExtrusionPattern,
    this.fillExtrusionRoundedRoof,
    this.fillExtrusionTranslate,
    this.fillExtrusionTranslateAnchor,
    this.fillExtrusionVerticalGradient,
    this.fillExtrusionVerticalScale,
  }) : super(
            id: id,
            visibility: visibility,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "fill-extrusion";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Radius of a fill extrusion edge in meters. If not zero, rounds extrusion edges for a smoother appearance.
  double? fillExtrusionEdgeRadius;

  /// Provides a control to futher fine-tune the look of the ambient occlusion on the ground beneath the extruded buildings. Lower values give the effect a more solid look while higher values make it smoother.
  double? fillExtrusionAmbientOcclusionGroundAttenuation;

  /// The extent of the ambient occlusion effect on the ground beneath the extruded buildings in meters.
  double? fillExtrusionAmbientOcclusionGroundRadius;

  /// Controls the intensity of shading near ground and concave angles between walls. Default value 0.0 disables ambient occlusion and values around 0.3 provide the most plausible results for buildings.
  double? fillExtrusionAmbientOcclusionIntensity;

  /// Shades area near ground and concave angles between walls where the radius defines only vertical impact. Default value 3.0 corresponds to height of one floor and brings the most plausible results for buildings. This property works only with legacy light. When 3D lights are enabled `fill-extrusion-ambient-occlusion-wall-radius` and `fill-extrusion-ambient-occlusion-ground-radius` are used instead.
  double? fillExtrusionAmbientOcclusionRadius;

  /// Shades area near ground and concave angles between walls where the radius defines only vertical impact. Default value 3.0 corresponds to height of one floor and brings the most plausible results for buildings.
  double? fillExtrusionAmbientOcclusionWallRadius;

  /// The height with which to extrude the base of this layer. Must be less than or equal to `fill-extrusion-height`.
  double? fillExtrusionBase;

  /// The base color of the extruded fill. The extrusion's surfaces will be shaded differently based on this color in combination with the root `light` settings. If this color is specified as `rgba` with an alpha component, the alpha component will be ignored; use `fill-extrusion-opacity` to set layer opacity.
  int? fillExtrusionColor;

  /// This parameter defines the range for the fade-out effect before an automatic content cutoff on pitched map views. The automatic cutoff range is calculated according to the minimum required zoom level of the source and layer. The fade range is expressed in relation to the height of the map view. A value of 1.0 indicates that the content is faded to the same extent as the map's height in pixels, while a value close to zero represents a sharp cutoff. When the value is set to 0.0, the cutoff is completely disabled. Note: The property has no effect on the map if terrain is enabled.
  double? fillExtrusionCutoffFadeRange;

  /// Controls the intensity of light emitted on the source features.
  double? fillExtrusionEmissiveStrength;

  /// The color of the flood light effect on the walls of the extruded buildings.
  int? fillExtrusionFloodLightColor;

  /// Provides a control to futher fine-tune the look of the flood light on the ground beneath the extruded buildings. Lower values give the effect a more solid look while higher values make it smoother.
  double? fillExtrusionFloodLightGroundAttenuation;

  /// The extent of the flood light effect on the ground beneath the extruded buildings in meters.
  double? fillExtrusionFloodLightGroundRadius;

  /// The intensity of the flood light color.
  double? fillExtrusionFloodLightIntensity;

  /// The extent of the flood light effect on the walls of the extruded buildings in meters.
  double? fillExtrusionFloodLightWallRadius;

  /// The height with which to extrude this layer.
  double? fillExtrusionHeight;

  /// The opacity of the entire fill extrusion layer. This is rendered on a per-layer, not per-feature, basis, and data-driven styling is not available.
  double? fillExtrusionOpacity;

  /// Name of image in sprite to use for drawing images on extruded fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? fillExtrusionPattern;

  /// Indicates whether top edges should be rounded when fill-extrusion-edge-radius has a value greater than 0. If false, rounded edges are only applied to the sides. Default is true.
  bool? fillExtrusionRoundedRoof;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up (on the flat plane), respectively.
  List<double?>? fillExtrusionTranslate;

  /// Controls the frame of reference for `fill-extrusion-translate`.
  FillExtrusionTranslateAnchor? fillExtrusionTranslateAnchor;

  /// Whether to apply a vertical gradient to the sides of a fill-extrusion layer. If true, sides will be shaded slightly darker farther down.
  bool? fillExtrusionVerticalGradient;

  /// A global multiplier that can be used to scale base, height, AO, and flood light of the fill extrusions.
  double? fillExtrusionVerticalScale;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.name.toLowerCase().replaceAll("_", "-");
    }
    if (fillExtrusionEdgeRadius != null) {
      layout["fill-extrusion-edge-radius"] = fillExtrusionEdgeRadius;
    }
    var paint = {};
    if (fillExtrusionAmbientOcclusionGroundAttenuation != null) {
      paint["fill-extrusion-ambient-occlusion-ground-attenuation"] =
          fillExtrusionAmbientOcclusionGroundAttenuation;
    }
    if (fillExtrusionAmbientOcclusionGroundRadius != null) {
      paint["fill-extrusion-ambient-occlusion-ground-radius"] =
          fillExtrusionAmbientOcclusionGroundRadius;
    }
    if (fillExtrusionAmbientOcclusionIntensity != null) {
      paint["fill-extrusion-ambient-occlusion-intensity"] =
          fillExtrusionAmbientOcclusionIntensity;
    }
    if (fillExtrusionAmbientOcclusionRadius != null) {
      paint["fill-extrusion-ambient-occlusion-radius"] =
          fillExtrusionAmbientOcclusionRadius;
    }
    if (fillExtrusionAmbientOcclusionWallRadius != null) {
      paint["fill-extrusion-ambient-occlusion-wall-radius"] =
          fillExtrusionAmbientOcclusionWallRadius;
    }
    if (fillExtrusionBase != null) {
      paint["fill-extrusion-base"] = fillExtrusionBase;
    }
    if (fillExtrusionColor != null) {
      paint["fill-extrusion-color"] = fillExtrusionColor?.toRGBA();
    }
    if (fillExtrusionCutoffFadeRange != null) {
      paint["fill-extrusion-cutoff-fade-range"] = fillExtrusionCutoffFadeRange;
    }
    if (fillExtrusionEmissiveStrength != null) {
      paint["fill-extrusion-emissive-strength"] = fillExtrusionEmissiveStrength;
    }
    if (fillExtrusionFloodLightColor != null) {
      paint["fill-extrusion-flood-light-color"] =
          fillExtrusionFloodLightColor?.toRGBA();
    }
    if (fillExtrusionFloodLightGroundAttenuation != null) {
      paint["fill-extrusion-flood-light-ground-attenuation"] =
          fillExtrusionFloodLightGroundAttenuation;
    }
    if (fillExtrusionFloodLightGroundRadius != null) {
      paint["fill-extrusion-flood-light-ground-radius"] =
          fillExtrusionFloodLightGroundRadius;
    }
    if (fillExtrusionFloodLightIntensity != null) {
      paint["fill-extrusion-flood-light-intensity"] =
          fillExtrusionFloodLightIntensity;
    }
    if (fillExtrusionFloodLightWallRadius != null) {
      paint["fill-extrusion-flood-light-wall-radius"] =
          fillExtrusionFloodLightWallRadius;
    }
    if (fillExtrusionHeight != null) {
      paint["fill-extrusion-height"] = fillExtrusionHeight;
    }
    if (fillExtrusionOpacity != null) {
      paint["fill-extrusion-opacity"] = fillExtrusionOpacity;
    }
    if (fillExtrusionPattern != null) {
      paint["fill-extrusion-pattern"] = fillExtrusionPattern;
    }
    if (fillExtrusionRoundedRoof != null) {
      paint["fill-extrusion-rounded-roof"] = fillExtrusionRoundedRoof;
    }
    if (fillExtrusionTranslate != null) {
      paint["fill-extrusion-translate"] = fillExtrusionTranslate;
    }
    if (fillExtrusionTranslateAnchor != null) {
      paint["fill-extrusion-translate-anchor"] =
          fillExtrusionTranslateAnchor?.name.toLowerCase().replaceAll("_", "-");
    }
    if (fillExtrusionVerticalGradient != null) {
      paint["fill-extrusion-vertical-gradient"] = fillExtrusionVerticalGradient;
    }
    if (fillExtrusionVerticalScale != null) {
      paint["fill-extrusion-vertical-scale"] = fillExtrusionVerticalScale;
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

  static FillExtrusionLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return FillExtrusionLayer(
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
      fillExtrusionEdgeRadius: map["layout"]["fill-extrusion-edge-radius"]
              is num?
          ? (map["layout"]["fill-extrusion-edge-radius"] as num?)?.toDouble()
          : null,
      fillExtrusionAmbientOcclusionGroundAttenuation: map["paint"]
              ["fill-extrusion-ambient-occlusion-ground-attenuation"] is num?
          ? (map["paint"]["fill-extrusion-ambient-occlusion-ground-attenuation"]
                  as num?)
              ?.toDouble()
          : null,
      fillExtrusionAmbientOcclusionGroundRadius:
          map["paint"]["fill-extrusion-ambient-occlusion-ground-radius"] is num?
              ? (map["paint"]["fill-extrusion-ambient-occlusion-ground-radius"]
                      as num?)
                  ?.toDouble()
              : null,
      fillExtrusionAmbientOcclusionIntensity: map["paint"]
              ["fill-extrusion-ambient-occlusion-intensity"] is num?
          ? (map["paint"]["fill-extrusion-ambient-occlusion-intensity"] as num?)
              ?.toDouble()
          : null,
      fillExtrusionAmbientOcclusionRadius: map["paint"]
              ["fill-extrusion-ambient-occlusion-radius"] is num?
          ? (map["paint"]["fill-extrusion-ambient-occlusion-radius"] as num?)
              ?.toDouble()
          : null,
      fillExtrusionAmbientOcclusionWallRadius:
          map["paint"]["fill-extrusion-ambient-occlusion-wall-radius"] is num?
              ? (map["paint"]["fill-extrusion-ambient-occlusion-wall-radius"]
                      as num?)
                  ?.toDouble()
              : null,
      fillExtrusionBase: map["paint"]["fill-extrusion-base"] is num?
          ? (map["paint"]["fill-extrusion-base"] as num?)?.toDouble()
          : null,
      fillExtrusionColor:
          (map["paint"]["fill-extrusion-color"] as List?)?.toRGBAInt(),
      fillExtrusionCutoffFadeRange:
          map["paint"]["fill-extrusion-cutoff-fade-range"] is num?
              ? (map["paint"]["fill-extrusion-cutoff-fade-range"] as num?)
                  ?.toDouble()
              : null,
      fillExtrusionEmissiveStrength:
          map["paint"]["fill-extrusion-emissive-strength"] is num?
              ? (map["paint"]["fill-extrusion-emissive-strength"] as num?)
                  ?.toDouble()
              : null,
      fillExtrusionFloodLightColor:
          (map["paint"]["fill-extrusion-flood-light-color"] as List?)
              ?.toRGBAInt(),
      fillExtrusionFloodLightGroundAttenuation:
          map["paint"]["fill-extrusion-flood-light-ground-attenuation"] is num?
              ? (map["paint"]["fill-extrusion-flood-light-ground-attenuation"]
                      as num?)
                  ?.toDouble()
              : null,
      fillExtrusionFloodLightGroundRadius: map["paint"]
              ["fill-extrusion-flood-light-ground-radius"] is num?
          ? (map["paint"]["fill-extrusion-flood-light-ground-radius"] as num?)
              ?.toDouble()
          : null,
      fillExtrusionFloodLightIntensity:
          map["paint"]["fill-extrusion-flood-light-intensity"] is num?
              ? (map["paint"]["fill-extrusion-flood-light-intensity"] as num?)
                  ?.toDouble()
              : null,
      fillExtrusionFloodLightWallRadius:
          map["paint"]["fill-extrusion-flood-light-wall-radius"] is num?
              ? (map["paint"]["fill-extrusion-flood-light-wall-radius"] as num?)
                  ?.toDouble()
              : null,
      fillExtrusionHeight: map["paint"]["fill-extrusion-height"] is num?
          ? (map["paint"]["fill-extrusion-height"] as num?)?.toDouble()
          : null,
      fillExtrusionOpacity: map["paint"]["fill-extrusion-opacity"] is num?
          ? (map["paint"]["fill-extrusion-opacity"] as num?)?.toDouble()
          : null,
      fillExtrusionPattern: map["paint"]["fill-extrusion-pattern"] is String?
          ? map["paint"]["fill-extrusion-pattern"] as String?
          : null,
      fillExtrusionRoundedRoof:
          map["paint"]["fill-extrusion-rounded-roof"] is bool?
              ? map["paint"]["fill-extrusion-rounded-roof"] as bool?
              : null,
      fillExtrusionTranslate:
          (map["paint"]["fill-extrusion-translate"] as List?)
              ?.map<double?>((e) => e.toDouble())
              .toList(),
      fillExtrusionTranslateAnchor:
          map["paint"]["fill-extrusion-translate-anchor"] == null
              ? null
              : FillExtrusionTranslateAnchor.values.firstWhere((e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["paint"]["fill-extrusion-translate-anchor"])),
      fillExtrusionVerticalGradient:
          map["paint"]["fill-extrusion-vertical-gradient"] is bool?
              ? map["paint"]["fill-extrusion-vertical-gradient"] as bool?
              : null,
      fillExtrusionVerticalScale: map["paint"]["fill-extrusion-vertical-scale"]
              is num?
          ? (map["paint"]["fill-extrusion-vertical-scale"] as num?)?.toDouble()
          : null,
    );
  }
}

// End of generated file.
