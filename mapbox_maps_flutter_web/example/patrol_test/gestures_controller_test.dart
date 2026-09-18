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

// GL JS `KeyboardHandler.keydown()` switches on the legacy DOM `keyCode`
// values below.
const _arrowUp = 38;
const _arrowRight = 39;
const _equals = 187;

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
            body: MapWebWidget(
              styleUri: 'mapbox://styles/mapbox/standard',
              viewport: _viewport,
              onMapCreated: onCreated,
            ),
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
            body: MapWebWidget(
              styleUri: 'mapbox://styles/mapbox/standard',
              viewport: _viewport,
              onMapCreated: onCreated,
            ),
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
            body: MapWebWidget(
              styleUri: 'mapbox://styles/mapbox/standard',
              viewport: _viewport,
              onMapCreated: onCreated,
            ),
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
    'rotateEnabled and pitchWithRotateEnabled toggle independently on the drag-rotate handler',
    ($) async {
      final tester = $.tester;
      await pumpMapTree(
        tester,
        (onCreated) => MaterialApp(
          home: Scaffold(
            body: MapWebWidget(
              styleUri: 'mapbox://styles/mapbox/standard',
              viewport: _viewport,
              onMapCreated: onCreated,
            ),
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

      await gestures.updateSettings(
        GesturesSettings(rotateEnabled: false, pitchWithRotateEnabled: true),
      );
      final bearing = map.getBearing();
      final pitch = map.getPitch();
      _ctrlDrag(start, end);
      await tester.pump(const Duration(milliseconds: 100));
      expect(map.getBearing(), bearing, reason: 'ctrl+drag rotate must be off');
      expect(
        map.getPitch(),
        isNot(pitch),
        reason:
            'ctrl+drag pitch must keep working: rotateEnabled and '
            'pitchWithRotateEnabled are independent sub-toggles on the '
            'drag-rotate handler',
      );
    },
  );

  patrolTest(
    'rotateEnabled and pitchWithRotateEnabled can both be re-enabled together in one call',
    ($) async {
      final tester = $.tester;
      await pumpMapTree(
        tester,
        (onCreated) => MaterialApp(
          home: Scaffold(
            body: MapWebWidget(
              styleUri: 'mapbox://styles/mapbox/standard',
              viewport: _viewport,
              onMapCreated: onCreated,
            ),
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

      // Start from both off, then re-enable both in the SAME call.
      await gestures.updateSettings(
        GesturesSettings(rotateEnabled: false, pitchWithRotateEnabled: false),
      );
      await gestures.updateSettings(
        GesturesSettings(rotateEnabled: true, pitchWithRotateEnabled: true),
      );
      final bearing = map.getBearing();
      final pitch = map.getPitch();
      _ctrlDrag(start, end);
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        map.getBearing(),
        isNot(bearing),
        reason: 'ctrl+drag rotate must work',
      );
      expect(map.getPitch(), isNot(pitch), reason: 'ctrl+drag pitch must work');
    },
  );

  patrolTest(
    'scrollEnabled gates keyboard arrow-pan too, independently of keyboard zoom/rotate/pitch',
    ($) async {
      final controller = await pumpMapTree(
        $.tester,
        (onCreated) => MaterialApp(
          home: Scaffold(
            body: MapWebWidget(
              styleUri: 'mapbox://styles/mapbox/standard',
              viewport: _viewport,
              onMapCreated: onCreated,
            ),
          ),
        ),
      );
      final map = currentMap($.tester)!;

      await controller.gestures.updateSettings(
        GesturesSettings(scrollEnabled: false),
      );
      final center = map.getCenter();
      final zoom = map.getZoom();
      final canvas = canvasContainer();
      canvas.dispatchEvent(keyboardEvent('keydown', _arrowRight));
      canvas.dispatchEvent(keyboardEvent('keyup', _arrowRight));
      await $.tester.pump(const Duration(milliseconds: 500));
      expect(
        map.getCenter().lng,
        closeTo(center.lng, 0.0001),
        reason: 'arrow-key pan must stop once scrollEnabled is disabled',
      );

      canvas.dispatchEvent(keyboardEvent('keydown', _equals));
      canvas.dispatchEvent(keyboardEvent('keyup', _equals));
      await $.tester.pump(const Duration(milliseconds: 500));
      expect(
        map.getZoom(),
        isNot(zoom),
        reason: 'keyboard zoom must be unaffected by scrollEnabled',
      );
    },
  );

  patrolTest(
    'rotateEnabled and pitchEnabled independently gate keyboard Shift+arrow rotate and pitch',
    ($) async {
      final controller = await pumpMapTree(
        $.tester,
        (onCreated) => MaterialApp(
          home: Scaffold(
            body: MapWebWidget(
              styleUri: 'mapbox://styles/mapbox/standard',
              viewport: _viewport,
              onMapCreated: onCreated,
            ),
          ),
        ),
      );
      final map = currentMap($.tester)!;

      await controller.gestures.updateSettings(
        GesturesSettings(rotateEnabled: false),
      );
      final bearing = map.getBearing();
      final pitch = map.getPitch();
      final canvas = canvasContainer();

      canvas.dispatchEvent(
        keyboardEvent('keydown', _arrowRight, shiftKey: true),
      );
      canvas.dispatchEvent(keyboardEvent('keyup', _arrowRight, shiftKey: true));
      await $.tester.pump(const Duration(milliseconds: 500));
      expect(
        map.getBearing(),
        closeTo(bearing, 0.0001),
        reason:
            'Shift+ArrowRight rotate must stop once rotateEnabled is '
            'disabled',
      );

      canvas.dispatchEvent(keyboardEvent('keydown', _arrowUp, shiftKey: true));
      canvas.dispatchEvent(keyboardEvent('keyup', _arrowUp, shiftKey: true));
      await $.tester.pump(const Duration(milliseconds: 500));
      expect(
        map.getPitch(),
        isNot(pitch),
        reason:
            'Shift+ArrowUp pitch must keep working: keyboard rotate and '
            'pitch no longer share one flag',
      );
    },
  );

  patrolTest('quickZoomEnabled gates tap-drag-zoom', ($) async {
    final tester = $.tester;
    await pumpMapTree(
      tester,
      (onCreated) => MaterialApp(
        home: Scaffold(
          body: MapWebWidget(
            styleUri: 'mapbox://styles/mapbox/standard',
            viewport: _viewport,
            onMapCreated: onCreated,
          ),
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

    // Tap-drag-zoom lives inside `touchZoomRotate`, alongside two-finger
    // pinch-zoom (`pinchToZoomEnabled`); leave that on so this exercises
    // quickZoomEnabled alone, the same way two-finger touch-rotate needs
    // pinch-zoom on regardless of rotateEnabled.
    Future<bool> tapDragZoom() {
      final canvas = canvasContainer();
      canvas.dispatchEvent(touchEvent('touchstart', center.x, center.y));
      canvas.dispatchEvent(touchEvent('touchend', center.x, center.y));
      canvas.dispatchEvent(touchEvent('touchstart', center.x, center.y));
      return _zoomFires(map, () {
        canvas.dispatchEvent(touchEvent('touchmove', center.x, center.y - 40));
        canvas.dispatchEvent(touchEvent('touchend', center.x, center.y - 40));
      });
    }

    await gestures.updateSettings(GesturesSettings(quickZoomEnabled: true));
    expect(
      await tapDragZoom(),
      isTrue,
      reason: 'tap-drag-zoom must work once quickZoomEnabled is enabled',
    );

    await gestures.updateSettings(GesturesSettings(quickZoomEnabled: false));
    expect(
      await tapDragZoom(),
      isFalse,
      reason: 'tap-drag-zoom must stop once quickZoomEnabled is disabled',
    );
  });
}
