// This file is generated.
part of mapbox_maps_flutter;

/// An icon or a text label.
class SymbolLayer extends Layer {
  SymbolLayer({
    required id,
    visibility,
    minZoom,
    maxZoom,
    required this.sourceId,
    this.sourceLayer,
    this.iconAllowOverlap,
    this.iconAnchor,
    this.iconIgnorePlacement,
    this.iconImage,
    this.iconKeepUpright,
    this.iconOffset,
    this.iconOptional,
    this.iconPadding,
    this.iconPitchAlignment,
    this.iconRotate,
    this.iconRotationAlignment,
    this.iconSize,
    this.iconTextFit,
    this.iconTextFitPadding,
    this.symbolAvoidEdges,
    this.symbolPlacement,
    this.symbolSortKey,
    this.symbolSpacing,
    this.symbolZOrder,
    this.textAllowOverlap,
    this.textAnchor,
    this.textFont,
    this.textIgnorePlacement,
    this.textJustify,
    this.textKeepUpright,
    this.textLetterSpacing,
    this.textLineHeight,
    this.textMaxAngle,
    this.textMaxWidth,
    this.textOffset,
    this.textOptional,
    this.textPadding,
    this.textPitchAlignment,
    this.textRadialOffset,
    this.textRotate,
    this.textRotationAlignment,
    this.textSize,
    this.textTransform,
    this.textVariableAnchor,
    this.textWritingMode,
    this.iconColor,
    this.iconHaloBlur,
    this.iconHaloColor,
    this.iconHaloWidth,
    this.iconOpacity,
    this.iconTranslate,
    this.iconTranslateAnchor,
    this.textColor,
    this.textHaloBlur,
    this.textHaloColor,
    this.textHaloWidth,
    this.textOpacity,
    this.textTranslate,
    this.textTranslateAnchor,
  }) : super(
            id: id, visibility: visibility, maxZoom: maxZoom, minZoom: minZoom);

  @override
  String getType() => "symbol";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// If true, the icon will be visible even if it collides with other previously drawn symbols.
  bool? iconAllowOverlap;

  /// Part of the icon placed closest to the anchor.
  IconAnchor? iconAnchor;

  /// If true, other symbols can be visible even if they collide with the icon.
  bool? iconIgnorePlacement;

  /// Name of image in sprite to use for drawing an image background.
  String? iconImage;

  /// If true, the icon may be flipped to prevent it from being rendered upside-down.
  bool? iconKeepUpright;

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up.
  List<double?>? iconOffset;

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not.
  bool? iconOptional;

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions.
  double? iconPadding;

  /// Orientation of icon when map is pitched.
  IconPitchAlignment? iconPitchAlignment;

  /// Rotates the icon clockwise.
  double? iconRotate;

  /// In combination with `symbol-placement`, determines the rotation behavior of icons.
  IconRotationAlignment? iconRotationAlignment;

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image.
  double? iconSize;

  /// Scales the icon to fit around the associated text.
  IconTextFit? iconTextFit;

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left.
  List<double?>? iconTextFitPadding;

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries.
  bool? symbolAvoidEdges;

  /// Label placement relative to its geometry.
  SymbolPlacement? symbolPlacement;

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first.  When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  double? symbolSortKey;

