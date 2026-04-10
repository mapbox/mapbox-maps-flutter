import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import '../bindings/map_bindings.dart';
import 'camera_handler.dart';
import 'overview_handler.dart';
import 'style_default_handler.dart';
import 'viewport_handler.dart';

/// Orchestrates viewport state changes on the web platform.
///
/// Manages pending/queued viewports before the map is ready, deduplication,
/// and cancellation of in-flight async viewports when a new one is applied.
class ViewportWeb {
  JSMap? _nativeMap;

  // Pending viewport to apply once the map is created.
  ViewportState? _pendingViewport;
  ViewportTransition? _pendingTransition;
  void Function(bool)? _pendingCompletion;

  // Last applied viewport for deduplication.
  ViewportState? _lastViewport;

  // Generation counter — incremented on each new viewport or reset.
  // In-flight async handlers check this to discard stale completions.
  int _generation = 0;

  /// Resets all state, releasing the reference to the native map.
  void reset() {
    _generation++;
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
    final gen = ++_generation;

    final handler = _handlerFor(viewport);
    if (handler == null) {
      if (viewport is IdleViewportState) map.stop();
      completion?.call(viewport is IdleViewportState);
      return;
    }

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
      FollowPuckViewportState() => null,
    };
  }
}
