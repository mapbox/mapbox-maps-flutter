import 'dart:js_interop';

import 'package:flutter/animation.dart';
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

    final duration =
        transitionDurationMs(transition) ??
        state.animationDuration.inMilliseconds;

    // Only assign non-null fields: GL JS reads e.g. `offset.x` eagerly and
    // throws on a null, which would abort the whole fitBounds call.
    final fitOpts = JSFitBoundsOptions(essential: true)
      ..padding = state.geometryPadding.toJSPadding()
      ..duration = duration
      ..linear =
          transition is EasingViewportTransition &&
          transition.curve == const Cubic(0, 0, 1, 1);
    if (state.bearing != null) fitOpts.bearing = state.bearing!;
    if (state.pitch != null) fitOpts.pitch = state.pitch!;
    if (state.offset != null) fitOpts.offset = state.offset!.toJSScreenPoint();
    if (state.maxZoom != null) fitOpts.maxZoom = state.maxZoom!;

    map.fitBounds(bounds, fitOpts);

    if (transition != null) {
      await map.onceAsync('moveend').toDart;
    }
  }
}
