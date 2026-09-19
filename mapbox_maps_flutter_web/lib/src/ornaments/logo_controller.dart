import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import '../bindings/map_bindings.dart';
import 'ornament_css.dart';

/// Web Mapbox logo backed by GL JS's logo control.
///
/// GL JS keeps the logo control private, so this handler works on the
/// control's element. It cannot add, remove or replace the control.
///
/// GL JS also hides the logo for a style whose sources do not require it. So
/// `enabled: true` means "do not hide the logo", not "show the logo":
/// [getSettings] can report the logo as enabled while the style hides it.
///
/// GL JS cannot report the settings back, so [_current] is the record of
/// them.
class LogoController implements LogoSettingsPlatformInterface, Disposable {
  /// There is no attach step: GL JS added the logo when it built the map.
  LogoController(this._map) {
    _applyStyle();
  }

  final JSMap _map;

  /// The margins follow iOS, as the attribution margins do.
  LogoSettings _current = LogoSettings(
    enabled: true,
    position: OrnamentPosition.BOTTOM_LEFT,
    marginLeft: 8,
    marginTop: 8,
    marginRight: 8,
    marginBottom: 8,
  );

  @override
  Future<LogoSettings> getSettings() async => _current;

  @override
  Future<void> updateSettings(LogoSettings settings) async {
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

  /// The logo control's root: the element wrapping the link, which is what
  /// carries the margins. The link itself carries a negative margin of its
  /// own from GL JS's stylesheet, and moving the link would leave the
  /// wrapper behind in the old corner.
  web.HTMLElement? _root() =>
      findControlElement(_map, '.mapboxgl-ctrl-logo')?.parentElement
          as web.HTMLElement?;

  /// Uses `visibility`, never `display`: GL JS rewrites `display` on the
  /// logo whenever a source reports new metadata.
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
  }

  @override
  void dispose() {
    // The map owns the logo control and tears it down with itself.
  }
}

/// Layers [update] over [base], which gives the API its partial updates.
LogoSettings _merge(LogoSettings base, LogoSettings update) {
  return LogoSettings(
    enabled: update.enabled ?? base.enabled,
    position: update.position ?? base.position,
    marginLeft: update.marginLeft ?? base.marginLeft,
    marginTop: update.marginTop ?? base.marginTop,
    marginRight: update.marginRight ?? base.marginRight,
    marginBottom: update.marginBottom ?? base.marginBottom,
  );
}
