import 'dart:js_interop';

import 'package:flutter/animation.dart';
import '../bindings/map_bindings.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import 'viewport_handler.dart';
import 'viewport_utils.dart';

class OverviewHandler implements WebViewportStateHandler {
  final OverviewViewportState state;
  OverviewHandler(this.state);

  @override
  Future<bool> apply(JSMap map, ViewportTransition? transition) async {
    final bounds = geometryToBounds(state.geometry);
    if (bounds == null) return false;

    final duration = transitionDurationMs(transition) ??
        state.animationDuration.inMilliseconds;

    final padding = JSPadding(
      top: state.geometryPadding.top,
      bottom: state.geometryPadding.bottom,
      left: state.geometryPadding.left,
      right: state.geometryPadding.right,
    );

    final offset = <JSAny>[
      (state.offset?.dx ?? 0.0).toJS,
      (state.offset?.dy ?? 0.0).toJS,
    ].toJS;

    final fitOpts = JSFitBoundsOptions(
      padding: padding,
      bearing: state.bearing,
      pitch: state.pitch,
      offset: offset,
      duration: transition == null ? 0 : duration,
      linear: transition is EasingViewportTransition &&
          transition.curve == const Cubic(0, 0, 1, 1),
      essential: true,
    );
    if (state.maxZoom != null) {
      fitOpts.maxZoom = state.maxZoom!;
    }

    map.fitBounds(bounds, fitOpts);

    if (transition != null) {
      await map.onceAsync('moveend').toDart;
    }
    return true;
  }
}
