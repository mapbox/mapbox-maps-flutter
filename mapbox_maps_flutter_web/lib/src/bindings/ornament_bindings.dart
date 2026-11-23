@JS('mapboxgl')
library;

import 'dart:js_interop';

import 'location_bindings.dart' show JSControl;

/// Corner of the map a control is attached to, as accepted by
/// `Map.addControl`. Closed set — an invalid position won't compile.
///
/// GL JS also accepts the edge midpoints (`'top'`, `'right'`, `'bottom'`,
/// `'left'`), but [OrnamentPosition] has no counterpart for them, so only
/// the four corners are bound.
extension type const JSControlPosition._(String value) {
  static const JSControlPosition topLeft = JSControlPosition._('top-left');
  static const JSControlPosition topRight = JSControlPosition._('top-right');
  static const JSControlPosition bottomLeft = JSControlPosition._(
    'bottom-left',
  );
  static const JSControlPosition bottomRight = JSControlPosition._(
    'bottom-right',
  );
}

/// Unit system for [JSScaleControl]. Closed set, mirroring GL JS's `Unit`.
extension type const JSScaleUnit._(String value) {
  static const JSScaleUnit metric = JSScaleUnit._('metric');
  static const JSScaleUnit imperial = JSScaleUnit._('imperial');
  static const JSScaleUnit nautical = JSScaleUnit._('nautical');
}

/// Options passed to [JSScaleControl]'s constructor.
///
/// This is the control's entire configuration surface — GL JS's scale bar
/// has no options for colours, border widths or text sizing. Those
/// [ScaleBarSettings] fields are applied as CSS by the scale bar handler
/// instead.
@JS()
@anonymous
extension type JSScaleControlOptions._(JSObject _) implements JSObject {
  external factory JSScaleControlOptions({int? maxWidth, JSScaleUnit? unit});
}

/// `mapboxgl.ScaleControl`. Renders a scale bar that relabels itself as the
/// camera moves.
///
/// `maxWidth` is construction-only, so a change to it requires detaching and
/// re-adding the control; [setUnit] is the one option with a runtime setter.
@JS('ScaleControl')
extension type JSScaleControl._(JSObject _) implements JSControl {
  external JSScaleControl(JSScaleControlOptions options);

  external void setUnit(JSScaleUnit unit);
}

/// Options passed to [JSNavigationControl]'s constructor. All three are
/// construction-only in GL JS.
@JS()
@anonymous
extension type JSNavigationControlOptions._(JSObject _) implements JSObject {
  external factory JSNavigationControlOptions({
    bool? showCompass,
    bool? showZoom,
    bool? visualizePitch,
  });
}

/// `mapboxgl.NavigationControl`. GL JS has no standalone compass control —
/// the compass is a button inside this one, which is why the compass handler
/// constructs it with `showZoom: false`.
@JS('NavigationControl')
extension type JSNavigationControl._(JSObject _) implements JSControl {
  external JSNavigationControl(JSNavigationControlOptions options);
}
