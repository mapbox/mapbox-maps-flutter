// This file is generated.
import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../annotations_manager.dart' show BaseAnnotationManager;

/// Manages point annotations.
final class PointAnnotationManager
    extends BaseAnnotationManager<PointAnnotationManagerPlatformInterface> {
  @internal
  PointAnnotationManager(PointAnnotationManagerPlatformInterface super.impl);

  /// Registers tap event callbacks for the annotations managed by this manager.
  ///
  /// Note: Tap events will now not propagate to annotations below the topmost one. If you tap on overlapping annotations, only the top annotation's tap event will be triggered.
  Cancelable tapEvents({required Function(PointAnnotation) onTap}) => impl
      .tapInteractionStream
      .listen((data) => onTap(data.annotation))
      .asCancelable();

  /// Registers long press event callbacks for the annotations managed by this manager.
  ///
  /// Note: This event will be triggered simultaneously with the [dragEvents] `onBegin` if the annotation is draggable.
  Cancelable longPressEvents({
    required Function(PointAnnotation) onLongPress,
  }) => impl.longPressInteractionStream
      .listen((data) => onLongPress(data.annotation))
      .asCancelable();

  /// Registers drag event callbacks for the annotations managed by this manager.
  ///
  /// - [onBegin]: Triggered when a drag gesture begins on an annotation.
  /// - [onChanged]: Triggered continuously as the annotation is being dragged.
  /// - [onEnd]: Triggered when the drag gesture ends.
  ///
  /// This method returns a [Cancelable] object that can be used to cancel
  /// the drag event listener when it's no longer needed.
  Cancelable dragEvents({
    Function(PointAnnotation)? onBegin,
    Function(PointAnnotation)? onChanged,
    Function(PointAnnotation)? onEnd,
  }) => impl.dragInteractionStream.listen((data) {
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

  /// Get all annotations of manager.
  Future<List<PointAnnotation>> getAnnotations() => impl.getAnnotations();

  /// Create a new annotation with the option.
  Future<PointAnnotation> create(PointAnnotationOptions annotation) =>
      impl.create(annotation);

  /// Create multi annotations with the options.
  Future<List<PointAnnotation?>> createMulti(
    List<PointAnnotationOptions> annotations,
  ) => impl.createMulti(annotations);

  /// Update an added annotation with new properties.
  Future<void> update(PointAnnotation annotation) => impl.update(annotation);

  /// Delete an added annotation.
  Future<void> delete(PointAnnotation annotation) => impl.delete(annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => impl.deleteAll();

  /// Delete multiple annotations added by this manager.
  Future<void> deleteMulti(List<PointAnnotation> annotations) =>
      impl.deleteMulti(annotations);

  /// If true, the icon will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<void> setIconAllowOverlap(bool iconAllowOverlap) =>
      impl.setIconAllowOverlap(iconAllowOverlap);

  /// If true, the icon will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<bool?> getIconAllowOverlap() => impl.getIconAllowOverlap();

  /// Part of the icon placed closest to the anchor. Default value: "center".
  Future<void> setIconAnchor(IconAnchor iconAnchor) =>
      impl.setIconAnchor(iconAnchor);

  /// Part of the icon placed closest to the anchor. Default value: "center".
  Future<IconAnchor?> getIconAnchor() => impl.getIconAnchor();

  /// If true, other symbols can be visible even if they collide with the icon. Default value: false.
  Future<void> setIconIgnorePlacement(bool iconIgnorePlacement) =>
      impl.setIconIgnorePlacement(iconIgnorePlacement);

  /// If true, other symbols can be visible even if they collide with the icon. Default value: false.
  Future<bool?> getIconIgnorePlacement() => impl.getIconIgnorePlacement();

  /// Name of image in sprite to use for drawing an image background.
  Future<void> setIconImage(String iconImage) => impl.setIconImage(iconImage);

  /// Name of image in sprite to use for drawing an image background.
  Future<String?> getIconImage() => impl.getIconImage();

  /// If true, the icon may be flipped to prevent it from being rendered upside-down. Default value: false.
  Future<void> setIconKeepUpright(bool iconKeepUpright) =>
      impl.setIconKeepUpright(iconKeepUpright);

  /// If true, the icon may be flipped to prevent it from being rendered upside-down. Default value: false.
  Future<bool?> getIconKeepUpright() => impl.getIconKeepUpright();

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up. Default value: [0,0].
  Future<void> setIconOffset(List<double?> iconOffset) =>
      impl.setIconOffset(iconOffset);

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up. Default value: [0,0].
  Future<List<double?>?> getIconOffset() => impl.getIconOffset();

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not. Default value: false.
  Future<void> setIconOptional(bool iconOptional) =>
      impl.setIconOptional(iconOptional);

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not. Default value: false.
  Future<bool?> getIconOptional() => impl.getIconOptional();

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0. The unit of iconPadding is in pixels.
  Future<void> setIconPadding(double iconPadding) =>
      impl.setIconPadding(iconPadding);

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0. The unit of iconPadding is in pixels.
  Future<double?> getIconPadding() => impl.getIconPadding();

  /// Orientation of icon when map is pitched. Default value: "auto".
  Future<void> setIconPitchAlignment(IconPitchAlignment iconPitchAlignment) =>
      impl.setIconPitchAlignment(iconPitchAlignment);

  /// Orientation of icon when map is pitched. Default value: "auto".
  Future<IconPitchAlignment?> getIconPitchAlignment() =>
      impl.getIconPitchAlignment();

  /// Rotates the icon clockwise. Default value: 0. The unit of iconRotate is in degrees.
  Future<void> setIconRotate(double iconRotate) =>
      impl.setIconRotate(iconRotate);

  /// Rotates the icon clockwise. Default value: 0. The unit of iconRotate is in degrees.
  Future<double?> getIconRotate() => impl.getIconRotate();

  /// In combination with `symbol-placement`, determines the rotation behavior of icons. Default value: "auto".
  Future<void> setIconRotationAlignment(
    IconRotationAlignment iconRotationAlignment,
  ) => impl.setIconRotationAlignment(iconRotationAlignment);

  /// In combination with `symbol-placement`, determines the rotation behavior of icons. Default value: "auto".
  Future<IconRotationAlignment?> getIconRotationAlignment() =>
      impl.getIconRotationAlignment();

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image. Default value: 1. Minimum value: 0. The unit of iconSize is in factor of the original icon size.
  Future<void> setIconSize(double iconSize) => impl.setIconSize(iconSize);

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image. Default value: 1. Minimum value: 0. The unit of iconSize is in factor of the original icon size.
  Future<double?> getIconSize() => impl.getIconSize();

  /// Limits the possible scaling range for `icon-size`, `icon-halo-width`, `icon-halo-blur` properties to be within [min-scale, max-scale] Default value: [0.8,2]. Minimum value: [0.1,0.1]. Maximum value: [10,10].
  @experimental
  Future<void> setIconSizeScaleRange(List<double?> iconSizeScaleRange) =>
      impl.setIconSizeScaleRange(iconSizeScaleRange);

  /// Limits the possible scaling range for `icon-size`, `icon-halo-width`, `icon-halo-blur` properties to be within [min-scale, max-scale] Default value: [0.8,2]. Minimum value: [0.1,0.1]. Maximum value: [10,10].
  @experimental
  Future<List<double?>?> getIconSizeScaleRange() =>
      impl.getIconSizeScaleRange();

  /// Scales the icon to fit around the associated text. Default value: "none".
  Future<void> setIconTextFit(IconTextFit iconTextFit) =>
      impl.setIconTextFit(iconTextFit);

  /// Scales the icon to fit around the associated text. Default value: "none".
  Future<IconTextFit?> getIconTextFit() => impl.getIconTextFit();

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left. Default value: [0,0,0,0]. The unit of iconTextFitPadding is in pixels.
  Future<void> setIconTextFitPadding(List<double?> iconTextFitPadding) =>
      impl.setIconTextFitPadding(iconTextFitPadding);

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left. Default value: [0,0,0,0]. The unit of iconTextFitPadding is in pixels.
  Future<List<double?>?> getIconTextFitPadding() =>
      impl.getIconTextFitPadding();

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries. Default value: false.
  Future<void> setSymbolAvoidEdges(bool symbolAvoidEdges) =>
      impl.setSymbolAvoidEdges(symbolAvoidEdges);

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries. Default value: false.
  Future<bool?> getSymbolAvoidEdges() => impl.getSymbolAvoidEdges();

  /// Selects the base of symbol-elevation. Default value: "ground".
  @experimental
  Future<void> setSymbolElevationReference(
    SymbolElevationReference symbolElevationReference,
  ) => impl.setSymbolElevationReference(symbolElevationReference);

  /// Selects the base of symbol-elevation. Default value: "ground".
  @experimental
  Future<SymbolElevationReference?> getSymbolElevationReference() =>
      impl.getSymbolElevationReference();

  /// Label placement relative to its geometry. Default value: "point".
  Future<void> setSymbolPlacement(SymbolPlacement symbolPlacement) =>
      impl.setSymbolPlacement(symbolPlacement);

  /// Label placement relative to its geometry. Default value: "point".
  Future<SymbolPlacement?> getSymbolPlacement() => impl.getSymbolPlacement();

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first. When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  Future<void> setSymbolSortKey(double symbolSortKey) =>
      impl.setSymbolSortKey(symbolSortKey);

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first. When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  Future<double?> getSymbolSortKey() => impl.getSymbolSortKey();

  /// Distance between two symbol anchors. Default value: 250. Minimum value: 1. The unit of symbolSpacing is in pixels.
  Future<void> setSymbolSpacing(double symbolSpacing) =>
      impl.setSymbolSpacing(symbolSpacing);

  /// Distance between two symbol anchors. Default value: 250. Minimum value: 1. The unit of symbolSpacing is in pixels.
  Future<double?> getSymbolSpacing() => impl.getSymbolSpacing();

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied. Default value: false.
  Future<void> setSymbolZElevate(bool symbolZElevate) =>
      impl.setSymbolZElevate(symbolZElevate);

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied. Default value: false.
  Future<bool?> getSymbolZElevate() => impl.getSymbolZElevate();

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`. Default value: "auto".
  Future<void> setSymbolZOrder(SymbolZOrder symbolZOrder) =>
      impl.setSymbolZOrder(symbolZOrder);

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`. Default value: "auto".
  Future<SymbolZOrder?> getSymbolZOrder() => impl.getSymbolZOrder();

  /// If true, the text will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<void> setTextAllowOverlap(bool textAllowOverlap) =>
      impl.setTextAllowOverlap(textAllowOverlap);

  /// If true, the text will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<bool?> getTextAllowOverlap() => impl.getTextAllowOverlap();

  /// Part of the text placed closest to the anchor. Default value: "center".
  Future<void> setTextAnchor(TextAnchor textAnchor) =>
      impl.setTextAnchor(textAnchor);

  /// Part of the text placed closest to the anchor. Default value: "center".
  Future<TextAnchor?> getTextAnchor() => impl.getTextAnchor();

  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options. SDF images are not supported in formatted text and will be ignored. Default value: "".
  Future<void> setTextField(String textField) => impl.setTextField(textField);

  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options. SDF images are not supported in formatted text and will be ignored. Default value: "".
  Future<String?> getTextField() => impl.getTextField();

  /// Font stack to use for displaying text.
  Future<void> setTextFont(List<String?> textFont) =>
      impl.setTextFont(textFont);

  /// Font stack to use for displaying text.
  Future<List<String?>?> getTextFont() => impl.getTextFont();

  /// If true, other symbols can be visible even if they collide with the text. Default value: false.
  Future<void> setTextIgnorePlacement(bool textIgnorePlacement) =>
      impl.setTextIgnorePlacement(textIgnorePlacement);

  /// If true, other symbols can be visible even if they collide with the text. Default value: false.
  Future<bool?> getTextIgnorePlacement() => impl.getTextIgnorePlacement();

  /// Text justification options. Default value: "center".
  Future<void> setTextJustify(TextJustify textJustify) =>
      impl.setTextJustify(textJustify);

  /// Text justification options. Default value: "center".
  Future<TextJustify?> getTextJustify() => impl.getTextJustify();

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down. Default value: true.
  Future<void> setTextKeepUpright(bool textKeepUpright) =>
      impl.setTextKeepUpright(textKeepUpright);

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down. Default value: true.
  Future<bool?> getTextKeepUpright() => impl.getTextKeepUpright();

  /// Text tracking amount. Default value: 0. The unit of textLetterSpacing is in ems.
  Future<void> setTextLetterSpacing(double textLetterSpacing) =>
      impl.setTextLetterSpacing(textLetterSpacing);

  /// Text tracking amount. Default value: 0. The unit of textLetterSpacing is in ems.
  Future<double?> getTextLetterSpacing() => impl.getTextLetterSpacing();

  /// Text leading value for multi-line text. Default value: 1.2. The unit of textLineHeight is in ems.
  Future<void> setTextLineHeight(double textLineHeight) =>
      impl.setTextLineHeight(textLineHeight);

  /// Text leading value for multi-line text. Default value: 1.2. The unit of textLineHeight is in ems.
  Future<double?> getTextLineHeight() => impl.getTextLineHeight();

  /// Maximum angle change between adjacent characters. Default value: 45. The unit of textMaxAngle is in degrees.
  Future<void> setTextMaxAngle(double textMaxAngle) =>
      impl.setTextMaxAngle(textMaxAngle);

  /// Maximum angle change between adjacent characters. Default value: 45. The unit of textMaxAngle is in degrees.
  Future<double?> getTextMaxAngle() => impl.getTextMaxAngle();

  /// The maximum line width for text wrapping. Default value: 10. Minimum value: 0. The unit of textMaxWidth is in ems.
  Future<void> setTextMaxWidth(double textMaxWidth) =>
      impl.setTextMaxWidth(textMaxWidth);

  /// The maximum line width for text wrapping. Default value: 10. Minimum value: 0. The unit of textMaxWidth is in ems.
  Future<double?> getTextMaxWidth() => impl.getTextMaxWidth();

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position. Default value: [0,0]. The unit of textOffset is in ems.
  Future<void> setTextOffset(List<double?> textOffset) =>
      impl.setTextOffset(textOffset);

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position. Default value: [0,0]. The unit of textOffset is in ems.
  Future<List<double?>?> getTextOffset() => impl.getTextOffset();

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not. Default value: false.
  Future<void> setTextOptional(bool textOptional) =>
      impl.setTextOptional(textOptional);

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not. Default value: false.
  Future<bool?> getTextOptional() => impl.getTextOptional();

  /// Size of the additional area around the text bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0. The unit of textPadding is in pixels.
  Future<void> setTextPadding(double textPadding) =>
      impl.setTextPadding(textPadding);

  /// Size of the additional area around the text bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0. The unit of textPadding is in pixels.
  Future<double?> getTextPadding() => impl.getTextPadding();

  /// Orientation of text when map is pitched. Default value: "auto".
  Future<void> setTextPitchAlignment(TextPitchAlignment textPitchAlignment) =>
      impl.setTextPitchAlignment(textPitchAlignment);

  /// Orientation of text when map is pitched. Default value: "auto".
  Future<TextPitchAlignment?> getTextPitchAlignment() =>
      impl.getTextPitchAlignment();

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present. Default value: 0. The unit of textRadialOffset is in ems.
  Future<void> setTextRadialOffset(double textRadialOffset) =>
      impl.setTextRadialOffset(textRadialOffset);

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present. Default value: 0. The unit of textRadialOffset is in ems.
  Future<double?> getTextRadialOffset() => impl.getTextRadialOffset();

  /// Rotates the text clockwise. Default value: 0. The unit of textRotate is in degrees.
  Future<void> setTextRotate(double textRotate) =>
      impl.setTextRotate(textRotate);

  /// Rotates the text clockwise. Default value: 0. The unit of textRotate is in degrees.
  Future<double?> getTextRotate() => impl.getTextRotate();

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text. Default value: "auto".
  Future<void> setTextRotationAlignment(
    TextRotationAlignment textRotationAlignment,
  ) => impl.setTextRotationAlignment(textRotationAlignment);

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text. Default value: "auto".
  Future<TextRotationAlignment?> getTextRotationAlignment() =>
      impl.getTextRotationAlignment();

  /// Font size. Default value: 16. Minimum value: 0. The unit of textSize is in pixels.
  Future<void> setTextSize(double textSize) => impl.setTextSize(textSize);

  /// Font size. Default value: 16. Minimum value: 0. The unit of textSize is in pixels.
  Future<double?> getTextSize() => impl.getTextSize();

  /// Limits the possible scaling range for `text-size`, `text-halo-width`, `text-halo-blur` properties to be within [min-scale, max-scale] Default value: [0.8,2]. Minimum value: [0.1,0.1]. Maximum value: [10,10].
  @experimental
  Future<void> setTextSizeScaleRange(List<double?> textSizeScaleRange) =>
      impl.setTextSizeScaleRange(textSizeScaleRange);

  /// Limits the possible scaling range for `text-size`, `text-halo-width`, `text-halo-blur` properties to be within [min-scale, max-scale] Default value: [0.8,2]. Minimum value: [0.1,0.1]. Maximum value: [10,10].
  @experimental
  Future<List<double?>?> getTextSizeScaleRange() =>
      impl.getTextSizeScaleRange();

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property. Default value: "none".
  Future<void> setTextTransform(TextTransform textTransform) =>
      impl.setTextTransform(textTransform);

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property. Default value: "none".
  Future<TextTransform?> getTextTransform() => impl.getTextTransform();

  /// The color of the icon. This can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "#000000".
  Future<void> setIconColor(int iconColor) => impl.setIconColor(iconColor);

  /// The color of the icon. This can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "#000000".
  Future<int?> getIconColor() => impl.getIconColor();

  /// Increase or reduce the brightness of the symbols. The value is the maximum brightness. Default value: 1. Value range: [0, 1]
  Future<void> setIconColorBrightnessMax(double iconColorBrightnessMax) =>
      impl.setIconColorBrightnessMax(iconColorBrightnessMax);

  /// Increase or reduce the brightness of the symbols. The value is the maximum brightness. Default value: 1. Value range: [0, 1]
  Future<double?> getIconColorBrightnessMax() =>
      impl.getIconColorBrightnessMax();

  /// Increase or reduce the brightness of the symbols. The value is the minimum brightness. Default value: 0. Value range: [0, 1]
  Future<void> setIconColorBrightnessMin(double iconColorBrightnessMin) =>
      impl.setIconColorBrightnessMin(iconColorBrightnessMin);

  /// Increase or reduce the brightness of the symbols. The value is the minimum brightness. Default value: 0. Value range: [0, 1]
  Future<double?> getIconColorBrightnessMin() =>
      impl.getIconColorBrightnessMin();

  /// Increase or reduce the contrast of the symbol icon. Default value: 0. Value range: [-1, 1]
  Future<void> setIconColorContrast(double iconColorContrast) =>
      impl.setIconColorContrast(iconColorContrast);

  /// Increase or reduce the contrast of the symbol icon. Default value: 0. Value range: [-1, 1]
  Future<double?> getIconColorContrast() => impl.getIconColorContrast();

  /// Increase or reduce the saturation of the symbol icon. Default value: 0. Value range: [-1, 1]
  Future<void> setIconColorSaturation(double iconColorSaturation) =>
      impl.setIconColorSaturation(iconColorSaturation);

  /// Increase or reduce the saturation of the symbol icon. Default value: 0. Value range: [-1, 1]
  Future<double?> getIconColorSaturation() => impl.getIconColorSaturation();

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0. The unit of iconEmissiveStrength is in intensity.
  Future<void> setIconEmissiveStrength(double iconEmissiveStrength) =>
      impl.setIconEmissiveStrength(iconEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0. The unit of iconEmissiveStrength is in intensity.
  Future<double?> getIconEmissiveStrength() => impl.getIconEmissiveStrength();

  /// Fade out the halo towards the outside. Default value: 0. Minimum value: 0. The unit of iconHaloBlur is in pixels.
  Future<void> setIconHaloBlur(double iconHaloBlur) =>
      impl.setIconHaloBlur(iconHaloBlur);

  /// Fade out the halo towards the outside. Default value: 0. Minimum value: 0. The unit of iconHaloBlur is in pixels.
  Future<double?> getIconHaloBlur() => impl.getIconHaloBlur();

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "rgba(0, 0, 0, 0)".
  Future<void> setIconHaloColor(int iconHaloColor) =>
      impl.setIconHaloColor(iconHaloColor);

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "rgba(0, 0, 0, 0)".
  Future<int?> getIconHaloColor() => impl.getIconHaloColor();

  /// Distance of halo to the icon outline. Default value: 0. Minimum value: 0. The unit of iconHaloWidth is in pixels.
  Future<void> setIconHaloWidth(double iconHaloWidth) =>
      impl.setIconHaloWidth(iconHaloWidth);

  /// Distance of halo to the icon outline. Default value: 0. Minimum value: 0. The unit of iconHaloWidth is in pixels.
  Future<double?> getIconHaloWidth() => impl.getIconHaloWidth();

  /// Controls the transition progress between the image variants of icon-image. Zero means the first variant is used, one is the second, and in between they are blended together. . Both images should be the same size and have the same type (either raster or vector). Default value: 0. Value range: [0, 1]
  Future<void> setIconImageCrossFade(double iconImageCrossFade) =>
      impl.setIconImageCrossFade(iconImageCrossFade);

  /// Controls the transition progress between the image variants of icon-image. Zero means the first variant is used, one is the second, and in between they are blended together. . Both images should be the same size and have the same type (either raster or vector). Default value: 0. Value range: [0, 1]
  Future<double?> getIconImageCrossFade() => impl.getIconImageCrossFade();

  /// The opacity at which the icon will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<void> setIconOcclusionOpacity(double iconOcclusionOpacity) =>
      impl.setIconOcclusionOpacity(iconOcclusionOpacity);

  /// The opacity at which the icon will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<double?> getIconOcclusionOpacity() => impl.getIconOcclusionOpacity();

  /// The opacity at which the icon will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setIconOpacity(double iconOpacity) =>
      impl.setIconOpacity(iconOpacity);

  /// The opacity at which the icon will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getIconOpacity() => impl.getIconOpacity();

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0]. The unit of iconTranslate is in pixels.
  Future<void> setIconTranslate(List<double?> iconTranslate) =>
      impl.setIconTranslate(iconTranslate);

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0]. The unit of iconTranslate is in pixels.
  Future<List<double?>?> getIconTranslate() => impl.getIconTranslate();

  /// Controls the frame of reference for `icon-translate`. Default value: "map".
  Future<void> setIconTranslateAnchor(
    IconTranslateAnchor iconTranslateAnchor,
  ) => impl.setIconTranslateAnchor(iconTranslateAnchor);

  /// Controls the frame of reference for `icon-translate`. Default value: "map".
  Future<IconTranslateAnchor?> getIconTranslateAnchor() =>
      impl.getIconTranslateAnchor();

  /// Specify how opacity in case of being occluded should be applied Default value: "anchor".
  Future<void> setOcclusionOpacityMode(
    OcclusionOpacityMode occlusionOpacityMode,
  ) => impl.setOcclusionOpacityMode(occlusionOpacityMode);

  /// Specify how opacity in case of being occluded should be applied Default value: "anchor".
  Future<OcclusionOpacityMode?> getOcclusionOpacityMode() =>
      impl.getOcclusionOpacityMode();

  /// Specifies an uniform elevation from the ground, in meters. Default value: 0. Minimum value: 0.
  @experimental
  Future<void> setSymbolZOffset(double symbolZOffset) =>
      impl.setSymbolZOffset(symbolZOffset);

  /// Specifies an uniform elevation from the ground, in meters. Default value: 0. Minimum value: 0.
  @experimental
  Future<double?> getSymbolZOffset() => impl.getSymbolZOffset();

  /// The color with which the text will be drawn. Default value: "#000000".
  Future<void> setTextColor(int textColor) => impl.setTextColor(textColor);

  /// The color with which the text will be drawn. Default value: "#000000".
  Future<int?> getTextColor() => impl.getTextColor();

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0. The unit of textEmissiveStrength is in intensity.
  Future<void> setTextEmissiveStrength(double textEmissiveStrength) =>
      impl.setTextEmissiveStrength(textEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0. The unit of textEmissiveStrength is in intensity.
  Future<double?> getTextEmissiveStrength() => impl.getTextEmissiveStrength();

  /// The halo's fadeout distance towards the outside. Default value: 0. Minimum value: 0. The unit of textHaloBlur is in pixels.
  Future<void> setTextHaloBlur(double textHaloBlur) =>
      impl.setTextHaloBlur(textHaloBlur);

  /// The halo's fadeout distance towards the outside. Default value: 0. Minimum value: 0. The unit of textHaloBlur is in pixels.
  Future<double?> getTextHaloBlur() => impl.getTextHaloBlur();

  /// The color of the text's halo, which helps it stand out from backgrounds. Default value: "rgba(0, 0, 0, 0)".
  Future<void> setTextHaloColor(int textHaloColor) =>
      impl.setTextHaloColor(textHaloColor);

  /// The color of the text's halo, which helps it stand out from backgrounds. Default value: "rgba(0, 0, 0, 0)".
  Future<int?> getTextHaloColor() => impl.getTextHaloColor();

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size. Default value: 0. Minimum value: 0. The unit of textHaloWidth is in pixels.
  Future<void> setTextHaloWidth(double textHaloWidth) =>
      impl.setTextHaloWidth(textHaloWidth);

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size. Default value: 0. Minimum value: 0. The unit of textHaloWidth is in pixels.
  Future<double?> getTextHaloWidth() => impl.getTextHaloWidth();

  /// The opacity at which the text will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<void> setTextOcclusionOpacity(double textOcclusionOpacity) =>
      impl.setTextOcclusionOpacity(textOcclusionOpacity);

  /// The opacity at which the text will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<double?> getTextOcclusionOpacity() => impl.getTextOcclusionOpacity();

  /// The opacity at which the text will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setTextOpacity(double textOpacity) =>
      impl.setTextOpacity(textOpacity);

  /// The opacity at which the text will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getTextOpacity() => impl.getTextOpacity();

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0]. The unit of textTranslate is in pixels.
  Future<void> setTextTranslate(List<double?> textTranslate) =>
      impl.setTextTranslate(textTranslate);

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0]. The unit of textTranslate is in pixels.
  Future<List<double?>?> getTextTranslate() => impl.getTextTranslate();

  /// Controls the frame of reference for `text-translate`. Default value: "map".
  Future<void> setTextTranslateAnchor(
    TextTranslateAnchor textTranslateAnchor,
  ) => impl.setTextTranslateAnchor(textTranslateAnchor);

  /// Controls the frame of reference for `text-translate`. Default value: "map".
  Future<TextTranslateAnchor?> getTextTranslateAnchor() =>
      impl.getTextTranslateAnchor();
}

// End of generated file.
