import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// `moveBy`, `rotateBy`, `pitchBy` and `scaleBy` aren't implemented on iOS.
final bool _relativeCameraMovesSupported = kIsWeb || !Platform.isIOS;

/// The ways to move the camera, on one map. Each scene drives the same camera
/// through a different API:
///
///  * **Animations** — the imperative `flyTo`, `easeTo` and relative moves.
///  * **Viewport** — declarative [ViewportState]s with a transition.
///  * **Auto-spin** — a continuous `easeTo` loop driven by camera changes.
class CameraPlaygroundExample extends StatefulWidget {
  const CameraPlaygroundExample({super.key});

  @override
  State<CameraPlaygroundExample> createState() =>
      _CameraPlaygroundExampleState();
}

enum _Mode { animations, viewport, spin }

const _scenes = [
  Scene(
    id: 'animations',
    title: 'Animations',
    subtitle: 'flyTo, easeTo and relative moves',
    icon: Icons.animation,
  ),
  Scene(
    id: 'viewport',
    title: 'Viewport',
    subtitle: 'Declarative states and transitions',
    icon: Icons.crop_free,
  ),
  Scene(
    id: 'spin',
    title: 'Auto-spin',
    subtitle: 'A globe that rotates continuously',
    icon: Icons.threesixty_outlined,
  ),
];

/// A city the viewport scene can frame.
class _City {
  const _City(this.name, this.bounds, this.bearing, this.duration);

  final String name;
  final Polygon bounds;
  final double bearing;
  final Duration duration;
}

class _CameraPlaygroundExampleState extends State<CameraPlaygroundExample> {
  static Polygon _box(double west, double south, double east, double north) =>
      Polygon.fromPoints(
        points: [
          [
            Point(coordinates: Position(west, north)),
            Point(coordinates: Position(west, south)),
            Point(coordinates: Position(east, south)),
            Point(coordinates: Position(east, north)),
            Point(coordinates: Position(west, north)),
          ],
        ],
      );

  static final _cities = [
    _City(
      'Helsinki',
      _box(24.7457, 60.1615, 25.1113, 60.2611),
      0,
      const Duration(seconds: 4),
    ),
    _City(
      'Stockholm',
      _box(17.7737, 59.2076, 18.3063, 59.4276),
      45,
      const Duration(seconds: 5),
    ),
    _City(
      'Tallinn',
      _box(24.5695, 59.3339, 24.9487, 59.4487),
      -30,
      const Duration(seconds: 4),
    ),
  ];

  final _viewportController = ViewportController();

  MapboxMap? _mapboxMap;
  var _mode = _Mode.animations;
  var _cityIndex = 0;
  var _pitched = true;

  // Auto-spin state. The stream serialises the easeTo calls so a new one only
  // starts after the previous camera change lands.
  StreamController<CameraOptions>? _spinCameras;
  StreamSubscription<CameraOptions>? _spinSubscription;
  var _spinning = true;

  /// True once the entry animation into the spin scene has finished.
  ///
  /// `_queueSpin` fires on every camera change, so without this gate its
  /// `easeTo` calls would fight the entry transition.
  var _spinReady = false;

  final _gestureSubscriptions =
      <StreamSubscription<MapContentGestureContext>>[];

