// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('attribution margins and styling are applied as CSS', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final attribution = platformMap.attribution;
    final map = platformMap.jsMap;

    await attribution.updateSettings(
      AttributionSettings(
        marginLeft: 12,
        marginTop: 8,
        marginRight: 6,
        marginBottom: 5,
        iconColor: 0xFF102030,
        clickable: false,
      ),
    );

    // Assert on the computed values: the browser re-serializes them.
    final root = attributionElement(map)!;
    final computed = web.window.getComputedStyle(root);
    expect(computed.marginLeft, '12px');
    expect(computed.marginTop, '8px');
    expect(computed.marginRight, '6px');
    expect(computed.marginBottom, '5px');
    expect(computed.pointerEvents, 'none');

    await attribution.updateSettings(AttributionSettings(clickable: true));
    expect(
      web.window.getComputedStyle(attributionElement(map)!).pointerEvents,
      'auto',
    );

    final settings = await attribution.getSettings();
    expect(settings.marginLeft, 12);
    // Web cannot recolor the icon, but must still round-trip the value.
    expect(settings.iconColor, 0xFF102030);
    expect(settings.clickable, isTrue);
  });
}
