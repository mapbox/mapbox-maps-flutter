@JS('mapboxgl')
library;

import 'dart:js_interop';

import 'package:web/web.dart';

import 'interaction_bindings.dart';
import 'location_bindings.dart';
import 'viewport_bindings.dart';

export 'interaction_bindings.dart';
export 'location_bindings.dart';
export 'viewport_bindings.dart';

@JS()
external String accessToken;

// ===== Foundation =====

/// JS plain object viewed as a key/value dictionary. Use [toDart] to
/// convert into a Dart [Map].
@JS()
extension type JSDictionary<K, V>._(JSObject _) implements JSObject {
  Map<K, V> toDart() => (dartify() as Map?)?.cast<K, V>() ?? <K, V>{};
}

/// GeoJSON geometry object. Same shape as [JSDictionary] but kept as a
/// distinct nominal type so geometry-specific helpers can be added here.
@JS()
extension type JSGeometry._(JSObject _)
    implements JSDictionary<String?, Object?> {}

/// Identifier value — GL JS types feature/source ids as `string | number`.
/// Numeric ids are treated as integers (the typical tile-feature shape).
@JS()
extension type JSIdentifier._(JSAny _) implements JSAny {
  String toDart() {
    if (isA<JSString>()) return (this as JSString).toDart;
    if (isA<JSNumber>()) return (this as JSNumber).toDartInt.toString();
    return '';
  }
}

@JS()
external void clearStorage(JSFunction callback);

@JS()
@anonymous
extension type JSMapOptions._(JSObject _) implements JSObject {
  external factory JSMapOptions({required HTMLDivElement container});
}

@JS('LngLat')
extension type JSLngLat._(JSObject _) implements JSObject {
  external JSLngLat(double lng, double lat);
  external double get lng;
  external double get lat;
}

/// `[longitude, latitude]` array pair — GL JS's `LngLatLike` array form.
/// Used wherever the engine expects a coordinate as a 2-element array
/// rather than a [JSLngLat] instance (e.g. `ImageSource.coordinates`,
/// `StyleSpec.center`).
extension type JSLngLatPair._(JSArray<JSNumber> _) implements JSArray<JSNumber> {
  factory JSLngLatPair(double lng, double lat) =>
      JSLngLatPair._(<JSNumber>[lng.toJS, lat.toJS].toJS);

  double get lng => _[0].toDartDouble;
  double get lat => _[1].toDartDouble;
}

/// GL JS's `Point` (`@mapbox/point-geometry`). Pixel coordinate within the
/// map container; satisfies `PointLike` wherever GL JS accepts one.
@JS('Point')
extension type JSScreenPoint._(JSObject _) implements JSObject {
  external JSScreenPoint(double x, double y);
  external double get x;
  external double get y;
}

/// The root-level camera fields from a Mapbox style specification.
@JS()
@anonymous
extension type JSStyleSpec._(JSObject _) implements JSObject {
  external JSLngLatPair? get center;
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

  /// Unprojects a pixel coordinate (relative to the map's container) to a
  /// geographical coordinate.
  external JSLngLat unproject(JSScreenPoint point);

  /// Returns the HTMLElement the map is rendered into.
  external HTMLElement getContainer();

  /// One-finger pan handler.
  external JSGestureHandler get dragPan;

  /// Right-click / two-finger rotate handler.
  external JSDragRotateHandler get dragRotate;

  /// Mouse-wheel / trackpad-pinch zoom handler.
  external JSGestureHandler get scrollZoom;

  /// Two-finger vertical pitch handler.
  external JSGestureHandler get touchPitch;

  /// Two-finger pinch zoom (and rotate) handler.
  external JSTouchZoomRotateHandler get touchZoomRotate;

  /// Double-click zoom-in handler.
  external JSGestureHandler get doubleClickZoom;

  /// Keyboard shortcut handler (+/-, arrows, shift+arrows).
  external JSKeyboardHandler get keyboard;

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

  /// Registers an interaction (gesture handler) under [id]. GL JS throws if
  /// [id] is already registered.
  external void addInteraction(String id, JSInteraction interaction);

  /// Removes an interaction previously registered with [addInteraction].
  /// No-op when [id] is unknown.
  external void removeInteraction(String id);

  /// Attaches an `IControl` (e.g. a `GeolocateControl`) to the map.
  external void addControl(JSControl control);

  /// Removes a previously attached control. No-op when the control was
  /// never added.
  external void removeControl(JSControl control);

  /// Synthesizes an event of [type] with the given [data] payload and
  /// dispatches it to all listeners (including interactions).
  external void fire(String type, JSObject? data);
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

/// Payload of camera-related events (`movestart`, `move`, `moveend`).
/// Programmatic moves leave `originalEvent` null.
///
/// TODO: replace with `JSGestureEventData` once the gestures-stream
/// branch lands.
@JS()
@anonymous
extension type JSMapMoveEvent._(JSObject _) implements JSObject {
  external Event? get originalEvent;
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

/// Payload of camera-surface gesture events (`drag*` / `zoom*` / `rotate*`
/// / `pitch*`). Carries only `originalEvent`; `point`/`lngLat` are absent.
@JS()
@anonymous
extension type JSGestureEventData._(JSObject _) implements JSObject {
  external JSDOMEvent? get originalEvent;
}

/// One of GL JS's toggleable gesture handlers (`dragPan`, `dragRotate`,
/// `scrollZoom`, `touchPitch`, `touchZoomRotate`, `doubleClickZoom`).
@JS()
extension type JSGestureHandler._(JSObject _) implements JSObject {
  external void enable();
  external void disable();
  external bool isEnabled();
}

/// `touchZoomRotate` handler — adds `disableRotation`/`enableRotation` for
/// turning off the rotate portion of pinch while keeping pinch-zoom on.
@JS()
extension type JSTouchZoomRotateHandler._(JSObject _)
    implements JSGestureHandler {
  external void disableRotation();
  external void enableRotation();
}

/// `dragRotate` handler — exposes GL JS's `_pitchWithRotate` field so the
/// pitch portion of ctrl+drag can be toggled at runtime. GL JS has no
/// public setter for this constructor-only option yet; tracked at
/// https://mapbox.atlassian.net/browse/GLJS-1827. Remove `pitchWithRotate`
/// once that ships.
@JS()
extension type JSDragRotateHandler._(JSObject _) implements JSGestureHandler {
  @JS('_pitchWithRotate')
  external bool pitchWithRotate;
}

/// Keyboard handler — adds `disableRotation`/`enableRotation` for turning
/// off shift+arrow rotate/pitch while keeping +/- zoom and arrow pan.
@JS()
extension type JSKeyboardHandler._(JSObject _) implements JSGestureHandler {
  external void disableRotation();
  external void enableRotation();
}
