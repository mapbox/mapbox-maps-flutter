// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:async';
import 'dart:js_interop';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:mapbox_maps_flutter_web/src/bindings/style_bindings.dart';
import 'package:mapbox_maps_flutter_web/src/mapbox_map_web.dart';

import 'ornament_test_utils.dart';
import 'patrol.dart';

const _styleJson = '{"version": 8, "sources": {}, "layers": []}';

const _styleWithTransitionJson = '''
{
  "version": 8,
  "transition": {"duration": 500, "delay": 0},
  "sources": {},
  "layers": [{"id": "background", "type": "background"}]
}
''';

Future<void> _loadStyle(
  WidgetTester tester,
  MapboxMapWeb platformMap,
  String styleJson,
) async {
  await platformMap.style.setStyleJSON(styleJson);
  final idle = Completer<void>();
  platformMap.jsMap.once('idle', (() => idle.complete()).toJS);
  await idle.future;
  await tester.pumpAndSettle();
}

void main() {
  patrolTest('labels fade for the transition duration', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    await _loadStyle($.tester, platformMap, _styleJson);

    await platformMap.style.setStyleTransition(
      TransitionOptions(duration: 1000, delay: 0),
    );

    expect(platformMap.jsMap.getFadeDuration(), 1000);
  });

  patrolTest('labels do not fade without placement transitions', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    await _loadStyle($.tester, platformMap, _styleJson);

    await platformMap.style.setStyleTransition(
      TransitionOptions(
        duration: 1000,
        delay: 0,
        enablePlacementTransitions: false,
      ),
    );

    expect(platformMap.jsMap.getFadeDuration(), 0);
  });

  patrolTest('a transition set while a style loads does not keep the fade', (
    $,
  ) async {
    final platformMap = await pumpOrnamentMap($.tester);
    await _loadStyle($.tester, platformMap, _styleJson);

    final loaded = _loadStyle($.tester, platformMap, _styleWithTransitionJson);
    await platformMap.style.setStyleTransition(
      TransitionOptions(duration: 1000, delay: 0),
    );
    await loaded;

    expect(
      platformMap.jsMap.getFadeDuration(),
      (await platformMap.style.getStyleTransition()).duration,
    );
  });

  patrolTest('a new style sets the label fade to its transition duration', (
    $,
  ) async {
    final platformMap = await pumpOrnamentMap($.tester);
    await _loadStyle($.tester, platformMap, _styleJson);
    await platformMap.style.setStyleTransition(
      TransitionOptions(
        duration: 1000,
        delay: 0,
        enablePlacementTransitions: false,
      ),
    );

    await _loadStyle($.tester, platformMap, _styleWithTransitionJson);

    expect(platformMap.jsMap.getFadeDuration(), 500);
    expect(
      (await platformMap.style.getStyleTransition()).enablePlacementTransitions,
      isTrue,
    );
  });
}
