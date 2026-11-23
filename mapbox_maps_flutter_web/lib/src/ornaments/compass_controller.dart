import 'dart:js_interop';
import 'dart:typed_data';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import '../bindings/map_bindings.dart';
import 'ornament_css.dart';

/// Bearing, in degrees, within which the map counts as facing north for
/// [CompassSettings.fadeWhenFacingNorth]. Matches the tolerance GL JS uses
/// to decide a `resetNorth` has arrived.
const _northTolerance = 0.5;

/// Web compass backed by the compass button of GL JS's `NavigationControl`.
///
/// GL JS has no standalone compass control, so the navigation control is
/// constructed with its zoom buttons switched off: the native compass
/// ornament is only a compass, and [CompassSettings] has no field that would
/// govern zoom buttons.
///
/// [CompassSettings] splits three ways here:
///
///   * `enabled`, `visibility` and `position` drive the control directly.
///   * `opacity`, `clickable`, the margins, `image` and
///     `fadeWhenFacingNorth` are applied to the control's element.
///   * `rotation` has no counterpart: GL JS rewrites the needle's rotation
///     on every camera change. It is stored and returned by [getSettings]
///     but never applied, so a round-trip through the API preserves it.
///
/// Settings are kept in a Dart-side shadow copy because GL JS cannot report
/// most of them back. [updateSettings] merges into that copy: a field left
/// `null` in an update keeps its previous value, giving the API its
/// partial-update behaviour.
class CompassController
    implements CompassSettingsPlatformInterface, Disposable {
  /// Attaches the control straight away: the compass is enabled by default,
  /// so it belongs on the map before the first [updateSettings] call, and
  /// [getSettings] reports it as enabled from the start.
  CompassController(this._map) {
    _attach();
    _applyStyle();
  }

  final JSMap _map;

  /// Seeded with the documented defaults so [getSettings] reports the
  /// configuration actually in effect before anything is changed, as the
  /// mobile implementations do.
  CompassSettings _current = CompassSettings(
    enabled: true,
    position: OrnamentPosition.TOP_RIGHT,
    marginLeft: 4,
    marginTop: 4,
    marginRight: 4,
    marginBottom: 4,
    opacity: 1,
    rotation: 0,
    visibility: true,
    fadeWhenFacingNorth: true,
    clickable: true,
  );
  JSNavigationControl? _control;

  /// URL of the blob backing a custom compass [CompassSettings.image].
  /// Held so it can be revoked when the image is replaced or the control
  /// goes away — an object URL lives until it is revoked.
  String? _imageUrl;

  /// Listener that re-evaluates the fade when the map's bearing changes.
  JSFunction? _rotateListener;

  @override
  Future<CompassSettings> getSettings() async => _current;

  @override
  Future<void> updateSettings(CompassSettings settings) async {
    final previous = _current;
    _current = _merge(previous, settings);

    // `enabled` and `visibility` both mean "is the compass shown", as on
    // iOS, so the two collapse onto one state. Resolve it from the fields
    // this call actually supplied, not the merged copy — reading the merged
    // copy would let a stale `false` on one field veto a `true` the caller
    // just set on the other.
    final visible =
        settings.enabled ??
        settings.visibility ??
        (previous.enabled != false && previous.visibility != false);
    _current.enabled = visible;
    _current.visibility = visible;

    if (!visible) {
      _detach();
      return;
    }

    // `position` is fixed when the control is added, so a change to it
    // needs a fresh control.
    if (_control == null || _current.position != previous.position) {
      _detach();
      _attach();
    }

    _applyStyle();
  }

  void _attach() {
    final control = JSNavigationControl(
      JSNavigationControlOptions(
        showCompass: true,
        showZoom: false,
        visualizePitch: true,
      ),
    );
    _map.addControl(control, toJSControlPosition(_current.position));
    _control = control;

    // GL JS keeps the compass visible at every bearing, so the fade is ours
    // to apply, re-evaluated whenever the bearing changes.
    final listener = ((JSAny? _) => _applyFade()).toJS;
    _map.on('rotate', listener);
    _rotateListener = listener;
  }

  void _detach() {
    final control = _control;
    if (control == null) return;
    if (_rotateListener case final listener?) {
      _map.off('rotate', listener);
      _rotateListener = null;
    }
    _map.removeControl(control);
    _control = null;
    _revokeImageUrl();
  }

  /// The control's root element: the group `div` GL JS wraps the compass
  /// button in. Margins and opacity belong here, not on the button — styling
  /// the button alone stretches and fades it inside a group box that stays
  /// put.
  web.HTMLElement? _rootElement() {
    final button = findControlElement(_map, '.mapboxgl-ctrl-compass');
    return button?.parentElement as web.HTMLElement?;
  }

  void _applyStyle() {
    final root = _rootElement();
    if (root == null) return;

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
    _applyImage(root);
    // Sets opacity, which the fade also drives.
    _applyFade();
  }

  /// Applies [CompassSettings.opacity], reduced to zero while the map faces
  /// north and [CompassSettings.fadeWhenFacingNorth] is on.
  void _applyFade() {
    final root = _rootElement();
    if (root == null) return;

    final opacity = _current.opacity ?? 1;
    final fading = _current.fadeWhenFacingNorth ?? true;
    final facingNorth = _map.getBearing().abs() < _northTolerance;
    root.style.opacity = '${fading && facingNorth ? 0 : opacity}';
  }

  /// Replaces the compass needle with [CompassSettings.image].
  ///
  /// GL JS draws the needle as the `background-image` of a span inside the
  /// button, so the custom image goes to the same place. Following the
  /// Android behaviour, an empty list restores the default needle.
  void _applyImage(web.HTMLElement root) {
    final image = _current.image;
    if (image == null) return;

    final icon = root.querySelector('.mapboxgl-ctrl-icon');
    if (icon == null) return;

    _revokeImageUrl();
    if (image.isEmpty) {
      (icon as web.HTMLElement).style.removeProperty('background-image');
      return;
    }

    final blob = web.Blob(
      [image.toJS].toJS,
      web.BlobPropertyBag(type: 'image/png'),
    );
    final url = web.URL.createObjectURL(blob);
    _imageUrl = url;
    (icon as web.HTMLElement).style.backgroundImage = 'url($url)';
  }

  void _revokeImageUrl() {
    final url = _imageUrl;
    if (url == null) return;
    web.URL.revokeObjectURL(url);
    _imageUrl = null;
  }

  @override
  void dispose() {
    // The map owns the control and tears it down with itself; the object
    // URL and the listener are ours to release, though.
    if (_rotateListener case final listener?) {
      _map.off('rotate', listener);
      _rotateListener = null;
    }
    _revokeImageUrl();
    _control = null;
  }
}

/// Layers [update] over [base], keeping [base]'s value for any field
/// [update] leaves `null`. This is what gives [CompassController] its
/// partial-update behaviour.
CompassSettings _merge(CompassSettings base, CompassSettings update) {
  return CompassSettings(
    enabled: update.enabled ?? base.enabled,
    position: update.position ?? base.position,
    marginLeft: update.marginLeft ?? base.marginLeft,
    marginTop: update.marginTop ?? base.marginTop,
    marginRight: update.marginRight ?? base.marginRight,
    marginBottom: update.marginBottom ?? base.marginBottom,
    opacity: update.opacity ?? base.opacity,
    rotation: update.rotation ?? base.rotation,
    visibility: update.visibility ?? base.visibility,
    fadeWhenFacingNorth: update.fadeWhenFacingNorth ?? base.fadeWhenFacingNorth,
    clickable: update.clickable ?? base.clickable,
    image: _mergeImage(base.image, update.image),
  );
}

/// An empty list is a meaningful value for `image` — it clears a custom
/// needle — so it must not be confused with "no image supplied", which is
/// `null`.
Uint8List? _mergeImage(Uint8List? base, Uint8List? update) => update ?? base;
