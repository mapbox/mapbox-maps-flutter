// This file is generated.
part of mapbox_maps_flutter;

/// A stroked line.
class LineLayer extends Layer {
  LineLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required String this.sourceId,
    String? this.sourceLayer,
    LineCap? this.lineCap,
    List<Object>? this.lineCapExpression,
    double? this.lineCrossSlope,
    List<Object>? this.lineCrossSlopeExpression,
    LineElevationReference? this.lineElevationReference,
    List<Object>? this.lineElevationReferenceExpression,
    LineJoin? this.lineJoin,
    List<Object>? this.lineJoinExpression,
    double? this.lineMiterLimit,
    List<Object>? this.lineMiterLimitExpression,
    double? this.lineRoundLimit,
    List<Object>? this.lineRoundLimitExpression,
    double? this.lineSortKey,
    List<Object>? this.lineSortKeyExpression,
    LineWidthUnit? this.lineWidthUnit,
    List<Object>? this.lineWidthUnitExpression,
    double? this.lineZOffset,
    List<Object>? this.lineZOffsetExpression,
    double? this.lineBlur,
    List<Object>? this.lineBlurExpression,
    int? this.lineBorderColor,
    List<Object>? this.lineBorderColorExpression,
    double? this.lineBorderWidth,
    List<Object>? this.lineBorderWidthExpression,
    int? this.lineColor,
    List<Object>? this.lineColorExpression,
    List<double?>? this.lineDasharray,
    List<Object>? this.lineDasharrayExpression,
    double? this.lineDepthOcclusionFactor,
    List<Object>? this.lineDepthOcclusionFactorExpression,
    double? this.lineEmissiveStrength,
    List<Object>? this.lineEmissiveStrengthExpression,
    double? this.lineGapWidth,
    List<Object>? this.lineGapWidthExpression,
    int? this.lineGradient,
    List<Object>? this.lineGradientExpression,
    double? this.lineOcclusionOpacity,
    List<Object>? this.lineOcclusionOpacityExpression,
    double? this.lineOffset,
    List<Object>? this.lineOffsetExpression,
    double? this.lineOpacity,
    List<Object>? this.lineOpacityExpression,
    String? this.linePattern,
    List<Object>? this.linePatternExpression,
    double? this.linePatternCrossFade,
    List<Object>? this.linePatternCrossFadeExpression,
    List<double?>? this.lineTranslate,
    List<Object>? this.lineTranslateExpression,
    LineTranslateAnchor? this.lineTranslateAnchor,
    List<Object>? this.lineTranslateAnchorExpression,
    int? this.lineTrimColor,
    List<Object>? this.lineTrimColorExpression,
    List<double?>? this.lineTrimFadeRange,
    List<Object>? this.lineTrimFadeRangeExpression,
    List<double?>? this.lineTrimOffset,
    List<Object>? this.lineTrimOffsetExpression,
    double? this.lineWidth,
    List<Object>? this.lineWidthExpression,
  }) : super(
            id: id,
            visibility: visibility,
            visibilityExpression: visibilityExpression,
            filter: filter,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "line";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// The display of line endings.
  /// Default value: "butt".
  LineCap? lineCap;

  /// The display of line endings.
  /// Default value: "butt".
  List<Object>? lineCapExpression;

  /// Defines the slope of an elevated line. A value of 0 creates a horizontal line. A value of 1 creates a vertical line. Other values are currently not supported. If undefined, the line follows the terrain slope. This is an experimental property with some known issues:
  ///  - Vertical lines don't support line caps
  ///  - `line-join: round` is not supported with this property
  @experimental
  double? lineCrossSlope;

  /// Defines the slope of an elevated line. A value of 0 creates a horizontal line. A value of 1 creates a vertical line. Other values are currently not supported. If undefined, the line follows the terrain slope. This is an experimental property with some known issues:
  ///  - Vertical lines don't support line caps
  ///  - `line-join: round` is not supported with this property
  @experimental
  List<Object>? lineCrossSlopeExpression;

  /// Selects the base of line-elevation. Some modes might require precomputed elevation data in the tileset.
  /// Default value: "none".
  @experimental
  LineElevationReference? lineElevationReference;

  /// Selects the base of line-elevation. Some modes might require precomputed elevation data in the tileset.
  /// Default value: "none".
  @experimental
  List<Object>? lineElevationReferenceExpression;

  /// The display of lines when joining.
  /// Default value: "miter".
  LineJoin? lineJoin;

  /// The display of lines when joining.
  /// Default value: "miter".
  List<Object>? lineJoinExpression;

  /// Used to automatically convert miter joins to bevel joins for sharp angles.
  /// Default value: 2.
  double? lineMiterLimit;

  /// Used to automatically convert miter joins to bevel joins for sharp angles.
  /// Default value: 2.
  List<Object>? lineMiterLimitExpression;

  /// Used to automatically convert round joins to miter joins for shallow angles.
  /// Default value: 1.05.
  double? lineRoundLimit;

  /// Used to automatically convert round joins to miter joins for shallow angles.
  /// Default value: 1.05.
  List<Object>? lineRoundLimitExpression;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  double? lineSortKey;

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  List<Object>? lineSortKeyExpression;

  /// Selects the unit of line-width. The same unit is automatically used for line-blur and line-offset. Note: This is an experimental property and might be removed in a future release.
  /// Default value: "pixels".
  @experimental
  LineWidthUnit? lineWidthUnit;

  /// Selects the unit of line-width. The same unit is automatically used for line-blur and line-offset. Note: This is an experimental property and might be removed in a future release.
  /// Default value: "pixels".
  @experimental
  List<Object>? lineWidthUnitExpression;

  /// Vertical offset from ground, in meters. Defaults to 0. This is an experimental property with some known issues:
  ///  - Not supported for globe projection at the moment
  ///  - Elevated line discontinuity is possible on tile borders with terrain enabled
  ///  - Rendering artifacts can happen near line joins and line caps depending on the line styling
  ///  - Rendering artifacts relating to `line-opacity` and `line-blur`
  ///  - Elevated line visibility is determined by layer order
  ///  - Z-fighting issues can happen with intersecting elevated lines
  ///  - Elevated lines don't cast shadows
  /// Default value: 0.
  @experimental
  double? lineZOffset;

  /// Vertical offset from ground, in meters. Defaults to 0. This is an experimental property with some known issues:
  ///  - Not supported for globe projection at the moment
  ///  - Elevated line discontinuity is possible on tile borders with terrain enabled
  ///  - Rendering artifacts can happen near line joins and line caps depending on the line styling
  ///  - Rendering artifacts relating to `line-opacity` and `line-blur`
  ///  - Elevated line visibility is determined by layer order
  ///  - Z-fighting issues can happen with intersecting elevated lines
  ///  - Elevated lines don't cast shadows
  /// Default value: 0.
  @experimental
  List<Object>? lineZOffsetExpression;

  /// Blur applied to the line, in pixels.
  /// Default value: 0. Minimum value: 0. The unit of lineBlur is in pixels.
  double? lineBlur;

  /// Blur applied to the line, in pixels.
  /// Default value: 0. Minimum value: 0. The unit of lineBlur is in pixels.
  List<Object>? lineBlurExpression;

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color.
  /// Default value: "rgba(0, 0, 0, 0)".
  int? lineBorderColor;

  /// The color of the line border. If line-border-width is greater than zero and the alpha value of this color is 0 (default), the color for the border will be selected automatically based on the line color.
  /// Default value: "rgba(0, 0, 0, 0)".
  List<Object>? lineBorderColorExpression;

  /// The width of the line border. A value of zero means no border.
  /// Default value: 0. Minimum value: 0.
  double? lineBorderWidth;

  /// The width of the line border. A value of zero means no border.
  /// Default value: 0. Minimum value: 0.
  List<Object>? lineBorderWidthExpression;

  /// The color with which the line will be drawn.
  /// Default value: "#000000".
  int? lineColor;

  /// The color with which the line will be drawn.
  /// Default value: "#000000".
  List<Object>? lineColorExpression;

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  /// Minimum value: 0. The unit of lineDasharray is in line widths.
  List<double?>? lineDasharray;

  /// Specifies the lengths of the alternating dashes and gaps that form the dash pattern. The lengths are later scaled by the line width. To convert a dash length to pixels, multiply the length by the current line width. Note that GeoJSON sources with `lineMetrics: true` specified won't render dashed lines to the expected scale. Also note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  /// Minimum value: 0. The unit of lineDasharray is in line widths.
  List<Object>? lineDasharrayExpression;

  /// Decrease line layer opacity based on occlusion from 3D objects. Value 0 disables occlusion, value 1 means fully occluded.
  /// Default value: 1. Value range: [0, 1]
  double? lineDepthOcclusionFactor;

  /// Decrease line layer opacity based on occlusion from 3D objects. Value 0 disables occlusion, value 1 means fully occluded.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? lineDepthOcclusionFactorExpression;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0. The unit of lineEmissiveStrength is in intensity.
  double? lineEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0. The unit of lineEmissiveStrength is in intensity.
  List<Object>? lineEmissiveStrengthExpression;

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap.
  /// Default value: 0. Minimum value: 0. The unit of lineGapWidth is in pixels.
  double? lineGapWidth;

  /// Draws a line casing outside of a line's actual path. Value indicates the width of the inner gap.
  /// Default value: 0. Minimum value: 0. The unit of lineGapWidth is in pixels.
  List<Object>? lineGapWidthExpression;

  /// A gradient used to color a line feature at various distances along its length. Defined using a `step` or `interpolate` expression which outputs a color for each corresponding `line-progress` input value. `line-progress` is a percentage of the line feature's total length as measured on the webmercator projected coordinate plane (a `number` between `0` and `1`). Can only be used with GeoJSON sources that specify `"lineMetrics": true`.
  int? lineGradient;

  /// A gradient used to color a line feature at various distances along its length. Defined using a `step` or `interpolate` expression which outputs a color for each corresponding `line-progress` input value. `line-progress` is a percentage of the line feature's total length as measured on the webmercator projected coordinate plane (a `number` between `0` and `1`). Can only be used with GeoJSON sources that specify `"lineMetrics": true`.
  List<Object>? lineGradientExpression;

  /// Opacity multiplier (multiplies line-opacity value) of the line part that is occluded by 3D objects. Value 0 hides occluded part, value 1 means the same opacity as non-occluded part. The property is not supported when `line-opacity` has data-driven styling.
  /// Default value: 0. Value range: [0, 1]
  double? lineOcclusionOpacity;

  /// Opacity multiplier (multiplies line-opacity value) of the line part that is occluded by 3D objects. Value 0 hides occluded part, value 1 means the same opacity as non-occluded part. The property is not supported when `line-opacity` has data-driven styling.
  /// Default value: 0. Value range: [0, 1]
  List<Object>? lineOcclusionOpacityExpression;

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset.
  /// Default value: 0. The unit of lineOffset is in pixels.
  double? lineOffset;

  /// The line's offset. For linear features, a positive value offsets the line to the right, relative to the direction of the line, and a negative value to the left. For polygon features, a positive value results in an inset, and a negative value results in an outset.
  /// Default value: 0. The unit of lineOffset is in pixels.
  List<Object>? lineOffsetExpression;

  /// The opacity at which the line will be drawn.
  /// Default value: 1. Value range: [0, 1]
  double? lineOpacity;

  /// The opacity at which the line will be drawn.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? lineOpacityExpression;

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? linePattern;

  /// Name of image in sprite to use for drawing image lines. For seamless patterns, image width must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  List<Object>? linePatternExpression;

  /// Controls the transition progress between the image variants of line-pattern. Zero means the first variant is used, one is the second, and in between they are blended together. Both images should be the same size and have the same type (either raster or vector).
  /// Default value: 0. Value range: [0, 1]
  double? linePatternCrossFade;

  /// Controls the transition progress between the image variants of line-pattern. Zero means the first variant is used, one is the second, and in between they are blended together. Both images should be the same size and have the same type (either raster or vector).
  /// Default value: 0. Value range: [0, 1]
  List<Object>? linePatternCrossFadeExpression;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  /// Default value: [0,0]. The unit of lineTranslate is in pixels.
  List<double?>? lineTranslate;

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively.
  /// Default value: [0,0]. The unit of lineTranslate is in pixels.
  List<Object>? lineTranslateExpression;

  /// Controls the frame of reference for `line-translate`.
  /// Default value: "map".
  LineTranslateAnchor? lineTranslateAnchor;

  /// Controls the frame of reference for `line-translate`.
  /// Default value: "map".
  List<Object>? lineTranslateAnchorExpression;

  /// The color to be used for rendering the trimmed line section that is defined by the `line-trim-offset` property.
  /// Default value: "transparent".
  @experimental
  int? lineTrimColor;

  /// The color to be used for rendering the trimmed line section that is defined by the `line-trim-offset` property.
  /// Default value: "transparent".
  @experimental
  List<Object>? lineTrimColorExpression;

  /// The fade range for the trim-start and trim-end points is defined by the `line-trim-offset` property. The first element of the array represents the fade range from the trim-start point toward the end of the line, while the second element defines the fade range from the trim-end point toward the beginning of the line. The fade result is achieved by interpolating between `line-trim-color` and the color specified by the `line-color` or the `line-gradient` property.
  /// Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  @experimental
  List<double?>? lineTrimFadeRange;

  /// The fade range for the trim-start and trim-end points is defined by the `line-trim-offset` property. The first element of the array represents the fade range from the trim-start point toward the end of the line, while the second element defines the fade range from the trim-end point toward the beginning of the line. The fade result is achieved by interpolating between `line-trim-color` and the color specified by the `line-color` or the `line-gradient` property.
  /// Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  @experimental
  List<Object>? lineTrimFadeRangeExpression;

  /// The line part between [trim-start, trim-end] will be painted using `line-trim-color,` which is transparent by default to produce a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0].
  /// Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  List<double?>? lineTrimOffset;

  /// The line part between [trim-start, trim-end] will be painted using `line-trim-color,` which is transparent by default to produce a route vanishing effect. The line trim-off offset is based on the whole line range [0.0, 1.0].
  /// Default value: [0,0]. Minimum value: [0,0]. Maximum value: [1,1].
  List<Object>? lineTrimOffsetExpression;

  /// Stroke thickness.
  /// Default value: 1. Minimum value: 0. The unit of lineWidth is in pixels.
  double? lineWidth;

  /// Stroke thickness.
  /// Default value: 1. Minimum value: 0. The unit of lineWidth is in pixels.
  List<Object>? lineWidthExpression;

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

    if (lineCapExpression != null) {
      layout["line-cap"] = lineCapExpression;
    }

    if (lineCap != null) {
      layout["line-cap"] = lineCap?.name.toLowerCase().replaceAll("_", "-");
    }
    if (lineCrossSlopeExpression != null) {
      layout["line-cross-slope"] = lineCrossSlopeExpression;
    }

    if (lineCrossSlope != null) {
      layout["line-cross-slope"] = lineCrossSlope;
    }
    if (lineElevationReferenceExpression != null) {
      layout["line-elevation-reference"] = lineElevationReferenceExpression;
    }

    if (lineElevationReference != null) {
      layout["line-elevation-reference"] =
          lineElevationReference?.name.toLowerCase().replaceAll("_", "-");
    }
    if (lineJoinExpression != null) {
      layout["line-join"] = lineJoinExpression;
    }

    if (lineJoin != null) {
      layout["line-join"] = lineJoin?.name.toLowerCase().replaceAll("_", "-");
    }
    if (lineMiterLimitExpression != null) {
      layout["line-miter-limit"] = lineMiterLimitExpression;
    }

    if (lineMiterLimit != null) {
      layout["line-miter-limit"] = lineMiterLimit;
    }
    if (lineRoundLimitExpression != null) {
      layout["line-round-limit"] = lineRoundLimitExpression;
    }

    if (lineRoundLimit != null) {
      layout["line-round-limit"] = lineRoundLimit;
    }
    if (lineSortKeyExpression != null) {
      layout["line-sort-key"] = lineSortKeyExpression;
    }

    if (lineSortKey != null) {
      layout["line-sort-key"] = lineSortKey;
    }
    if (lineWidthUnitExpression != null) {
      layout["line-width-unit"] = lineWidthUnitExpression;
    }

    if (lineWidthUnit != null) {
      layout["line-width-unit"] =
          lineWidthUnit?.name.toLowerCase().replaceAll("_", "-");
    }
    if (lineZOffsetExpression != null) {
      layout["line-z-offset"] = lineZOffsetExpression;
    }

    if (lineZOffset != null) {
      layout["line-z-offset"] = lineZOffset;
    }
    var paint = {};
    if (lineBlurExpression != null) {
      paint["line-blur"] = lineBlurExpression;
    } else if (lineBlur != null) {
      paint["line-blur"] = lineBlur;
    }

    if (lineBorderColorExpression != null) {
      paint["line-border-color"] = lineBorderColorExpression;
    } else if (lineBorderColor != null) {
      paint["line-border-color"] = lineBorderColor?.toRGBA();
    }

    if (lineBorderWidthExpression != null) {
      paint["line-border-width"] = lineBorderWidthExpression;
    } else if (lineBorderWidth != null) {
      paint["line-border-width"] = lineBorderWidth;
    }

    if (lineColorExpression != null) {
      paint["line-color"] = lineColorExpression;
    } else if (lineColor != null) {
      paint["line-color"] = lineColor?.toRGBA();
    }

    if (lineDasharrayExpression != null) {
      paint["line-dasharray"] = lineDasharrayExpression;
    } else if (lineDasharray != null) {
      paint["line-dasharray"] = lineDasharray;
    }

    if (lineDepthOcclusionFactorExpression != null) {
      paint["line-depth-occlusion-factor"] = lineDepthOcclusionFactorExpression;
    } else if (lineDepthOcclusionFactor != null) {
      paint["line-depth-occlusion-factor"] = lineDepthOcclusionFactor;
    }

    if (lineEmissiveStrengthExpression != null) {
      paint["line-emissive-strength"] = lineEmissiveStrengthExpression;
    } else if (lineEmissiveStrength != null) {
      paint["line-emissive-strength"] = lineEmissiveStrength;
    }

    if (lineGapWidthExpression != null) {
      paint["line-gap-width"] = lineGapWidthExpression;
    } else if (lineGapWidth != null) {
      paint["line-gap-width"] = lineGapWidth;
    }

    if (lineGradientExpression != null) {
      paint["line-gradient"] = lineGradientExpression;
    } else if (lineGradient != null) {
      paint["line-gradient"] = lineGradient?.toRGBA();
    }

    if (lineOcclusionOpacityExpression != null) {
      paint["line-occlusion-opacity"] = lineOcclusionOpacityExpression;
    } else if (lineOcclusionOpacity != null) {
      paint["line-occlusion-opacity"] = lineOcclusionOpacity;
    }

    if (lineOffsetExpression != null) {
      paint["line-offset"] = lineOffsetExpression;
    } else if (lineOffset != null) {
      paint["line-offset"] = lineOffset;
    }

    if (lineOpacityExpression != null) {
      paint["line-opacity"] = lineOpacityExpression;
    } else if (lineOpacity != null) {
      paint["line-opacity"] = lineOpacity;
    }

    if (linePatternExpression != null) {
      paint["line-pattern"] = linePatternExpression;
    } else if (linePattern != null) {
      paint["line-pattern"] = linePattern;
    }

    if (linePatternCrossFadeExpression != null) {
      paint["line-pattern-cross-fade"] = linePatternCrossFadeExpression;
    } else if (linePatternCrossFade != null) {
      paint["line-pattern-cross-fade"] = linePatternCrossFade;
    }

    if (lineTranslateExpression != null) {
      paint["line-translate"] = lineTranslateExpression;
    } else if (lineTranslate != null) {
      paint["line-translate"] = lineTranslate;
    }

    if (lineTranslateAnchorExpression != null) {
      paint["line-translate-anchor"] = lineTranslateAnchorExpression;
    } else if (lineTranslateAnchor != null) {
      paint["line-translate-anchor"] =
          lineTranslateAnchor?.name.toLowerCase().replaceAll("_", "-");
    }

    if (lineTrimColorExpression != null) {
      paint["line-trim-color"] = lineTrimColorExpression;
    } else if (lineTrimColor != null) {
      paint["line-trim-color"] = lineTrimColor?.toRGBA();
    }

    if (lineTrimFadeRangeExpression != null) {
      paint["line-trim-fade-range"] = lineTrimFadeRangeExpression;
    } else if (lineTrimFadeRange != null) {
      paint["line-trim-fade-range"] = lineTrimFadeRange;
    }

    if (lineTrimOffsetExpression != null) {
      paint["line-trim-offset"] = lineTrimOffsetExpression;
    } else if (lineTrimOffset != null) {
      paint["line-trim-offset"] = lineTrimOffset;
    }

    if (lineWidthExpression != null) {
      paint["line-width"] = lineWidthExpression;
    } else if (lineWidth != null) {
      paint["line-width"] = lineWidth;
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

  static LineLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return LineLayer(
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
      lineCap: map["layout"]["line-cap"] == null
          ? null
          : LineCap.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["line-cap"])),
      lineCapExpression: _optionalCastList(map["layout"]["line-cap"]),
      lineCrossSlope: _optionalCast(map["layout"]["line-cross-slope"]),
      lineCrossSlopeExpression:
          _optionalCastList(map["layout"]["line-cross-slope"]),
      lineElevationReference: map["layout"]["line-elevation-reference"] == null
          ? null
          : LineElevationReference.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["line-elevation-reference"])),
      lineElevationReferenceExpression:
          _optionalCastList(map["layout"]["line-elevation-reference"]),
      lineJoin: map["layout"]["line-join"] == null
          ? null
          : LineJoin.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["line-join"])),
      lineJoinExpression: _optionalCastList(map["layout"]["line-join"]),
      lineMiterLimit: _optionalCast(map["layout"]["line-miter-limit"]),
      lineMiterLimitExpression:
          _optionalCastList(map["layout"]["line-miter-limit"]),
      lineRoundLimit: _optionalCast(map["layout"]["line-round-limit"]),
      lineRoundLimitExpression:
          _optionalCastList(map["layout"]["line-round-limit"]),
      lineSortKey: _optionalCast(map["layout"]["line-sort-key"]),
      lineSortKeyExpression: _optionalCastList(map["layout"]["line-sort-key"]),
      lineWidthUnit: map["layout"]["line-width-unit"] == null
          ? null
          : LineWidthUnit.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["line-width-unit"])),
      lineWidthUnitExpression:
          _optionalCastList(map["layout"]["line-width-unit"]),
      lineZOffset: _optionalCast(map["layout"]["line-z-offset"]),
      lineZOffsetExpression: _optionalCastList(map["layout"]["line-z-offset"]),
      lineBlur: _optionalCast(map["paint"]["line-blur"]),
      lineBlurExpression: _optionalCastList(map["paint"]["line-blur"]),
      lineBorderColor:
          (map["paint"]["line-border-color"] as List?)?.toRGBAInt(),
      lineBorderColorExpression:
          _optionalCastList(map["paint"]["line-border-color"]),
      lineBorderWidth: _optionalCast(map["paint"]["line-border-width"]),
      lineBorderWidthExpression:
          _optionalCastList(map["paint"]["line-border-width"]),
      lineColor: (map["paint"]["line-color"] as List?)?.toRGBAInt(),
      lineColorExpression: _optionalCastList(map["paint"]["line-color"]),
      lineDasharray: (map["paint"]["line-dasharray"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      lineDasharrayExpression:
          _optionalCastList(map["paint"]["line-dasharray"]),
      lineDepthOcclusionFactor:
          _optionalCast(map["paint"]["line-depth-occlusion-factor"]),
      lineDepthOcclusionFactorExpression:
          _optionalCastList(map["paint"]["line-depth-occlusion-factor"]),
      lineEmissiveStrength:
          _optionalCast(map["paint"]["line-emissive-strength"]),
      lineEmissiveStrengthExpression:
          _optionalCastList(map["paint"]["line-emissive-strength"]),
      lineGapWidth: _optionalCast(map["paint"]["line-gap-width"]),
      lineGapWidthExpression: _optionalCastList(map["paint"]["line-gap-width"]),
      lineGradient: (map["paint"]["line-gradient"] as List?)?.toRGBAInt(),
      lineGradientExpression: _optionalCastList(map["paint"]["line-gradient"]),
      lineOcclusionOpacity:
          _optionalCast(map["paint"]["line-occlusion-opacity"]),
      lineOcclusionOpacityExpression:
          _optionalCastList(map["paint"]["line-occlusion-opacity"]),
      lineOffset: _optionalCast(map["paint"]["line-offset"]),
      lineOffsetExpression: _optionalCastList(map["paint"]["line-offset"]),
      lineOpacity: _optionalCast(map["paint"]["line-opacity"]),
      lineOpacityExpression: _optionalCastList(map["paint"]["line-opacity"]),
      linePattern: _optionalCast(map["paint"]["line-pattern"]),
      linePatternExpression: _optionalCastList(map["paint"]["line-pattern"]),
      linePatternCrossFade:
          _optionalCast(map["paint"]["line-pattern-cross-fade"]),
      linePatternCrossFadeExpression:
          _optionalCastList(map["paint"]["line-pattern-cross-fade"]),
      lineTranslate: (map["paint"]["line-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      lineTranslateExpression:
          _optionalCastList(map["paint"]["line-translate"]),
      lineTranslateAnchor: map["paint"]["line-translate-anchor"] == null
          ? null
          : LineTranslateAnchor.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["line-translate-anchor"])),
      lineTranslateAnchorExpression:
          _optionalCastList(map["paint"]["line-translate-anchor"]),
      lineTrimColor: (map["paint"]["line-trim-color"] as List?)?.toRGBAInt(),
      lineTrimColorExpression:
          _optionalCastList(map["paint"]["line-trim-color"]),
      lineTrimFadeRange: (map["paint"]["line-trim-fade-range"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      lineTrimFadeRangeExpression:
          _optionalCastList(map["paint"]["line-trim-fade-range"]),
      lineTrimOffset: (map["paint"]["line-trim-offset"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      lineTrimOffsetExpression:
          _optionalCastList(map["paint"]["line-trim-offset"]),
      lineWidth: _optionalCast(map["paint"]["line-width"]),
      lineWidthExpression: _optionalCastList(map["paint"]["line-width"]),
    );
  }
}

// End of generated file.
