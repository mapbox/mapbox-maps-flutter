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

typedef _ObjectHash = int;
typedef _Identifier = int;
typedef TransitionCompletion = Function(bool success);

class ViewportManager {
  late final Finalizer<int> _overviewViewportStateFinalizer;
  late final Finalizer<int> _followPuckStateFinalizer;
  late final Finalizer<int> _defaultTransitionFinalizer;
  late final Finalizer<int> _immediateTransitionFinalizer;

  final _ViewportManagerMessenger _messenger;
  final Map<_ObjectHash, _Identifier> _viewportStateIdentifiers = {};
  final Map<_ObjectHash, _Identifier> _transitionIdentifiers = {};
  final Map<_ObjectHash, TransitionCompletion> _completions = {};

  ViewportManager._(
    this._messenger,
  ) {
    _overviewViewportStateFinalizer = Finalizer((suffix) {
      try {
        _messenger.teardownOverviewViewportState(suffix);
        _suffixesRegistry.releaseSuffix(suffix);
      } catch (e) {}
    });
    _followPuckStateFinalizer = Finalizer((suffix) {
      try {
        _messenger.teardownFollowPuckViewportState(suffix);
        _suffixesRegistry.releaseSuffix(suffix);
      } catch (e) {}
    });
    _defaultTransitionFinalizer = Finalizer((suffix) {
      try {
        _messenger.teardownDefaultTransition(suffix);
        _suffixesRegistry.releaseSuffix(suffix);
      } catch (e) {}
    });
    _immediateTransitionFinalizer = Finalizer((suffix) {
      try {
        _messenger.teardownImmediateTransition(suffix);
        _suffixesRegistry.releaseSuffix(suffix);
      } catch (e) {}
    });
  }

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

  Future<void> idle() {
    throw UnimplementedError();
  }

  Future<void> transition(ViewportState toState,
      {ViewportTransition? transition, TransitionCompletion? completion}) {
    final stateIdentifier =
        _viewportStateIdentifiers[identityHashCode(toState)];
    if (stateIdentifier == null) {
      throw ArgumentError(
          'The given viewport state is not managed by this viewport manager.');
    }
    final _Identifier? transitionIdentifier;
    if (transition != null) {
      transitionIdentifier =
          _transitionIdentifiers[identityHashCode(transition)];
      if (transitionIdentifier == null) {
        throw ArgumentError(
            'The given viewport transition is not managed by this viewport manager.');
      }
    } else {
      transitionIdentifier = null;
    }

    final _Identifier? completionIdentifier;
    if (completion != null) {
      completionIdentifier = identityHashCode(completion);
      _completions[completionIdentifier] = completion;
    } else {
      completionIdentifier = null;
    }

    return _messenger.transition(
        stateIdentifier, transitionIdentifier, completionIdentifier);
  }

  Future<OverviewViewportState> makeOverviewViewportState(
      {required OverviewViewportStateOptions options}) async {
    final suffix = _suffixesRegistry.getSuffix();
    await _messenger.setupOverviewViewportState(
        options._internalOptions, suffix);
    final state = OverviewViewportState._(
        _OverviewViewportMessenger(messageChannelSuffix: suffix.toString()));

    _viewportStateIdentifiers[identityHashCode(state)] = suffix;
    _overviewViewportStateFinalizer.attach(state, suffix, detach: state);
    return state;
  }

  Future<FollowPuckViewportState> makeFollowPuckViewportState(
      {FollowPuckViewportStateOptions? options}) async {
    final resolvedOptions = options ?? FollowPuckViewportStateOptions();
    final suffix = _suffixesRegistry.getSuffix();
    await _messenger.setupFollowPuckViewportState(
        resolvedOptions._internalOptions, suffix);
    final state = FollowPuckViewportState._(
        _FollowPuckViewportMessenger(messageChannelSuffix: suffix.toString()));

    _viewportStateIdentifiers[identityHashCode(state)] = suffix;
    _followPuckStateFinalizer.attach(state, suffix, detach: state);
    return state;
  }

  Future<DefaultViewportTransition> makeDefaultViewportTransition(
      {DefaultViewportTransitionOptions options =
          const DefaultViewportTransitionOptions()}) async {
    final suffix = _suffixesRegistry.getSuffix();
    await _messenger.setupDefaultTransition(options._internalOptions, suffix);
    final transition = DefaultViewportTransition._(
        _DefaultViewportTransitionMessenger(messageChannelSuffix: suffix.toString()));

    _transitionIdentifiers[identityHashCode(transition)] = suffix;
    _defaultTransitionFinalizer.attach(transition, suffix, detach: transition);
    return transition;
  }

  Future<ImmediateViewportTransition> makeImmediateViewportTransition() async {
    final suffix = _suffixesRegistry.getSuffix();
    await _messenger.setupImmediateTransition(suffix);
    final transition = ImmediateViewportTransition._();

    _transitionIdentifiers[identityHashCode(transition)] = suffix;
    _immediateTransitionFinalizer.attach(transition, suffix, detach: transition);
    return transition;
  }
}
