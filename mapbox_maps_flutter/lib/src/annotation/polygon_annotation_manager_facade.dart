// This file is generated.
import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../annotations_manager.dart' show BaseAnnotationManager;

/// Manages polygon annotations.
final class PolygonAnnotationManager
    extends BaseAnnotationManager<PolygonAnnotationManagerPlatformInterface> {
  @internal
  PolygonAnnotationManager(
    PolygonAnnotationManagerPlatformInterface super.impl,
  );

  /// Registers tap event callbacks for the annotations managed by this manager.
  Cancelable tapEvents({required Function(PolygonAnnotation) onTap}) =>
      impl.tapEvents(onTap: onTap);

  /// Registers long press event callbacks for the annotations managed by this manager.
  Cancelable longPressEvents({
    required Function(PolygonAnnotation) onLongPress,
  }) => impl.longPressEvents(onLongPress: onLongPress);

  /// Registers drag event callbacks for the annotations managed by this manager.
  Cancelable dragEvents({
    Function(PolygonAnnotation)? onBegin,
    Function(PolygonAnnotation)? onChanged,
    Function(PolygonAnnotation)? onEnd,
  }) => impl.dragEvents(onBegin: onBegin, onChanged: onChanged, onEnd: onEnd);

  /// Get all annotations of manager.
  Future<List<PolygonAnnotation>> getAnnotations() => impl.getAnnotations();

  /// Create a new annotation with the option.
  Future<PolygonAnnotation> create(PolygonAnnotationOptions annotation) =>
      impl.create(annotation);

  /// Create multi annotations with the options.
  Future<List<PolygonAnnotation?>> createMulti(
    List<PolygonAnnotationOptions> annotations,
  ) => impl.createMulti(annotations);

  /// Update an added annotation with new properties.
  Future<void> update(PolygonAnnotation annotation) => impl.update(annotation);

  /// Delete an added annotation.
  Future<void> delete(PolygonAnnotation annotation) => impl.delete(annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll() => impl.deleteAll();

  /// Delete multiple annotations added by this manager.
  Future<void> deleteMulti(List<PolygonAnnotation> annotations) =>
      impl.deleteMulti(annotations);

  /// Determines whether bridge guard rails are added for elevated roads. Default value: "true".
  @experimental
  Future<void> setFillConstructBridgeGuardRail(
    bool fillConstructBridgeGuardRail,
  ) => impl.setFillConstructBridgeGuardRail(fillConstructBridgeGuardRail);

  /// Determines whether bridge guard rails are added for elevated roads. Default value: "true".
  @experimental
  Future<bool?> getFillConstructBridgeGuardRail() =>
      impl.getFillConstructBridgeGuardRail();

  /// Selects the base of fill-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  @experimental
  Future<void> setFillElevationReference(
    FillElevationReference fillElevationReference,
  ) => impl.setFillElevationReference(fillElevationReference);

  /// Selects the base of fill-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  @experimental
  Future<FillElevationReference?> getFillElevationReference() =>
      impl.getFillElevationReference();

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<void> setFillSortKey(double fillSortKey) =>
      impl.setFillSortKey(fillSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<double?> getFillSortKey() => impl.getFillSortKey();

  /// Whether or not the fill should be antialiased. Default value: true.
  Future<void> setFillAntialias(bool fillAntialias) =>
      impl.setFillAntialias(fillAntialias);

  /// Whether or not the fill should be antialiased. Default value: true.
  Future<bool?> getFillAntialias() => impl.getFillAntialias();

  /// The color of bridge guard rail. Default value: "rgba(241, 236, 225, 255)".
  @experimental
  Future<void> setFillBridgeGuardRailColor(int fillBridgeGuardRailColor) =>
      impl.setFillBridgeGuardRailColor(fillBridgeGuardRailColor);

  /// The color of bridge guard rail. Default value: "rgba(241, 236, 225, 255)".
  @experimental
  Future<int?> getFillBridgeGuardRailColor() =>
      impl.getFillBridgeGuardRailColor();

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used. Default value: "#000000".
  Future<void> setFillColor(int fillColor) => impl.setFillColor(fillColor);

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used. Default value: "#000000".
  Future<int?> getFillColor() => impl.getFillColor();

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of fillEmissiveStrength is in intensity.
  Future<void> setFillEmissiveStrength(double fillEmissiveStrength) =>
      impl.setFillEmissiveStrength(fillEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of fillEmissiveStrength is in intensity.
  Future<double?> getFillEmissiveStrength() => impl.getFillEmissiveStrength();

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used. Default value: 1. Value range: [0, 1]
  Future<void> setFillOpacity(double fillOpacity) =>
      impl.setFillOpacity(fillOpacity);

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used. Default value: 1. Value range: [0, 1]
  Future<double?> getFillOpacity() => impl.getFillOpacity();

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  Future<void> setFillOutlineColor(int fillOutlineColor) =>
      impl.setFillOutlineColor(fillOutlineColor);

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  Future<int?> getFillOutlineColor() => impl.getFillOutlineColor();

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<void> setFillPattern(String fillPattern) =>
      impl.setFillPattern(fillPattern);

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<String?> getFillPattern() => impl.getFillPattern();

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of fillTranslate is in pixels.
  Future<void> setFillTranslate(List<double?> fillTranslate) =>
      impl.setFillTranslate(fillTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of fillTranslate is in pixels.
  Future<List<double?>?> getFillTranslate() => impl.getFillTranslate();

  /// Controls the frame of reference for `fill-translate`. Default value: "map".
  Future<void> setFillTranslateAnchor(
    FillTranslateAnchor fillTranslateAnchor,
  ) => impl.setFillTranslateAnchor(fillTranslateAnchor);

  /// Controls the frame of reference for `fill-translate`. Default value: "map".
  Future<FillTranslateAnchor?> getFillTranslateAnchor() =>
      impl.getFillTranslateAnchor();

  /// The color of tunnel structures (tunnel entrance and tunnel walls). Default value: "rgba(241, 236, 225, 255)".
  @experimental
  Future<void> setFillTunnelStructureColor(int fillTunnelStructureColor) =>
      impl.setFillTunnelStructureColor(fillTunnelStructureColor);

  /// The color of tunnel structures (tunnel entrance and tunnel walls). Default value: "rgba(241, 236, 225, 255)".
  @experimental
  Future<int?> getFillTunnelStructureColor() =>
      impl.getFillTunnelStructureColor();

  /// Specifies an uniform elevation in meters. Note: If the value is zero, the layer will be rendered on the ground. Non-zero values will elevate the layer from the sea level, which can cause it to be rendered below the terrain. Default value: 0. Minimum value: 0.
  @experimental
  Future<void> setFillZOffset(double fillZOffset) =>
      impl.setFillZOffset(fillZOffset);

  /// Specifies an uniform elevation in meters. Note: If the value is zero, the layer will be rendered on the ground. Non-zero values will elevate the layer from the sea level, which can cause it to be rendered below the terrain. Default value: 0. Minimum value: 0.
  @experimental
  Future<double?> getFillZOffset() => impl.getFillZOffset();
}

// End of generated file.
