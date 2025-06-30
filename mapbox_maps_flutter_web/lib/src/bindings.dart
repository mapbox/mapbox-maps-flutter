@JS('mapboxgl')
library;

import 'dart:js_interop';

import 'package:web/web.dart';

@JS()
external String accessToken;

@JS()
@anonymous
extension type LngLat._(JSObject _) implements JSObject {
  external LngLat(num lng, num lat);
  external num lat;
  external num lng;
}

@JS()
@anonymous
extension type CameraOptions._(JSObject _) implements JSObject {
  external factory CameraOptions({
    LngLat? center,
    PaddingOptions? padding,
    double? zoom,
    double? bearing,
    double? pitch,
  });
  external LngLat? center;
  external PaddingOptions? padding;
  external double? zoom;
  external double? bearing;
  external double? pitch;
}

@JS()
@anonymous
extension type PaddingOptions._(JSObject _) implements JSObject {
  external factory PaddingOptions({
    num top,
    num left,
    num bottom,
    num right,
  });
  external num top;
  external num left;
  external num bottom;
  external num right;
}

@JS()
@anonymous
extension type MapOptions._(JSObject _) implements JSObject {
  external factory MapOptions({
    required HTMLDivElement container,
    LngLat? center,
    PaddingOptions? padding,
    double? zoom,
    double? bearing,
    double? pitch,
  });
}

extension type Map._(JSObject _) implements JSObject {
  external Map(MapOptions container);
  external void on(String event, JSFunction callback);
  external void jumpTo(CameraOptions camera);
  external LngLat getCenter();
  external PaddingOptions getPadding();
  external double getZoom();
  external double getBearing();
  external double getPitch();
}
