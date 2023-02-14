// This file is generated.
part of mapbox_maps_flutter;

/// Raster map textures such as satellite imagery.
class RasterLayer extends Layer {
  RasterLayer({
    required id,
    visibility,
    minZoom,
    maxZoom,
    required this.sourceId,
    this.sourceLayer,
    this.rasterBrightnessMax,
    this.rasterBrightnessMin,
    this.rasterContrast,
    this.rasterFadeDuration,
    this.rasterHueRotate,
    this.rasterOpacity,
    this.rasterResampling,
    this.rasterSaturation,
  }) : super(
            id: id, visibility: visibility, maxZoom: maxZoom, minZoom: minZoom);

  @override
  String getType() => "raster";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Increase or reduce the brightness of the image. The value is the maximum brightness.
  double? rasterBrightnessMax;

  /// Increase or reduce the brightness of the image. The value is the minimum brightness.
  double? rasterBrightnessMin;

  /// Increase or reduce the contrast of the image.
  double? rasterContrast;

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
    if (rasterBrightnessMax != null) {
      paint["raster-brightness-max"] = rasterBrightnessMax;
    }
    if (rasterBrightnessMin != null) {
      paint["raster-brightness-min"] = rasterBrightnessMin;
    }
    if (rasterContrast != null) {
      paint["raster-contrast"] = rasterContrast;
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
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["visibility"])),
      rasterBrightnessMax: map["paint"]["raster-brightness-max"] is num?
          ? (map["paint"]["raster-brightness-max"] as num?)?.toDouble()
          : null,
      rasterBrightnessMin: map["paint"]["raster-brightness-min"] is num?
          ? (map["paint"]["raster-brightness-min"] as num?)?.toDouble()
          : null,
      rasterContrast: map["paint"]["raster-contrast"] is num?
          ? (map["paint"]["raster-contrast"] as num?)?.toDouble()
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
