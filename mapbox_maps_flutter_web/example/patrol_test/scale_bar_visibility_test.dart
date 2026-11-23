// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('scale bar defaults, enabled and position', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final scaleBar = platformMap.scaleBar;
    final map = platformMap.jsMap;

    // Enabled by default, as on mobile, so the control starts attached and
    // `getSettings` reports the documented defaults rather than nulls.
    expect(scaleBarElement(map), isNotNull);
    final settings = await scaleBar.getSettings();
    expect(settings.enabled, isTrue);
    expect(settings.position, OrnamentPosition.TOP_LEFT);
    expect(settings.distanceUnits, DistanceUnits.METRIC);
    expect(settings.isMetricUnits, isTrue);
    expect(settings.ratio, 0.5);

    await scaleBar.updateSettings(ScaleBarSettings(enabled: false));
    expect(scaleBarElement(map), isNull);
    await scaleBar.updateSettings(ScaleBarSettings(enabled: true));
    expect(scaleBarElement(map), isNotNull);

    // Position moves the control between GL JS's corner containers.
    await scaleBar.updateSettings(
      ScaleBarSettings(position: OrnamentPosition.BOTTOM_LEFT),
    );
    expect(
      scaleBarElement(map)!.parentElement!.className,
      contains('mapboxgl-ctrl-bottom-left'),
    );
    await scaleBar.updateSettings(
      ScaleBarSettings(position: OrnamentPosition.TOP_RIGHT),
    );
    expect(
      scaleBarElement(map)!.parentElement!.className,
      contains('mapboxgl-ctrl-top-right'),
    );
  });
}
