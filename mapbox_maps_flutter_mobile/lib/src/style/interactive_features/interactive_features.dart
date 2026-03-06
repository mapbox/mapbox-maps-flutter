part of '../../../mapbox_maps_flutter.dart';

/// A single tap interaction on a Featureset with a typed `FeaturesetDescriptor` or on the map.
final class TapInteraction<T extends FeaturesetDescriptor>
    extends TypedInteraction<TypedFeaturesetFeature<T>> {
  TapInteraction(
      T featuresetDescriptor,
      OnInteractionFeatureContext<TypedFeaturesetFeature<T>>
          actionFeatureContext,
      {super.filter,
      super.radius,
      super.stopPropagation = true})
      : super(
            featuresetDescriptor: featuresetDescriptor,
            interactionType: "TAP",
            action: (feature, context) {
              if (feature != null) {
                actionFeatureContext(feature, context);
              }
            });

  TapInteraction.onMap(OnInteractionContext actionContext,
      {super.stopPropagation = true})
      : super(
            featuresetDescriptor: null,
            interactionType: "TAP",
            action: (feature, context) => actionContext(context));
}

/// A long tap interaction on a Featureset with a typed `FeaturesetDescriptor` or on the map.
final class LongTapInteraction<T extends FeaturesetDescriptor>
    extends TypedInteraction<TypedFeaturesetFeature<T>> {
  LongTapInteraction(
      T featuresetDescriptor,
      OnInteractionFeatureContext<TypedFeaturesetFeature<T>>
          actionFeatureContext,
      {super.filter,
      super.radius,
      super.stopPropagation = true})
      : super(
            featuresetDescriptor: featuresetDescriptor,
            interactionType: "LONG_TAP",
            action: (feature, context) {
              if (feature != null) {
                actionFeatureContext(feature, context);
              }
            });

  LongTapInteraction.onMap(OnInteractionContext actionContext,
      {super.stopPropagation = true})
      : super(
            featuresetDescriptor: null,
            interactionType: "LONG_TAP",
            action: (feature, context) => actionContext(context));
}

/// An `_Interaction` with an action that has a typed `FeaturesetFeature` as input.
final class TypedInteraction<T extends TypedFeaturesetFeature>
    extends _Interaction {
  TypedInteraction(
      {super.featuresetDescriptor,
      super.filter,
      super.radius,
      super.stopPropagation = true,
      required this.action,
      required interactionType})
      : super(interactionType: _InteractionType.values.byName(interactionType));

  OnInteraction<T> action;
}

/// A `FeaturesetFeature` with a typed `FeaturesetDescriptor`. This is used to provide typed access to the specific properties and state of a feature with a known type such as StandardPOIs or StandardBuildings.
class TypedFeaturesetFeature<T extends FeaturesetDescriptor>
    extends FeaturesetFeature {
  TypedFeaturesetFeature(T featureset, Map<String?, Object?> geometry,
      Map<String, Object?> properties, Map<String, Object?> state, {super.id})
      : super(
            featureset: featureset,
            geometry: geometry,
            properties: properties,
            state: state);

  /// Creates a `TypedFeaturesetFeature` from a `FeaturesetFeature`.
  TypedFeaturesetFeature.fromFeaturesetFeature(FeaturesetFeature feature)
      : super(
            id: feature.id,
            featureset: feature.featureset,
            geometry: feature.geometry,
            properties: feature.properties,
            state: feature.state);
}
