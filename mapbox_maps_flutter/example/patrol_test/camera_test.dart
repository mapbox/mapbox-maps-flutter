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

  patrolTest('coordinateBoundsForCamera', ($) async {
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
    _expectBoundsAroundCenter(camera);
  });

  patrolTest('coordinateBoundsForCameraUnwrapped', ($) async {
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
    _expectBoundsAroundCenter(camera);
  });

  patrolTest('coordinateBoundsZoomForCamera', ($) async {
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
    _expectBoundsAroundCenter(coordinate.bounds);
  });
  patrolTest('coordinateBoundsZoomForCameraUnwrapped', ($) async {
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
    _expectBoundsAroundCenter(coordinate.bounds);
  });
  patrolTest('coordinateBoundsForCamera on the globe', ($) async {
    final mapboxMap = await app.pumpMap(
      tester: $.tester,
      styleJson: _globeStyle,
    );
    await $.tester.pumpAndSettle();

    // At a low zoom near the pole, the globe shows the North Pole, so the
    // bounds go to latitude 90 and cover all longitudes.
    final polar = await mapboxMap.coordinateBoundsForCamera(
      CameraOptions(
        center: Point(coordinates: Position(0, 80)),
        zoom: 1,
        bearing: 0,
        pitch: 0,
        padding: MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
      ),
    );
    expect(polar.northeast.coordinates.lat, closeTo(90, 1e-6));
    expect(polar.southwest.coordinates.lng, closeTo(-180, 1e-6));
    expect(polar.northeast.coordinates.lng, closeTo(180, 1e-6));

    // The globe cannot show more than one hemisphere.
    final equator = await mapboxMap.coordinateBoundsForCamera(
      CameraOptions(
        center: Point(coordinates: Position(0, 0)),
        zoom: 1,
        bearing: 0,
        pitch: 0,
        padding: MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
      ),
    );
    expect(equator.southwest.coordinates.lng, greaterThanOrEqualTo(-90));
    expect(equator.northeast.coordinates.lng, lessThanOrEqualTo(90));
    expect(equator.southwest.coordinates.lat, greaterThanOrEqualTo(-90));
    expect(equator.northeast.coordinates.lat, lessThanOrEqualTo(90));
  });

  patrolTest('coordinateBoundsForCamera matches the projected corners', (
    $,
  ) async {
    final tester = $.tester;
    // A style without terrain, because on web terrain changes the bounds.
    // A fixed map size, because MapboxMap.getSize() is not supported on iOS.
    final size = Size(width: 300, height: 400);
    final mapboxMap = await app.pumpMap(
      tester: $.tester,
      styleJson: _flatStyle,
      width: size.width,
      height: size.height,
    );
    await tester.pumpAndSettle();

    for (final pitch in [0.0, 45.0]) {
      final camera = CameraOptions(
        center: Point(coordinates: Position(24.94, 60.17)),
        zoom: 12,
        bearing: 30,
        pitch: pitch,
        padding: MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
      );
      await mapboxMap.setCamera(camera);
      await tester.pumpAndSettle();

      // Read the live camera next to the corners, so that a camera change
      // between the two calls cannot make them disagree.
      final state = await mapboxMap.getCameraState();
      final bounds = await mapboxMap.coordinateBoundsForCamera(
        CameraOptions(
          center: state.center,
          zoom: state.zoom,
          bearing: state.bearing,
          pitch: state.pitch,
          padding: camera.padding,
        ),
      );
      // The bottom corners are below the horizon for both pitches, so they
      // must be inside the bounds. With no pitch, all four corners are
      // on the map plane.
      final corners = await mapboxMap.coordinatesForPixels([
        ScreenCoordinate(x: 0, y: size.height),
        ScreenCoordinate(x: size.width, y: size.height),
        if (pitch == 0) ...[
          ScreenCoordinate(x: 0, y: 0),
          ScreenCoordinate(x: size.width, y: 0),
        ],
      ]);
      const tolerance = 1e-4;
      for (final corner in corners) {
        final lng = corner.coordinates.lng.toDouble();
        final lat = corner.coordinates.lat.toDouble();
        expect(
          lng,
          inInclusiveRange(
            bounds.southwest.coordinates.lng - tolerance,
            bounds.northeast.coordinates.lng + tolerance,
          ),
        );
        expect(
          lat,
          inInclusiveRange(
            bounds.southwest.coordinates.lat - tolerance,
            bounds.northeast.coordinates.lat + tolerance,
          ),
        );
      }
      if (pitch == 0) {
        final lngs = corners.map((c) => c.coordinates.lng.toDouble());
        final lats = corners.map((c) => c.coordinates.lat.toDouble());
        expect(
          bounds.southwest.coordinates.lng,
          closeTo(lngs.reduce((a, b) => a < b ? a : b), tolerance),
        );
        expect(
          bounds.northeast.coordinates.lng,
          closeTo(lngs.reduce((a, b) => a > b ? a : b), tolerance),
        );
        expect(
          bounds.southwest.coordinates.lat,
          closeTo(lats.reduce((a, b) => a < b ? a : b), tolerance),
        );
        expect(
          bounds.northeast.coordinates.lat,
          closeTo(lats.reduce((a, b) => a > b ? a : b), tolerance),
        );
      }
    }
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

/// Checks that [bounds] contain the center (1, 2) of the camera that the
/// `coordinateBounds*ForCamera` tests use. At zoom 10, the view is less than
/// one degree wide on all screen sizes that the tests use.
const _flatStyle =
    '{"version":8,"projection":{"name":"mercator"},"sources":{},"layers":[]}';
const _globeStyle =
    '{"version":8,"projection":{"name":"globe"},"sources":{},"layers":[]}';

void _expectBoundsAroundCenter(CoordinateBounds bounds) {
  final southwest = bounds.southwest.coordinates;
  final northeast = bounds.northeast.coordinates;
  expect(1.0, inInclusiveRange(southwest.lng, northeast.lng));
  expect(2.0, inInclusiveRange(southwest.lat, northeast.lat));
  expect(northeast.lng - southwest.lng, lessThan(1.5));
  expect(northeast.lat - southwest.lat, lessThan(1.5));
}
