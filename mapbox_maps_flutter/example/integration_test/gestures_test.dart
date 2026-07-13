// ignore_for_file: experimental_member_use
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter_examples/platform.dart'
    show isAndroid, isMobile;
import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Gestures settings', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
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

  testWidgets(
    'Gestures settings partial update preserves other fields',
    skip: !isMobile,
    (WidgetTester tester) async {
      final mapFuture = app.main();
      await tester.pumpAndSettle();
      final mapboxMap = await mapFuture;
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
