// This file is generated.
// ignore_for_file: unused_import
import 'dart:convert';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../style_internal.dart';
import '../style_types.dart';
import 'layer.dart';

/// An extruded (3D) polygon.
final class FillExtrusionLayer extends Layer {
  FillExtrusionLayer({
    required super.id,
    super.visibility,
    super.visibilityExpression,
    super.filter,
    super.minZoom,
    super.maxZoom,
    super.slot,
    required this.sourceId,
    this.sourceLayer,

    this.fillExtrusionEdgeRadius,
    this.fillExtrusionEdgeRadiusExpression,
    this.fillExtrusionAmbientOcclusionGroundAttenuation,
    this.fillExtrusionAmbientOcclusionGroundAttenuationExpression,
    this.fillExtrusionAmbientOcclusionGroundRadius,
    this.fillExtrusionAmbientOcclusionGroundRadiusExpression,
    this.fillExtrusionAmbientOcclusionIntensity,
    this.fillExtrusionAmbientOcclusionIntensityExpression,
    this.fillExtrusionAmbientOcclusionRadius,
    this.fillExtrusionAmbientOcclusionRadiusExpression,
    this.fillExtrusionAmbientOcclusionWallRadius,
    this.fillExtrusionAmbientOcclusionWallRadiusExpression,
    this.fillExtrusionBase,
    this.fillExtrusionBaseExpression,
    this.fillExtrusionBaseAlignment,
    this.fillExtrusionBaseAlignmentExpression,
    this.fillExtrusionCastShadows,
    this.fillExtrusionCastShadowsExpression,
    this.fillExtrusionColor,
    this.fillExtrusionColorExpression,
    this.fillExtrusionCutoffFadeRange,
    this.fillExtrusionCutoffFadeRangeExpression,
    this.fillExtrusionEmissiveStrength,
    this.fillExtrusionEmissiveStrengthExpression,
    this.fillExtrusionFloodLightColor,
    this.fillExtrusionFloodLightColorExpression,
    this.fillExtrusionFloodLightGroundAttenuation,
    this.fillExtrusionFloodLightGroundAttenuationExpression,
    this.fillExtrusionFloodLightGroundRadius,
    this.fillExtrusionFloodLightGroundRadiusExpression,
    this.fillExtrusionFloodLightIntensity,
    this.fillExtrusionFloodLightIntensityExpression,
    this.fillExtrusionFloodLightWallRadius,
    this.fillExtrusionFloodLightWallRadiusExpression,
    this.fillExtrusionHeight,
    this.fillExtrusionHeightExpression,
    this.fillExtrusionHeightAlignment,
    this.fillExtrusionHeightAlignmentExpression,
    this.fillExtrusionLineWidth,
    this.fillExtrusionLineWidthExpression,
    this.fillExtrusionOpacity,
    this.fillExtrusionOpacityExpression,
    this.fillExtrusionPattern,
    this.fillExtrusionPatternExpression,
    this.fillExtrusionPatternCrossFade,
    this.fillExtrusionPatternCrossFadeExpression,
    this.fillExtrusionRoundedRoof,
    this.fillExtrusionRoundedRoofExpression,
    this.fillExtrusionTranslate,
    this.fillExtrusionTranslateExpression,
    this.fillExtrusionTranslateAnchor,
    this.fillExtrusionTranslateAnchorExpression,
    this.fillExtrusionVerticalGradient,
    this.fillExtrusionVerticalGradientExpression,
    this.fillExtrusionVerticalScale,
    this.fillExtrusionVerticalScaleExpression,
  });

  @override
  String getType() => "fill-extrusion";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Radius of a fill extrusion edge in meters. If not zero, rounds extrusion edges for a smoother appearance.
  /// Default value: 0. Value range: [0, 1]
  @experimental
  double? fillExtrusionEdgeRadius;

  /// Radius of a fill extrusion edge in meters. If not zero, rounds extrusion edges for a smoother appearance.
  /// Default value: 0. Value range: [0, 1]
  @experimental
  List<Object>? fillExtrusionEdgeRadiusExpression;

  /// Provides a control to futher fine-tune the look of the ambient occlusion on the ground beneath the extruded buildings. Lower values give the effect a more solid look while higher values make it smoother.
  /// Default value: 0.69. Value range: [0, 1]
  @experimental
  double? fillExtrusionAmbientOcclusionGroundAttenuation;

