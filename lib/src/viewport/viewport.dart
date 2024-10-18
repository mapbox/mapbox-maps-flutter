// ignore_for_file: empty_catches

part of mapbox_maps_flutter;

sealed class ViewportTransition {}

sealed class ViewportStatus {}

typedef TransitionCompletion = Function(bool success);

class ViewportManager {
  final _ViewportManagerMessenger _messenger;

  ViewportManager._(
    this._messenger,
  );

  Future<ViewportOptions> getOptions() => _messenger.getOptions();
  Future<void> setOptions(ViewportOptions options) =>
      _messenger.setOptions(options);

  Future<ViewportStatus> getViewportStatus() async {
    throw UnimplementedError();
  }

  Future<ViewportTransition> getDefaultTransition() async {
    throw UnimplementedError();
  }

  Future<void> setDefaultTransition(ViewportTransition transition) async {
    throw UnimplementedError();
  }

  Future<void> addViewportStatusObserver(ViewportStatusObserver observer) {
    throw UnimplementedError();
  }

  Future<void> removeViewportStatusObserver(ViewportStatusObserver observer) {
    throw UnimplementedError();
  }

  Future<bool> transition(ViewportState toState,
      {ViewportTransition? transition, TransitionCompletion? completion}) {
    return _messenger.transition(toState._toStorage(), 0);
    // return _messenger.transition(
    //     stateIdentifier, transitionIdentifier, completionIdentifier);
  }
}
