part of mapbox_maps_flutter;

class DefaultViewportTransitionOptions {
  final Duration maxDuration;

  const DefaultViewportTransitionOptions({
    this.maxDuration = const Duration(seconds: 3, milliseconds: 500),
  });
}

class DefaultViewportTransition implements ViewportTransition {
  final _DefaultViewportTransitionMessenger _messenger;

  DefaultViewportTransition._(this._messenger);

  Future<DefaultViewportTransitionOptions> getOptions() async {
    return _messenger.getInternalOptions().then((value) => value._options);
  }

  Future<void> setOptions(DefaultViewportTransitionOptions options) {
    return _messenger.setInternalOptions(options._internalOptions);
  }

  @override
  Cancelable run(ViewportState toState, Function(bool success) completion) {
    return Cancelable();
  }
}

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
