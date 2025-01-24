part of '../../../mapbox_maps_flutter.dart';

/// A single tap interaction.
final class TapInteraction<T extends FeaturesetFeature>
    extends TypedInteraction<T> {
  TapInteraction(
      FeaturesetDescriptor featuresetDescriptor, OnInteraction<T> action,
      {super.filter, super.radius, super.stopPropagation = true})
      : super(
            featuresetDescriptor: featuresetDescriptor,
            interactionType: "TAP",
            action: action);
}

/// A long tap interaction
final class LongTapInteraction<T extends FeaturesetFeature>
    extends TypedInteraction<T> {
  LongTapInteraction(
      FeaturesetDescriptor featuresetDescriptor, OnInteraction<T> action,
      {super.filter, super.radius, super.stopPropagation = true})
      : super(
            featuresetDescriptor: featuresetDescriptor,
            interactionType: "LONG_TAP",
            action: action);
}

/// A typed interaction with an action
final class TypedInteraction<T extends FeaturesetFeature> extends _Interaction {
  TypedInteraction(
      {required super.featuresetDescriptor,
      super.filter,
      super.radius,
      super.stopPropagation = true,
      required this.action,
      required interactionType})
      : super(interactionType: _InteractionType.values.byName(interactionType));

  OnInteraction<T> action;
}
