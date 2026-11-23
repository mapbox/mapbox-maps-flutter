import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../empty_map_widget.dart' as app;
import '../patrol.dart';
import '../utils/image_comparison.dart';

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

/// A black background and one point at the center of the view. A symbol
/// layer draws the point with the icon [iconImage], large enough to cover the
/// center pixel of a snapshot.
String _symbolStyle(String iconImage) => jsonEncode({
  'version': 8,
  'center': [0, 0],
  'zoom': 1,
  'sources': {
    'point': {
      'type': 'geojson',
      'data': {
        'type': 'Feature',
        'properties': {},
        'geometry': {
          'type': 'Point',
          'coordinates': [0, 0],
        },
      },
    },
  },
  'layers': [
    {
      'id': 'background',
      'type': 'background',
      'paint': {'background-color': '#000000'},
    },
    {
      'id': 'icon',
      'type': 'symbol',
      'source': 'point',
      'layout': {
        'icon-image': iconImage,
        'icon-allow-overlap': true,
        'icon-ignore-placement': true,
      },
    },
  ],
});

/// A black background and an image source with no initial image that
/// covers the center of the view.
final _imageSourceStyle = jsonEncode({
  'version': 8,
  'center': [0, 0],
  'zoom': 1,
  'sources': {
    'image': {
      'type': 'image',
      'coordinates': [
        [-40, 40],
        [40, 40],
        [40, -40],
        [-40, -40],
      ],
    },
  },
  'layers': [
    {
      'id': 'background',
      'type': 'background',
      'paint': {'background-color': '#000000'},
    },
    {
      'id': 'image',
      'type': 'raster',
      'source': 'image',
      'paint': {'raster-fade-duration': 0},
    },
  ],
});

/// A solid, premultiplied RGBA image.
StyleImageRgba _solidRgba(int size, List<int> rgba) {
  final alpha = rgba[3];
  final premultiplied = [
    for (final channel in rgba.take(3)) (channel * alpha / 255).round(),
    alpha,
  ];
  return StyleImageRgba(
    width: size,
    height: size,
    pixels: Uint8List.fromList([
      for (var i = 0; i < size * size; i++) ...premultiplied,
    ]),
  );
}

/// A solid PNG image.
Future<Uint8List> _solidPng(int size, ui.Color color) async {
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder).drawColor(color, ui.BlendMode.src);
  final image = await recorder.endRecording().toImage(size, size);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return data!.buffer.asUint8List();
}

Future<List<int>> _renderedCenter(
  PatrolIntegrationTester $,
  MapboxMap map,
) async {
  app.events.resetOnMapIdle();
  await map.triggerRepaint();
  await app.waitForEvent($.tester, app.events.onMapIdle.future);
  return centerPixel(await map.snapshot());
}

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('getImage round-trips premultiplied pixels and size', ($) async {
    final map = await app.pumpMap(tester: $.tester);

    // A half-transparent pixel checks that premultiplication survives the
    // round trip. The opaque pixel checks the channel order.
    final pixels = Uint8List.fromList([10, 90, 200, 255, 60, 30, 0, 128]);
    await map.addImage(
      'round-trip',
      2.0,
      StyleImage.rgba(width: 2, height: 1, pixels: pixels),
    );

    final image = await map.getImage('round-trip');
    expect(image, isNotNull);
    expect(image!.width, 2);
    expect(image.height, 1);
    for (var i = 0; i < pixels.length; i++) {
      // Straight-alpha storage can change a premultiplied channel by one.
      expect(image.pixels[i], closeTo(pixels[i], 1), reason: 'byte $i');
    }
  });

  patrolTest('getImage returns null for an unknown id', ($) async {
    final map = await app.pumpMap(tester: $.tester);
    expect(await map.getImage('does-not-exist'), isNull);
  });

  patrolTest('addImage applies sdf, stretch, content and scale', ($) async {
    final map = await app.pumpMap(
      tester: $.tester,
      styleJson: _symbolStyle('options'),
    );

    await map.addImage(
      'options',
      2.0,
      _solidRgba(64, const [255, 255, 255, 255]),
      sdf: true,
      stretchX: [ImageStretches(first: 16, second: 48)],
      stretchY: [ImageStretches(first: 16, second: 48)],
      content: ImageContent(left: 16, top: 16, right: 48, bottom: 48),
    );
    await map.setStyleLayerProperty('icon', 'icon-color', '#00ff00');

    expect(await map.hasStyleImage('options'), isTrue);
    final center = await _renderedCenter($, map);
    // The SDF icon takes the green icon-color.
    expect(center[1], greaterThan(200), reason: 'center pixel $center');
    expect(center[0], lessThan(50), reason: 'center pixel $center');
  });

  patrolTest('addImage replaces an image of the same size', ($) async {
    final map = await app.pumpMap(
      tester: $.tester,
      styleJson: _symbolStyle('replace'),
    );

    await map.addImage('replace', 1.0, _solidRgba(32, const [255, 0, 0, 255]));
    expect((await _renderedCenter($, map)).take(3), [255, 0, 0]);

    await map.addImage('replace', 1.0, _solidRgba(32, const [0, 0, 255, 255]));
    final image = await map.getImage('replace');
    expect(image!.pixels.take(4), [0, 0, 255, 255]);
    expect((await _renderedCenter($, map)).take(3), [0, 0, 255]);
  });

  patrolTest('addImage replaces an image with a new size', ($) async {
    final map = await app.pumpMap(tester: $.tester);

    await map.addImage('resize', 1.0, _solidRgba(8, const [255, 0, 0, 255]));
    await map.addImage('resize', 1.0, _solidRgba(16, const [0, 255, 0, 255]));

    final image = await map.getImage('resize');
    expect(image!.width, 16);
    expect(image.height, 16);
    expect(image.pixels.take(4), [0, 255, 0, 255]);
  });

  patrolTest('onStyleImageMissing reports the id and accepts the image', (
    $,
  ) async {
    final map = await app.pumpMap(
      tester: $.tester,
      styleJson: _symbolStyle('missing-x'),
    );

    final id = await app.waitForEvent(
      $.tester,
      app.events.onStyleImageMissing.future,
    );
    expect(id, 'missing-x');

    await map.addImage(
      'missing-x',
      1.0,
      _solidRgba(32, const [255, 0, 0, 255]),
    );
    await map.setCamera(
      CameraOptions(center: Point(coordinates: Position(0, 0)), zoom: 1),
    );
    expect((await _renderedCenter($, map)).take(3), [255, 0, 0]);
  });

  patrolTest('updateImageForSource accepts RGBA and encoded images', ($) async {
    final map = await app.pumpMap(
      tester: $.tester,
      styleJson: _imageSourceStyle,
    );

    await map.updateImageForSource(
      'image',
      _solidRgba(4, const [255, 0, 0, 255]),
    );
    expect((await _renderedCenter($, map)).take(3), [255, 0, 0]);

    await map.updateImageForSource(
      'image',
      StyleImage.bytes(await _solidPng(4, const ui.Color(0xFF0000FF))),
    );
    expect((await _renderedCenter($, map)).take(3), [0, 0, 255]);
  });

  patrolTest('updateImageForSource throws for a source of another type', (
    $,
  ) async {
    final map = await app.pumpMap(
      tester: $.tester,
      styleJson: _symbolStyle('unused'),
    );

    await expectLater(
      map.updateImageForSource('point', _solidRgba(4, const [0, 0, 0, 255])),
      throwsA(anything),
    );
  });
}
