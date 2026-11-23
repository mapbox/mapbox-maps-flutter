// This file is generated.
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Featureset describing the buildings.
///
/// Use the ``StandardBuildings()`` descriptor to handle interactions on Buildings features:
///
/// ```dart
/// mapboxMap.addInteraction(TapInteraction(StandardBuildings(), (feature, context) {
///     // Handle the tapped feature here
/// }));
/// ```
extension StandardBuildingsFeature
    on TypedFeaturesetFeature<StandardBuildings> {
  /// A feature state.
  ///
  /// This is a **snapshot** of the state that the feature had when it was interacted with.
  /// To update and read the original state, use ``MapboxMap/setFeatureState()`` and ``MapboxMap/getFeatureState()``.
  StandardBuildingsState get stateSnapshot {
    return StandardBuildingsState()
      ..highlight = state["highlight"] as bool?
      ..select = state["select"] as bool?;
  }

  /// A high-level building group like building-2d, building-3d, etc.
  String? get group {
    return properties["group"] as String?;
  }
}

/// A featureset of StandardBuildings features.
class StandardBuildings extends FeaturesetDescriptor {
  StandardBuildings({String importId = "basemap"})
    : super(featuresetId: "buildings", importId: importId);

  static StandardBuildings decode(Object result) {
    result as List<Object?>;
    return StandardBuildings(importId: result[1] as String? ?? 'basemap');
  }
}

/// Represents available states for StandardBuildings features in the Standard style.
class StandardBuildingsState extends FeatureState {
  /// When `true`, the building is highlighted. Use this state to create a temporary effect (e.g. hover).
  bool? highlight;

  /// When `true`, the building is selected. Use this state to create a permanent effect. Note: the `select` state has a higher priority than `highlight`.
  bool? select;

  @override
  Map<String, Object?> get map {
    return {"highlight": highlight, "select": select};
  }

  StandardBuildingsState({this.highlight, this.select})
    : super(map: {"highlight": highlight, "select": select});

  static StandardBuildingsState decode(Object result) {
    result as List<Object?>;
    final map = (result[0] as Map<Object?, Object?>?)!.cast<String, Object?>();
    return StandardBuildingsState(
      highlight: map['highlight'] as bool?,
      select: map['select'] as bool?,
    );
  }
}
