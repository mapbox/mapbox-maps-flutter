part of mapbox_maps_flutter;

// A feature that is a point of interest in the Standard style.
class StandardPoiFeature extends FeaturesetFeature {
  // A feature state.
  //
  // This is a **snapshot** of the state that the feature had when it was interacted with.
  // To update and read the original state, use ``MapboxMap/setFeatureState()`` and ``MapboxMap/getFeatureState()``.
  StandardPoiState get stateSnapshot {
    return StandardPoiState()..hide = state["hide"] as bool?;
  }

  // Name of the point of interest.
  String? get name {
    return properties["name"] as String?;
  }

  // A high-level point of interest category like airport, transit, etc.
  String? get group {
    return properties["group"] as String?;
  }

  // A broad category of point of interest.
  String? get category {
    return properties["class"] as String?;
  }

  // An icon identifier, designed to assign icons using the Maki icon project or other icons that follow the same naming scheme.
  String? get maki {
    return properties["maki"] as String?;
  }

  // Mode of transport served by a stop/station. Expected to be null for non-transit points of interest.
  String? get transitMode {
    return properties["transit_mode"] as String?;
  }

  // A type of transit stop. Expected to be null for non-transit points of interest.
  String? get transitStopType {
    return properties["transit_stop_type"] as String?;
  }

  // A rail station network identifier that is part of specific local or regional transit systems. Expected to be null for non-transit points of interest.
  String? get transitNetwork {
    return properties["transit_network"] as String?;
  }

  // A short identifier code of the airport. Expected to be null for non-airport points of interest
  String? get airportRef {
    return properties["airport_ref"] as String?;
  }

  // POI coordinate.
  Point? get coordinate {
    return this.geometry["coordinates"] as Point?;
  }

  StandardPoiFeature(Map<String?, Object?> geometry,
      Map<String, Object?> properties, Map<String, Object?> state,
      {FeaturesetFeatureId? id})
      : super(
            id: id,
            featureset: Featureset.standardPoi(),
            geometry: geometry,
            properties: properties,
            state: state);
}

// Represents available states for POIs in the Standard style.
class StandardPoiState extends FeatureState {
  // When `true`, hides the icon and text. 
  bool? hide;
  
  @override
  Map<String, Object?> get map {
    return {
      "hide": hide
    };
  }

  StandardPoiState({this.hide})
      : super(map: {
          "hide": hide,
        });
}
