import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import '../bindings/map_bindings.dart';
import 'viewport_handler.dart';
import 'viewport_utils.dart';

final class StyleDefaultHandler extends WebViewportStateHandler {
  @override
  Future<void> runApply(JSMap map, ViewportTransition? transition) async {
    if (!map.isStyleLoaded()) {
      await map.onceAsync('style.load').toDart;
    }

    final style = map.getStyle();
    animateCamera(
      map,
      style.center,
      style.zoom,
      style.bearing,
      style.pitch,
      null,
      transition ?? const ImmediateViewportTransition(),
    );

    if (transition != null) {
      await map.onceAsync('moveend').toDart;
    }
  }
}
