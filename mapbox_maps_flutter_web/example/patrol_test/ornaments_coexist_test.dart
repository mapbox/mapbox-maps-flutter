// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  // Both ornaments share the corner containers GL JS keeps per position, so
  // exercise them together the way the ornaments example page does.
  patrolTest('the scale bar and compass coexist in one corner', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final map = platformMap.jsMap;

    await platformMap.scaleBar.updateSettings(
      ScaleBarSettings(position: OrnamentPosition.TOP_LEFT),
    );
    await platformMap.compass.updateSettings(
      CompassSettings(position: OrnamentPosition.TOP_LEFT),
    );

    expect(scaleBarElement(map), isNotNull);
    expect(compassElement(map), isNotNull);

    // Removing one must leave the other in place.
    await platformMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    expect(scaleBarElement(map), isNull);
    expect(
      compassElement(map),
      isNotNull,
      reason: 'disabling the scale bar must not remove the compass',
    );
  });
}
