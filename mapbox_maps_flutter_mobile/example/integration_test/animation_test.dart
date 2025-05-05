import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('easeTo', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    mapboxMap.easeTo(
        CameraOptions(
            padding: MbxEdgeInsets(left: 0, top: 0, right: 0, bottom: 0),
            anchor: ScreenCoordinate(x: 0, y: 0),
            center: Point(
                coordinates: Position(
              -0.11968,
              51.50325,
            )),
            zoom: 15,
            bearing: 0,
            pitch: 3),
        MapAnimationOptions(duration: 2000, startDelay: 0));
  });

  testWidgets('flyTo', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    mapboxMap.flyTo(
        CameraOptions(
            padding: MbxEdgeInsets(left: 0, top: 0, right: 0, bottom: 0),
            anchor: ScreenCoordinate(x: 0, y: 0),
            center: Point(
                coordinates: Position(
              -0.11968,
              51.50325,
            )),
            zoom: 15,
            bearing: 0,
            pitch: 3),
        MapAnimationOptions(duration: 2000, startDelay: 0));
  });

  if (Platform.isAndroid) {
    testWidgets('moveBy', (WidgetTester tester) async {
      final mapFuture = app.main();
      await tester.pumpAndSettle();
      final mapboxMap = await mapFuture;
      mapboxMap.moveBy(ScreenCoordinate(x: 500.0, y: 500.0),
          MapAnimationOptions(duration: 2000, startDelay: 0));
    });

    testWidgets('rotateBy', (WidgetTester tester) async {
      final mapFuture = app.main();
      await tester.pumpAndSettle();
      final mapboxMap = await mapFuture;
      mapboxMap.rotateBy(
          ScreenCoordinate(x: 0, y: 0),
          ScreenCoordinate(x: 500.0, y: 500.0),
          MapAnimationOptions(duration: 2000, startDelay: 0));
    });
    testWidgets('scaleBy', (WidgetTester tester) async {
      final mapFuture = app.main();
      await tester.pumpAndSettle();
      final mapboxMap = await mapFuture;
      mapboxMap.scaleBy(15.0, ScreenCoordinate(x: 10.0, y: 10.0),
          MapAnimationOptions(duration: 2000, startDelay: 0));
    });
    testWidgets('pitchBy', (WidgetTester tester) async {
      final mapFuture = app.main();
      await tester.pumpAndSettle();
      final mapboxMap = await mapFuture;
      mapboxMap.pitchBy(
          70.0, MapAnimationOptions(duration: 2000, startDelay: 0));
    });
  }
  testWidgets('cancelCameraAnimation', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    mapboxMap.cancelCameraAnimation();
    mapboxMap.flyTo(
        CameraOptions(
            padding: MbxEdgeInsets(left: 0, top: 0, right: 0, bottom: 0),
            anchor: ScreenCoordinate(x: 0, y: 0),
            center: Point(
                coordinates: Position(
              -0.11968,
              51.50325,
            )),
            zoom: 15,
            bearing: 0,
            pitch: 3),
        MapAnimationOptions(duration: 2000, startDelay: 0));
    mapboxMap.cancelCameraAnimation();
  });
}
