import 'dart:async';
import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart' show Point, Position;
import 'package:web/web.dart' as web;

import 'bindings/binding_adapters.dart';
import 'bindings/map_bindings.dart';

class GesturesController implements GesturesSettingsPlatformInterface {
  GesturesController(this._map) {
    _registerDrag();
    _registerZoom();
    _registerRotate();
    _registerPitch();
    _registerKeyboard();
  }

  final JSMap _map;

  final _panController = StreamController<MapContentGestureContext>.broadcast();
  final _zoomController =
      StreamController<MapContentGestureContext>.broadcast();
  final _rotateController =
      StreamController<MapContentGestureContext>.broadcast();
  final _pitchController =
      StreamController<MapContentGestureContext>.broadcast();
  final _keyboardController =
      StreamController<MapKeyboardGestureContext>.broadcast();

  @override
  Stream<MapContentGestureContext> get panEvents => _panController.stream;

  @override
  Stream<MapContentGestureContext> get zoomEvents => _zoomController.stream;

  @override
  Stream<MapContentGestureContext> get rotateEvents => _rotateController.stream;

  @override
  Stream<MapContentGestureContext> get pitchEvents => _pitchController.stream;

  @override
  Stream<MapKeyboardGestureContext> get keyboardEvents =>
      _keyboardController.stream;

  @override
  Future<GesturesSettings> getSettings() => Future.value(
    GesturesSettings(
      scrollEnabled: _map.dragPan.isEnabled(),
      pinchToZoomEnabled: _map.touchZoomRotate.isEnabled(),
      rotateEnabled: _map.dragRotate.isEnabled(),
      pitchEnabled: _map.touchPitch.isEnabled(),
      doubleTapToZoomInEnabled: _map.doubleClickZoom.isEnabled(),
      scrollZoomEnabled: _map.scrollZoom.isEnabled(),
      boxZoomEnabled: _map.boxZoom.isEnabled(),
      pitchWithRotateEnabled: _map.dragRotate.pitchWithRotate,
    ),
  );

  @override
  Future<void> updateSettings(GesturesSettings settings) async {
    void apply(bool? value, JSGestureHandler handler) {
      if (value == null) return;
      value ? handler.enable() : handler.disable();
    }

    apply(settings.scrollEnabled, _map.dragPan);
    apply(settings.pinchToZoomEnabled, _map.touchZoomRotate);
    apply(settings.rotateEnabled, _map.dragRotate);
    // Touch two-finger rotate lives inside `touchZoomRotate`; toggle its
    // rotation portion so pinch-zoom keeps working when rotate is off.
    if (settings.rotateEnabled != null) {
      settings.rotateEnabled!
          ? _map.touchZoomRotate.enableRotation()
          : _map.touchZoomRotate.disableRotation();
    }
    apply(settings.pitchEnabled, _map.touchPitch);
    // ctrl+drag pitch lives inside `dragRotate` and is gated by a
    // constructor-only `pitchWithRotate` option. Until
    // https://mapbox.atlassian.net/browse/GLJS-1827 lands a public setter,
    // mutate the convention-private field and re-enable `dragRotate` so the
    // underlying `_mousePitch` reflects the new value. Read `isEnabled()`
    // BEFORE the mutation: when pitch is being switched on, `_mousePitch`
    // is still disabled and `dragRotate.isEnabled()` would lie about
    // whether to refresh.
    if (settings.pitchWithRotateEnabled != null) {
      final wasEnabled = _map.dragRotate.isEnabled();
      _map.dragRotate.pitchWithRotate = settings.pitchWithRotateEnabled!;
      if (wasEnabled) {
        _map.dragRotate.disable();
        _map.dragRotate.enable();
      }
    }
    apply(settings.doubleTapToZoomInEnabled, _map.doubleClickZoom);
    apply(settings.scrollZoomEnabled, _map.scrollZoom);
    apply(settings.boxZoomEnabled, _map.boxZoom);

    // Keyboard rotate (shift+left/right) and pitch (shift+up/down) share
    // one flag in GL JS — disabling either disables both. Disable when
    // either rotateEnabled or pitchEnabled resolves to false.
    if (settings.rotateEnabled != null || settings.pitchEnabled != null) {
      final rotate = settings.rotateEnabled ?? _map.dragRotate.isEnabled();
      final pitch = settings.pitchEnabled ?? _map.touchPitch.isEnabled();
      rotate && pitch
          ? _map.keyboard.enableRotation()
          : _map.keyboard.disableRotation();
    }
  }

