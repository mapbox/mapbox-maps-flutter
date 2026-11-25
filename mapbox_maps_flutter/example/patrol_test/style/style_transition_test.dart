import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../empty_map_widget.dart' as app;
import '../patrol.dart';

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

const _styleJson = '{"version": 8, "sources": {}, "layers": []}';

const _otherStyleJson = '''
{
  "version": 8,
  "sources": {},
  "layers": [{"id": "background", "type": "background"}]
}
''';

Future<void> _waitForStyleLoaded(WidgetTester tester) async {
  await tester.pumpAndSettle();
  if (!app.events.onStyleLoaded.isCompleted) {
    await app.waitForEvent(
      tester,
      app.events.onStyleLoaded.future,
      description: () => 'style never finished loading',
    );
  }
}

Future<MapboxMap> _setupMap(WidgetTester tester) async {
  final mapboxMap = await app.pumpMap(tester: tester, styleJson: _styleJson);
  await _waitForStyleLoaded(tester);
  return mapboxMap;
}

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('a style without a transition has the default transition', (
    $,
  ) async {
    final mapboxMap = await _setupMap($.tester);

    final transition = await mapboxMap.getStyleTransition();

    expect(transition.duration, 300);
    expect(transition.delay, 0);
  });

  patrolTest('setStyleTransition sets all the options', ($) async {
    final mapboxMap = await _setupMap($.tester);

    await mapboxMap.setStyleTransition(
      TransitionOptions(
        duration: 1000,
        delay: 50,
        enablePlacementTransitions: false,
      ),
    );
    final transition = await mapboxMap.getStyleTransition();

    expect(transition.duration, 1000);
    expect(transition.delay, 50);
    expect(transition.enablePlacementTransitions, false);
  });

  patrolTest('a new style removes the transition override', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await mapboxMap.setStyleTransition(
      TransitionOptions(
        duration: 1000,
        delay: 50,
        enablePlacementTransitions: false,
      ),
    );

    // GL JS applies a small style change in place and sends no style loaded
    // event for it. All platforms send a style data loaded event.
    app.events.resetOnStyleDataLoaded();
    await mapboxMap.setStyleJSON(_otherStyleJson);
    await app.waitForEvent(
      $.tester,
      app.events.onStyleDataLoaded.future,
      description: () => 'the new style never loaded',
    );
    final transition = await mapboxMap.getStyleTransition();

    expect(transition.duration, 300);
    expect(transition.delay, 0);
    expect(transition.enablePlacementTransitions, isNot(false));
  });
}
