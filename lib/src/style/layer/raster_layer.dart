// This file is generated.
part of mapbox_maps_flutter;

/// Raster map textures such as satellite imagery.
class RasterLayer extends Layer {
  RasterLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required String this.sourceId,
    String? this.sourceLayer,
    String? this.rasterArrayBand,
    List<Object>? this.rasterArrayBandExpression,
    double? this.rasterBrightnessMax,
    List<Object>? this.rasterBrightnessMaxExpression,
    double? this.rasterBrightnessMin,
    List<Object>? this.rasterBrightnessMinExpression,
    int? this.rasterColor,
    List<Object>? this.rasterColorExpression,
    List<double?>? this.rasterColorMix,
    List<Object>? this.rasterColorMixExpression,
    List<double?>? this.rasterColorRange,
    List<Object>? this.rasterColorRangeExpression,
    double? this.rasterContrast,
    List<Object>? this.rasterContrastExpression,
    double? this.rasterElevation,
    List<Object>? this.rasterElevationExpression,
    double? this.rasterEmissiveStrength,
    List<Object>? this.rasterEmissiveStrengthExpression,
    double? this.rasterFadeDuration,
    List<Object>? this.rasterFadeDurationExpression,
    double? this.rasterHueRotate,
    List<Object>? this.rasterHueRotateExpression,
    double? this.rasterOpacity,
    List<Object>? this.rasterOpacityExpression,
    RasterResampling? this.rasterResampling,
    List<Object>? this.rasterResamplingExpression,
    double? this.rasterSaturation,
    List<Object>? this.rasterSaturationExpression,
  }) : super(
            id: id,
            visibility: visibility,
            visibilityExpression: visibilityExpression,
            filter: filter,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

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

  /// Defines a color map by which to colorize a raster layer, parameterized by the `["raster-value"]` expression and evaluated at 256 uniformly spaced steps over the range specified by `raster-color-range`.
  int? rasterColor;

  /// Defines a color map by which to colorize a raster layer, parameterized by the `["raster-value"]` expression and evaluated at 256 uniformly spaced steps over the range specified by `raster-color-range`.
  List<Object>? rasterColorExpression;

  /// When `raster-color` is active, specifies the combination of source RGB channels used to compute the raster value. Computed using the equation `mix.r - src.r + mix.g - src.g + mix.b - src.b + mix.a`. The first three components specify the mix of source red, green, and blue channels, respectively. The fourth component serves as a constant offset and is -not- multipled by source alpha. Source alpha is instead carried through and applied as opacity to the colorized result. Default value corresponds to RGB luminosity.
  /// Default value: [0.2126,0.7152,0.0722,0].
  List<double?>? rasterColorMix;

  /// When `raster-color` is active, specifies the combination of source RGB channels used to compute the raster value. Computed using the equation `mix.r - src.r + mix.g - src.g + mix.b - src.b + mix.a`. The first three components specify the mix of source red, green, and blue channels, respectively. The fourth component serves as a constant offset and is -not- multipled by source alpha. Source alpha is instead carried through and applied as opacity to the colorized result. Default value corresponds to RGB luminosity.
  /// Default value: [0.2126,0.7152,0.0722,0].
  List<Object>? rasterColorMixExpression;

  /// When `raster-color` is active, specifies the range over which `raster-color` is tabulated. Units correspond to the computed raster value via `raster-color-mix`. For `rasterarray` sources, if `raster-color-range` is unspecified, the source's stated data range is used.
  List<double?>? rasterColorRange;

  /// When `raster-color` is active, specifies the range over which `raster-color` is tabulated. Units correspond to the computed raster value via `raster-color-mix`. For `rasterarray` sources, if `raster-color-range` is unspecified, the source's stated data range is used.
  List<Object>? rasterColorRangeExpression;

  /// Increase or reduce the contrast of the image.
  /// Default value: 0. Value range: [-1, 1]
  double? rasterContrast;

  /// Increase or reduce the contrast of the image.
  /// Default value: 0. Value range: [-1, 1]
  List<Object>? rasterContrastExpression;

  /// Specifies an uniform elevation from the ground, in meters.
  /// Default value: 0. Minimum value: 0.
  @experimental
  double? rasterElevation;

  /// Specifies an uniform elevation from the ground, in meters.
  /// Default value: 0. Minimum value: 0.
  @experimental
  List<Object>? rasterElevationExpression;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0.
  double? rasterEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0.
  List<Object>? rasterEmissiveStrengthExpression;

  /// Fade duration when a new tile is added.
  /// Default value: 300. Minimum value: 0.
  double? rasterFadeDuration;

  /// Fade duration when a new tile is added.
  /// Default value: 300. Minimum value: 0.
  List<Object>? rasterFadeDurationExpression;

  /// Rotates hues around the color wheel.
  /// Default value: 0.
  double? rasterHueRotate;

  /// Rotates hues around the color wheel.
  /// Default value: 0.
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
  Future<String> _encode() async {
    var layout = {};
    if (visibilityExpression != null) {
      layout["visibility"] = visibilityExpression!;
    }
    if (visibility != null) {
      layout["visibility"] =
          visibility!.name.toLowerCase().replaceAll("_", "-");
    }

    var paint = {};
    if (rasterArrayBandExpression != null) {
      paint["raster-array-band"] = rasterArrayBandExpression;
    }
    if (rasterArrayBand != null) {
      paint["raster-array-band"] = rasterArrayBand;
    }

    if (rasterBrightnessMaxExpression != null) {
      paint["raster-brightness-max"] = rasterBrightnessMaxExpression;
    }
    if (rasterBrightnessMax != null) {
      paint["raster-brightness-max"] = rasterBrightnessMax;
    }

    if (rasterBrightnessMinExpression != null) {
      paint["raster-brightness-min"] = rasterBrightnessMinExpression;
    }
    if (rasterBrightnessMin != null) {
      paint["raster-brightness-min"] = rasterBrightnessMin;
    }

    if (rasterColorExpression != null) {
      paint["raster-color"] = rasterColorExpression;
    }
    if (rasterColor != null) {
      paint["raster-color"] = rasterColor?.toRGBA();
    }

    if (rasterColorMixExpression != null) {
      paint["raster-color-mix"] = rasterColorMixExpression;
    }
    if (rasterColorMix != null) {
      paint["raster-color-mix"] = rasterColorMix;
    }

    if (rasterColorRangeExpression != null) {
      paint["raster-color-range"] = rasterColorRangeExpression;
    }
    if (rasterColorRange != null) {
      paint["raster-color-range"] = rasterColorRange;
    }

    if (rasterContrastExpression != null) {
      paint["raster-contrast"] = rasterContrastExpression;
    }
    if (rasterContrast != null) {
      paint["raster-contrast"] = rasterContrast;
    }

    if (rasterElevationExpression != null) {
      paint["raster-elevation"] = rasterElevationExpression;
    }
    if (rasterElevation != null) {
      paint["raster-elevation"] = rasterElevation;
    }

    if (rasterEmissiveStrengthExpression != null) {
      paint["raster-emissive-strength"] = rasterEmissiveStrengthExpression;
    }
    if (rasterEmissiveStrength != null) {
      paint["raster-emissive-strength"] = rasterEmissiveStrength;
    }

    if (rasterFadeDurationExpression != null) {
      paint["raster-fade-duration"] = rasterFadeDurationExpression;
    }
    if (rasterFadeDuration != null) {
      paint["raster-fade-duration"] = rasterFadeDuration;
    }

    if (rasterHueRotateExpression != null) {
      paint["raster-hue-rotate"] = rasterHueRotateExpression;
    }
    if (rasterHueRotate != null) {
      paint["raster-hue-rotate"] = rasterHueRotate;
    }

    if (rasterOpacityExpression != null) {
      paint["raster-opacity"] = rasterOpacityExpression;
    }
    if (rasterOpacity != null) {
      paint["raster-opacity"] = rasterOpacity;
    }

    if (rasterResamplingExpression != null) {
      paint["raster-resampling"] = rasterResamplingExpression;
    }
    if (rasterResampling != null) {
      paint["raster-resampling"] =
          rasterResampling?.name.toLowerCase().replaceAll("_", "-");
    }

    if (rasterSaturationExpression != null) {
      paint["raster-saturation"] = rasterSaturationExpression;
    }
    if (rasterSaturation != null) {
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
          : Visibility.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["visibility"])),
      visibilityExpression: _optionalCastList(map["layout"]["visibility"]),
      filter: _optionalCastList(map["filter"]),
      rasterArrayBand: _optionalCast(map["paint"]["raster-array-band"]),
      rasterArrayBandExpression:
          _optionalCastList(map["paint"]["raster-array-band"]),
      rasterBrightnessMax: _optionalCast(map["paint"]["raster-brightness-max"]),
      rasterBrightnessMaxExpression:
          _optionalCastList(map["paint"]["raster-brightness-max"]),
      rasterBrightnessMin: _optionalCast(map["paint"]["raster-brightness-min"]),
      rasterBrightnessMinExpression:
          _optionalCastList(map["paint"]["raster-brightness-min"]),
      rasterColor: (map["paint"]["raster-color"] as List?)?.toRGBAInt(),
      rasterColorExpression: _optionalCastList(map["paint"]["raster-color"]),
      rasterColorMix: (map["paint"]["raster-color-mix"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      rasterColorMixExpression:
          _optionalCastList(map["paint"]["raster-color-mix"]),
      rasterColorRange: (map["paint"]["raster-color-range"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      rasterColorRangeExpression:
          _optionalCastList(map["paint"]["raster-color-range"]),
      rasterContrast: _optionalCast(map["paint"]["raster-contrast"]),
      rasterContrastExpression:
          _optionalCastList(map["paint"]["raster-contrast"]),
      rasterElevation: _optionalCast(map["paint"]["raster-elevation"]),
      rasterElevationExpression:
          _optionalCastList(map["paint"]["raster-elevation"]),
      rasterEmissiveStrength:
          _optionalCast(map["paint"]["raster-emissive-strength"]),
      rasterEmissiveStrengthExpression:
          _optionalCastList(map["paint"]["raster-emissive-strength"]),
      rasterFadeDuration: _optionalCast(map["paint"]["raster-fade-duration"]),
      rasterFadeDurationExpression:
          _optionalCastList(map["paint"]["raster-fade-duration"]),
      rasterHueRotate: _optionalCast(map["paint"]["raster-hue-rotate"]),
      rasterHueRotateExpression:
          _optionalCastList(map["paint"]["raster-hue-rotate"]),
      rasterOpacity: _optionalCast(map["paint"]["raster-opacity"]),
      rasterOpacityExpression:
          _optionalCastList(map["paint"]["raster-opacity"]),
      rasterResampling: map["paint"]["raster-resampling"] == null
          ? null
          : RasterResampling.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["raster-resampling"])),
      rasterResamplingExpression:
          _optionalCastList(map["paint"]["raster-resampling"]),
      rasterSaturation: _optionalCast(map["paint"]["raster-saturation"]),
      rasterSaturationExpression:
          _optionalCastList(map["paint"]["raster-saturation"]),
    );
  }
}

// End of generated file.
