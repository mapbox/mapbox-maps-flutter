// AndroidPlatformViewHostingMode is @experimental on the platform_interface.
// ignore_for_file: experimental_member_use

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

void main() {
  group('MapWidget.isOpaque assert', () {
    test('throws when isOpaque:false and textureView:false', () {
      expect(
        () => MapWidget(
          isOpaque: false,
          textureView: false,
          androidHostingMode: AndroidPlatformViewHostingMode.HC,
        ),
        throwsAssertionError,
      );
    });

    test('allows isOpaque:false with textureView:true', () {
      expect(
        () => MapWidget(
          isOpaque: false,
          textureView: true,
          androidHostingMode: AndroidPlatformViewHostingMode.HC,
        ),
        returnsNormally,
      );
    });

    test('allows isOpaque:false with default textureView', () {
      expect(
        () => MapWidget(
          isOpaque: false,
          androidHostingMode: AndroidPlatformViewHostingMode.HC,
        ),
        returnsNormally,
      );
    });

    test('allows isOpaque:true with textureView:false', () {
      expect(
        () => MapWidget(
          isOpaque: true,
          textureView: false,
          androidHostingMode: AndroidPlatformViewHostingMode.HC,
        ),
        returnsNormally,
      );
    });

    test('defaults to opaque', () {
      expect(
        MapWidget(androidHostingMode: AndroidPlatformViewHostingMode.HC)
            .isOpaque,
        isTrue,
      );
    });
  });
}
