// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  // Covers what the ornaments example page depends on: every ornament the
  // page offers is present on a plain map, and each one takes an update
  // without disturbing the others.
  patrolTest('every default ornament is present and settable', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final map = platformMap.jsMap;

    // All four are enabled by default, as on mobile.
    expect(scaleBarElement(map), isNotNull);
    expect(compassElement(map), isNotNull);
    expect(attributionElement(map), isNotNull);
    expect(logoElement(map), isNotNull);

    expect((await platformMap.scaleBar.getSettings()).enabled, isTrue);
    expect((await platformMap.compass.getSettings()).enabled, isTrue);
    expect((await platformMap.attribution.getSettings()).enabled, isTrue);
    expect((await platformMap.logo.getSettings()).enabled, isTrue);

    // A partial update on each must keep the field it sets.
    await platformMap.scaleBar.updateSettings(ScaleBarSettings(ratio: 0.8));
    expect((await platformMap.scaleBar.getSettings()).ratio, 0.8);

    await platformMap.compass.updateSettings(CompassSettings(opacity: 0.4));
    expect((await platformMap.compass.getSettings()).opacity, 0.4);

    await platformMap.attribution.updateSettings(
      AttributionSettings(marginBottom: 7),
    );
    expect((await platformMap.attribution.getSettings()).marginBottom, 7);

    await platformMap.logo.updateSettings(LogoSettings(marginLeft: 6));
    expect((await platformMap.logo.getSettings()).marginLeft, 6);

    // The indoor selector is the one settings sub-interface left
    // unimplemented on web. Confirm that is still the case, so this starts
    // failing once it lands rather than silently passing.
    //
    // The stub throws synchronously (`=> throw ...`) rather than returning a
    // failed Future, so this catches rather than using `throwsA`, which only
    // matches an async error. The example page relies on the same: its
    // try/catch around `await` handles both shapes.
    expect(
      () => platformMap.indoorSelector.getSettings(),
      throwsUnimplementedError,
    );

    // The implemented ornaments keep working regardless.
    expect(scaleBarElement(map), isNotNull);
    expect(web.window.getComputedStyle(logoRoot(map)!).visibility, 'visible');
  });
}
