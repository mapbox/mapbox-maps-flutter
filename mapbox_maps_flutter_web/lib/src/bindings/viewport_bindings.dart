@JS('mapboxgl')
library;

import 'dart:js_interop';

/// Mapbox GL JS camera options for jumpTo/easeTo/flyTo.
@JS()
@anonymous
extension type JSCameraOptions._(JSObject _) implements JSObject {
  external factory JSCameraOptions({
    JSAny? center,
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
    JSAny? offset,
    int? duration,
    bool? linear,
    JSFunction? easing,
    bool? essential,
  });

  external set maxZoom(double value);
}
