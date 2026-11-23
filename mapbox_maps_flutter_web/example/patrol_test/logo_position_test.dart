// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('logo moves between corners', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final logo = platformMap.logo;
    final map = platformMap.jsMap;

    await logo.updateSettings(
      LogoSettings(position: OrnamentPosition.TOP_RIGHT),
    );
    expect(cornerOf(logoRoot(map)!), contains('mapboxgl-ctrl-top-right'));

    // A second logo would mean the element was copied, not moved.
    expect(
      map.getContainer().querySelectorAll('.mapboxgl-ctrl-logo').length,
      1,
      reason: 'the logo is moved, never duplicated',
    );

    await logo.updateSettings(
      LogoSettings(position: OrnamentPosition.BOTTOM_RIGHT),
    );
    expect(cornerOf(logoRoot(map)!), contains('mapboxgl-ctrl-bottom-right'));
    expect(
      map.getContainer().querySelectorAll('.mapboxgl-ctrl-logo').length,
      1,
    );

    final settings = await logo.getSettings();
    expect(settings.position, OrnamentPosition.BOTTOM_RIGHT);
  });
}
