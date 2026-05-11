// This file is generated.
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Web stub. Methods that mutate the map throw [UnimplementedError];
/// the interaction streams are empty broadcast streams so listener
/// registration succeeds with a Cancelable that never fires.
class UnsupportedPolygonAnnotationManagerWeb
    implements PolygonAnnotationManagerPlatformInterface {
  UnsupportedPolygonAnnotationManagerWeb(this.id);

  @override
  final String id;

  Never _unimplemented(String method) => throw UnimplementedError(
    'PolygonAnnotationManager.\$method is not yet implemented on web.',
  );

  @override
  Stream<PolygonAnnotationInteractionContext> get tapInteractionStream =>
      Stream<PolygonAnnotationInteractionContext>.empty().asBroadcastStream();

  @override
  Stream<PolygonAnnotationInteractionContext> get longPressInteractionStream =>
      Stream<PolygonAnnotationInteractionContext>.empty().asBroadcastStream();

  @override
  Stream<PolygonAnnotationInteractionContext> get dragInteractionStream =>
      Stream<PolygonAnnotationInteractionContext>.empty().asBroadcastStream();

  @override
  Future<List<PolygonAnnotation>> getAnnotations() =>
      _unimplemented('getAnnotations');

  @override
  Future<PolygonAnnotation> create(PolygonAnnotationOptions annotation) =>
      _unimplemented('create');

  @override
  Future<List<PolygonAnnotation?>> createMulti(
    List<PolygonAnnotationOptions> annotations,
  ) => _unimplemented('createMulti');

  @override
  Future<void> update(PolygonAnnotation annotation) => _unimplemented('update');

  @override
  Future<void> delete(PolygonAnnotation annotation) => _unimplemented('delete');

  @override
  Future<void> deleteAll() => _unimplemented('deleteAll');

  @override
  Future<void> deleteMulti(List<PolygonAnnotation> annotations) =>
      _unimplemented('deleteMulti');

  @override
  Future<void> setFillConstructBridgeGuardRail(
    bool fillConstructBridgeGuardRail,
  ) => _unimplemented('setFillConstructBridgeGuardRail');

  @override
  Future<bool?> getFillConstructBridgeGuardRail() =>
      _unimplemented('getFillConstructBridgeGuardRail');

  @override
  Future<void> setFillElevationReference(
    FillElevationReference fillElevationReference,
  ) => _unimplemented('setFillElevationReference');

  @override
  Future<FillElevationReference?> getFillElevationReference() =>
      _unimplemented('getFillElevationReference');

  @override
  Future<void> setFillSortKey(double fillSortKey) =>
      _unimplemented('setFillSortKey');

  @override
  Future<double?> getFillSortKey() => _unimplemented('getFillSortKey');

  @override
  Future<void> setFillAntialias(bool fillAntialias) =>
      _unimplemented('setFillAntialias');

  @override
  Future<bool?> getFillAntialias() => _unimplemented('getFillAntialias');

  @override
  Future<void> setFillBridgeGuardRailColor(int fillBridgeGuardRailColor) =>
      _unimplemented('setFillBridgeGuardRailColor');

  @override
  Future<int?> getFillBridgeGuardRailColor() =>
      _unimplemented('getFillBridgeGuardRailColor');

  @override
  Future<void> setFillColor(int fillColor) => _unimplemented('setFillColor');

  @override
  Future<int?> getFillColor() => _unimplemented('getFillColor');

  @override
  Future<void> setFillEmissiveStrength(double fillEmissiveStrength) =>
      _unimplemented('setFillEmissiveStrength');

  @override
  Future<double?> getFillEmissiveStrength() =>
      _unimplemented('getFillEmissiveStrength');

  @override
  Future<void> setFillOpacity(double fillOpacity) =>
      _unimplemented('setFillOpacity');

  @override
  Future<double?> getFillOpacity() => _unimplemented('getFillOpacity');

  @override
  Future<void> setFillOutlineColor(int fillOutlineColor) =>
      _unimplemented('setFillOutlineColor');

  @override
  Future<int?> getFillOutlineColor() => _unimplemented('getFillOutlineColor');

  @override
  Future<void> setFillPattern(String fillPattern) =>
      _unimplemented('setFillPattern');

  @override
  Future<String?> getFillPattern() => _unimplemented('getFillPattern');

  @override
  Future<void> setFillTranslate(List<double?> fillTranslate) =>
      _unimplemented('setFillTranslate');

  @override
  Future<List<double?>?> getFillTranslate() =>
      _unimplemented('getFillTranslate');

  @override
  Future<void> setFillTranslateAnchor(
    FillTranslateAnchor fillTranslateAnchor,
  ) => _unimplemented('setFillTranslateAnchor');

  @override
  Future<FillTranslateAnchor?> getFillTranslateAnchor() =>
      _unimplemented('getFillTranslateAnchor');

  @override
  Future<void> setFillTunnelStructureColor(int fillTunnelStructureColor) =>
      _unimplemented('setFillTunnelStructureColor');

  @override
  Future<int?> getFillTunnelStructureColor() =>
      _unimplemented('getFillTunnelStructureColor');

  @override
  Future<void> setFillZOffset(double fillZOffset) =>
      _unimplemented('setFillZOffset');

  @override
  Future<double?> getFillZOffset() => _unimplemented('getFillZOffset');
}

// End of generated file.
