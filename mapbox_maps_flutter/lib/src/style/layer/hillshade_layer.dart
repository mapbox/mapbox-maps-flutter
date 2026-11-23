// This file is generated.
// ignore_for_file: unused_import, experimental_member_use
import 'dart:convert';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../style_internal.dart';
import '../style_types.dart';
import 'layer.dart';

/// Client-side hillshading visualization based on DEM data. Currently, the implementation only supports Mapbox Terrain RGB and Mapzen Terrarium tiles.
final class HillshadeLayer extends Layer {
  HillshadeLayer({
    required super.id,
    super.visibility,
    super.visibilityExpression,
    super.filter,
    super.minZoom,
    super.maxZoom,
    super.slot,
    required this.sourceId,
    this.sourceLayer,

    this.hillshadeAccentColor,
    this.hillshadeAccentColorExpression,
    this.hillshadeAccentColorUseTheme,
    this.hillshadeAccentColorUseThemeExpression,
    this.hillshadeEmissiveStrength,
    this.hillshadeEmissiveStrengthExpression,
    this.hillshadeExaggeration,
    this.hillshadeExaggerationExpression,
    this.hillshadeHighlightColor,
    this.hillshadeHighlightColorExpression,
    this.hillshadeHighlightColorUseTheme,
    this.hillshadeHighlightColorUseThemeExpression,
    this.hillshadeIlluminationAnchor,
    this.hillshadeIlluminationAnchorExpression,
    this.hillshadeIlluminationDirection,
    this.hillshadeIlluminationDirectionExpression,
    this.hillshadeShadowColor,
    this.hillshadeShadowColorExpression,
    this.hillshadeShadowColorUseTheme,
    this.hillshadeShadowColorUseThemeExpression,
  });

  @override
  String getType() => "hillshade";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// The shading color used to accentuate rugged terrain like sharp cliffs and gorges.
  /// Default value: "#000000".
  int? hillshadeAccentColor;

  /// The shading color used to accentuate rugged terrain like sharp cliffs and gorges.
  /// Default value: "#000000".
  List<Object>? hillshadeAccentColorExpression;

  /// Sets if the color theme of the style changes `hillshadeAccentColor`. If you do not set this property, the color theme changes the color.
  @experimental
  ColorUseTheme? hillshadeAccentColorUseTheme;

  /// Sets if the color theme of the style changes `hillshadeAccentColor`. If you do not set this property, the color theme changes the color.
  @experimental
  List<Object>? hillshadeAccentColorUseThemeExpression;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0. The unit of hillshadeEmissiveStrength is in intensity.
  double? hillshadeEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0. The unit of hillshadeEmissiveStrength is in intensity.
  List<Object>? hillshadeEmissiveStrengthExpression;

  /// Intensity of the hillshade
  /// Default value: 0.5. Value range: [0, 1]
  double? hillshadeExaggeration;

  /// Intensity of the hillshade
  /// Default value: 0.5. Value range: [0, 1]
  List<Object>? hillshadeExaggerationExpression;

  /// The shading color of areas that faces towards the light source.
  /// Default value: "#FFFFFF".
  int? hillshadeHighlightColor;

  /// The shading color of areas that faces towards the light source.
  /// Default value: "#FFFFFF".
  List<Object>? hillshadeHighlightColorExpression;

  /// Sets if the color theme of the style changes `hillshadeHighlightColor`. If you do not set this property, the color theme changes the color.
  @experimental
  ColorUseTheme? hillshadeHighlightColorUseTheme;

  /// Sets if the color theme of the style changes `hillshadeHighlightColor`. If you do not set this property, the color theme changes the color.
  @experimental
  List<Object>? hillshadeHighlightColorUseThemeExpression;

  /// Direction of light source when map is rotated.
  /// Default value: "viewport".
  HillshadeIlluminationAnchor? hillshadeIlluminationAnchor;

