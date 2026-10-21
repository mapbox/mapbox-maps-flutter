// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../empty_map_widget.dart' as app;
import '../patrol.dart';

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

const _styleJson = '{"version": 8, "sources": {}, "layers": []}';

Future<MapboxMap> _setupMap(WidgetTester tester) async {
  final mapboxMap = await app.pumpMap(tester: tester, styleJson: _styleJson);
  await tester.pumpAndSettle();
  if (!app.events.onStyleLoaded.isCompleted) {
    await app.waitForEvent(
      tester,
      app.events.onStyleLoaded.future,
      description: () => 'style never finished loading',
    );
  }
  return mapboxMap;
}

Future<void> _setLights(MapboxMap mapboxMap) => mapboxMap.setLights(
  AmbientLight(id: 'ambient', color: 0xFFFF0000, intensity: 0.4),
  DirectionalLight(
    id: 'directional',
    direction: [210, 30],
    intensity: 0.7,
    castShadows: true,
  ),
);

/// Checks the kind of a light property value. iOS reports
/// [StylePropertyValueKind.CONSTANT], or [StylePropertyValueKind.TRANSITION]
/// for a transition, for every light property.
void _expectKind(StylePropertyValue value, StylePropertyValueKind kind) {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) return;
  expect(value.kind, kind);
}

/// Returns the value of a flat light property that the last `setLight` did
/// not set. Web returns the style-spec default, because GL JS cannot remove
/// the value of a light property.
Object? _unsetFlatLightValue(Object defaultValue) =>
    kIsWeb ? defaultValue : null;

