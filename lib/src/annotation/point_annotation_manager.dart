// This file is generated.
part of mapbox_maps_flutter;

/// The PointAnnotationManager to add/update/delete PointAnnotationAnnotations on the map.
class PointAnnotationManager extends BaseAnnotationManager {
  PointAnnotationManager(
      {required String id, required BinaryMessenger messenger})
      : super(id: id, messenger: messenger);

  late _PointAnnotationMessenger messenger =
      _PointAnnotationMessenger(binaryMessenger: _messenger);

  /// Add a listener to receive the callback when an annotation is clicked.
  void addOnPointAnnotationClickListener(
      OnPointAnnotationClickListener listener) {
    OnPointAnnotationClickListener.setUp(listener, binaryMessenger: _messenger);
  }

  /// Create a new annotation with the option.
  Future<PointAnnotation> create(PointAnnotationOptions annotation) =>
      messenger.create(id, annotation);

  /// Create multi annotations with the options.
  Future<List<PointAnnotation?>> createMulti(
          List<PointAnnotationOptions> annotations) =>
      messenger.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  Future<void> update(PointAnnotation annotation) =>
      messenger.update(id, annotation);

  /// Delete an added annotation.
  Future<void> delete(PointAnnotation annotation) =>
      messenger.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => messenger.deleteAll(id);

  /// If true, the icon will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<void> setIconAllowOverlap(bool iconAllowOverlap) =>
      messenger.setIconAllowOverlap(id, iconAllowOverlap);

  /// If true, the icon will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<bool?> getIconAllowOverlap() => messenger.getIconAllowOverlap(id);

  /// Part of the icon placed closest to the anchor. Default value: "center".
  Future<void> setIconAnchor(IconAnchor iconAnchor) =>
      messenger.setIconAnchor(id, iconAnchor);

  /// Part of the icon placed closest to the anchor. Default value: "center".
  Future<IconAnchor?> getIconAnchor() => messenger.getIconAnchor(id);

  /// If true, other symbols can be visible even if they collide with the icon. Default value: false.
  Future<void> setIconIgnorePlacement(bool iconIgnorePlacement) =>
      messenger.setIconIgnorePlacement(id, iconIgnorePlacement);

  /// If true, other symbols can be visible even if they collide with the icon. Default value: false.
  Future<bool?> getIconIgnorePlacement() =>
      messenger.getIconIgnorePlacement(id);

  /// Name of image in sprite to use for drawing an image background.
  Future<void> setIconImage(String iconImage) =>
      messenger.setIconImage(id, iconImage);

  /// Name of image in sprite to use for drawing an image background.
  Future<String?> getIconImage() => messenger.getIconImage(id);

  /// If true, the icon may be flipped to prevent it from being rendered upside-down. Default value: false.
  Future<void> setIconKeepUpright(bool iconKeepUpright) =>
      messenger.setIconKeepUpright(id, iconKeepUpright);

  /// If true, the icon may be flipped to prevent it from being rendered upside-down. Default value: false.
  Future<bool?> getIconKeepUpright() => messenger.getIconKeepUpright(id);

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up. Default value: [0,0].
  Future<void> setIconOffset(List<double?> iconOffset) =>
      messenger.setIconOffset(id, iconOffset);

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up. Default value: [0,0].
  Future<List<double?>?> getIconOffset() => messenger.getIconOffset(id);

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not. Default value: false.
  Future<void> setIconOptional(bool iconOptional) =>
      messenger.setIconOptional(id, iconOptional);

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not. Default value: false.
  Future<bool?> getIconOptional() => messenger.getIconOptional(id);

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0.
  Future<void> setIconPadding(double iconPadding) =>
      messenger.setIconPadding(id, iconPadding);

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0.
  Future<double?> getIconPadding() => messenger.getIconPadding(id);

  /// Orientation of icon when map is pitched. Default value: "auto".
  Future<void> setIconPitchAlignment(IconPitchAlignment iconPitchAlignment) =>
      messenger.setIconPitchAlignment(id, iconPitchAlignment);

  /// Orientation of icon when map is pitched. Default value: "auto".
  Future<IconPitchAlignment?> getIconPitchAlignment() =>
      messenger.getIconPitchAlignment(id);

  /// Rotates the icon clockwise. Default value: 0.
  Future<void> setIconRotate(double iconRotate) =>
      messenger.setIconRotate(id, iconRotate);

