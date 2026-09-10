// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('compass visibility, position and defaults', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final compass = platformMap.compass;
    final map = platformMap.jsMap;

    // Enabled by default, as on mobile, so the control starts attached and
    // `getSettings` reports the documented defaults rather than nulls.
    expect(compassElement(map), isNotNull);
    var settings = await compass.getSettings();
    expect(settings.enabled, isTrue);
    expect(settings.visibility, isTrue);
    expect(settings.position, OrnamentPosition.TOP_RIGHT);
    expect(settings.marginLeft, 4);
    expect(settings.marginTop, 4);
    expect(settings.marginRight, 4);
    expect(settings.marginBottom, 4);
    expect(settings.opacity, 1);
    expect(settings.rotation, 0);
    expect(settings.fadeWhenFacingNorth, isTrue);
    expect(settings.clickable, isTrue);

    // GL JS bundles the compass with zoom buttons; the ornament is only a
    // compass, so those must not come with it.
    expect(
      map.getContainer().querySelectorAll('.mapboxgl-ctrl-zoom-in').length,
      0,
    );

    // `enabled` and `visibility` are one state, and neither may strand the
    // other: hiding through one must not stop the other showing it again.
    await compass.updateSettings(CompassSettings(enabled: false));
    expect(compassElement(map), isNull);
    await compass.updateSettings(CompassSettings(visibility: true));
    expect(compassElement(map), isNotNull);
    await compass.updateSettings(CompassSettings(visibility: false));
    expect(compassElement(map), isNull);
    await compass.updateSettings(CompassSettings(enabled: true));
    expect(compassElement(map), isNotNull);

    settings = await compass.getSettings();
    expect(settings.enabled, isTrue);
    expect(settings.visibility, isTrue);

    // Position moves the control between GL JS's corner containers.
    await compass.updateSettings(
      CompassSettings(position: OrnamentPosition.BOTTOM_RIGHT),
    );
    expect(
      compassRoot(map)!.parentElement!.className,
      contains('mapboxgl-ctrl-bottom-right'),
    );
    await compass.updateSettings(
      CompassSettings(position: OrnamentPosition.TOP_LEFT),
    );
    expect(
      compassRoot(map)!.parentElement!.className,
      contains('mapboxgl-ctrl-top-left'),
    );
  });
}
