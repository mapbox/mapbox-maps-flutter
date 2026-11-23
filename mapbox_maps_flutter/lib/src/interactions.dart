import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// A single tap interaction on a featureset or on the map.
///
/// ```dart
/// mapboxMap.addInteraction(TapInteraction(StandardPOIs(), (feature, context) {
///   // Handle tapped POI
/// }));
/// ```
final class TapInteraction<T extends FeaturesetDescriptor>
    extends TypedInteraction<TypedFeaturesetFeature<T>> {
  TapInteraction(
    T featuresetDescriptor,
    OnInteractionFeatureContext<TypedFeaturesetFeature<T>>
    actionFeatureContext, {
    super.filter,
    super.radius,
    super.stopPropagation = true,
  }) : super(
         featuresetDescriptor: featuresetDescriptor,
         interactionType: InteractionType.tap,
         featureFactory: (f) =>
             TypedFeaturesetFeature<T>.fromFeaturesetFeature(f),
         action: (feature, context) {
           if (feature != null) actionFeatureContext(feature, context);
         },
       );

  TapInteraction.onMap(
    OnInteractionContext actionContext, {
    super.stopPropagation = true,
  }) : super(
         featuresetDescriptor: null,
         interactionType: InteractionType.tap,
         featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
         action: (feature, context) => actionContext(context),
       );

  static TapInteraction<FeaturesetDescriptor> decode(Object result) {
    return TapInteraction<FeaturesetDescriptor>.onMap((_) {});
  }
}

/// A long tap interaction on a featureset or on the map.
///
/// ```dart
/// mapboxMap.addInteraction(LongTapInteraction(StandardBuildings(), (feature, context) {
///   // Handle long-pressed building
/// }));
/// ```
final class LongTapInteraction<T extends FeaturesetDescriptor>
    extends TypedInteraction<TypedFeaturesetFeature<T>> {
  LongTapInteraction(
    T featuresetDescriptor,
    OnInteractionFeatureContext<TypedFeaturesetFeature<T>>
    actionFeatureContext, {
    super.filter,
    super.radius,
    super.stopPropagation = true,
  }) : super(
         featuresetDescriptor: featuresetDescriptor,
         interactionType: InteractionType.longTap,
         featureFactory: (f) =>
             TypedFeaturesetFeature<T>.fromFeaturesetFeature(f),
         action: (feature, context) {
           if (feature != null) actionFeatureContext(feature, context);
         },
       );

  LongTapInteraction.onMap(
    OnInteractionContext actionContext, {
    super.stopPropagation = true,
  }) : super(
         featuresetDescriptor: null,
         interactionType: InteractionType.longTap,
         featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
         action: (feature, context) => actionContext(context),
       );

  static LongTapInteraction<FeaturesetDescriptor> decode(Object result) {
    return LongTapInteraction<FeaturesetDescriptor>.onMap((_) {});
  }
}
