// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Size;
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'empty_map_widget.dart' as app;
import 'patrol.dart';
import 'utils/image_comparison.dart';

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

// `getImage()` must always return raw, premultiplied RGBA pixels via
// `StyleImageRgba`, regardless of how the image was encoded when added
// (here, PNG bytes via `StyleImage.bytes`). This file tests that contract
// directly, independent of any annotation code: the pixel count implied by
// `width`/`height`, and a pixel-exact round trip through
// addImage()/getImage().
void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest(
    'getImage returns raw RGBA pixels, not an encoded container',
    skip: kIsWeb,
    ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();

      const width = 4;
      const height = 4;
      // Fully opaque with three different, non-zero channel values. A channel
      // reordering bug (e.g. reading BGRA as RGBA) or a premultiplication bug
      // changes this color to a visibly different one, instead of silently
      // matching by coincidence the way a pure red/green/blue fixture could.
      const color = Color.fromARGB(255, 10, 90, 200);
      final sourcePng = await _solidColorPng(
        color,
        width: width,
        height: height,
      );

      await mapboxMap.addImage(
        'style-image-encoding-icon',
        1.0,
        StyleImage.bytes(sourcePng),
      );

      final styleImage = await mapboxMap.getImage('style-image-encoding-icon');
      expect(styleImage, isNotNull);

      // A compressed container is never exactly `4 * width * height` bytes
      // for a real image. This catches that case before the pixel
      // comparison below even runs.
      expect(
        styleImage!.pixels.length,
        4 * styleImage.width * styleImage.height,
        reason:
            'getImage() must return raw RGBA pixels, not a compressed '
            'image container',
      );

      // The round trip: the pixels read back must be the exact pixels
      // implied by the PNG that was added, not just the right byte count.
      expect(
        await isSameImage(
          styleImage.pixels,
          sourcePng,
          widthA: styleImage.width,
          heightA: styleImage.height,
        ),
        isTrue,
        reason: 'getImage() must round-trip the exact pixels that were added',
      );
    },
  );
}

/// Renders a solid-color square and encodes it as a PNG.
Future<Uint8List> _solidColorPng(
  Color color, {
  required int width,
  required int height,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    Paint()..color = color,
  );
  final image = await recorder.endRecording().toImage(width, height);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return byteData!.buffer.asUint8List();
}
