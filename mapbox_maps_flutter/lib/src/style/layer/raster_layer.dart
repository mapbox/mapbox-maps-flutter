// This file is generated.
// ignore_for_file: unused_import
import 'dart:convert';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../style_internal.dart';
import '../style_types.dart';
import 'layer.dart';

/// Raster map textures such as satellite imagery.
final class RasterLayer extends Layer {
  RasterLayer({
    required super.id,
    super.visibility,
    super.visibilityExpression,
    super.filter,
    super.minZoom,
    super.maxZoom,
    super.slot,
    required this.sourceId,
    this.sourceLayer,

    this.rasterArrayBand,
    this.rasterArrayBandExpression,
    this.rasterBrightnessMax,
    this.rasterBrightnessMaxExpression,
    this.rasterBrightnessMin,
    this.rasterBrightnessMinExpression,
    this.rasterColor,
    this.rasterColorExpression,
    this.rasterColorMix,
    this.rasterColorMixExpression,
    this.rasterColorRange,
    this.rasterColorRangeExpression,
    this.rasterContrast,
    this.rasterContrastExpression,
    this.rasterElevation,
    this.rasterElevationExpression,
    this.rasterEmissiveStrength,
    this.rasterEmissiveStrengthExpression,
    this.rasterFadeDuration,
    this.rasterFadeDurationExpression,
    this.rasterHueRotate,
    this.rasterHueRotateExpression,
    this.rasterOpacity,
    this.rasterOpacityExpression,
    this.rasterResampling,
    this.rasterResamplingExpression,
    this.rasterSaturation,
    this.rasterSaturationExpression,
  });

  @override
  String getType() => "raster";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Displayed band of raster array source layer. Defaults to the first band if not set.
  @experimental
  String? rasterArrayBand;

  /// Displayed band of raster array source layer. Defaults to the first band if not set.
  @experimental
  List<Object>? rasterArrayBandExpression;

  /// Increase or reduce the brightness of the image. The value is the maximum brightness.
  /// Default value: 1. Value range: [0, 1]
  double? rasterBrightnessMax;

  /// Increase or reduce the brightness of the image. The value is the maximum brightness.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? rasterBrightnessMaxExpression;

  /// Increase or reduce the brightness of the image. The value is the minimum brightness.
  /// Default value: 0. Value range: [0, 1]
  double? rasterBrightnessMin;

  /// Increase or reduce the brightness of the image. The value is the minimum brightness.
  /// Default value: 0. Value range: [0, 1]
  List<Object>? rasterBrightnessMinExpression;

  /// Defines the color ramp used to colorize a raster layer, parameterized by the `["raster-value"]` expression and evaluated over the range specified by `raster-color-range`. Raster values are spaced evenly across the range by default.
  int? rasterColor;

  /// Defines the color ramp used to colorize a raster layer, parameterized by the `["raster-value"]` expression and evaluated over the range specified by `raster-color-range`. Raster values are spaced evenly across the range by default.
  List<Object>? rasterColorExpression;

  /// When `raster-color` is active, specifies how the raster value is computed from a non-`rasterarray` source's channels, using the equation `mix.r - src.r + mix.g - src.g + mix.b - src.b + mix.a`. The first three components weight the source's red, green, and blue channels; the fourth is a constant offset and is not multiplied by source alpha. Source alpha is carried through and applied as opacity to the colorized result. The default corresponds to RGB luminosity. `rasterarray` sources ignore this property, as their raster value is decoded directly from the source data.
  /// Default value: [0.2126,0.7152,0.0722,0].
  List<double?>? rasterColorMix;

  /// When `raster-color` is active, specifies how the raster value is computed from a non-`rasterarray` source's channels, using the equation `mix.r - src.r + mix.g - src.g + mix.b - src.b + mix.a`. The first three components weight the source's red, green, and blue channels; the fourth is a constant offset and is not multiplied by source alpha. Source alpha is carried through and applied as opacity to the colorized result. The default corresponds to RGB luminosity. `rasterarray` sources ignore this property, as their raster value is decoded directly from the source data.
  /// Default value: [0.2126,0.7152,0.0722,0].
  List<Object>? rasterColorMixExpression;

  /// When `raster-color` is active, specifies the range of raster values mapped onto the color ramp, from the start of the ramp (low bound) to its end (high bound). For `rasterarray` sources the raster value is the decoded source data in the source's own units, and the source's stated data range is used when this property is unspecified. For other raster sources the raster value is computed from the source's channels via `raster-color-mix`. Defaults to `[0, 1]` when no range is otherwise available.
  List<double?>? rasterColorRange;

