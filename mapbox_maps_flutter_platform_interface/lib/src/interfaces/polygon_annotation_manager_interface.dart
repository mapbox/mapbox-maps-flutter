// This file is generated.
import 'package:meta/meta.dart';

import '../pigeons/annotation_data_types.dart';
import '../pigeons/platform_interface_data_types.dart';
import 'annotations_interface.dart';

/// Abstract interface for managing polygon annotations.
abstract interface class PolygonAnnotationManagerPlatformInterface
    implements BaseAnnotationManagerPlatformInterface {
  /// Broadcast stream of raw tap interaction contexts. The facade's
  /// `tapEvents` subscribes to this stream, projects the payload to
  /// the annotation type, and wraps the subscription in a `Cancelable`.
  Stream<PolygonAnnotationInteractionContext> get tapInteractionStream;

  /// Broadcast stream of raw long-press interaction contexts.
  Stream<PolygonAnnotationInteractionContext> get longPressInteractionStream;

  /// Broadcast stream of raw drag interaction contexts. The facade's
  /// `dragEvents` filters by `gestureState` to dispatch begin/changed/end.
  Stream<PolygonAnnotationInteractionContext> get dragInteractionStream;

  /// Get all annotations of manager.
  Future<List<PolygonAnnotation>> getAnnotations();

  /// Create a new annotation with the option.
  Future<PolygonAnnotation> create(PolygonAnnotationOptions annotation);

  /// Create multi annotations with the options.
  Future<List<PolygonAnnotation?>> createMulti(
    List<PolygonAnnotationOptions> annotations,
  );

  /// Update an added annotation with new properties.
  Future<void> update(PolygonAnnotation annotation);

  /// Delete an added annotation.
  Future<void> delete(PolygonAnnotation annotation);

  /// Delete all the annotation added by this manager.
  Future<void> deleteAll();

  /// Delete multiple annotations added by this manager.
  Future<void> deleteMulti(List<PolygonAnnotation> annotations);

  /// Determines whether bridge guard rails are added for elevated roads. Default value: "true".
  @experimental
  Future<void> setFillConstructBridgeGuardRail(
    bool fillConstructBridgeGuardRail,
  );

  /// Determines whether bridge guard rails are added for elevated roads. Default value: "true".
  @experimental
  Future<bool?> getFillConstructBridgeGuardRail();

  /// Selects the base of fill-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  @experimental
  Future<void> setFillElevationReference(
    FillElevationReference fillElevationReference,
  );

  /// Selects the base of fill-elevation. Some modes might require precomputed elevation data in the tileset. Default value: "none".
  @experimental
  Future<FillElevationReference?> getFillElevationReference();

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<void> setFillSortKey(double fillSortKey);

  /// Sorts features in ascending order based on this value. Features with a higher sort key will appear above features with a lower sort key.
  Future<double?> getFillSortKey();

  /// Whether or not the fill should be antialiased. Default value: true.
  Future<void> setFillAntialias(bool fillAntialias);

  /// Whether or not the fill should be antialiased. Default value: true.
  Future<bool?> getFillAntialias();

  /// The color of bridge guard rail. Default value: "rgba(241, 236, 225, 255)".
  @experimental
  Future<void> setFillBridgeGuardRailColor(int fillBridgeGuardRailColor);

  /// The color of bridge guard rail. Default value: "rgba(241, 236, 225, 255)".
  @experimental
  Future<int?> getFillBridgeGuardRailColor();

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used. Default value: "#000000".
  Future<void> setFillColor(int fillColor);

  /// The color of the filled part of this layer. This color can be specified as `rgba` with an alpha component and the color's opacity will not affect the opacity of the 1px stroke, if it is used. Default value: "#000000".
  Future<int?> getFillColor();

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of fillEmissiveStrength is in intensity.
  Future<void> setFillEmissiveStrength(double fillEmissiveStrength);

  /// Controls the intensity of light emitted on the source features. Default value: 0. Minimum value: 0. The unit of fillEmissiveStrength is in intensity.
  Future<double?> getFillEmissiveStrength();

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used. Default value: 1. Value range: [0, 1]
  Future<void> setFillOpacity(double fillOpacity);

  /// The opacity of the entire fill layer. In contrast to the `fill-color`, this value will also affect the 1px stroke around the fill, if the stroke is used. Default value: 1. Value range: [0, 1]
  Future<double?> getFillOpacity();

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  Future<void> setFillOutlineColor(int fillOutlineColor);

  /// The outline color of the fill. Matches the value of `fill-color` if unspecified.
  Future<int?> getFillOutlineColor();

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<void> setFillPattern(String fillPattern);

  /// Name of image in sprite to use for drawing image fills. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  Future<String?> getFillPattern();

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of fillTranslate is in pixels.
  Future<void> setFillTranslate(List<double?> fillTranslate);

  /// The geometry's offset. Values are [x, y] where negatives indicate left and up, respectively. Default value: [0,0]. The unit of fillTranslate is in pixels.
  Future<List<double?>?> getFillTranslate();

  /// Controls the frame of reference for `fill-translate`. Default value: "map".
  Future<void> setFillTranslateAnchor(FillTranslateAnchor fillTranslateAnchor);

  /// Controls the frame of reference for `fill-translate`. Default value: "map".
  Future<FillTranslateAnchor?> getFillTranslateAnchor();

  /// The color of tunnel structures (tunnel entrance and tunnel walls). Default value: "rgba(241, 236, 225, 255)".
  @experimental
  Future<void> setFillTunnelStructureColor(int fillTunnelStructureColor);

  /// The color of tunnel structures (tunnel entrance and tunnel walls). Default value: "rgba(241, 236, 225, 255)".
  @experimental
  Future<int?> getFillTunnelStructureColor();

  /// Specifies an uniform elevation in meters. Note: If the value is zero, the layer will be rendered on the ground. Non-zero values will elevate the layer from the sea level, which can cause it to be rendered below the terrain. Default value: 0. Minimum value: 0.
  @experimental
  Future<void> setFillZOffset(double fillZOffset);

  /// Specifies an uniform elevation in meters. Note: If the value is zero, the layer will be rendered on the ground. Non-zero values will elevate the layer from the sea level, which can cause it to be rendered below the terrain. Default value: 0. Minimum value: 0.
  @experimental
  Future<double?> getFillZOffset();
}

// End of generated file.
