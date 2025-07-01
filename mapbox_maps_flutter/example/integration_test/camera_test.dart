import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'app.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final initialCamera = CameraOptions(
    center: Point(coordinates: Position(0, 0)),
    padding: MbxEdgeInsets(top: 10, left: 20, bottom: 30, right: 40),
    zoom: 15,
    pitch: 60,
    bearing: 12,
  );

  group('camera get and set', () {
    testWidgets('set camera when creating a map', (WidgetTester tester) async {
      final mapFuture = app.main(camera: initialCamera);
      await tester.pumpAndSettle();
      final mapboxMap = await mapFuture;

      // Verify that the camera options are set correctly
      final camera = await mapboxMap.getCameraState();
      expect(camera.center.coordinates.lng,
          closeTo(initialCamera.center!.coordinates.lng, 0.0001));
      expect(camera.center.coordinates.lat,
          closeTo(initialCamera.center!.coordinates.lat, 0.0001));
      expect(camera.padding.top, closeTo(initialCamera.padding!.top, 0.0001));
      expect(camera.padding.left, closeTo(initialCamera.padding!.left, 0.0001));
      expect(camera.padding.bottom,
          closeTo(initialCamera.padding!.bottom, 0.0001));
      expect(
          camera.padding.right, closeTo(initialCamera.padding!.right, 0.0001));
      expect(camera.zoom, closeTo(initialCamera.zoom!, 0.0001));
      expect(camera.pitch, closeTo(initialCamera.pitch!, 0.0001));
      expect(camera.bearing, closeTo(initialCamera.bearing!, 0.0001));
    });

    testWidgets('set camera after map created', (tester) async {
      final mapFuture = app.main();
      await tester.pumpAndSettle();
      final mapboxMap = await mapFuture;

      // Set the camera options
      final cameraOptions = CameraOptions(
        center: Point(coordinates: Position(1, 1)),
        padding: MbxEdgeInsets(top: 10, left: 20, bottom: 30, right: 40),
        zoom: 15,
        pitch: 60,
        bearing: 12,
      );

      await mapboxMap.setCamera(cameraOptions);
      await tester.pumpAndSettle();

      final camera = await mapboxMap.getCameraState();
      expect(camera.center.coordinates.lng,
          closeTo(cameraOptions.center!.coordinates.lng, 0.0001));
      expect(camera.center.coordinates.lat,
          closeTo(cameraOptions.center!.coordinates.lat, 0.0001));
      expect(
          camera.padding.top, closeTo(cameraOptions.padding?.top ?? 0, 0.0001));
      expect(camera.padding.left, closeTo(cameraOptions.padding!.left, 0.0001));
      expect(camera.padding.bottom,
          closeTo(cameraOptions.padding!.bottom, 0.0001));
      expect(
          camera.padding.right, closeTo(cameraOptions.padding!.right, 0.0001));
      expect(camera.zoom, closeTo(cameraOptions.zoom!, 0.0001));
      expect(camera.pitch, closeTo(cameraOptions.pitch!, 0.0001));
      expect(camera.bearing, closeTo(cameraOptions.bearing!, 0.0001));
    });
  });
}
