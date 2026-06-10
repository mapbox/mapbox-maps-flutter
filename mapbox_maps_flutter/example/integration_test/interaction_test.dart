// ignore_for_file: experimental_member_use
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TapInteraction.onMap fires on dispatched click', (
    WidgetTester tester,
  ) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

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

  testWidgets(
    'LongTapInteraction.onMap fires on dispatched longClick',
    skip: kIsWeb,
    (WidgetTester tester) async {
      final mapFuture = app.main();
      await tester.pumpAndSettle();
      final mapboxMap = await mapFuture;

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
