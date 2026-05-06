// This file is generated.
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Web stub: GL JS has annotation-like primitives, wiring is post-WS4
/// web-parity work. Every method throws [UnimplementedError].
class UnsupportedPolylineAnnotationManagerWeb
    implements PolylineAnnotationManagerPlatformInterface {
  UnsupportedPolylineAnnotationManagerWeb(this.id);

  @override
  final String id;

  Never _unimplemented(String method) => throw UnimplementedError(
    'PolylineAnnotationManager.\$method is not yet implemented on web.',
  );

  @override
  Cancelable tapEvents({required Function(PolylineAnnotation) onTap}) =>
      _unimplemented('tapEvents');

  @override
  Cancelable longPressEvents({
    required Function(PolylineAnnotation) onLongPress,
  }) => _unimplemented('longPressEvents');

  @override
  Cancelable dragEvents({
    Function(PolylineAnnotation)? onBegin,
    Function(PolylineAnnotation)? onChanged,
    Function(PolylineAnnotation)? onEnd,
  }) => _unimplemented('dragEvents');

  @override
  Future<List<PolylineAnnotation>> getAnnotations() =>
      _unimplemented('getAnnotations');

  @override
  Future<PolylineAnnotation> create(PolylineAnnotationOptions annotation) =>
      _unimplemented('create');

  @override
  Future<List<PolylineAnnotation?>> createMulti(
    List<PolylineAnnotationOptions> annotations,
  ) => _unimplemented('createMulti');

  @override
  Future<void> update(PolylineAnnotation annotation) =>
      _unimplemented('update');

  @override
  Future<void> delete(PolylineAnnotation annotation) =>
      _unimplemented('delete');

  @override
  Future<void> deleteAll() => _unimplemented('deleteAll');

  @override
  Future<void> deleteMulti(List<PolylineAnnotation> annotations) =>
      _unimplemented('deleteMulti');

  @override
  Future<void> setLineCap(LineCap lineCap) => _unimplemented('setLineCap');

  @override
  Future<LineCap?> getLineCap() => _unimplemented('getLineCap');

  @override
  Future<void> setLineCrossSlope(double lineCrossSlope) =>
      _unimplemented('setLineCrossSlope');

  @override
  Future<double?> getLineCrossSlope() => _unimplemented('getLineCrossSlope');

  @override
  Future<void> setLineElevationGroundScale(double lineElevationGroundScale) =>
      _unimplemented('setLineElevationGroundScale');

  @override
  Future<double?> getLineElevationGroundScale() =>
      _unimplemented('getLineElevationGroundScale');

  @override
  Future<void> setLineElevationReference(
    LineElevationReference lineElevationReference,
  ) => _unimplemented('setLineElevationReference');

  @override
  Future<LineElevationReference?> getLineElevationReference() =>
      _unimplemented('getLineElevationReference');

  @override
  Future<void> setLineJoin(LineJoin lineJoin) => _unimplemented('setLineJoin');

  @override
  Future<LineJoin?> getLineJoin() => _unimplemented('getLineJoin');

  @override
  Future<void> setLineMiterLimit(double lineMiterLimit) =>
      _unimplemented('setLineMiterLimit');

  @override
  Future<double?> getLineMiterLimit() => _unimplemented('getLineMiterLimit');

  @override
  Future<void> setLineRoundLimit(double lineRoundLimit) =>
      _unimplemented('setLineRoundLimit');

  @override
  Future<double?> getLineRoundLimit() => _unimplemented('getLineRoundLimit');

  @override
  Future<void> setLineSortKey(double lineSortKey) =>
      _unimplemented('setLineSortKey');

  @override
  Future<double?> getLineSortKey() => _unimplemented('getLineSortKey');

  @override
  Future<void> setLineWidthUnit(LineWidthUnit lineWidthUnit) =>
      _unimplemented('setLineWidthUnit');

  @override
  Future<LineWidthUnit?> getLineWidthUnit() =>
      _unimplemented('getLineWidthUnit');

  @override
  Future<void> setLineZOffset(double lineZOffset) =>
      _unimplemented('setLineZOffset');

  @override
  Future<double?> getLineZOffset() => _unimplemented('getLineZOffset');

  @override
  Future<void> setLineBlur(double lineBlur) => _unimplemented('setLineBlur');

  @override
  Future<double?> getLineBlur() => _unimplemented('getLineBlur');

  @override
  Future<void> setLineBorderColor(int lineBorderColor) =>
      _unimplemented('setLineBorderColor');

  @override
  Future<int?> getLineBorderColor() => _unimplemented('getLineBorderColor');

  @override
  Future<void> setLineBorderWidth(double lineBorderWidth) =>
      _unimplemented('setLineBorderWidth');

  @override
  Future<double?> getLineBorderWidth() => _unimplemented('getLineBorderWidth');

  @override
  Future<void> setLineColor(int lineColor) => _unimplemented('setLineColor');

  @override
  Future<int?> getLineColor() => _unimplemented('getLineColor');

  @override
  Future<void> setLineCutoutFadeWidth(double lineCutoutFadeWidth) =>
      _unimplemented('setLineCutoutFadeWidth');

  @override
  Future<double?> getLineCutoutFadeWidth() =>
      _unimplemented('getLineCutoutFadeWidth');

  @override
  Future<void> setLineCutoutOpacity(double lineCutoutOpacity) =>
      _unimplemented('setLineCutoutOpacity');

  @override
  Future<double?> getLineCutoutOpacity() =>
      _unimplemented('getLineCutoutOpacity');

  @override
  Future<void> setLineDasharray(List<double?> lineDasharray) =>
      _unimplemented('setLineDasharray');

  @override
  Future<List<double?>?> getLineDasharray() =>
      _unimplemented('getLineDasharray');

  @override
  Future<void> setLineDepthOcclusionFactor(double lineDepthOcclusionFactor) =>
      _unimplemented('setLineDepthOcclusionFactor');

  @override
  Future<double?> getLineDepthOcclusionFactor() =>
      _unimplemented('getLineDepthOcclusionFactor');

  @override
  Future<void> setLineEmissiveStrength(double lineEmissiveStrength) =>
      _unimplemented('setLineEmissiveStrength');

  @override
  Future<double?> getLineEmissiveStrength() =>
      _unimplemented('getLineEmissiveStrength');

  @override
  Future<void> setLineGapWidth(double lineGapWidth) =>
      _unimplemented('setLineGapWidth');

  @override
  Future<double?> getLineGapWidth() => _unimplemented('getLineGapWidth');

  @override
  Future<void> setLineOcclusionOpacity(double lineOcclusionOpacity) =>
      _unimplemented('setLineOcclusionOpacity');

  @override
  Future<double?> getLineOcclusionOpacity() =>
      _unimplemented('getLineOcclusionOpacity');

  @override
  Future<void> setLineOffset(double lineOffset) =>
      _unimplemented('setLineOffset');

  @override
  Future<double?> getLineOffset() => _unimplemented('getLineOffset');

  @override
  Future<void> setLineOpacity(double lineOpacity) =>
      _unimplemented('setLineOpacity');

  @override
  Future<double?> getLineOpacity() => _unimplemented('getLineOpacity');

  @override
  Future<void> setLinePattern(String linePattern) =>
      _unimplemented('setLinePattern');

  @override
  Future<String?> getLinePattern() => _unimplemented('getLinePattern');

  @override
  Future<void> setLineTranslate(List<double?> lineTranslate) =>
      _unimplemented('setLineTranslate');

  @override
  Future<List<double?>?> getLineTranslate() =>
      _unimplemented('getLineTranslate');

  @override
  Future<void> setLineTranslateAnchor(
    LineTranslateAnchor lineTranslateAnchor,
  ) => _unimplemented('setLineTranslateAnchor');

  @override
  Future<LineTranslateAnchor?> getLineTranslateAnchor() =>
      _unimplemented('getLineTranslateAnchor');

  @override
  Future<void> setLineTrimColor(int lineTrimColor) =>
      _unimplemented('setLineTrimColor');

  @override
  Future<int?> getLineTrimColor() => _unimplemented('getLineTrimColor');

  @override
  Future<void> setLineTrimFadeRange(List<double?> lineTrimFadeRange) =>
      _unimplemented('setLineTrimFadeRange');

  @override
  Future<List<double?>?> getLineTrimFadeRange() =>
      _unimplemented('getLineTrimFadeRange');

  @override
  Future<void> setLineTrimOffset(List<double?> lineTrimOffset) =>
      _unimplemented('setLineTrimOffset');

  @override
  Future<List<double?>?> getLineTrimOffset() =>
      _unimplemented('getLineTrimOffset');

  @override
  Future<void> setLineWidth(double lineWidth) => _unimplemented('setLineWidth');

  @override
  Future<double?> getLineWidth() => _unimplemented('getLineWidth');
}

// End of generated file.
