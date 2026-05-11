// This file is generated.
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Web stub. Methods that mutate the map throw [UnimplementedError];
/// the interaction streams are empty broadcast streams so listener
/// registration succeeds with a Cancelable that never fires.
class UnsupportedPointAnnotationManagerWeb
    implements PointAnnotationManagerPlatformInterface {
  UnsupportedPointAnnotationManagerWeb(this.id);

  @override
  final String id;

  Never _unimplemented(String method) => throw UnimplementedError(
    'PointAnnotationManager.\$method is not yet implemented on web.',
  );

  @override
  Stream<PointAnnotationInteractionContext> get tapInteractionStream =>
      Stream<PointAnnotationInteractionContext>.empty().asBroadcastStream();

  @override
  Stream<PointAnnotationInteractionContext> get longPressInteractionStream =>
      Stream<PointAnnotationInteractionContext>.empty().asBroadcastStream();

  @override
  Stream<PointAnnotationInteractionContext> get dragInteractionStream =>
      Stream<PointAnnotationInteractionContext>.empty().asBroadcastStream();

  @override
  Future<List<PointAnnotation>> getAnnotations() =>
      _unimplemented('getAnnotations');

  @override
  Future<PointAnnotation> create(PointAnnotationOptions annotation) =>
      _unimplemented('create');

  @override
  Future<List<PointAnnotation?>> createMulti(
    List<PointAnnotationOptions> annotations,
  ) => _unimplemented('createMulti');

  @override
  Future<void> update(PointAnnotation annotation) => _unimplemented('update');

  @override
  Future<void> delete(PointAnnotation annotation) => _unimplemented('delete');

  @override
  Future<void> deleteAll() => _unimplemented('deleteAll');

  @override
  Future<void> deleteMulti(List<PointAnnotation> annotations) =>
      _unimplemented('deleteMulti');

  @override
  Future<void> setIconAllowOverlap(bool iconAllowOverlap) =>
      _unimplemented('setIconAllowOverlap');

  @override
  Future<bool?> getIconAllowOverlap() => _unimplemented('getIconAllowOverlap');

  @override
  Future<void> setIconAnchor(IconAnchor iconAnchor) =>
      _unimplemented('setIconAnchor');

  @override
  Future<IconAnchor?> getIconAnchor() => _unimplemented('getIconAnchor');

  @override
  Future<void> setIconIgnorePlacement(bool iconIgnorePlacement) =>
      _unimplemented('setIconIgnorePlacement');

  @override
  Future<bool?> getIconIgnorePlacement() =>
      _unimplemented('getIconIgnorePlacement');

  @override
  Future<void> setIconImage(String iconImage) => _unimplemented('setIconImage');

  @override
  Future<String?> getIconImage() => _unimplemented('getIconImage');

  @override
  Future<void> setIconKeepUpright(bool iconKeepUpright) =>
      _unimplemented('setIconKeepUpright');

  @override
  Future<bool?> getIconKeepUpright() => _unimplemented('getIconKeepUpright');

  @override
  Future<void> setIconOffset(List<double?> iconOffset) =>
      _unimplemented('setIconOffset');

  @override
  Future<List<double?>?> getIconOffset() => _unimplemented('getIconOffset');

  @override
  Future<void> setIconOptional(bool iconOptional) =>
      _unimplemented('setIconOptional');

  @override
  Future<bool?> getIconOptional() => _unimplemented('getIconOptional');

  @override
  Future<void> setIconPadding(double iconPadding) =>
      _unimplemented('setIconPadding');

  @override
  Future<double?> getIconPadding() => _unimplemented('getIconPadding');

  @override
  Future<void> setIconPitchAlignment(IconPitchAlignment iconPitchAlignment) =>
      _unimplemented('setIconPitchAlignment');

  @override
  Future<IconPitchAlignment?> getIconPitchAlignment() =>
      _unimplemented('getIconPitchAlignment');

  @override
  Future<void> setIconRotate(double iconRotate) =>
      _unimplemented('setIconRotate');

  @override
  Future<double?> getIconRotate() => _unimplemented('getIconRotate');

  @override
  Future<void> setIconRotationAlignment(
    IconRotationAlignment iconRotationAlignment,
  ) => _unimplemented('setIconRotationAlignment');

  @override
  Future<IconRotationAlignment?> getIconRotationAlignment() =>
      _unimplemented('getIconRotationAlignment');

  @override
  Future<void> setIconSize(double iconSize) => _unimplemented('setIconSize');

  @override
  Future<double?> getIconSize() => _unimplemented('getIconSize');

  @override
  Future<void> setIconSizeScaleRange(List<double?> iconSizeScaleRange) =>
      _unimplemented('setIconSizeScaleRange');

  @override
  Future<List<double?>?> getIconSizeScaleRange() =>
      _unimplemented('getIconSizeScaleRange');

  @override
  Future<void> setIconTextFit(IconTextFit iconTextFit) =>
      _unimplemented('setIconTextFit');

  @override
  Future<IconTextFit?> getIconTextFit() => _unimplemented('getIconTextFit');

  @override
  Future<void> setIconTextFitPadding(List<double?> iconTextFitPadding) =>
      _unimplemented('setIconTextFitPadding');

  @override
  Future<List<double?>?> getIconTextFitPadding() =>
      _unimplemented('getIconTextFitPadding');

  @override
  Future<void> setSymbolAvoidEdges(bool symbolAvoidEdges) =>
      _unimplemented('setSymbolAvoidEdges');

  @override
  Future<bool?> getSymbolAvoidEdges() => _unimplemented('getSymbolAvoidEdges');

  @override
  Future<void> setSymbolElevationReference(
    SymbolElevationReference symbolElevationReference,
  ) => _unimplemented('setSymbolElevationReference');

  @override
  Future<SymbolElevationReference?> getSymbolElevationReference() =>
      _unimplemented('getSymbolElevationReference');

  @override
  Future<void> setSymbolPlacement(SymbolPlacement symbolPlacement) =>
      _unimplemented('setSymbolPlacement');

  @override
  Future<SymbolPlacement?> getSymbolPlacement() =>
      _unimplemented('getSymbolPlacement');

  @override
  Future<void> setSymbolSortKey(double symbolSortKey) =>
      _unimplemented('setSymbolSortKey');

  @override
  Future<double?> getSymbolSortKey() => _unimplemented('getSymbolSortKey');

  @override
  Future<void> setSymbolSpacing(double symbolSpacing) =>
      _unimplemented('setSymbolSpacing');

  @override
  Future<double?> getSymbolSpacing() => _unimplemented('getSymbolSpacing');

  @override
  Future<void> setSymbolZElevate(bool symbolZElevate) =>
      _unimplemented('setSymbolZElevate');

  @override
  Future<bool?> getSymbolZElevate() => _unimplemented('getSymbolZElevate');

  @override
  Future<void> setSymbolZOrder(SymbolZOrder symbolZOrder) =>
      _unimplemented('setSymbolZOrder');

  @override
  Future<SymbolZOrder?> getSymbolZOrder() => _unimplemented('getSymbolZOrder');

  @override
  Future<void> setTextAllowOverlap(bool textAllowOverlap) =>
      _unimplemented('setTextAllowOverlap');

  @override
  Future<bool?> getTextAllowOverlap() => _unimplemented('getTextAllowOverlap');

  @override
  Future<void> setTextAnchor(TextAnchor textAnchor) =>
      _unimplemented('setTextAnchor');

  @override
  Future<TextAnchor?> getTextAnchor() => _unimplemented('getTextAnchor');

  @override
  Future<void> setTextField(String textField) => _unimplemented('setTextField');

  @override
  Future<String?> getTextField() => _unimplemented('getTextField');

  @override
  Future<void> setTextFont(List<String?> textFont) =>
      _unimplemented('setTextFont');

  @override
  Future<List<String?>?> getTextFont() => _unimplemented('getTextFont');

  @override
  Future<void> setTextIgnorePlacement(bool textIgnorePlacement) =>
      _unimplemented('setTextIgnorePlacement');

  @override
  Future<bool?> getTextIgnorePlacement() =>
      _unimplemented('getTextIgnorePlacement');

  @override
  Future<void> setTextJustify(TextJustify textJustify) =>
      _unimplemented('setTextJustify');

  @override
  Future<TextJustify?> getTextJustify() => _unimplemented('getTextJustify');

  @override
  Future<void> setTextKeepUpright(bool textKeepUpright) =>
      _unimplemented('setTextKeepUpright');

  @override
  Future<bool?> getTextKeepUpright() => _unimplemented('getTextKeepUpright');

  @override
  Future<void> setTextLetterSpacing(double textLetterSpacing) =>
      _unimplemented('setTextLetterSpacing');

  @override
  Future<double?> getTextLetterSpacing() =>
      _unimplemented('getTextLetterSpacing');

  @override
  Future<void> setTextLineHeight(double textLineHeight) =>
      _unimplemented('setTextLineHeight');

  @override
  Future<double?> getTextLineHeight() => _unimplemented('getTextLineHeight');

  @override
  Future<void> setTextMaxAngle(double textMaxAngle) =>
      _unimplemented('setTextMaxAngle');

  @override
  Future<double?> getTextMaxAngle() => _unimplemented('getTextMaxAngle');

  @override
  Future<void> setTextMaxWidth(double textMaxWidth) =>
      _unimplemented('setTextMaxWidth');

  @override
  Future<double?> getTextMaxWidth() => _unimplemented('getTextMaxWidth');

  @override
  Future<void> setTextOffset(List<double?> textOffset) =>
      _unimplemented('setTextOffset');

  @override
  Future<List<double?>?> getTextOffset() => _unimplemented('getTextOffset');

  @override
  Future<void> setTextOptional(bool textOptional) =>
      _unimplemented('setTextOptional');

  @override
  Future<bool?> getTextOptional() => _unimplemented('getTextOptional');

  @override
  Future<void> setTextPadding(double textPadding) =>
      _unimplemented('setTextPadding');

  @override
  Future<double?> getTextPadding() => _unimplemented('getTextPadding');

  @override
  Future<void> setTextPitchAlignment(TextPitchAlignment textPitchAlignment) =>
      _unimplemented('setTextPitchAlignment');

  @override
  Future<TextPitchAlignment?> getTextPitchAlignment() =>
      _unimplemented('getTextPitchAlignment');

  @override
  Future<void> setTextRadialOffset(double textRadialOffset) =>
      _unimplemented('setTextRadialOffset');

  @override
  Future<double?> getTextRadialOffset() =>
      _unimplemented('getTextRadialOffset');

  @override
  Future<void> setTextRotate(double textRotate) =>
      _unimplemented('setTextRotate');

  @override
  Future<double?> getTextRotate() => _unimplemented('getTextRotate');

  @override
  Future<void> setTextRotationAlignment(
    TextRotationAlignment textRotationAlignment,
  ) => _unimplemented('setTextRotationAlignment');

  @override
  Future<TextRotationAlignment?> getTextRotationAlignment() =>
      _unimplemented('getTextRotationAlignment');

  @override
  Future<void> setTextSize(double textSize) => _unimplemented('setTextSize');

  @override
  Future<double?> getTextSize() => _unimplemented('getTextSize');

  @override
  Future<void> setTextSizeScaleRange(List<double?> textSizeScaleRange) =>
      _unimplemented('setTextSizeScaleRange');

  @override
  Future<List<double?>?> getTextSizeScaleRange() =>
      _unimplemented('getTextSizeScaleRange');

  @override
  Future<void> setTextTransform(TextTransform textTransform) =>
      _unimplemented('setTextTransform');

  @override
  Future<TextTransform?> getTextTransform() =>
      _unimplemented('getTextTransform');

  @override
  Future<void> setIconColor(int iconColor) => _unimplemented('setIconColor');

  @override
  Future<int?> getIconColor() => _unimplemented('getIconColor');

  @override
  Future<void> setIconColorBrightnessMax(double iconColorBrightnessMax) =>
      _unimplemented('setIconColorBrightnessMax');

  @override
  Future<double?> getIconColorBrightnessMax() =>
      _unimplemented('getIconColorBrightnessMax');

  @override
  Future<void> setIconColorBrightnessMin(double iconColorBrightnessMin) =>
      _unimplemented('setIconColorBrightnessMin');

  @override
  Future<double?> getIconColorBrightnessMin() =>
      _unimplemented('getIconColorBrightnessMin');

  @override
  Future<void> setIconColorContrast(double iconColorContrast) =>
      _unimplemented('setIconColorContrast');

  @override
  Future<double?> getIconColorContrast() =>
      _unimplemented('getIconColorContrast');

  @override
  Future<void> setIconColorSaturation(double iconColorSaturation) =>
      _unimplemented('setIconColorSaturation');

  @override
  Future<double?> getIconColorSaturation() =>
      _unimplemented('getIconColorSaturation');

  @override
  Future<void> setIconEmissiveStrength(double iconEmissiveStrength) =>
      _unimplemented('setIconEmissiveStrength');

  @override
  Future<double?> getIconEmissiveStrength() =>
      _unimplemented('getIconEmissiveStrength');

  @override
  Future<void> setIconHaloBlur(double iconHaloBlur) =>
      _unimplemented('setIconHaloBlur');

  @override
  Future<double?> getIconHaloBlur() => _unimplemented('getIconHaloBlur');

  @override
  Future<void> setIconHaloColor(int iconHaloColor) =>
      _unimplemented('setIconHaloColor');

  @override
  Future<int?> getIconHaloColor() => _unimplemented('getIconHaloColor');

  @override
  Future<void> setIconHaloWidth(double iconHaloWidth) =>
      _unimplemented('setIconHaloWidth');

  @override
  Future<double?> getIconHaloWidth() => _unimplemented('getIconHaloWidth');

  @override
  Future<void> setIconImageCrossFade(double iconImageCrossFade) =>
      _unimplemented('setIconImageCrossFade');

  @override
  Future<double?> getIconImageCrossFade() =>
      _unimplemented('getIconImageCrossFade');

  @override
  Future<void> setIconOcclusionOpacity(double iconOcclusionOpacity) =>
      _unimplemented('setIconOcclusionOpacity');

  @override
  Future<double?> getIconOcclusionOpacity() =>
      _unimplemented('getIconOcclusionOpacity');

  @override
  Future<void> setIconOpacity(double iconOpacity) =>
      _unimplemented('setIconOpacity');

  @override
  Future<double?> getIconOpacity() => _unimplemented('getIconOpacity');

  @override
  Future<void> setIconTranslate(List<double?> iconTranslate) =>
      _unimplemented('setIconTranslate');

  @override
  Future<List<double?>?> getIconTranslate() =>
      _unimplemented('getIconTranslate');

  @override
  Future<void> setIconTranslateAnchor(
    IconTranslateAnchor iconTranslateAnchor,
  ) => _unimplemented('setIconTranslateAnchor');

  @override
  Future<IconTranslateAnchor?> getIconTranslateAnchor() =>
      _unimplemented('getIconTranslateAnchor');

  @override
  Future<void> setOcclusionOpacityMode(
    OcclusionOpacityMode occlusionOpacityMode,
  ) => _unimplemented('setOcclusionOpacityMode');

  @override
  Future<OcclusionOpacityMode?> getOcclusionOpacityMode() =>
      _unimplemented('getOcclusionOpacityMode');

  @override
  Future<void> setSymbolZOffset(double symbolZOffset) =>
      _unimplemented('setSymbolZOffset');

  @override
  Future<double?> getSymbolZOffset() => _unimplemented('getSymbolZOffset');

  @override
  Future<void> setTextColor(int textColor) => _unimplemented('setTextColor');

  @override
  Future<int?> getTextColor() => _unimplemented('getTextColor');

  @override
  Future<void> setTextEmissiveStrength(double textEmissiveStrength) =>
      _unimplemented('setTextEmissiveStrength');

  @override
  Future<double?> getTextEmissiveStrength() =>
      _unimplemented('getTextEmissiveStrength');

  @override
  Future<void> setTextHaloBlur(double textHaloBlur) =>
      _unimplemented('setTextHaloBlur');

  @override
  Future<double?> getTextHaloBlur() => _unimplemented('getTextHaloBlur');

  @override
  Future<void> setTextHaloColor(int textHaloColor) =>
      _unimplemented('setTextHaloColor');

  @override
  Future<int?> getTextHaloColor() => _unimplemented('getTextHaloColor');

  @override
  Future<void> setTextHaloWidth(double textHaloWidth) =>
      _unimplemented('setTextHaloWidth');

  @override
  Future<double?> getTextHaloWidth() => _unimplemented('getTextHaloWidth');

  @override
  Future<void> setTextOcclusionOpacity(double textOcclusionOpacity) =>
      _unimplemented('setTextOcclusionOpacity');

  @override
  Future<double?> getTextOcclusionOpacity() =>
      _unimplemented('getTextOcclusionOpacity');

  @override
  Future<void> setTextOpacity(double textOpacity) =>
      _unimplemented('setTextOpacity');

  @override
  Future<double?> getTextOpacity() => _unimplemented('getTextOpacity');

  @override
  Future<void> setTextTranslate(List<double?> textTranslate) =>
      _unimplemented('setTextTranslate');

  @override
  Future<List<double?>?> getTextTranslate() =>
      _unimplemented('getTextTranslate');

  @override
  Future<void> setTextTranslateAnchor(
    TextTranslateAnchor textTranslateAnchor,
  ) => _unimplemented('setTextTranslateAnchor');

  @override
  Future<TextTranslateAnchor?> getTextTranslateAnchor() =>
      _unimplemented('getTextTranslateAnchor');
}

// End of generated file.
