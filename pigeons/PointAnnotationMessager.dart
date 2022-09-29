// This file is generated.
import 'package:pigeon/pigeon.dart';

/// Part of the icon placed closest to the anchor.
enum IconAnchor {
  /// The center of the icon is placed closest to the anchor.
  CENTER,
  /// The left side of the icon is placed closest to the anchor.
  LEFT,
  /// The right side of the icon is placed closest to the anchor.
  RIGHT,
  /// The top of the icon is placed closest to the anchor.
  TOP,
  /// The bottom of the icon is placed closest to the anchor.
  BOTTOM,
  /// The top left corner of the icon is placed closest to the anchor.
  TOP_LEFT,
  /// The top right corner of the icon is placed closest to the anchor.
  TOP_RIGHT,
  /// The bottom left corner of the icon is placed closest to the anchor.
  BOTTOM_LEFT,
  /// The bottom right corner of the icon is placed closest to the anchor.
  BOTTOM_RIGHT,
}

/// Orientation of icon when map is pitched.
enum IconPitchAlignment {
  /// The icon is aligned to the plane of the map.
  MAP,
  /// The icon is aligned to the plane of the viewport.
  VIEWPORT,
  /// Automatically matches the value of {@link ICON_ROTATION_ALIGNMENT}.
  AUTO,
}

/// In combination with `symbol-placement`, determines the rotation behavior of icons.
enum IconRotationAlignment {
  /// When {@link SYMBOL_PLACEMENT} is set to {@link Property#SYMBOL_PLACEMENT_POINT}, aligns icons east-west. When {@link SYMBOL_PLACEMENT} is set to {@link Property#SYMBOL_PLACEMENT_LINE} or {@link Property#SYMBOL_PLACEMENT_LINE_CENTER}, aligns icon x-axes with the line.
  MAP,
  /// Produces icons whose x-axes are aligned with the x-axis of the viewport, regardless of the value of {@link SYMBOL_PLACEMENT}.
  VIEWPORT,
  /// When {@link SYMBOL_PLACEMENT} is set to {@link Property#SYMBOL_PLACEMENT_POINT}, this is equivalent to {@link Property#ICON_ROTATION_ALIGNMENT_VIEWPORT}. When {@link SYMBOL_PLACEMENT} is set to {@link Property#SYMBOL_PLACEMENT_LINE} or {@link Property#SYMBOL_PLACEMENT_LINE_CENTER}, this is equivalent to {@link Property#ICON_ROTATION_ALIGNMENT_MAP}.
  AUTO,
}

/// Scales the icon to fit around the associated text.
enum IconTextFit {
  /// The icon is displayed at its intrinsic aspect ratio.
  NONE,
  /// The icon is scaled in the x-dimension to fit the width of the text.
  WIDTH,
  /// The icon is scaled in the y-dimension to fit the height of the text.
  HEIGHT,
  /// The icon is scaled in both x- and y-dimensions.
  BOTH,
}

/// Label placement relative to its geometry.
enum SymbolPlacement {
  /// The label is placed at the point where the geometry is located.
  POINT,
  /// The label is placed along the line of the geometry. Can only be used on LineString and Polygon geometries.
  LINE,
  /// The label is placed at the center of the line of the geometry. Can only be used on LineString and Polygon geometries. Note that a single feature in a vector tile may contain multiple line geometries.
  LINE_CENTER,
}

/// Determines whether overlapping symbols in the same layer are rendered in the order that they appear in the data source or by their y-position relative to the viewport. To control the order and prioritization of symbols otherwise, use `symbol-sort-key`.
enum SymbolZOrder {
  /// Sorts symbols by symbol sort key if set. Otherwise, sorts symbols by their y-position relative to the viewport if {@link ICON_ALLOW_OVERLAP} or {@link TEXT_ALLOW_OVERLAP} is set to {@link TRUE} or {@link ICON_IGNORE_PLACEMENT} or {@link TEXT_IGNORE_PLACEMENT} is {@link FALSE}.
  AUTO,
  /// Sorts symbols by their y-position relative to the viewport if {@link ICON_ALLOW_OVERLAP} or {@link TEXT_ALLOW_OVERLAP} is set to {@link TRUE} or {@link ICON_IGNORE_PLACEMENT} or {@link TEXT_IGNORE_PLACEMENT} is {@link FALSE}.
  VIEWPORT_Y,
  /// Sorts symbols by symbol sort key if set. Otherwise, no sorting is applied; symbols are rendered in the same order as the source data.
  SOURCE,
}

