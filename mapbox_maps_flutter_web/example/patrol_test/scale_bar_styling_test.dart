// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('scale bar margins and styling are applied as CSS', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final scaleBar = platformMap.scaleBar;
    final map = platformMap.jsMap;

    await scaleBar.updateSettings(
      ScaleBarSettings(
        position: OrnamentPosition.TOP_LEFT,
        marginLeft: 12,
        marginTop: 8,
        textColor: 0xFF102030,
        secondaryColor: 0xFFFFFFFF,
        textSize: 11,
      ),
    );

    // The browser re-serializes what it is given, so assert on the computed
    // values rather than the exact strings the controller writes.
    final computed = web.window.getComputedStyle(scaleBarElement(map)!);
    expect(computed.marginLeft, '12px');
    expect(computed.marginTop, '8px');
    expect(computed.color, 'rgb(16, 32, 48)');
    expect(computed.backgroundColor, 'rgb(255, 255, 255)');
    expect(computed.fontSize, '11px');

    // A unit change goes through `setUnit`, so it must not replace the
    // control the styling was applied to.
    final before = scaleBarElement(map);
    await scaleBar.updateSettings(
      ScaleBarSettings(distanceUnits: DistanceUnits.IMPERIAL),
    );
    expect(
      scaleBarElement(map),
      same(before),
      reason: 'setUnit applies in place, so the element must be the same one',
    );
    expect(
      (await scaleBar.getSettings()).distanceUnits,
      DistanceUnits.IMPERIAL,
    );
  });
}
