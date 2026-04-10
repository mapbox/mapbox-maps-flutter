import 'dart:js_interop';

import '../bindings/map_bindings.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import 'viewport_handler.dart';
import 'viewport_utils.dart';

class StyleDefaultHandler implements WebViewportStateHandler {
  @override
  Future<bool> apply(JSMap map, ViewportTransition? transition) async {
    if (!map.isStyleLoaded()) {
      await map.onceAsync('style.load').toDart;
    }

    final style = map.getStyle();
    final center = style.center;
    final jsCenter =
        center != null ? <JSAny>[center[0], center[1]].toJS : null;

    if (transition == null) {
      map.jumpTo(JSCameraOptions(
        center: jsCenter,
        zoom: style.zoom,
        bearing: style.bearing,
        pitch: style.pitch,
      ));
    } else {
      animate(map, jsCenter, style.zoom, style.bearing, style.pitch, null,
          transition);
      await map.onceAsync('moveend').toDart;
    }
    return true;
  }
}
