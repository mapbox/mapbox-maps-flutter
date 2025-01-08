part of mapbox_maps_flutter;

// A single tap interaction.
class TapInteraction extends Interaction {
  TapInteraction(FeaturesetDescriptor featuresetDescriptor,
      {String? filter, double? radius, bool stopPropagation = true})
      : super(
            featuresetDescriptor: featuresetDescriptor,
            interactionType: InteractionType.TAP,
            filter: filter,
            radius: radius,
            stopPropagation: stopPropagation);
}

// A long tap interaction
class LongTapInteraction extends Interaction {
  LongTapInteraction(FeaturesetDescriptor featuresetDescriptor,
      {String? filter, double? radius, bool stopPropagation = true})
      : super(
            featuresetDescriptor: featuresetDescriptor,
            interactionType: InteractionType.LONG_TAP,
            filter: filter,
            radius: radius,
            stopPropagation: stopPropagation);
}

extension Featureset on FeaturesetDescriptor {
  // A Featureset of buildings in the Standard style
  static FeaturesetDescriptor standardBuildings({String importId = "basemap"}) {
    return FeaturesetDescriptor(featuresetId: "buildings", importId: importId);
  }

  // A Featureset of place labels in the Standard style
  static FeaturesetDescriptor standardPlaceLabels(
      {String importId = "basemap"}) {
    return FeaturesetDescriptor(
        featuresetId: "place-labels", importId: importId);
  }

  // A Featureset of POIs in the Standard style
  static FeaturesetDescriptor standardPoi({String importId = "basemap"}) {
    return FeaturesetDescriptor(featuresetId: "poi", importId: importId);
  }
}
