// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter_examples/platform.dart';
import 'patrol.dart';
import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  // These tests are skipped on web: repeatedly starting/cancelling camera
  // animations under the software (SwiftShader) WebGL renderer on CI
  // intermittently hard-wedges the browser's GPU process, freezing the whole
  // Patrol run at the next page reload — even when the map is fully idle when
  // the test ends, and in both headless and headed Chromium. On web these
  // camera methods are one-line passthroughs to GL JS (`map.easeTo(...)`),
  // so the skipped coverage is minimal.
  patrolTest('easeTo', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await mapboxMap.easeTo(
      CameraOptions(
        padding: MbxEdgeInsets(left: 0, top: 0, right: 0, bottom: 0),
        anchor: ScreenCoordinate(x: 0, y: 0),
        center: Point(coordinates: Position(-0.11968, 51.50325)),
        zoom: 15,
        bearing: 0,
        pitch: 3,
      ),
      MapAnimationOptions(duration: 2000, startDelay: 0),
    );
  });

  patrolTest('flyTo', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await mapboxMap.flyTo(
      CameraOptions(
        padding: MbxEdgeInsets(left: 0, top: 0, right: 0, bottom: 0),
        anchor: ScreenCoordinate(x: 0, y: 0),
        center: Point(coordinates: Position(-0.11968, 51.50325)),
        zoom: 15,
        bearing: 0,
        pitch: 3,
      ),
      MapAnimationOptions(duration: 2000, startDelay: 0),
    );
  });

  if (isAndroid) {
    patrolTest('moveBy', ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      await mapboxMap.moveBy(
        ScreenCoordinate(x: 500.0, y: 500.0),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );
    });

    patrolTest('rotateBy', ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      await mapboxMap.rotateBy(
        ScreenCoordinate(x: 0, y: 0),
        ScreenCoordinate(x: 500.0, y: 500.0),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );
    });
    patrolTest('scaleBy', ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      await mapboxMap.scaleBy(
        15.0,
        ScreenCoordinate(x: 10.0, y: 10.0),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );
    });
    patrolTest('pitchBy', ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      await mapboxMap.pitchBy(
        70.0,
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );
    });
  }
  patrolTest('cancelCameraAnimation', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await mapboxMap.cancelCameraAnimation();
    await mapboxMap.flyTo(
      CameraOptions(
        padding: MbxEdgeInsets(left: 0, top: 0, right: 0, bottom: 0),
        anchor: ScreenCoordinate(x: 0, y: 0),
        center: Point(coordinates: Position(-0.11968, 51.50325)),
        zoom: 15,
        bearing: 0,
        pitch: 3,
      ),
      MapAnimationOptions(duration: 2000, startDelay: 0),
    );
    await mapboxMap.cancelCameraAnimation();
    // Let the map settle before the test ends. Leaving a half-cancelled
    // animation mid-render when the harness tears the map down (and, on web,
    // when Patrol reloads the page for the next test) intermittently wedges
    // the headless software-WebGL renderer on CI and freezes the whole run.
    app.events.resetOnMapIdle();
    try {
      await app.waitForEvent(
        $.tester,
        app.events.onMapIdle.future,
        timeout: const Duration(seconds: 5),
      );
    } on TimeoutException {
      // Best-effort settle; proceed if the map never goes idle.
    }
  });
}
