// This file is generated.
part of mapbox_maps_flutter;

/// The PointAnnotationManager to add/update/delete PointAnnotationAnnotations on the map.
class PointAnnotationManager extends BaseAnnotationManager {
  PointAnnotationManager._(
      {required super.id,
      required super.messenger,
      required String channelSuffix})
      : _annotationMessenger = _PointAnnotationMessenger(
            binaryMessenger: messenger, messageChannelSuffix: channelSuffix),
        _channelSuffix = channelSuffix,
        super._();

  final _PointAnnotationMessenger _annotationMessenger;
  final String _channelSuffix;

  /// Add a listener to receive the callback when an annotation is clicked.
  @Deprecated('Use [tapEvents] instead.')
  void addOnPointAnnotationClickListener(
      OnPointAnnotationClickListener listener) {
    OnPointAnnotationClickListener._withCancelable(
        tapEvents(onTap: listener.onPointAnnotationClick), _channelSuffix);
  }

  /// Registers tap event callbacks for the annotations managed by this manager.
  ///
  /// Note: Tap events will now not propagate to annotations below the topmost one. If you tap on overlapping annotations, only the top annotation's tap event will be triggered.
  Cancelable tapEvents({required Function(PointAnnotation) onTap}) {
    return _annotationInteractionEvents(instanceName: "$_channelSuffix/$id/tap")
        .cast<PointAnnotationInteractionContext>()
        .listen((data) => onTap(data.annotation))
        .asCancelable();
  }

  /// Registers long press event callbacks for the annotations managed by this manager.
  ///
  /// Note: This event will be triggered simultaneously with the [dragEvents] `onBegin` if the annotation is draggable.
  Cancelable longPressEvents({required Function(PointAnnotation) onLongPress}) {
    return _annotationInteractionEvents(
            instanceName: "$_channelSuffix/$id/long_press")
        .cast<PointAnnotationInteractionContext>()
        .listen((data) => onLongPress(data.annotation))
        .asCancelable();
  }

  /// Registers drag event callbacks for the annotations managed by this manager.
  ///
  /// - [onBegin]: Triggered when a drag gesture begins on an annotation.
  /// - [onChanged]: Triggered continuously as the annotation is being dragged.
  /// - [onEnd]: Triggered when the drag gesture ends.
  ///
  /// This method returns a [Cancelable] object that can be used to cancel
  /// the drag event listener when it's no longer needed.
  /// Example usage:
  /// ```dart
  /// manager.dragEvents(
  ///   onBegin: (annotation) {
  ///     print("Drag started for: ${annotation.id}");
  ///   },
  ///   onChanged: (annotation) {
  ///     print("Dragging at: ${annotation.geometry}");
  ///   },
  ///   onEnd: (annotation) {
  ///     print("Drag ended at: ${annotation.geometry}");
  ///   },
  /// );
  /// ```
  Cancelable dragEvents({
    Function(PointAnnotation)? onBegin,
    Function(PointAnnotation)? onChanged,
    Function(PointAnnotation)? onEnd,
  }) {
    return _annotationInteractionEvents(
            instanceName: "$_channelSuffix/$id/drag")
        .cast<PointAnnotationInteractionContext>()
        .listen((data) {
      switch (data.gestureState) {
        case GestureState.started when onBegin != null:
          onBegin(data.annotation);
        case GestureState.changed when onChanged != null:
          onChanged(data.annotation);
        case GestureState.ended when onEnd != null:
          onEnd(data.annotation);
        default:
          break;
      }
    }).asCancelable();
  }

  /// Create a new annotation with the option.
  Future<PointAnnotation> create(PointAnnotationOptions annotation) =>
      _annotationMessenger.create(id, annotation);

  /// Create multi annotations with the options.
  Future<List<PointAnnotation?>> createMulti(
          List<PointAnnotationOptions> annotations) =>
      _annotationMessenger.createMulti(id, annotations);

  /// Update an added annotation with new properties.
  Future<void> update(PointAnnotation annotation) =>
      _annotationMessenger.update(id, annotation);

