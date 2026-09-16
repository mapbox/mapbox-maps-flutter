// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('logo visibility and defaults', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final logo = platformMap.logo;
    final map = platformMap.jsMap;

    // GL JS adds the logo to every map it builds, so it starts attached.
    expect(logoElement(map), isNotNull);
    var settings = await logo.getSettings();
    expect(settings.enabled, isTrue);
    expect(settings.position, OrnamentPosition.BOTTOM_LEFT);
    expect(settings.marginLeft, 8);
    expect(settings.marginTop, 8);
    expect(settings.marginRight, 8);
    expect(settings.marginBottom, 8);

    // The seeded position must match where GL JS put the logo.
    expect(cornerOf(logoRoot(map)!), contains('mapboxgl-ctrl-bottom-left'));

    await logo.updateSettings(LogoSettings(enabled: false));
    expect(web.window.getComputedStyle(logoRoot(map)!).visibility, 'hidden');

    // GL JS owns the control, so the link stays in the document.
    expect(
      logoElement(map),
      isNotNull,
      reason: 'hiding the logo must not detach it',
    );

    await logo.updateSettings(LogoSettings(enabled: true));
    expect(web.window.getComputedStyle(logoRoot(map)!).visibility, 'visible');

    settings = await logo.getSettings();
    expect(settings.enabled, isTrue);
  });
}
