// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';
import 'package:turf/turf.dart' show Point, Position;
import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));
  final initialViewport = CameraViewportState(
    center: Point(coordinates: Position(0, 0)),
    zoom: 15,
    pitch: 60,
    bearing: 12,
  );

  patrolTest('cameraForCoordinatesPadding', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    var reference = CameraOptions(
      center: Point(coordinates: Position(1.0, 2.0)),
      padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
      anchor: null,
      zoom: 5,
      bearing: 20,
      pitch: 30,
    );
    var camera = await mapboxMap.cameraForCoordinatesPadding(
      [
        Point(coordinates: Position(1.0, 2.0)),
        Point(coordinates: Position(3.0, 4.0)),
      ],
      reference,
      MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
      10,
      ScreenCoordinate(x: 5, y: 5),
    );

    expect(camera.bearing, 20);
    expect(camera.pitch, closeTo(30, 0.1));
    expect(camera.zoom, lessThanOrEqualTo(10));
    expect(camera.padding!.top, 1);
    expect(camera.padding!.left, 2);
    expect(camera.padding!.bottom, 3);
    expect(camera.padding!.right, 4);
  });

  patrolTest('cameraForCoordinateBounds', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    var camera = await mapboxMap.cameraForCoordinateBounds(
      CoordinateBounds(
        southwest: Point(coordinates: Position(1.0, 2.0)),
        northeast: Point(coordinates: Position(3.0, 4.0)),
        infiniteBounds: true,
      ),
      MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
      10,
      20,
      10,
      null,
    );
    expect(camera.bearing, 10);
    expect(camera.pitch, 20);
    expect(camera.zoom, lessThanOrEqualTo(10));
    final position = camera.center;
    expect((position?.coordinates.lng as double).round(), 2);
    expect((position?.coordinates.lat as double).round(), 3);
    expect(camera.anchor, isNull);
  });

  patrolTest('cameraForCoordinatesCameraOptions', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    var option = CameraOptions(
      center: Point(coordinates: Position(1.0, 2.0)),
      padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
      anchor: ScreenCoordinate(x: 1, y: 1),
      zoom: 10,
      bearing: 20,
      pitch: 30,
    );
    var camera = await mapboxMap.cameraForCoordinatesCameraOptions(
      [
        Point(coordinates: Position(1.0, 2.0)),
        Point(coordinates: Position(3.0, 4.0)),
      ],
      option,
      ScreenBox(
        min: ScreenCoordinate(x: 0, y: 0),
        max: ScreenCoordinate(x: 100, y: 100),
      ),
    );
    expect(camera.bearing, 20);
    expect(camera.pitch, 30);
    expect(camera.center, isNotNull);
    if (kIsWeb) {
      expect(camera.center!.coordinates.lng, closeTo(1, 5));
      expect(camera.center!.coordinates.lat, closeTo(2, 5));
      expect(camera.zoom, lessThanOrEqualTo(10));
    } else {
      expect((camera.center!.coordinates.lng as double).round(), 1);
      expect((camera.center!.coordinates.lat as double).round(), 2);
      expect(camera.anchor!.x, 1);
      expect(camera.anchor!.y, 1);
      expect(camera.padding!.top, option.padding!.top);
      expect(camera.padding!.left, option.padding!.left);
      expect(camera.padding!.bottom, option.padding!.bottom);
      expect(camera.padding!.right, option.padding!.right);
      expect(camera.zoom!.round(), 10);
    }
  });

  patrolTest('cameraForGeometry', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var camera = await mapboxMap.cameraForGeometry(
      {
        "type": "Point",
        "coordinates": [1, 2],
      },
      MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
      10,
      20,
    );
    expect(camera.bearing, 10);
    expect(camera.pitch, 20);
    // TODO zoom might be different depending whether surface has changed the size
    // expect(camera.zoom!.round(), 21);
    final position = camera.center;
    expect((position?.coordinates.lng as double).round(), 1);
    expect((position?.coordinates.lat as double).round(), 2);
    expect(camera.anchor, isNull);
  });

  patrolTest('coordinateBoundsForCamera', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var option = CameraOptions(
      center: Point(coordinates: Position(1.0, 2.0)),
      padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
      anchor: ScreenCoordinate(x: 1, y: 1),
      zoom: 10,
      bearing: 20,
      pitch: 30,
    );
    var camera = await mapboxMap.coordinateBoundsForCamera(option);
    expect(camera.infiniteBounds, false);
    final northeast = camera.northeast;
    final southwest = camera.southwest;
    expect((northeast.coordinates.lng as double).round(), 1);
    expect((northeast.coordinates.lat as double).round(), 2);
    expect((southwest.coordinates.lng as double).round(), 1);
    expect((southwest.coordinates.lat as double).round(), 2);
  });

  patrolTest('coordinateBoundsForCameraUnwrapped', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var option = CameraOptions(
      center: Point(coordinates: Position(1.0, 2.0)),
      padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
      anchor: ScreenCoordinate(x: 1, y: 1),
      zoom: 10,
      bearing: 20,
      pitch: 30,
    );
    var camera = await mapboxMap.coordinateBoundsForCameraUnwrapped(option);
    expect(camera.infiniteBounds, false);
    final northeast = camera.northeast;
    final southwest = camera.southwest;
    expect((northeast.coordinates.lng as double).round(), 1);
    expect((northeast.coordinates.lat as double).round(), 2);
    expect((southwest.coordinates.lng as double).round(), 1);
    expect((southwest.coordinates.lat as double).round(), 2);
  });

  patrolTest('coordinateBoundsZoomForCamera', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var option = CameraOptions(
      center: Point(coordinates: Position(1.0, 2.0)),
      padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
      anchor: ScreenCoordinate(x: 1, y: 1),
      zoom: 10,
      bearing: 20,
      pitch: 30,
    );
    var coordinate = await mapboxMap.coordinateBoundsZoomForCamera(option);
    expect(coordinate.zoom, 10);
    expect(coordinate.bounds.infiniteBounds, false);
    final northeast = coordinate.bounds.northeast;
    final southwest = coordinate.bounds.southwest;
    expect((northeast.coordinates.lng as double).round(), 1);
    expect((northeast.coordinates.lat as double).round(), 2);
    expect((southwest.coordinates.lng as double).round(), 1);
    expect((southwest.coordinates.lat as double).round(), 2);
  });
  patrolTest('coordinateBoundsZoomForCameraUnwrapped', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var option = CameraOptions(
      center: Point(coordinates: Position(1.0, 2.0)),
      padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
      anchor: ScreenCoordinate(x: 1, y: 1),
      zoom: 10,
      bearing: 20,
      pitch: 30,
    );
    var coordinate = await mapboxMap.coordinateBoundsZoomForCameraUnwrapped(
      option,
    );
    expect(coordinate.zoom, 10);
    expect(coordinate.bounds.infiniteBounds, false);
    final northeast = coordinate.bounds.northeast;
    final southwest = coordinate.bounds.southwest;
    expect((northeast.coordinates.lng as double).round(), 1);
    expect((northeast.coordinates.lat as double).round(), 2);
    expect((southwest.coordinates.lng as double).round(), 1);
    expect((southwest.coordinates.lat as double).round(), 2);
  });
  patrolTest('pixelForCoordinate', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    var pixel = await mapboxMap.pixelForCoordinate(
      Point(coordinates: Position(1.0, 2.0)),
    );
    expect(pixel.x, isNotNull);
    expect(pixel.y, isNotNull);
  });
  patrolTest('pixelsForCoordinates', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    var pixels = await mapboxMap.pixelsForCoordinates([
      Point(coordinates: Position(1.0, 2.0)),
      Point(coordinates: Position(2.0, 3.0)),
    ]);
    expect(pixels.length, 2);
    expect(pixels.first.x, isNotNull);
    expect(pixels.first.y, isNotNull);
    expect(pixels.last.x, isNotNull);
    expect(pixels.last.y, isNotNull);
  });

  patrolTest('coordinateForPixel', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    final point = await mapboxMap.coordinateForPixel(
      ScreenCoordinate(x: 100, y: 100),
    );
    expect(point, isNotNull);
  });
  patrolTest('coordinatesForPixels', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    final coordinates = await mapboxMap.coordinatesForPixels([
      ScreenCoordinate(x: 100, y: 100),
      ScreenCoordinate(x: 200, y: 300),
    ]);
    expect(coordinates.length, 2);
  });

  patrolTest('setCamera', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var option = CameraOptions(
      center: Point(coordinates: Position(1.0, 2.0)),
      padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
      anchor: ScreenCoordinate(x: 1, y: 1),
      zoom: 10,
      bearing: 20,
      pitch: 30,
    );
    await mapboxMap.setCamera(option);
  });

  patrolTest('getCameraState', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(
      tester: $.tester,
      viewport: initialViewport,
    );
    await tester.pumpAndSettle();

    var cameraState = await mapboxMap.getCameraState();
    expect(cameraState.zoom, closeTo(15, 0.1));
    expect(cameraState.pitch, closeTo(60, 1));
    expect(cameraState.bearing, closeTo(12, 0.1));
    final position = cameraState.center;
    expect(position.coordinates.lng, 0);
    expect(position.coordinates.lat, 0);
    expect(cameraState.padding.top, 0);
    expect(cameraState.padding.right, 0);
    expect(cameraState.padding.bottom, 0);
    expect(cameraState.padding.left, 0);
  });
  patrolTest('setBounds', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await mapboxMap.setBounds(
      CameraBoundsOptions(
        bounds: CoordinateBounds(
          southwest: Point(coordinates: Position(1.0, 2.0)),
          northeast: Point(coordinates: Position(3.0, 4.0)),
          infiniteBounds: true,
        ),
        maxZoom: 10,
        minZoom: 0,
        maxPitch: 10,
        minPitch: 0,
      ),
    );
  });
  patrolTest('getBounds', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var bounds = await mapboxMap.getBounds();
    expect(bounds.maxPitch, 85);
    expect(bounds.minPitch, 0);
    expect(bounds.maxZoom, 22);
    expect(bounds.minZoom.floor(), 0);
    expect(bounds.maxPitch, 85);
    final southwest = bounds.bounds.southwest;
    final northeast = bounds.bounds.northeast;
    expect(southwest.coordinates.lng, -180);
    expect(southwest.coordinates.lat, -90);
    expect(northeast.coordinates.lng, 180);
    expect(northeast.coordinates.lat, 90);
    expect(bounds.bounds.infiniteBounds, true);
  });
}
