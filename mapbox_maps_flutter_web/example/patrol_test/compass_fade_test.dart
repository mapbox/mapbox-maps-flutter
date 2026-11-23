// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:web/web.dart' as web;

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('fadeWhenFacingNorth hides the compass at bearing 0', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final compass = platformMap.compass;
    final map = platformMap.jsMap;

    await compass.updateSettings(
      CompassSettings(fadeWhenFacingNorth: true, opacity: 1),
    );

    map.jumpTo(JSCameraOptions()..bearing = 45);
    await $.tester.pumpAndSettle();
    expect(
      web.window.getComputedStyle(compassRoot(map)!).opacity,
      '1',
      reason: 'away from north the compass shows at its own opacity',
    );

    map.jumpTo(JSCameraOptions()..bearing = 0);
    await $.tester.pumpAndSettle();
    expect(
      web.window.getComputedStyle(compassRoot(map)!).opacity,
      '0',
      reason: 'facing north the compass fades out',
    );

    // With the fade off the compass stays put at any bearing.
    await compass.updateSettings(CompassSettings(fadeWhenFacingNorth: false));
    expect(web.window.getComputedStyle(compassRoot(map)!).opacity, '1');
  });
}