  /// Provides a control to futher fine-tune the look of the ambient occlusion on the ground beneath the extruded buildings. Lower values give the effect a more solid look while higher values make it smoother.
  /// Default value: 0.69. Value range: [0, 1]
  @experimental
  List<Object>? fillExtrusionAmbientOcclusionGroundAttenuationExpression;

  /// The extent of the ambient occlusion effect on the ground beneath the extruded buildings in meters.
  /// Default value: 3. Minimum value: 0.
  @experimental
  double? fillExtrusionAmbientOcclusionGroundRadius;

  /// The extent of the ambient occlusion effect on the ground beneath the extruded buildings in meters.
  /// Default value: 3. Minimum value: 0.
  @experimental
  List<Object>? fillExtrusionAmbientOcclusionGroundRadiusExpression;

  /// Controls the intensity of shading near ground and concave angles between walls. Default value 0.0 disables ambient occlusion and values around 0.3 provide the most plausible results for buildings.
  /// Default value: 0. Value range: [0, 1]
  double? fillExtrusionAmbientOcclusionIntensity;

  /// Controls the intensity of shading near ground and concave angles between walls. Default value 0.0 disables ambient occlusion and values around 0.3 provide the most plausible results for buildings.
  /// Default value: 0. Value range: [0, 1]
  List<Object>? fillExtrusionAmbientOcclusionIntensityExpression;

  /// Shades area near ground and concave angles between walls where the radius defines only vertical impact. Default value 3.0 corresponds to height of one floor and brings the most plausible results for buildings. This property works only with legacy light. When 3D lights are enabled `fill-extrusion-ambient-occlusion-wall-radius` and `fill-extrusion-ambient-occlusion-ground-radius` are used instead.
  /// Default value: 3. Minimum value: 0.
  double? fillExtrusionAmbientOcclusionRadius;

  /// Shades area near ground and concave angles between walls where the radius defines only vertical impact. Default value 3.0 corresponds to height of one floor and brings the most plausible results for buildings. This property works only with legacy light. When 3D lights are enabled `fill-extrusion-ambient-occlusion-wall-radius` and `fill-extrusion-ambient-occlusion-ground-radius` are used instead.
  /// Default value: 3. Minimum value: 0.
  List<Object>? fillExtrusionAmbientOcclusionRadiusExpression;

  /// Shades area near ground and concave angles between walls where the radius defines only vertical impact. Default value 3.0 corresponds to height of one floor and brings the most plausible results for buildings.
  /// Default value: 3. Minimum value: 0.
  @experimental
  double? fillExtrusionAmbientOcclusionWallRadius;

  /// Shades area near ground and concave angles between walls where the radius defines only vertical impact. Default value 3.0 corresponds to height of one floor and brings the most plausible results for buildings.
  /// Default value: 3. Minimum value: 0.
  @experimental
  List<Object>? fillExtrusionAmbientOcclusionWallRadiusExpression;

  /// The height with which to extrude the base of this layer. Must be less than or equal to `fill-extrusion-height`.
  /// Default value: 0. Minimum value: 0. The unit of fillExtrusionBase is in meters.
  double? fillExtrusionBase;

  /// The height with which to extrude the base of this layer. Must be less than or equal to `fill-extrusion-height`.
  /// Default value: 0. Minimum value: 0. The unit of fillExtrusionBase is in meters.
  List<Object>? fillExtrusionBaseExpression;

  /// Controls the behavior of fill extrusion base over terrain
  /// Default value: "terrain".
  @experimental
  FillExtrusionBaseAlignment? fillExtrusionBaseAlignment;

  /// Controls the behavior of fill extrusion base over terrain
  /// Default value: "terrain".
  @experimental
  List<Object>? fillExtrusionBaseAlignmentExpression;

  /// Enable/Disable shadow casting for this layer
  /// Default value: true.
  bool? fillExtrusionCastShadows;

  /// Enable/Disable shadow casting for this layer
  /// Default value: true.
  List<Object>? fillExtrusionCastShadowsExpression;

  /// The base color of the extruded fill. The extrusion's surfaces will be shaded differently based on this color in combination with the root `light` settings. If this color is specified as `rgba` with an alpha component, the alpha component will be ignored; use `fill-extrusion-opacity` to set layer opacity.
  /// Default value: "#000000".
  int? fillExtrusionColor;

  /// The base color of the extruded fill. The extrusion's surfaces will be shaded differently based on this color in combination with the root `light` settings. If this color is specified as `rgba` with an alpha component, the alpha component will be ignored; use `fill-extrusion-opacity` to set layer opacity.
  /// Default value: "#000000".
  List<Object>? fillExtrusionColorExpression;