  /// Delete an added annotation.
  Future<void> delete(PointAnnotation annotation) =>
      _annotationMessenger.delete(id, annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => _annotationMessenger.deleteAll(id);

  /// If true, the icon will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<void> setIconAllowOverlap(bool iconAllowOverlap) =>
      _annotationMessenger.setIconAllowOverlap(id, iconAllowOverlap);

  /// If true, the icon will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<bool?> getIconAllowOverlap() =>
      _annotationMessenger.getIconAllowOverlap(id);

  /// Part of the icon placed closest to the anchor. Default value: "center".
  Future<void> setIconAnchor(IconAnchor iconAnchor) =>
      _annotationMessenger.setIconAnchor(id, iconAnchor);

  /// Part of the icon placed closest to the anchor. Default value: "center".
  Future<IconAnchor?> getIconAnchor() => _annotationMessenger.getIconAnchor(id);

  /// If true, other symbols can be visible even if they collide with the icon. Default value: false.
  Future<void> setIconIgnorePlacement(bool iconIgnorePlacement) =>
      _annotationMessenger.setIconIgnorePlacement(id, iconIgnorePlacement);

  /// If true, other symbols can be visible even if they collide with the icon. Default value: false.
  Future<bool?> getIconIgnorePlacement() =>
      _annotationMessenger.getIconIgnorePlacement(id);

  /// Name of image in sprite to use for drawing an image background.
  Future<void> setIconImage(String iconImage) =>
      _annotationMessenger.setIconImage(id, iconImage);

  /// Name of image in sprite to use for drawing an image background.
  Future<String?> getIconImage() => _annotationMessenger.getIconImage(id);

  /// If true, the icon may be flipped to prevent it from being rendered upside-down. Default value: false.
  Future<void> setIconKeepUpright(bool iconKeepUpright) =>
      _annotationMessenger.setIconKeepUpright(id, iconKeepUpright);

  /// If true, the icon may be flipped to prevent it from being rendered upside-down. Default value: false.
  Future<bool?> getIconKeepUpright() =>
      _annotationMessenger.getIconKeepUpright(id);

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up. Default value: [0,0].
  Future<void> setIconOffset(List<double?> iconOffset) =>
      _annotationMessenger.setIconOffset(id, iconOffset);

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up. Default value: [0,0].
  Future<List<double?>?> getIconOffset() =>
      _annotationMessenger.getIconOffset(id);

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not. Default value: false.
  Future<void> setIconOptional(bool iconOptional) =>
      _annotationMessenger.setIconOptional(id, iconOptional);

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not. Default value: false.
  Future<bool?> getIconOptional() => _annotationMessenger.getIconOptional(id);

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0. The unit of iconPadding is in pixels.
  Future<void> setIconPadding(double iconPadding) =>
      _annotationMessenger.setIconPadding(id, iconPadding);

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0. The unit of iconPadding is in pixels.
  Future<double?> getIconPadding() => _annotationMessenger.getIconPadding(id);

  /// Orientation of icon when map is pitched. Default value: "auto".
  Future<void> setIconPitchAlignment(IconPitchAlignment iconPitchAlignment) =>
      _annotationMessenger.setIconPitchAlignment(id, iconPitchAlignment);

  /// Orientation of icon when map is pitched. Default value: "auto".
  Future<IconPitchAlignment?> getIconPitchAlignment() =>
      _annotationMessenger.getIconPitchAlignment(id);

  /// Rotates the icon clockwise. Default value: 0. The unit of iconRotate is in degrees.
  Future<void> setIconRotate(double iconRotate) =>
      _annotationMessenger.setIconRotate(id, iconRotate);

  /// Rotates the icon clockwise. Default value: 0. The unit of iconRotate is in degrees.
  Future<double?> getIconRotate() => _annotationMessenger.getIconRotate(id);

  /// In combination with `symbol-placement`, determines the rotation behavior of icons. Default value: "auto".
  Future<void> setIconRotationAlignment(
          IconRotationAlignment iconRotationAlignment) =>
      _annotationMessenger.setIconRotationAlignment(id, iconRotationAlignment);

  /// In combination with `symbol-placement`, determines the rotation behavior of icons. Default value: "auto".
  Future<IconRotationAlignment?> getIconRotationAlignment() =>
      _annotationMessenger.getIconRotationAlignment(id);

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image. Default value: 1. Minimum value: 0. The unit of iconSize is in factor of the original icon size.
  Future<void> setIconSize(double iconSize) =>
      _annotationMessenger.setIconSize(id, iconSize);

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image. Default value: 1. Minimum value: 0. The unit of iconSize is in factor of the original icon size.
  Future<double?> getIconSize() => _annotationMessenger.getIconSize(id);

  /// Defines the minimum and maximum scaling factors for icon related properties like `icon-size`, `icon-halo-width`, `icon-halo-blur` Default value: [0.8,2]. Value range: [0.1, 10]
  @experimental
  Future<void> setIconSizeScaleRange(List<double?> iconSizeScaleRange) =>
      _annotationMessenger.setIconSizeScaleRange(id, iconSizeScaleRange);

  /// Defines the minimum and maximum scaling factors for icon related properties like `icon-size`, `icon-halo-width`, `icon-halo-blur` Default value: [0.8,2]. Value range: [0.1, 10]
  @experimental
  Future<List<double?>?> getIconSizeScaleRange() =>
      _annotationMessenger.getIconSizeScaleRange(id);

  /// Scales the icon to fit around the associated text. Default value: "none".
  Future<void> setIconTextFit(IconTextFit iconTextFit) =>
      _annotationMessenger.setIconTextFit(id, iconTextFit);

  /// Scales the icon to fit around the associated text. Default value: "none".
  Future<IconTextFit?> getIconTextFit() =>
      _annotationMessenger.getIconTextFit(id);

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left. Default value: [0,0,0,0]. The unit of iconTextFitPadding is in pixels.
  Future<void> setIconTextFitPadding(List<double?> iconTextFitPadding) =>
      _annotationMessenger.setIconTextFitPadding(id, iconTextFitPadding);

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left. Default value: [0,0,0,0]. The unit of iconTextFitPadding is in pixels.
  Future<List<double?>?> getIconTextFitPadding() =>
      _annotationMessenger.getIconTextFitPadding(id);

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries. Default value: false.
  Future<void> setSymbolAvoidEdges(bool symbolAvoidEdges) =>
      _annotationMessenger.setSymbolAvoidEdges(id, symbolAvoidEdges);

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries. Default value: false.
  Future<bool?> getSymbolAvoidEdges() =>
      _annotationMessenger.getSymbolAvoidEdges(id);

  /// Selects the base of symbol-elevation. Default value: "ground".
  @experimental
  Future<void> setSymbolElevationReference(
          SymbolElevationReference symbolElevationReference) =>
      _annotationMessenger.setSymbolElevationReference(
          id, symbolElevationReference);

  /// Selects the base of symbol-elevation. Default value: "ground".
  @experimental
  Future<SymbolElevationReference?> getSymbolElevationReference() =>
      _annotationMessenger.getSymbolElevationReference(id);

  /// Label placement relative to its geometry. Default value: "point".
  Future<void> setSymbolPlacement(SymbolPlacement symbolPlacement) =>
      _annotationMessenger.setSymbolPlacement(id, symbolPlacement);

  /// Label placement relative to its geometry. Default value: "point".
  Future<SymbolPlacement?> getSymbolPlacement() =>
      _annotationMessenger.getSymbolPlacement(id);

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first. When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  Future<void> setSymbolSortKey(double symbolSortKey) =>
      _annotationMessenger.setSymbolSortKey(id, symbolSortKey);

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first. When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  Future<double?> getSymbolSortKey() =>
      _annotationMessenger.getSymbolSortKey(id);

  /// Distance between two symbol anchors. Default value: 250. Minimum value: 1. The unit of symbolSpacing is in pixels.
  Future<void> setSymbolSpacing(double symbolSpacing) =>
      _annotationMessenger.setSymbolSpacing(id, symbolSpacing);

  /// Distance between two symbol anchors. Default value: 250. Minimum value: 1. The unit of symbolSpacing is in pixels.
  Future<double?> getSymbolSpacing() =>
      _annotationMessenger.getSymbolSpacing(id);

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied. Default value: false.
  Future<void> setSymbolZElevate(bool symbolZElevate) =>
      _annotationMessenger.setSymbolZElevate(id, symbolZElevate);

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied. Default value: false.
  Future<bool?> getSymbolZElevate() =>
      _annotationMessenger.getSymbolZElevate(id);

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`. Default value: "auto".
  Future<void> setSymbolZOrder(SymbolZOrder symbolZOrder) =>
      _annotationMessenger.setSymbolZOrder(id, symbolZOrder);

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`. Default value: "auto".
  Future<SymbolZOrder?> getSymbolZOrder() =>
      _annotationMessenger.getSymbolZOrder(id);

  /// If true, the text will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<void> setTextAllowOverlap(bool textAllowOverlap) =>
      _annotationMessenger.setTextAllowOverlap(id, textAllowOverlap);

  /// If true, the text will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<bool?> getTextAllowOverlap() =>
      _annotationMessenger.getTextAllowOverlap(id);

  /// Part of the text placed closest to the anchor. Default value: "center".
  Future<void> setTextAnchor(TextAnchor textAnchor) =>
      _annotationMessenger.setTextAnchor(id, textAnchor);

  /// Part of the text placed closest to the anchor. Default value: "center".
  Future<TextAnchor?> getTextAnchor() => _annotationMessenger.getTextAnchor(id);

  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options. SDF images are not supported in formatted text and will be ignored. Default value: "".
  Future<void> setTextField(String textField) =>
      _annotationMessenger.setTextField(id, textField);

  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options. SDF images are not supported in formatted text and will be ignored. Default value: "".
  Future<String?> getTextField() => _annotationMessenger.getTextField(id);

  /// Font stack to use for displaying text.
  Future<void> setTextFont(List<String?> textFont) =>
      _annotationMessenger.setTextFont(id, textFont);

  /// Font stack to use for displaying text.
  Future<List<String?>?> getTextFont() => _annotationMessenger.getTextFont(id);

  /// If true, other symbols can be visible even if they collide with the text. Default value: false.
  Future<void> setTextIgnorePlacement(bool textIgnorePlacement) =>
      _annotationMessenger.setTextIgnorePlacement(id, textIgnorePlacement);

  /// If true, other symbols can be visible even if they collide with the text. Default value: false.
  Future<bool?> getTextIgnorePlacement() =>
      _annotationMessenger.getTextIgnorePlacement(id);

  /// Text justification options. Default value: "center".
  Future<void> setTextJustify(TextJustify textJustify) =>
      _annotationMessenger.setTextJustify(id, textJustify);

  /// Text justification options. Default value: "center".
  Future<TextJustify?> getTextJustify() =>
      _annotationMessenger.getTextJustify(id);

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down. Default value: true.
  Future<void> setTextKeepUpright(bool textKeepUpright) =>
      _annotationMessenger.setTextKeepUpright(id, textKeepUpright);

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down. Default value: true.
  Future<bool?> getTextKeepUpright() =>
      _annotationMessenger.getTextKeepUpright(id);

  /// Text tracking amount. Default value: 0. The unit of textLetterSpacing is in ems.
  Future<void> setTextLetterSpacing(double textLetterSpacing) =>
      _annotationMessenger.setTextLetterSpacing(id, textLetterSpacing);

  /// Text tracking amount. Default value: 0. The unit of textLetterSpacing is in ems.
  Future<double?> getTextLetterSpacing() =>
      _annotationMessenger.getTextLetterSpacing(id);

  /// Text leading value for multi-line text. Default value: 1.2. The unit of textLineHeight is in ems.
  Future<void> setTextLineHeight(double textLineHeight) =>
      _annotationMessenger.setTextLineHeight(id, textLineHeight);

  /// Text leading value for multi-line text. Default value: 1.2. The unit of textLineHeight is in ems.
  Future<double?> getTextLineHeight() =>
      _annotationMessenger.getTextLineHeight(id);

  /// Maximum angle change between adjacent characters. Default value: 45. The unit of textMaxAngle is in degrees.
  Future<void> setTextMaxAngle(double textMaxAngle) =>
      _annotationMessenger.setTextMaxAngle(id, textMaxAngle);

  /// Maximum angle change between adjacent characters. Default value: 45. The unit of textMaxAngle is in degrees.
  Future<double?> getTextMaxAngle() => _annotationMessenger.getTextMaxAngle(id);

  /// The maximum line width for text wrapping. Default value: 10. Minimum value: 0. The unit of textMaxWidth is in ems.
  Future<void> setTextMaxWidth(double textMaxWidth) =>
      _annotationMessenger.setTextMaxWidth(id, textMaxWidth);

  /// The maximum line width for text wrapping. Default value: 10. Minimum value: 0. The unit of textMaxWidth is in ems.
  Future<double?> getTextMaxWidth() => _annotationMessenger.getTextMaxWidth(id);

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position. Default value: [0,0]. The unit of textOffset is in ems.
  Future<void> setTextOffset(List<double?> textOffset) =>
      _annotationMessenger.setTextOffset(id, textOffset);

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position. Default value: [0,0]. The unit of textOffset is in ems.
  Future<List<double?>?> getTextOffset() =>
      _annotationMessenger.getTextOffset(id);

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not. Default value: false.
  Future<void> setTextOptional(bool textOptional) =>
      _annotationMessenger.setTextOptional(id, textOptional);

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not. Default value: false.
  Future<bool?> getTextOptional() => _annotationMessenger.getTextOptional(id);

  /// Size of the additional area around the text bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0. The unit of textPadding is in pixels.
  Future<void> setTextPadding(double textPadding) =>
      _annotationMessenger.setTextPadding(id, textPadding);

  /// Size of the additional area around the text bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0. The unit of textPadding is in pixels.
  Future<double?> getTextPadding() => _annotationMessenger.getTextPadding(id);

  /// Orientation of text when map is pitched. Default value: "auto".
  Future<void> setTextPitchAlignment(TextPitchAlignment textPitchAlignment) =>
      _annotationMessenger.setTextPitchAlignment(id, textPitchAlignment);

  /// Orientation of text when map is pitched. Default value: "auto".
  Future<TextPitchAlignment?> getTextPitchAlignment() =>
      _annotationMessenger.getTextPitchAlignment(id);

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present. Default value: 0. The unit of textRadialOffset is in ems.
  Future<void> setTextRadialOffset(double textRadialOffset) =>
      _annotationMessenger.setTextRadialOffset(id, textRadialOffset);

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present. Default value: 0. The unit of textRadialOffset is in ems.
  Future<double?> getTextRadialOffset() =>
      _annotationMessenger.getTextRadialOffset(id);

  /// Rotates the text clockwise. Default value: 0. The unit of textRotate is in degrees.
  Future<void> setTextRotate(double textRotate) =>
      _annotationMessenger.setTextRotate(id, textRotate);

  /// Rotates the text clockwise. Default value: 0. The unit of textRotate is in degrees.
  Future<double?> getTextRotate() => _annotationMessenger.getTextRotate(id);

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text. Default value: "auto".
  Future<void> setTextRotationAlignment(
          TextRotationAlignment textRotationAlignment) =>
      _annotationMessenger.setTextRotationAlignment(id, textRotationAlignment);

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text. Default value: "auto".
  Future<TextRotationAlignment?> getTextRotationAlignment() =>
      _annotationMessenger.getTextRotationAlignment(id);

  /// Font size. Default value: 16. Minimum value: 0. The unit of textSize is in pixels.
  Future<void> setTextSize(double textSize) =>
      _annotationMessenger.setTextSize(id, textSize);

  /// Font size. Default value: 16. Minimum value: 0. The unit of textSize is in pixels.
  Future<double?> getTextSize() => _annotationMessenger.getTextSize(id);

  /// Defines the minimum and maximum scaling factors for text related properties like `text-size`, `text-max-width`, `text-halo-width`, `font-size` Default value: [0.8,2]. Value range: [0.1, 10]
  @experimental
  Future<void> setTextSizeScaleRange(List<double?> textSizeScaleRange) =>
      _annotationMessenger.setTextSizeScaleRange(id, textSizeScaleRange);

  /// Defines the minimum and maximum scaling factors for text related properties like `text-size`, `text-max-width`, `text-halo-width`, `font-size` Default value: [0.8,2]. Value range: [0.1, 10]
  @experimental
  Future<List<double?>?> getTextSizeScaleRange() =>
      _annotationMessenger.getTextSizeScaleRange(id);

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property. Default value: "none".
  Future<void> setTextTransform(TextTransform textTransform) =>
      _annotationMessenger.setTextTransform(id, textTransform);

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property. Default value: "none".
  Future<TextTransform?> getTextTransform() =>
      _annotationMessenger.getTextTransform(id);

  /// The color of the icon. This can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "#000000".
  Future<void> setIconColor(int iconColor) =>
      _annotationMessenger.setIconColor(id, iconColor);

  /// The color of the icon. This can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "#000000".
  Future<int?> getIconColor() => _annotationMessenger.getIconColor(id);

  /// Increase or reduce the saturation of the symbol icon. Default value: 0. Value range: [-1, 1]
  Future<void> setIconColorSaturation(double iconColorSaturation) =>
      _annotationMessenger.setIconColorSaturation(id, iconColorSaturation);

  /// Increase or reduce the saturation of the symbol icon. Default value: 0. Value range: [-1, 1]
  Future<double?> getIconColorSaturation() =>
      _annotationMessenger.getIconColorSaturation(id);

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0. The unit of iconEmissiveStrength is in intensity.
  Future<void> setIconEmissiveStrength(double iconEmissiveStrength) =>
      _annotationMessenger.setIconEmissiveStrength(id, iconEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0. The unit of iconEmissiveStrength is in intensity.
  Future<double?> getIconEmissiveStrength() =>
      _annotationMessenger.getIconEmissiveStrength(id);

  /// Fade out the halo towards the outside. Default value: 0. Minimum value: 0. The unit of iconHaloBlur is in pixels.
  Future<void> setIconHaloBlur(double iconHaloBlur) =>
      _annotationMessenger.setIconHaloBlur(id, iconHaloBlur);

  /// Fade out the halo towards the outside. Default value: 0. Minimum value: 0. The unit of iconHaloBlur is in pixels.
  Future<double?> getIconHaloBlur() => _annotationMessenger.getIconHaloBlur(id);

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "rgba(0, 0, 0, 0)".
  Future<void> setIconHaloColor(int iconHaloColor) =>
      _annotationMessenger.setIconHaloColor(id, iconHaloColor);

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "rgba(0, 0, 0, 0)".
  Future<int?> getIconHaloColor() => _annotationMessenger.getIconHaloColor(id);

  /// Distance of halo to the icon outline. Default value: 0. Minimum value: 0. The unit of iconHaloWidth is in pixels.
  Future<void> setIconHaloWidth(double iconHaloWidth) =>
      _annotationMessenger.setIconHaloWidth(id, iconHaloWidth);

  /// Distance of halo to the icon outline. Default value: 0. Minimum value: 0. The unit of iconHaloWidth is in pixels.
  Future<double?> getIconHaloWidth() =>
      _annotationMessenger.getIconHaloWidth(id);

  /// Controls the transition progress between the image variants of icon-image. Zero means the first variant is used, one is the second, and in between they are blended together. Both images should be the same size and have the same type (either raster or vector). Default value: 0. Value range: [0, 1]
  Future<void> setIconImageCrossFade(double iconImageCrossFade) =>
      _annotationMessenger.setIconImageCrossFade(id, iconImageCrossFade);

  /// Controls the transition progress between the image variants of icon-image. Zero means the first variant is used, one is the second, and in between they are blended together. Both images should be the same size and have the same type (either raster or vector). Default value: 0. Value range: [0, 1]
  Future<double?> getIconImageCrossFade() =>
      _annotationMessenger.getIconImageCrossFade(id);

  /// The opacity at which the icon will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<void> setIconOcclusionOpacity(double iconOcclusionOpacity) =>
      _annotationMessenger.setIconOcclusionOpacity(id, iconOcclusionOpacity);

  /// The opacity at which the icon will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<double?> getIconOcclusionOpacity() =>
      _annotationMessenger.getIconOcclusionOpacity(id);

  /// The opacity at which the icon will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setIconOpacity(double iconOpacity) =>
      _annotationMessenger.setIconOpacity(id, iconOpacity);

  /// The opacity at which the icon will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getIconOpacity() => _annotationMessenger.getIconOpacity(id);

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0]. The unit of iconTranslate is in pixels.
  Future<void> setIconTranslate(List<double?> iconTranslate) =>
      _annotationMessenger.setIconTranslate(id, iconTranslate);

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0]. The unit of iconTranslate is in pixels.
  Future<List<double?>?> getIconTranslate() =>
      _annotationMessenger.getIconTranslate(id);