/// Part of the text placed closest to the anchor.
enum TextAnchor {
  /// The center of the text is placed closest to the anchor.
  CENTER,
  /// The left side of the text is placed closest to the anchor.
  LEFT,
  /// The right side of the text is placed closest to the anchor.
  RIGHT,
  /// The top of the text is placed closest to the anchor.
  TOP,
  /// The bottom of the text is placed closest to the anchor.
  BOTTOM,
  /// The top left corner of the text is placed closest to the anchor.
  TOP_LEFT,
  /// The top right corner of the text is placed closest to the anchor.
  TOP_RIGHT,
  /// The bottom left corner of the text is placed closest to the anchor.
  BOTTOM_LEFT,
  /// The bottom right corner of the text is placed closest to the anchor.
  BOTTOM_RIGHT,
}

/// Text justification options.
enum TextJustify {
  /// The text is aligned towards the anchor position.
  AUTO,
  /// The text is aligned to the left.
  LEFT,
  /// The text is centered.
  CENTER,
  /// The text is aligned to the right.
  RIGHT,
}

/// Orientation of text when map is pitched.
enum TextPitchAlignment {
  /// The text is aligned to the plane of the map.
  MAP,
  /// The text is aligned to the plane of the viewport.
  VIEWPORT,
  /// Automatically matches the value of {@link TEXT_ROTATION_ALIGNMENT}.
  AUTO,
}

/// In combination with `symbol-placement`, determines the rotation behavior of the individual glyphs forming the text.
enum TextRotationAlignment {
  /// When {@link SYMBOL_PLACEMENT} is set to {@link Property#SYMBOL_PLACEMENT_POINT}, aligns text east-west. When {@link SYMBOL_PLACEMENT} is set to {@link Property#SYMBOL_PLACEMENT_LINE} or {@link Property#SYMBOL_PLACEMENT_LINE_CENTER}, aligns text x-axes with the line.
  MAP,
  /// Produces glyphs whose x-axes are aligned with the x-axis of the viewport, regardless of the value of {@link SYMBOL_PLACEMENT}.
  VIEWPORT,
  /// When {@link SYMBOL_PLACEMENT} is set to {@link Property#SYMBOL_PLACEMENT_POINT}, this is equivalent to {@link Property#TEXT_ROTATION_ALIGNMENT_VIEWPORT}. When {@link SYMBOL_PLACEMENT} is set to {@link Property#SYMBOL_PLACEMENT_LINE} or {@link Property#SYMBOL_PLACEMENT_LINE_CENTER}, this is equivalent to {@link Property#TEXT_ROTATION_ALIGNMENT_MAP}.
  AUTO,
}

/// Specifies how to capitalize text, similar to the CSS `text-transform` property.
enum TextTransform {
  /// The text is not altered.
  NONE,
  /// Forces all letters to be displayed in uppercase.
  UPPERCASE,
  /// Forces all letters to be displayed in lowercase.
  LOWERCASE,
}

/// To increase the chance of placing high-priority labels on the map, you can provide an array of `text-anchor` locations: the renderer will attempt to place the label at each location, in order, before moving onto the next label. Use `text-justify: auto` to choose justification based on anchor position. To apply an offset, use the `text-radial-offset` or the two-dimensional `text-offset`.
enum TextVariableAnchor {
  /// The center of the text is placed closest to the anchor.
  CENTER,
  /// The left side of the text is placed closest to the anchor.
  LEFT,
  /// The right side of the text is placed closest to the anchor.
  RIGHT,
  /// The top of the text is placed closest to the anchor.
  TOP,
  /// The bottom of the text is placed closest to the anchor.
  BOTTOM,
  /// The top left corner of the text is placed closest to the anchor.
  TOP_LEFT,
  /// The top right corner of the text is placed closest to the anchor.
  TOP_RIGHT,
  /// The bottom left corner of the text is placed closest to the anchor.
  BOTTOM_LEFT,
  /// The bottom right corner of the text is placed closest to the anchor.
  BOTTOM_RIGHT,
}

/// The property allows control over a symbol's orientation. Note that the property values act as a hint, so that a symbol whose language doesn’t support the provided orientation will be laid out in its natural orientation. Example: English point symbol will be rendered horizontally even if array value contains single 'vertical' enum value. The order of elements in an array define priority order for the placement of an orientation variant.
enum TextWritingMode {
  /// If a text's language supports horizontal writing mode, symbols with point placement would be laid out horizontally.
  HORIZONTAL,
  /// If a text's language supports vertical writing mode, symbols with point placement would be laid out vertically.
  VERTICAL,
}

