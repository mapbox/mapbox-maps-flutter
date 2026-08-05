import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:mapbox_maps_flutter_web/src/gestures_controller.dart';
import 'package:turf/turf.dart' show Point, Position;
import 'package:web/web.dart' as web;
import 'patrol.dart';

import 'test_utils.dart';

final _viewport = CameraViewportState(
  center: Point(coordinates: Position(0, 0)),
  zoom: 5,
);

/// Runs [dispatch], which should trigger some wheel events on the map, and
/// reports whether GL JS's `zoom` event fires within a few seconds
/// afterward.
Future<bool> _zoomFires(JSMap map, void Function() dispatch) {
  final completer = Completer<bool>();
  map.once('zoom', (() => completer.complete(true)).toJS);
  dispatch();
  return completer.future.timeout(
    const Duration(seconds: 3),
    onTimeout: () => false,
  );
}

/// A ctrl+drag from [start] to [end]: GL JS routes this through `dragRotate`
/// (`MouseRotateHandler`/`MousePitchHandler`), which read `_lastPoint` (set
/// at mousedown) and the single subsequent mousemove to compute the full
/// bearing/pitch delta in one step — no intermediate mousemove steps needed.
/// `mousemove`/`mouseup` must land on `document`: GL JS listens for those at
/// the window level (via `mousemoveWindow`/`mouseupWindow`) so a drag that
/// leaves the canvas is still tracked; only `mousedown` is bound to the
/// canvas container itself.
void _ctrlDrag(({double x, double y}) start, ({double x, double y}) end) {
  canvasContainer().dispatchEvent(
    mouseEvent('mousedown', start.x, start.y, ctrlKey: true, buttons: 1),
  );
  web.document.dispatchEvent(
    mouseEvent('mousemove', end.x, end.y, ctrlKey: true, buttons: 1),
  );
  web.document.dispatchEvent(mouseEvent('mouseup', end.x, end.y));
}

/// A shift+drag from [start] to [end]: GL JS routes this through
/// `boxZoomHandler`. Unlike ctrl+drag, `mouseupWindow` reads its point
/// directly off the mouseup event rather than a tracked `_lastPoint`, so the
/// intermediate mousemove can be skipped entirely — mousedown then mouseup
/// at a different point is enough to fire `boxzoomend`.
void _shiftDrag(({double x, double y}) start, ({double x, double y}) end) {
  canvasContainer().dispatchEvent(
    mouseEvent('mousedown', start.x, start.y, shiftKey: true, buttons: 1),
  );
  web.document.dispatchEvent(mouseEvent('mouseup', end.x, end.y));
}

