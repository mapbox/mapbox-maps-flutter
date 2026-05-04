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

  /// Loads a new style by URI (`mapbox://styles/...`) or inline JSON object.
  external void setStyle(JSAny style);

  /// Returns whether the map's style is fully loaded.
  external bool isStyleLoaded();

  /// Recalculates the map's dimensions and re-renders.
  external void resize();

  /// Cleans up all resources associated with this map instance:
  /// destroys the WebGL context, removes DOM elements, clears event listeners.
  external void remove();
}

// ===== Event names =====

/// Mapbox GL JS event names that the web implementation subscribes to.
/// Kept as constants so callers can reference one name from bindings and
/// adapters without a typo-prone duplicate string.
class JSMapEvents {
  JSMapEvents._();

  static const load = 'load';
  static const styleLoad = 'style.load';
  static const styleData = 'styledata';
  static const idle = 'idle';

  /// Camera-position change. GL JS calls this `'move'`; renamed at the
  /// constant level to disambiguate from gesture events (mouse/touch
  /// `move` belongs to the gesture surface, not the camera surface).
  static const cameraMove = 'move';

  static const sourceData = 'sourcedata';
  static const renderStart = 'renderstart';
  static const render = 'render';
}

// ===== Event payload extern types =====

/// Shared shape of every Mapbox GL JS map event. Carries `type`; the full
/// object also exposes `target: JSMap` but we reach the map via closure
/// capture instead, so it isn't declared here.
@JS()
@anonymous
extension type JSMapBaseEvent._(JSObject _) implements JSObject {
  external String get type;
}

/// Payload of the `sourcedata` event (and the parent `data` event before
/// the Map re-fires it as `sourcedata`/`styledata`). Only the fields the
/// adapters read are declared.
@JS()
@anonymous
extension type JSMapDataEvent._(JSObject _) implements JSObject {
  /// Source id the event relates to, when `dataType == 'source'`.
  external String? get sourceId;

  /// True once the source has finished its initial load. Per
  /// `gl-js/src/ui/events.ts`, transitions to `true` on metadata-complete
  /// and stays true for subsequent content updates.
  external bool? get isSourceLoaded;
}
