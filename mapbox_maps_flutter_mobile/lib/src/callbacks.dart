part of mapbox_maps_flutter_mobile;

// General interaction callback called used to communicate across platforms
typedef void OnInteraction<T extends FeaturesetFeature>(
  T? feature,
  MapContentGestureContext context,
);

// Interaction callback for a specific featureset which returns a non-optional FeaturesetFeature.
typedef void OnInteractionFeatureContext<T extends FeaturesetFeature>(
  T feature,
  MapContentGestureContext context,
);

// Interaction callback that just returns the MapContentGestureContext.
typedef void OnInteractionContext(MapContentGestureContext context);
