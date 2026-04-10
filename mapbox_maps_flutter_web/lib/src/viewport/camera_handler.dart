import 'dart:js_interop';

import '../bindings/map_bindings.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import 'viewport_handler.dart';
import 'viewport_utils.dart';

class CameraHandler implements WebViewportStateHandler {
  final CameraViewportState state;
  CameraHandler(this.state);

  @override
  Future<bool> apply(JSMap map, ViewportTransition? transition) async {
    final center = pointToJSCenter(state.center);
    final padding = edgeInsetsToJSPadding(state.padding);

    if (transition == null) {
      map.jumpTo(JSCameraOptions(
        center: center,
        zoom: state.zoom,
        bearing: state.bearing,
        pitch: state.pitch,
        padding: padding,
      ));
      return true;
    }

    animate(map, center, state.zoom, state.bearing, state.pitch, padding,
        transition);
    await map.onceAsync('moveend').toDart;
    return true;
  }
}
