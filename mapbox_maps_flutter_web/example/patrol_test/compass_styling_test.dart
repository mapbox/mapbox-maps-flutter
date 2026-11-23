// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:web/web.dart' as web;

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('compass margins, opacity, clickable and image', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final compass = platformMap.compass;
    final map = platformMap.jsMap;
    await faceAwayFromNorth($.tester, map);

    await compass.updateSettings(
      CompassSettings(
        position: OrnamentPosition.TOP_LEFT,
        marginLeft: 7,
        marginTop: 5,
        opacity: 0.5,
        clickable: false,
      ),
    );

    // These style the whole control, not just the button inside it — styling
    // the button stretches and fades it within a group box that stays put.
    final computed = web.window.getComputedStyle(compassRoot(map)!);
    expect(computed.marginLeft, '7px');
    expect(computed.marginTop, '5px');
    expect(computed.opacity, '0.5');
    expect(computed.pointerEvents, 'none');
    expect(
      web.window.getComputedStyle(compassElement(map)!).marginLeft,
      '0px',
      reason: 'the button itself must carry no margin',
    );

    // A custom needle, and an empty list to restore the default.
    await compass.updateSettings(CompassSettings(image: onePixelPng));
    final icon =
        compassElement(map)!.querySelector('.mapboxgl-ctrl-icon')
            as web.HTMLElement;
    expect(icon.style.backgroundImage, contains('blob:'));
    await compass.updateSettings(CompassSettings(image: Uint8List(0)));
    expect(icon.style.backgroundImage, isEmpty);

    // `rotation` is the one field with no web counterpart: GL JS rewrites
    // the needle's transform on every camera change.
    await compass.updateSettings(CompassSettings(rotation: 45));
    expect((await compass.getSettings()).rotation, 45);
  });
}
