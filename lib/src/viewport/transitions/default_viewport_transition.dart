part of mapbox_maps_flutter;

class DefaultViewportTransitionOptions {
  final Duration maxDuration;

  const DefaultViewportTransitionOptions({
    this.maxDuration = const Duration(seconds: 3, milliseconds: 500),
  });
}

class DefaultViewportTransition implements ViewportTransition { }

extension on _DefaultViewportTransitionOptions {
  DefaultViewportTransitionOptions get _options {
    return DefaultViewportTransitionOptions(
      maxDuration: Duration(milliseconds: maxDurationMs),
    );
  }
}

extension on DefaultViewportTransitionOptions {
  _DefaultViewportTransitionOptions get _internalOptions {
    return _DefaultViewportTransitionOptions(
      maxDurationMs: maxDuration.inMilliseconds,
    );
  }
}
