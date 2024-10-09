part of mapbox_maps_flutter;

class DefaultViewportTransitionOptions {
  final Duration maxDuration;

  const DefaultViewportTransitionOptions({
    this.maxDuration = const Duration(seconds: 3, milliseconds: 500),
  });
}

class DefaultViewportTransition implements ViewportTransition {
  final DefaultViewportTransitionOptions options;

  DefaultViewportTransition._(this.options);

  @override
  Cancelable run(ViewportState toState, Function(bool success) completion) {
    throw UnimplementedError();
  }
}
