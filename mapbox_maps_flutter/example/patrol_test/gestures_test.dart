// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter_examples/platform.dart'
    show isAndroid, isMobile;
import 'patrol.dart';
import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('Gestures settings', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    final gestures = mapboxMap.gestures;
    var settings = GesturesSettings(
      rotateEnabled: false,
      pinchToZoomEnabled: true,
      scrollEnabled: false,
      simultaneousRotateAndPinchToZoomEnabled: false,
      pitchEnabled: true,
      scrollMode: ScrollMode.HORIZONTAL,
      doubleTapToZoomInEnabled: false,
      doubleTouchToZoomOutEnabled: true,
      quickZoomEnabled: true,
      focalPoint: ScreenCoordinate(x: 10, y: 10),
      pinchToZoomDecelerationEnabled: false,
      rotateDecelerationEnabled: true,
      scrollDecelerationEnabled: false,
      increaseRotateThresholdWhenPinchingToZoom: true,
      increasePinchToZoomThresholdWhenRotating: true,
      zoomAnimationAmount: 42,
      pinchPanEnabled: true,
    );

    await gestures.updateSettings(settings);
    final updatedSettings = await gestures.getSettings();

    // Supported platforms: mobile, web.
    expect(updatedSettings.rotateEnabled, settings.rotateEnabled);
    expect(updatedSettings.pinchToZoomEnabled, settings.pinchToZoomEnabled);
    expect(updatedSettings.scrollEnabled, settings.scrollEnabled);
    expect(updatedSettings.pitchEnabled, settings.pitchEnabled);
    expect(
      updatedSettings.doubleTapToZoomInEnabled,
      settings.doubleTapToZoomInEnabled,
    );

    if (isMobile) {
      // Supported platforms: mobile.
      expect(
        updatedSettings.simultaneousRotateAndPinchToZoomEnabled,
        settings.simultaneousRotateAndPinchToZoomEnabled,
      );
      expect(updatedSettings.scrollMode, settings.scrollMode);
      expect(
        updatedSettings.doubleTouchToZoomOutEnabled,
        settings.doubleTouchToZoomOutEnabled,
      );
      expect(updatedSettings.quickZoomEnabled, settings.quickZoomEnabled);
      expect(updatedSettings.focalPoint?.x, settings.focalPoint?.x);
      expect(updatedSettings.focalPoint?.y, settings.focalPoint?.y);
      expect(updatedSettings.pinchPanEnabled, settings.pinchPanEnabled);

      if (isAndroid) {
        expect(
          updatedSettings.increaseRotateThresholdWhenPinchingToZoom,
          settings.increaseRotateThresholdWhenPinchingToZoom,
        );
        expect(
          updatedSettings.increasePinchToZoomThresholdWhenRotating,
          settings.increasePinchToZoomThresholdWhenRotating,
        );
        expect(
          updatedSettings.pinchToZoomDecelerationEnabled,
          settings.pinchToZoomDecelerationEnabled,
        );
        expect(
          updatedSettings.rotateDecelerationEnabled,
          settings.rotateDecelerationEnabled,
        );
        expect(
          updatedSettings.scrollDecelerationEnabled,
          settings.scrollDecelerationEnabled,
        );
        expect(
          updatedSettings.zoomAnimationAmount,
          settings.zoomAnimationAmount,
        );
      }
    }
  });

  patrolTest(
    'Gestures settings partial update preserves other fields',
    skip: !isMobile,
    ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      final gestures = mapboxMap.gestures;

      await gestures.updateSettings(
        GesturesSettings(
          rotateEnabled: false,
          scrollDecelerationEnabled: false,
        ),
      );
      final baseline = await gestures.getSettings();
      expect(baseline.rotateEnabled, false);
      expect(baseline.scrollDecelerationEnabled, false);

      await gestures.updateSettings(
        GesturesSettings(scrollDecelerationEnabled: true),
      );
      final updated = await gestures.getSettings();

      expect(updated.scrollDecelerationEnabled, true);
      expect(
        updated.rotateEnabled,
        baseline.rotateEnabled,
        reason:
            'A partial update only sets scrollDecelerationEnabled and must not reset rotateEnabled back to its default value.',
      );
    },
  );
}
