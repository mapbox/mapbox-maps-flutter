import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
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

    expect(updatedSettings.rotateEnabled, settings.rotateEnabled);
    expect(updatedSettings.pinchToZoomEnabled, settings.pinchToZoomEnabled);
    expect(updatedSettings.scrollEnabled, settings.scrollEnabled);
    expect(updatedSettings.simultaneousRotateAndPinchToZoomEnabled,
        settings.simultaneousRotateAndPinchToZoomEnabled);
    expect(updatedSettings.pitchEnabled, settings.pitchEnabled);
    expect(updatedSettings.scrollMode, settings.scrollMode);
    expect(updatedSettings.doubleTapToZoomInEnabled,
        settings.doubleTapToZoomInEnabled);
    expect(updatedSettings.doubleTouchToZoomOutEnabled,
        settings.doubleTouchToZoomOutEnabled);
    expect(updatedSettings.quickZoomEnabled, settings.quickZoomEnabled);
    expect(updatedSettings.focalPoint?.x, settings.focalPoint?.x);
    expect(updatedSettings.focalPoint?.y, settings.focalPoint?.y);
    expect(updatedSettings.pinchPanEnabled, settings.pinchPanEnabled);
    if (Platform.isAndroid) {
      expect(updatedSettings.increaseRotateThresholdWhenPinchingToZoom,
          settings.increaseRotateThresholdWhenPinchingToZoom);
      expect(updatedSettings.increasePinchToZoomThresholdWhenRotating,
          settings.increasePinchToZoomThresholdWhenRotating);
      expect(updatedSettings.pinchToZoomDecelerationEnabled,
          settings.pinchToZoomDecelerationEnabled);
      expect(updatedSettings.rotateDecelerationEnabled,
          settings.rotateDecelerationEnabled);
      expect(updatedSettings.scrollDecelerationEnabled,
          settings.scrollDecelerationEnabled);
      expect(updatedSettings.zoomAnimationAmount, settings.zoomAnimationAmount);
    }
  });

  testWidgets('RecognizeTapEvent', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    var point = await mapboxMap
        .pixelForCoordinate(Point(coordinates: Position(0.01, 0.01)));
    mapboxMap.dispatch("click", point);

    await app.events.onMapTapListener.future;
    var tapContext = app.events.mapInteractions[0];

    expect(tapContext.gestureState, GestureState.ended);
    expect(tapContext.touchPosition.x, closeTo(point.x, 1e-4));
    expect(tapContext.touchPosition.y, closeTo(point.y, 1e-4));
    expect(tapContext.point.coordinates.lat, closeTo(0.01, 1e-4));
    expect(tapContext.point.coordinates.lng, closeTo(0.01, 1e-4));
  });

  testWidgets('RecognizeLongTapEvent', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    var point = await mapboxMap
        .pixelForCoordinate(Point(coordinates: Position(-0.01, -0.01)));
    mapboxMap.dispatch("longClick", point);

    await app.events.onMapLongTapListener.future;
    var tapContext = app.events.mapInteractions[0];

    expect(tapContext.gestureState, GestureState.ended);
    expect(tapContext.touchPosition.x, closeTo(point.x, 1e-4));
    expect(tapContext.touchPosition.y, closeTo(point.y, 1e-4));
    expect(tapContext.point.coordinates.lat, closeTo(-0.01, 1e-4));
    expect(tapContext.point.coordinates.lng, closeTo(-0.01, 1e-4));
  });
}
