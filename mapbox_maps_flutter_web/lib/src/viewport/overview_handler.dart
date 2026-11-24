import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import 'viewport_handler.dart';
import 'viewport_utils.dart';

import '../bindings/binding_adapters.dart';
import '../bindings/map_bindings.dart';

final class OverviewHandler extends WebViewportStateHandler {
  final OverviewViewportState state;
  OverviewHandler(this.state);

  @override
  Future<void> runApply(JSMap map, ViewportTransition? transition) async {
    final bounds = geometryToBounds(state.geometry);
    if (bounds == null) return;

    // Only assign non-null fields: GL JS reads e.g. `offset.x` eagerly and
    // throws on a null, which would abort the whole fitBounds call.
    final fitOpts = JSFitBoundsOptions(essential: true)
      ..padding = state.geometryPadding.toJSPadding();
    if (state.bearing != null) fitOpts.bearing = state.bearing!;
    if (state.pitch != null) fitOpts.pitch = state.pitch!;
    if (state.offset != null) fitOpts.offset = state.offset!.toJSScreenPoint();
    if (state.maxZoom != null) fitOpts.maxZoom = state.maxZoom!;

    final durationMs = switch (transition) {
      EasingViewportTransition(:final duration) => duration.inMilliseconds,
      DefaultViewportTransition(:final maxDuration) => _defaultDuration(
        map,
        bounds,
        maxDuration,
      ).inMilliseconds,
      FlyViewportTransition(:final duration) =>
        (duration ?? state.animationDuration).inMilliseconds,
      // `animationDuration` applies only to later geometry updates, so
      // entering the state without a transition jumps to the target.
      ImmediateViewportTransition() || null => 0,
    };
    fitOpts.duration = durationMs;
    switch (transition) {
      case EasingViewportTransition(:final curve):
        // `linear` makes GL JS ease instead of fly; `easing` sets the curve.
        fitOpts
          ..linear = true
          ..easing = ((double t) => curve.transform(t)).toJS;
      case DefaultViewportTransition():
        fitOpts.linear = true;
      case FlyViewportTransition() || ImmediateViewportTransition() || null:
        break;
    }

    map.fitBounds(bounds, fitOpts);
    await moveEnded(map);
  }

  /// Returns the duration from the current camera to the camera that fits
  /// [bounds]. Returns [maxDuration] when GL JS cannot compute that camera.
  Duration _defaultDuration(JSMap map, JSAny bounds, Duration maxDuration) {
    final options = JSCameraForBoundsOptions(
      padding: state.geometryPadding.toJSPadding(),
    );
    if (state.bearing != null) options.bearing = state.bearing!;
    if (state.pitch != null) options.pitch = state.pitch!;
    if (state.offset != null) options.offset = state.offset!.toJSScreenPoint();
    if (state.maxZoom != null) options.maxZoom = state.maxZoom!;
    final target = map.cameraForBounds(bounds as JSLngLatBounds, options);
    if (target == null) return maxDuration;
    return defaultTransitionDurationTo(
      map,
      center: target.center,
      zoom: target.zoom,
      hasBearing: state.bearing != null,
      hasPitch: state.pitch != null,
      hasPadding: true,
      maxDuration: maxDuration,
    );
  }
}
