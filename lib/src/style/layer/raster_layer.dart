// This file is generated.
part of mapbox_maps_flutter;

/// Raster map textures such as satellite imagery.
class RasterLayer extends Layer {
  RasterLayer({
    required id,
    visibility,
    minZoom,
    maxZoom,
    slot,
    required this.sourceId,
    this.sourceLayer,
    this.rasterArrayBand,
    this.rasterBrightnessMax,
    this.rasterBrightnessMin,
    this.rasterColor,
    this.rasterColorMix,
    this.rasterColorRange,
    this.rasterContrast,
    this.rasterElevation,
    this.rasterEmissiveStrength,
    this.rasterFadeDuration,
    this.rasterHueRotate,
    this.rasterOpacity,
    this.rasterResampling,
    this.rasterSaturation,
  }) : super(
            id: id,
            visibility: visibility,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "raster";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Displayed band of raster array source layer
  String? rasterArrayBand;

  /// Increase or reduce the brightness of the image. The value is the maximum brightness.
  double? rasterBrightnessMax;

  /// Increase or reduce the brightness of the image. The value is the minimum brightness.
  double? rasterBrightnessMin;

  /// Defines a color map by which to colorize a raster layer, parameterized by the `["raster-value"]` expression and evaluated at 256 uniformly spaced steps over the range specified by `raster-color-range`.
  int? rasterColor;

  /// When `raster-color` is active, specifies the combination of source RGB channels used to compute the raster value. Computed using the equation `mix.r * src.r + mix.g * src.g + mix.b * src.b + mix.a`. The first three components specify the mix of source red, green, and blue channels, respectively. The fourth component serves as a constant offset and is *not* multipled by source alpha. Source alpha is instead carried through and applied as opacity to the colorized result. Default value corresponds to RGB luminosity.
  List<double?>? rasterColorMix;

  /// When `raster-color` is active, specifies the range over which `raster-color` is tabulated. Units correspond to the computed raster value via `raster-color-mix`.
  List<double?>? rasterColorRange;

  /// Increase or reduce the contrast of the image.
  double? rasterContrast;

  /// Specifies an uniform elevation from the ground, in meters. Only supported with image sources.
  double? rasterElevation;

  /// Controls the intensity of light emitted on the source features.
  double? rasterEmissiveStrength;

  /// Fade duration when a new tile is added.
  double? rasterFadeDuration;

  /// Rotates hues around the color wheel.
  double? rasterHueRotate;

  /// The opacity at which the image will be drawn.
  double? rasterOpacity;

  /// The resampling/interpolation method to use for overscaling, also known as texture magnification filter
  RasterResampling? rasterResampling;

  /// Increase or reduce the saturation of the image.
  double? rasterSaturation;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.toString().split('.').last.toLowerCase();
    }
    var paint = {};
    if (rasterArrayBand != null) {
      paint["raster-array-band"] = rasterArrayBand;
    }
    if (rasterBrightnessMax != null) {
      paint["raster-brightness-max"] = rasterBrightnessMax;
    }
    if (rasterBrightnessMin != null) {
      paint["raster-brightness-min"] = rasterBrightnessMin;
    }
    if (rasterColor != null) {
      paint["raster-color"] = rasterColor?.toRGBA();
    }
    if (rasterColorMix != null) {
      paint["raster-color-mix"] = rasterColorMix;
    }
    if (rasterColorRange != null) {
      paint["raster-color-range"] = rasterColorRange;
    }
    if (rasterContrast != null) {
      paint["raster-contrast"] = rasterContrast;
    }
    if (rasterElevation != null) {
      paint["raster-elevation"] = rasterElevation;
    }
    if (rasterEmissiveStrength != null) {
      paint["raster-emissive-strength"] = rasterEmissiveStrength;
    }
    if (rasterFadeDuration != null) {
      paint["raster-fade-duration"] = rasterFadeDuration;
    }
    if (rasterHueRotate != null) {
      paint["raster-hue-rotate"] = rasterHueRotate;
    }
    if (rasterOpacity != null) {
      paint["raster-opacity"] = rasterOpacity;
    }
    if (rasterResampling != null) {
      paint["raster-resampling"] =
          rasterResampling?.toString().split('.').last.toLowerCase();
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
          : Visibility.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["visibility"])),
      rasterArrayBand: map["paint"]["raster-array-band"] is String?
          ? map["paint"]["raster-array-band"] as String?
          : null,
      rasterBrightnessMax: map["paint"]["raster-brightness-max"] is num?
          ? (map["paint"]["raster-brightness-max"] as num?)?.toDouble()
          : null,
      rasterBrightnessMin: map["paint"]["raster-brightness-min"] is num?
          ? (map["paint"]["raster-brightness-min"] as num?)?.toDouble()
          : null,
      rasterColor: (map["paint"]["raster-color"] as List?)?.toRGBAInt(),
      rasterColorMix: (map["paint"]["raster-color-mix"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      rasterColorRange: (map["paint"]["raster-color-range"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      rasterContrast: map["paint"]["raster-contrast"] is num?
          ? (map["paint"]["raster-contrast"] as num?)?.toDouble()
          : null,
      rasterElevation: map["paint"]["raster-elevation"] is num?
          ? (map["paint"]["raster-elevation"] as num?)?.toDouble()
          : null,
      rasterEmissiveStrength: map["paint"]["raster-emissive-strength"] is num?
          ? (map["paint"]["raster-emissive-strength"] as num?)?.toDouble()
          : null,
      rasterFadeDuration: map["paint"]["raster-fade-duration"] is num?
          ? (map["paint"]["raster-fade-duration"] as num?)?.toDouble()
          : null,
      rasterHueRotate: map["paint"]["raster-hue-rotate"] is num?
          ? (map["paint"]["raster-hue-rotate"] as num?)?.toDouble()
          : null,
      rasterOpacity: map["paint"]["raster-opacity"] is num?
          ? (map["paint"]["raster-opacity"] as num?)?.toDouble()
          : null,
      rasterResampling: map["paint"]["raster-resampling"] == null
          ? null
          : RasterResampling.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["paint"]["raster-resampling"])),
      rasterSaturation: map["paint"]["raster-saturation"] is num?
          ? (map["paint"]["raster-saturation"] as num?)?.toDouble()
          : null,
    );
  }
}

// End of generated file.
