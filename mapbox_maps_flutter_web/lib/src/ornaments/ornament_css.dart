import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import '../bindings/map_bindings.dart';

/// Maps an [OrnamentPosition] onto the GL JS control corner it corresponds to.
JSControlPosition toJSControlPosition(OrnamentPosition? position) =>
    switch (position) {
      OrnamentPosition.TOP_LEFT => JSControlPosition.topLeft,
      OrnamentPosition.TOP_RIGHT => JSControlPosition.topRight,
      OrnamentPosition.BOTTOM_LEFT => JSControlPosition.bottomLeft,
      OrnamentPosition.BOTTOM_RIGHT => JSControlPosition.bottomRight,
      null => JSControlPosition.topLeft,
    };

/// Formats an ARGB integer as a CSS color.
///
/// The settings APIs carry colors as `0xAARRGGBB`, matching the value of
/// Flutter's `Color`.
String cssColor(int argb) {
  final alpha = (argb >> 24) & 0xFF;
  final red = (argb >> 16) & 0xFF;
  final green = (argb >> 8) & 0xFF;
  final blue = argb & 0xFF;
  final opacity = (alpha / 255 * 100).round();
  return 'rgb($red $green $blue / $opacity%)';
}

/// Applies the four per-side margins to [element] as CSS margins.
///
/// GL JS stacks controls inside a per-corner container, so a control's
/// margin is its offset from that corner. Only the two sides that face the
/// corner have a visible effect — for example, `marginRight` does nothing
/// at [OrnamentPosition.TOP_LEFT]. The inactive values are still applied, so
/// they take effect as soon as the ornament moves to a corner where they
/// matter.
void applyMargins(
  web.HTMLElement element, {
  double? marginLeft,
  double? marginTop,
  double? marginRight,
  double? marginBottom,
}) {
  if (marginLeft case final value?) {
    element.style.marginLeft = '${value}px';
  }
  if (marginTop case final value?) {
    element.style.marginTop = '${value}px';
  }
  if (marginRight case final value?) {
    element.style.marginRight = '${value}px';
  }
  if (marginBottom case final value?) {
    element.style.marginBottom = '${value}px';
  }
}

/// Finds the element GL JS created for a control, by the class it stamps on
/// it.
///
/// GL JS keeps the control's root element private, so the DOM is the only
/// way to reach it. The search is scoped to this map's own container, so a
/// second map on the page cannot be picked up by mistake.
web.HTMLElement? findControlElement(JSMap map, String selector) =>
    map.getContainer().querySelector(selector) as web.HTMLElement?;