  /// When `raster-color` is active, specifies the range of raster values mapped onto the color ramp, from the start of the ramp (low bound) to its end (high bound). For `rasterarray` sources the raster value is the decoded source data in the source's own units, and the source's stated data range is used when this property is unspecified. For other raster sources the raster value is computed from the source's channels via `raster-color-mix`. Defaults to `[0, 1]` when no range is otherwise available.
  List<Object>? rasterColorRangeExpression;

  /// Increase or reduce the contrast of the image.
  /// Default value: 0. Value range: [-1, 1]
  double? rasterContrast;

  /// Increase or reduce the contrast of the image.
  /// Default value: 0. Value range: [-1, 1]
  List<Object>? rasterContrastExpression;

  /// Defines an uniform elevation from the base specified in raster-elevation-reference, in meters.
  /// Default value: 0. Minimum value: 0.
  @experimental
  double? rasterElevation;

  /// Defines an uniform elevation from the base specified in raster-elevation-reference, in meters.
  /// Default value: 0. Minimum value: 0.
  @experimental
  List<Object>? rasterElevationExpression;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0. The unit of rasterEmissiveStrength is in intensity.
  double? rasterEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0. The unit of rasterEmissiveStrength is in intensity.
  List<Object>? rasterEmissiveStrengthExpression;

  /// Fade duration when a new tile is added.
  /// Default value: 300. Minimum value: 0. The unit of rasterFadeDuration is in milliseconds.
  double? rasterFadeDuration;

  /// Fade duration when a new tile is added.
  /// Default value: 300. Minimum value: 0. The unit of rasterFadeDuration is in milliseconds.
  List<Object>? rasterFadeDurationExpression;

  /// Rotates hues around the color wheel.
  /// Default value: 0. The unit of rasterHueRotate is in degrees.
  double? rasterHueRotate;

  /// Rotates hues around the color wheel.
  /// Default value: 0. The unit of rasterHueRotate is in degrees.
  List<Object>? rasterHueRotateExpression;

  /// The opacity at which the image will be drawn.
  /// Default value: 1. Value range: [0, 1]
  double? rasterOpacity;

  /// The opacity at which the image will be drawn.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? rasterOpacityExpression;

  /// The resampling/interpolation method to use for overscaling, also known as texture magnification filter
  /// Default value: "linear".
  RasterResampling? rasterResampling;

  /// The resampling/interpolation method to use for overscaling, also known as texture magnification filter
  /// Default value: "linear".
  List<Object>? rasterResamplingExpression;

  /// Increase or reduce the saturation of the image.
  /// Default value: 0. Value range: [-1, 1]
  double? rasterSaturation;

  /// Increase or reduce the saturation of the image.
  /// Default value: 0. Value range: [-1, 1]
  List<Object>? rasterSaturationExpression;

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
    if (rasterArrayBandExpression != null) {
      paint["raster-array-band"] = rasterArrayBandExpression;
    } else if (rasterArrayBand != null) {
      paint["raster-array-band"] = rasterArrayBand;
    }

    if (rasterBrightnessMaxExpression != null) {
      paint["raster-brightness-max"] = rasterBrightnessMaxExpression;
    } else if (rasterBrightnessMax != null) {
      paint["raster-brightness-max"] = rasterBrightnessMax;
    }

    if (rasterBrightnessMinExpression != null) {
      paint["raster-brightness-min"] = rasterBrightnessMinExpression;
    } else if (rasterBrightnessMin != null) {
      paint["raster-brightness-min"] = rasterBrightnessMin;
    }

    if (rasterColorExpression != null) {
      paint["raster-color"] = rasterColorExpression;
    } else if (rasterColor != null) {
      paint["raster-color"] = rasterColor?.toRGBA();
    }

    if (rasterColorMixExpression != null) {
      paint["raster-color-mix"] = rasterColorMixExpression;
    } else if (rasterColorMix != null) {
      paint["raster-color-mix"] = rasterColorMix;
    }

    if (rasterColorRangeExpression != null) {
      paint["raster-color-range"] = rasterColorRangeExpression;
    } else if (rasterColorRange != null) {
      paint["raster-color-range"] = rasterColorRange;
    }

    if (rasterContrastExpression != null) {
      paint["raster-contrast"] = rasterContrastExpression;
    } else if (rasterContrast != null) {
      paint["raster-contrast"] = rasterContrast;
    }

    if (rasterElevationExpression != null) {
      paint["raster-elevation"] = rasterElevationExpression;
    } else if (rasterElevation != null) {
      paint["raster-elevation"] = rasterElevation;
    }