  /// Rotates the icon clockwise. Default value: 0.
  Future<double?> getIconRotate() => messenger.getIconRotate(id);

  /// In combination with `symbol-placement`, determines the rotation behavior of icons. Default value: "auto".
  Future<void> setIconRotationAlignment(
          IconRotationAlignment iconRotationAlignment) =>
      messenger.setIconRotationAlignment(id, iconRotationAlignment);

  /// In combination with `symbol-placement`, determines the rotation behavior of icons. Default value: "auto".
  Future<IconRotationAlignment?> getIconRotationAlignment() =>
      messenger.getIconRotationAlignment(id);

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image. Default value: 1. Minimum value: 0.
  Future<void> setIconSize(double iconSize) =>
      messenger.setIconSize(id, iconSize);

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image. Default value: 1. Minimum value: 0.
  Future<double?> getIconSize() => messenger.getIconSize(id);

  /// Scales the icon to fit around the associated text. Default value: "none".
  Future<void> setIconTextFit(IconTextFit iconTextFit) =>
      messenger.setIconTextFit(id, iconTextFit);

  /// Scales the icon to fit around the associated text. Default value: "none".
  Future<IconTextFit?> getIconTextFit() => messenger.getIconTextFit(id);

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left. Default value: [0,0,0,0].
  Future<void> setIconTextFitPadding(List<double?> iconTextFitPadding) =>
      messenger.setIconTextFitPadding(id, iconTextFitPadding);

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left. Default value: [0,0,0,0].
  Future<List<double?>?> getIconTextFitPadding() =>
      messenger.getIconTextFitPadding(id);

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries. Default value: false.
  Future<void> setSymbolAvoidEdges(bool symbolAvoidEdges) =>
      messenger.setSymbolAvoidEdges(id, symbolAvoidEdges);

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries. Default value: false.
  Future<bool?> getSymbolAvoidEdges() => messenger.getSymbolAvoidEdges(id);

  /// Label placement relative to its geometry. Default value: "point".
  Future<void> setSymbolPlacement(SymbolPlacement symbolPlacement) =>
      messenger.setSymbolPlacement(id, symbolPlacement);

  /// Label placement relative to its geometry. Default value: "point".
  Future<SymbolPlacement?> getSymbolPlacement() =>
      messenger.getSymbolPlacement(id);

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first. When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  Future<void> setSymbolSortKey(double symbolSortKey) =>
      messenger.setSymbolSortKey(id, symbolSortKey);

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first. When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  Future<double?> getSymbolSortKey() => messenger.getSymbolSortKey(id);

  /// Distance between two symbol anchors. Default value: 250. Minimum value: 1.
  Future<void> setSymbolSpacing(double symbolSpacing) =>
      messenger.setSymbolSpacing(id, symbolSpacing);

  /// Distance between two symbol anchors. Default value: 250. Minimum value: 1.
  Future<double?> getSymbolSpacing() => messenger.getSymbolSpacing(id);

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied. Default value: false.
  Future<void> setSymbolZElevate(bool symbolZElevate) =>
      messenger.setSymbolZElevate(id, symbolZElevate);

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied. Default value: false.
  Future<bool?> getSymbolZElevate() => messenger.getSymbolZElevate(id);

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`. Default value: "auto".
  Future<void> setSymbolZOrder(SymbolZOrder symbolZOrder) =>
      messenger.setSymbolZOrder(id, symbolZOrder);

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`. Default value: "auto".
  Future<SymbolZOrder?> getSymbolZOrder() => messenger.getSymbolZOrder(id);

  /// If true, the text will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<void> setTextAllowOverlap(bool textAllowOverlap) =>
      messenger.setTextAllowOverlap(id, textAllowOverlap);

  /// If true, the text will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<bool?> getTextAllowOverlap() => messenger.getTextAllowOverlap(id);

  /// Part of the text placed closest to the anchor. Default value: "center".
  Future<void> setTextAnchor(TextAnchor textAnchor) =>
      messenger.setTextAnchor(id, textAnchor);

  /// Part of the text placed closest to the anchor. Default value: "center".
  Future<TextAnchor?> getTextAnchor() => messenger.getTextAnchor(id);

  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options. SDF images are not supported in formatted text and will be ignored. Default value: "".
  Future<void> setTextField(String textField) =>
      messenger.setTextField(id, textField);

  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options. SDF images are not supported in formatted text and will be ignored. Default value: "".
  Future<String?> getTextField() => messenger.getTextField(id);

