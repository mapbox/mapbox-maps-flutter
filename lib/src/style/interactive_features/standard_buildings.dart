part of mapbox_maps_flutter;

// A Feature that represents a building in the Standard style.
class StandardBuildingsFeature extends FeaturesetFeature {
  // A feature state.
  //
  // This is a **snapshot** of the state that the feature had when it was interacted with.
  // To update and read the original state, use ``MapboxMap/setFeatureState()`` and ``MapboxMap/getFeatureState()``.
  StandardBuildingState get stateSnapshot {
    return StandardBuildingState()
      ..highlight = state["highlight"] as bool?
      ..select = state["select"] as bool?;
  }

  // A high-level building group like building-2d, building-3d, etc.
  String? get group {
    return properties["group"] as String?;
  }

  StandardBuildingsFeature(Map<String?, Object?> geometry,
      Map<String, Object?> properties, Map<String, Object?> state,
      {FeaturesetFeatureId? id})
      : super(
            id: id,
            featureset: Featureset.standardBuildings(),
            geometry: geometry,
            properties: properties,
            state: state);
}

// Represents available states for Buildings in the Standard style.
class StandardBuildingState extends FeatureState {
  // When `true`, the feature is highlighted. Use this state to create a temporary effect (e.g. hover).
  bool? highlight;

  // When `true`, the feature is selected. Use this state to create a permanent effect. Note: the `select` state has a higher priority than `highlight`.
  bool? select;

  @override
  Map<String, Object?> get map {
    return {
      "highlight": highlight,
      "select": select,
    };
  }

  StandardBuildingState({this.highlight, this.select})
      : super(map: {
          "highlight": highlight,
          "select": select,
        });
}
