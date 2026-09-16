// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  // The ornaments share the corner containers GL JS keeps per position, so
  // exercise them together the way the ornaments example page does.
  patrolTest('the ornaments coexist in one corner', ($) async {
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

    // Attribution and the logo start in opposite bottom corners.
    expect(
      cornerOf(attributionElement(map)!),
      contains('mapboxgl-ctrl-bottom-right'),
    );
    expect(cornerOf(logoRoot(map)!), contains('mapboxgl-ctrl-bottom-left'));

    // Moving attribution onto the logo must leave both in place.
    await platformMap.attribution.updateSettings(
      AttributionSettings(position: OrnamentPosition.BOTTOM_LEFT),
    );
    expect(
      cornerOf(attributionElement(map)!),
      contains('mapboxgl-ctrl-bottom-left'),
    );
    expect(
      logoElement(map),
      isNotNull,
      reason: 'moving attribution must not displace the logo',
    );

    // Removing one must leave the others in place.
    await platformMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    expect(scaleBarElement(map), isNull);
    expect(
      compassElement(map),
      isNotNull,
      reason: 'disabling the scale bar must not remove the compass',
    );
    expect(attributionElement(map), isNotNull);
    expect(logoElement(map), isNotNull);
  });
}
