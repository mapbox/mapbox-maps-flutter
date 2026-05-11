// This file is generated.
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Web stub. Methods that mutate the map throw [UnimplementedError];
/// the interaction streams are empty broadcast streams so listener
/// registration succeeds with a Cancelable that never fires.
class UnsupportedCircleAnnotationManagerWeb
    implements CircleAnnotationManagerPlatformInterface {
  UnsupportedCircleAnnotationManagerWeb(this.id);

  @override
  final String id;

  Never _unimplemented(String method) => throw UnimplementedError(
    'CircleAnnotationManager.\$method is not yet implemented on web.',
  );

  @override
  Stream<CircleAnnotationInteractionContext> get tapInteractionStream =>
      Stream<CircleAnnotationInteractionContext>.empty().asBroadcastStream();

  @override
  Stream<CircleAnnotationInteractionContext> get longPressInteractionStream =>
      Stream<CircleAnnotationInteractionContext>.empty().asBroadcastStream();

  @override
  Stream<CircleAnnotationInteractionContext> get dragInteractionStream =>
      Stream<CircleAnnotationInteractionContext>.empty().asBroadcastStream();

  @override
  Future<List<CircleAnnotation>> getAnnotations() =>
      _unimplemented('getAnnotations');

  @override
  Future<CircleAnnotation> create(CircleAnnotationOptions annotation) =>
      _unimplemented('create');

  @override
  Future<List<CircleAnnotation?>> createMulti(
    List<CircleAnnotationOptions> annotations,
  ) => _unimplemented('createMulti');

  @override
  Future<void> update(CircleAnnotation annotation) => _unimplemented('update');

  @override
  Future<void> delete(CircleAnnotation annotation) => _unimplemented('delete');

  @override
  Future<void> deleteAll() => _unimplemented('deleteAll');

  @override
  Future<void> deleteMulti(List<CircleAnnotation> annotations) =>
      _unimplemented('deleteMulti');

  @override
  Future<void> setCircleElevationReference(
    CircleElevationReference circleElevationReference,
  ) => _unimplemented('setCircleElevationReference');

  @override
  Future<CircleElevationReference?> getCircleElevationReference() =>
      _unimplemented('getCircleElevationReference');

  @override
  Future<void> setCircleSortKey(double circleSortKey) =>
      _unimplemented('setCircleSortKey');

  @override
  Future<double?> getCircleSortKey() => _unimplemented('getCircleSortKey');

  @override
  Future<void> setCircleBlur(double circleBlur) =>
      _unimplemented('setCircleBlur');

  @override
  Future<double?> getCircleBlur() => _unimplemented('getCircleBlur');

  @override
  Future<void> setCircleColor(int circleColor) =>
      _unimplemented('setCircleColor');

  @override
  Future<int?> getCircleColor() => _unimplemented('getCircleColor');

  @override
  Future<void> setCircleEmissiveStrength(double circleEmissiveStrength) =>
      _unimplemented('setCircleEmissiveStrength');

  @override
  Future<double?> getCircleEmissiveStrength() =>
      _unimplemented('getCircleEmissiveStrength');

  @override
  Future<void> setCircleOpacity(double circleOpacity) =>
      _unimplemented('setCircleOpacity');

  @override
  Future<double?> getCircleOpacity() => _unimplemented('getCircleOpacity');

  @override
  Future<void> setCirclePitchAlignment(
    CirclePitchAlignment circlePitchAlignment,
  ) => _unimplemented('setCirclePitchAlignment');

  @override
  Future<CirclePitchAlignment?> getCirclePitchAlignment() =>
      _unimplemented('getCirclePitchAlignment');

  @override
  Future<void> setCirclePitchScale(CirclePitchScale circlePitchScale) =>
      _unimplemented('setCirclePitchScale');

  @override
  Future<CirclePitchScale?> getCirclePitchScale() =>
      _unimplemented('getCirclePitchScale');

  @override
  Future<void> setCircleRadius(double circleRadius) =>
      _unimplemented('setCircleRadius');

  @override
  Future<double?> getCircleRadius() => _unimplemented('getCircleRadius');

  @override
  Future<void> setCircleStrokeColor(int circleStrokeColor) =>
      _unimplemented('setCircleStrokeColor');

  @override
  Future<int?> getCircleStrokeColor() => _unimplemented('getCircleStrokeColor');

  @override
  Future<void> setCircleStrokeOpacity(double circleStrokeOpacity) =>
      _unimplemented('setCircleStrokeOpacity');

  @override
  Future<double?> getCircleStrokeOpacity() =>
      _unimplemented('getCircleStrokeOpacity');

  @override
  Future<void> setCircleStrokeWidth(double circleStrokeWidth) =>
      _unimplemented('setCircleStrokeWidth');

  @override
  Future<double?> getCircleStrokeWidth() =>
      _unimplemented('getCircleStrokeWidth');

  @override
  Future<void> setCircleTranslate(List<double?> circleTranslate) =>
      _unimplemented('setCircleTranslate');

  @override
  Future<List<double?>?> getCircleTranslate() =>
      _unimplemented('getCircleTranslate');

  @override
  Future<void> setCircleTranslateAnchor(
    CircleTranslateAnchor circleTranslateAnchor,
  ) => _unimplemented('setCircleTranslateAnchor');

  @override
  Future<CircleTranslateAnchor?> getCircleTranslateAnchor() =>
      _unimplemented('getCircleTranslateAnchor');
}

// End of generated file.
