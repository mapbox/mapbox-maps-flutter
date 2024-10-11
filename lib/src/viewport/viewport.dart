part of mapbox_maps_flutter;

enum _ViewportStatusChangeReason {
  idleRequested,
  transitionStarted,
  transitionSucceeded,
  transitionFailed,
  userInteraction,
}

abstract interface class ViewportStatusObserver {
  void onViewportStatusChanged(ViewportStatus from, ViewportStatus to,
      ViewportStatusChangeReason reason);
}

class ViewportStatusChangeReason {
  final _ViewportStatusChangeReason reason;

  const ViewportStatusChangeReason._(this.reason);

  static const ViewportStatusChangeReason idleRequested =
      ViewportStatusChangeReason._(_ViewportStatusChangeReason.idleRequested);
  static const ViewportStatusChangeReason transitionStarted =
      ViewportStatusChangeReason._(
          _ViewportStatusChangeReason.transitionStarted);
  static const ViewportStatusChangeReason transitionSucceeded =
      ViewportStatusChangeReason._(
          _ViewportStatusChangeReason.transitionSucceeded);
  static const ViewportStatusChangeReason transitionFailed =
      ViewportStatusChangeReason._(
          _ViewportStatusChangeReason.transitionFailed);
  static const ViewportStatusChangeReason userInteraction =
      ViewportStatusChangeReason._(_ViewportStatusChangeReason.userInteraction);
}

abstract interface class ViewportTransition {
  Cancelable run(ViewportState toState, Function(bool success) completion);
}

typedef bool OnViewportCameraChange();

abstract interface class ViewportState {
  Cancelable observeDataSource(OnViewportCameraChange cameraChangeHandler);
  void startUpdatingCamera();
  void stopUpdatingCamera();
}

sealed class ViewportStatus {}

class ViewportStatusIdle extends ViewportStatus {}

class ViewportStatusState extends ViewportStatus {
  final ViewportState state;
  ViewportStatusState(this.state);
}

class ViewportStatusTransition extends ViewportStatus {
  final ViewportTransition transition;
  ViewportStatusTransition(this.transition);
}

class ViewportManager {
  _ViewportManager _viewportManager;

  ViewportManager(this._viewportManager);

  Future<ViewportOptions> getOptions() => _viewportManager.getOptions();
  Future<void> setOptions(ViewportOptions options) =>
      _viewportManager.setOptions(options);

  Future<ViewportStatus> getViewportStatus() async {
    throw UnimplementedError();
  }

  Future<ViewportTransition> getDefaultTransition() async {
    throw UnimplementedError();
  }

  Future<void> setDefaultTransition(ViewportTransition transition) async {
    throw UnimplementedError();
  }

  void addViewportStatusObserver(ViewportStatusObserver observer) {
    throw UnimplementedError();
  }

  void removeViewportStatusObserver(ViewportStatusObserver observer) {
    throw UnimplementedError();
  }

  void idle() {
    throw UnimplementedError();
  }

  void transition(ViewportState toState,
      {ViewportTransition? transition, Function(bool success)? completion}) {
    throw UnimplementedError();
  }

  Future<OverviewViewportState> makeOverviewViewportState(
      OverviewViewportStateOptions options) async {
    throw UnimplementedError();
  }

  Future<FollowPuckViewportState> makeFollowPuckViewportState(
      {FollowPuckViewportStateOptions options =
          const FollowPuckViewportStateOptions()}) async {
    throw UnimplementedError();
  }

  Future<DefaultViewportTransition> makeDefaultViewportTransition(
      {DefaultViewportTransitionOptions options =
          const DefaultViewportTransitionOptions()}) async {
    throw UnimplementedError();
  }

  Future<ImmediateViewportTransition> makeImmediateViewportTransition() async {
    throw UnimplementedError();
  }
}
