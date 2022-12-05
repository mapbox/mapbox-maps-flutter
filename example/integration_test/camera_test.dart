import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;
import 'package:turf/helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> addDelay(int ms) async {
    await Future<void>.delayed(Duration(milliseconds: ms));
  }

  testWidgets('cameraForCoordinateBounds', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await addDelay(1000);

    var camera = await mapboxMap.cameraForCoordinateBounds(
        CoordinateBounds(
            southwest: Point(
                coordinates: Position(
              1.0,
              2.0,
            )).toJson(),
            northeast: Point(
                coordinates: Position(
              3.0,
              4.0,
            )).toJson(),
            infiniteBounds: true),
        MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
        10,
        20);
    expect(camera.bearing, 10);
    expect(camera.pitch, 20);
    expect(camera.padding!.top, 1);
    expect(camera.padding!.left, 2);
    expect(camera.padding!.bottom, 3);
    expect(camera.padding!.right, 4);
    // TODO zoom might be different depending whether surface has changed the size
    // expect(camera.zoom!.round(), 7);
    var coordinates = camera.center!["coordinates"] as List;
    expect((coordinates.first as double).round(), 2);
    expect((coordinates.last as double).round(), 3);
    expect(camera.anchor, isNull);
    await addDelay(1000);
  });

  testWidgets('cameraForCoordinates', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await addDelay(1000);

    var camera = await mapboxMap.cameraForCoordinates([
      Point(
          coordinates: Position(
        1.0,
        2.0,
      )).toJson(),
      Point(
          coordinates: Position(
        3.0,
        4.0,
      )).toJson()
    ], MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4), 10, 20);
    expect(camera.bearing, 10);
    expect(camera.pitch, 20);
    expect(camera.padding!.top, 1);
    expect(camera.padding!.left, 2);
    expect(camera.padding!.bottom, 3);
    expect(camera.padding!.right, 4);
    // TODO zoom might be different depending whether surface has changed the size
    // expect(camera.zoom!.round(), 7);
    var coordinates = camera.center!["coordinates"] as List;
    expect((coordinates.first as double).round(), 2);
    expect((coordinates.last as double).round(), 3);
    expect(camera.anchor, isNull);
    await addDelay(1000);
  });

  testWidgets('cameraForCoordinatesCameraOptions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await addDelay(3000);

    var option = CameraOptions(
        center: Point(
            coordinates: Position(
          1.0,
          2.0,
        )).toJson(),
        padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
        anchor: ScreenCoordinate(x: 1, y: 1),
        zoom: 10,
        bearing: 20,
        pitch: 30);
    var camera = await mapboxMap.cameraForCoordinatesCameraOptions(
        [
          Point(
              coordinates: Position(
            1.0,
            2.0,
          )).toJson(),
          Point(
              coordinates: Position(
            3.0,
            4.0,
          )).toJson()
        ],
        option,
        ScreenBox(
            min: ScreenCoordinate(x: 0, y: 0),
            max: ScreenCoordinate(x: 100, y: 100)));
    expect(camera.zoom, 10);
    expect(camera.bearing, 20);
    expect(camera.pitch, 30);
    expect(camera.padding!.top, 1);
    expect(camera.padding!.left, 2);
    expect(camera.padding!.bottom, 3);
    expect(camera.padding!.right, 4);
    expect(camera.zoom!.round(), 10);
    var coordinates = camera.center!["coordinates"] as List;
    expect((coordinates.first as double).round(), 1);
    expect((coordinates.last as double).round(), 2);
    expect(camera.anchor!.x, 1);
    expect(camera.anchor!.y, 1);
    await addDelay(1000);
  });

  testWidgets('cameraForGeometry', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var camera = await mapboxMap.cameraForGeometry({
      "type": "Point",
      "coordinates": [1, 2]
    }, MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4), 10, 20);
    expect(camera.bearing, 10);
    expect(camera.pitch, 20);
    expect(camera.padding!.top, 1);
    expect(camera.padding!.left, 2);
    expect(camera.padding!.bottom, 3);
    expect(camera.padding!.right, 4);
    // TODO zoom might be different depending whether surface has changed the size
    // expect(camera.zoom!.round(), 21);
    var coordinates = camera.center!["coordinates"] as List;
    expect((coordinates.first as double).round(), 1);
    expect((coordinates.last as double).round(), 2);
    expect(camera.anchor, isNull);
    await addDelay(1000);
  });

  testWidgets('coordinateBoundsForCamera', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var option = CameraOptions(
        center: Point(
            coordinates: Position(
          1.0,
          2.0,
        )).toJson(),
        padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
        anchor: ScreenCoordinate(x: 1, y: 1),
        zoom: 10,
        bearing: 20,
        pitch: 30);
    var camera = await mapboxMap.coordinateBoundsForCamera(option);
    expect(camera.infiniteBounds, false);
    var northeast = camera.northeast['coordinates'] as List;
    var southwest = camera.southwest['coordinates'] as List;
    expect(northeast.length, 2);
    expect(southwest.length, 2);
    expect((northeast.first as double).round(), 1);
    expect((northeast.last as double).round(), 2);
    expect((southwest.first as double).round(), 1);
    expect((southwest.last as double).round(), 2);
    await addDelay(1000);
  });

  testWidgets('coordinateBoundsForCameraUnwrapped',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var option = CameraOptions(
        center: Point(
            coordinates: Position(
          1.0,
          2.0,
        )).toJson(),
        padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
        anchor: ScreenCoordinate(x: 1, y: 1),
        zoom: 10,
        bearing: 20,
        pitch: 30);
    var camera = await mapboxMap.coordinateBoundsForCameraUnwrapped(option);
    expect(camera.infiniteBounds, false);
    var northeast = camera.northeast['coordinates'] as List;
    var southwest = camera.southwest['coordinates'] as List;
    expect(northeast.length, 2);
    expect(southwest.length, 2);
    expect((northeast.first as double).round(), 1);
    expect((northeast.last as double).round(), 2);
    expect((southwest.first as double).round(), 1);
    expect((southwest.last as double).round(), 2);
    await addDelay(1000);
  });
  testWidgets('coordinateBoundsZoomForCamera', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var option = CameraOptions(
        center: Point(
            coordinates: Position(
          1.0,
          2.0,
        )).toJson(),
        padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
        anchor: ScreenCoordinate(x: 1, y: 1),
        zoom: 10,
        bearing: 20,
        pitch: 30);
    var coordinate = await mapboxMap.coordinateBoundsZoomForCamera(option);
    expect(coordinate.zoom, 10);
    expect(coordinate.bounds.infiniteBounds, false);
    var northeast = coordinate.bounds.northeast['coordinates'] as List;
    var southwest = coordinate.bounds.southwest['coordinates'] as List;
    expect((northeast.first as double).round(), 1);
    expect((northeast.last as double).round(), 2);
    expect((southwest.first as double).round(), 1);
    expect((southwest.last as double).round(), 2);
    await addDelay(1000);
  });
  testWidgets('coordinateBoundsZoomForCameraUnwrapped',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var option = CameraOptions(
        center: Point(
            coordinates: Position(
          1.0,
          2.0,
        )).toJson(),
        padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
        anchor: ScreenCoordinate(x: 1, y: 1),
        zoom: 10,
        bearing: 20,
        pitch: 30);
    var coordinate =
        await mapboxMap.coordinateBoundsZoomForCameraUnwrapped(option);
    expect(coordinate.zoom, 10);
    expect(coordinate.bounds.infiniteBounds, false);
    var northeast = coordinate.bounds.northeast['coordinates'] as List;
    var southwest = coordinate.bounds.southwest['coordinates'] as List;
    expect((northeast.first as double).round(), 1);
    expect((northeast.last as double).round(), 2);
    expect((southwest.first as double).round(), 1);
    expect((southwest.last as double).round(), 2);
    await addDelay(1000);
  });
  testWidgets('pixelForCoordinate', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    var pixel = await mapboxMap.pixelForCoordinate(Point(
        coordinates: Position(
      1.0,
      2.0,
    )).toJson());
    expect(pixel.x, isNotNull);
    expect(pixel.y, isNotNull);
    await addDelay(1000);
  });
  testWidgets('pixelsForCoordinates', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    var pixels = await mapboxMap.pixelsForCoordinates([
      Point(
          coordinates: Position(
        1.0,
        2.0,
      )).toJson(),
      Point(
          coordinates: Position(
        2.0,
        3.0,
      )).toJson()
    ]);
    expect(pixels.length, 2);
    expect(pixels.first!.x, isNotNull);
    expect(pixels.first!.y, isNotNull);
    expect(pixels.last!.x, isNotNull);
    expect(pixels.last!.y, isNotNull);
    await addDelay(1000);
  });

  testWidgets('coordinateForPixel', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    var point =
        await mapboxMap.coordinateForPixel(ScreenCoordinate(x: 100, y: 100));
    var coordinates = point['coordinates'] as List;
    expect(coordinates.length, 2);
    await addDelay(1000);
  });
  testWidgets('coordinatesForPixels', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    List<Map<String?, Object?>?> coordinates = await mapboxMap
        .coordinatesForPixels([
      ScreenCoordinate(x: 100, y: 100),
      ScreenCoordinate(x: 200, y: 300)
    ]);
    expect(coordinates.length, 2);
    await addDelay(1000);
  });

  testWidgets('setCamera', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    await addDelay(1000);
    final mapboxMap = await mapFuture;
    var option = CameraOptions(
        center: Point(
            coordinates: Position(
          1.0,
          2.0,
        )).toJson(),
        padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
        anchor: ScreenCoordinate(x: 1, y: 1),
        zoom: 10,
        bearing: 20,
        pitch: 30);
    await mapboxMap.setCamera(option);
    await addDelay(1000);
  });

  testWidgets('getCameraState', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    await addDelay(5000);
    final mapboxMap = await mapFuture;
    var cameraState = await mapboxMap.getCameraState();
    expect(cameraState.zoom.floor(), 0);
    expect(cameraState.pitch, 0);
    expect(cameraState.bearing, 0);
    var coordinates = cameraState.center['coordinates'] as List;
    expect(coordinates.first, 0);
    expect(coordinates.last, 0);
    expect(cameraState.padding.top, 0);
    expect(cameraState.padding.right, 0);
    expect(cameraState.padding.bottom, 0);
    expect(cameraState.padding.left, 0);

    await addDelay(1000);
  });
  testWidgets('setBounds', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await mapboxMap.setBounds(CameraBoundsOptions(
        bounds: CoordinateBounds(
            southwest: Point(
                coordinates: Position(
              1.0,
              2.0,
            )).toJson(),
            northeast: Point(
                coordinates: Position(
              3.0,
              4.0,
            )).toJson(),
            infiniteBounds: true),
        maxZoom: 10,
        minZoom: 0,
        maxPitch: 10,
        minPitch: 0));

    await addDelay(1000);
  });
  testWidgets('getBounds', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    await addDelay(1000);
    final mapboxMap = await mapFuture;
    var bounds = await mapboxMap.getBounds();
    expect(bounds.maxPitch, 85);
    expect(bounds.minPitch, 0);
    expect(bounds.maxZoom, 22);
    expect(bounds.minZoom.floor(), 0);
    expect(bounds.maxPitch, 85);
    var southwest = bounds.bounds.southwest['coordinates'] as List;
    var northeast = bounds.bounds.northeast['coordinates'] as List;
    expect(southwest.first, -180);
    expect(southwest.last, -90);
    expect(northeast.first, 180);
    expect(northeast.last, 90);
    expect(bounds.bounds.infiniteBounds, true);

    await addDelay(1000);
  });

  testWidgets('drag', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await mapboxMap.dragStart(ScreenCoordinate(x: 1, y: 1));
    await addDelay(1000);
    mapboxMap.dragEnd();
  });
  testWidgets('getDragCameraOptions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var options = await mapboxMap.getDragCameraOptions(
        ScreenCoordinate(x: 1, y: 1), ScreenCoordinate(x: 100, y: 100));
    var coordinates = options.center!["coordinates"] as List;
    expect((coordinates.first as double).round(), 0);
    expect((coordinates.last as double).round(), 0);

    await addDelay(1000);
  });
}
