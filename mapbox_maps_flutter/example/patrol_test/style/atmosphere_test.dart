// ignore_for_file: experimental_member_use
import 'package:flutter/foundation.dart';
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

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('a style without atmosphere, snow and rain', ($) async {
    final mapboxMap = await _setupMap($.tester);

    expect(await mapboxMap.getStyleAtmosphere(), isNull);
    expect(await mapboxMap.getStyleSnow(), isNull);
    expect(await mapboxMap.getStyleRain(), isNull);
  });

  patrolTest('setStyleAtmosphere and getStyleAtmosphere', ($) async {
    final mapboxMap = await _setupMap($.tester);

    await mapboxMap.setStyleAtmosphere(
      Atmosphere(
        color: 0xFFFF0000,
        highColor: 0xFF0000FF,
        starIntensity: 0.5,
        colorUseTheme: ColorUseTheme.none,
        range: [1.0, 8.0],
      ),
    );

    final atmosphere = await mapboxMap.getStyleAtmosphere();
    expect(atmosphere, isNotNull);
    expect(atmosphere!.color, 0xFFFF0000);
    expect(atmosphere.highColor, 0xFF0000FF);
    expect(atmosphere.starIntensity, closeTo(0.5, 1e-6));
    expect(atmosphere.colorUseTheme, ColorUseTheme.none);
    expect(atmosphere.range, [1.0, 8.0]);
  });

  patrolTest('setStyleAtmosphere with an expression', ($) async {
    final mapboxMap = await _setupMap($.tester);
    final expression = [
      'interpolate',
      ['linear'],
      ['zoom'],
      5,
      0.4,
      6,
      0.0,
    ];

    await mapboxMap.setStyleAtmosphere(
      Atmosphere(starIntensityExpression: expression),
    );

    final atmosphere = await mapboxMap.getStyleAtmosphere();
    expect(atmosphere?.starIntensityExpression, expression);
    expect(atmosphere?.starIntensity, isNull);
  });

  patrolTest('setStyleAtmosphere null removes the atmosphere', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await mapboxMap.setStyleAtmosphere(Atmosphere(starIntensity: 0.5));

    await mapboxMap.setStyleAtmosphere(null);

    expect(await mapboxMap.getStyleAtmosphere(), isNull);
  });

  patrolTest('setStyleAtmosphereProperty changes one property', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await mapboxMap.setStyleAtmosphere(
      Atmosphere(color: 0xFFFF0000, starIntensity: 0.5),
    );

    await mapboxMap.setStyleAtmosphereProperty('star-intensity', 0.2);

    final atmosphere = await mapboxMap.getStyleAtmosphere();
    expect(atmosphere?.starIntensity, closeTo(0.2, 1e-6));
    expect(atmosphere?.color, 0xFFFF0000);
  });

  patrolTest('setStyleSnow and getStyleSnow', ($) async {
    final mapboxMap = await _setupMap($.tester);

    await mapboxMap.setStyleSnow(
      Snow(
        intensity: 0.8,
        color: 0xFF00FF00,
        colorUseTheme: ColorUseTheme.none,
        direction: [10.0, 40.0],
      ),
    );

    final snow = await mapboxMap.getStyleSnow();
    expect(snow, isNotNull);
    expect(snow!.intensity, closeTo(0.8, 1e-6));
    expect(snow.color, 0xFF00FF00);
    // GL JS has no use-theme properties for snow.
    expect(snow.colorUseTheme, kIsWeb ? isNull : ColorUseTheme.none);
    expect(snow.direction, [10.0, 40.0]);
  });

  patrolTest('setStyleSnow null removes the snow', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await mapboxMap.setStyleSnow(Snow(intensity: 0.8));

    await mapboxMap.setStyleSnow(null);

    expect(await mapboxMap.getStyleSnow(), isNull);
  });

  patrolTest('setStyleSnowProperty changes one property', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await mapboxMap.setStyleSnow(Snow(intensity: 0.8, opacity: 0.5));

    await mapboxMap.setStyleSnowProperty('opacity', 0.9);

    final snow = await mapboxMap.getStyleSnow();
    expect(snow?.opacity, closeTo(0.9, 1e-6));
    expect(snow?.intensity, closeTo(0.8, 1e-6));
  });

  patrolTest('setStyleRain and getStyleRain', ($) async {
    final mapboxMap = await _setupMap($.tester);

    await mapboxMap.setStyleRain(
      Rain(
        intensity: 0.8,
        vignetteColor: 0xFF0000FF,
        vignetteColorUseTheme: ColorUseTheme.none,
        dropletSize: [2.0, 10.0],
      ),
    );

    final rain = await mapboxMap.getStyleRain();
    expect(rain, isNotNull);
    expect(rain!.intensity, closeTo(0.8, 1e-6));
    expect(rain.vignetteColor, 0xFF0000FF);
    // GL JS has no use-theme properties for rain.
    expect(rain.vignetteColorUseTheme, kIsWeb ? isNull : ColorUseTheme.none);
    expect(rain.dropletSize, [2.0, 10.0]);
  });

  patrolTest('setStyleRain null removes the rain', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await mapboxMap.setStyleRain(Rain(intensity: 0.8));

    await mapboxMap.setStyleRain(null);

    expect(await mapboxMap.getStyleRain(), isNull);
  });

  patrolTest('setStyleRainProperty changes one property', ($) async {
    final mapboxMap = await _setupMap($.tester);
    await mapboxMap.setStyleRain(Rain(intensity: 0.8, opacity: 0.5));

    await mapboxMap.setStyleRainProperty('opacity', 0.9);

    final rain = await mapboxMap.getStyleRain();
    expect(rain?.opacity, closeTo(0.9, 1e-6));
    expect(rain?.intensity, closeTo(0.8, 1e-6));
  });
}