    if (rasterEmissiveStrengthExpression != null) {
      paint["raster-emissive-strength"] = rasterEmissiveStrengthExpression;
    } else if (rasterEmissiveStrength != null) {
      paint["raster-emissive-strength"] = rasterEmissiveStrength;
    }

    if (rasterFadeDurationExpression != null) {
      paint["raster-fade-duration"] = rasterFadeDurationExpression;
    } else if (rasterFadeDuration != null) {
      paint["raster-fade-duration"] = rasterFadeDuration;
    }

    if (rasterHueRotateExpression != null) {
      paint["raster-hue-rotate"] = rasterHueRotateExpression;
    } else if (rasterHueRotate != null) {
      paint["raster-hue-rotate"] = rasterHueRotate;
    }

    if (rasterOpacityExpression != null) {
      paint["raster-opacity"] = rasterOpacityExpression;
    } else if (rasterOpacity != null) {
      paint["raster-opacity"] = rasterOpacity;
    }

    if (rasterResamplingExpression != null) {
      paint["raster-resampling"] = rasterResamplingExpression;
    } else if (rasterResampling != null) {
      paint["raster-resampling"] = rasterResampling?.name
          .toLowerCase()
          .replaceAll("_", "-");
    }

    if (rasterSaturationExpression != null) {
      paint["raster-saturation"] = rasterSaturationExpression;
    } else if (rasterSaturation != null) {
      paint["raster-saturation"] = rasterSaturation;
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

  static RasterLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return RasterLayer(
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
      rasterArrayBand: styleOptionalCast(map["paint"]["raster-array-band"]),
      rasterArrayBandExpression: styleOptionalCastList(
        map["paint"]["raster-array-band"],
      ),
      rasterBrightnessMax: styleOptionalCast(
        map["paint"]["raster-brightness-max"],
      ),
      rasterBrightnessMaxExpression: styleOptionalCastList(
        map["paint"]["raster-brightness-max"],
      ),
      rasterBrightnessMin: styleOptionalCast(
        map["paint"]["raster-brightness-min"],
      ),
      rasterBrightnessMinExpression: styleOptionalCastList(
        map["paint"]["raster-brightness-min"],
      ),
      rasterColor: (map["paint"]["raster-color"] as List?)?.toRGBAInt(),
      rasterColorExpression: styleOptionalCastList(
        map["paint"]["raster-color"],
      ),
      rasterColorMix: (map["paint"]["raster-color-mix"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      rasterColorMixExpression: styleOptionalCastList(
        map["paint"]["raster-color-mix"],
      ),
      rasterColorRange: (map["paint"]["raster-color-range"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      rasterColorRangeExpression: styleOptionalCastList(
        map["paint"]["raster-color-range"],
      ),
      rasterContrast: styleOptionalCast(map["paint"]["raster-contrast"]),
      rasterContrastExpression: styleOptionalCastList(
        map["paint"]["raster-contrast"],
      ),
      rasterElevation: styleOptionalCast(map["paint"]["raster-elevation"]),
      rasterElevationExpression: styleOptionalCastList(
        map["paint"]["raster-elevation"],
      ),
      rasterEmissiveStrength: styleOptionalCast(
        map["paint"]["raster-emissive-strength"],
      ),
      rasterEmissiveStrengthExpression: styleOptionalCastList(
        map["paint"]["raster-emissive-strength"],
      ),
      rasterFadeDuration: styleOptionalCast(
        map["paint"]["raster-fade-duration"],
      ),
      rasterFadeDurationExpression: styleOptionalCastList(
        map["paint"]["raster-fade-duration"],
      ),
      rasterHueRotate: styleOptionalCast(map["paint"]["raster-hue-rotate"]),
      rasterHueRotateExpression: styleOptionalCastList(
        map["paint"]["raster-hue-rotate"],
      ),
      rasterOpacity: styleOptionalCast(map["paint"]["raster-opacity"]),
      rasterOpacityExpression: styleOptionalCastList(
        map["paint"]["raster-opacity"],
      ),
      rasterResampling: map["paint"]["raster-resampling"] == null
          ? null
          : RasterResampling.values.firstWhere(
              (e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["paint"]["raster-resampling"]),
            ),
      rasterResamplingExpression: styleOptionalCastList(
        map["paint"]["raster-resampling"],
      ),
      rasterSaturation: styleOptionalCast(map["paint"]["raster-saturation"]),
      rasterSaturationExpression: styleOptionalCastList(
        map["paint"]["raster-saturation"],
      ),
    );
  }
}

// End of generated file.
