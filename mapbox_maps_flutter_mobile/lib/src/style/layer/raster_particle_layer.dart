// This file is generated.
part of mapbox_maps_flutter;

/// Particle animation driven by textures such as wind maps.
@experimental
class RasterParticleLayer extends Layer {
  RasterParticleLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required String this.sourceId,
    String? this.sourceLayer,
    String? this.rasterParticleArrayBand,
    List<Object>? this.rasterParticleArrayBandExpression,
    int? this.rasterParticleColor,
    List<Object>? this.rasterParticleColorExpression,
    double? this.rasterParticleCount,
    List<Object>? this.rasterParticleCountExpression,
    double? this.rasterParticleFadeOpacityFactor,
    List<Object>? this.rasterParticleFadeOpacityFactorExpression,
    double? this.rasterParticleMaxSpeed,
    List<Object>? this.rasterParticleMaxSpeedExpression,
    double? this.rasterParticleResetRateFactor,
    List<Object>? this.rasterParticleResetRateFactorExpression,
    double? this.rasterParticleSpeedFactor,
    List<Object>? this.rasterParticleSpeedFactorExpression,
  }) : super(
            id: id,
            visibility: visibility,
            visibilityExpression: visibilityExpression,
            filter: filter,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "raster-particle";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Displayed band of raster array source layer
  @experimental
  String? rasterParticleArrayBand;

  /// Displayed band of raster array source layer
  @experimental
  List<Object>? rasterParticleArrayBandExpression;

  /// Defines a color map by which to colorize a raster particle layer, parameterized by the `["raster-particle-speed"]` expression and evaluated at 256 uniformly spaced steps over the range specified by `raster-particle-max-speed`.
  @experimental
  int? rasterParticleColor;

  /// Defines a color map by which to colorize a raster particle layer, parameterized by the `["raster-particle-speed"]` expression and evaluated at 256 uniformly spaced steps over the range specified by `raster-particle-max-speed`.
  @experimental
  List<Object>? rasterParticleColorExpression;

  /// Defines the amount of particles per tile.
  /// Default value: 512. Minimum value: 1.
  @experimental
  double? rasterParticleCount;

  /// Defines the amount of particles per tile.
  /// Default value: 512. Minimum value: 1.
  @experimental
  List<Object>? rasterParticleCountExpression;

  /// Defines defines the opacity coefficient applied to the faded particles in each frame. In practice, this property controls the length of the particle tail.
  /// Default value: 0.98. Value range: [0, 1]
  @experimental
  double? rasterParticleFadeOpacityFactor;

  /// Defines defines the opacity coefficient applied to the faded particles in each frame. In practice, this property controls the length of the particle tail.
  /// Default value: 0.98. Value range: [0, 1]
  @experimental
  List<Object>? rasterParticleFadeOpacityFactorExpression;

  /// Defines the maximum speed for particles. Velocities with magnitudes equal to or exceeding this value are clamped to the max value.
  /// Default value: 1. Minimum value: 1.
  @experimental
  double? rasterParticleMaxSpeed;

  /// Defines the maximum speed for particles. Velocities with magnitudes equal to or exceeding this value are clamped to the max value.
  /// Default value: 1. Minimum value: 1.
  @experimental
  List<Object>? rasterParticleMaxSpeedExpression;

  /// Defines a coefficient for a time period at which particles will restart at a random position, to avoid degeneration (empty areas without particles).
  /// Default value: 0.8. Value range: [0, 1]
  @experimental
  double? rasterParticleResetRateFactor;

  /// Defines a coefficient for a time period at which particles will restart at a random position, to avoid degeneration (empty areas without particles).
  /// Default value: 0.8. Value range: [0, 1]
  @experimental
  List<Object>? rasterParticleResetRateFactorExpression;

  /// Defines a coefficient for the speed of particles’ motion.
  /// Default value: 0.2. Value range: [0, 1]
  @experimental
  double? rasterParticleSpeedFactor;

  /// Defines a coefficient for the speed of particles’ motion.
  /// Default value: 0.2. Value range: [0, 1]
  @experimental
  List<Object>? rasterParticleSpeedFactorExpression;

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
    if (rasterParticleArrayBandExpression != null) {
      paint["raster-particle-array-band"] = rasterParticleArrayBandExpression;
    }
    if (rasterParticleArrayBand != null) {
      paint["raster-particle-array-band"] = rasterParticleArrayBand;
    }

    if (rasterParticleColorExpression != null) {
      paint["raster-particle-color"] = rasterParticleColorExpression;
    }
    if (rasterParticleColor != null) {
      paint["raster-particle-color"] = rasterParticleColor?.toRGBA();
    }

    if (rasterParticleCountExpression != null) {
      paint["raster-particle-count"] = rasterParticleCountExpression;
    }
    if (rasterParticleCount != null) {
      paint["raster-particle-count"] = rasterParticleCount;
    }

    if (rasterParticleFadeOpacityFactorExpression != null) {
      paint["raster-particle-fade-opacity-factor"] =
          rasterParticleFadeOpacityFactorExpression;
    }
    if (rasterParticleFadeOpacityFactor != null) {
      paint["raster-particle-fade-opacity-factor"] =
          rasterParticleFadeOpacityFactor;
    }

    if (rasterParticleMaxSpeedExpression != null) {
      paint["raster-particle-max-speed"] = rasterParticleMaxSpeedExpression;
    }
    if (rasterParticleMaxSpeed != null) {
      paint["raster-particle-max-speed"] = rasterParticleMaxSpeed;
    }

    if (rasterParticleResetRateFactorExpression != null) {
      paint["raster-particle-reset-rate-factor"] =
          rasterParticleResetRateFactorExpression;
    }
    if (rasterParticleResetRateFactor != null) {
      paint["raster-particle-reset-rate-factor"] =
          rasterParticleResetRateFactor;
    }

    if (rasterParticleSpeedFactorExpression != null) {
      paint["raster-particle-speed-factor"] =
          rasterParticleSpeedFactorExpression;
    }
    if (rasterParticleSpeedFactor != null) {
      paint["raster-particle-speed-factor"] = rasterParticleSpeedFactor;
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

  static RasterParticleLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return RasterParticleLayer(
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
      rasterParticleArrayBand:
          _optionalCast(map["paint"]["raster-particle-array-band"]),
      rasterParticleArrayBandExpression:
          _optionalCastList(map["paint"]["raster-particle-array-band"]),
      rasterParticleColor:
          (map["paint"]["raster-particle-color"] as List?)?.toRGBAInt(),
      rasterParticleColorExpression:
          _optionalCastList(map["paint"]["raster-particle-color"]),
      rasterParticleCount: _optionalCast(map["paint"]["raster-particle-count"]),
      rasterParticleCountExpression:
          _optionalCastList(map["paint"]["raster-particle-count"]),
      rasterParticleFadeOpacityFactor:
          _optionalCast(map["paint"]["raster-particle-fade-opacity-factor"]),
      rasterParticleFadeOpacityFactorExpression: _optionalCastList(
          map["paint"]["raster-particle-fade-opacity-factor"]),
      rasterParticleMaxSpeed:
          _optionalCast(map["paint"]["raster-particle-max-speed"]),
      rasterParticleMaxSpeedExpression:
          _optionalCastList(map["paint"]["raster-particle-max-speed"]),
      rasterParticleResetRateFactor:
          _optionalCast(map["paint"]["raster-particle-reset-rate-factor"]),
      rasterParticleResetRateFactorExpression:
          _optionalCastList(map["paint"]["raster-particle-reset-rate-factor"]),
      rasterParticleSpeedFactor:
          _optionalCast(map["paint"]["raster-particle-speed-factor"]),
      rasterParticleSpeedFactorExpression:
          _optionalCastList(map["paint"]["raster-particle-speed-factor"]),
    );
  }
}

// End of generated file.
