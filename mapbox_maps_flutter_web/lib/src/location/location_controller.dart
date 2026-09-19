import 'dart:async';
import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart';

import '../bindings/map_bindings.dart';

/// Web location component backed by GL JS's `GeolocateControl`. Puck
/// imagery, pulsing, and ring colours are stored on Dart side only — GL
/// JS doesn't expose them on the control.
class LocationController
    implements LocationSettingsPlatformInterface, Disposable {
  final JSMap _map;

  LocationComponentSettings _current = LocationComponentSettings();
  JSGeolocateControl? _control;

  late final _locationUpdates =
      StreamController<GeolocationCoordinates>.broadcast(
        onListen: _attachGeolocateListener,
        onCancel: _detachGeolocateListener,
      );
  JSFunction? _geolocateListener;

  /// Stream of positions reported by the active `GeolocateControl`. Empty
  /// while `enabled = false`. Used by the viewport for follow-puck.
  Stream<GeolocationCoordinates> get locationUpdates => _locationUpdates.stream;

  LocationController(this._map);

  @override
  Future<LocationComponentSettings> getSettings() async => _current;

  @override
  Future<void> updateSettings(LocationComponentSettings settings) async {
    _current = _merge(_current, settings);
    final control = _control;

    if (_current.enabled != true) {
      _detach();
      return;
    }

    if (control == null) {
      _attach();
      return;
    }

    if (settings.puckBearingEnabled case final puckBearingEnabled?) {
      control.setShowUserHeading(puckBearingEnabled);
    }
    if (settings.showAccuracyRing case final showAccuracyRing?) {
      control.setShowAccuracyCircle(showAccuracyRing);
    }
  }

  void _attach() {
    final control = JSGeolocateControl(
      JSGeolocateControlOptions(
        positionOptions: JSPositionOptions(enableHighAccuracy: true),
        // `trackUserLocation` keeps watchPosition alive so the puck moves
        // with the user; `followUserLocation: false` keeps the camera put —
        // camera control lives in the viewport API, not here. Neither is
        // ever changed at runtime, so they stay construction-only.
        trackUserLocation: true,
        followUserLocation: false,
        showUserHeading: _current.puckBearingEnabled ?? false,
        showAccuracyCircle: _current.showAccuracyRing ?? false,
        showUserLocation: true,
        showButton: false,
      ),
    );
    _map.addControl(control);
    _control = control;
    // Only attach the geolocate listener if someone is already listening
    // to the [locationUpdates] stream; otherwise leave it off until a
    // subscriber appears (see [onListen] on `_locationUpdates`).
    if (_locationUpdates.hasListener) _attachGeolocateListener();
    // `trigger()` before `'ready'` logs a warning; the control fires
    // `'ready'` exactly once, so a plain listener behaves like `once`.
    control.on(JSGeolocateEventType.ready, (() => control.trigger()).toJS);
  }

  void _attachGeolocateListener() {
    final control = _control;
    if (control == null || _geolocateListener != null) return;
    final listener = ((JSGeolocateEvent event) {
      _locationUpdates.add(event.coords);
    }).toJS;
    control.on(JSGeolocateEventType.geolocate, listener);
    _geolocateListener = listener;
  }

  void _detachGeolocateListener() {
    final listener = _geolocateListener;
    if (listener == null) return;
    _control?.off(JSGeolocateEventType.geolocate, listener);
    _geolocateListener = null;
  }

  void _detach() {
    final control = _control;
    if (control == null) return;
    _detachGeolocateListener();
    _map.removeControl(control);
    _control = null;
  }

  @override
  void dispose() {
    // The JSMap instance is owned by `_MapWebWidgetState` and torn down in
    // its own `dispose()` (see [map_widget.dart]).
    // Here we just clean up the resources on Dart side.
    _geolocateListener = null;
    _control = null;
    _locationUpdates.close();
  }
}

/// Layer [update] over [base], keeping [base]'s value for any field [update]
/// leaves as `null`. Mirrors the partial-update contract that mobile
/// implements in its `applyFromFLT` mapping.
LocationComponentSettings _merge(
  LocationComponentSettings base,
  LocationComponentSettings update,
) {
  return LocationComponentSettings(
    enabled: update.enabled ?? base.enabled,
    pulsingEnabled: update.pulsingEnabled ?? base.pulsingEnabled,
    pulsingColor: update.pulsingColor ?? base.pulsingColor,
    pulsingMaxRadius: update.pulsingMaxRadius ?? base.pulsingMaxRadius,
    showAccuracyRing: update.showAccuracyRing ?? base.showAccuracyRing,
    accuracyRingColor: update.accuracyRingColor ?? base.accuracyRingColor,
    accuracyRingBorderColor:
        update.accuracyRingBorderColor ?? base.accuracyRingBorderColor,
    layerAbove: update.layerAbove ?? base.layerAbove,
    layerBelow: update.layerBelow ?? base.layerBelow,
    puckBearingEnabled: update.puckBearingEnabled ?? base.puckBearingEnabled,
    puckBearing: update.puckBearing ?? base.puckBearing,
    slot: update.slot ?? base.slot,
    locationPuck: update.locationPuck ?? base.locationPuck,
  );
}
