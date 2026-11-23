// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('attribution visibility and defaults', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final attribution = platformMap.attribution;
    final map = platformMap.jsMap;

    // GL JS adds the control to every map it builds, so it starts attached.
    expect(attributionElement(map), isNotNull);
    var settings = await attribution.getSettings();
    expect(settings.enabled, isTrue);
    expect(settings.position, OrnamentPosition.BOTTOM_RIGHT);
    expect(settings.marginLeft, 8);
    expect(settings.marginTop, 8);
    expect(settings.marginRight, 8);
    expect(settings.marginBottom, 8);
    expect(settings.iconColor, 0xFF1E8CAB);
    expect(settings.clickable, isTrue);

    // The seeded position must match where GL JS put the control.
    expect(
      cornerOf(attributionElement(map)!),
      contains('mapboxgl-ctrl-bottom-right'),
    );

    await attribution.updateSettings(AttributionSettings(enabled: false));
    expect(
      web.window.getComputedStyle(attributionElement(map)!).visibility,
      'hidden',
    );

    await attribution.updateSettings(AttributionSettings(enabled: true));
    expect(
      web.window.getComputedStyle(attributionElement(map)!).visibility,
      'visible',
    );

    settings = await attribution.getSettings();
    expect(settings.enabled, isTrue);
  });
}
