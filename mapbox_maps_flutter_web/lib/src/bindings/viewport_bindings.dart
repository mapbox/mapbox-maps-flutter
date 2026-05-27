@JS('mapboxgl')
library;

import 'dart:js_interop';

import 'package:mapbox_maps_flutter_web/src/bindings/map_bindings.dart';

/// Mapbox GL JS camera options for jumpTo/easeTo/flyTo.
@JS()
@anonymous
extension type JSCameraOptions._(JSObject _) implements JSObject {
  external factory JSCameraOptions({
    JSLngLat? center,
    double? zoom,
    double? bearing,
    double? pitch,
    JSPadding? padding,
    double? speed,
    double? curve,
    int? duration,
    JSFunction? easing,
    bool? essential,
  });

  external JSLngLat? center;
  external double? zoom;
  external double? bearing;
  external double? pitch;
  external set padding(JSPadding value);
  external set around(JSLngLat value);
  external set speed(double value);
  external set curve(double value);
  external set duration(int value);
  external set easing(JSFunction value);
  external set essential(bool value);
}

/// Mapbox GL JS padding object.
@JS()
@anonymous
extension type JSPadding._(JSObject _) implements JSObject {
  external factory JSPadding({
    double top,
    double bottom,
    double left,
    double right,
  });
}

/// Mapbox GL JS fitBounds options.
@JS()
@anonymous
extension type JSFitBoundsOptions._(JSObject _) implements JSObject {
  external factory JSFitBoundsOptions({
    JSPadding? padding,
    double? bearing,
    double? pitch,
    JSScreenPoint? offset,
    int? duration,
    bool? linear,
    JSFunction? easing,
    bool? essential,
  });

  external set maxZoom(double value);
}
