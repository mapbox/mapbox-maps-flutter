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
///
/// Optional fields are exposed as setters rather than factory arguments so
/// callers only ever assign non-null values: GL JS reads e.g. `offset.x`
/// eagerly and throws on a null.
@JS()
@anonymous
extension type JSFitBoundsOptions._(JSObject _) implements JSObject {
  external factory JSFitBoundsOptions({bool? essential});

  external set padding(JSPadding value);
  external set bearing(double value);
  external set pitch(double value);
  external set offset(JSScreenPoint value);
  external set duration(int value);
  external set linear(bool value);
  external set maxZoom(double value);
}
