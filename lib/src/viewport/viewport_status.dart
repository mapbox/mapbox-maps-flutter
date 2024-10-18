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
  final _ViewportStatusChangeReason _reason;

  const ViewportStatusChangeReason._(this._reason);

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

class ViewportStatusIdle extends ViewportStatus {}

class ViewportStatusState extends ViewportStatus {
  final ViewportState state;
  ViewportStatusState(this.state);
}

class ViewportStatusTransition extends ViewportStatus {
  final ViewportTransition transition;
  ViewportStatusTransition(this.transition);
}
