import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import 'viewport_handler.dart';
import 'viewport_utils.dart';

import '../bindings/binding_adapters.dart';
import '../bindings/map_bindings.dart';

final class CameraHandler extends WebViewportStateHandler {
  final CameraViewportState state;
  CameraHandler(this.state);

  @override
  Future<void> runApply(JSMap map, ViewportTransition? transition) async {
    animateCamera(
      map,
      state.center?.toJSLngLat(),
      state.zoom,
      state.bearing,
      state.pitch,
      state.padding?.toJSPadding(),
      transition ?? const ImmediateViewportTransition(),
    );

    if (transition != null) {
      await map.onceAsync('moveend').toDart;
    }
  }
}