  /// Controls the frame of reference for `icon-translate`. Default value: "map".
  Future<void> setIconTranslateAnchor(
          IconTranslateAnchor iconTranslateAnchor) =>
      _annotationMessenger.setIconTranslateAnchor(id, iconTranslateAnchor);

  /// Controls the frame of reference for `icon-translate`. Default value: "map".
  Future<IconTranslateAnchor?> getIconTranslateAnchor() =>
      _annotationMessenger.getIconTranslateAnchor(id);

  /// Specifies an uniform elevation from the ground, in meters. Default value: 0. Minimum value: 0.
  @experimental
  Future<void> setSymbolZOffset(double symbolZOffset) =>
      _annotationMessenger.setSymbolZOffset(id, symbolZOffset);

  /// Specifies an uniform elevation from the ground, in meters. Default value: 0. Minimum value: 0.
  @experimental
  Future<double?> getSymbolZOffset() =>
      _annotationMessenger.getSymbolZOffset(id);

  /// The color with which the text will be drawn. Default value: "#000000".
  Future<void> setTextColor(int textColor) =>
      _annotationMessenger.setTextColor(id, textColor);

  /// The color with which the text will be drawn. Default value: "#000000".
  Future<int?> getTextColor() => _annotationMessenger.getTextColor(id);

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0. The unit of textEmissiveStrength is in intensity.
  Future<void> setTextEmissiveStrength(double textEmissiveStrength) =>
      _annotationMessenger.setTextEmissiveStrength(id, textEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0. The unit of textEmissiveStrength is in intensity.
  Future<double?> getTextEmissiveStrength() =>
      _annotationMessenger.getTextEmissiveStrength(id);

  /// The halo's fadeout distance towards the outside. Default value: 0. Minimum value: 0. The unit of textHaloBlur is in pixels.
  Future<void> setTextHaloBlur(double textHaloBlur) =>
      _annotationMessenger.setTextHaloBlur(id, textHaloBlur);

  /// The halo's fadeout distance towards the outside. Default value: 0. Minimum value: 0. The unit of textHaloBlur is in pixels.
  Future<double?> getTextHaloBlur() => _annotationMessenger.getTextHaloBlur(id);

  /// The color of the text's halo, which helps it stand out from backgrounds. Default value: "rgba(0, 0, 0, 0)".
  Future<void> setTextHaloColor(int textHaloColor) =>
      _annotationMessenger.setTextHaloColor(id, textHaloColor);

  /// The color of the text's halo, which helps it stand out from backgrounds. Default value: "rgba(0, 0, 0, 0)".
  Future<int?> getTextHaloColor() => _annotationMessenger.getTextHaloColor(id);

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size. Default value: 0. Minimum value: 0. The unit of textHaloWidth is in pixels.
  Future<void> setTextHaloWidth(double textHaloWidth) =>
      _annotationMessenger.setTextHaloWidth(id, textHaloWidth);

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size. Default value: 0. Minimum value: 0. The unit of textHaloWidth is in pixels.
  Future<double?> getTextHaloWidth() =>
      _annotationMessenger.getTextHaloWidth(id);

  /// The opacity at which the text will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<void> setTextOcclusionOpacity(double textOcclusionOpacity) =>
      _annotationMessenger.setTextOcclusionOpacity(id, textOcclusionOpacity);

  /// The opacity at which the text will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<double?> getTextOcclusionOpacity() =>
      _annotationMessenger.getTextOcclusionOpacity(id);

  /// The opacity at which the text will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setTextOpacity(double textOpacity) =>
      _annotationMessenger.setTextOpacity(id, textOpacity);

  /// The opacity at which the text will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getTextOpacity() => _annotationMessenger.getTextOpacity(id);

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0]. The unit of textTranslate is in pixels.
  Future<void> setTextTranslate(List<double?> textTranslate) =>
      _annotationMessenger.setTextTranslate(id, textTranslate);

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0]. The unit of textTranslate is in pixels.
  Future<List<double?>?> getTextTranslate() =>
      _annotationMessenger.getTextTranslate(id);

  /// Controls the frame of reference for `text-translate`. Default value: "map".
  Future<void> setTextTranslateAnchor(
          TextTranslateAnchor textTranslateAnchor) =>
      _annotationMessenger.setTextTranslateAnchor(id, textTranslateAnchor);

  /// Controls the frame of reference for `text-translate`. Default value: "map".
  Future<TextTranslateAnchor?> getTextTranslateAnchor() =>
      _annotationMessenger.getTextTranslateAnchor(id);
}
// End of generated file.
