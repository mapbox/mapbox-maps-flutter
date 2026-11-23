// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:mapbox_maps_flutter_web/src/mapbox_map_web.dart';

import 'patrol.dart';
import 'test_utils.dart';

Future<JSMap> pumpMap(
  WidgetTester tester, {
  ValueListenable<String?>? language,
  ValueListenable<String?>? worldview,
}) async {
  final platformMap = await pumpMapTree(
    tester,
    (onCreated) => MaterialApp(
      home: Scaffold(
        body: MapWebWidget(
          styleUri: 'mapbox://styles/mapbox/standard',
          onMapCreated: onCreated,
          language: language,
          worldview: worldview,
        ),
      ),
    ),
  );
  return (platformMap as MapboxMapWeb).jsMap;
}

void main() {
  final options = MapboxMapsFlutterWeb();

  patrolTest('language and worldview apply to the map created next', ($) async {
    addTearDown(() {
      options.setLanguage(null);
      options.setWorldview(null);
    });

    options.setLanguage('fr');
    options.setWorldview('JP');

    expect(await options.getLanguage(), 'fr');
    expect(await options.getWorldview(), 'JP');

    final map = await pumpMap(
      $.tester,
      language: options.language,
      worldview: options.worldview,
    );
    expect(map.getLanguage(), 'fr');
    expect(map.getWorldview(), 'JP');
  });

  patrolTest('language and worldview apply to a map already on the page', (
    $,
  ) async {
    addTearDown(() {
      options.setLanguage(null);
      options.setWorldview(null);
    });

    final map = await pumpMap(
      $.tester,
      language: options.language,
      worldview: options.worldview,
    );

    options.setLanguage('de');
    options.setWorldview('US');

    expect(map.getLanguage(), 'de');
    expect(map.getWorldview(), 'US');
    expect(await options.getLanguage(), 'de');
    expect(await options.getWorldview(), 'US');
  });
}
