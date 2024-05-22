// This file is generated.
part of mapbox_maps_flutter;

/// An icon or a text label.
class SymbolLayer extends Layer {
  SymbolLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    double? minZoom,
    double? maxZoom,
    String? slot,
    required String this.sourceId,
    String? this.sourceLayer,
    bool? this.iconAllowOverlap,
    List<Object>? this.iconAllowOverlapExpression,
    IconAnchor? this.iconAnchor,
    List<Object>? this.iconAnchorExpression,
    bool? this.iconIgnorePlacement,
    List<Object>? this.iconIgnorePlacementExpression,
    String? this.iconImage,
    List<Object>? this.iconImageExpression,
    bool? this.iconKeepUpright,
    List<Object>? this.iconKeepUprightExpression,
    List<double?>? this.iconOffset,
    List<Object>? this.iconOffsetExpression,
    bool? this.iconOptional,
    List<Object>? this.iconOptionalExpression,
    double? this.iconPadding,
    List<Object>? this.iconPaddingExpression,
    IconPitchAlignment? this.iconPitchAlignment,
    List<Object>? this.iconPitchAlignmentExpression,
    double? this.iconRotate,
    List<Object>? this.iconRotateExpression,
    IconRotationAlignment? this.iconRotationAlignment,
    List<Object>? this.iconRotationAlignmentExpression,
    double? this.iconSize,
    List<Object>? this.iconSizeExpression,
    IconTextFit? this.iconTextFit,
    List<Object>? this.iconTextFitExpression,
    List<double?>? this.iconTextFitPadding,
    List<Object>? this.iconTextFitPaddingExpression,
    bool? this.symbolAvoidEdges,
    List<Object>? this.symbolAvoidEdgesExpression,
    SymbolPlacement? this.symbolPlacement,
    List<Object>? this.symbolPlacementExpression,
    double? this.symbolSortKey,
    List<Object>? this.symbolSortKeyExpression,
    double? this.symbolSpacing,
    List<Object>? this.symbolSpacingExpression,
    bool? this.symbolZElevate,
    List<Object>? this.symbolZElevateExpression,
    SymbolZOrder? this.symbolZOrder,
    List<Object>? this.symbolZOrderExpression,
    bool? this.textAllowOverlap,
    List<Object>? this.textAllowOverlapExpression,
    TextAnchor? this.textAnchor,
    List<Object>? this.textAnchorExpression,
    String? this.textField,
    List<Object>? this.textFieldExpression,
    List<String?>? this.textFont,
    List<Object>? this.textFontExpression,
    bool? this.textIgnorePlacement,
    List<Object>? this.textIgnorePlacementExpression,
    TextJustify? this.textJustify,
    List<Object>? this.textJustifyExpression,
    bool? this.textKeepUpright,
    List<Object>? this.textKeepUprightExpression,
    double? this.textLetterSpacing,
    List<Object>? this.textLetterSpacingExpression,
    double? this.textLineHeight,
    List<Object>? this.textLineHeightExpression,
    double? this.textMaxAngle,
    List<Object>? this.textMaxAngleExpression,
    double? this.textMaxWidth,
    List<Object>? this.textMaxWidthExpression,
    List<double?>? this.textOffset,
    List<Object>? this.textOffsetExpression,
    bool? this.textOptional,
    List<Object>? this.textOptionalExpression,
    double? this.textPadding,
    List<Object>? this.textPaddingExpression,
    TextPitchAlignment? this.textPitchAlignment,
    List<Object>? this.textPitchAlignmentExpression,
    double? this.textRadialOffset,
    List<Object>? this.textRadialOffsetExpression,
    double? this.textRotate,
    List<Object>? this.textRotateExpression,
    TextRotationAlignment? this.textRotationAlignment,
    List<Object>? this.textRotationAlignmentExpression,
    double? this.textSize,
    List<Object>? this.textSizeExpression,
    TextTransform? this.textTransform,
    List<Object>? this.textTransformExpression,
    List<String?>? this.textVariableAnchor,
    List<Object>? this.textVariableAnchorExpression,
    List<String?>? this.textWritingMode,
    List<Object>? this.textWritingModeExpression,
    int? this.iconColor,
    List<Object>? this.iconColorExpression,
    double? this.iconColorSaturation,
    List<Object>? this.iconColorSaturationExpression,
    double? this.iconEmissiveStrength,
    List<Object>? this.iconEmissiveStrengthExpression,
    double? this.iconHaloBlur,
    List<Object>? this.iconHaloBlurExpression,
    int? this.iconHaloColor,
    List<Object>? this.iconHaloColorExpression,
    double? this.iconHaloWidth,
    List<Object>? this.iconHaloWidthExpression,
    double? this.iconImageCrossFade,
    List<Object>? this.iconImageCrossFadeExpression,
    double? this.iconOpacity,
    List<Object>? this.iconOpacityExpression,
    List<double?>? this.iconTranslate,
    List<Object>? this.iconTranslateExpression,
    IconTranslateAnchor? this.iconTranslateAnchor,
    List<Object>? this.iconTranslateAnchorExpression,
    int? this.textColor,
    List<Object>? this.textColorExpression,
    double? this.textEmissiveStrength,
    List<Object>? this.textEmissiveStrengthExpression,
    double? this.textHaloBlur,
    List<Object>? this.textHaloBlurExpression,
    int? this.textHaloColor,
    List<Object>? this.textHaloColorExpression,
    double? this.textHaloWidth,
    List<Object>? this.textHaloWidthExpression,
    double? this.textOpacity,
    List<Object>? this.textOpacityExpression,
    List<double?>? this.textTranslate,
    List<Object>? this.textTranslateExpression,
    TextTranslateAnchor? this.textTranslateAnchor,
    List<Object>? this.textTranslateAnchorExpression,
  }) : super(
            id: id,
            visibility: visibility,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "symbol";

  /// The id of the source.
  String sourceId;

  /// A source layer is an individual layer of data within a vector source. A vector source can have multiple source layers.
  String? sourceLayer;

  /// If true, the icon will be visible even if it collides with other previously drawn symbols.
  bool? iconAllowOverlap;

  /// If true, the icon will be visible even if it collides with other previously drawn symbols.
  List<Object>? iconAllowOverlapExpression;

  /// Part of the icon placed closest to the anchor.
  IconAnchor? iconAnchor;

  /// Part of the icon placed closest to the anchor.
  List<Object>? iconAnchorExpression;

  /// If true, other symbols can be visible even if they collide with the icon.
  bool? iconIgnorePlacement;

  /// If true, other symbols can be visible even if they collide with the icon.
  List<Object>? iconIgnorePlacementExpression;

  /// Name of image in sprite to use for drawing an image background.
  String? iconImage;

  /// Name of image in sprite to use for drawing an image background.
  List<Object>? iconImageExpression;

  /// If true, the icon may be flipped to prevent it from being rendered upside-down.
  bool? iconKeepUpright;

  /// If true, the icon may be flipped to prevent it from being rendered upside-down.
  List<Object>? iconKeepUprightExpression;

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up.
  List<double?>? iconOffset;

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up.
  List<Object>? iconOffsetExpression;

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not.
  bool? iconOptional;

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not.
  List<Object>? iconOptionalExpression;

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions.
  double? iconPadding;

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions.
  List<Object>? iconPaddingExpression;

  /// Orientation of icon when map is pitched.
  IconPitchAlignment? iconPitchAlignment;

  /// Orientation of icon when map is pitched.
  List<Object>? iconPitchAlignmentExpression;

  /// Rotates the icon clockwise.
  double? iconRotate;

  /// Rotates the icon clockwise.
  List<Object>? iconRotateExpression;

  /// In combination with `symbol-placement`, determines the rotation behavior of icons.
  IconRotationAlignment? iconRotationAlignment;

  /// In combination with `symbol-placement`, determines the rotation behavior of icons.
  List<Object>? iconRotationAlignmentExpression;

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image.
  double? iconSize;

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image.
  List<Object>? iconSizeExpression;

  /// Scales the icon to fit around the associated text.
  IconTextFit? iconTextFit;

  /// Scales the icon to fit around the associated text.
  List<Object>? iconTextFitExpression;

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left.
  List<double?>? iconTextFitPadding;

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left.
  List<Object>? iconTextFitPaddingExpression;

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries.
  bool? symbolAvoidEdges;

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries.
  List<Object>? symbolAvoidEdgesExpression;

  /// Label placement relative to its geometry.
  SymbolPlacement? symbolPlacement;

  /// Label placement relative to its geometry.
  List<Object>? symbolPlacementExpression;

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first. When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  double? symbolSortKey;

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first. When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  List<Object>? symbolSortKeyExpression;

  /// Distance between two symbol anchors.
  double? symbolSpacing;

  /// Distance between two symbol anchors.
  List<Object>? symbolSpacingExpression;

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied.
  bool? symbolZElevate;

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied.
  List<Object>? symbolZElevateExpression;

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`.
  SymbolZOrder? symbolZOrder;

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`.
  List<Object>? symbolZOrderExpression;

  /// If true, the text will be visible even if it collides with other previously drawn symbols.
  bool? textAllowOverlap;

  /// If true, the text will be visible even if it collides with other previously drawn symbols.
  List<Object>? textAllowOverlapExpression;

  /// Part of the text placed closest to the anchor.
  TextAnchor? textAnchor;

  /// Part of the text placed closest to the anchor.
  List<Object>? textAnchorExpression;

  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options. SDF images are not supported in formatted text and will be ignored.
  String? textField;

  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options. SDF images are not supported in formatted text and will be ignored.
  List<Object>? textFieldExpression;

  /// Font stack to use for displaying text.
  List<String?>? textFont;

  /// Font stack to use for displaying text.
  List<Object>? textFontExpression;

  /// If true, other symbols can be visible even if they collide with the text.
  bool? textIgnorePlacement;

  /// If true, other symbols can be visible even if they collide with the text.
  List<Object>? textIgnorePlacementExpression;

  /// Text justification options.
  TextJustify? textJustify;

  /// Text justification options.
  List<Object>? textJustifyExpression;

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down.
  bool? textKeepUpright;

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down.
  List<Object>? textKeepUprightExpression;

  /// Text tracking amount.
  double? textLetterSpacing;

  /// Text tracking amount.
  List<Object>? textLetterSpacingExpression;

  /// Text leading value for multi-line text.
  double? textLineHeight;

  /// Text leading value for multi-line text.
  List<Object>? textLineHeightExpression;

  /// Maximum angle change between adjacent characters.
  double? textMaxAngle;

  /// Maximum angle change between adjacent characters.
  List<Object>? textMaxAngleExpression;

  /// The maximum line width for text wrapping.
  double? textMaxWidth;

  /// The maximum line width for text wrapping.
  List<Object>? textMaxWidthExpression;

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position.
  List<double?>? textOffset;

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position.
  List<Object>? textOffsetExpression;

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not.
  bool? textOptional;

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not.
  List<Object>? textOptionalExpression;

  /// Size of the additional area around the text bounding box used for detecting symbol collisions.
  double? textPadding;

  /// Size of the additional area around the text bounding box used for detecting symbol collisions.
  List<Object>? textPaddingExpression;

  /// Orientation of text when map is pitched.
  TextPitchAlignment? textPitchAlignment;

  /// Orientation of text when map is pitched.
  List<Object>? textPitchAlignmentExpression;

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present.
  double? textRadialOffset;

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present.
  List<Object>? textRadialOffsetExpression;

  /// Rotates the text clockwise.
  double? textRotate;

  /// Rotates the text clockwise.
  List<Object>? textRotateExpression;

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text.
  TextRotationAlignment? textRotationAlignment;

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text.
  List<Object>? textRotationAlignmentExpression;

  /// Font size.
  double? textSize;

  /// Font size.
  List<Object>? textSizeExpression;

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property.
  TextTransform? textTransform;

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property.
  List<Object>? textTransformExpression;

  /// To increase the chance of placing high-priority labels on the map, you can provide an array of `text-anchor` locations: the renderer will attempt to place the label at each location, in order, before moving onto the next label. Use `text-justify: auto` to choose justification based on anchor position. To apply an offset, use the `text-radial-offset` or the two-dimensional `text-offset`.
  List<String?>? textVariableAnchor;

  /// To increase the chance of placing high-priority labels on the map, you can provide an array of `text-anchor` locations: the renderer will attempt to place the label at each location, in order, before moving onto the next label. Use `text-justify: auto` to choose justification based on anchor position. To apply an offset, use the `text-radial-offset` or the two-dimensional `text-offset`.
  List<Object>? textVariableAnchorExpression;

  /// The property allows control over a symbol's orientation. Note that the property values act as a hint, so that a symbol whose language doesn’t support the provided orientation will be laid out in its natural orientation. Example: English point symbol will be rendered horizontally even if array value contains single 'vertical' enum value. For symbol with point placement, the order of elements in an array define priority order for the placement of an orientation variant. For symbol with line placement, the default text writing mode is either ['horizontal', 'vertical'] or ['vertical', 'horizontal'], the order doesn't affect the placement.
  List<String?>? textWritingMode;

  /// The property allows control over a symbol's orientation. Note that the property values act as a hint, so that a symbol whose language doesn’t support the provided orientation will be laid out in its natural orientation. Example: English point symbol will be rendered horizontally even if array value contains single 'vertical' enum value. For symbol with point placement, the order of elements in an array define priority order for the placement of an orientation variant. For symbol with line placement, the default text writing mode is either ['horizontal', 'vertical'] or ['vertical', 'horizontal'], the order doesn't affect the placement.
  List<Object>? textWritingModeExpression;

  /// The color of the icon. This can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/).
  int? iconColor;

  /// The color of the icon. This can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/).
  List<Object>? iconColorExpression;

  /// Controls saturation level of the symbol icon. With the default value of 1 the icon color is preserved while with a value of 0 it is fully desaturated and looks black and white.
  double? iconColorSaturation;

  /// Controls saturation level of the symbol icon. With the default value of 1 the icon color is preserved while with a value of 0 it is fully desaturated and looks black and white.
  List<Object>? iconColorSaturationExpression;

  /// Controls the intensity of light emitted on the source features.
  double? iconEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  List<Object>? iconEmissiveStrengthExpression;

  /// Fade out the halo towards the outside.
  double? iconHaloBlur;

  /// Fade out the halo towards the outside.
  List<Object>? iconHaloBlurExpression;

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/).
  int? iconHaloColor;

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/).
  List<Object>? iconHaloColorExpression;

  /// Distance of halo to the icon outline.
  double? iconHaloWidth;

  /// Distance of halo to the icon outline.
  List<Object>? iconHaloWidthExpression;

  /// Controls the transition progress between the image variants of icon-image. Zero means the first variant is used, one is the second, and in between they are blended together.
  double? iconImageCrossFade;

  /// Controls the transition progress between the image variants of icon-image. Zero means the first variant is used, one is the second, and in between they are blended together.
  List<Object>? iconImageCrossFadeExpression;

  /// The opacity at which the icon will be drawn.
  double? iconOpacity;

  /// The opacity at which the icon will be drawn.
  List<Object>? iconOpacityExpression;

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  List<double?>? iconTranslate;

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  List<Object>? iconTranslateExpression;

  /// Controls the frame of reference for `icon-translate`.
  IconTranslateAnchor? iconTranslateAnchor;

  /// Controls the frame of reference for `icon-translate`.
  List<Object>? iconTranslateAnchorExpression;

  /// The color with which the text will be drawn.
  int? textColor;

  /// The color with which the text will be drawn.
  List<Object>? textColorExpression;

  /// Controls the intensity of light emitted on the source features.
  double? textEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  List<Object>? textEmissiveStrengthExpression;

  /// The halo's fadeout distance towards the outside.
  double? textHaloBlur;

  /// The halo's fadeout distance towards the outside.
  List<Object>? textHaloBlurExpression;

  /// The color of the text's halo, which helps it stand out from backgrounds.
  int? textHaloColor;

  /// The color of the text's halo, which helps it stand out from backgrounds.
  List<Object>? textHaloColorExpression;

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size.
  double? textHaloWidth;

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size.
  List<Object>? textHaloWidthExpression;

  /// The opacity at which the text will be drawn.
  double? textOpacity;

  /// The opacity at which the text will be drawn.
  List<Object>? textOpacityExpression;

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  List<double?>? textTranslate;

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  List<Object>? textTranslateExpression;

  /// Controls the frame of reference for `text-translate`.
  TextTranslateAnchor? textTranslateAnchor;

  /// Controls the frame of reference for `text-translate`.
  List<Object>? textTranslateAnchorExpression;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.name.toLowerCase().replaceAll("_", "-");
    }
    if (iconAllowOverlap != null) {
      layout["icon-allow-overlap"] = iconAllowOverlap;
    }
    if (iconAnchor != null) {
      layout["icon-anchor"] =
          iconAnchor?.name.toLowerCase().replaceAll("_", "-");
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
          iconPitchAlignment?.name.toLowerCase().replaceAll("_", "-");
    }
    if (iconRotate != null) {
      layout["icon-rotate"] = iconRotate;
    }
    if (iconRotationAlignment != null) {
      layout["icon-rotation-alignment"] =
          iconRotationAlignment?.name.toLowerCase().replaceAll("_", "-");
    }
    if (iconSize != null) {
      layout["icon-size"] = iconSize;
    }
    if (iconTextFit != null) {
      layout["icon-text-fit"] =
          iconTextFit?.name.toLowerCase().replaceAll("_", "-");
    }
    if (iconTextFitPadding != null) {
      layout["icon-text-fit-padding"] = iconTextFitPadding;
    }
    if (symbolAvoidEdges != null) {
      layout["symbol-avoid-edges"] = symbolAvoidEdges;
    }
    if (symbolPlacement != null) {
      layout["symbol-placement"] =
          symbolPlacement?.name.toLowerCase().replaceAll("_", "-");
    }
    if (symbolSortKey != null) {
      layout["symbol-sort-key"] = symbolSortKey;
    }
    if (symbolSpacing != null) {
      layout["symbol-spacing"] = symbolSpacing;
    }
    if (symbolZElevate != null) {
      layout["symbol-z-elevate"] = symbolZElevate;
    }
    if (symbolZOrder != null) {
      layout["symbol-z-order"] =
          symbolZOrder?.name.toLowerCase().replaceAll("_", "-");
    }
    if (textAllowOverlap != null) {
      layout["text-allow-overlap"] = textAllowOverlap;
    }
    if (textAnchor != null) {
      layout["text-anchor"] =
          textAnchor?.name.toLowerCase().replaceAll("_", "-");
    }
    if (textField != null) {
      layout["text-field"] = textField;
    }
    if (textFont != null) {
      layout["text-font"] = textFont;
    }
    if (textIgnorePlacement != null) {
      layout["text-ignore-placement"] = textIgnorePlacement;
    }
    if (textJustify != null) {
      layout["text-justify"] =
          textJustify?.name.toLowerCase().replaceAll("_", "-");
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
          textPitchAlignment?.name.toLowerCase().replaceAll("_", "-");
    }
    if (textRadialOffset != null) {
      layout["text-radial-offset"] = textRadialOffset;
    }
    if (textRotate != null) {
      layout["text-rotate"] = textRotate;
    }
    if (textRotationAlignment != null) {
      layout["text-rotation-alignment"] =
          textRotationAlignment?.name.toLowerCase().replaceAll("_", "-");
    }
    if (textSize != null) {
      layout["text-size"] = textSize;
    }
    if (textTransform != null) {
      layout["text-transform"] =
          textTransform?.name.toLowerCase().replaceAll("_", "-");
    }
    if (textVariableAnchor != null) {
      layout["text-variable-anchor"] = textVariableAnchor;
    }
    if (textWritingMode != null) {
      layout["text-writing-mode"] = textWritingMode;
    }
    var paint = {};
    if (iconColorExpression != null) {
      paint["icon-color"] = iconColorExpression;
    }
    if (iconColor != null) {
      paint["icon-color"] = iconColor?.toRGBA();
    }

    if (iconColorSaturationExpression != null) {
      paint["icon-color-saturation"] = iconColorSaturationExpression;
    }
    if (iconColorSaturation != null) {
      paint["icon-color-saturation"] = iconColorSaturation;
    }

    if (iconEmissiveStrengthExpression != null) {
      paint["icon-emissive-strength"] = iconEmissiveStrengthExpression;
    }
    if (iconEmissiveStrength != null) {
      paint["icon-emissive-strength"] = iconEmissiveStrength;
    }

    if (iconHaloBlurExpression != null) {
      paint["icon-halo-blur"] = iconHaloBlurExpression;
    }
    if (iconHaloBlur != null) {
      paint["icon-halo-blur"] = iconHaloBlur;
    }

    if (iconHaloColorExpression != null) {
      paint["icon-halo-color"] = iconHaloColorExpression;
    }
    if (iconHaloColor != null) {
      paint["icon-halo-color"] = iconHaloColor?.toRGBA();
    }

    if (iconHaloWidthExpression != null) {
      paint["icon-halo-width"] = iconHaloWidthExpression;
    }
    if (iconHaloWidth != null) {
      paint["icon-halo-width"] = iconHaloWidth;
    }

    if (iconImageCrossFadeExpression != null) {
      paint["icon-image-cross-fade"] = iconImageCrossFadeExpression;
    }
    if (iconImageCrossFade != null) {
      paint["icon-image-cross-fade"] = iconImageCrossFade;
    }

    if (iconOpacityExpression != null) {
      paint["icon-opacity"] = iconOpacityExpression;
    }
    if (iconOpacity != null) {
      paint["icon-opacity"] = iconOpacity;
    }

    if (iconTranslateExpression != null) {
      paint["icon-translate"] = iconTranslateExpression;
    }
    if (iconTranslate != null) {
      paint["icon-translate"] = iconTranslate;
    }

    if (iconTranslateAnchorExpression != null) {
      paint["icon-translate-anchor"] = iconTranslateAnchorExpression;
    }
    if (iconTranslateAnchor != null) {
      paint["icon-translate-anchor"] =
          iconTranslateAnchor?.name.toLowerCase().replaceAll("_", "-");
    }

    if (textColorExpression != null) {
      paint["text-color"] = textColorExpression;
    }
    if (textColor != null) {
      paint["text-color"] = textColor?.toRGBA();
    }

    if (textEmissiveStrengthExpression != null) {
      paint["text-emissive-strength"] = textEmissiveStrengthExpression;
    }
    if (textEmissiveStrength != null) {
      paint["text-emissive-strength"] = textEmissiveStrength;
    }

    if (textHaloBlurExpression != null) {
      paint["text-halo-blur"] = textHaloBlurExpression;
    }
    if (textHaloBlur != null) {
      paint["text-halo-blur"] = textHaloBlur;
    }

    if (textHaloColorExpression != null) {
      paint["text-halo-color"] = textHaloColorExpression;
    }
    if (textHaloColor != null) {
      paint["text-halo-color"] = textHaloColor?.toRGBA();
    }

    if (textHaloWidthExpression != null) {
      paint["text-halo-width"] = textHaloWidthExpression;
    }
    if (textHaloWidth != null) {
      paint["text-halo-width"] = textHaloWidth;
    }

    if (textOpacityExpression != null) {
      paint["text-opacity"] = textOpacityExpression;
    }
    if (textOpacity != null) {
      paint["text-opacity"] = textOpacity;
    }

    if (textTranslateExpression != null) {
      paint["text-translate"] = textTranslateExpression;
    }
    if (textTranslate != null) {
      paint["text-translate"] = textTranslate;
    }

    if (textTranslateAnchorExpression != null) {
      paint["text-translate-anchor"] = textTranslateAnchorExpression;
    }
    if (textTranslateAnchor != null) {
      paint["text-translate-anchor"] =
          textTranslateAnchor?.name.toLowerCase().replaceAll("_", "-");
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
      slot: map["slot"],
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["visibility"])),
      iconAllowOverlap: optionalCast(map["layout"]["icon-allow-overlap"]),
      iconAllowOverlapExpression:
          optionalCast(map["layout"]["icon-allow-overlap"]),
      iconAnchor: map["layout"]["icon-anchor"] == null
          ? null
          : IconAnchor.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["icon-anchor"])),
      iconAnchorExpression: optionalCast(map["layout"]["icon-anchor"]),
      iconIgnorePlacement: optionalCast(map["layout"]["icon-ignore-placement"]),
      iconIgnorePlacementExpression:
          optionalCast(map["layout"]["icon-ignore-placement"]),
      iconImage: optionalCast(map["layout"]["icon-image"]),
      iconImageExpression: optionalCast(map["layout"]["icon-image"]),
      iconKeepUpright: optionalCast(map["layout"]["icon-keep-upright"]),
      iconKeepUprightExpression:
          optionalCast(map["layout"]["icon-keep-upright"]),
      iconOffset: (map["layout"]["icon-offset"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      iconOffsetExpression: optionalCast(map["layout"]["icon-offset"]),
      iconOptional: optionalCast(map["layout"]["icon-optional"]),
      iconOptionalExpression: optionalCast(map["layout"]["icon-optional"]),
      iconPadding: optionalCast(map["layout"]["icon-padding"]),
      iconPaddingExpression: optionalCast(map["layout"]["icon-padding"]),
      iconPitchAlignment: map["layout"]["icon-pitch-alignment"] == null
          ? null
          : IconPitchAlignment.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["icon-pitch-alignment"])),
      iconPitchAlignmentExpression:
          optionalCast(map["layout"]["icon-pitch-alignment"]),
      iconRotate: optionalCast(map["layout"]["icon-rotate"]),
      iconRotateExpression: optionalCast(map["layout"]["icon-rotate"]),
      iconRotationAlignment: map["layout"]["icon-rotation-alignment"] == null
          ? null
          : IconRotationAlignment.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["icon-rotation-alignment"])),
      iconRotationAlignmentExpression:
          optionalCast(map["layout"]["icon-rotation-alignment"]),
      iconSize: optionalCast(map["layout"]["icon-size"]),
      iconSizeExpression: optionalCast(map["layout"]["icon-size"]),
      iconTextFit: map["layout"]["icon-text-fit"] == null
          ? null
          : IconTextFit.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["icon-text-fit"])),
      iconTextFitExpression: optionalCast(map["layout"]["icon-text-fit"]),
      iconTextFitPadding: (map["layout"]["icon-text-fit-padding"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      iconTextFitPaddingExpression:
          optionalCast(map["layout"]["icon-text-fit-padding"]),
      symbolAvoidEdges: optionalCast(map["layout"]["symbol-avoid-edges"]),
      symbolAvoidEdgesExpression:
          optionalCast(map["layout"]["symbol-avoid-edges"]),
      symbolPlacement: map["layout"]["symbol-placement"] == null
          ? null
          : SymbolPlacement.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["symbol-placement"])),
      symbolPlacementExpression:
          optionalCast(map["layout"]["symbol-placement"]),
      symbolSortKey: optionalCast(map["layout"]["symbol-sort-key"]),
      symbolSortKeyExpression: optionalCast(map["layout"]["symbol-sort-key"]),
      symbolSpacing: optionalCast(map["layout"]["symbol-spacing"]),
      symbolSpacingExpression: optionalCast(map["layout"]["symbol-spacing"]),
      symbolZElevate: optionalCast(map["layout"]["symbol-z-elevate"]),
      symbolZElevateExpression: optionalCast(map["layout"]["symbol-z-elevate"]),
      symbolZOrder: map["layout"]["symbol-z-order"] == null
          ? null
          : SymbolZOrder.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["symbol-z-order"])),
      symbolZOrderExpression: optionalCast(map["layout"]["symbol-z-order"]),
      textAllowOverlap: optionalCast(map["layout"]["text-allow-overlap"]),
      textAllowOverlapExpression:
          optionalCast(map["layout"]["text-allow-overlap"]),
      textAnchor: map["layout"]["text-anchor"] == null
          ? null
          : TextAnchor.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["text-anchor"])),
      textAnchorExpression: optionalCast(map["layout"]["text-anchor"]),
      textField: optionalCast(map["layout"]["text-field"]),
      textFieldExpression: optionalCast(map["layout"]["text-field"]),
      textFont: (map["layout"]["text-font"] as List?)
          ?.map<String?>((e) => e.toString())
          .toList(),
      textFontExpression: optionalCast(map["layout"]["text-font"]),
      textIgnorePlacement: optionalCast(map["layout"]["text-ignore-placement"]),
      textIgnorePlacementExpression:
          optionalCast(map["layout"]["text-ignore-placement"]),
      textJustify: map["layout"]["text-justify"] == null
          ? null
          : TextJustify.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["text-justify"])),
      textJustifyExpression: optionalCast(map["layout"]["text-justify"]),
      textKeepUpright: optionalCast(map["layout"]["text-keep-upright"]),
      textKeepUprightExpression:
          optionalCast(map["layout"]["text-keep-upright"]),
      textLetterSpacing: optionalCast(map["layout"]["text-letter-spacing"]),
      textLetterSpacingExpression:
          optionalCast(map["layout"]["text-letter-spacing"]),
      textLineHeight: optionalCast(map["layout"]["text-line-height"]),
      textLineHeightExpression: optionalCast(map["layout"]["text-line-height"]),
      textMaxAngle: optionalCast(map["layout"]["text-max-angle"]),
      textMaxAngleExpression: optionalCast(map["layout"]["text-max-angle"]),
      textMaxWidth: optionalCast(map["layout"]["text-max-width"]),
      textMaxWidthExpression: optionalCast(map["layout"]["text-max-width"]),
      textOffset: (map["layout"]["text-offset"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      textOffsetExpression: optionalCast(map["layout"]["text-offset"]),
      textOptional: optionalCast(map["layout"]["text-optional"]),
      textOptionalExpression: optionalCast(map["layout"]["text-optional"]),
      textPadding: optionalCast(map["layout"]["text-padding"]),
      textPaddingExpression: optionalCast(map["layout"]["text-padding"]),
      textPitchAlignment: map["layout"]["text-pitch-alignment"] == null
          ? null
          : TextPitchAlignment.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["text-pitch-alignment"])),
      textPitchAlignmentExpression:
          optionalCast(map["layout"]["text-pitch-alignment"]),
      textRadialOffset: optionalCast(map["layout"]["text-radial-offset"]),
      textRadialOffsetExpression:
          optionalCast(map["layout"]["text-radial-offset"]),
      textRotate: optionalCast(map["layout"]["text-rotate"]),
      textRotateExpression: optionalCast(map["layout"]["text-rotate"]),
      textRotationAlignment: map["layout"]["text-rotation-alignment"] == null
          ? null
          : TextRotationAlignment.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["text-rotation-alignment"])),
      textRotationAlignmentExpression:
          optionalCast(map["layout"]["text-rotation-alignment"]),
      textSize: optionalCast(map["layout"]["text-size"]),
      textSizeExpression: optionalCast(map["layout"]["text-size"]),
      textTransform: map["layout"]["text-transform"] == null
          ? null
          : TextTransform.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["text-transform"])),
      textTransformExpression: optionalCast(map["layout"]["text-transform"]),
      textVariableAnchor: (map["layout"]["text-variable-anchor"] as List?)
          ?.map<String?>((e) => e.toString())
          .toList(),
      textVariableAnchorExpression:
          optionalCast(map["layout"]["text-variable-anchor"]),
      textWritingMode: (map["layout"]["text-writing-mode"] as List?)
          ?.map<String?>((e) => e.toString())
          .toList(),
      textWritingModeExpression:
          optionalCast(map["layout"]["text-writing-mode"]),
      iconColor: (map["paint"]["icon-color"] as List?)?.toRGBAInt(),
      iconColorExpression: optionalCast(map["layout"]["icon-color"]),
      iconColorSaturation: optionalCast(map["paint"]["icon-color-saturation"]),
      iconColorSaturationExpression:
          optionalCast(map["layout"]["icon-color-saturation"]),
      iconEmissiveStrength:
          optionalCast(map["paint"]["icon-emissive-strength"]),
      iconEmissiveStrengthExpression:
          optionalCast(map["layout"]["icon-emissive-strength"]),
      iconHaloBlur: optionalCast(map["paint"]["icon-halo-blur"]),
      iconHaloBlurExpression: optionalCast(map["layout"]["icon-halo-blur"]),
      iconHaloColor: (map["paint"]["icon-halo-color"] as List?)?.toRGBAInt(),
      iconHaloColorExpression: optionalCast(map["layout"]["icon-halo-color"]),
      iconHaloWidth: optionalCast(map["paint"]["icon-halo-width"]),
      iconHaloWidthExpression: optionalCast(map["layout"]["icon-halo-width"]),
      iconImageCrossFade: optionalCast(map["paint"]["icon-image-cross-fade"]),
      iconImageCrossFadeExpression:
          optionalCast(map["layout"]["icon-image-cross-fade"]),
      iconOpacity: optionalCast(map["paint"]["icon-opacity"]),
      iconOpacityExpression: optionalCast(map["layout"]["icon-opacity"]),
      iconTranslate: (map["paint"]["icon-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      iconTranslateExpression: optionalCast(map["layout"]["icon-translate"]),
      iconTranslateAnchor: map["paint"]["icon-translate-anchor"] == null
          ? null
          : IconTranslateAnchor.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["icon-translate-anchor"])),
      iconTranslateAnchorExpression:
          optionalCast(map["layout"]["icon-translate-anchor"]),
      textColor: (map["paint"]["text-color"] as List?)?.toRGBAInt(),
      textColorExpression: optionalCast(map["layout"]["text-color"]),
      textEmissiveStrength:
          optionalCast(map["paint"]["text-emissive-strength"]),
      textEmissiveStrengthExpression:
          optionalCast(map["layout"]["text-emissive-strength"]),
      textHaloBlur: optionalCast(map["paint"]["text-halo-blur"]),
      textHaloBlurExpression: optionalCast(map["layout"]["text-halo-blur"]),
      textHaloColor: (map["paint"]["text-halo-color"] as List?)?.toRGBAInt(),
      textHaloColorExpression: optionalCast(map["layout"]["text-halo-color"]),
      textHaloWidth: optionalCast(map["paint"]["text-halo-width"]),
      textHaloWidthExpression: optionalCast(map["layout"]["text-halo-width"]),
      textOpacity: optionalCast(map["paint"]["text-opacity"]),
      textOpacityExpression: optionalCast(map["layout"]["text-opacity"]),
      textTranslate: (map["paint"]["text-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      textTranslateExpression: optionalCast(map["layout"]["text-translate"]),
      textTranslateAnchor: map["paint"]["text-translate-anchor"] == null
          ? null
          : TextTranslateAnchor.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["text-translate-anchor"])),
      textTranslateAnchorExpression:
          optionalCast(map["layout"]["text-translate-anchor"]),
    );
  }
}

// End of generated file.