  /// Font stack to use for displaying text.
  Future<void> setTextFont(List<String?> textFont) =>
      messenger.setTextFont(id, textFont);

  /// Font stack to use for displaying text.
  Future<List<String?>?> getTextFont() => messenger.getTextFont(id);

  /// If true, other symbols can be visible even if they collide with the text. Default value: false.
  Future<void> setTextIgnorePlacement(bool textIgnorePlacement) =>
      messenger.setTextIgnorePlacement(id, textIgnorePlacement);

  /// If true, other symbols can be visible even if they collide with the text. Default value: false.
  Future<bool?> getTextIgnorePlacement() =>
      messenger.getTextIgnorePlacement(id);

  /// Text justification options. Default value: "center".
  Future<void> setTextJustify(TextJustify textJustify) =>
      messenger.setTextJustify(id, textJustify);

  /// Text justification options. Default value: "center".
  Future<TextJustify?> getTextJustify() => messenger.getTextJustify(id);

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down. Default value: true.
  Future<void> setTextKeepUpright(bool textKeepUpright) =>
      messenger.setTextKeepUpright(id, textKeepUpright);

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down. Default value: true.
  Future<bool?> getTextKeepUpright() => messenger.getTextKeepUpright(id);

  /// Text tracking amount. Default value: 0.
  Future<void> setTextLetterSpacing(double textLetterSpacing) =>
      messenger.setTextLetterSpacing(id, textLetterSpacing);

  /// Text tracking amount. Default value: 0.
  Future<double?> getTextLetterSpacing() => messenger.getTextLetterSpacing(id);

  /// Text leading value for multi-line text. Default value: 1.2.
  Future<void> setTextLineHeight(double textLineHeight) =>
      messenger.setTextLineHeight(id, textLineHeight);

  /// Text leading value for multi-line text. Default value: 1.2.
  Future<double?> getTextLineHeight() => messenger.getTextLineHeight(id);

  /// Maximum angle change between adjacent characters. Default value: 45.
  Future<void> setTextMaxAngle(double textMaxAngle) =>
      messenger.setTextMaxAngle(id, textMaxAngle);

  /// Maximum angle change between adjacent characters. Default value: 45.
  Future<double?> getTextMaxAngle() => messenger.getTextMaxAngle(id);

  /// The maximum line width for text wrapping. Default value: 10. Minimum value: 0.
  Future<void> setTextMaxWidth(double textMaxWidth) =>
      messenger.setTextMaxWidth(id, textMaxWidth);

  /// The maximum line width for text wrapping. Default value: 10. Minimum value: 0.
  Future<double?> getTextMaxWidth() => messenger.getTextMaxWidth(id);

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position. Default value: [0,0].
  Future<void> setTextOffset(List<double?> textOffset) =>
      messenger.setTextOffset(id, textOffset);

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position. Default value: [0,0].
  Future<List<double?>?> getTextOffset() => messenger.getTextOffset(id);

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not. Default value: false.
  Future<void> setTextOptional(bool textOptional) =>
      messenger.setTextOptional(id, textOptional);

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not. Default value: false.
  Future<bool?> getTextOptional() => messenger.getTextOptional(id);

  /// Size of the additional area around the text bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0.
  Future<void> setTextPadding(double textPadding) =>
      messenger.setTextPadding(id, textPadding);

  /// Size of the additional area around the text bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0.
  Future<double?> getTextPadding() => messenger.getTextPadding(id);

  /// Orientation of text when map is pitched. Default value: "auto".
  Future<void> setTextPitchAlignment(TextPitchAlignment textPitchAlignment) =>
      messenger.setTextPitchAlignment(id, textPitchAlignment);

  /// Orientation of text when map is pitched. Default value: "auto".
  Future<TextPitchAlignment?> getTextPitchAlignment() =>
      messenger.getTextPitchAlignment(id);

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present. Default value: 0.
  Future<void> setTextRadialOffset(double textRadialOffset) =>
      messenger.setTextRadialOffset(id, textRadialOffset);

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present. Default value: 0.
  Future<double?> getTextRadialOffset() => messenger.getTextRadialOffset(id);

  /// Rotates the text clockwise. Default value: 0.
  Future<void> setTextRotate(double textRotate) =>
      messenger.setTextRotate(id, textRotate);