  /// Direction of light source when map is rotated.
  /// Default value: "viewport".
  List<Object>? hillshadeIlluminationAnchorExpression;

  /// The direction of the light source used to generate the hillshading with 0 as the top of the viewport if `hillshade-illumination-anchor` is set to `viewport` and due north if `hillshade-illumination-anchor` is set to `map` and no 3d lights enabled. If `hillshade-illumination-anchor` is set to `map` and 3d lights enabled, the direction from 3d lights is used instead.
  /// Default value: 335. Value range: [0, 359]
  double? hillshadeIlluminationDirection;

  /// The direction of the light source used to generate the hillshading with 0 as the top of the viewport if `hillshade-illumination-anchor` is set to `viewport` and due north if `hillshade-illumination-anchor` is set to `map` and no 3d lights enabled. If `hillshade-illumination-anchor` is set to `map` and 3d lights enabled, the direction from 3d lights is used instead.
  /// Default value: 335. Value range: [0, 359]
  List<Object>? hillshadeIlluminationDirectionExpression;

  /// The shading color of areas that face away from the light source.
  /// Default value: "#000000".
  int? hillshadeShadowColor;

  /// The shading color of areas that face away from the light source.
  /// Default value: "#000000".
  List<Object>? hillshadeShadowColorExpression;

  /// Sets if the color theme of the style changes `hillshadeShadowColor`. If you do not set this property, the color theme changes the color.
  @experimental
  ColorUseTheme? hillshadeShadowColorUseTheme;

  /// Sets if the color theme of the style changes `hillshadeShadowColor`. If you do not set this property, the color theme changes the color.
  @experimental
  List<Object>? hillshadeShadowColorUseThemeExpression;

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

    var paint = {};
    if (hillshadeAccentColorExpression != null) {
      paint["hillshade-accent-color"] = hillshadeAccentColorExpression;
    } else if (hillshadeAccentColor != null) {
      paint["hillshade-accent-color"] = hillshadeAccentColor?.toRGBA();
    }

    if (hillshadeAccentColorUseThemeExpression != null) {
      paint["hillshade-accent-color-use-theme"] =
          hillshadeAccentColorUseThemeExpression;
    } else if (hillshadeAccentColorUseTheme != null) {
      paint["hillshade-accent-color-use-theme"] =
          hillshadeAccentColorUseTheme?.value;
    }

    if (hillshadeEmissiveStrengthExpression != null) {
      paint["hillshade-emissive-strength"] =
          hillshadeEmissiveStrengthExpression;
    } else if (hillshadeEmissiveStrength != null) {
      paint["hillshade-emissive-strength"] = hillshadeEmissiveStrength;
    }

    if (hillshadeExaggerationExpression != null) {
      paint["hillshade-exaggeration"] = hillshadeExaggerationExpression;
    } else if (hillshadeExaggeration != null) {
      paint["hillshade-exaggeration"] = hillshadeExaggeration;
    }

    if (hillshadeHighlightColorExpression != null) {
      paint["hillshade-highlight-color"] = hillshadeHighlightColorExpression;
    } else if (hillshadeHighlightColor != null) {
      paint["hillshade-highlight-color"] = hillshadeHighlightColor?.toRGBA();
    }

    if (hillshadeHighlightColorUseThemeExpression != null) {
      paint["hillshade-highlight-color-use-theme"] =
          hillshadeHighlightColorUseThemeExpression;
    } else if (hillshadeHighlightColorUseTheme != null) {
      paint["hillshade-highlight-color-use-theme"] =
          hillshadeHighlightColorUseTheme?.value;
    }

    if (hillshadeIlluminationAnchorExpression != null) {
      paint["hillshade-illumination-anchor"] =
          hillshadeIlluminationAnchorExpression;
    } else if (hillshadeIlluminationAnchor != null) {
      paint["hillshade-illumination-anchor"] = hillshadeIlluminationAnchor?.name
          .toLowerCase()
          .replaceAll("_", "-");
    }

