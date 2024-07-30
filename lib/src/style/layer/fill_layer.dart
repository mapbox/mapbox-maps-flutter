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
    double? this.fillSortKey,
    List<Object>? this.fillSortKeyExpression,
    bool? this.fillAntialias,
    List<Object>? this.fillAntialiasExpression,
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

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used.
  /// Default value: "#000000".
  int? fillColor;

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used.
  /// Default value: "#000000".
  List<Object>? fillColorExpression;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0.
  double? fillEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0.
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
  /// Default value: [0,0].
  List<double?>? fillTranslate;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  /// Default value: [0,0].
  List<Object>? fillTranslateExpression;

  /// Controls the frame of reference for `fill-translate`.
  /// Default value: "map".
  FillTranslateAnchor? fillTranslateAnchor;

  /// Controls the frame of reference for `fill-translate`.
  /// Default value: "map".
  List<Object>? fillTranslateAnchorExpression;

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
      fillSortKey: _optionalCast(map["layout"]["fill-sort-key"]),
      fillSortKeyExpression: _optionalCastList(map["layout"]["fill-sort-key"]),
      fillAntialias: _optionalCast(map["paint"]["fill-antialias"]),
      fillAntialiasExpression:
          _optionalCastList(map["paint"]["fill-antialias"]),
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
    );
  }
}

// End of generated file.
