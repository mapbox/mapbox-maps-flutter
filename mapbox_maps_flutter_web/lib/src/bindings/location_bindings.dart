@JS('mapboxgl')
library;

import 'dart:js_interop';
import 'package:web/web.dart' show GeolocationCoordinates;

/// Marker type for any object implementing GL JS's `IControl` interface
/// (the contract accepted by `Map.addControl` / `Map.removeControl`).
@JS()
extension type JSControl._(JSObject _) implements JSObject {}

/// Options passed to [JSGeolocateControl]'s constructor.
///
/// Mirrors the subset of GL JS `GeolocateControlOptions` the handler uses;
/// pulsing colour / custom puck imagery / accuracy ring colours have no
/// counterpart on the GL JS control and are stored on the Dart side only.
@JS()
@anonymous
extension type JSGeolocateControlOptions._(JSObject _) implements JSObject {
  external factory JSGeolocateControlOptions({
    JSPositionOptions? positionOptions,
    bool? trackUserLocation,
    bool? followUserLocation,
    bool? showUserHeading,
    bool? showAccuracyCircle,
    bool? showUserLocation,
    bool? showButton,
  });
}

/// Browser Geolocation API `PositionOptions`. GL JS forwards this to
/// `navigator.geolocation.watchPosition`.
@JS()
@anonymous
extension type JSPositionOptions._(JSObject _) implements JSObject {
  external factory JSPositionOptions({
    bool? enableHighAccuracy,
    int? timeout,
    int? maximumAge,
  });
}

/// `mapboxgl.GeolocateControl`. Renders the user-location puck and accuracy
/// ring; subscribes to `navigator.geolocation.watchPosition` while attached
/// to the map. `positionOptions`, `trackUserLocation`, `showUserLocation`,
/// `followUserLocation`, and `showButton` are never changed after
/// construction, so only the two settings the handler updates at runtime
/// have setters below.
@JS('GeolocateControl')
extension type JSGeolocateControl._(JSObject _) implements JSControl {
  external JSGeolocateControl(JSGeolocateControlOptions options);

  /// Programmatically starts location tracking. Prompts the user for
  /// geolocation permission on first call. Must not be called before the
  /// `'ready'` event fires.
  external void trigger();

  external void setShowAccuracyCircle(bool show);
  external void setShowUserHeading(bool show);

  external void on(JSGeolocateEventType event, JSFunction handler);
  external void off(JSGeolocateEventType event, JSFunction handler);
}

/// Events emitted by [JSGeolocateControl]. Closed set — invalid event
/// names won't compile at the call site.
extension type const JSGeolocateEventType._(String value) {
  static const JSGeolocateEventType geolocate = JSGeolocateEventType._(
    'geolocate',
  );

  /// Fires once, after the control finishes initializing and is safe to
  /// [JSGeolocateControl.trigger].
  static const JSGeolocateEventType ready = JSGeolocateEventType._('ready');
}

/// Payload of `GeolocateControl`'s `'geolocate'` event.
@JS()
@anonymous
extension type JSGeolocateEvent._(JSObject _) implements JSObject {
  external GeolocationCoordinates get coords;
}
