// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';
import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('CameraViewportState test', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final cameraViewport = CameraViewportState(
      center: Point(coordinates: Position(5, 6)),
      zoom: 16.35,
      bearing: 8,
      pitch: 42,
    );
    final mapboxMap = await app.pumpMap(
      tester: $.tester,
      viewport: cameraViewport,
    );
    await tester.pumpAndSettle();
    final camera = await mapboxMap.getCameraState();

    expect(
      camera.center.coordinates.lng,
      moreOrLessEquals(cameraViewport.center!.coordinates.lng.toDouble()),
    );
    expect(
      camera.center.coordinates.lat,
      moreOrLessEquals(cameraViewport.center!.coordinates.lat.toDouble()),
    );
    expect(camera.zoom, moreOrLessEquals(cameraViewport.zoom!.toDouble()));
    expect(
      camera.bearing,
      moreOrLessEquals(cameraViewport.bearing!.toDouble()),
    );
    expect(camera.pitch, moreOrLessEquals(cameraViewport.pitch!.toDouble()));
  });

  patrolTest('StyleDefaultViewportState test', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final styleDefaultCamera = CameraOptions(
      center: Point(coordinates: Position(80, 20)),
      zoom: 12.5,
      bearing: 29,
      pitch: 50,
    );

    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    app.events.resetOnStyleLoaded();
    mapboxMap.loadStyleJson("""{
    "bearing": ${styleDefaultCamera.bearing},
    "center": [${styleDefaultCamera.center?.coordinates.lng}, ${styleDefaultCamera.center?.coordinates.lat}],
    "pitch": ${styleDefaultCamera.pitch},
    "zoom": ${styleDefaultCamera.zoom}
}""");
    await app.waitForEvent($.tester, app.events.onStyleLoaded.future);
    await mapboxMap.setCamera(
      CameraOptions(
        center: Point(coordinates: Position(5, 6)),
        zoom: 16.35,
        bearing: 8,
        pitch: 42,
      ),
    );

    // apply default viewport (updates the already-mounted map in place)
    await app.pumpMapUpdate(
      tester: $.tester,
      viewport: StyleDefaultViewportState(),
    );
    await tester.pumpAndSettle();
    final cameraAfterViewport = await mapboxMap.getCameraState();

    // check that the camera is reset to the default viewport
    expect(
      cameraAfterViewport.center.coordinates.lng,
      moreOrLessEquals(styleDefaultCamera.center!.coordinates.lng.toDouble()),
    );
    expect(
      cameraAfterViewport.center.coordinates.lat,
      moreOrLessEquals(styleDefaultCamera.center!.coordinates.lat.toDouble()),
    );
    expect(
      cameraAfterViewport.zoom,
      moreOrLessEquals(styleDefaultCamera.zoom!.toDouble()),
    );
    expect(
      cameraAfterViewport.bearing,
      moreOrLessEquals(styleDefaultCamera.bearing!.toDouble()),
    );
    expect(
      cameraAfterViewport.pitch,
      moreOrLessEquals(styleDefaultCamera.pitch!.toDouble()),
    );
  });

  patrolTest('OverviewViewportState test', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final overviewViewport = OverviewViewportState(
      geometry: Polygon.fromPoints(
        points: [
          [
            Point(coordinates: Position(0, 0)),
            Point(coordinates: Position(0, 10)),
            Point(coordinates: Position(10, 10)),
            Point(coordinates: Position(10, 0)),
            Point(coordinates: Position(0, 0)),
          ],
        ],
      ),
      bearing: 30.0,
      pitch: 45.0,
    );
    final mapboxMap = await app.pumpMap(
      tester: $.tester,
      viewport: overviewViewport,
    );
    await tester.pumpAndSettle();
    final camera = await mapboxMap.getCameraState();

    // Android has a bug that overview viewport state is not applying correctly.
    // The bug appears rarely in real use case scenarios, but is more prominent in tests.
    // TODO: Remove this once https://mapbox.atlassian.net/browse/MAPSAND-1907 is fixed.
    if (!Platform.isAndroid) {
      expect(camera.center.coordinates.lng, moreOrLessEquals(5, epsilon: 0.1));
      expect(camera.center.coordinates.lat, moreOrLessEquals(5, epsilon: 0.1));
    }
    expect(
      camera.bearing,
      moreOrLessEquals(overviewViewport.bearing!.toDouble()),
    );
    expect(camera.pitch, moreOrLessEquals(overviewViewport.pitch!.toDouble()));
  });

  patrolTest('IdleViewportState test', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final idleViewport = IdleViewportState();
    await app.pumpMap(tester: $.tester, viewport: idleViewport);
    await tester.pumpAndSettle();

    // no-op viewport state, camera should not change
  });

  patrolTest('FollowPuckViewportState test', ($) async {
    final tester = $.tester;
    final followPuckViewport = FollowPuckViewportState(
      zoom: 16.0,
      bearing: FollowPuckViewportStateBearingConstant(30.0),
      pitch: 45.0,
    );
    await app.pumpMap(tester: $.tester, viewport: followPuckViewport);
    await tester.pumpAndSettle();

    // TODO: test that the camera is updated when custom location provider is supported
  });
}