  @override
  void dispose() {
    _spinSubscription?.cancel();
    _spinCameras?.close();
    for (final subscription in _gestureSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
    _startSpin();
    for (final gestureEvents in [
      mapboxMap.gestures.pan.gestureEvents,
      mapboxMap.gestures.zoom.gestureEvents,
      mapboxMap.gestures.rotate.gestureEvents,
      mapboxMap.gestures.pitch.gestureEvents,
    ]) {
      _gestureSubscriptions.add(gestureEvents.listen(_onGesture));
    }
  }

  /// Stops spinning when the user touches the map.
  ///
  /// A spin `easeTo` and a gesture both compete for the camera, and a step
  /// already in flight can cut the gesture short. The user switches spin back
  /// on.
  void _onGesture(MapContentGestureContext context) {
    if (context.gestureState != GestureState.started || !_spinning) return;
    setState(() => _spinning = false);
  }

  void _startSpin() {
    final controller = StreamController<CameraOptions>();
    _spinCameras = controller;
    _spinSubscription = controller.stream.listen((camera) async {
      await _mapboxMap?.easeTo(camera, null);
    });
  }

  /// Advances the globe one step west, slowing down as the camera zooms in.
  void _queueSpin(CameraState camera) {
    final controller = _spinCameras;
    if (_mode != _Mode.spin || controller == null) return;
    if (controller.isClosed || !controller.hasListener) return;
    if (!_spinReady || !_spinning) return;

    const secondsPerRevolution = 120.0;
    const slowSpinZoom = 3.0;
    const maxSpinZoom = 5.0;
    if (camera.zoom >= maxSpinZoom) return;

    final speedFactor =
        (maxSpinZoom - max(slowSpinZoom, camera.zoom)) /
        (maxSpinZoom - slowSpinZoom);
    controller.add(
      CameraOptions(
        center: Point(
          coordinates: Position(
            camera.center.coordinates.lng -
                speedFactor * 360.0 / secondsPerRevolution,
            camera.center.coordinates.lat,
          ),
        ),
      ),
    );
  }

  void _onCameraChanged(CameraChangedEventData data) =>
      _queueSpin(data.cameraState);

  void _selectMode(String id) {
    _spinSubscription?.cancel();
    _spinCameras?.close();
    setState(() {
      _mode = _Mode.values.firstWhere((mode) => mode.name == id);
      _spinning = true;
      _spinReady = false;
    });
    _startSpin();
    _flyToScene();
  }

  /// Animates the camera to the selected scene.
  ///
  /// Goes through [_viewportController], because [MapWidget] renders
  /// `controller.state` once a controller is attached. A `flyTo` would leave
  /// that state behind, and the next equal [ViewportController.moveTo] would
  /// then do nothing.
  void _flyToScene() {
    switch (_mode) {
      case _Mode.animations:
        _viewportController.moveTo(
          CameraViewportState(
            center: Point(coordinates: Position(0, 20)),
            zoom: 2,
            pitch: 0,
            bearing: 0,
          ),
          transition: FlyViewportTransition(
            duration: const Duration(milliseconds: 1200),
          ),
        );
      case _Mode.viewport:
        _moveToCity(_cities[_cityIndex % _cities.length]);
      case _Mode.spin:
        _viewportController.moveTo(
          CameraViewportState(
            center: Point(coordinates: Position(0, 20)),
            zoom: 0,
            pitch: 0,
            bearing: 0,
          ),
          transition: FlyViewportTransition(
            duration: const Duration(milliseconds: 1200),
          ),
          // Spin only after the entry animation has landed.
          completion: (_) {
            if (!mounted || _mode != _Mode.spin) return;
            setState(() => _spinReady = true);
            _mapboxMap?.getCameraState().then(_queueSpin);
          },
        );
    }
  }

  _City get _nextCity => _cities[(_cityIndex + 1) % _cities.length];

  void _flyToNextCity() {
    setState(() => _cityIndex++);
    _moveToCity(_cities[_cityIndex % _cities.length]);
  }

  void _moveToCity(_City city) {
    _viewportController.moveTo(
      OverviewViewportState(
        geometry: city.bounds,
        bearing: city.bearing,
        pitch: _pitched ? 60 : 0,
      ),
      transition: FlyViewportTransition(duration: city.duration),
    );
  }

  Future<void> _animate(Future<void> Function(MapboxMap map) action) async {
    final map = _mapboxMap;
    if (map != null) await action(map);
  }

  List<Widget> _buildControls() {
    switch (_mode) {
      case _Mode.animations:
        return [
          ControlAction(
            label: 'flyTo Helsinki',
            icon: Icons.flight_takeoff,
            onPressed: () => _animate(
              (map) => map.flyTo(
                CameraOptions(
                  center: Point(coordinates: Position(24.9384, 60.1699)),
                  zoom: 12,
                  pitch: 45,
                ),
                MapAnimationOptions(duration: 3000),
              ),
            ),
          ),
          ControlAction(
            label: 'easeTo Berlin',
            icon: Icons.moving,
            onPressed: () => _animate(
              (map) => map.easeTo(
                CameraOptions(
                  center: Point(coordinates: Position(13.405, 52.52)),
                  zoom: 10,
                ),
                MapAnimationOptions(duration: 2000),
              ),
            ),
          ),
          ControlAction(
            label: 'moveBy',
            icon: Icons.open_with,
            note: _relativeCameraMovesSupported ? null : 'Not available on iOS',
            onPressed: _relativeCameraMovesSupported
                ? () => _animate(
                    (map) => map.moveBy(
                      ScreenCoordinate(x: 120, y: 80),
                      MapAnimationOptions(duration: 800),
                    ),
                  )
                : null,
          ),
          ControlAction(
            label: 'rotateBy',
            icon: Icons.rotate_right,
            note: _relativeCameraMovesSupported ? null : 'Not available on iOS',
            onPressed: _relativeCameraMovesSupported
                ? () => _animate(
                    (map) => map.rotateBy(
                      ScreenCoordinate(x: 0, y: 0),
                      ScreenCoordinate(x: 100, y: 100),
                      MapAnimationOptions(duration: 800),
                    ),
                  )
                : null,
          ),
          ControlAction(
            label: 'pitchBy',
            icon: Icons.height,
            note: _relativeCameraMovesSupported ? null : 'Not available on iOS',
            onPressed: _relativeCameraMovesSupported
                ? () => _animate(
                    (map) =>
                        map.pitchBy(15, MapAnimationOptions(duration: 800)),
                  )
                : null,
          ),
          ControlAction(
            label: 'scaleBy',
            icon: Icons.zoom_in,
            note: _relativeCameraMovesSupported ? null : 'Not available on iOS',
            onPressed: _relativeCameraMovesSupported
                ? () => _animate(
                    (map) => map.scaleBy(
                      2,
                      ScreenCoordinate(x: 0, y: 0),
                      MapAnimationOptions(duration: 800),
                    ),
                  )
                : null,
          ),
          ControlAction(
            label: 'Cancel animation',
            icon: Icons.stop_circle_outlined,
            onPressed: () => _animate((map) => map.cancelCameraAnimation()),
          ),
        ];
      case _Mode.viewport:
        return [
          ControlSwitch(
            label: 'Pitched overview',
            icon: Icons.landscape_outlined,
            value: _pitched,
            onChanged: (value) => setState(() => _pitched = value),
          ),
          const SizedBox(height: 8),
          ControlAction(
            label: 'Fly to ${_nextCity.name}',
            icon: Icons.flight_takeoff,
            onPressed: _flyToNextCity,
          ),
          const SizedBox(height: 4),
          const Text(
            'OverviewViewportState frames a geometry, and the viewport '
            'controller animates between states.',
            style: TextStyle(
              fontSize: 11,
              height: 1.35,
              color: MapboxGlass.labelFaint,
            ),
          ),
        ];
      case _Mode.spin:
        return [
          ControlSwitch(
            label: 'Spinning',
            icon: Icons.rotate_right,
            value: _spinning,
            onChanged: (value) {
              setState(() => _spinning = value);
              if (value) {
                _spinSubscription?.resume();
                _mapboxMap?.getCameraState().then(_queueSpin);
              } else {
                _spinSubscription?.pause();
              }
            },
          ),
          const SizedBox(height: 4),
          const Text(
            'Each camera change queues the next easeTo, so the globe keeps '
            'turning. Zoom in past level 5 to stop it, or touch the map — '
            'spinning turns itself off on the first gesture and stays off '
            'until switched back on.',
            style: TextStyle(
              fontSize: 11,
              height: 1.35,
              color: MapboxGlass.labelFaint,
            ),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      scenes: _scenes,
      selectedSceneId: _mode.name,
      onSceneSelected: _selectMode,
      controlsTitle: 'Camera',
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      // One map persists across scenes, and _flyToScene animates it.
      map: MapWidget(
        key: const ValueKey('mapWidget'),
        styleUri: MapboxStyles.STANDARD,
        viewport: CameraViewportState(
          center: Point(coordinates: Position(0, 20)),
          zoom: 2,
        ),
        viewportController: _viewportController,
        onMapCreated: _onMapCreated,
        onCameraChangeListener: _onCameraChanged,
      ),
      controlsBuilder: _buildControls,
    );
  }
}
