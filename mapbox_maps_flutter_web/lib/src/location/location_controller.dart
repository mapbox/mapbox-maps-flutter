import 'dart:async';
import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
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
  MutationObserver? _setupObserver;

  /// Stream of positions reported by the active `GeolocateControl`. Empty
  /// while `enabled = false`. Used by the viewport for follow-puck.
  Stream<GeolocationCoordinates> get locationUpdates => _locationUpdates.stream;

  LocationController(this._map);

  @override
  Future<LocationComponentSettings> getSettings() async => _current;

  @override
  Future<void> updateSettings(LocationComponentSettings settings) async {
    _current = _merge(_current, settings);

    // Workaround: GL JS's `GeolocateControl` options are construction-only,
    // so every settings change requires tearing the control down and
    // recreating it. Remove this once GL JS exposes runtime option
    // updates https://mapbox.atlassian.net/browse/GLJS-1821.
    if (_current.enabled == true) {
      _attach();
    } else {
      _detach();
    }
  }

  void _attach() {
    _detach();
    final control = JSGeolocateControl(
      JSGeolocateControlOptions(
        positionOptions: JSPositionOptions(enableHighAccuracy: true),
        // `trackUserLocation` keeps watchPosition alive so the puck moves
        // with the user; `followUserLocation: false` keeps the camera put —
        // camera control lives in the viewport API, not here.
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
    _whenButtonAppears(() => control.trigger());
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

  // Workaround: GL JS provides no signal that the control is ready to
  // `trigger()`, so we watch the DOM for the button instead. Remove
  // once GL JS exposes a 'ready' event https://mapbox.atlassian.net/browse/GLJS-1822.
  void _whenButtonAppears(void Function() callback) {
    final container = _map.getContainer();
    const selector = '.mapboxgl-ctrl-geolocate';
    // Fast path: browsers without `navigator.permissions` finish setup
    // synchronously inside `addControl`, so the button is already there.
    if (container.querySelector(selector) != null) {
      callback();
      return;
    }
    final observer = MutationObserver(
      ((JSArray<MutationRecord> _, MutationObserver _) {
        if (container.querySelector(selector) != null) {
          _setupObserver?.disconnect();
          _setupObserver = null;
          callback();
        }
      }).toJS,
    );
    _setupObserver = observer;
    observer.observe(
      container,
      MutationObserverInit(childList: true, subtree: true),
    );
  }

  void _detach() {
    _setupObserver?.disconnect();
    _setupObserver = null;
    final control = _control;
    if (control == null) return;
    _detachGeolocateListener();
    _map.removeControl(control);
    _control = null;
  }

  @override
  void dispose() {
    _detach();
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
