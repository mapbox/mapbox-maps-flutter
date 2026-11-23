// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('logo margins are applied to the wrapper', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final logo = platformMap.logo;
    final map = platformMap.jsMap;

    await logo.updateSettings(
      LogoSettings(
        marginLeft: 12,
        marginTop: 8,
        marginRight: 6,
        marginBottom: 5,
      ),
    );

    // Assert on the computed values: the browser re-serializes them.
    final computed = web.window.getComputedStyle(logoRoot(map)!);
    expect(computed.marginLeft, '12px');
    expect(computed.marginTop, '8px');
    expect(computed.marginRight, '6px');
    expect(computed.marginBottom, '5px');

    // GL JS gives the link a negative margin, which must stay.
    final link = web.window.getComputedStyle(logoElement(map)!);
    expect(link.marginLeft, isNot('12px'));

    final settings = await logo.getSettings();
    expect(settings.marginLeft, 12);
    expect(settings.marginBottom, 5);
  });
}