  /// Distance between two symbol anchors.
  double? symbolSpacing;

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`.
  SymbolZOrder? symbolZOrder;

  /// If true, the text will be visible even if it collides with other previously drawn symbols.
  bool? textAllowOverlap;

  /// Part of the text placed closest to the anchor.
  TextAnchor? textAnchor;

  /// Font stack to use for displaying text.
  List<String?>? textFont;

  /// If true, other symbols can be visible even if they collide with the text.
  bool? textIgnorePlacement;

  /// Text justification options.
  TextJustify? textJustify;

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down.
  bool? textKeepUpright;

  /// Text tracking amount.
  double? textLetterSpacing;

  /// Text leading value for multi-line text.
  double? textLineHeight;

  /// Maximum angle change between adjacent characters.
  double? textMaxAngle;

  /// The maximum line width for text wrapping.
  double? textMaxWidth;

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position.
  List<double?>? textOffset;

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not.
  bool? textOptional;

  /// Size of the additional area around the text bounding box used for detecting symbol collisions.
  double? textPadding;

  /// Orientation of text when map is pitched.
  TextPitchAlignment? textPitchAlignment;

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present.
  double? textRadialOffset;

  /// Rotates the text clockwise.
  double? textRotate;

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text.
  TextRotationAlignment? textRotationAlignment;

  /// Font size.
  double? textSize;

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property.
  TextTransform? textTransform;

  /// To increase the chance of placing high-priority labels on the map, you can provide an array of `text-anchor` locations: the renderer will attempt to place the label at each location, in order, before moving onto the next label. Use `text-justify: auto` to choose justification based on anchor position. To apply an offset, use the `text-radial-offset` or the two-dimensional `text-offset`.
  List<String?>? textVariableAnchor;

  /// The property allows control over a symbol's orientation. Note that the property values act as a hint, so that a symbol whose language doesn’t support the provided orientation will be laid out in its natural orientation. Example: English point symbol will be rendered horizontally even if array value contains single 'vertical' enum value. The order of elements in an array define priority order for the placement of an orientation variant.
  List<String?>? textWritingMode;

  /// The color of the icon. This can only be used with sdf icons.
  int? iconColor;

  /// Fade out the halo towards the outside.
  double? iconHaloBlur;

  /// The color of the icon's halo. Icon halos can only be used with SDF icons.
  int? iconHaloColor;

  /// Distance of halo to the icon outline.
  double? iconHaloWidth;

  /// The opacity at which the icon will be drawn.
  double? iconOpacity;

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  List<double?>? iconTranslate;

  /// Controls the frame of reference for `icon-translate`.
  IconTranslateAnchor? iconTranslateAnchor;

  /// The color with which the text will be drawn.
  int? textColor;

  /// The halo's fadeout distance towards the outside.
  double? textHaloBlur;

  /// The color of the text's halo, which helps it stand out from backgrounds.
  int? textHaloColor;

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size.
  double? textHaloWidth;

  /// The opacity at which the text will be drawn.
  double? textOpacity;

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  List<double?>? textTranslate;

  /// Controls the frame of reference for `text-translate`.
  TextTranslateAnchor? textTranslateAnchor;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.toString().split('.').last.toLowerCase();
    }
    if (iconAllowOverlap != null) {
      layout["icon-allow-overlap"] = iconAllowOverlap;
    }
    if (iconAnchor != null) {
      layout["icon-anchor"] =
          iconAnchor?.toString().split('.').last.toLowerCase();
    }
    if (iconIgnorePlacement != null) {
      layout["icon-ignore-placement"] = iconIgnorePlacement;
    }
    if (iconImage != null) {
      layout["icon-image"] = iconImage;
    }
    if (iconKeepUpright != null) {
      layout["icon-keep-upright"] = iconKeepUpright;
    }
    if (iconOffset != null) {
      layout["icon-offset"] = iconOffset;
    }
    if (iconOptional != null) {
      layout["icon-optional"] = iconOptional;
    }
    if (iconPadding != null) {
      layout["icon-padding"] = iconPadding;
    }
    if (iconPitchAlignment != null) {
      layout["icon-pitch-alignment"] =
          iconPitchAlignment?.toString().split('.').last.toLowerCase();
    }
    if (iconRotate != null) {
      layout["icon-rotate"] = iconRotate;
    }
    if (iconRotationAlignment != null) {
      layout["icon-rotation-alignment"] =
          iconRotationAlignment?.toString().split('.').last.toLowerCase();
    }
    if (iconSize != null) {
      layout["icon-size"] = iconSize;
    }
    if (iconTextFit != null) {
      layout["icon-text-fit"] =
          iconTextFit?.toString().split('.').last.toLowerCase();
    }
    if (iconTextFitPadding != null) {
      layout["icon-text-fit-padding"] = iconTextFitPadding;
    }
    if (symbolAvoidEdges != null) {
      layout["symbol-avoid-edges"] = symbolAvoidEdges;
    }
    if (symbolPlacement != null) {
      layout["symbol-placement"] =
          symbolPlacement?.toString().split('.').last.toLowerCase();
    }
    if (symbolSortKey != null) {
      layout["symbol-sort-key"] = symbolSortKey;
    }
    if (symbolSpacing != null) {
      layout["symbol-spacing"] = symbolSpacing;
    }
    if (symbolZOrder != null) {
      layout["symbol-z-order"] =
          symbolZOrder?.toString().split('.').last.toLowerCase();
    }
    if (textAllowOverlap != null) {
      layout["text-allow-overlap"] = textAllowOverlap;
    }
    if (textAnchor != null) {
      layout["text-anchor"] =
          textAnchor?.toString().split('.').last.toLowerCase();
    }
    if (textFont != null) {
      layout["text-font"] = textFont;
    }
    if (textIgnorePlacement != null) {
      layout["text-ignore-placement"] = textIgnorePlacement;
    }
    if (textJustify != null) {
      layout["text-justify"] =
          textJustify?.toString().split('.').last.toLowerCase();
    }
    if (textKeepUpright != null) {
      layout["text-keep-upright"] = textKeepUpright;
    }
    if (textLetterSpacing != null) {
      layout["text-letter-spacing"] = textLetterSpacing;
    }
    if (textLineHeight != null) {
      layout["text-line-height"] = textLineHeight;
    }
    if (textMaxAngle != null) {
      layout["text-max-angle"] = textMaxAngle;
    }
    if (textMaxWidth != null) {
      layout["text-max-width"] = textMaxWidth;
    }
    if (textOffset != null) {
      layout["text-offset"] = textOffset;
    }
    if (textOptional != null) {
      layout["text-optional"] = textOptional;
    }
    if (textPadding != null) {
      layout["text-padding"] = textPadding;
    }
    if (textPitchAlignment != null) {
      layout["text-pitch-alignment"] =
          textPitchAlignment?.toString().split('.').last.toLowerCase();
    }
    if (textRadialOffset != null) {
      layout["text-radial-offset"] = textRadialOffset;
    }
    if (textRotate != null) {
      layout["text-rotate"] = textRotate;
    }
    if (textRotationAlignment != null) {
      layout["text-rotation-alignment"] =
          textRotationAlignment?.toString().split('.').last.toLowerCase();
    }
    if (textSize != null) {
      layout["text-size"] = textSize;
    }
    if (textTransform != null) {
      layout["text-transform"] =
          textTransform?.toString().split('.').last.toLowerCase();
    }
    if (textVariableAnchor != null) {
      layout["text-variable-anchor"] = textVariableAnchor;
    }
    if (textWritingMode != null) {
      layout["text-writing-mode"] = textWritingMode;
    }
    var paint = {};
    if (iconColor != null) {
      paint["icon-color"] = iconColor?.toRGBA();
    }
    if (iconHaloBlur != null) {
      paint["icon-halo-blur"] = iconHaloBlur;
    }
    if (iconHaloColor != null) {
      paint["icon-halo-color"] = iconHaloColor?.toRGBA();
    }
    if (iconHaloWidth != null) {
      paint["icon-halo-width"] = iconHaloWidth;
    }
    if (iconOpacity != null) {
      paint["icon-opacity"] = iconOpacity;
    }
    if (iconTranslate != null) {
      paint["icon-translate"] = iconTranslate;
    }
    if (iconTranslateAnchor != null) {
      paint["icon-translate-anchor"] =
          iconTranslateAnchor?.toString().split('.').last.toLowerCase();
    }
    if (textColor != null) {
      paint["text-color"] = textColor?.toRGBA();
    }
    if (textHaloBlur != null) {
      paint["text-halo-blur"] = textHaloBlur;
    }
    if (textHaloColor != null) {
      paint["text-halo-color"] = textHaloColor?.toRGBA();
    }
    if (textHaloWidth != null) {
      paint["text-halo-width"] = textHaloWidth;
    }
    if (textOpacity != null) {
      paint["text-opacity"] = textOpacity;
    }
    if (textTranslate != null) {
      paint["text-translate"] = textTranslate;
    }
    if (textTranslateAnchor != null) {
      paint["text-translate-anchor"] =
          textTranslateAnchor?.toString().split('.').last.toLowerCase();
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

  static SymbolLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return SymbolLayer(
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
      iconAllowOverlap: map["layout"]["icon-allow-overlap"],
      iconAnchor: map["layout"]["icon-anchor"] == null
          ? null
          : IconAnchor.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["icon-anchor"])),
      iconIgnorePlacement: map["layout"]["icon-ignore-placement"],
      iconImage: map["layout"]["icon-image"],
      iconKeepUpright: map["layout"]["icon-keep-upright"],
      iconOffset: (map["layout"]["icon-offset"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      iconOptional: map["layout"]["icon-optional"],
      iconPadding: map["layout"]["icon-padding"] is num?
          ? (map["layout"]["icon-padding"] as num?)?.toDouble()
          : null,
      iconPitchAlignment: map["layout"]["icon-pitch-alignment"] == null
          ? null
          : IconPitchAlignment.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["icon-pitch-alignment"])),
      iconRotate: map["layout"]["icon-rotate"] is num?
          ? (map["layout"]["icon-rotate"] as num?)?.toDouble()
          : null,
      iconRotationAlignment: map["layout"]["icon-rotation-alignment"] == null
          ? null
          : IconRotationAlignment.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["icon-rotation-alignment"])),
      iconSize: map["layout"]["icon-size"] is num?
          ? (map["layout"]["icon-size"] as num?)?.toDouble()
          : null,
      iconTextFit: map["layout"]["icon-text-fit"] == null
          ? null
          : IconTextFit.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["icon-text-fit"])),
      iconTextFitPadding: (map["layout"]["icon-text-fit-padding"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      symbolAvoidEdges: map["layout"]["symbol-avoid-edges"],
      symbolPlacement: map["layout"]["symbol-placement"] == null
          ? null
          : SymbolPlacement.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["symbol-placement"])),
      symbolSortKey: map["layout"]["symbol-sort-key"] is num?
          ? (map["layout"]["symbol-sort-key"] as num?)?.toDouble()
          : null,
      symbolSpacing: map["layout"]["symbol-spacing"] is num?
          ? (map["layout"]["symbol-spacing"] as num?)?.toDouble()
          : null,
      symbolZOrder: map["layout"]["symbol-z-order"] == null
          ? null
          : SymbolZOrder.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["symbol-z-order"])),
      textAllowOverlap: map["layout"]["text-allow-overlap"],
      textAnchor: map["layout"]["text-anchor"] == null
          ? null
          : TextAnchor.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["text-anchor"])),
      textFont: (map["layout"]["text-font"] as List?)
          ?.map<String?>((e) => e.toString())
          .toList(),
      textIgnorePlacement: map["layout"]["text-ignore-placement"],
      textJustify: map["layout"]["text-justify"] == null
          ? null
          : TextJustify.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["text-justify"])),
      textKeepUpright: map["layout"]["text-keep-upright"],
      textLetterSpacing: map["layout"]["text-letter-spacing"] is num?
          ? (map["layout"]["text-letter-spacing"] as num?)?.toDouble()
          : null,
      textLineHeight: map["layout"]["text-line-height"] is num?
          ? (map["layout"]["text-line-height"] as num?)?.toDouble()
          : null,
      textMaxAngle: map["layout"]["text-max-angle"] is num?
          ? (map["layout"]["text-max-angle"] as num?)?.toDouble()
          : null,
      textMaxWidth: map["layout"]["text-max-width"] is num?
          ? (map["layout"]["text-max-width"] as num?)?.toDouble()
          : null,
      textOffset: (map["layout"]["text-offset"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      textOptional: map["layout"]["text-optional"],
      textPadding: map["layout"]["text-padding"] is num?
          ? (map["layout"]["text-padding"] as num?)?.toDouble()
          : null,
      textPitchAlignment: map["layout"]["text-pitch-alignment"] == null
          ? null
          : TextPitchAlignment.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["text-pitch-alignment"])),
      textRadialOffset: map["layout"]["text-radial-offset"] is num?
          ? (map["layout"]["text-radial-offset"] as num?)?.toDouble()
          : null,
      textRotate: map["layout"]["text-rotate"] is num?
          ? (map["layout"]["text-rotate"] as num?)?.toDouble()
          : null,
      textRotationAlignment: map["layout"]["text-rotation-alignment"] == null
          ? null
          : TextRotationAlignment.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["text-rotation-alignment"])),
      textSize: map["layout"]["text-size"] is num?
          ? (map["layout"]["text-size"] as num?)?.toDouble()
          : null,
      textTransform: map["layout"]["text-transform"] == null
          ? null
          : TextTransform.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["layout"]["text-transform"])),
      textVariableAnchor: (map["layout"]["text-variable-anchor"] as List?)
          ?.map<String?>((e) => e.toString())
          .toList(),
      textWritingMode: (map["layout"]["text-writing-mode"] as List?)
          ?.map<String?>((e) => e.toString())
          .toList(),
      iconColor: (map["paint"]["icon-color"] as List?)?.toRGBAInt(),
      iconHaloBlur: map["paint"]["icon-halo-blur"] is num?
          ? (map["paint"]["icon-halo-blur"] as num?)?.toDouble()
          : null,
      iconHaloColor: (map["paint"]["icon-halo-color"] as List?)?.toRGBAInt(),
      iconHaloWidth: map["paint"]["icon-halo-width"] is num?
          ? (map["paint"]["icon-halo-width"] as num?)?.toDouble()
          : null,
      iconOpacity: map["paint"]["icon-opacity"] is num?
          ? (map["paint"]["icon-opacity"] as num?)?.toDouble()
          : null,
      iconTranslate: (map["paint"]["icon-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      iconTranslateAnchor: map["paint"]["icon-translate-anchor"] == null
          ? null
          : IconTranslateAnchor.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["paint"]["icon-translate-anchor"])),
      textColor: (map["paint"]["text-color"] as List?)?.toRGBAInt(),
      textHaloBlur: map["paint"]["text-halo-blur"] is num?
          ? (map["paint"]["text-halo-blur"] as num?)?.toDouble()
          : null,
      textHaloColor: (map["paint"]["text-halo-color"] as List?)?.toRGBAInt(),
      textHaloWidth: map["paint"]["text-halo-width"] is num?
          ? (map["paint"]["text-halo-width"] as num?)?.toDouble()
          : null,
      textOpacity: map["paint"]["text-opacity"] is num?
          ? (map["paint"]["text-opacity"] as num?)?.toDouble()
          : null,
      textTranslate: (map["paint"]["text-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      textTranslateAnchor: map["paint"]["text-translate-anchor"] == null
          ? null
          : TextTranslateAnchor.values.firstWhere((e) => e
              .toString()
              .split('.')
              .last
              .toLowerCase()
              .contains(map["paint"]["text-translate-anchor"])),
    );
  }
}

// End of generated file.
