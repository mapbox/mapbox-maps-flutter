import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:web/web.dart' show GeolocationCoordinates;

import '../bindings/map_bindings.dart';
import 'camera_handler.dart';
import 'follow_puck_handler.dart';
import 'overview_handler.dart';
import 'style_default_handler.dart';
import 'viewport_handler.dart';

/// Orchestrates viewport state changes on the web platform.
///
/// Manages pending/queued viewports before the map is ready, deduplication,
/// and cancellation of in-flight async viewports when a new one is applied.
///
/// Also observes user-driven map gestures (pan/zoom/rotate/pitch) for the
/// active viewport and transitions to [IdleViewportState], matching the
/// `transitionsToIdleUponUserInteraction == true` default on iOS/Android.
class ViewportWeb {
  JSMap? _nativeMap;

  // Pending viewport to apply once the map is created.
  ViewportState? _pendingViewport;
  ViewportTransition? _pendingTransition;
  void Function(bool)? _pendingCompletion;

  // Last applied viewport for deduplication.
  ViewportState? _lastViewport;

  // The handler currently driving the camera. Cancelled on transition.
  WebViewportStateHandler? _activeHandler;

  /// Provider for the location-position stream — set by the host widget
  /// after [LocationController] is constructed. `FollowPuckViewportState`
  /// requires this to be set or it falls back to a no-op handler.
  Stream<GeolocationCoordinates> Function()? positionStreamProvider;

  // Generation counter — incremented on each new viewport or reset.
  // In-flight async handlers, queued completions, and stale gesture
  // listeners check this to discard stale work.
  int _generation = 0;

  /// Resets all state, releasing the reference to the native map.
  void reset() {
    _cancelActiveViewport();
    _nativeMap = null;
    _pendingViewport = null;
    _pendingTransition = null;
    _pendingCompletion = null;
    _lastViewport = null;
  }

  /// Called when the native map instance is ready.
  void onMapCreated(JSMap nativeMap) {
    _nativeMap = nativeMap;
    _flushPendingViewport();
  }

  /// Applies a viewport change, queuing it if the map isn't ready yet.
  /// Returns true if the viewport was new and will be applied.
  bool applyIfChanged(
    ViewportState viewport,
    ViewportTransition? transition,
    void Function(bool)? completion,
  ) {
    if (viewport == _lastViewport) return false;
    _lastViewport = viewport;

    if (_nativeMap == null) {
      _pendingViewport = viewport;
      _pendingTransition = transition;
      _pendingCompletion = completion;
      return true;
    }
    _applyToMap(_nativeMap!, viewport, transition, completion);
    return true;
  }

  void _flushPendingViewport() {
    final viewport = _pendingViewport;
    if (viewport == null) return;
    final transition = _pendingTransition;
    final completion = _pendingCompletion;
    _pendingViewport = null;
    _pendingTransition = null;
    _pendingCompletion = null;
    _applyToMap(_nativeMap!, viewport, transition, completion);
  }

  void _applyToMap(
    JSMap map,
    ViewportState viewport,
    ViewportTransition? transition,
    void Function(bool)? completion,
  ) {
    _cancelActiveViewport();
    // Bumping [_generation] is what makes the previous handler's
    // `.then(...)` skip its completion call here — the controller has
    // already fired it with `false`. Also scopes the new gesture
    // listener so older ones self-remove on their next fire.
    final gen = ++_generation;

    final handler = _handlerFor(viewport);
    if (handler == null) {
      if (viewport is IdleViewportState) map.stop();
      completion?.call(viewport is IdleViewportState);
      return;
    }

    _activeHandler = handler;
    _attachGestureListener(map, gen);
    handler.apply(map, transition).then((result) {
      if (gen == _generation) {
        completion?.call(result);
      }
    });
  }

  WebViewportStateHandler? _handlerFor(ViewportState viewport) {
    return switch (viewport) {
      CameraViewportState() => CameraHandler(viewport),
      OverviewViewportState() => OverviewHandler(viewport),
      StyleDefaultViewportState() => StyleDefaultHandler(),
      IdleViewportState() => null,
      FollowPuckViewportState() =>
        positionStreamProvider == null
            ? null
            : FollowPuckHandler(viewport, positionStreamProvider!()),
    };
  }

  /// Attaches a `movestart` listener scoped to [gen]. The listener
  /// self-removes when it sees either a user gesture (cancelling the
  /// viewport) or a stale generation (a newer viewport replaced its
  /// handler).
  void _attachGestureListener(JSMap map, int gen) {
    late final JSFunction listener;
    listener = ((JSMapMoveEvent event) {
      // A newer viewport replaced this one — drop the stale listener.
      if (gen != _generation) {
        map.off('movestart', listener);
        return;
      }
      // Programmatic moves (handler-driven flyTo/easeTo/jumpTo) leave
      // originalEvent null; resize-induced moves are not gestures.
      final origin = event.originalEvent;
      if (origin == null || origin.type == 'resize') return;

      map.off('movestart', listener);

      _cancelActiveViewport();
      _lastViewport = const IdleViewportState();
    }).toJS;
    map.on('movestart', listener);
  }

  /// Shuts down the active handler. Whether the previous transition's
  /// `.then(...)` should fire its completion depends on the caller —
  /// `_applyToMap` bumps [_generation] afterwards to suppress it, the
  /// user-gesture and `reset()` paths don't.
  void _cancelActiveViewport() {
    _activeHandler?.cancel();
    _activeHandler = null;
  }
}
