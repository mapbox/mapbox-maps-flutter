// This file is generated.
part of mapbox_maps_flutter;

/// A filled circle.
class CircleLayer extends Layer {
  CircleLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required String this.sourceId,
    String? this.sourceLayer,
    double? this.circleSortKey,
    List<Object>? this.circleSortKeyExpression,
    double? this.circleBlur,
    List<Object>? this.circleBlurExpression,
    int? this.circleColor,
    List<Object>? this.circleColorExpression,
    double? this.circleEmissiveStrength,
    List<Object>? this.circleEmissiveStrengthExpression,
    double? this.circleOpacity,
    List<Object>? this.circleOpacityExpression,
    CirclePitchAlignment? this.circlePitchAlignment,
    List<Object>? this.circlePitchAlignmentExpression,
    CirclePitchScale? this.circlePitchScale,
    List<Object>? this.circlePitchScaleExpression,
    double? this.circleRadius,
    List<Object>? this.circleRadiusExpression,
    int? this.circleStrokeColor,
    List<Object>? this.circleStrokeColorExpression,
    double? this.circleStrokeOpacity,
    List<Object>? this.circleStrokeOpacityExpression,
    double? this.circleStrokeWidth,
    List<Object>? this.circleStrokeWidthExpression,
    List<double?>? this.circleTranslate,
    List<Object>? this.circleTranslateExpression,
    CircleTranslateAnchor? this.circleTranslateAnchor,
    List<Object>? this.circleTranslateAnchorExpression,
  }) : super(
            id: id,
            visibility: visibility,
            visibilityExpression: visibilityExpression,
            filter: filter,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "circle";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? circleSortKey;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  List<Object>? circleSortKeyExpression;

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity. Setting a negative value renders the blur as an inner glow effect.
  /// Default value: 0.
  double? circleBlur;

  /// Amount to blur the circle. 1 blurs the circle such that only the centerpoint is full opacity. Setting a negative value renders the blur as an inner glow effect.
  /// Default value: 0.
  List<Object>? circleBlurExpression;

  /// The fill color of the circle.
  /// Default value: "#000000".
  int? circleColor;

  /// The fill color of the circle.
  /// Default value: "#000000".
  List<Object>? circleColorExpression;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0.
  double? circleEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0.
  List<Object>? circleEmissiveStrengthExpression;

  /// The opacity at which the circle will be drawn.
  /// Default value: 1. Value range: [0, 1]
  double? circleOpacity;

  /// The opacity at which the circle will be drawn.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? circleOpacityExpression;

  /// Orientation of circle when map is pitched.
  /// Default value: "viewport".
  CirclePitchAlignment? circlePitchAlignment;

  /// Orientation of circle when map is pitched.
  /// Default value: "viewport".
  List<Object>? circlePitchAlignmentExpression;

  /// Controls the scaling behavior of the circle when the map is pitched.
  /// Default value: "map".
  CirclePitchScale? circlePitchScale;

  /// Controls the scaling behavior of the circle when the map is pitched.
  /// Default value: "map".
  List<Object>? circlePitchScaleExpression;

  /// Circle radius.
  /// Default value: 5. Minimum value: 0.
  double? circleRadius;

  /// Circle radius.
  /// Default value: 5. Minimum value: 0.
  List<Object>? circleRadiusExpression;

  /// The stroke color of the circle.
  /// Default value: "#000000".
  int? circleStrokeColor;

  /// The stroke color of the circle.
  /// Default value: "#000000".
  List<Object>? circleStrokeColorExpression;

  /// The opacity of the circle's stroke.
  /// Default value: 1. Value range: [0, 1]
  double? circleStrokeOpacity;

  /// The opacity of the circle's stroke.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? circleStrokeOpacityExpression;

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`.
  /// Default value: 0. Minimum value: 0.
  double? circleStrokeWidth;

  /// The width of the circle's stroke. Strokes are placed outside of the `circle-radius`.
  /// Default value: 0. Minimum value: 0.
  List<Object>? circleStrokeWidthExpression;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  /// Default value: [0,0].
  List<double?>? circleTranslate;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  /// Default value: [0,0].
  List<Object>? circleTranslateExpression;

  /// Controls the frame of reference for `circle-translate`.
  /// Default value: "map".
  CircleTranslateAnchor? circleTranslateAnchor;

  /// Controls the frame of reference for `circle-translate`.
  /// Default value: "map".
  List<Object>? circleTranslateAnchorExpression;

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

    if (circleSortKeyExpression != null) {
      layout["circle-sort-key"] = circleSortKeyExpression;
    }

    if (circleSortKey != null) {
      layout["circle-sort-key"] = circleSortKey;
    }
    var paint = {};
    if (circleBlurExpression != null) {
      paint["circle-blur"] = circleBlurExpression;
    }
    if (circleBlur != null) {
      paint["circle-blur"] = circleBlur;
    }

    if (circleColorExpression != null) {
      paint["circle-color"] = circleColorExpression;
    }
    if (circleColor != null) {
      paint["circle-color"] = circleColor?.toRGBA();
    }

    if (circleEmissiveStrengthExpression != null) {
      paint["circle-emissive-strength"] = circleEmissiveStrengthExpression;
    }
    if (circleEmissiveStrength != null) {
      paint["circle-emissive-strength"] = circleEmissiveStrength;
    }

    if (circleOpacityExpression != null) {
      paint["circle-opacity"] = circleOpacityExpression;
    }
    if (circleOpacity != null) {
      paint["circle-opacity"] = circleOpacity;
    }

    if (circlePitchAlignmentExpression != null) {
      paint["circle-pitch-alignment"] = circlePitchAlignmentExpression;
    }
    if (circlePitchAlignment != null) {
      paint["circle-pitch-alignment"] =
          circlePitchAlignment?.name.toLowerCase().replaceAll("_", "-");
    }

    if (circlePitchScaleExpression != null) {
      paint["circle-pitch-scale"] = circlePitchScaleExpression;
    }
    if (circlePitchScale != null) {
      paint["circle-pitch-scale"] =
          circlePitchScale?.name.toLowerCase().replaceAll("_", "-");
    }

    if (circleRadiusExpression != null) {
      paint["circle-radius"] = circleRadiusExpression;
    }
    if (circleRadius != null) {
      paint["circle-radius"] = circleRadius;
    }

    if (circleStrokeColorExpression != null) {
      paint["circle-stroke-color"] = circleStrokeColorExpression;
    }
    if (circleStrokeColor != null) {
      paint["circle-stroke-color"] = circleStrokeColor?.toRGBA();
    }

    if (circleStrokeOpacityExpression != null) {
      paint["circle-stroke-opacity"] = circleStrokeOpacityExpression;
    }
    if (circleStrokeOpacity != null) {
      paint["circle-stroke-opacity"] = circleStrokeOpacity;
    }

    if (circleStrokeWidthExpression != null) {
      paint["circle-stroke-width"] = circleStrokeWidthExpression;
    }
    if (circleStrokeWidth != null) {
      paint["circle-stroke-width"] = circleStrokeWidth;
    }

    if (circleTranslateExpression != null) {
      paint["circle-translate"] = circleTranslateExpression;
    }
    if (circleTranslate != null) {
      paint["circle-translate"] = circleTranslate;
    }

    if (circleTranslateAnchorExpression != null) {
      paint["circle-translate-anchor"] = circleTranslateAnchorExpression;
    }
    if (circleTranslateAnchor != null) {
      paint["circle-translate-anchor"] =
          circleTranslateAnchor?.name.toLowerCase().replaceAll("_", "-");
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

  static CircleLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return CircleLayer(
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
      circleSortKey: _optionalCast(map["layout"]["circle-sort-key"]),
      circleSortKeyExpression:
          _optionalCastList(map["layout"]["circle-sort-key"]),
      circleBlur: _optionalCast(map["paint"]["circle-blur"]),
      circleBlurExpression: _optionalCastList(map["paint"]["circle-blur"]),
      circleColor: (map["paint"]["circle-color"] as List?)?.toRGBAInt(),
      circleColorExpression: _optionalCastList(map["paint"]["circle-color"]),
      circleEmissiveStrength:
          _optionalCast(map["paint"]["circle-emissive-strength"]),
      circleEmissiveStrengthExpression:
          _optionalCastList(map["paint"]["circle-emissive-strength"]),
      circleOpacity: _optionalCast(map["paint"]["circle-opacity"]),
      circleOpacityExpression:
          _optionalCastList(map["paint"]["circle-opacity"]),
      circlePitchAlignment: map["paint"]["circle-pitch-alignment"] == null
          ? null
          : CirclePitchAlignment.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["circle-pitch-alignment"])),
      circlePitchAlignmentExpression:
          _optionalCastList(map["paint"]["circle-pitch-alignment"]),
      circlePitchScale: map["paint"]["circle-pitch-scale"] == null
          ? null
          : CirclePitchScale.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["circle-pitch-scale"])),
      circlePitchScaleExpression:
          _optionalCastList(map["paint"]["circle-pitch-scale"]),
      circleRadius: _optionalCast(map["paint"]["circle-radius"]),
      circleRadiusExpression: _optionalCastList(map["paint"]["circle-radius"]),
      circleStrokeColor:
          (map["paint"]["circle-stroke-color"] as List?)?.toRGBAInt(),
      circleStrokeColorExpression:
          _optionalCastList(map["paint"]["circle-stroke-color"]),
      circleStrokeOpacity: _optionalCast(map["paint"]["circle-stroke-opacity"]),
      circleStrokeOpacityExpression:
          _optionalCastList(map["paint"]["circle-stroke-opacity"]),
      circleStrokeWidth: _optionalCast(map["paint"]["circle-stroke-width"]),
      circleStrokeWidthExpression:
          _optionalCastList(map["paint"]["circle-stroke-width"]),
      circleTranslate: (map["paint"]["circle-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      circleTranslateExpression:
          _optionalCastList(map["paint"]["circle-translate"]),
      circleTranslateAnchor: map["paint"]["circle-translate-anchor"] == null
          ? null
          : CircleTranslateAnchor.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["circle-translate-anchor"])),
      circleTranslateAnchorExpression:
          _optionalCastList(map["paint"]["circle-translate-anchor"]),
    );
  }
}

// End of generated file.
