@JS('mapboxgl')
library;

import 'dart:js_interop';

import 'package:web/web.dart';

import 'viewport_bindings.dart';
export 'viewport_bindings.dart';

@JS()
external String accessToken;

@JS()
@anonymous
extension type JSMapOptions._(JSObject _) implements JSObject {
  external factory JSMapOptions({required HTMLDivElement container});
}

@JS('LngLat')
extension type JSLngLat._(JSObject _) implements JSObject {
  external double get lng;
  external double get lat;
}

/// The root-level camera fields from a Mapbox style specification.
@JS()
@anonymous
extension type JSStyleSpec._(JSObject _) implements JSObject {
  external JSArray<JSNumber>? get center;
  external double? get zoom;
  external double? get bearing;
  external double? get pitch;
}

@JS('Map')
extension type JSMap._(JSObject _) implements JSObject {
  external JSMap(JSMapOptions container);
  external void on(String event, JSFunction callback);
  external void off(String event, JSFunction callback);
  external void once(String event, JSFunction callback);

  /// Returns a Promise that resolves when the event fires once.
  @JS('once')
  external JSPromise<JSAny> onceAsync(String event);

  /// Instantly sets the camera to the given options.
  external void jumpTo(JSCameraOptions options);

  /// Animates the camera to the given options using an ease animation.
  external void easeTo(JSCameraOptions options);

  /// Animates the camera to the given options using a fly animation.
  external void flyTo(JSCameraOptions options);

  /// Fits the map to the given geographical bounds.
  external void fitBounds(JSAny bounds, JSFitBoundsOptions? options);

  /// Stops any current camera animation.
  external void stop();

  /// Returns the map's current center as a LngLat object.
  external JSLngLat getCenter();

  /// Returns the map's current zoom level.
  external double getZoom();

  /// Returns the map's current bearing (rotation).
  external double getBearing();

  /// Returns the map's current pitch (tilt).
  external double getPitch();

  /// Returns the map's style specification object.
  external JSStyleSpec getStyle();

  /// Returns whether the map's style is fully loaded.
  external bool isStyleLoaded();

  /// Recalculates the map's dimensions and re-renders.
  external void resize();

  /// Cleans up all resources associated with this map instance:
  /// destroys the WebGL context, removes DOM elements, clears event listeners.
  external void remove();
}
