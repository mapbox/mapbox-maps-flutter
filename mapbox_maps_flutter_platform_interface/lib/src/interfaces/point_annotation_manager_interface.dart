// This file is generated.
import 'package:meta/meta.dart';

import '../pigeons/annotation_data_types.dart';
import '../pigeons/platform_interface_data_types.dart';
import 'annotations_interface.dart';

/// Abstract interface for managing point annotations.
abstract interface class PointAnnotationManagerPlatformInterface
    implements BaseAnnotationManagerPlatformInterface {
  /// Broadcast stream of raw tap interaction contexts. The facade's
  /// `tapEvents` subscribes to this stream, projects the payload to
  /// the annotation type, and wraps the subscription in a `Cancelable`.
  Stream<PointAnnotationInteractionContext> get tapInteractionStream;

  /// Broadcast stream of raw long-press interaction contexts.
  Stream<PointAnnotationInteractionContext> get longPressInteractionStream;

  /// Broadcast stream of raw drag interaction contexts. The facade's
  /// `dragEvents` filters by `gestureState` to dispatch begin/changed/end.
  Stream<PointAnnotationInteractionContext> get dragInteractionStream;

  /// Get all annotations of manager.
  Future<List<PointAnnotation>> getAnnotations();

  /// Create a new annotation with the option.
  Future<PointAnnotation> create(PointAnnotationOptions annotation);

  /// Create multi annotations with the options.
  Future<List<PointAnnotation?>> createMulti(
    List<PointAnnotationOptions> annotations,
  );

  /// Update an added annotation with new properties.
  Future<void> update(PointAnnotation annotation);

  /// Delete an added annotation.
  Future<void> delete(PointAnnotation annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll();

  /// Delete multiple annotations added by this manager.
  Future<void> deleteMulti(List<PointAnnotation> annotations);

  /// If true, the icon will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<void> setIconAllowOverlap(bool iconAllowOverlap);

  /// If true, the icon will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<bool?> getIconAllowOverlap();

  /// Part of the icon placed closest to the anchor. Default value: "center".
  Future<void> setIconAnchor(IconAnchor iconAnchor);

  /// Part of the icon placed closest to the anchor. Default value: "center".
  Future<IconAnchor?> getIconAnchor();

  /// If true, other symbols can be visible even if they collide with the icon. Default value: false.
  Future<void> setIconIgnorePlacement(bool iconIgnorePlacement);

  /// If true, other symbols can be visible even if they collide with the icon. Default value: false.
  Future<bool?> getIconIgnorePlacement();

  /// Name of image in sprite to use for drawing an image background.
  Future<void> setIconImage(String iconImage);

  /// Name of image in sprite to use for drawing an image background.
  Future<String?> getIconImage();

  /// If true, the icon may be flipped to prevent it from being rendered upside-down. Default value: false.
  Future<void> setIconKeepUpright(bool iconKeepUpright);

  /// If true, the icon may be flipped to prevent it from being rendered upside-down. Default value: false.
  Future<bool?> getIconKeepUpright();

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up. Default value: [0,0].
  Future<void> setIconOffset(List<double?> iconOffset);

  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up. Default value: [0,0].
  Future<List<double?>?> getIconOffset();

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not. Default value: false.
  Future<void> setIconOptional(bool iconOptional);

  /// If true, text will display without their corresponding icons when the icon collides with other symbols and the text does not. Default value: false.
  Future<bool?> getIconOptional();

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0. The unit of iconPadding is in pixels.
  Future<void> setIconPadding(double iconPadding);

  /// Size of the additional area around the icon bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0. The unit of iconPadding is in pixels.
  Future<double?> getIconPadding();

  /// Orientation of icon when map is pitched. Default value: "auto".
  Future<void> setIconPitchAlignment(IconPitchAlignment iconPitchAlignment);

  /// Orientation of icon when map is pitched. Default value: "auto".
  Future<IconPitchAlignment?> getIconPitchAlignment();

  /// Rotates the icon clockwise. Default value: 0. The unit of iconRotate is in degrees.
  Future<void> setIconRotate(double iconRotate);

  /// Rotates the icon clockwise. Default value: 0. The unit of iconRotate is in degrees.
  Future<double?> getIconRotate();

  /// In combination with `symbol-placement`, determines the rotation behavior of icons. Default value: "auto".
  Future<void> setIconRotationAlignment(
    IconRotationAlignment iconRotationAlignment,
  );

  /// In combination with `symbol-placement`, determines the rotation behavior of icons. Default value: "auto".
  Future<IconRotationAlignment?> getIconRotationAlignment();

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image. Default value: 1. Minimum value: 0. The unit of iconSize is in factor of the original icon size.
  Future<void> setIconSize(double iconSize);

  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image. Default value: 1. Minimum value: 0. The unit of iconSize is in factor of the original icon size.
  Future<double?> getIconSize();

  /// Limits the possible scaling range for `icon-size`, `icon-halo-width`, `icon-halo-blur` properties to be within [min-scale, max-scale] Default value: [0.8,2]. Minimum value: [0.1,0.1]. Maximum value: [10,10].
  @experimental
  Future<void> setIconSizeScaleRange(List<double?> iconSizeScaleRange);

  /// Limits the possible scaling range for `icon-size`, `icon-halo-width`, `icon-halo-blur` properties to be within [min-scale, max-scale] Default value: [0.8,2]. Minimum value: [0.1,0.1]. Maximum value: [10,10].
  @experimental
  Future<List<double?>?> getIconSizeScaleRange();

  /// Scales the icon to fit around the associated text. Default value: "none".
  Future<void> setIconTextFit(IconTextFit iconTextFit);

  /// Scales the icon to fit around the associated text. Default value: "none".
  Future<IconTextFit?> getIconTextFit();

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left. Default value: [0,0,0,0]. The unit of iconTextFitPadding is in pixels.
  Future<void> setIconTextFitPadding(List<double?> iconTextFitPadding);

  /// Size of the additional area added to dimensions determined by `icon-text-fit`, in clockwise order: top, right, bottom, left. Default value: [0,0,0,0]. The unit of iconTextFitPadding is in pixels.
  Future<List<double?>?> getIconTextFitPadding();

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries. Default value: false.
  Future<void> setSymbolAvoidEdges(bool symbolAvoidEdges);

  /// If true, the symbols will not cross tile edges to avoid mutual collisions. Recommended in layers that don't have enough padding in the vector tile to prevent collisions, or if it is a point symbol layer placed after a line symbol layer. When using a client that supports global collision detection, like Mapbox GL JS version 0.42.0 or greater, enabling this property is not needed to prevent clipped labels at tile boundaries. Default value: false.
  Future<bool?> getSymbolAvoidEdges();

  /// Selects the base of symbol-elevation. Default value: "ground".
  @experimental
  Future<void> setSymbolElevationReference(
    SymbolElevationReference symbolElevationReference,
  );

  /// Selects the base of symbol-elevation. Default value: "ground".
  @experimental
  Future<SymbolElevationReference?> getSymbolElevationReference();

  /// Label placement relative to its geometry. Default value: "point".
  Future<void> setSymbolPlacement(SymbolPlacement symbolPlacement);

  /// Label placement relative to its geometry. Default value: "point".
  Future<SymbolPlacement?> getSymbolPlacement();

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first. When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  Future<void> setSymbolSortKey(double symbolSortKey);

  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first. When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  Future<double?> getSymbolSortKey();

  /// Distance between two symbol anchors. Default value: 250. Minimum value: 1. The unit of symbolSpacing is in pixels.
  Future<void> setSymbolSpacing(double symbolSpacing);

  /// Distance between two symbol anchors. Default value: 250. Minimum value: 1. The unit of symbolSpacing is in pixels.
  Future<double?> getSymbolSpacing();

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied. Default value: false.
  Future<void> setSymbolZElevate(bool symbolZElevate);

  /// Position symbol on buildings (both fill extrusions and models) rooftops. In order to have minimal impact on performance, this is supported only when `fill-extrusion-height` is not zoom-dependent and remains unchanged. For fading in buildings when zooming in, fill-extrusion-vertical-scale should be used and symbols would raise with building rooftops. Symbols are sorted by elevation, except in cases when `viewport-y` sorting or `symbol-sort-key` are applied. Default value: false.
  Future<bool?> getSymbolZElevate();

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`. Default value: "auto".
  Future<void> setSymbolZOrder(SymbolZOrder symbolZOrder);

  /// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`. Default value: "auto".
  Future<SymbolZOrder?> getSymbolZOrder();

  /// If true, the text will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<void> setTextAllowOverlap(bool textAllowOverlap);

  /// If true, the text will be visible even if it collides with other previously drawn symbols. Default value: false.
  Future<bool?> getTextAllowOverlap();

  /// Part of the text placed closest to the anchor. Default value: "center".
  Future<void> setTextAnchor(TextAnchor textAnchor);

  /// Part of the text placed closest to the anchor. Default value: "center".
  Future<TextAnchor?> getTextAnchor();

  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options. SDF images are not supported in formatted text and will be ignored. Default value: "".
  Future<void> setTextField(String textField);

  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options. SDF images are not supported in formatted text and will be ignored. Default value: "".
  Future<String?> getTextField();

  /// Font stack to use for displaying text.
  Future<void> setTextFont(List<String?> textFont);

  /// Font stack to use for displaying text.
  Future<List<String?>?> getTextFont();

  /// If true, other symbols can be visible even if they collide with the text. Default value: false.
  Future<void> setTextIgnorePlacement(bool textIgnorePlacement);

  /// If true, other symbols can be visible even if they collide with the text. Default value: false.
  Future<bool?> getTextIgnorePlacement();

  /// Text justification options. Default value: "center".
  Future<void> setTextJustify(TextJustify textJustify);

  /// Text justification options. Default value: "center".
  Future<TextJustify?> getTextJustify();

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down. Default value: true.
  Future<void> setTextKeepUpright(bool textKeepUpright);

  /// If true, the text may be flipped vertically to prevent it from being rendered upside-down. Default value: true.
  Future<bool?> getTextKeepUpright();

  /// Text tracking amount. Default value: 0. The unit of textLetterSpacing is in ems.
  Future<void> setTextLetterSpacing(double textLetterSpacing);

  /// Text tracking amount. Default value: 0. The unit of textLetterSpacing is in ems.
  Future<double?> getTextLetterSpacing();

  /// Text leading value for multi-line text. Default value: 1.2. The unit of textLineHeight is in ems.
  Future<void> setTextLineHeight(double textLineHeight);

  /// Text leading value for multi-line text. Default value: 1.2. The unit of textLineHeight is in ems.
  Future<double?> getTextLineHeight();

  /// Maximum angle change between adjacent characters. Default value: 45. The unit of textMaxAngle is in degrees.
  Future<void> setTextMaxAngle(double textMaxAngle);

  /// Maximum angle change between adjacent characters. Default value: 45. The unit of textMaxAngle is in degrees.
  Future<double?> getTextMaxAngle();

  /// The maximum line width for text wrapping. Default value: 10. Minimum value: 0. The unit of textMaxWidth is in ems.
  Future<void> setTextMaxWidth(double textMaxWidth);

  /// The maximum line width for text wrapping. Default value: 10. Minimum value: 0. The unit of textMaxWidth is in ems.
  Future<double?> getTextMaxWidth();

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position. Default value: [0,0]. The unit of textOffset is in ems.
  Future<void> setTextOffset(List<double?> textOffset);

  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position. Default value: [0,0]. The unit of textOffset is in ems.
  Future<List<double?>?> getTextOffset();

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not. Default value: false.
  Future<void> setTextOptional(bool textOptional);

  /// If true, icons will display without their corresponding text when the text collides with other symbols and the icon does not. Default value: false.
  Future<bool?> getTextOptional();

  /// Size of the additional area around the text bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0. The unit of textPadding is in pixels.
  Future<void> setTextPadding(double textPadding);

  /// Size of the additional area around the text bounding box used for detecting symbol collisions. Default value: 2. Minimum value: 0. The unit of textPadding is in pixels.
  Future<double?> getTextPadding();

  /// Orientation of text when map is pitched. Default value: "auto".
  Future<void> setTextPitchAlignment(TextPitchAlignment textPitchAlignment);

  /// Orientation of text when map is pitched. Default value: "auto".
  Future<TextPitchAlignment?> getTextPitchAlignment();

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present. Default value: 0. The unit of textRadialOffset is in ems.
  Future<void> setTextRadialOffset(double textRadialOffset);

  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present. Default value: 0. The unit of textRadialOffset is in ems.
  Future<double?> getTextRadialOffset();

  /// Rotates the text clockwise. Default value: 0. The unit of textRotate is in degrees.
  Future<void> setTextRotate(double textRotate);

  /// Rotates the text clockwise. Default value: 0. The unit of textRotate is in degrees.
  Future<double?> getTextRotate();

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text. Default value: "auto".
  Future<void> setTextRotationAlignment(
    TextRotationAlignment textRotationAlignment,
  );

  /// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text. Default value: "auto".
  Future<TextRotationAlignment?> getTextRotationAlignment();

  /// Font size. Default value: 16. Minimum value: 0. The unit of textSize is in pixels.
  Future<void> setTextSize(double textSize);

  /// Font size. Default value: 16. Minimum value: 0. The unit of textSize is in pixels.
  Future<double?> getTextSize();

  /// Limits the possible scaling range for `text-size`, `text-halo-width`, `text-halo-blur` properties to be within [min-scale, max-scale] Default value: [0.8,2]. Minimum value: [0.1,0.1]. Maximum value: [10,10].
  @experimental
  Future<void> setTextSizeScaleRange(List<double?> textSizeScaleRange);

  /// Limits the possible scaling range for `text-size`, `text-halo-width`, `text-halo-blur` properties to be within [min-scale, max-scale] Default value: [0.8,2]. Minimum value: [0.1,0.1]. Maximum value: [10,10].
  @experimental
  Future<List<double?>?> getTextSizeScaleRange();

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property. Default value: "none".
  Future<void> setTextTransform(TextTransform textTransform);

  /// Specifies how to capitalize text, similar to the CSS `text-transform` property. Default value: "none".
  Future<TextTransform?> getTextTransform();

  /// The color of the icon. This can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "#000000".
  Future<void> setIconColor(int iconColor);

  /// The color of the icon. This can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "#000000".
  Future<int?> getIconColor();

  /// Increase or reduce the brightness of the symbols. The value is the maximum brightness. Default value: 1. Value range: [0, 1]
  Future<void> setIconColorBrightnessMax(double iconColorBrightnessMax);

  /// Increase or reduce the brightness of the symbols. The value is the maximum brightness. Default value: 1. Value range: [0, 1]
  Future<double?> getIconColorBrightnessMax();

  /// Increase or reduce the brightness of the symbols. The value is the minimum brightness. Default value: 0. Value range: [0, 1]
  Future<void> setIconColorBrightnessMin(double iconColorBrightnessMin);

  /// Increase or reduce the brightness of the symbols. The value is the minimum brightness. Default value: 0. Value range: [0, 1]
  Future<double?> getIconColorBrightnessMin();

  /// Increase or reduce the contrast of the symbol icon. Default value: 0. Value range: [-1, 1]
  Future<void> setIconColorContrast(double iconColorContrast);

  /// Increase or reduce the contrast of the symbol icon. Default value: 0. Value range: [-1, 1]
  Future<double?> getIconColorContrast();

  /// Increase or reduce the saturation of the symbol icon. Default value: 0. Value range: [-1, 1]
  Future<void> setIconColorSaturation(double iconColorSaturation);

  /// Increase or reduce the saturation of the symbol icon. Default value: 0. Value range: [-1, 1]
  Future<double?> getIconColorSaturation();

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0. The unit of iconEmissiveStrength is in intensity.
  Future<void> setIconEmissiveStrength(double iconEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0. The unit of iconEmissiveStrength is in intensity.
  Future<double?> getIconEmissiveStrength();

  /// Fade out the halo towards the outside. Default value: 0. Minimum value: 0. The unit of iconHaloBlur is in pixels.
  Future<void> setIconHaloBlur(double iconHaloBlur);

  /// Fade out the halo towards the outside. Default value: 0. Minimum value: 0. The unit of iconHaloBlur is in pixels.
  Future<double?> getIconHaloBlur();

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "rgba(0, 0, 0, 0)".
  Future<void> setIconHaloColor(int iconHaloColor);

  /// The color of the icon's halo. Icon halos can only be used with [SDF icons](/help/troubleshooting/using-recolorable-images-in-mapbox-maps/). Default value: "rgba(0, 0, 0, 0)".
  Future<int?> getIconHaloColor();

  /// Distance of halo to the icon outline. Default value: 0. Minimum value: 0. The unit of iconHaloWidth is in pixels.
  Future<void> setIconHaloWidth(double iconHaloWidth);

  /// Distance of halo to the icon outline. Default value: 0. Minimum value: 0. The unit of iconHaloWidth is in pixels.
  Future<double?> getIconHaloWidth();

  /// Controls the transition progress between the image variants of icon-image. Zero means the first variant is used, one is the second, and in between they are blended together. . Both images should be the same size and have the same type (either raster or vector). Default value: 0. Value range: [0, 1]
  Future<void> setIconImageCrossFade(double iconImageCrossFade);

  /// Controls the transition progress between the image variants of icon-image. Zero means the first variant is used, one is the second, and in between they are blended together. . Both images should be the same size and have the same type (either raster or vector). Default value: 0. Value range: [0, 1]
  Future<double?> getIconImageCrossFade();

  /// The opacity at which the icon will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<void> setIconOcclusionOpacity(double iconOcclusionOpacity);

  /// The opacity at which the icon will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<double?> getIconOcclusionOpacity();

  /// The opacity at which the icon will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setIconOpacity(double iconOpacity);

  /// The opacity at which the icon will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getIconOpacity();

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0]. The unit of iconTranslate is in pixels.
  Future<void> setIconTranslate(List<double?> iconTranslate);

  /// Distance that the icon's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0]. The unit of iconTranslate is in pixels.
  Future<List<double?>?> getIconTranslate();

  /// Controls the frame of reference for `icon-translate`. Default value: "map".
  Future<void> setIconTranslateAnchor(IconTranslateAnchor iconTranslateAnchor);

  /// Controls the frame of reference for `icon-translate`. Default value: "map".
  Future<IconTranslateAnchor?> getIconTranslateAnchor();

  /// Specify how opacity in case of being occluded should be applied Default value: "anchor".
  Future<void> setOcclusionOpacityMode(
    OcclusionOpacityMode occlusionOpacityMode,
  );

  /// Specify how opacity in case of being occluded should be applied Default value: "anchor".
  Future<OcclusionOpacityMode?> getOcclusionOpacityMode();

  /// Specifies an uniform elevation from the ground, in meters. Default value: 0. Minimum value: 0.
  @experimental
  Future<void> setSymbolZOffset(double symbolZOffset);

  /// Specifies an uniform elevation from the ground, in meters. Default value: 0. Minimum value: 0.
  @experimental
  Future<double?> getSymbolZOffset();

  /// The color with which the text will be drawn. Default value: "#000000".
  Future<void> setTextColor(int textColor);

  /// The color with which the text will be drawn. Default value: "#000000".
  Future<int?> getTextColor();

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0. The unit of textEmissiveStrength is in intensity.
  Future<void> setTextEmissiveStrength(double textEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 1. Minimum value: 0. The unit of textEmissiveStrength is in intensity.
  Future<double?> getTextEmissiveStrength();

  /// The halo's fadeout distance towards the outside. Default value: 0. Minimum value: 0. The unit of textHaloBlur is in pixels.
  Future<void> setTextHaloBlur(double textHaloBlur);

  /// The halo's fadeout distance towards the outside. Default value: 0. Minimum value: 0. The unit of textHaloBlur is in pixels.
  Future<double?> getTextHaloBlur();

  /// The color of the text's halo, which helps it stand out from backgrounds. Default value: "rgba(0, 0, 0, 0)".
  Future<void> setTextHaloColor(int textHaloColor);

  /// The color of the text's halo, which helps it stand out from backgrounds. Default value: "rgba(0, 0, 0, 0)".
  Future<int?> getTextHaloColor();

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size. Default value: 0. Minimum value: 0. The unit of textHaloWidth is in pixels.
  Future<void> setTextHaloWidth(double textHaloWidth);

  /// Distance of halo to the font outline. Max text halo width is 1/4 of the font-size. Default value: 0. Minimum value: 0. The unit of textHaloWidth is in pixels.
  Future<double?> getTextHaloWidth();

  /// The opacity at which the text will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<void> setTextOcclusionOpacity(double textOcclusionOpacity);

  /// The opacity at which the text will be drawn in case of being depth occluded. Absent value means full occlusion against terrain only. Default value: 0. Value range: [0, 1]
  Future<double?> getTextOcclusionOpacity();

  /// The opacity at which the text will be drawn. Default value: 1. Value range: [0, 1]
  Future<void> setTextOpacity(double textOpacity);

  /// The opacity at which the text will be drawn. Default value: 1. Value range: [0, 1]
  Future<double?> getTextOpacity();

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0]. The unit of textTranslate is in pixels.
  Future<void> setTextTranslate(List<double?> textTranslate);

  /// Distance that the text's anchor is moved from its original placement. Positive values indicate right and down, while negative values indicate left and up. Default value: [0,0]. The unit of textTranslate is in pixels.
  Future<List<double?>?> getTextTranslate();

  /// Controls the frame of reference for `text-translate`. Default value: "map".
  Future<void> setTextTranslateAnchor(TextTranslateAnchor textTranslateAnchor);

  /// Controls the frame of reference for `text-translate`. Default value: "map".
  Future<TextTranslateAnchor?> getTextTranslateAnchor();
}

// End of generated file.
