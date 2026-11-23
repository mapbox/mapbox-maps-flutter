// ignore_for_file: experimental_member_use
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart' show Color;
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../empty_map_widget.dart' as app;
import '../patrol.dart';

const _accessToken = String.fromEnvironment('ACCESS_TOKEN');

const _red = Color(0xFFFF0000);

/// A style with one solid red background layer.
const _redStyle = '''
{
  "version": 8,
  "sources": {},
  "layers": [
    {"id": "bg", "type": "background", "paint": {"background-color": "#ff0000"}}
  ]
}
''';

const _emptyStyle = '{"version": 8, "sources": {}, "layers": []}';

/// Builds a 2x2x2 LUT (a 4x2 PNG strip) that maps every color to [color].
Future<ColorTheme> _solidLut(Color color) async {
  const width = 4, height = 2;
  final pixels = Uint8List(width * height * 4);
  for (var i = 0; i < pixels.length; i += 4) {
    pixels[i] = (color.r * 255).round();
    pixels[i + 1] = (color.g * 255).round();
    pixels[i + 2] = (color.b * 255).round();
    pixels[i + 3] = 255;
  }
  final completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    pixels,
    width,
    height,
    ui.PixelFormat.rgba8888,
    completer.complete,
  );
  final image = await completer.future;
  final png = await image.toByteData(format: ui.ImageByteFormat.png);
  return ColorTheme.base64(base64Encode(png!.buffer.asUint8List()));
}

/// Returns the RGB color at the center of the map snapshot.
Future<Color> _centerColor(MapboxMap map) async {
  final codec = await ui.instantiateImageCodec(await map.snapshot());
  final image = (await codec.getNextFrame()).image;
  final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  final offset = ((image.height ~/ 2) * image.width + image.width ~/ 2) * 4;
  final bytes = data!.buffer.asUint8List();
  return Color.fromARGB(
    255,
    bytes[offset],
    bytes[offset + 1],
    bytes[offset + 2],
  );
}

Matcher _closeTo(Color expected) => predicate<Color>(
  (c) =>
      (c.r - expected.r).abs() < 0.1 &&
      (c.g - expected.g).abs() < 0.1 &&
      (c.b - expected.b).abs() < 0.1,
  'is close to $expected',
);

Future<MapboxMap> _pumpStyle(PatrolIntegrationTester $, String styleJson) {
  final tester = $.tester;
  return tester.retryOnTimeout(() async {
    final map = await app.pumpMap(tester: tester, styleJson: styleJson);
    await tester.pumpAndSettle();
    await app.waitForEvent(tester, app.events.onMapIdle.future);
    return map;
  });
}

Future<void> _settle(PatrolIntegrationTester $) async {
  app.events.resetOnMapIdle();
  await $.tester.pump();
  await app.waitForEvent($.tester, app.events.onMapIdle.future);
}

void main() {
  setUpAll(() {
    MapboxOptions.setAccessToken(_accessToken);
  });

  patrolTest('a color theme recolors the map', ($) async {
    final map = await _pumpStyle($, _redStyle);
    expect(await _centerColor(map), _closeTo(_red));

    await map.setStyleColorTheme(await _solidLut(const Color(0xFF0000FF)));
    await _settle($);

    expect(await _centerColor(map), _closeTo(const Color(0xFF0000FF)));
  });

  patrolTest('a color with use-theme none ignores the color theme', ($) async {
    final map = await _pumpStyle($, _redStyle);
    await map.setStyleLayerProperty(
      'bg',
      'background-color-use-theme',
      ColorUseTheme.none.value,
    );
    await map.setStyleColorTheme(await _solidLut(const Color(0xFF0000FF)));
    await _settle($);

    expect(await _centerColor(map), _closeTo(_red));
  });

  patrolTest('removing the color theme restores the original colors', (
    $,
  ) async {
    final map = await _pumpStyle($, _redStyle);
    await map.setStyleColorTheme(await _solidLut(const Color(0xFF0000FF)));
    await _settle($);
    await map.setStyleColorTheme(null);
    await _settle($);

    expect(await _centerColor(map), _closeTo(_red));
  });

  patrolTest('an import color theme recolors only that import', ($) async {
    final map = await _pumpStyle($, _emptyStyle);
    await map.addStyleImportFromJSON('fragment', _redStyle);
    await _settle($);
    await map.setStyleImportColorTheme(
      'fragment',
      await _solidLut(const Color(0xFF00FF00)),
    );
    await _settle($);

    expect(await _centerColor(map), _closeTo(const Color(0xFF00FF00)));
  });
}
