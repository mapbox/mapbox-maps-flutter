part of mapbox_maps_flutter;

final class DefaultViewportTransition extends ViewportTransition {
  final Duration maxDuration;

  const DefaultViewportTransition({
    this.maxDuration = const Duration(seconds: 3, milliseconds: 500),
  }) : super();
}
