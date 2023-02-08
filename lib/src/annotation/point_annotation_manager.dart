// This file is generated.
part of mapbox_maps_flutter;

/// The PointAnnotationManager to add/update/delete PointAnnotationAnnotations on the map.
class PointAnnotationManager extends BaseAnnotationManager {
  PointAnnotationManager(
      {required String id, required BinaryMessenger messenger})
      : super(id: id, messenger: messenger);

  late _PointAnnotationMessager messager =
      _PointAnnotationMessager(binaryMessenger: _messenger);

  /// Add a listener to receive the callback when an annotation is clicked.
  void addOnPointAnnotationClickListener(
      OnPointAnnotationClickListener listener) {
    OnPointAnnotationClickListener.setup(listener, binaryMessenger: _messenger);
  }

  /// Create a new annotation with the option.
  Future<PointAnnotation> create(PointAnnotationOptions annotation) =>
      messager.create(id, annotation);

  /// Create multi annotations with the options.
  Future<List<PointAnnotation?>> createMulti(
          List<PointAnnotationOptions> annotations) =>
      messager.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  Future<void> update(PointAnnotation annotation) =>
      messager.update(id, annotation);

  /// Delete an added annotation.
  Future<void> delete(PointAnnotation annotation) =>
      messager.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => messager.deleteAll(id);

  /// If true, the icon will be visible even if it collides with other previously drawn symbols.
  Future<void> setIconAllowOverlap(bool iconAllowOverlap) =>
      messager.setIconAllowOverlap(id, iconAllowOverlap);

  /// If true, the icon will be visible even if it collides with other previously drawn symbols.
  Future<bool?> getIconAllowOverlap() => messager.getIconAllowOverlap(id);

  /// If true, other symbols can be visible even if they collide with the icon.
  Future<void> setIconIgnorePlacement(bool iconIgnorePlacement) =>
      messager.setIconIgnorePlacement(id, iconIgnorePlacement);

  /// If true, other symbols can be visible even if they collide with the icon.
  Future<bool?> getIconIgnorePlacement() => messager.getIconIgnorePlacement(id);

  /// If true, the icon may be flipped to prevent it from being rendered upside-down.
  Future<void> setIconKeepUpright(bool iconKeepUpright) =>
      messager.setIconKeepUpright(id, iconKeepUpright);

  /// If true, the icon may be flipped to prevent it from being rendered upside-down.
  Future<bool?> getIconKeepUpright() => messager.getIconKeepUpright(id);

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not.
  Future<void> setIconOptional(bool iconOptional) =>
      messager.setIconOptional(id, iconOptional);

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not.
  Future<bool?> getIconOptional() => messager.getIconOptional(id);

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions.
  Future<void> setIconPadding(double iconPadding) =>
      messager.setIconPadding(id, iconPadding);

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions.
  Future<double?> getIconPadding() => messager.getIconPadding(id);

  /// Orientation of icon when map is pitched.
  Future<void> setIconPitchAlignment(IconPitchAlignment iconPitchAlignment) =>
      messager.setIconPitchAlignment(id, iconPitchAlignment);

  /// Orientation of icon when map is pitched.
  Future<IconPitchAlignment?> getIconPitchAlignment() => messager
      .getIconPitchAlignment(id)
      .then((value) => value != null ? IconPitchAlignment.values[value] : null);

  /// In combination with `symbol-placement`, determines the rotation behavior of icons.
  Future<void> setIconRotationAlignment(
          IconRotationAlignment iconRotationAlignment) =>
      messager.setIconRotationAlignment(id, iconRotationAlignment);

  /// In combination with `symbol-placement`, determines the rotation behavior of icons.
  Future<IconRotationAlignment?> getIconRotationAlignment() =>
      messager.getIconRotationAlignment(id).then((value) =>
          value != null ? IconRotationAlignment.values[value] : null);

  /// Scales the icon to fit around the associated text.
  Future<void> setIconTextFit(IconTextFit iconTextFit) =>
      messager.setIconTextFit(id, iconTextFit);

  /// Scales the icon to fit around the associated text.
  Future<IconTextFit?> getIconTextFit() => messager
      .getIconTextFit(id)
      .then((value) => value != null ? IconTextFit.values[value] : null);

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left.
  Future<void> setIconTextFitPadding(List<double?> iconTextFitPadding) =>
      messager.setIconTextFitPadding(id, iconTextFitPadding);

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left.
  Future<List<double?>?> getIconTextFitPadding() =>
      messager.getIconTextFitPadding(id);

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries.
  Future<void> setSymbolAvoidEdges(bool symbolAvoidEdges) =>
      messager.setSymbolAvoidEdges(id, symbolAvoidEdges);

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries.
  Future<bool?> getSymbolAvoidEdges() => messager.getSymbolAvoidEdges(id);

  /// Label placement relative to its geometry.
  Future<void> setSymbolPlacement(SymbolPlacement symbolPlacement) =>
      messager.setSymbolPlacement(id, symbolPlacement);

  /// Label placement relative to its geometry.
  Future<SymbolPlacement?> getSymbolPlacement() => messager
      .getSymbolPlacement(id)
      .then((value) => value != null ? SymbolPlacement.values[value] : null);