    if (hillshadeIlluminationDirectionExpression != null) {
      paint["hillshade-illumination-direction"] =
          hillshadeIlluminationDirectionExpression;
    } else if (hillshadeIlluminationDirection != null) {
      paint["hillshade-illumination-direction"] =
          hillshadeIlluminationDirection;
    }

    if (hillshadeShadowColorExpression != null) {
      paint["hillshade-shadow-color"] = hillshadeShadowColorExpression;
    } else if (hillshadeShadowColor != null) {
      paint["hillshade-shadow-color"] = hillshadeShadowColor?.toRGBA();
    }

    if (hillshadeShadowColorUseThemeExpression != null) {
      paint["hillshade-shadow-color-use-theme"] =
          hillshadeShadowColorUseThemeExpression;
    } else if (hillshadeShadowColorUseTheme != null) {
      paint["hillshade-shadow-color-use-theme"] =
          hillshadeShadowColorUseTheme?.value;
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

  static HillshadeLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return HillshadeLayer(
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
      hillshadeAccentColor: styleColorFromJson(
        map["paint"]["hillshade-accent-color"],
      ),
      hillshadeAccentColorExpression: styleOptionalCastList(
        map["paint"]["hillshade-accent-color"],
      ),
      hillshadeAccentColorUseTheme: ColorUseTheme.fromValue(
        map["paint"]["hillshade-accent-color-use-theme"],
      ),
      hillshadeAccentColorUseThemeExpression: styleOptionalCastList(
        map["paint"]["hillshade-accent-color-use-theme"],
      ),
      hillshadeEmissiveStrength: styleOptionalCast(
        map["paint"]["hillshade-emissive-strength"],
      ),
      hillshadeEmissiveStrengthExpression: styleOptionalCastList(
        map["paint"]["hillshade-emissive-strength"],
      ),
      hillshadeExaggeration: styleOptionalCast(
        map["paint"]["hillshade-exaggeration"],
      ),
      hillshadeExaggerationExpression: styleOptionalCastList(
        map["paint"]["hillshade-exaggeration"],
      ),
      hillshadeHighlightColor: styleColorFromJson(
        map["paint"]["hillshade-highlight-color"],
      ),
      hillshadeHighlightColorExpression: styleOptionalCastList(
        map["paint"]["hillshade-highlight-color"],
      ),
      hillshadeHighlightColorUseTheme: ColorUseTheme.fromValue(
        map["paint"]["hillshade-highlight-color-use-theme"],
      ),
      hillshadeHighlightColorUseThemeExpression: styleOptionalCastList(
        map["paint"]["hillshade-highlight-color-use-theme"],
      ),
      hillshadeIlluminationAnchor:
          map["paint"]["hillshade-illumination-anchor"] == null
          ? null
          : HillshadeIlluminationAnchor.values.firstWhere(
              (e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["paint"]["hillshade-illumination-anchor"]),
            ),
      hillshadeIlluminationAnchorExpression: styleOptionalCastList(
        map["paint"]["hillshade-illumination-anchor"],
      ),
      hillshadeIlluminationDirection: styleOptionalCast(
        map["paint"]["hillshade-illumination-direction"],
      ),
      hillshadeIlluminationDirectionExpression: styleOptionalCastList(
        map["paint"]["hillshade-illumination-direction"],
      ),
      hillshadeShadowColor: styleColorFromJson(
        map["paint"]["hillshade-shadow-color"],
      ),
      hillshadeShadowColorExpression: styleOptionalCastList(
        map["paint"]["hillshade-shadow-color"],
      ),
      hillshadeShadowColorUseTheme: ColorUseTheme.fromValue(
        map["paint"]["hillshade-shadow-color-use-theme"],
      ),
      hillshadeShadowColorUseThemeExpression: styleOptionalCastList(
        map["paint"]["hillshade-shadow-color-use-theme"],
      ),
    );
  }
}

// End of generated file.
