import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

import '../bindings/map_bindings.dart';
import 'ornament_css.dart';

/// Web scale bar backed by GL JS's `ScaleControl`.
///
/// GL JS's scale bar is a bordered label showing a rounded distance, not the
/// tick-marked ruler the native SDKs draw, and its only options are
/// `maxWidth` and `unit`. So [ScaleBarSettings] splits three ways here:
///
///   * `enabled`, `position`, `ratio`, `isMetricUnits` and `distanceUnits`
///     drive the control directly. `distanceUnits` wins over `isMetricUnits`
///     when both are set, since it can also select nautical units.
///   * The margins, colors, `borderWidth` and `textSize` are applied as CSS
///     on the control's element.
///   * `height`, `textBarMargin`, `textBorderWidth`, `refreshInterval`,
///     `showTextBorder` and `useContinuousRendering` have no counterpart.
///     They are stored and returned by [getSettings] but never applied, so a
///     round-trip through the API preserves them.
///
/// Settings are kept in a Dart-side shadow copy because GL JS cannot report
/// most of them back. [updateSettings] merges into that copy: a field left
/// `null` in an update keeps its previous value, giving the API its
/// partial-update behaviour.
class ScaleBarController
    implements ScaleBarSettingsPlatformInterface, Disposable {
  /// Attaches the control straight away: the scale bar is enabled by default,
  /// so it belongs on the map before the first [updateSettings] call, and
  /// [getSettings] reports it as enabled from the start.
  ScaleBarController(this._map) {
    _attach();
    _applyStyle();
  }

  final JSMap _map;

  /// Seeded with the documented defaults so [getSettings] reports the
  /// configuration actually in effect before anything is changed, as the
  /// mobile implementations do.
  ScaleBarSettings _current = ScaleBarSettings(
    enabled: true,
    position: OrnamentPosition.TOP_LEFT,
    marginLeft: 4,
    marginTop: 4,
    marginRight: 4,
    marginBottom: 4,
    textColor: 0xFF000000,
    primaryColor: 0xFF000000,
    secondaryColor: 0xFFFFFFFF,
    borderWidth: 2,
    height: 2,
    textBarMargin: 8,
    textBorderWidth: 2,
    textSize: 8,
    isMetricUnits: true,
    distanceUnits: DistanceUnits.METRIC,
    refreshInterval: 15,
    showTextBorder: true,
    ratio: 0.5,
    useContinuousRendering: false,
  );
  JSScaleControl? _control;

  @override
  Future<ScaleBarSettings> getSettings() async => _current;

  @override
  Future<void> updateSettings(ScaleBarSettings settings) async {
    final previous = _current;
    _current = _merge(previous, settings);

    if (_current.enabled == false) {
      _detach();
      return;
    }

    // `position` and `maxWidth` are fixed when the control is added, so a
    // change to either needs a fresh control.
    final needsReattach =
        _control == null ||
        _current.position != previous.position ||
        _current.ratio != previous.ratio;
    if (needsReattach) {
      _detach();
      _attach();
    } else if (_unit(_current) case final unit?) {
      _control?.setUnit(unit);
    }

    _applyStyle();
  }

  void _attach() {
    final control = JSScaleControl(
      JSScaleControlOptions(maxWidth: _maxWidth(), unit: _unit(_current)),
    );
    _map.addControl(control, toJSControlPosition(_current.position));
    _control = control;
  }

  void _detach() {
    final control = _control;
    if (control == null) return;
    _map.removeControl(control);
    _control = null;
  }

  /// Converts `ratio` — a fraction of the map's width on the native SDKs —
  /// into the pixel width GL JS expects. Falls back to GL JS's own default
  /// of 100px when unset. Clamped to `[0, 1]` so an out-of-range ratio still
  /// yields a valid, non-negative width.
  int? _maxWidth() {
    final ratio = _current.ratio;
    if (ratio == null) return null;
    final clamped = ratio.clamp(0, 1);
    return (clamped * _map.getContainer().clientWidth).round();
  }

  /// Resolves the scale bar's unit from [ScaleBarSettings.distanceUnits] and
  /// [ScaleBarSettings.isMetricUnits]. `distanceUnits` wins when both are
  /// set, since it can also select nautical units.
  JSScaleUnit? _unit(ScaleBarSettings settings) {
    if (settings.distanceUnits case final units?) {
      return switch (units) {
        DistanceUnits.METRIC => JSScaleUnit.metric,
        DistanceUnits.IMPERIAL => JSScaleUnit.imperial,
        DistanceUnits.NAUTICAL => JSScaleUnit.nautical,
      };
    }
    if (settings.isMetricUnits case final isMetric?) {
      return isMetric ? JSScaleUnit.metric : JSScaleUnit.imperial;
    }
    return null;
  }

  void _applyStyle() {
    final element = findControlElement(_map, '.mapboxgl-ctrl-scale');
    if (element == null) return;

    applyMargins(
      element,
      marginLeft: _current.marginLeft,
      marginTop: _current.marginTop,
      marginRight: _current.marginRight,
      marginBottom: _current.marginBottom,
    );

    // The native scale bar alternates `primaryColor` and `secondaryColor`
    // between ruler segments; GL JS's label has no segments, so
    // `primaryColor` becomes the border and `secondaryColor` the fill.
    if (_current.textColor case final color?) {
      element.style.color = cssColor(color);
    }
    if (_current.primaryColor case final color?) {
      element.style.borderColor = cssColor(color);
    }
    if (_current.secondaryColor case final color?) {
      element.style.backgroundColor = cssColor(color);
    }
    if (_current.borderWidth case final width?) {
      // GL JS draws only the left, right and bottom edges of the label.
      element.style.borderLeftWidth = '${width}px';
      element.style.borderRightWidth = '${width}px';
      element.style.borderBottomWidth = '${width}px';
    }
    if (_current.textSize case final size?) {
      element.style.fontSize = '${size}px';
    }
  }

  @override
  void dispose() {
    // The map owns the control and tears it down with itself; only the
    // Dart-side handle needs clearing here.
    _control = null;
  }
}

/// Layers [update] over [base], keeping [base]'s value for any field
/// [update] leaves `null`. This is what gives [ScaleBarController] its
/// partial-update behaviour.
ScaleBarSettings _merge(ScaleBarSettings base, ScaleBarSettings update) {
  return ScaleBarSettings(
    enabled: update.enabled ?? base.enabled,
    position: update.position ?? base.position,
    marginLeft: update.marginLeft ?? base.marginLeft,
    marginTop: update.marginTop ?? base.marginTop,
    marginRight: update.marginRight ?? base.marginRight,
    marginBottom: update.marginBottom ?? base.marginBottom,
    textColor: update.textColor ?? base.textColor,
    primaryColor: update.primaryColor ?? base.primaryColor,
    secondaryColor: update.secondaryColor ?? base.secondaryColor,
    borderWidth: update.borderWidth ?? base.borderWidth,
    height: update.height ?? base.height,
    textBarMargin: update.textBarMargin ?? base.textBarMargin,
    textBorderWidth: update.textBorderWidth ?? base.textBorderWidth,
    textSize: update.textSize ?? base.textSize,
    isMetricUnits: update.isMetricUnits ?? base.isMetricUnits,
    distanceUnits: update.distanceUnits ?? base.distanceUnits,
    refreshInterval: update.refreshInterval ?? base.refreshInterval,
    showTextBorder: update.showTextBorder ?? base.showTextBorder,
    ratio: update.ratio ?? base.ratio,
    useContinuousRendering:
        update.useContinuousRendering ?? base.useContinuousRendering,
  );
}