Future<List<(String, String)>> _lights(MapboxMap mapboxMap) async => [
  for (final light in (await mapboxMap.getStyleLights()).nonNulls)
    (light.id, light.type),
];

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('a style without lights has no lights', ($) async {
    final mapboxMap = await _setupMap($.tester);

    expect(await _lights(mapboxMap), isEmpty);
  });

  patrolTest('setLights adds ambient and directional lights', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await _setLights(mapboxMap);

    expect(await _lights(mapboxMap), [
      ('ambient', 'ambient'),
      ('directional', 'directional'),
    ]);
  });

  patrolTest('getStyleLightProperty', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await _setLights(mapboxMap);

    final intensity = await mapboxMap.getStyleLightProperty(
      'ambient',
      'intensity',
    );
    expect(intensity.kind, StylePropertyValueKind.CONSTANT);
    expect(intensity.value, closeTo(0.4, 0.001));

    final color = await mapboxMap.getStyleLightProperty('ambient', 'color');
    _expectKind(color, StylePropertyValueKind.EXPRESSION);
    expect((color.value as List).toRGBAInt(), 0xFFFF0000);

    final castShadows = await mapboxMap.getStyleLightProperty(
      'directional',
      'cast-shadows',
    );
    expect(castShadows.value, true);
  });

  patrolTest('getStyleLightProperty returns null without a value', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await _setLights(mapboxMap);

    final color = await mapboxMap.getStyleLightProperty('directional', 'color');
    _expectKind(color, StylePropertyValueKind.UNDEFINED);
    expect(color.value, isNull);
    final transition = await mapboxMap.getStyleLightProperty(
      'ambient',
      'color-transition',
    );
    _expectKind(transition, StylePropertyValueKind.UNDEFINED);
    expect(transition.value, isNull);
    final unknownLight = await mapboxMap.getStyleLightProperty(
      'unknown',
      'intensity',
    );
    expect(unknownLight.value, isNull);
  });

  patrolTest('setStyleLightProperty keeps other properties and lights', (
    $,
  ) async {
    final mapboxMap = await _setupMap($.tester);
    await _setLights(mapboxMap);

    await mapboxMap.setStyleLightProperty('directional', 'intensity', 0.2);

    final intensity = await mapboxMap.getStyleLightProperty(
      'directional',
      'intensity',
    );
    expect(intensity.value, closeTo(0.2, 0.001));
    final castShadows = await mapboxMap.getStyleLightProperty(
      'directional',
      'cast-shadows',
    );
    expect(castShadows.value, true);
    final direction = await mapboxMap.getStyleLightProperty(
      'directional',
      'direction',
    );
    expect(direction.value, [210, 30]);
    final ambientIntensity = await mapboxMap.getStyleLightProperty(
      'ambient',
      'intensity',
    );
    expect(ambientIntensity.value, closeTo(0.4, 0.001));
    final ambientColor = await mapboxMap.getStyleLightProperty(
      'ambient',
      'color',
    );
    expect((ambientColor.value as List).toRGBAInt(), 0xFFFF0000);
  });

  patrolTest('setStyleLightProperty sets a color and a transition', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await _setLights(mapboxMap);

    await mapboxMap.setStyleLightProperty(
      'ambient',
      'color',
      'rgba(0, 255, 0, 1)',
    );
    await mapboxMap.setStyleLightProperty('ambient', 'color-transition', {
      'duration': 100,
      'delay': 5,
    });

    final color = await mapboxMap.getStyleLightProperty('ambient', 'color');
    expect((color.value as List).toRGBAInt(), 0xFF00FF00);
    final transition = await mapboxMap.getStyleLightProperty(
      'ambient',
      'color-transition',
    );
    expect(transition.kind, StylePropertyValueKind.TRANSITION);
    expect(transition.value, {'duration': 100, 'delay': 5});
  });

  patrolTest('setStyleLightProperty throws without lights', ($) async {
    final mapboxMap = await _setupMap($.tester);

    await expectLater(
      mapboxMap.setStyleLightProperty('ambient', 'intensity', 0.2),
      throwsA(isA<PlatformException>()),
    );
  });

  patrolTest('setStyleLightProperty throws for an unknown property', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await _setLights(mapboxMap);

    await expectLater(
      mapboxMap.setStyleLightProperty('ambient', 'unknown', 0.2),
      throwsA(isA<PlatformException>()),
    );
  });

  patrolTest('setStyleLightProperty ignores an unknown light', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await _setLights(mapboxMap);

    await mapboxMap.setStyleLightProperty('unknown', 'intensity', 0.2);
  });

  patrolTest('setLights replaces the lights', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await _setLights(mapboxMap);

    await mapboxMap.setLights(
      AmbientLight(id: 'ambient'),
      DirectionalLight(id: 'directional'),
    );

    final ambientColor = await mapboxMap.getStyleLightProperty(
      'ambient',
      'color',
    );
    expect(ambientColor.value, isNull);
    final castShadows = await mapboxMap.getStyleLightProperty(
      'directional',
      'cast-shadows',
    );
    expect(castShadows.value, isNull);
  });

  patrolTest('setLight sets a flat light', ($) async {
    final mapboxMap = await _setupMap($.tester);

    await mapboxMap.setLight(FlatLight(id: 'flat', intensity: 0.3));

    expect(await _lights(mapboxMap), [('flat', 'flat')]);
    final intensity = await mapboxMap.getStyleLightProperty(
      'flat',
      'intensity',
    );
    expect(intensity.value, closeTo(0.3, 0.001));
    final anchor = await mapboxMap.getStyleLightProperty('flat', 'anchor');
    expect(anchor.value, _unsetFlatLightValue('viewport'));
  });

  patrolTest('setLight sets the flat light anchor', ($) async {
    final mapboxMap = await _setupMap($.tester);

    await mapboxMap.setLight(FlatLight(id: 'flat', anchor: Anchor.MAP));

    final anchor = await mapboxMap.getStyleLightProperty('flat', 'anchor');
    expect(anchor.value, 'map');
  });

  patrolTest('setLight keeps the ambient and directional lights', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await _setLights(mapboxMap);

    await mapboxMap.setLight(FlatLight(id: 'flat', intensity: 0.3));

    expect(await _lights(mapboxMap), [
      ('ambient', 'ambient'),
      ('directional', 'directional'),
      ('flat', 'flat'),
    ]);
  });

  patrolTest('setLight replaces the flat light', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await mapboxMap.setLight(FlatLight(id: 'flat', intensity: 0.3));

    await mapboxMap.setLight(FlatLight(id: 'other'));

    expect(await _lights(mapboxMap), [('other', 'flat')]);
    final intensity = await mapboxMap.getStyleLightProperty(
      'other',
      'intensity',
    );
    expect(intensity.value, _unsetFlatLightValue(0.5));
  });

  patrolTest('setStyleLightProperty keeps other flat light properties', (
    $,
  ) async {
    final mapboxMap = await _setupMap($.tester);
    await mapboxMap.setLight(
      FlatLight(id: 'flat', anchor: Anchor.MAP, intensity: 0.3),
    );

    await mapboxMap.setStyleLightProperty('flat', 'intensity', 0.6);

    final intensity = await mapboxMap.getStyleLightProperty(
      'flat',
      'intensity',
    );
    expect(intensity.value, closeTo(0.6, 0.001));
    final anchor = await mapboxMap.getStyleLightProperty('flat', 'anchor');
    expect(anchor.value, 'map');
  });
}
