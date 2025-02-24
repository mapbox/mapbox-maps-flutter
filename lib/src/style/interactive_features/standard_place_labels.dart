// This file is generated.
part of '../../../mapbox_maps_flutter.dart';

/// Points for labeling places including countries, states, cities, towns, and neighborhoods.
///
/// Use the ``StandardPlaceLabels()`` descriptor to handle interactions on Place Labels features:
///
/// ```dart
/// mapboxMap.addInteraction(TapInteraction(StandardPlaceLabels(), (feature, context) {
///     // Handle the tapped feature here
/// }));
/// ```
extension StandardPlaceLabelsFeature on TypedFeaturesetFeature<StandardPlaceLabels> {
  /// A feature state.
  ///
  /// This is a **snapshot** of the state that the feature had when it was interacted with.
  /// To update and read the original state, use ``MapboxMap/setFeatureState()`` and ``MapboxMap/getFeatureState()``.
  StandardPlaceLabelsState get stateSnapshot {
    return StandardPlaceLabelsState()
      ..hide = state["hide"] as bool?
      ..highlight = state["highlight"] as bool?
      ..select = state["select"] as bool?;
  }

  /// Name of the place label.
  String? get name {
    return properties["name"] as String?;
  }

  /// Provides a broad distinction between place types.
  String? get category {
    return properties["class"] as String?;
  }
}

/// A featureset of StandardPlaceLabels features.
class StandardPlaceLabels extends FeaturesetDescriptor {
  StandardPlaceLabels({String importId = "basemap"})
    : super(featuresetId: "place-labels", importId: importId);
}

/// Represents available states for StandardPlaceLabels features in the Standard style.
class StandardPlaceLabelsState extends FeatureState {
  /// When `true`, hides the label. Use this state when displaying a custom annotation on top.
  bool? hide;

  /// When `true`, the feature is highlighted. Use this state to create a temporary effect (e.g. hover).
  bool? highlight;

  /// When `true`, the feature is selected. Use this state to create a permanent effect. Note: the `select` state has a higher priority than `highlight`.
  bool? select;

  @override
  Map<String, Object?> get map {
    return {
      "hide": hide,
      "highlight": highlight,
      "select": select,
    };
  }

  StandardPlaceLabelsState({this.hide, this.highlight, this.select})
    : super(map: {
      "hide": hide,
      "highlight": highlight,
      "select": select,
    });
}
