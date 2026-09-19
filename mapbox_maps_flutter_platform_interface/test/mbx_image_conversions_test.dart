import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

void main() {
  group('MbxImage.toStyleImage', () {
    test('treats data as rgba when length matches width * height * 4', () {
      final pixels = Uint8List.fromList(const [1, 2, 3, 4]);
      final image = MbxImage(width: 1, height: 1, data: pixels);

      expect(image.toStyleImage(), StyleImage.rgba(width: 1, height: 1, pixels: pixels));
    });

    test('treats data as encoded bytes otherwise', () {
      final png = Uint8List.fromList(const [
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
        0, 0, 0, 0,
      ]);
      final image = MbxImage(width: 0, height: 0, data: png);

      expect(image.toStyleImage(), StyleImage.bytes(png));
    });

    test('treats larger rgba data as rgba, not bytes', () {
      final pixels = Uint8List(16);
      final image = MbxImage(width: 2, height: 2, data: pixels);

      expect(image.toStyleImage(), StyleImage.rgba(width: 2, height: 2, pixels: pixels));
    });
  });

  group('StyleImage.toMbxImage', () {
    test('rgba round-trips width, height, and pixels', () {
      final pixels = Uint8List.fromList(const [1, 2, 3, 4]);
      final image = StyleImage.rgba(width: 1, height: 1, pixels: pixels);

      final mbxImage = image.toMbxImage();
      expect(mbxImage.width, 1);
      expect(mbxImage.height, 1);
      expect(mbxImage.data, pixels);
    });

    test('bytes round-trips with width/height set to 0', () {
      final bytes = Uint8List.fromList(const [1, 2, 3]);
      final image = StyleImage.bytes(bytes);

      final mbxImage = image.toMbxImage();
      expect(mbxImage.width, 0);
      expect(mbxImage.height, 0);
      expect(mbxImage.data, bytes);
    });
  });
}