  /// This parameter defines the range for the fade-out effect before an automatic content cutoff on pitched map views. Fade out is implemented by scaling down and removing buildings in the fade range in a staggered fashion. Opacity is not changed. The fade range is expressed in relation to the height of the map view. A value of 1.0 indicates that the content is faded to the same extent as the map's height in pixels, while a value close to zero represents a sharp cutoff. When the value is set to 0.0, the cutoff is completely disabled. Note: The property has no effect on the map if terrain is enabled.
  /// Default value: 0. Value range: [0, 1]
  double? fillExtrusionCutoffFadeRange;

  /// This parameter defines the range for the fade-out effect before an automatic content cutoff on pitched map views. Fade out is implemented by scaling down and removing buildings in the fade range in a staggered fashion. Opacity is not changed. The fade range is expressed in relation to the height of the map view. A value of 1.0 indicates that the content is faded to the same extent as the map's height in pixels, while a value close to zero represents a sharp cutoff. When the value is set to 0.0, the cutoff is completely disabled. Note: The property has no effect on the map if terrain is enabled.
  /// Default value: 0. Value range: [0, 1]
  List<Object>? fillExtrusionCutoffFadeRangeExpression;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0. The unit of fillExtrusionEmissiveStrength is in intensity.
  double? fillExtrusionEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0. The unit of fillExtrusionEmissiveStrength is in intensity.
  List<Object>? fillExtrusionEmissiveStrengthExpression;

  /// The color of the flood light effect on the walls of the extruded buildings.
  /// Default value: "#ffffff".
  @experimental
  int? fillExtrusionFloodLightColor;

  /// The color of the flood light effect on the walls of the extruded buildings.
  /// Default value: "#ffffff".
  @experimental
  List<Object>? fillExtrusionFloodLightColorExpression;

  /// Provides a control to futher fine-tune the look of the flood light on the ground beneath the extruded buildings. Lower values give the effect a more solid look while higher values make it smoother.
  /// Default value: 0.69. Value range: [0, 1]
  @experimental
  double? fillExtrusionFloodLightGroundAttenuation;

  /// Provides a control to futher fine-tune the look of the flood light on the ground beneath the extruded buildings. Lower values give the effect a more solid look while higher values make it smoother.
  /// Default value: 0.69. Value range: [0, 1]
  @experimental
  List<Object>? fillExtrusionFloodLightGroundAttenuationExpression;

  /// The extent of the flood light effect on the ground beneath the extruded buildings in meters. Note: this experimental property is evaluated once per tile, during tile initialization. Changing the property value could trigger tile reload. The `feature-state` styling is deprecated and will get removed soon.
  /// Default value: 0. The unit of fillExtrusionFloodLightGroundRadius is in meters.
  @experimental
  double? fillExtrusionFloodLightGroundRadius;

  /// The extent of the flood light effect on the ground beneath the extruded buildings in meters. Note: this experimental property is evaluated once per tile, during tile initialization. Changing the property value could trigger tile reload. The `feature-state` styling is deprecated and will get removed soon.
  /// Default value: 0. The unit of fillExtrusionFloodLightGroundRadius is in meters.
  @experimental
  List<Object>? fillExtrusionFloodLightGroundRadiusExpression;

  /// The intensity of the flood light color.
  /// Default value: 0. Value range: [0, 1]
  @experimental
  double? fillExtrusionFloodLightIntensity;

  /// The intensity of the flood light color.
  /// Default value: 0. Value range: [0, 1]
  @experimental
  List<Object>? fillExtrusionFloodLightIntensityExpression;

  /// The extent of the flood light effect on the walls of the extruded buildings in meters.
  /// Default value: 0. Minimum value: 0. The unit of fillExtrusionFloodLightWallRadius is in meters.
  @experimental
  double? fillExtrusionFloodLightWallRadius;

  /// The extent of the flood light effect on the walls of the extruded buildings in meters.
  /// Default value: 0. Minimum value: 0. The unit of fillExtrusionFloodLightWallRadius is in meters.
  @experimental
  List<Object>? fillExtrusionFloodLightWallRadiusExpression;

  /// The height with which to extrude this layer.
  /// Default value: 0. Minimum value: 0. The unit of fillExtrusionHeight is in meters.
  double? fillExtrusionHeight;

