// This file is generated.
part of mapbox_maps_flutter;

/// An icon or a text label.
class SymbolLayer extends Layer {
  SymbolLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
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
    double? this.iconOcclusionOpacity,
    List<Object>? this.iconOcclusionOpacityExpression,
    double? this.iconOpacity,
    List<Object>? this.iconOpacityExpression,
    List<double?>? this.iconTranslate,
    List<Object>? this.iconTranslateExpression,
    IconTranslateAnchor? this.iconTranslateAnchor,
    List<Object>? this.iconTranslateAnchorExpression,
    SymbolElevationReference? this.symbolElevationReference,
    List<Object>? this.symbolElevationReferenceExpression,
    double? this.symbolZOffset,
    List<Object>? this.symbolZOffsetExpression,
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
    double? this.textOcclusionOpacity,
    List<Object>? this.textOcclusionOpacityExpression,
    double? this.textOpacity,
    List<Object>? this.textOpacityExpression,
    List<double?>? this.textTranslate,
    List<Object>? this.textTranslateExpression,
    TextTranslateAnchor? this.textTranslateAnchor,
    List<Object>? this.textTranslateAnchorExpression,
  }) : super(
            id: id,
            visibility: visibility,
            visibilityExpression: visibilityExpression,
            filter: filter,
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
  /// Default value: false.
  bool? iconAllowOverlap;

  /// If true, the icon will be visible even if it collides with other previously drawn symbols.
  /// Default value: false.
  List<Object>? iconAllowOverlapExpression;

  /// Part of the icon placed closest to the anchor.
  /// Default value: "center".
  IconAnchor? iconAnchor;

  /// Part of the icon placed closest to the anchor.
  /// Default value: "center".
  List<Object>? iconAnchorExpression;

  /// If true, other symbols can be visible even if they collide with the icon.
  /// Default value: false.
  bool? iconIgnorePlacement;

  /// If true, other symbols can be visible even if they collide with the icon.
  /// Default value: false.
  List<Object>? iconIgnorePlacementExpression;

  /// Name of image in sprite to use for drawing an image background.
  String? iconImage;

  /// Name of image in sprite to use for drawing an image background.
  List<Object>? iconImageExpression;

  /// If true, the icon may be flipped to prevent it from being rendered upside-down.
  /// Default value: false.
  bool? iconKeepUpright;

  /// If true, the icon may be flipped to prevent it from being rendered upside-down.
  /// Default value: false.
  List<Object>? iconKeepUprightExpression;

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up.
  /// Default value: [0,0].
  List<double?>? iconOffset;

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up.
  /// Default value: [0,0].
  List<Object>? iconOffsetExpression;

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not.
  /// Default value: false.
  bool? iconOptional;

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not.
  /// Default value: false.
  List<Object>? iconOptionalExpression;

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions.
  /// Default value: 2. Minimum value: 0.
  double? iconPadding;

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions.
  /// Default value: 2. Minimum value: 0.
  List<Object>? iconPaddingExpression;

  /// Orientation of icon when map is pitched.
  /// Default value: "auto".
  IconPitchAlignment? iconPitchAlignment;

  /// Orientation of icon when map is pitched.
  /// Default value: "auto".
  List<Object>? iconPitchAlignmentExpression;

  /// Rotates the icon clockwise.
  /// Default value: 0.
  double? iconRotate;

  /// Rotates the icon clockwise.
  /// Default value: 0.
  List<Object>? iconRotateExpression;

  /// In combination with `symbol-placement`, determines the rotation behavior of icons.
  /// Default value: "auto".
  IconRotationAlignment? iconRotationAlignment;

  /// In combination with `symbol-placement`, determines the rotation behavior of icons.
  /// Default value: "auto".
  List<Object>? iconRotationAlignmentExpression;

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image.
  /// Default value: 1. Minimum value: 0.
  double? iconSize;

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image.
  /// Default value: 1. Minimum value: 0.
  List<Object>? iconSizeExpression;

  /// Scales the icon to fit around the associated text.
  /// Default value: "none".
  IconTextFit? iconTextFit;

  /// Scales the icon to fit around the associated text.
  /// Default value: "none".
  List<Object>? iconTextFitExpression;

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left.
  /// Default value: [0,0,0,0].
  List<double?>? iconTextFitPadding;

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left.
  /// Default value: [0,0,0,0].
  List<Object>? iconTextFitPaddingExpression;

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries.
  /// Default value: false.
  bool? symbolAvoidEdges;

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries.
  /// Default value: false.
  List<Object>? symbolAvoidEdgesExpression;

  /// Label placement relative to its geometry.
  /// Default value: "point".
  SymbolPlacement? symbolPlacement;

  /// Label placement relative to its geometry.
  /// Default value: "point".
  List<Object>? symbolPlacementExpression;

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first. When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  double? symbolSortKey;

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first. When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  List<Object>? symbolSortKeyExpression;

  /// Distance between two symbol anchors.
  /// Default value: 250. Minimum value: 1.
  double? symbolSpacing;

  /// Distance between two symbol anchors.
  /// Default value: 250. Minimum value: 1.
  List<Object>? symbolSpacingExpression;

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied.
  /// Default value: false.
  bool? symbolZElevate;

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied.
  /// Default value: false.
  List<Object>? symbolZElevateExpression;

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`.
  /// Default value: "auto".
  SymbolZOrder? symbolZOrder;

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`.
  /// Default value: "auto".
  List<Object>? symbolZOrderExpression;

  /// If true, the text will be visible even if it collides with other previously drawn symbols.
  /// Default value: false.
  bool? textAllowOverlap;

  /// If true, the text will be visible even if it collides with other previously drawn symbols.
  /// Default value: false.
  List<Object>? textAllowOverlapExpression;

  /// Part of the text placed closest to the anchor.
  /// Default value: "center".
  TextAnchor? textAnchor;

  /// Part of the text placed closest to the anchor.
  /// Default value: "center".
  List<Object>? textAnchorExpression;

  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options. SDF images are not supported in formatted text and will be ignored.
  /// Default value: "".
  String? textField;

  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options. SDF images are not supported in formatted text and will be ignored.
  /// Default value: "".
  List<Object>? textFieldExpression;

  /// Font stack to use for displaying text.
  List<String?>? textFont;

  /// Font stack to use for displaying text.
  List<Object>? textFontExpression;

  /// If true, other symbols can be visible even if they collide with the text.
  /// Default value: false.
  bool? textIgnorePlacement;

  /// If true, other symbols can be visible even if they collide with the text.
  /// Default value: false.
  List<Object>? textIgnorePlacementExpression;

  /// Text justification options.
  /// Default value: "center".
  TextJustify? textJustify;

  /// Text justification options.
  /// Default value: "center".
  List<Object>? textJustifyExpression;

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down.
  /// Default value: true.
  bool? textKeepUpright;

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down.
  /// Default value: true.
  List<Object>? textKeepUprightExpression;

  /// Text tracking amount.
  /// Default value: 0.
  double? textLetterSpacing;

  /// Text tracking amount.
  /// Default value: 0.
  List<Object>? textLetterSpacingExpression;

  /// Text leading value for multi-line text.
  /// Default value: 1.2.
  double? textLineHeight;

  /// Text leading value for multi-line text.
  /// Default value: 1.2.
  List<Object>? textLineHeightExpression;

  /// Maximum angle change between adjacent characters.
  /// Default value: 45.
  double? textMaxAngle;

  /// Maximum angle change between adjacent characters.
  /// Default value: 45.
  List<Object>? textMaxAngleExpression;

  /// The maximum line width for text wrapping.
  /// Default value: 10. Minimum value: 0.
  double? textMaxWidth;

  /// The maximum line width for text wrapping.
  /// Default value: 10. Minimum value: 0.
  List<Object>? textMaxWidthExpression;

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position.
  /// Default value: [0,0].
  List<double?>? textOffset;

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position.
  /// Default value: [0,0].
  List<Object>? textOffsetExpression;

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not.
  /// Default value: false.
  bool? textOptional;

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not.
  /// Default value: false.
  List<Object>? textOptionalExpression;

  /// Size of the additional area around the text bounding box used for detecting symbol collisions.
  /// Default value: 2. Minimum value: 0.
  double? textPadding;

  /// Size of the additional area around the text bounding box used for detecting symbol collisions.
  /// Default value: 2. Minimum value: 0.
  List<Object>? textPaddingExpression;

  /// Orientation of text when map is pitched.
  /// Default value: "auto".
  TextPitchAlignment? textPitchAlignment;

  /// Orientation of text when map is pitched.
  /// Default value: "auto".
  List<Object>? textPitchAlignmentExpression;

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present.
  /// Default value: 0.
  double? textRadialOffset;

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present.
  /// Default value: 0.
  List<Object>? textRadialOffsetExpression;

  /// Rotates the text clockwise.
  /// Default value: 0.
  double? textRotate;

  /// Rotates the text clockwise.
  /// Default value: 0.
  List<Object>? textRotateExpression;

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text.
  /// Default value: "auto".
  TextRotationAlignment? textRotationAlignment;

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text.
  /// Default value: "auto".
  List<Object>? textRotationAlignmentExpression;

  /// Font size.
  /// Default value: 16. Minimum value: 0.
  double? textSize;

  /// Font size.
  /// Default value: 16. Minimum value: 0.
  List<Object>? textSizeExpression;

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property.
  /// Default value: "none".
  TextTransform? textTransform;

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property.
  /// Default value: "none".
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
  /// Default value: "#000000".
  int? iconColor;

  /// The color of the icon. This can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/).
  /// Default value: "#000000".
  List<Object>? iconColorExpression;

  /// Increase or reduce the saturation of the symbol icon.
  /// Default value: 0. Value range: [-1, 1]
  double? iconColorSaturation;

  /// Increase or reduce the saturation of the symbol icon.
  /// Default value: 0. Value range: [-1, 1]
  List<Object>? iconColorSaturationExpression;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 1. Minimum value: 0.
  double? iconEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 1. Minimum value: 0.
  List<Object>? iconEmissiveStrengthExpression;

  /// Fade out the halo towards the outside.
  /// Default value: 0. Minimum value: 0.
  double? iconHaloBlur;

  /// Fade out the halo towards the outside.
  /// Default value: 0. Minimum value: 0.
  List<Object>? iconHaloBlurExpression;

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/).
  /// Default value: "rgba(0, 0, 0, 0)".
  int? iconHaloColor;

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/).
  /// Default value: "rgba(0, 0, 0, 0)".
  List<Object>? iconHaloColorExpression;

  /// Distance of halo to the icon outline.
  /// Default value: 0. Minimum value: 0.
  double? iconHaloWidth;

  /// Distance of halo to the icon outline.
  /// Default value: 0. Minimum value: 0.
  List<Object>? iconHaloWidthExpression;

  /// Controls the transition progress between the image variants of icon-image. Zero means the first variant is used, one is the second, and in between they are blended together.
  /// Default value: 0. Value range: [0, 1]
  double? iconImageCrossFade;

  /// Controls the transition progress between the image variants of icon-image. Zero means the first variant is used, one is the second, and in between they are blended together.
  /// Default value: 0. Value range: [0, 1]
  List<Object>? iconImageCrossFadeExpression;

  /// The opacity at which the icon will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only.
  /// Default value: 0. Value range: [0, 1]
  double? iconOcclusionOpacity;

  /// The opacity at which the icon will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only.
  /// Default value: 0. Value range: [0, 1]
  List<Object>? iconOcclusionOpacityExpression;

  /// The opacity at which the icon will be drawn.
  /// Default value: 1. Value range: [0, 1]
  double? iconOpacity;

  /// The opacity at which the icon will be drawn.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? iconOpacityExpression;

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  /// Default value: [0,0].
  List<double?>? iconTranslate;

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  /// Default value: [0,0].
  List<Object>? iconTranslateExpression;

  /// Controls the frame of reference for `icon-translate`.
  /// Default value: "map".
  IconTranslateAnchor? iconTranslateAnchor;

  /// Controls the frame of reference for `icon-translate`.
  /// Default value: "map".
  List<Object>? iconTranslateAnchorExpression;

  /// Selects the base of symbol-elevation.
  /// Default value: "ground".
  @experimental
  SymbolElevationReference? symbolElevationReference;

  /// Selects the base of symbol-elevation.
  /// Default value: "ground".
  @experimental
  List<Object>? symbolElevationReferenceExpression;

  /// Specifies an uniform elevation from the ground, in meters.
  /// Default value: 0. Minimum value: 0.
  @experimental
  double? symbolZOffset;

  /// Specifies an uniform elevation from the ground, in meters.
  /// Default value: 0. Minimum value: 0.
  @experimental
  List<Object>? symbolZOffsetExpression;

  /// The color with which the text will be drawn.
  /// Default value: "#000000".
  int? textColor;

  /// The color with which the text will be drawn.
  /// Default value: "#000000".
  List<Object>? textColorExpression;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 1. Minimum value: 0.
  double? textEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 1. Minimum value: 0.
  List<Object>? textEmissiveStrengthExpression;

  /// The halo's fadeout distance towards the outside.
  /// Default value: 0. Minimum value: 0.
  double? textHaloBlur;

  /// The halo's fadeout distance towards the outside.
  /// Default value: 0. Minimum value: 0.
  List<Object>? textHaloBlurExpression;

  /// The color of the text's halo, which helps it stand out from backgrounds.
  /// Default value: "rgba(0, 0, 0, 0)".
  int? textHaloColor;

  /// The color of the text's halo, which helps it stand out from backgrounds.
  /// Default value: "rgba(0, 0, 0, 0)".
  List<Object>? textHaloColorExpression;

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size.
  /// Default value: 0. Minimum value: 0.
  double? textHaloWidth;

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size.
  /// Default value: 0. Minimum value: 0.
  List<Object>? textHaloWidthExpression;

  /// The opacity at which the text will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only.
  /// Default value: 0. Value range: [0, 1]
  double? textOcclusionOpacity;

  /// The opacity at which the text will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only.
  /// Default value: 0. Value range: [0, 1]
  List<Object>? textOcclusionOpacityExpression;

  /// The opacity at which the text will be drawn.
  /// Default value: 1. Value range: [0, 1]
  double? textOpacity;

  /// The opacity at which the text will be drawn.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? textOpacityExpression;

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  /// Default value: [0,0].
  List<double?>? textTranslate;

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  /// Default value: [0,0].
  List<Object>? textTranslateExpression;

  /// Controls the frame of reference for `text-translate`.
  /// Default value: "map".
  TextTranslateAnchor? textTranslateAnchor;

  /// Controls the frame of reference for `text-translate`.
  /// Default value: "map".
  List<Object>? textTranslateAnchorExpression;

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

    if (iconAllowOverlapExpression != null) {
      layout["icon-allow-overlap"] = iconAllowOverlapExpression;
    }

    if (iconAllowOverlap != null) {
      layout["icon-allow-overlap"] = iconAllowOverlap;
    }
    if (iconAnchorExpression != null) {
      layout["icon-anchor"] = iconAnchorExpression;
    }

    if (iconAnchor != null) {
      layout["icon-anchor"] =
          iconAnchor?.name.toLowerCase().replaceAll("_", "-");
    }
    if (iconIgnorePlacementExpression != null) {
      layout["icon-ignore-placement"] = iconIgnorePlacementExpression;
    }

    if (iconIgnorePlacement != null) {
      layout["icon-ignore-placement"] = iconIgnorePlacement;
    }
    if (iconImageExpression != null) {
      layout["icon-image"] = iconImageExpression;
    }

    if (iconImage != null) {
      layout["icon-image"] = iconImage;
    }
    if (iconKeepUprightExpression != null) {
      layout["icon-keep-upright"] = iconKeepUprightExpression;
    }

    if (iconKeepUpright != null) {
      layout["icon-keep-upright"] = iconKeepUpright;
    }
    if (iconOffsetExpression != null) {
      layout["icon-offset"] = iconOffsetExpression;
    }

    if (iconOffset != null) {
      layout["icon-offset"] = iconOffset;
    }
    if (iconOptionalExpression != null) {
      layout["icon-optional"] = iconOptionalExpression;
    }

    if (iconOptional != null) {
      layout["icon-optional"] = iconOptional;
    }
    if (iconPaddingExpression != null) {
      layout["icon-padding"] = iconPaddingExpression;
    }

    if (iconPadding != null) {
      layout["icon-padding"] = iconPadding;
    }
    if (iconPitchAlignmentExpression != null) {
      layout["icon-pitch-alignment"] = iconPitchAlignmentExpression;
    }

    if (iconPitchAlignment != null) {
      layout["icon-pitch-alignment"] =
          iconPitchAlignment?.name.toLowerCase().replaceAll("_", "-");
    }
    if (iconRotateExpression != null) {
      layout["icon-rotate"] = iconRotateExpression;
    }

    if (iconRotate != null) {
      layout["icon-rotate"] = iconRotate;
    }
    if (iconRotationAlignmentExpression != null) {
      layout["icon-rotation-alignment"] = iconRotationAlignmentExpression;
    }

    if (iconRotationAlignment != null) {
      layout["icon-rotation-alignment"] =
          iconRotationAlignment?.name.toLowerCase().replaceAll("_", "-");
    }
    if (iconSizeExpression != null) {
      layout["icon-size"] = iconSizeExpression;
    }

    if (iconSize != null) {
      layout["icon-size"] = iconSize;
    }
    if (iconTextFitExpression != null) {
      layout["icon-text-fit"] = iconTextFitExpression;
    }

    if (iconTextFit != null) {
      layout["icon-text-fit"] =
          iconTextFit?.name.toLowerCase().replaceAll("_", "-");
    }
    if (iconTextFitPaddingExpression != null) {
      layout["icon-text-fit-padding"] = iconTextFitPaddingExpression;
    }

    if (iconTextFitPadding != null) {
      layout["icon-text-fit-padding"] = iconTextFitPadding;
    }
    if (symbolAvoidEdgesExpression != null) {
      layout["symbol-avoid-edges"] = symbolAvoidEdgesExpression;
    }

    if (symbolAvoidEdges != null) {
      layout["symbol-avoid-edges"] = symbolAvoidEdges;
    }
    if (symbolPlacementExpression != null) {
      layout["symbol-placement"] = symbolPlacementExpression;
    }

    if (symbolPlacement != null) {
      layout["symbol-placement"] =
          symbolPlacement?.name.toLowerCase().replaceAll("_", "-");
    }
    if (symbolSortKeyExpression != null) {
      layout["symbol-sort-key"] = symbolSortKeyExpression;
    }

    if (symbolSortKey != null) {
      layout["symbol-sort-key"] = symbolSortKey;
    }
    if (symbolSpacingExpression != null) {
      layout["symbol-spacing"] = symbolSpacingExpression;
    }

    if (symbolSpacing != null) {
      layout["symbol-spacing"] = symbolSpacing;
    }
    if (symbolZElevateExpression != null) {
      layout["symbol-z-elevate"] = symbolZElevateExpression;
    }

    if (symbolZElevate != null) {
      layout["symbol-z-elevate"] = symbolZElevate;
    }
    if (symbolZOrderExpression != null) {
      layout["symbol-z-order"] = symbolZOrderExpression;
    }

    if (symbolZOrder != null) {
      layout["symbol-z-order"] =
          symbolZOrder?.name.toLowerCase().replaceAll("_", "-");
    }
    if (textAllowOverlapExpression != null) {
      layout["text-allow-overlap"] = textAllowOverlapExpression;
    }

    if (textAllowOverlap != null) {
      layout["text-allow-overlap"] = textAllowOverlap;
    }
    if (textAnchorExpression != null) {
      layout["text-anchor"] = textAnchorExpression;
    }

    if (textAnchor != null) {
      layout["text-anchor"] =
          textAnchor?.name.toLowerCase().replaceAll("_", "-");
    }
    if (textFieldExpression != null) {
      layout["text-field"] = textFieldExpression;
    }

    if (textField != null) {
      layout["text-field"] = textField;
    }
    if (textFontExpression != null) {
      layout["text-font"] = textFontExpression;
    }

    if (textFont != null) {
      layout["text-font"] = textFont;
    }
    if (textIgnorePlacementExpression != null) {
      layout["text-ignore-placement"] = textIgnorePlacementExpression;
    }

    if (textIgnorePlacement != null) {
      layout["text-ignore-placement"] = textIgnorePlacement;
    }
    if (textJustifyExpression != null) {
      layout["text-justify"] = textJustifyExpression;
    }

    if (textJustify != null) {
      layout["text-justify"] =
          textJustify?.name.toLowerCase().replaceAll("_", "-");
    }
    if (textKeepUprightExpression != null) {
      layout["text-keep-upright"] = textKeepUprightExpression;
    }

    if (textKeepUpright != null) {
      layout["text-keep-upright"] = textKeepUpright;
    }
    if (textLetterSpacingExpression != null) {
      layout["text-letter-spacing"] = textLetterSpacingExpression;
    }

    if (textLetterSpacing != null) {
      layout["text-letter-spacing"] = textLetterSpacing;
    }
    if (textLineHeightExpression != null) {
      layout["text-line-height"] = textLineHeightExpression;
    }

    if (textLineHeight != null) {
      layout["text-line-height"] = textLineHeight;
    }
    if (textMaxAngleExpression != null) {
      layout["text-max-angle"] = textMaxAngleExpression;
    }

    if (textMaxAngle != null) {
      layout["text-max-angle"] = textMaxAngle;
    }
    if (textMaxWidthExpression != null) {
      layout["text-max-width"] = textMaxWidthExpression;
    }

    if (textMaxWidth != null) {
      layout["text-max-width"] = textMaxWidth;
    }
    if (textOffsetExpression != null) {
      layout["text-offset"] = textOffsetExpression;
    }

    if (textOffset != null) {
      layout["text-offset"] = textOffset;
    }
    if (textOptionalExpression != null) {
      layout["text-optional"] = textOptionalExpression;
    }

    if (textOptional != null) {
      layout["text-optional"] = textOptional;
    }
    if (textPaddingExpression != null) {
      layout["text-padding"] = textPaddingExpression;
    }

    if (textPadding != null) {
      layout["text-padding"] = textPadding;
    }
    if (textPitchAlignmentExpression != null) {
      layout["text-pitch-alignment"] = textPitchAlignmentExpression;
    }

    if (textPitchAlignment != null) {
      layout["text-pitch-alignment"] =
          textPitchAlignment?.name.toLowerCase().replaceAll("_", "-");
    }
    if (textRadialOffsetExpression != null) {
      layout["text-radial-offset"] = textRadialOffsetExpression;
    }

    if (textRadialOffset != null) {
      layout["text-radial-offset"] = textRadialOffset;
    }
    if (textRotateExpression != null) {
      layout["text-rotate"] = textRotateExpression;
    }

    if (textRotate != null) {
      layout["text-rotate"] = textRotate;
    }
    if (textRotationAlignmentExpression != null) {
      layout["text-rotation-alignment"] = textRotationAlignmentExpression;
    }

    if (textRotationAlignment != null) {
      layout["text-rotation-alignment"] =
          textRotationAlignment?.name.toLowerCase().replaceAll("_", "-");
    }
    if (textSizeExpression != null) {
      layout["text-size"] = textSizeExpression;
    }

    if (textSize != null) {
      layout["text-size"] = textSize;
    }
    if (textTransformExpression != null) {
      layout["text-transform"] = textTransformExpression;
    }

    if (textTransform != null) {
      layout["text-transform"] =
          textTransform?.name.toLowerCase().replaceAll("_", "-");
    }
    if (textVariableAnchorExpression != null) {
      layout["text-variable-anchor"] = textVariableAnchorExpression;
    }

    if (textVariableAnchor != null) {
      layout["text-variable-anchor"] = textVariableAnchor;
    }
    if (textWritingModeExpression != null) {
      layout["text-writing-mode"] = textWritingModeExpression;
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

    if (iconOcclusionOpacityExpression != null) {
      paint["icon-occlusion-opacity"] = iconOcclusionOpacityExpression;
    }
    if (iconOcclusionOpacity != null) {
      paint["icon-occlusion-opacity"] = iconOcclusionOpacity;
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

    if (symbolElevationReferenceExpression != null) {
      paint["symbol-elevation-reference"] = symbolElevationReferenceExpression;
    }
    if (symbolElevationReference != null) {
      paint["symbol-elevation-reference"] =
          symbolElevationReference?.name.toLowerCase().replaceAll("_", "-");
    }

    if (symbolZOffsetExpression != null) {
      paint["symbol-z-offset"] = symbolZOffsetExpression;
    }
    if (symbolZOffset != null) {
      paint["symbol-z-offset"] = symbolZOffset;
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

    if (textOcclusionOpacityExpression != null) {
      paint["text-occlusion-opacity"] = textOcclusionOpacityExpression;
    }
    if (textOcclusionOpacity != null) {
      paint["text-occlusion-opacity"] = textOcclusionOpacity;
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
    if (filter != null) {
      properties["filter"] = filter!;
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
      visibilityExpression: _optionalCastList(map["layout"]["visibility"]),
      filter: _optionalCastList(map["filter"]),
      iconAllowOverlap: _optionalCast(map["layout"]["icon-allow-overlap"]),
      iconAllowOverlapExpression:
          _optionalCastList(map["layout"]["icon-allow-overlap"]),
      iconAnchor: map["layout"]["icon-anchor"] == null
          ? null
          : IconAnchor.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["icon-anchor"])),
      iconAnchorExpression: _optionalCastList(map["layout"]["icon-anchor"]),
      iconIgnorePlacement:
          _optionalCast(map["layout"]["icon-ignore-placement"]),
      iconIgnorePlacementExpression:
          _optionalCastList(map["layout"]["icon-ignore-placement"]),
      iconImage: _optionalCast(map["layout"]["icon-image"]),
      iconImageExpression: _optionalCastList(map["layout"]["icon-image"]),
      iconKeepUpright: _optionalCast(map["layout"]["icon-keep-upright"]),
      iconKeepUprightExpression:
          _optionalCastList(map["layout"]["icon-keep-upright"]),
      iconOffset: (map["layout"]["icon-offset"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      iconOffsetExpression: _optionalCastList(map["layout"]["icon-offset"]),
      iconOptional: _optionalCast(map["layout"]["icon-optional"]),
      iconOptionalExpression: _optionalCastList(map["layout"]["icon-optional"]),
      iconPadding: _optionalCast(map["layout"]["icon-padding"]),
      iconPaddingExpression: _optionalCastList(map["layout"]["icon-padding"]),
      iconPitchAlignment: map["layout"]["icon-pitch-alignment"] == null
          ? null
          : IconPitchAlignment.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["icon-pitch-alignment"])),
      iconPitchAlignmentExpression:
          _optionalCastList(map["layout"]["icon-pitch-alignment"]),
      iconRotate: _optionalCast(map["layout"]["icon-rotate"]),
      iconRotateExpression: _optionalCastList(map["layout"]["icon-rotate"]),
      iconRotationAlignment: map["layout"]["icon-rotation-alignment"] == null
          ? null
          : IconRotationAlignment.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["icon-rotation-alignment"])),
      iconRotationAlignmentExpression:
          _optionalCastList(map["layout"]["icon-rotation-alignment"]),
      iconSize: _optionalCast(map["layout"]["icon-size"]),
      iconSizeExpression: _optionalCastList(map["layout"]["icon-size"]),
      iconTextFit: map["layout"]["icon-text-fit"] == null
          ? null
          : IconTextFit.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["icon-text-fit"])),
      iconTextFitExpression: _optionalCastList(map["layout"]["icon-text-fit"]),
      iconTextFitPadding: (map["layout"]["icon-text-fit-padding"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      iconTextFitPaddingExpression:
          _optionalCastList(map["layout"]["icon-text-fit-padding"]),
      symbolAvoidEdges: _optionalCast(map["layout"]["symbol-avoid-edges"]),
      symbolAvoidEdgesExpression:
          _optionalCastList(map["layout"]["symbol-avoid-edges"]),
      symbolPlacement: map["layout"]["symbol-placement"] == null
          ? null
          : SymbolPlacement.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["symbol-placement"])),
      symbolPlacementExpression:
          _optionalCastList(map["layout"]["symbol-placement"]),
      symbolSortKey: _optionalCast(map["layout"]["symbol-sort-key"]),
      symbolSortKeyExpression:
          _optionalCastList(map["layout"]["symbol-sort-key"]),
      symbolSpacing: _optionalCast(map["layout"]["symbol-spacing"]),
      symbolSpacingExpression:
          _optionalCastList(map["layout"]["symbol-spacing"]),
      symbolZElevate: _optionalCast(map["layout"]["symbol-z-elevate"]),
      symbolZElevateExpression:
          _optionalCastList(map["layout"]["symbol-z-elevate"]),
      symbolZOrder: map["layout"]["symbol-z-order"] == null
          ? null
          : SymbolZOrder.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["symbol-z-order"])),
      symbolZOrderExpression:
          _optionalCastList(map["layout"]["symbol-z-order"]),
      textAllowOverlap: _optionalCast(map["layout"]["text-allow-overlap"]),
      textAllowOverlapExpression:
          _optionalCastList(map["layout"]["text-allow-overlap"]),
      textAnchor: map["layout"]["text-anchor"] == null
          ? null
          : TextAnchor.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["text-anchor"])),
      textAnchorExpression: _optionalCastList(map["layout"]["text-anchor"]),
      textField: _optionalCast(map["layout"]["text-field"]),
      textFieldExpression: _optionalCastList(map["layout"]["text-field"]),
      textFont: (map["layout"]["text-font"] as List?)
          ?.map<String?>((e) => e.toString())
          .toList(),
      textFontExpression: _optionalCastList(map["layout"]["text-font"]),
      textIgnorePlacement:
          _optionalCast(map["layout"]["text-ignore-placement"]),
      textIgnorePlacementExpression:
          _optionalCastList(map["layout"]["text-ignore-placement"]),
      textJustify: map["layout"]["text-justify"] == null
          ? null
          : TextJustify.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["text-justify"])),
      textJustifyExpression: _optionalCastList(map["layout"]["text-justify"]),
      textKeepUpright: _optionalCast(map["layout"]["text-keep-upright"]),
      textKeepUprightExpression:
          _optionalCastList(map["layout"]["text-keep-upright"]),
      textLetterSpacing: _optionalCast(map["layout"]["text-letter-spacing"]),
      textLetterSpacingExpression:
          _optionalCastList(map["layout"]["text-letter-spacing"]),
      textLineHeight: _optionalCast(map["layout"]["text-line-height"]),
      textLineHeightExpression:
          _optionalCastList(map["layout"]["text-line-height"]),
      textMaxAngle: _optionalCast(map["layout"]["text-max-angle"]),
      textMaxAngleExpression:
          _optionalCastList(map["layout"]["text-max-angle"]),
      textMaxWidth: _optionalCast(map["layout"]["text-max-width"]),
      textMaxWidthExpression:
          _optionalCastList(map["layout"]["text-max-width"]),
      textOffset: (map["layout"]["text-offset"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      textOffsetExpression: _optionalCastList(map["layout"]["text-offset"]),
      textOptional: _optionalCast(map["layout"]["text-optional"]),
      textOptionalExpression: _optionalCastList(map["layout"]["text-optional"]),
      textPadding: _optionalCast(map["layout"]["text-padding"]),
      textPaddingExpression: _optionalCastList(map["layout"]["text-padding"]),
      textPitchAlignment: map["layout"]["text-pitch-alignment"] == null
          ? null
          : TextPitchAlignment.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["text-pitch-alignment"])),
      textPitchAlignmentExpression:
          _optionalCastList(map["layout"]["text-pitch-alignment"]),
      textRadialOffset: _optionalCast(map["layout"]["text-radial-offset"]),
      textRadialOffsetExpression:
          _optionalCastList(map["layout"]["text-radial-offset"]),
      textRotate: _optionalCast(map["layout"]["text-rotate"]),
      textRotateExpression: _optionalCastList(map["layout"]["text-rotate"]),
      textRotationAlignment: map["layout"]["text-rotation-alignment"] == null
          ? null
          : TextRotationAlignment.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["text-rotation-alignment"])),
      textRotationAlignmentExpression:
          _optionalCastList(map["layout"]["text-rotation-alignment"]),
      textSize: _optionalCast(map["layout"]["text-size"]),
      textSizeExpression: _optionalCastList(map["layout"]["text-size"]),
      textTransform: map["layout"]["text-transform"] == null
          ? null
          : TextTransform.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["text-transform"])),
      textTransformExpression:
          _optionalCastList(map["layout"]["text-transform"]),
      textVariableAnchor: (map["layout"]["text-variable-anchor"] as List?)
          ?.map<String?>((e) => e.toString())
          .toList(),
      textVariableAnchorExpression:
          _optionalCastList(map["layout"]["text-variable-anchor"]),
      textWritingMode: (map["layout"]["text-writing-mode"] as List?)
          ?.map<String?>((e) => e.toString())
          .toList(),
      textWritingModeExpression:
          _optionalCastList(map["layout"]["text-writing-mode"]),
      iconColor: (map["paint"]["icon-color"] as List?)?.toRGBAInt(),
      iconColorExpression: _optionalCastList(map["paint"]["icon-color"]),
      iconColorSaturation: _optionalCast(map["paint"]["icon-color-saturation"]),
      iconColorSaturationExpression:
          _optionalCastList(map["paint"]["icon-color-saturation"]),
      iconEmissiveStrength:
          _optionalCast(map["paint"]["icon-emissive-strength"]),
      iconEmissiveStrengthExpression:
          _optionalCastList(map["paint"]["icon-emissive-strength"]),
      iconHaloBlur: _optionalCast(map["paint"]["icon-halo-blur"]),
      iconHaloBlurExpression: _optionalCastList(map["paint"]["icon-halo-blur"]),
      iconHaloColor: (map["paint"]["icon-halo-color"] as List?)?.toRGBAInt(),
      iconHaloColorExpression:
          _optionalCastList(map["paint"]["icon-halo-color"]),
      iconHaloWidth: _optionalCast(map["paint"]["icon-halo-width"]),
      iconHaloWidthExpression:
          _optionalCastList(map["paint"]["icon-halo-width"]),
      iconImageCrossFade: _optionalCast(map["paint"]["icon-image-cross-fade"]),
      iconImageCrossFadeExpression:
          _optionalCastList(map["paint"]["icon-image-cross-fade"]),
      iconOcclusionOpacity:
          _optionalCast(map["paint"]["icon-occlusion-opacity"]),
      iconOcclusionOpacityExpression:
          _optionalCastList(map["paint"]["icon-occlusion-opacity"]),
      iconOpacity: _optionalCast(map["paint"]["icon-opacity"]),
      iconOpacityExpression: _optionalCastList(map["paint"]["icon-opacity"]),
      iconTranslate: (map["paint"]["icon-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      iconTranslateExpression:
          _optionalCastList(map["paint"]["icon-translate"]),
      iconTranslateAnchor: map["paint"]["icon-translate-anchor"] == null
          ? null
          : IconTranslateAnchor.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["icon-translate-anchor"])),
      iconTranslateAnchorExpression:
          _optionalCastList(map["paint"]["icon-translate-anchor"]),
      symbolElevationReference:
          map["layout"]["symbol-elevation-reference"] == null
              ? null
              : SymbolElevationReference.values.firstWhere((e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["layout"]["symbol-elevation-reference"])),
      symbolElevationReferenceExpression:
          _optionalCastList(map["layout"]["symbol-elevation-reference"]),
      symbolZOffset: _optionalCast(map["paint"]["symbol-z-offset"]),
      symbolZOffsetExpression:
          _optionalCastList(map["paint"]["symbol-z-offset"]),
      textColor: (map["paint"]["text-color"] as List?)?.toRGBAInt(),
      textColorExpression: _optionalCastList(map["paint"]["text-color"]),
      textEmissiveStrength:
          _optionalCast(map["paint"]["text-emissive-strength"]),
      textEmissiveStrengthExpression:
          _optionalCastList(map["paint"]["text-emissive-strength"]),
      textHaloBlur: _optionalCast(map["paint"]["text-halo-blur"]),
      textHaloBlurExpression: _optionalCastList(map["paint"]["text-halo-blur"]),
      textHaloColor: (map["paint"]["text-halo-color"] as List?)?.toRGBAInt(),
      textHaloColorExpression:
          _optionalCastList(map["paint"]["text-halo-color"]),
      textHaloWidth: _optionalCast(map["paint"]["text-halo-width"]),
      textHaloWidthExpression:
          _optionalCastList(map["paint"]["text-halo-width"]),
      textOcclusionOpacity:
          _optionalCast(map["paint"]["text-occlusion-opacity"]),
      textOcclusionOpacityExpression:
          _optionalCastList(map["paint"]["text-occlusion-opacity"]),
      textOpacity: _optionalCast(map["paint"]["text-opacity"]),
      textOpacityExpression: _optionalCastList(map["paint"]["text-opacity"]),
      textTranslate: (map["paint"]["text-translate"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      textTranslateExpression:
          _optionalCastList(map["paint"]["text-translate"]),
      textTranslateAnchor: map["paint"]["text-translate-anchor"] == null
          ? null
          : TextTranslateAnchor.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["paint"]["text-translate-anchor"])),
      textTranslateAnchorExpression:
          _optionalCastList(map["paint"]["text-translate-anchor"]),
    );
  }
}

// End of generated file.
