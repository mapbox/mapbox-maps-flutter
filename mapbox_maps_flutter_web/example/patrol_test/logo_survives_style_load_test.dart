// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:async';
import 'dart:js_interop';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('a hidden logo stays hidden across a style load', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final logo = platformMap.logo;
    final map = platformMap.jsMap;

    await logo.updateSettings(LogoSettings(enabled: false));
    expect(web.window.getComputedStyle(logoRoot(map)!).visibility, 'hidden');

    await platformMap.style.setStyleURI('mapbox://styles/mapbox/light-v11');
    final loaded = Completer<void>();
    map.once('idle', (() => loaded.complete()).toJS);
    await loaded.future;
    await $.tester.pumpAndSettle();

    // GL JS rewrites `display` on new source metadata, so a logo hidden
    // with `display` would be visible again by now.
    expect(
      web.window.getComputedStyle(logoRoot(map)!).visibility,
      'hidden',
      reason: 'the style load must not undo the hide',
    );
    expect((await logo.getSettings()).enabled, isFalse);
  });
}
