import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import '../bindings/map_bindings.dart';
import 'ornament_css.dart';

/// Web attribution backed by GL JS's `AttributionControl`.
///
/// GL JS adds the control to every map it builds, so this handler uses that
/// control and never adds one. A position change moves the control's element
/// between the corner containers.
///
/// `iconColor` has no counterpart: GL JS draws the icon as a background
/// image, which CSS cannot recolor. [getSettings] returns it, but web never
/// applies it.
///
/// GL JS cannot report the settings back, so [_current] is the record of
/// them.
class AttributionController
    implements AttributionSettingsPlatformInterface, Disposable {
  /// There is no attach step: GL JS added the control when it built the map.
  AttributionController(this._map) {
    _applyStyle();
  }

  final JSMap _map;

  /// The defaults follow iOS, which agrees with where GL JS puts the
  /// control. Android uses the bottom-left corner and a wide left margin.
  AttributionSettings _current = AttributionSettings(
    enabled: true,
    iconColor: 0xFF1E8CAB,
    position: OrnamentPosition.BOTTOM_RIGHT,
    marginLeft: 8,
    marginTop: 8,
    marginRight: 8,
    marginBottom: 8,
    clickable: true,
  );

  @override
  Future<AttributionSettings> getSettings() async => _current;

  @override
  Future<void> updateSettings(AttributionSettings settings) async {
    final previous = _current;
    _current = _merge(previous, settings);

    if (_current.enabled == false) {
      _hide();
      return;
    }

    if (_current.position != previous.position) {
      if (_root() case final root?) {
        moveToCorner(_map, root, _current.position);
      }
    }

    _applyStyle();
  }

  web.HTMLElement? _root() => findControlElement(_map, '.mapboxgl-ctrl-attrib');

  void _hide() {
    if (_root() case final root?) {
      root.style.visibility = 'hidden';
    }
  }

  void _applyStyle() {
    final root = _root();
    if (root == null) return;

    root.style.visibility = 'visible';

    applyMargins(
      root,
      marginLeft: _current.marginLeft,
      marginTop: _current.marginTop,
      marginRight: _current.marginRight,
      marginBottom: _current.marginBottom,
    );

    if (_current.clickable case final clickable?) {
      root.style.pointerEvents = clickable ? 'auto' : 'none';
    }
  }

  @override
  void dispose() {
    // The map owns the control and tears it down with itself.
  }
}

/// Layers [update] over [base], which gives the API its partial updates.
AttributionSettings _merge(
  AttributionSettings base,
  AttributionSettings update,
) {
  return AttributionSettings(
    enabled: update.enabled ?? base.enabled,
    iconColor: update.iconColor ?? base.iconColor,
    position: update.position ?? base.position,
    marginLeft: update.marginLeft ?? base.marginLeft,
    marginTop: update.marginTop ?? base.marginTop,
    marginRight: update.marginRight ?? base.marginRight,
    marginBottom: update.marginBottom ?? base.marginBottom,
    clickable: update.clickable ?? base.clickable,
  );
}
