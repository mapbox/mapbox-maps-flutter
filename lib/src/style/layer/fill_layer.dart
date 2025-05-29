// This file is generated.
part of mapbox_maps_flutter;

/// A filled polygon with an optional stroked border.
class FillLayer extends Layer {
  FillLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required String this.sourceId,
    String? this.sourceLayer,
    bool? this.fillConstructBridgeGuardRail,
    List<Object>? this.fillConstructBridgeGuardRailExpression,
    FillElevationReference? this.fillElevationReference,
    List<Object>? this.fillElevationReferenceExpression,
    double? this.fillSortKey,
    List<Object>? this.fillSortKeyExpression,
    bool? this.fillAntialias,
    List<Object>? this.fillAntialiasExpression,
    int? this.fillBridgeGuardRailColor,
    List<Object>? this.fillBridgeGuardRailColorExpression,
    int? this.fillColor,
    List<Object>? this.fillColorExpression,
    double? this.fillEmissiveStrength,
    List<Object>? this.fillEmissiveStrengthExpression,
    double? this.fillOpacity,
    List<Object>? this.fillOpacityExpression,
    int? this.fillOutlineColor,
    List<Object>? this.fillOutlineColorExpression,
    String? this.fillPattern,
    List<Object>? this.fillPatternExpression,
    List<double?>? this.fillTranslate,
    List<Object>? this.fillTranslateExpression,
    FillTranslateAnchor? this.fillTranslateAnchor,
    List<Object>? this.fillTranslateAnchorExpression,
    int? this.fillTunnelStructureColor,
    List<Object>? this.fillTunnelStructureColorExpression,
    double? this.fillZOffset,
    List<Object>? this.fillZOffsetExpression,
  }) : super(
            id: id,
            visibility: visibility,
            visibilityExpression: visibilityExpression,
            filter: filter,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "fill";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Determines whether bridge guard rails are added for elevated roads.
  /// Default value: "true".
  @experimental
  bool? fillConstructBridgeGuardRail;

  /// Determines whether bridge guard rails are added for elevated roads.
  /// Default value: "true".
  @experimental
  List<Object>? fillConstructBridgeGuardRailExpression;

  /// Selects the base of fill-elevation. Some modes might require precomputed elevation data in the tileset.
  /// Default value: "none".
  @experimental
  FillElevationReference? fillElevationReference;

  /// Selects the base of fill-elevation. Some modes might require precomputed elevation data in the tileset.
  /// Default value: "none".
  @experimental
  List<Object>? fillElevationReferenceExpression;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? fillSortKey;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  List<Object>? fillSortKeyExpression;

  /// Whether or not the fill should be antialiased.
  /// Default value: true.
  bool? fillAntialias;

  /// Whether or not the fill should be antialiased.
  /// Default value: true.
  List<Object>? fillAntialiasExpression;

  /// The color of bridge guard rail.
  /// Default value: "rgba(241, 236, 225, 255)".
  @experimental
  int? fillBridgeGuardRailColor;

  /// The color of bridge guard rail.
  /// Default value: "rgba(241, 236, 225, 255)".
  @experimental
  List<Object>? fillBridgeGuardRailColorExpression;

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used.
  /// Default value: "#000000".
  int? fillColor;

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used.
  /// Default value: "#000000".
  List<Object>? fillColorExpression;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0. The unit of fillEmissiveStrength is in intensity.
  double? fillEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0. The unit of fillEmissiveStrength is in intensity.
  List<Object>? fillEmissiveStrengthExpression;

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used.
  /// Default value: 1. Value range: [0, 1]
  double? fillOpacity;

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? fillOpacityExpression;

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  int? fillOutlineColor;

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  List<Object>? fillOutlineColorExpression;

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? fillPattern;

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  List<Object>? fillPatternExpression;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  /// Default value: [0,0]. The unit of fillTranslate is in pixels.
  List<double?>? fillTranslate;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  /// Default value: [0,0]. The unit of fillTranslate is in pixels.
  List<Object>? fillTranslateExpression;

  /// Controls the frame of reference for `fill-translate`.
  /// Default value: "map".
  FillTranslateAnchor? fillTranslateAnchor;

  /// Controls the frame of reference for `fill-translate`.
  /// Default value: "map".
  List<Object>? fillTranslateAnchorExpression;

  /// The color of tunnel structures (tunnel entrance and tunnel walls).
  /// Default value: "rgba(241, 236, 225, 255)".
  @experimental
  int? fillTunnelStructureColor;

  /// The color of tunnel structures (tunnel entrance and tunnel walls).
  /// Default value: "rgba(241, 236, 225, 255)".
  @experimental
  List<Object>? fillTunnelStructureColorExpression;

  /// Specifies an uniform elevation in meters. Note: If the value is zero, the layer will be rendered on the ground. Non-zero values will elevate the layer from the sea level, which can cause it to be rendered below the terrain.
  /// Default value: 0. Minimum value: 0.
  @experimental
  double? fillZOffset;

  /// Specifies an uniform elevation in meters. Note: If the value is zero, the layer will be rendered on the ground. Non-zero values will elevate the layer from the sea level, which can cause it to be rendered below the terrain.
  /// Default value: 0. Minimum value: 0.
  @experimental
  List<Object>? fillZOffsetExpression;

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

    if (fillConstructBridgeGuardRailExpression != null) {
      layout["fill-construct-bridge-guard-rail"] =
          fillConstructBridgeGuardRailExpression;
    }

    if (fillConstructBridgeGuardRail != null) {
      layout["fill-construct-bridge-guard-rail"] = fillConstructBridgeGuardRail;
    }
    if (fillElevationReferenceExpression != null) {
      layout["fill-elevation-reference"] = fillElevationReferenceExpression;
    }

    if (fillElevationReference != null) {
      layout["fill-elevation-reference"] =
          fillElevationReference?.name.toLowerCase().replaceAll("_", "-");
    }
    if (fillSortKeyExpression != null) {
      layout["fill-sort-key"] = fillSortKeyExpression;
    }

    if (fillSortKey != null) {
      layout["fill-sort-key"] = fillSortKey;
    }
    var paint = {};
    if (fillAntialiasExpression != null) {
      paint["fill-antialias"] = fillAntialiasExpression;
    }
    if (fillAntialias != null) {
      paint["fill-antialias"] = fillAntialias;
    }

    if (fillBridgeGuardRailColorExpression != null) {
      paint["fill-bridge-guard-rail-color"] =
          fillBridgeGuardRailColorExpression;
    }
    if (fillBridgeGuardRailColor != null) {
      paint["fill-bridge-guard-rail-color"] =
          fillBridgeGuardRailColor?.toRGBA();
    }

    if (fillColorExpression != null) {
      paint["fill-color"] = fillColorExpression;
    }
    if (fillColor != null) {
      paint["fill-color"] = fillColor?.toRGBA();
    }

    if (fillEmissiveStrengthExpression != null) {
      paint["fill-emissive-strength"] = fillEmissiveStrengthExpression;
    }
    if (fillEmissiveStrength != null) {
      paint["fill-emissive-strength"] = fillEmissiveStrength;
    }

    if (fillOpacityExpression != null) {
      paint["fill-opacity"] = fillOpacityExpression;
    }
    if (fillOpacity != null) {
      paint["fill-opacity"] = fillOpacity;
    }

    if (fillOutlineColorExpression != null) {
      paint["fill-outline-color"] = fillOutlineColorExpression;
    }
    if (fillOutlineColor != null) {
      paint["fill-outline-color"] = fillOutlineColor?.toRGBA();
    }

    if (fillPatternExpression != null) {
      paint["fill-pattern"] = fillPatternExpression;
    }
    if (fillPattern != null) {
      paint["fill-pattern"] = fillPattern;
    }

    if (fillTranslateExpression != null) {
      paint["fill-translate"] = fillTranslateExpression;
    }
    if (fillTranslate != null) {
      paint["fill-translate"] = fillTranslate;
    }

    if (fillTranslateAnchorExpression != null) {
      paint["fill-translate-anchor"] = fillTranslateAnchorExpression;
    }
    if (fillTranslateAnchor != null) {
      paint["fill-translate-anchor"] =
          fillTranslateAnchor?.name.toLowerCase().replaceAll("_", "-");
    }

    if (fillTunnelStructureColorExpression != null) {
      paint["fill-tunnel-structure-color"] = fillTunnelStructureColorExpression;
    }
    if (fillTunnelStructureColor != null) {
      paint["fill-tunnel-structure-color"] = fillTunnelStructureColor?.toRGBA();
    }

    if (fillZOffsetExpression != null) {
      paint["fill-z-offset"] = fillZOffsetExpression;
    }
    if (fillZOffset != null) {
      paint["fill-z-offset"] = fillZOffset;
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

  static FillLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return FillLayer(
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
      fillConstructBridgeGuardRail:
          _optionalCast(map["layout"]["fill-construct-bridge-guard-rail"]),
      fillConstructBridgeGuardRailExpression:
          _optionalCastList(map["layout"]["fill-construct-bridge-guard-rail"]),
      fillElevationReference: map["layout"]["fill-elevation-reference"] == null
          ? null
          : FillElevationReference.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["fill-elevation-reference"])),
      fillElevationReferenceExpression:
          _optionalCastList(map["layout"]["fill-elevation-reference"]),
      fillSortKey: _optionalCast(map["layout"]["fill-sort-key"]),
      fillSortKeyExpression: _optionalCastList(map["layout"]["fill-sort-key"]),
      fillAntialias: _optionalCast(map["paint"]["fill-antialias"]),
      fillAntialiasExpression:
          _optionalCastList(map["paint"]["fill-antialias"]),
      fillBridgeGuardRailColor:
          (map["paint"]["fill-bridge-guard-rail-color"] as List?)?.toRGBAInt(),
      fillBridgeGuardRailColorExpression:
          _optionalCastList(map["paint"]["fill-bridge-guard-rail-color"]),
      fillColor: (map["paint"]["fill-color"] as List?)?.toRGBAInt(),
      fillColorExpression: _optionalCastList(map["paint"]["fill-color"]),
      fillEmissiveStrength:
          _optionalCast(map["paint"]["fill-emissive-strength"]),
      fillEmissiveStrengthExpression:
          _optionalCastList(map["paint"]["fill-emissive-strength"]),
      fillOpacity: _optionalCast(map["paint"]["fill-opacity"]),
      fillOpacityExpression: _optionalCastList(map["paint"]["fill-opacity"]),
      fillOutlineColor:
          (map["paint"]["fill-outline-color"] as List?)?.toRGBAInt(),
      fillOutlineColorExpression:
          _optionalCastList(map["paint"]["fill-outline-color"]),
      fillPattern: _optionalCast(map["paint"]["fill-pattern"]),
      fillPatternExpression: _optionalCastList(map["paint"]["fill-pattern"]),
      fillTranslate: (map["paint"]["fill-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      fillTranslateExpression:
          _optionalCastList(map["paint"]["fill-translate"]),
      fillTranslateAnchor: map["paint"]["fill-translate-anchor"] == null
          ? null
          : FillTranslateAnchor.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["fill-translate-anchor"])),
      fillTranslateAnchorExpression:
          _optionalCastList(map["paint"]["fill-translate-anchor"]),
      fillTunnelStructureColor:
          (map["paint"]["fill-tunnel-structure-color"] as List?)?.toRGBAInt(),
      fillTunnelStructureColorExpression:
          _optionalCastList(map["paint"]["fill-tunnel-structure-color"]),
      fillZOffset: _optionalCast(map["paint"]["fill-z-offset"]),
      fillZOffsetExpression: _optionalCastList(map["paint"]["fill-z-offset"]),
    );
  }
}

// End of generated file.
