// ignore_for_file: experimental_member_use

import 'dart:async';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import '../bindings/map_bindings.dart';
import '../ornaments/ornament_css.dart';

/// Web indoor floor selector ornament, backed by GL JS's `IndoorControl`.
class IndoorSelectorController
    implements IndoorSelectorSettingsPlatformInterface, Disposable {
  IndoorSelectorController(this._map, this._indoor) {
    _attach();
  }

  final JSMap _map;
  final IndoorPlatformInterface _indoor;
  StreamSubscription<IndoorState>? _updateSubscription;

  IndoorSelectorSettings _current = IndoorSelectorSettings(
    enabled: true,
    position: OrnamentPosition.TOP_RIGHT,
  );
  JSIndoorControl? _control;

  @override
  Future<IndoorSelectorSettings> getSettings() async => _current;

  @override
  Future<void> updateSettings(IndoorSelectorSettings settings) async {
    final previous = _current;
    _current = _merge(previous, settings);

    if (_current.enabled == false) {
      _detach();
      return;
    }

    if (_control == null || _current.position != previous.position) {
      _detach();
      _attach();
    } else {
      _applyStyle();
    }
  }

  void _attach() {
    final control = JSIndoorControl();
    _map.addControl(control, toJSControlPosition(_current.position));
    _control = control;
    _applyStyle();
  }

  void _detach() {
    _updateSubscription?.cancel();
    _updateSubscription = null;
    final control = _control;
    if (control == null) return;
    _map.removeControl(control);
    _control = null;
  }

  web.HTMLElement? _rootElement() {
    final toggle = findControlElement(_map, '.mapboxgl-ctrl-indoor-toggle');
    return toggle?.parentElement as web.HTMLElement?;
  }

  // GL JS only renders the toggle button (the element we style) once the
  // control has floors to show, so this can fail right after `addControl`.
  // If so, wait for the next indoor update and retry, then stop — the
  // container persists afterwards, even if floors later disappear and
  // reappear. Drop this once GLJS-2038 adds native margin support to
  // addControl: https://mapbox.atlassian.net/browse/GLJS-2038
  void _applyStyle() {
    final root = _rootElement();
    if (root == null) {
      _updateSubscription ??= _indoor.indoorUpdates.listen(
        (_) => _applyStyle(),
      );
      return;
    }
    applyMargins(
      root,
      marginLeft: _current.marginLeft,
      marginTop: _current.marginTop,
      marginRight: _current.marginRight,
      marginBottom: _current.marginBottom,
    );
    _updateSubscription?.cancel();
    _updateSubscription = null;
  }

  @override
  void dispose() {
    _detach();
  }
}

IndoorSelectorSettings _merge(
  IndoorSelectorSettings base,
  IndoorSelectorSettings update,
) {
  return IndoorSelectorSettings(
    enabled: update.enabled ?? base.enabled,
    position: update.position ?? base.position,
    marginLeft: update.marginLeft ?? base.marginLeft,
    marginTop: update.marginTop ?? base.marginTop,
    marginRight: update.marginRight ?? base.marginRight,
    marginBottom: update.marginBottom ?? base.marginBottom,
  );
}