  /// The height with which to extrude this layer.
  /// Default value: 0. Minimum value: 0. The unit of fillExtrusionHeight is in meters.
  List<Object>? fillExtrusionHeightExpression;

  /// Controls the behavior of fill extrusion height over terrain
  /// Default value: "flat".
  @experimental
  FillExtrusionHeightAlignment? fillExtrusionHeightAlignment;

  /// Controls the behavior of fill extrusion height over terrain
  /// Default value: "flat".
  @experimental
  List<Object>? fillExtrusionHeightAlignmentExpression;

  /// If a non-zero value is provided, it sets the fill-extrusion layer into wall rendering mode. The value is used to render the feature with the given width over the outlines of the geometry. Note: This property is experimental and some other fill-extrusion properties might not be supported with non-zero line width.
  /// Default value: 0. Minimum value: 0. The unit of fillExtrusionLineWidth is in meters.
  @experimental
  double? fillExtrusionLineWidth;

  /// If a non-zero value is provided, it sets the fill-extrusion layer into wall rendering mode. The value is used to render the feature with the given width over the outlines of the geometry. Note: This property is experimental and some other fill-extrusion properties might not be supported with non-zero line width.
  /// Default value: 0. Minimum value: 0. The unit of fillExtrusionLineWidth is in meters.
  @experimental
  List<Object>? fillExtrusionLineWidthExpression;

  /// The opacity of the entire fill extrusion layer. This is rendered on a per-layer, not per-feature, basis, and data-driven styling is not available.
  /// Default value: 1. Value range: [0, 1]
  double? fillExtrusionOpacity;

  /// The opacity of the entire fill extrusion layer. This is rendered on a per-layer, not per-feature, basis, and data-driven styling is not available.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? fillExtrusionOpacityExpression;

  /// Name of image in sprite to use for drawing images on extruded fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? fillExtrusionPattern;

  /// Name of image in sprite to use for drawing images on extruded fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  List<Object>? fillExtrusionPatternExpression;

  /// Controls the transition progress between the image variants of fill-extrusion-pattern. Zero means the first variant is used, one is the second, and in between they are blended together. Both images should be the same size and have the same type (either raster or vector).
  /// Default value: 0. Value range: [0, 1]
  double? fillExtrusionPatternCrossFade;

  /// Controls the transition progress between the image variants of fill-extrusion-pattern. Zero means the first variant is used, one is the second, and in between they are blended together. Both images should be the same size and have the same type (either raster or vector).
  /// Default value: 0. Value range: [0, 1]
  List<Object>? fillExtrusionPatternCrossFadeExpression;

  /// Indicates whether top edges should be rounded when fill-extrusion-edge-radius has a value greater than 0. If false, rounded edges are only applied to the sides. Default is true.
  /// Default value: true.
  @experimental
  bool? fillExtrusionRoundedRoof;

  /// Indicates whether top edges should be rounded when fill-extrusion-edge-radius has a value greater than 0. If false, rounded edges are only applied to the sides. Default is true.
  /// Default value: true.
  @experimental
  List<Object>? fillExtrusionRoundedRoofExpression;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up (on the flat plane), respectively.
  /// Default value: [0,0]. The unit of fillExtrusionTranslate is in pixels.
  List<double?>? fillExtrusionTranslate;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up (on the flat plane), respectively.
  /// Default value: [0,0]. The unit of fillExtrusionTranslate is in pixels.
  List<Object>? fillExtrusionTranslateExpression;

  /// Controls the frame of reference for `fill-extrusion-translate`.
  /// Default value: "map".
  FillExtrusionTranslateAnchor? fillExtrusionTranslateAnchor;

  /// Controls the frame of reference for `fill-extrusion-translate`.
  /// Default value: "map".
  List<Object>? fillExtrusionTranslateAnchorExpression;

  /// Whether to apply a vertical gradient to the sides of a fill-extrusion layer. If true, sides will be shaded slightly darker farther down.
  /// Default value: true.
  bool? fillExtrusionVerticalGradient;

  /// Whether to apply a vertical gradient to the sides of a fill-extrusion layer. If true, sides will be shaded slightly darker farther down.
  /// Default value: true.
  List<Object>? fillExtrusionVerticalGradientExpression;

  /// A global multiplier that can be used to scale base, height, AO, and flood light of the fill extrusions.
  /// Default value: 1. Minimum value: 0.
  @experimental
  double? fillExtrusionVerticalScale;

