// AndroidPlatformViewHostingMode is @experimental on the platform_interface.
// ignore_for_file: experimental_member_use

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  group('MapWidget.androidHostingMode', () {
    // This is the single source of truth for the default Android platform-view
    // hosting mode: the platform packages take it as a required parameter, so
    // this constructor default is the only place the value is declared.
    test('defaults to HC', () {
      expect(
        const MapWidget().androidHostingMode,
        AndroidPlatformViewHostingMode.HC,
      );
    });

    test('honors an explicitly provided hosting mode', () {
      expect(
        const MapWidget(
          androidHostingMode: AndroidPlatformViewHostingMode.VD,
        ).androidHostingMode,
        AndroidPlatformViewHostingMode.VD,
      );
    });
  });
}
