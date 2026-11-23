import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  group('StyleColorList.toRGBAInt', () {
    test('decodes rgb expressions as fully opaque', () {
      final color = ["rgb", 10, 20, 30].toRGBAInt();
      expect(color, const Color.fromARGB(255, 10, 20, 30).toARGB32());
    });

    test('decodes rgba expressions with the given alpha', () {
      final color = ["rgba", 10, 20, 30, 0.2].toRGBAInt();
      expect(color, const Color.fromARGB(51, 10, 20, 30).toARGB32());
    });

    test('decodes hsl expressions with percentage saturation/lightness', () {
      // hsl(120, 100%, 50%) is pure green.
      final color = ["hsl", 120, 100, 50].toRGBAInt();
      expect(color, const Color.fromARGB(255, 0, 255, 0).toARGB32());
    });

    test('decodes hsla expressions with the given alpha', () {
      // hsl(0, 0%, 100%) is white regardless of hue/saturation.
      final color = ["hsla", 0, 0, 100, 0.2].toRGBAInt();
      expect(color, const Color.fromARGB(51, 255, 255, 255).toARGB32());
    });

    test('returns transparent black for unsupported expressions', () {
      final color = ["unknown", 1, 2, 3].toRGBAInt();
      expect(color, const Color(0x00000000).toARGB32());
    });
  });
}