  /// Rotates the text clockwise. Default value: 0.
  Future<double?> getTextRotate() => messenger.getTextRotate(id);

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text. Default value: "auto".
  Future<void> setTextRotationAlignment(
          TextRotationAlignment textRotationAlignment) =>
      messenger.setTextRotationAlignment(id, textRotationAlignment);

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text. Default value: "auto".
  Future<TextRotationAlignment?> getTextRotationAlignment() =>
      messenger.getTextRotationAlignment(id);

  /// Font size. Default value: 16. Minimum value: 0.
  Future<void> setTextSize(double textSize) =>
      messenger.setTextSize(id, textSize);

  /// Font size. Default value: 16. Minimum value: 0.
  Future<double?> getTextSize() => messenger.getTextSize(id);

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property. Default value: "none".
  Future<void> setTextTransform(TextTransform textTransform) =>
      messenger.setTextTransform(id, textTransform);

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property. Default value: "none".
  Future<TextTransform?> getTextTransform() => messenger.getTextTransform(id);

  /// The color of the icon. This can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "#000000".
  Future<void> setIconColor(int iconColor) =>
      messenger.setIconColor(id, iconColor);

  /// The color of the icon. This can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "#000000".
  Future<int?> getIconColor() => messenger.getIconColor(id);

  /// Increase or reduce the saturation of the symbol icon. Default value: 0. Value range: [-1, 1]
  Future<void> setIconColorSaturation(double iconColorSaturation) =>
      messenger.setIconColorSaturation(id, iconColorSaturation);

