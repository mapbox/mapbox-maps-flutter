import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  group('MapWidget.isOpaque assert', () {
    test('throws when isOpaque:false and textureView:false', () {
      expect(() => MapWidget(isOpaque: false, textureView: false),
          throwsAssertionError);
    });

    test('allows isOpaque:false with textureView:true', () {
      expect(
          () => MapWidget(isOpaque: false, textureView: true), returnsNormally);
    });

    test('allows isOpaque:false with default textureView', () {
      expect(() => MapWidget(isOpaque: false), returnsNormally);
    });

    test('allows isOpaque:true with textureView:false', () {
      expect(
          () => MapWidget(isOpaque: true, textureView: false), returnsNormally);
    });

    test('defaults to opaque', () {
      expect(MapWidget().isOpaque, isTrue);
    });
  });
}