  /// Distance between two symbol anchors.
  Future<void> setSymbolSpacing(double symbolSpacing) =>
      messager.setSymbolSpacing(id, symbolSpacing);

  /// Distance between two symbol anchors.
  Future<double?> getSymbolSpacing() => messager.getSymbolSpacing(id);

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`.
  Future<void> setSymbolZOrder(SymbolZOrder symbolZOrder) =>
      messager.setSymbolZOrder(id, symbolZOrder);

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`.
  Future<SymbolZOrder?> getSymbolZOrder() => messager
      .getSymbolZOrder(id)
      .then((value) => value != null ? SymbolZOrder.values[value] : null);

  /// If true, the text will be visible even if it collides with other previously drawn symbols.
  Future<void> setTextAllowOverlap(bool textAllowOverlap) =>
      messager.setTextAllowOverlap(id, textAllowOverlap);

  /// If true, the text will be visible even if it collides with other previously drawn symbols.
  Future<bool?> getTextAllowOverlap() => messager.getTextAllowOverlap(id);

  /// Font stack to use for displaying text.
  Future<void> setTextFont(List<String?> textFont) =>
      messager.setTextFont(id, textFont);

  /// Font stack to use for displaying text.
  Future<List<String?>?> getTextFont() => messager.getTextFont(id);

  /// If true, other symbols can be visible even if they collide with the text.
  Future<void> setTextIgnorePlacement(bool textIgnorePlacement) =>
      messager.setTextIgnorePlacement(id, textIgnorePlacement);

  /// If true, other symbols can be visible even if they collide with the text.
  Future<bool?> getTextIgnorePlacement() => messager.getTextIgnorePlacement(id);

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down.
  Future<void> setTextKeepUpright(bool textKeepUpright) =>
      messager.setTextKeepUpright(id, textKeepUpright);

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down.
  Future<bool?> getTextKeepUpright() => messager.getTextKeepUpright(id);

  /// Text leading value for multi-line text.
  Future<void> setTextLineHeight(double textLineHeight) =>
      messager.setTextLineHeight(id, textLineHeight);

  /// Text leading value for multi-line text.
  Future<double?> getTextLineHeight() => messager.getTextLineHeight(id);

  /// Maximum angle change between adjacent characters.
  Future<void> setTextMaxAngle(double textMaxAngle) =>
      messager.setTextMaxAngle(id, textMaxAngle);

  /// Maximum angle change between adjacent characters.
  Future<double?> getTextMaxAngle() => messager.getTextMaxAngle(id);

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not.
  Future<void> setTextOptional(bool textOptional) =>
      messager.setTextOptional(id, textOptional);

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not.
  Future<bool?> getTextOptional() => messager.getTextOptional(id);

  /// Size of the additional area around the text bounding box used for detecting symbol collisions.
  Future<void> setTextPadding(double textPadding) =>
      messager.setTextPadding(id, textPadding);

  /// Size of the additional area around the text bounding box used for detecting symbol collisions.
  Future<double?> getTextPadding() => messager.getTextPadding(id);

  /// Orientation of text when map is pitched.
  Future<void> setTextPitchAlignment(TextPitchAlignment textPitchAlignment) =>
      messager.setTextPitchAlignment(id, textPitchAlignment);

  /// Orientation of text when map is pitched.
  Future<TextPitchAlignment?> getTextPitchAlignment() => messager
      .getTextPitchAlignment(id)
      .then((value) => value != null ? TextPitchAlignment.values[value] : null);

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text.
  Future<void> setTextRotationAlignment(
          TextRotationAlignment textRotationAlignment) =>
      messager.setTextRotationAlignment(id, textRotationAlignment);

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text.
  Future<TextRotationAlignment?> getTextRotationAlignment() =>
      messager.getTextRotationAlignment(id).then((value) =>
          value != null ? TextRotationAlignment.values[value] : null);

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  Future<void> setIconTranslate(List<double?> iconTranslate) =>
      messager.setIconTranslate(id, iconTranslate);

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  Future<List<double?>?> getIconTranslate() => messager.getIconTranslate(id);

  /// Controls the frame of reference for `icon-translate`.
  Future<void> setIconTranslateAnchor(
          IconTranslateAnchor iconTranslateAnchor) =>
      messager.setIconTranslateAnchor(id, iconTranslateAnchor);

  /// Controls the frame of reference for `icon-translate`.
  Future<IconTranslateAnchor?> getIconTranslateAnchor() =>
      messager.getIconTranslateAnchor(id).then(
          (value) => value != null ? IconTranslateAnchor.values[value] : null);

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  Future<void> setTextTranslate(List<double?> textTranslate) =>
      messager.setTextTranslate(id, textTranslate);

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  Future<List<double?>?> getTextTranslate() => messager.getTextTranslate(id);

  /// Controls the frame of reference for `text-translate`.
  Future<void> setTextTranslateAnchor(
          TextTranslateAnchor textTranslateAnchor) =>
      messager.setTextTranslateAnchor(id, textTranslateAnchor);

  /// Controls the frame of reference for `text-translate`.
  Future<TextTranslateAnchor?> getTextTranslateAnchor() =>
      messager.getTextTranslateAnchor(id).then(
          (value) => value != null ? TextTranslateAnchor.values[value] : null);
}
// End of generated file.
