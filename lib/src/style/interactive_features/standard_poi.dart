// This file is generated.
part of '../../../mapbox_maps_flutter.dart';

/// A point of interest.
///
/// Use the ``StandardPOIs()`` descriptor to handle interactions on Poi features:
///
/// ```dart
/// mapboxMap.addInteraction(TapInteraction(StandardPOIs(), (feature, context) {
///     // Handle the tapped feature here
/// }));
/// ```
extension StandardPOIsFeature on TypedFeaturesetFeature<StandardPOIs> {
  /// A feature state.
  ///
  /// This is a **snapshot** of the state that the feature had when it was interacted with.
  /// To update and read the original state, use ``MapboxMap/setFeatureState()`` and ``MapboxMap/getFeatureState()``.
  StandardPOIsState get stateSnapshot {
    return StandardPOIsState()
      ..hide = state["hide"] as bool?;
  }

  /// Name of the point of interest.
  String? get name {
    return properties["name"] as String?;
  }

  /// A high-level point of interest category like airport, transit, etc.
  String? get group {
    return properties["group"] as String?;
  }

  /// A broad category of point of interest.
  String? get category {
    return properties["class"] as String?;
  }

  /// An icon identifier, designed to assign icons using the Maki icon project or other icons that follow the same naming scheme.
  String? get maki {
    return properties["maki"] as String?;
  }

  /// Mode of transport served by a stop/station. Expected to be null for non-transit points of interest.
  String? get transitMode {
    return properties["transit_mode"] as String?;
  }

  /// A type of transit stop. Expected to be null for non-transit points of interest.
  String? get transitStopType {
    return properties["transit_stop_type"] as String?;
  }

  /// A rail station network identifier that is part of specific local or regional transit systems. Expected to be null for non-transit points of interest.
  String? get transitNetwork {
    return properties["transit_network"] as String?;
  }

  /// A short identifier code of the airport. Expected to be null for non-airport points of interest
  String? get airportRef {
    return properties["airport_ref"] as String?;
  }

  /// The coordinate of the Point of Interest.
  Point? get coordinate {
    return this.geometry["coordinates"] as Point?;
  }
}

/// A featureset of StandardPOIs features.
class StandardPOIs extends FeaturesetDescriptor {
  StandardPOIs({String importId = "basemap"})
    : super(featuresetId: "poi", importId: importId);
}

/// Represents available states for StandardPOIs features in the Standard style.
class StandardPOIsState extends FeatureState {
  /// When `true`, hides the icon and text. Use this state when displaying a custom annotation on top.
  bool? hide;

  @override
  Map<String, Object?> get map {
    return {
      "hide": hide,
    };
  }

  StandardPOIsState({this.hide})
    : super(map: {
      "hide": hide,
    });
}