  /// Increase or reduce the saturation of the symbol icon. Default value: 0. Value range: [-1, 1]
  Future<double?> getIconColorSaturation() =>
      messenger.getIconColorSaturation(id);

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0.
  Future<void> setIconEmissiveStrength(double iconEmissiveStrength) =>
      messenger.setIconEmissiveStrength(id, iconEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0.
  Future<double?> getIconEmissiveStrength() =>
      messenger.getIconEmissiveStrength(id);

  /// Fade out the halo towards the outside. Default value: 0. Minimum value: 0.
  Future<void> setIconHaloBlur(double iconHaloBlur) =>
      messenger.setIconHaloBlur(id, iconHaloBlur);

  /// Fade out the halo towards the outside. Default value: 0. Minimum value: 0.
  Future<double?> getIconHaloBlur() => messenger.getIconHaloBlur(id);

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "rgba(0, 0, 0, 0)".
  Future<void> setIconHaloColor(int iconHaloColor) =>
      messenger.setIconHaloColor(id, iconHaloColor);

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "rgba(0, 0, 0, 0)".
  Future<int?> getIconHaloColor() => messenger.getIconHaloColor(id);

  /// Distance of halo to the icon outline. Default value: 0. Minimum value: 0.
  Future<void> setIconHaloWidth(double iconHaloWidth) =>
      messenger.setIconHaloWidth(id, iconHaloWidth);

  /// Distance of halo to the icon outline. Default value: 0. Minimum value: 0.
  Future<double?> getIconHaloWidth() => messenger.getIconHaloWidth(id);

  /// Controls the transition progress between the image variants of icon-image. Zero means the first variant is used, one is the second, and in between they are blended together. Default value: 0. Value range: [0, 1]
  Future<void> setIconImageCrossFade(double iconImageCrossFade) =>
      messenger.setIconImageCrossFade(id, iconImageCrossFade);

  /// Controls the transition progress between the image variants of icon-image. Zero means the first variant is used, one is the second, and in between they are blended together. Default value: 0. Value range: [0, 1]
  Future<double?> getIconImageCrossFade() =>
      messenger.getIconImageCrossFade(id);

  /// The opacity at which the icon will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<void> setIconOcclusionOpacity(double iconOcclusionOpacity) =>
      messenger.setIconOcclusionOpacity(id, iconOcclusionOpacity);

  /// The opacity at which the icon will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<double?> getIconOcclusionOpacity() =>
      messenger.getIconOcclusionOpacity(id);

  /// The opacity at which the icon will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setIconOpacity(double iconOpacity) =>
      messenger.setIconOpacity(id, iconOpacity);

  /// The opacity at which the icon will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getIconOpacity() => messenger.getIconOpacity(id);

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0].
  Future<void> setIconTranslate(List<double?> iconTranslate) =>
      messenger.setIconTranslate(id, iconTranslate);

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0].
  Future<List<double?>?> getIconTranslate() => messenger.getIconTranslate(id);

  /// Controls the frame of reference for `icon-translate`. Default value: "map".
  Future<void> setIconTranslateAnchor(
          IconTranslateAnchor iconTranslateAnchor) =>
      messenger.setIconTranslateAnchor(id, iconTranslateAnchor);

  /// Controls the frame of reference for `icon-translate`. Default value: "map".
  Future<IconTranslateAnchor?> getIconTranslateAnchor() =>
      messenger.getIconTranslateAnchor(id);

  /// Selects the base of symbol-elevation. Default value: "ground".
  Future<void> setSymbolElevationReference(
          SymbolElevationReference symbolElevationReference) =>
      messenger.setSymbolElevationReference(id, symbolElevationReference);

  /// Selects the base of symbol-elevation. Default value: "ground".
  Future<SymbolElevationReference?> getSymbolElevationReference() =>
      messenger.getSymbolElevationReference(id);

  /// Specifies an uniform elevation from the ground, in meters. Default value: 0. Minimum value: 0.
  Future<void> setSymbolZOffset(double symbolZOffset) =>
      messenger.setSymbolZOffset(id, symbolZOffset);

  /// Specifies an uniform elevation from the ground, in meters. Default value: 0. Minimum value: 0.
  Future<double?> getSymbolZOffset() => messenger.getSymbolZOffset(id);

  /// The color with which the text will be drawn. Default value: "#000000".
  Future<void> setTextColor(int textColor) =>
      messenger.setTextColor(id, textColor);

  /// The color with which the text will be drawn. Default value: "#000000".
  Future<int?> getTextColor() => messenger.getTextColor(id);

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0.
  Future<void> setTextEmissiveStrength(double textEmissiveStrength) =>
      messenger.setTextEmissiveStrength(id, textEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0.
  Future<double?> getTextEmissiveStrength() =>
      messenger.getTextEmissiveStrength(id);

  /// The halo's fadeout distance towards the outside. Default value: 0. Minimum value: 0.
  Future<void> setTextHaloBlur(double textHaloBlur) =>
      messenger.setTextHaloBlur(id, textHaloBlur);

  /// The halo's fadeout distance towards the outside. Default value: 0. Minimum value: 0.
  Future<double?> getTextHaloBlur() => messenger.getTextHaloBlur(id);

  /// The color of the text's halo, which helps it stand out from backgrounds. Default value: "rgba(0, 0, 0, 0)".
  Future<void> setTextHaloColor(int textHaloColor) =>
      messenger.setTextHaloColor(id, textHaloColor);

  /// The color of the text's halo, which helps it stand out from backgrounds. Default value: "rgba(0, 0, 0, 0)".
  Future<int?> getTextHaloColor() => messenger.getTextHaloColor(id);

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size. Default value: 0. Minimum value: 0.
  Future<void> setTextHaloWidth(double textHaloWidth) =>
      messenger.setTextHaloWidth(id, textHaloWidth);

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size. Default value: 0. Minimum value: 0.
  Future<double?> getTextHaloWidth() => messenger.getTextHaloWidth(id);

  /// The opacity at which the text will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<void> setTextOcclusionOpacity(double textOcclusionOpacity) =>
      messenger.setTextOcclusionOpacity(id, textOcclusionOpacity);

  /// The opacity at which the text will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<double?> getTextOcclusionOpacity() =>
      messenger.getTextOcclusionOpacity(id);

  /// The opacity at which the text will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setTextOpacity(double textOpacity) =>
      messenger.setTextOpacity(id, textOpacity);

  /// The opacity at which the text will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getTextOpacity() => messenger.getTextOpacity(id);

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0].
  Future<void> setTextTranslate(List<double?> textTranslate) =>
      messenger.setTextTranslate(id, textTranslate);

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0].
  Future<List<double?>?> getTextTranslate() => messenger.getTextTranslate(id);

  /// Controls the frame of reference for `text-translate`. Default value: "map".
  Future<void> setTextTranslateAnchor(
          TextTranslateAnchor textTranslateAnchor) =>
      messenger.setTextTranslateAnchor(id, textTranslateAnchor);

  /// Controls the frame of reference for `text-translate`. Default value: "map".
  Future<TextTranslateAnchor?> getTextTranslateAnchor() =>
      messenger.getTextTranslateAnchor(id);
}
// End of generated file.
