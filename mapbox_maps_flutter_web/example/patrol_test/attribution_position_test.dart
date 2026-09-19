// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('attribution moves between corners', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final attribution = platformMap.attribution;
    final map = platformMap.jsMap;

    await attribution.updateSettings(
      AttributionSettings(position: OrnamentPosition.TOP_LEFT),
    );
    expect(
      cornerOf(attributionElement(map)!),
      contains('mapboxgl-ctrl-top-left'),
    );

    // A second element would mean the handler added its own control.
    expect(
      map.getContainer().querySelectorAll('.mapboxgl-ctrl-attrib').length,
      1,
      reason: 'the control is moved, never added a second time',
    );

    await attribution.updateSettings(
      AttributionSettings(position: OrnamentPosition.BOTTOM_LEFT),
    );
    expect(
      cornerOf(attributionElement(map)!),
      contains('mapboxgl-ctrl-bottom-left'),
    );
    expect(
      map.getContainer().querySelectorAll('.mapboxgl-ctrl-attrib').length,
      1,
    );

    // Margins set before the move must survive it.
    await attribution.updateSettings(AttributionSettings(marginBottom: 9));
    await attribution.updateSettings(
      AttributionSettings(position: OrnamentPosition.TOP_RIGHT),
    );
    final settings = await attribution.getSettings();
    expect(settings.marginBottom, 9);
    expect(settings.position, OrnamentPosition.TOP_RIGHT);
  });
}