/// Controls the frame of reference for `icon-translate`.
enum IconTranslateAnchor {
  /// Icons are translated relative to the map.
  MAP,
  /// Icons are translated relative to the viewport.
  VIEWPORT,
}

/// Controls the frame of reference for `text-translate`.
enum TextTranslateAnchor {
  /// The text is translated relative to the map.
  MAP,
  /// The text is translated relative to the viewport.
  VIEWPORT,
}

@FlutterApi
abstract class OnPointAnnotationClickListener {
  void onPointAnnotationClick(PointAnnotation annotation);
}

@HostApi
abstract class _PointAnnotationMessager {
  @async
  PointAnnotation create(String managerId, PointAnnotationOptions annotationOption);
  @async
  List<PointAnnotation> createMulti(String managerId, List<PointAnnotationOptions> annotationOptions);
  @async
  void update(String managerId, PointAnnotation annotation);
  @async
  void delete(String managerId, PointAnnotation annotation);
  @async
  void deleteAll(String managerId);
  @async
  void setIconAllowOverlap(String managerId, bool iconAllowOverlap);
  @async
  bool? getIconAllowOverlap(String managerId);
  @async
  void setIconIgnorePlacement(String managerId, bool iconIgnorePlacement);
  @async
  bool? getIconIgnorePlacement(String managerId);
  @async
  void setIconKeepUpright(String managerId, bool iconKeepUpright);
  @async
  bool? getIconKeepUpright(String managerId);
  @async
  void setIconOptional(String managerId, bool iconOptional);
  @async
  bool? getIconOptional(String managerId);
  @async
  void setIconPadding(String managerId, double iconPadding);
  @async
  double? getIconPadding(String managerId);
  @async
  void setIconPitchAlignment(String managerId, IconPitchAlignment iconPitchAlignment);
  @async
  int? getIconPitchAlignment(String managerId);
  @async
  void setIconRotationAlignment(String managerId, IconRotationAlignment iconRotationAlignment);
  @async
  int? getIconRotationAlignment(String managerId);
  @async
  void setIconTextFit(String managerId, IconTextFit iconTextFit);
  @async
  int? getIconTextFit(String managerId);
  @async
  void setIconTextFitPadding(String managerId, List<double?> iconTextFitPadding);
  @async
  List<double?>? getIconTextFitPadding(String managerId);
  @async
  void setSymbolAvoidEdges(String managerId, bool symbolAvoidEdges);
  @async
  bool? getSymbolAvoidEdges(String managerId);
  @async
  void setSymbolPlacement(String managerId, SymbolPlacement symbolPlacement);
  @async
  int? getSymbolPlacement(String managerId);
  @async
  void setSymbolSpacing(String managerId, double symbolSpacing);
  @async
  double? getSymbolSpacing(String managerId);
  @async
  void setSymbolZOrder(String managerId, SymbolZOrder symbolZOrder);
  @async
  int? getSymbolZOrder(String managerId);
  @async
  void setTextAllowOverlap(String managerId, bool textAllowOverlap);
  @async
  bool? getTextAllowOverlap(String managerId);
  @async
  void setTextFont(String managerId, List<String?> textFont);
  @async
  List<String?>? getTextFont(String managerId);
  @async
  void setTextIgnorePlacement(String managerId, bool textIgnorePlacement);
  @async
  bool? getTextIgnorePlacement(String managerId);
  @async
  void setTextKeepUpright(String managerId, bool textKeepUpright);
  @async
  bool? getTextKeepUpright(String managerId);
  @async
  void setTextLineHeight(String managerId, double textLineHeight);
  @async
  double? getTextLineHeight(String managerId);
  @async
  void setTextMaxAngle(String managerId, double textMaxAngle);
  @async
  double? getTextMaxAngle(String managerId);
  @async
  void setTextOptional(String managerId, bool textOptional);
  @async
  bool? getTextOptional(String managerId);
  @async
  void setTextPadding(String managerId, double textPadding);
  @async
  double? getTextPadding(String managerId);
  @async
  void setTextPitchAlignment(String managerId, TextPitchAlignment textPitchAlignment);
  @async
  int? getTextPitchAlignment(String managerId);
  @async
  void setTextRotationAlignment(String managerId, TextRotationAlignment textRotationAlignment);
  @async
  int? getTextRotationAlignment(String managerId);
  @async
  void setIconTranslate(String managerId, List<double?> iconTranslate);
  @async
  List<double?>? getIconTranslate(String managerId);
  @async
  void setIconTranslateAnchor(String managerId, IconTranslateAnchor iconTranslateAnchor);
  @async
  int? getIconTranslateAnchor(String managerId);
  @async
  void setTextTranslate(String managerId, List<double?> textTranslate);
  @async
  List<double?>? getTextTranslate(String managerId);
  @async
  void setTextTranslateAnchor(String managerId, TextTranslateAnchor textTranslateAnchor);
  @async
  int? getTextTranslateAnchor(String managerId);
}

