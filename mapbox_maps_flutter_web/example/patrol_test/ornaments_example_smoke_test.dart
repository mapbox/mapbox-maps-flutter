// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  // Covers what the ornaments example page depends on: both implemented
  // ornaments are present on a plain map, and the two web does not implement
  // yet fail on their own without disturbing them.
  patrolTest('default ornaments survive an unimplemented one', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final map = platformMap.jsMap;

    // The scale bar and compass are enabled by default, as on mobile, so a
    // plain map shows both with no settings call at all.
    expect(scaleBarElement(map), isNotNull);
    expect(compassElement(map), isNotNull);
    expect((await platformMap.scaleBar.getSettings()).enabled, isTrue);
    expect((await platformMap.compass.getSettings()).enabled, isTrue);

    // Logo and attribution are not implemented on web yet. Confirm that is
    // still the case, so this starts failing once they land rather than
    // silently passing.
    //
    // The stubs throw synchronously (`=> throw ...`) rather than returning a
    // failed Future, so this catches rather than using `throwsA`, which only
    // matches an async error. The example page relies on the same: its
    // try/catch around `await` handles both shapes.
    expect(() => platformMap.logo.getSettings(), throwsUnimplementedError);
    expect(
      () => platformMap.attribution.getSettings(),
      throwsUnimplementedError,
    );

    // The implemented ornaments keep working regardless.
    await platformMap.scaleBar.updateSettings(ScaleBarSettings(ratio: 0.8));
    expect((await platformMap.scaleBar.getSettings()).ratio, 0.8);
    await platformMap.compass.updateSettings(CompassSettings(opacity: 0.4));
    expect((await platformMap.compass.getSettings()).opacity, 0.4);
  });
}
