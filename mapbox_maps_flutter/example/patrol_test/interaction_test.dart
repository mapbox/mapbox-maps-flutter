// dispatch() is @visibleForTesting; the analyzer does not treat patrol_test/
// as a test directory (unlike test/ and integration_test/), so its
// visible-for-testing check fires here even though this is a test.
// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';

import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('TapInteraction.onMap fires on dispatched click', ($) async {
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();

    final completer = Completer<MapContentGestureContext>();
    const id = 'tap-interaction';
    mapboxMap.addInteraction(
      TapInteraction.onMap((context) {
        completer.ensureCompletedOnce(context);
      }),
      interactionID: id,
    );

    await mapboxMap.dispatch('click', ScreenCoordinate(x: 10, y: 10));

    final context = await completer.future.timeout(const Duration(seconds: 3));
    expect(context.touchPosition.x, closeTo(10, 1e-4));
    expect(context.touchPosition.y, closeTo(10, 1e-4));

    mapboxMap.removeInteraction(id);
    await mapboxMap.dispatch('click', ScreenCoordinate(x: 10, y: 10));
    await Future.delayed(const Duration(milliseconds: 500));
  });

  patrolTest(
    'LongTapInteraction.onMap fires on dispatched longClick',
    skip: kIsWeb,
    ($) async {
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await $.tester.pumpAndSettle();

      final completer = Completer<MapContentGestureContext>();
      const id = 'long-tap-interaction';
      mapboxMap.addInteraction(
        LongTapInteraction.onMap((context) {
          completer.ensureCompletedOnce(context);
        }),
        interactionID: id,
      );

      await mapboxMap.dispatch('longClick', ScreenCoordinate(x: 10, y: 10));

      final context = await completer.future.timeout(
        const Duration(seconds: 3),
      );
      expect(context.touchPosition.x, closeTo(10, 1e-4));
      expect(context.touchPosition.y, closeTo(10, 1e-4));

      mapboxMap.removeInteraction(id);
      await mapboxMap.dispatch('longClick', ScreenCoordinate(x: 10, y: 10));
      await Future.delayed(const Duration(milliseconds: 500));
    },
  );
}