class PointAnnotation {
  /// The id for annotation
  String id;
  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;
  /// The bitmap image for this Annotation
  /// Will not take effect if [iconImage] has been set.
  Uint8List? image;
  /// Part of the icon placed closest to the anchor.
  IconAnchor? iconAnchor;
  /// Name of image in sprite to use for drawing an image background.
  String? iconImage;
  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up.
  List<double?>? iconOffset;
  /// Rotates the icon clockwise.
  double? iconRotate;
  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image.
  double? iconSize;
  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first.  When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  double? symbolSortKey;
  /// Part of the text placed closest to the anchor.
  TextAnchor? textAnchor;
  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options.
  String? textField;
  /// Text justification options.
  TextJustify? textJustify;
  /// Text tracking amount.
  double? textLetterSpacing;
  /// The maximum line width for text wrapping.
  double? textMaxWidth;
  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position.
  List<double?>? textOffset;
  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present.
  double? textRadialOffset;
  /// Rotates the text clockwise.
  double? textRotate;
  /// Font size.
  double? textSize;
  /// Specifies how to capitalize text, similar to the CSS `text-transform` property.
  TextTransform? textTransform;
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
}

class PointAnnotationOptions {
  /// The geometry that determines the location/shape of this annotation
  Map<String?, Object?>? geometry;
  /// The bitmap image for this Annotation
  /// Will not take effect if [iconImage] has been set.
  Uint8List? image;
  /// Part of the icon placed closest to the anchor.
  IconAnchor? iconAnchor;
  /// Name of image in sprite to use for drawing an image background.
  String? iconImage;
  /// Offset distance of icon from its anchor. Positive values indicate right and down, while negative values indicate left and up. Each component is multiplied by the value of `icon-size` to obtain the final offset in pixels. When combined with `icon-rotate` the offset will be as if the rotated direction was up.
  List<double?>? iconOffset;
  /// Rotates the icon clockwise.
  double? iconRotate;
  /// Scales the original size of the icon by the provided factor. The new pixel size of the image will be the original pixel size multiplied by `icon-size`. 1 is the original size; 3 triples the size of the image.
  double? iconSize;
  /// Sorts features in ascending order based on this value. Features with lower sort keys are drawn and placed first.  When `icon-allow-overlap` or `text-allow-overlap` is `false`, features with a lower sort key will have priority during placement. When `icon-allow-overlap` or `text-allow-overlap` is set to `true`, features with a higher sort key will overlap over features with a lower sort key.
  double? symbolSortKey;
  /// Part of the text placed closest to the anchor.
  TextAnchor? textAnchor;
  /// Value to use for a text label. If a plain `string` is provided, it will be treated as a `formatted` with default/inherited formatting options.
  String? textField;
  /// Text justification options.
  TextJustify? textJustify;
  /// Text tracking amount.
  double? textLetterSpacing;
  /// The maximum line width for text wrapping.
  double? textMaxWidth;
  /// Offset distance of text from its anchor. Positive values indicate right and down, while negative values indicate left and up. If used with text-variable-anchor, input values will be taken as absolute values. Offsets along the x- and y-axis will be applied automatically based on the anchor position.
  List<double?>? textOffset;
  /// Radial offset of text, in the direction of the symbol's anchor. Useful in combination with `text-variable-anchor`, which defaults to using the two-dimensional `text-offset` if present.
  double? textRadialOffset;
  /// Rotates the text clockwise.
  double? textRotate;
  /// Font size.
  double? textSize;
  /// Specifies how to capitalize text, similar to the CSS `text-transform` property.
  TextTransform? textTransform;
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
}
// End of generated file.