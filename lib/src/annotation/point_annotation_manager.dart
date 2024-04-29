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

  /// If true, the icon will be visible even if it collides with other previously drawn symbols.
  Future<void> setIconAllowOverlap(bool iconAllowOverlap) =>
      messenger.setIconAllowOverlap(id, iconAllowOverlap);

  /// If true, the icon will be visible even if it collides with other previously drawn symbols.
  Future<bool?> getIconAllowOverlap() => messenger.getIconAllowOverlap(id);

  /// If true, other symbols can be visible even if they collide with the icon.
  Future<void> setIconIgnorePlacement(bool iconIgnorePlacement) =>
      messenger.setIconIgnorePlacement(id, iconIgnorePlacement);

  /// If true, other symbols can be visible even if they collide with the icon.
  Future<bool?> getIconIgnorePlacement() =>
      messenger.getIconIgnorePlacement(id);

  /// If true, the icon may be flipped to prevent it from being rendered upside-down.
  Future<void> setIconKeepUpright(bool iconKeepUpright) =>
      messenger.setIconKeepUpright(id, iconKeepUpright);

  /// If true, the icon may be flipped to prevent it from being rendered upside-down.
  Future<bool?> getIconKeepUpright() => messenger.getIconKeepUpright(id);

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not.
  Future<void> setIconOptional(bool iconOptional) =>
      messenger.setIconOptional(id, iconOptional);

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not.
  Future<bool?> getIconOptional() => messenger.getIconOptional(id);

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions.
  Future<void> setIconPadding(double iconPadding) =>
      messenger.setIconPadding(id, iconPadding);

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions.
  Future<double?> getIconPadding() => messenger.getIconPadding(id);

  /// Orientation of icon when map is pitched.
  Future<void> setIconPitchAlignment(IconPitchAlignment iconPitchAlignment) =>
      messenger.setIconPitchAlignment(id, iconPitchAlignment);

  /// Orientation of icon when map is pitched.
  Future<IconPitchAlignment?> getIconPitchAlignment() =>
      messenger.getIconPitchAlignment(id);

  /// In combination with `symbol-placement`, determines the rotation behavior of icons.
  Future<void> setIconRotationAlignment(
          IconRotationAlignment iconRotationAlignment) =>
      messenger.setIconRotationAlignment(id, iconRotationAlignment);

  /// In combination with `symbol-placement`, determines the rotation behavior of icons.
  Future<IconRotationAlignment?> getIconRotationAlignment() =>
      messenger.getIconRotationAlignment(id);

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries.
  Future<void> setSymbolAvoidEdges(bool symbolAvoidEdges) =>
      messenger.setSymbolAvoidEdges(id, symbolAvoidEdges);

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries.
  Future<bool?> getSymbolAvoidEdges() => messenger.getSymbolAvoidEdges(id);

  /// Label placement relative to its geometry.
  Future<void> setSymbolPlacement(SymbolPlacement symbolPlacement) =>
      messenger.setSymbolPlacement(id, symbolPlacement);

  /// Label placement relative to its geometry.
  Future<SymbolPlacement?> getSymbolPlacement() =>
      messenger.getSymbolPlacement(id);

  /// Distance between two symbol anchors.
  Future<void> setSymbolSpacing(double symbolSpacing) =>
      messenger.setSymbolSpacing(id, symbolSpacing);

  /// Distance between two symbol anchors.
  Future<double?> getSymbolSpacing() => messenger.getSymbolSpacing(id);

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied.
  Future<void> setSymbolZElevate(bool symbolZElevate) =>
      messenger.setSymbolZElevate(id, symbolZElevate);

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied.
  Future<bool?> getSymbolZElevate() => messenger.getSymbolZElevate(id);

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`.
  Future<void> setSymbolZOrder(SymbolZOrder symbolZOrder) =>
      messenger.setSymbolZOrder(id, symbolZOrder);

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`.
  Future<SymbolZOrder?> getSymbolZOrder() => messenger.getSymbolZOrder(id);

  /// If true, the text will be visible even if it collides with other previously drawn symbols.
  Future<void> setTextAllowOverlap(bool textAllowOverlap) =>
      messenger.setTextAllowOverlap(id, textAllowOverlap);

  /// If true, the text will be visible even if it collides with other previously drawn symbols.
  Future<bool?> getTextAllowOverlap() => messenger.getTextAllowOverlap(id);

  /// Font stack to use for displaying text.
  Future<void> setTextFont(List<String?> textFont) =>
      messenger.setTextFont(id, textFont);

  /// Font stack to use for displaying text.
  Future<List<String?>?> getTextFont() => messenger.getTextFont(id);

  /// If true, other symbols can be visible even if they collide with the text.
  Future<void> setTextIgnorePlacement(bool textIgnorePlacement) =>
      messenger.setTextIgnorePlacement(id, textIgnorePlacement);

  /// If true, other symbols can be visible even if they collide with the text.
  Future<bool?> getTextIgnorePlacement() =>
      messenger.getTextIgnorePlacement(id);

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down.
  Future<void> setTextKeepUpright(bool textKeepUpright) =>
      messenger.setTextKeepUpright(id, textKeepUpright);

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down.
  Future<bool?> getTextKeepUpright() => messenger.getTextKeepUpright(id);

  /// Maximum angle change between adjacent characters.
  Future<void> setTextMaxAngle(double textMaxAngle) =>
      messenger.setTextMaxAngle(id, textMaxAngle);

  /// Maximum angle change between adjacent characters.
  Future<double?> getTextMaxAngle() => messenger.getTextMaxAngle(id);

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not.
  Future<void> setTextOptional(bool textOptional) =>
      messenger.setTextOptional(id, textOptional);

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not.
  Future<bool?> getTextOptional() => messenger.getTextOptional(id);

  /// Size of the additional area around the text bounding box used for detecting symbol collisions.
  Future<void> setTextPadding(double textPadding) =>
      messenger.setTextPadding(id, textPadding);

  /// Size of the additional area around the text bounding box used for detecting symbol collisions.
  Future<double?> getTextPadding() => messenger.getTextPadding(id);

  /// Orientation of text when map is pitched.
  Future<void> setTextPitchAlignment(TextPitchAlignment textPitchAlignment) =>
      messenger.setTextPitchAlignment(id, textPitchAlignment);

  /// Orientation of text when map is pitched.
  Future<TextPitchAlignment?> getTextPitchAlignment() =>
      messenger.getTextPitchAlignment(id);

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text.
  Future<void> setTextRotationAlignment(
          TextRotationAlignment textRotationAlignment) =>
      messenger.setTextRotationAlignment(id, textRotationAlignment);

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text.
  Future<TextRotationAlignment?> getTextRotationAlignment() =>
      messenger.getTextRotationAlignment(id);

  /// Controls saturation level of the symbol icon. With the default value of 1 the icon color is preserved while with a value of 0 it is fully desaturated and looks black and white.
  Future<void> setIconColorSaturation(double iconColorSaturation) =>
      messenger.setIconColorSaturation(id, iconColorSaturation);

  /// Controls saturation level of the symbol icon. With the default value of 1 the icon color is preserved while with a value of 0 it is fully desaturated and looks black and white.
  Future<double?> getIconColorSaturation() =>
      messenger.getIconColorSaturation(id);

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  Future<void> setIconTranslate(List<double?> iconTranslate) =>
      messenger.setIconTranslate(id, iconTranslate);

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  Future<List<double?>?> getIconTranslate() => messenger.getIconTranslate(id);

  /// Controls the frame of reference for `icon-translate`.
  Future<void> setIconTranslateAnchor(
          IconTranslateAnchor iconTranslateAnchor) =>
      messenger.setIconTranslateAnchor(id, iconTranslateAnchor);

  /// Controls the frame of reference for `icon-translate`.
  Future<IconTranslateAnchor?> getIconTranslateAnchor() =>
      messenger.getIconTranslateAnchor(id);

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  Future<void> setTextTranslate(List<double?> textTranslate) =>
      messenger.setTextTranslate(id, textTranslate);

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up.
  Future<List<double?>?> getTextTranslate() => messenger.getTextTranslate(id);

  /// Controls the frame of reference for `text-translate`.
  Future<void> setTextTranslateAnchor(
          TextTranslateAnchor textTranslateAnchor) =>
      messenger.setTextTranslateAnchor(id, textTranslateAnchor);

  /// Controls the frame of reference for `text-translate`.
  Future<TextTranslateAnchor?> getTextTranslateAnchor() =>
      messenger.getTextTranslateAnchor(id);
}
// End of generated file.
