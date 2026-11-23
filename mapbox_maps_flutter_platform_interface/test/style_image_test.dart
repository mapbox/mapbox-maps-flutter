import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

Future<ui.Image> _decodeImage(int width, int height, Uint8List rgba) {
  final completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    rgba,
    width,
    height,
    ui.PixelFormat.rgba8888,
    completer.complete,
  );
  return completer.future;
}

void main() {
  group('StyleImage.fromImage', () {
    test('reads the source image as premultiplied RGBA pixels', () async {
      // Fully opaque pixels: premultiplication is a no-op, so the bytes
      // round-trip exactly.
      final pixels = Uint8List.fromList(const [
        255, 0, 0, 255, //
        0, 255, 0, 255, //
        0, 0, 255, 255, //
        255, 255, 0, 255, //
      ]);
      final image = await _decodeImage(2, 2, pixels);
      addTearDown(image.dispose);

      final styleImage = await StyleImage.fromImage(image);

      expect(
        styleImage,
        StyleImage.rgba(width: 2, height: 2, pixels: pixels),
      );
    });
  });
}