  /// A global multiplier that can be used to scale base, height, AO, and flood light of the fill extrusions.
  /// Default value: 1. Minimum value: 0.
  @experimental
  List<Object>? fillExtrusionVerticalScaleExpression;

  @override
  @internal
  Future<String> encode() async {
    var layout = {};
    if (visibilityExpression != null) {
      layout["visibility"] = visibilityExpression!;
    }
    if (visibility != null) {
      layout["visibility"] = visibility!.name.toLowerCase().replaceAll(
        "_",
        "-",
      );
    }

    if (fillExtrusionEdgeRadiusExpression != null) {
      layout["fill-extrusion-edge-radius"] = fillExtrusionEdgeRadiusExpression;
    }

    if (fillExtrusionEdgeRadius != null) {
      layout["fill-extrusion-edge-radius"] = fillExtrusionEdgeRadius;
    }
    var paint = {};
    if (fillExtrusionAmbientOcclusionGroundAttenuationExpression != null) {
      paint["fill-extrusion-ambient-occlusion-ground-attenuation"] =
          fillExtrusionAmbientOcclusionGroundAttenuationExpression;
    } else if (fillExtrusionAmbientOcclusionGroundAttenuation != null) {
      paint["fill-extrusion-ambient-occlusion-ground-attenuation"] =
          fillExtrusionAmbientOcclusionGroundAttenuation;
    }

    if (fillExtrusionAmbientOcclusionGroundRadiusExpression != null) {
      paint["fill-extrusion-ambient-occlusion-ground-radius"] =
          fillExtrusionAmbientOcclusionGroundRadiusExpression;
    } else if (fillExtrusionAmbientOcclusionGroundRadius != null) {
      paint["fill-extrusion-ambient-occlusion-ground-radius"] =
          fillExtrusionAmbientOcclusionGroundRadius;
    }

    if (fillExtrusionAmbientOcclusionIntensityExpression != null) {
      paint["fill-extrusion-ambient-occlusion-intensity"] =
          fillExtrusionAmbientOcclusionIntensityExpression;
    } else if (fillExtrusionAmbientOcclusionIntensity != null) {
      paint["fill-extrusion-ambient-occlusion-intensity"] =
          fillExtrusionAmbientOcclusionIntensity;
    }

    if (fillExtrusionAmbientOcclusionRadiusExpression != null) {
      paint["fill-extrusion-ambient-occlusion-radius"] =
          fillExtrusionAmbientOcclusionRadiusExpression;
    } else if (fillExtrusionAmbientOcclusionRadius != null) {
      paint["fill-extrusion-ambient-occlusion-radius"] =
          fillExtrusionAmbientOcclusionRadius;
    }

    if (fillExtrusionAmbientOcclusionWallRadiusExpression != null) {
      paint["fill-extrusion-ambient-occlusion-wall-radius"] =
          fillExtrusionAmbientOcclusionWallRadiusExpression;
    } else if (fillExtrusionAmbientOcclusionWallRadius != null) {
      paint["fill-extrusion-ambient-occlusion-wall-radius"] =
          fillExtrusionAmbientOcclusionWallRadius;
    }

    if (fillExtrusionBaseExpression != null) {
      paint["fill-extrusion-base"] = fillExtrusionBaseExpression;
    } else if (fillExtrusionBase != null) {
      paint["fill-extrusion-base"] = fillExtrusionBase;
    }

    if (fillExtrusionBaseAlignmentExpression != null) {
      paint["fill-extrusion-base-alignment"] =
          fillExtrusionBaseAlignmentExpression;
    } else if (fillExtrusionBaseAlignment != null) {
      paint["fill-extrusion-base-alignment"] = fillExtrusionBaseAlignment?.name
          .toLowerCase()
          .replaceAll("_", "-");
    }

    if (fillExtrusionCastShadowsExpression != null) {
      paint["fill-extrusion-cast-shadows"] = fillExtrusionCastShadowsExpression;
    } else if (fillExtrusionCastShadows != null) {
      paint["fill-extrusion-cast-shadows"] = fillExtrusionCastShadows;
    }

    if (fillExtrusionColorExpression != null) {
      paint["fill-extrusion-color"] = fillExtrusionColorExpression;
    } else if (fillExtrusionColor != null) {
      paint["fill-extrusion-color"] = fillExtrusionColor?.toRGBA();
    }

    if (fillExtrusionCutoffFadeRangeExpression != null) {
      paint["fill-extrusion-cutoff-fade-range"] =
          fillExtrusionCutoffFadeRangeExpression;
    } else if (fillExtrusionCutoffFadeRange != null) {
      paint["fill-extrusion-cutoff-fade-range"] = fillExtrusionCutoffFadeRange;
    }

    if (fillExtrusionEmissiveStrengthExpression != null) {
      paint["fill-extrusion-emissive-strength"] =
          fillExtrusionEmissiveStrengthExpression;
    } else if (fillExtrusionEmissiveStrength != null) {
      paint["fill-extrusion-emissive-strength"] = fillExtrusionEmissiveStrength;
    }

    if (fillExtrusionFloodLightColorExpression != null) {
      paint["fill-extrusion-flood-light-color"] =
          fillExtrusionFloodLightColorExpression;
    } else if (fillExtrusionFloodLightColor != null) {
      paint["fill-extrusion-flood-light-color"] = fillExtrusionFloodLightColor
          ?.toRGBA();
    }

    if (fillExtrusionFloodLightGroundAttenuationExpression != null) {
      paint["fill-extrusion-flood-light-ground-attenuation"] =
          fillExtrusionFloodLightGroundAttenuationExpression;
    } else if (fillExtrusionFloodLightGroundAttenuation != null) {
      paint["fill-extrusion-flood-light-ground-attenuation"] =
          fillExtrusionFloodLightGroundAttenuation;
    }

    if (fillExtrusionFloodLightGroundRadiusExpression != null) {
      paint["fill-extrusion-flood-light-ground-radius"] =
          fillExtrusionFloodLightGroundRadiusExpression;
    } else if (fillExtrusionFloodLightGroundRadius != null) {
      paint["fill-extrusion-flood-light-ground-radius"] =
          fillExtrusionFloodLightGroundRadius;
    }

    if (fillExtrusionFloodLightIntensityExpression != null) {
      paint["fill-extrusion-flood-light-intensity"] =
          fillExtrusionFloodLightIntensityExpression;
    } else if (fillExtrusionFloodLightIntensity != null) {
      paint["fill-extrusion-flood-light-intensity"] =
          fillExtrusionFloodLightIntensity;
    }

    if (fillExtrusionFloodLightWallRadiusExpression != null) {
      paint["fill-extrusion-flood-light-wall-radius"] =
          fillExtrusionFloodLightWallRadiusExpression;
    } else if (fillExtrusionFloodLightWallRadius != null) {
      paint["fill-extrusion-flood-light-wall-radius"] =
          fillExtrusionFloodLightWallRadius;
    }

    if (fillExtrusionHeightExpression != null) {
      paint["fill-extrusion-height"] = fillExtrusionHeightExpression;
    } else if (fillExtrusionHeight != null) {
      paint["fill-extrusion-height"] = fillExtrusionHeight;
    }

    if (fillExtrusionHeightAlignmentExpression != null) {
      paint["fill-extrusion-height-alignment"] =
          fillExtrusionHeightAlignmentExpression;
    } else if (fillExtrusionHeightAlignment != null) {
      paint["fill-extrusion-height-alignment"] = fillExtrusionHeightAlignment
          ?.name
          .toLowerCase()
          .replaceAll("_", "-");
    }

    if (fillExtrusionLineWidthExpression != null) {
      paint["fill-extrusion-line-width"] = fillExtrusionLineWidthExpression;
    } else if (fillExtrusionLineWidth != null) {
      paint["fill-extrusion-line-width"] = fillExtrusionLineWidth;
    }

    if (fillExtrusionOpacityExpression != null) {
      paint["fill-extrusion-opacity"] = fillExtrusionOpacityExpression;
    } else if (fillExtrusionOpacity != null) {
      paint["fill-extrusion-opacity"] = fillExtrusionOpacity;
    }

    if (fillExtrusionPatternExpression != null) {
      paint["fill-extrusion-pattern"] = fillExtrusionPatternExpression;
    } else if (fillExtrusionPattern != null) {
      paint["fill-extrusion-pattern"] = fillExtrusionPattern;
    }

    if (fillExtrusionPatternCrossFadeExpression != null) {
      paint["fill-extrusion-pattern-cross-fade"] =
          fillExtrusionPatternCrossFadeExpression;
    } else if (fillExtrusionPatternCrossFade != null) {
      paint["fill-extrusion-pattern-cross-fade"] =
          fillExtrusionPatternCrossFade;
    }

    if (fillExtrusionRoundedRoofExpression != null) {
      paint["fill-extrusion-rounded-roof"] = fillExtrusionRoundedRoofExpression;
    } else if (fillExtrusionRoundedRoof != null) {
      paint["fill-extrusion-rounded-roof"] = fillExtrusionRoundedRoof;
    }

    if (fillExtrusionTranslateExpression != null) {
      paint["fill-extrusion-translate"] = fillExtrusionTranslateExpression;
    } else if (fillExtrusionTranslate != null) {
      paint["fill-extrusion-translate"] = fillExtrusionTranslate;
    }

    if (fillExtrusionTranslateAnchorExpression != null) {
      paint["fill-extrusion-translate-anchor"] =
          fillExtrusionTranslateAnchorExpression;
    } else if (fillExtrusionTranslateAnchor != null) {
      paint["fill-extrusion-translate-anchor"] = fillExtrusionTranslateAnchor
          ?.name
          .toLowerCase()
          .replaceAll("_", "-");
    }

    if (fillExtrusionVerticalGradientExpression != null) {
      paint["fill-extrusion-vertical-gradient"] =
          fillExtrusionVerticalGradientExpression;
    } else if (fillExtrusionVerticalGradient != null) {
      paint["fill-extrusion-vertical-gradient"] = fillExtrusionVerticalGradient;
    }

    if (fillExtrusionVerticalScaleExpression != null) {
      paint["fill-extrusion-vertical-scale"] =
          fillExtrusionVerticalScaleExpression;
    } else if (fillExtrusionVerticalScale != null) {
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
    if (filter != null) {
      properties["filter"] = filter!;
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
          : Visibility.values.firstWhere(
              (e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["layout"]["visibility"]),
            ),
      visibilityExpression: styleOptionalCastList(map["layout"]["visibility"]),
      filter: styleOptionalCastList(map["filter"]),
      fillExtrusionEdgeRadius: styleOptionalCast(
        map["layout"]["fill-extrusion-edge-radius"],
      ),
      fillExtrusionEdgeRadiusExpression: styleOptionalCastList(
        map["layout"]["fill-extrusion-edge-radius"],
      ),
      fillExtrusionAmbientOcclusionGroundAttenuation: styleOptionalCast(
        map["paint"]["fill-extrusion-ambient-occlusion-ground-attenuation"],
      ),
      fillExtrusionAmbientOcclusionGroundAttenuationExpression:
          styleOptionalCastList(
            map["paint"]["fill-extrusion-ambient-occlusion-ground-attenuation"],
          ),
      fillExtrusionAmbientOcclusionGroundRadius: styleOptionalCast(
        map["paint"]["fill-extrusion-ambient-occlusion-ground-radius"],
      ),
      fillExtrusionAmbientOcclusionGroundRadiusExpression:
          styleOptionalCastList(
            map["paint"]["fill-extrusion-ambient-occlusion-ground-radius"],
          ),
      fillExtrusionAmbientOcclusionIntensity: styleOptionalCast(
        map["paint"]["fill-extrusion-ambient-occlusion-intensity"],
      ),
      fillExtrusionAmbientOcclusionIntensityExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-ambient-occlusion-intensity"],
      ),
      fillExtrusionAmbientOcclusionRadius: styleOptionalCast(
        map["paint"]["fill-extrusion-ambient-occlusion-radius"],
      ),
      fillExtrusionAmbientOcclusionRadiusExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-ambient-occlusion-radius"],
      ),
      fillExtrusionAmbientOcclusionWallRadius: styleOptionalCast(
        map["paint"]["fill-extrusion-ambient-occlusion-wall-radius"],
      ),
      fillExtrusionAmbientOcclusionWallRadiusExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-ambient-occlusion-wall-radius"],
      ),
      fillExtrusionBase: styleOptionalCast(map["paint"]["fill-extrusion-base"]),
      fillExtrusionBaseExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-base"],
      ),
      fillExtrusionBaseAlignment:
          map["paint"]["fill-extrusion-base-alignment"] == null
          ? null
          : FillExtrusionBaseAlignment.values.firstWhere(
              (e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["paint"]["fill-extrusion-base-alignment"]),
            ),
      fillExtrusionBaseAlignmentExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-base-alignment"],
      ),
      fillExtrusionCastShadows: styleOptionalCast(
        map["paint"]["fill-extrusion-cast-shadows"],
      ),
      fillExtrusionCastShadowsExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-cast-shadows"],
      ),
      fillExtrusionColor: (map["paint"]["fill-extrusion-color"] as List?)
          ?.toRGBAInt(),
      fillExtrusionColorExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-color"],
      ),
      fillExtrusionCutoffFadeRange: styleOptionalCast(
        map["paint"]["fill-extrusion-cutoff-fade-range"],
      ),
      fillExtrusionCutoffFadeRangeExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-cutoff-fade-range"],
      ),
      fillExtrusionEmissiveStrength: styleOptionalCast(
        map["paint"]["fill-extrusion-emissive-strength"],
      ),
      fillExtrusionEmissiveStrengthExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-emissive-strength"],
      ),
      fillExtrusionFloodLightColor:
          (map["paint"]["fill-extrusion-flood-light-color"] as List?)
              ?.toRGBAInt(),
      fillExtrusionFloodLightColorExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-flood-light-color"],
      ),
      fillExtrusionFloodLightGroundAttenuation: styleOptionalCast(
        map["paint"]["fill-extrusion-flood-light-ground-attenuation"],
      ),
      fillExtrusionFloodLightGroundAttenuationExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-flood-light-ground-attenuation"],
      ),
      fillExtrusionFloodLightGroundRadius: styleOptionalCast(
        map["paint"]["fill-extrusion-flood-light-ground-radius"],
      ),
      fillExtrusionFloodLightGroundRadiusExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-flood-light-ground-radius"],
      ),
      fillExtrusionFloodLightIntensity: styleOptionalCast(
        map["paint"]["fill-extrusion-flood-light-intensity"],
      ),
      fillExtrusionFloodLightIntensityExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-flood-light-intensity"],
      ),
      fillExtrusionFloodLightWallRadius: styleOptionalCast(
        map["paint"]["fill-extrusion-flood-light-wall-radius"],
      ),
      fillExtrusionFloodLightWallRadiusExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-flood-light-wall-radius"],
      ),
      fillExtrusionHeight: styleOptionalCast(
        map["paint"]["fill-extrusion-height"],
      ),
      fillExtrusionHeightExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-height"],
      ),
      fillExtrusionHeightAlignment:
          map["paint"]["fill-extrusion-height-alignment"] == null
          ? null
          : FillExtrusionHeightAlignment.values.firstWhere(
              (e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["paint"]["fill-extrusion-height-alignment"]),
            ),
      fillExtrusionHeightAlignmentExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-height-alignment"],
      ),
      fillExtrusionLineWidth: styleOptionalCast(
        map["paint"]["fill-extrusion-line-width"],
      ),
      fillExtrusionLineWidthExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-line-width"],
      ),
      fillExtrusionOpacity: styleOptionalCast(
        map["paint"]["fill-extrusion-opacity"],
      ),
      fillExtrusionOpacityExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-opacity"],
      ),
      fillExtrusionPattern: styleOptionalCast(
        map["paint"]["fill-extrusion-pattern"],
      ),
      fillExtrusionPatternExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-pattern"],
      ),
      fillExtrusionPatternCrossFade: styleOptionalCast(
        map["paint"]["fill-extrusion-pattern-cross-fade"],
      ),
      fillExtrusionPatternCrossFadeExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-pattern-cross-fade"],
      ),
      fillExtrusionRoundedRoof: styleOptionalCast(
        map["paint"]["fill-extrusion-rounded-roof"],
      ),
      fillExtrusionRoundedRoofExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-rounded-roof"],
      ),
      fillExtrusionTranslate:
          (map["paint"]["fill-extrusion-translate"] as List?)
              ?.map<double?>((e) => e.toDouble())
              .toList(),
      fillExtrusionTranslateExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-translate"],
      ),
      fillExtrusionTranslateAnchor:
          map["paint"]["fill-extrusion-translate-anchor"] == null
          ? null
          : FillExtrusionTranslateAnchor.values.firstWhere(
              (e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["paint"]["fill-extrusion-translate-anchor"]),
            ),
      fillExtrusionTranslateAnchorExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-translate-anchor"],
      ),
      fillExtrusionVerticalGradient: styleOptionalCast(
        map["paint"]["fill-extrusion-vertical-gradient"],
      ),
      fillExtrusionVerticalGradientExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-vertical-gradient"],
      ),
      fillExtrusionVerticalScale: styleOptionalCast(
        map["paint"]["fill-extrusion-vertical-scale"],
      ),
      fillExtrusionVerticalScaleExpression: styleOptionalCastList(
        map["paint"]["fill-extrusion-vertical-scale"],
      ),
    );
  }
}

// End of generated file.