void main() {
  patrolTest(
    'scrollZoomEnabled gates wheel zoom independently of pinchToZoomEnabled',
    ($) async {
      final tester = $.tester;
      await pumpMapTree(
        tester,
        (onCreated) => MaterialApp(
          home: Scaffold(
            body: MapWebWidget(viewport: _viewport, onMapCreated: onCreated),
          ),
        ),
      );
      final map = currentMap(tester)!;
      final gestures = GesturesController(map);
      final rect = mapRect();
      final center = (
        x: rect.left + rect.width / 2,
        y: rect.top + rect.height / 2,
      );

      await gestures.updateSettings(
        GesturesSettings(pinchToZoomEnabled: false, scrollZoomEnabled: true),
      );
      expect(
        await _zoomFires(map, () {
          canvasContainer().dispatchEvent(wheelEvent(center.x, center.y));
          canvasContainer().dispatchEvent(wheelEvent(center.x, center.y));
        }),
        isTrue,
        reason:
            'wheel zoom must still work when only pinchToZoomEnabled is '
            'disabled; scrollZoomEnabled is the flag that gates it now',
      );

      await gestures.updateSettings(GesturesSettings(scrollZoomEnabled: false));
      expect(
        await _zoomFires(map, () {
          canvasContainer().dispatchEvent(wheelEvent(center.x, center.y));
          canvasContainer().dispatchEvent(wheelEvent(center.x, center.y));
        }),
        isFalse,
        reason: 'wheel zoom must stop once scrollZoomEnabled is disabled',
      );
    },
  );

  patrolTest(
    'boxZoomEnabled gates shift+drag box-zoom independently of pinchToZoomEnabled',
    ($) async {
      final tester = $.tester;
      await pumpMapTree(
        tester,
        (onCreated) => MaterialApp(
          home: Scaffold(
            body: MapWebWidget(viewport: _viewport, onMapCreated: onCreated),
          ),
        ),
      );
      final map = currentMap(tester)!;
      final gestures = GesturesController(map);
      final rect = mapRect();
      final start = (
        x: rect.left + rect.width / 4,
        y: rect.top + rect.height / 4,
      );
      final end = (
        x: rect.left + rect.width * 3 / 4,
        y: rect.top + rect.height * 3 / 4,
      );

      await gestures.updateSettings(
        GesturesSettings(pinchToZoomEnabled: false, boxZoomEnabled: true),
      );
      expect(
        await _zoomFires(map, () => _shiftDrag(start, end)),
        isTrue,
        reason:
            'shift+drag box-zoom must still work when pinchToZoomEnabled is '
            'disabled; boxZoomEnabled is the flag that gates it',
      );

      await gestures.updateSettings(GesturesSettings(boxZoomEnabled: false));
      expect(
        await _zoomFires(map, () => _shiftDrag(start, end)),
        isFalse,
        reason: 'shift+drag box-zoom must stop once boxZoomEnabled is disabled',
      );
    },
  );

  patrolTest(
    'pitchWithRotateEnabled gates ctrl+drag pitch independently of pitchEnabled',
    ($) async {
      final tester = $.tester;
      await pumpMapTree(
        tester,
        (onCreated) => MaterialApp(
          home: Scaffold(
            body: MapWebWidget(viewport: _viewport, onMapCreated: onCreated),
          ),
        ),
      );
      final map = currentMap(tester)!;
      final gestures = GesturesController(map);
      final rect = mapRect();
      final start = (
        x: rect.left + rect.width / 2,
        y: rect.top + rect.height * 3 / 4,
      );
      // Up and to the right: a positive bearing delta, and (since dragging
      // the cursor up tilts the map down) a positive pitch delta.
      final end = (x: start.x + 60, y: start.y - 60);

      await gestures.updateSettings(
        GesturesSettings(pitchEnabled: false, pitchWithRotateEnabled: true),
      );
      var bearing = map.getBearing();
      var pitch = map.getPitch();
      _ctrlDrag(start, end);
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        map.getBearing(),
        isNot(bearing),
        reason: 'ctrl+drag rotate should still work',
      );
      expect(
        map.getPitch(),
        isNot(pitch),
        reason:
            'ctrl+drag pitch must not be affected by pitchEnabled; only '
            'pitchWithRotateEnabled gates it',
      );

      await gestures.updateSettings(
        GesturesSettings(pitchWithRotateEnabled: false),
      );
      bearing = map.getBearing();
      pitch = map.getPitch();
      _ctrlDrag(start, end);
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        map.getBearing(),
        isNot(bearing),
        reason:
            'ctrl+drag rotate must keep working when only pitch is disabled',
      );
      expect(
        map.getPitch(),
        pitch,
        reason:
            'ctrl+drag pitch must stop once pitchWithRotateEnabled is disabled',
      );
    },
  );

  patrolTest(
    'rotateEnabled disables ctrl+drag pitch too, since both live in the same handler',
    ($) async {
      final tester = $.tester;
      await pumpMapTree(
        tester,
        (onCreated) => MaterialApp(
          home: Scaffold(
            body: MapWebWidget(viewport: _viewport, onMapCreated: onCreated),
          ),
        ),
      );
      final map = currentMap(tester)!;
      final gestures = GesturesController(map);
      final rect = mapRect();
      final start = (
        x: rect.left + rect.width / 2,
        y: rect.top + rect.height * 3 / 4,
      );
      final end = (x: start.x + 60, y: start.y - 60);

      await gestures.updateSettings(GesturesSettings(rotateEnabled: false));
      final bearing = map.getBearing();
      final pitch = map.getPitch();
      _ctrlDrag(start, end);
      await tester.pump(const Duration(milliseconds: 100));
      expect(map.getBearing(), bearing, reason: 'ctrl+drag rotate must be off');
      expect(
        map.getPitch(),
        pitch,
        reason:
            'disabling rotateEnabled must also disable ctrl+drag pitch: GL '
            "JS's dragRotate.disable() disables both _mouseRotate and "
            '_mousePitch unconditionally, with no way to keep one and drop '
            'the other',
      );
    },
  );
}