  void _registerDrag() {
    _addHandler('dragstart', GestureState.started, _panController);
    _addHandler('drag', GestureState.changed, _panController);
    _addHandler('dragend', GestureState.ended, _panController);
  }

  void _registerZoom() {
    _addHandler('zoomstart', GestureState.started, _zoomController);
    _addHandler('zoom', GestureState.changed, _zoomController);
    _addHandler('zoomend', GestureState.ended, _zoomController);
  }

  void _registerRotate() {
    _addHandler('rotatestart', GestureState.started, _rotateController);
    _addHandler('rotate', GestureState.changed, _rotateController);
    _addHandler('rotateend', GestureState.ended, _rotateController);
  }

  void _registerPitch() {
    _addHandler('pitchstart', GestureState.started, _pitchController);
    _addHandler('pitch', GestureState.changed, _pitchController);
    _addHandler('pitchend', GestureState.ended, _pitchController);
  }

  /// Keyboard input has no cursor position, so it can't reuse [_addHandler]'s
  /// context-building — instead filters `movestart`/`move`/`moveend` (fired
  /// for every camera change) down to `KeyboardEvent` only.
  void _registerKeyboard() {
    _addKeyboardHandler('movestart', GestureState.started);
    _addKeyboardHandler('move', GestureState.changed);
    _addKeyboardHandler('moveend', GestureState.ended);
  }

  void _addKeyboardHandler(String type, GestureState state) {
    _map.on(
      type,
      ((JSMapMoveEvent event) {
        if (!(event.originalEvent?.isA<web.KeyboardEvent>() ?? false)) return;
        _keyboardController.add(
          MapKeyboardGestureContext(
            cameraState: _map.getCameraState(),
            gestureState: state,
          ),
        );
      }).toJS,
    );
  }

  void _addHandler(
    String type,
    GestureState state,
    StreamController<MapContentGestureContext> sink,
  ) {
    _map.on(
      type,
      ((JSGestureEventData event) {
        final ctx = _buildContext(event.originalEvent, state);
        if (ctx != null) sink.add(ctx);
      }).toJS,
    );
  }

  MapContentGestureContext? _buildContext(
    web.Event? original,
    GestureState state,
  ) {
    if (original == null) return null;
    final touch = _cursorPoint(original);
    if (touch == null) return null;
    final lngLat = _map.unproject(JSScreenPoint(touch.x, touch.y));
    return MapContentGestureContext(
      touchPosition: touch,
      point: Point(coordinates: Position(lngLat.lng, lngLat.lat)),
      gestureState: state,
    );
  }

  /// Derives a screen position from the event that drove a gesture. Returns
  /// null for anything without one — notably a `KeyboardEvent`, since GL JS
  /// fires `zoom*`/`rotate*`/`pitch*` for keyboard-driven changes too, but
  /// they have no cursor position to report. Those are silently dropped
  /// from [zoomEvents]/[rotateEvents]/[pitchEvents]; keyboard input is
  /// delivered separately through [keyboardEvents].
  ScreenCoordinate? _cursorPoint(web.Event original) {
    final rect = _map.getContainer().getBoundingClientRect();
    if (original.isA<web.MouseEvent>()) {
      final me = original as web.MouseEvent;
      return ScreenCoordinate(
        x: me.clientX.toDouble() - rect.left,
        y: me.clientY.toDouble() - rect.top,
      );
    }
    if (original.isA<web.TouchEvent>()) {
      final te = original as web.TouchEvent;
      final list = te.touches.length > 0 ? te.touches : te.changedTouches;
      if (list.length == 0) return null;
      final t = list.item(0)!;
      return ScreenCoordinate(
        x: t.clientX.toDouble() - rect.left,
        y: t.clientY.toDouble() - rect.top,
      );
    }
    return null;
  }
}
