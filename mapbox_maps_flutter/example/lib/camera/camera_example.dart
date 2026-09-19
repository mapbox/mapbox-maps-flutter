import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// Drives the camera from sliders and reads the result back.
///
/// The sliders write with `setCamera`, and the HUD shows what
/// `getCameraState` reports. The framing actions do the opposite: they ask the
/// map which camera fits a given shape, then fly there.
class CameraExample extends StatefulWidget {
  const CameraExample({super.key});

  @override
  State<CameraExample> createState() => _CameraExampleState();
}

/// Corners of the Eiffel Tower base, about 125 m square.
const _landmarkSouthWest = [2.2937, 48.8578];
const _landmarkNorthEast = [2.2953, 48.8590];

/// Where the map opens. The tower starts off screen, so each framing action
/// has to travel to reach it.
const _openingCenter = [2.3400, 48.8650];
const _openingZoom = 12.0;

/// Zoom ceiling for the framing actions. Both fits are computed from the flat
/// footprint, so an exact fit would crop the tower's height.
const _maxFitZoom = 16.0;

/// The tower footprint: the [_landmarkSouthWest]/[_landmarkNorthEast] box,
/// traced clockwise from its south-west corner.
const _landmarkFootprint = [
  [2.2937, 48.8578],
  [2.2937, 48.8590],
  [2.2953, 48.8590],
  [2.2953, 48.8578],
];

class _CameraExampleState extends State<CameraExample> {
  MapboxMap? _mapboxMap;

  /// Seeded to match the opening camera, so the first slider touch does not
  /// move the map.
  double _zoom = _openingZoom;
  double _pitch = 0;
  double _bearing = 0;
  double _paddingTop = 0;
  double _paddingRight = 0;
  double _paddingBottom = 0;
  double _paddingLeft = 0;

  CameraState? _state;
  CoordinateBounds? _bounds;

  /// Cleared when the platform has no `coordinateBoundsForCamera`, which is
  /// the case on web.
  bool _boundsSupported = true;

  /// Set while a slider drives the camera. The camera-change listener also
  /// fires for these writes, and must not move the thumb the user holds.
  bool _driving = false;

  void _onMapCreated(MapboxMap mapboxMap) {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
    _syncFromMap();
  }

  /// Pulls the camera state into the sliders and the HUD, on every camera
  /// change.
  Future<void> _syncFromMap() async {
    final map = _mapboxMap;
    if (map == null) return;
    final state = await map.getCameraState();
    CoordinateBounds? bounds;
    if (_boundsSupported) {
      try {
        bounds = await map.coordinateBoundsForCamera(
          CameraOptions(
            center: state.center,
            zoom: state.zoom,
            pitch: state.pitch,
            bearing: state.bearing,
          ),
        );
      } on UnimplementedError {
        // Not available on web. The flag stays false, so the call is not
        // retried on every camera change.
        _boundsSupported = false;
      }
    }
    if (!mounted) return;
    setState(() {
      _state = state;
      _bounds = bounds;
      if (!_driving) {
        _zoom = state.zoom;
        _pitch = state.pitch;
        _bearing = state.bearing;
      }
    });
  }

  /// Writes the slider values to the camera.
  Future<void> _apply() async {
    _driving = true;
    await _mapboxMap?.setCamera(
      CameraOptions(
        zoom: _zoom,
        pitch: _pitch,
        bearing: _bearing,
        padding: MbxEdgeInsets(
          top: _paddingTop,
          left: _paddingLeft,
          bottom: _paddingBottom,
          right: _paddingRight,
        ),
      ),
    );
    // The callback for this write arrives while _driving is set, so it
    // leaves the readout untouched. Refresh it here instead.
    _driving = false;
    await _syncFromMap();
  }

  /// Asks the map for a flat, north-up camera that fits the tower base.
  ///
  /// `cameraForCoordinateBounds` is the inverse of the sliders above.
  Future<void> _frameBounds() async {
    final map = _mapboxMap;
    if (map == null) return;
    final camera = await map.cameraForCoordinateBounds(
      CoordinateBounds(
        southwest: Point(
          coordinates: Position(_landmarkSouthWest[0], _landmarkSouthWest[1]),
        ),
        northeast: Point(
          coordinates: Position(_landmarkNorthEast[0], _landmarkNorthEast[1]),
        ),
        infiniteBounds: false,
      ),
      MbxEdgeInsets(top: 40, left: 40, bottom: 40, right: 40),
      // North-up and flat, to contrast with the pitched action below.
      0,
      0,
      _maxFitZoom,
      null,
    );
    await map.flyTo(camera, MapAnimationOptions(duration: 1200));
  }

  /// Fits the same landmark expressed as a polygon geometry, with a pitch
  /// that looks up the tower.
  Future<void> _frameGeometry() async {
    final map = _mapboxMap;
    if (map == null) return;
    final camera = await map.cameraForGeometry(
      Polygon(
        coordinates: [
          [for (final pair in _landmarkFootprint) Position(pair[0], pair[1])],
        ],
      ).toJson(),
      MbxEdgeInsets(top: 60, left: 60, bottom: 60, right: 60),
      335,
      65,
    );
    // `cameraForGeometry` takes no zoom limit, so clamp the result the way
    // the bounds action asks the map to.
    final zoom = camera.zoom;
    if (zoom != null && zoom > _maxFitZoom) camera.zoom = _maxFitZoom;
    await map.flyTo(camera, MapAnimationOptions(duration: 1200));
  }

  /// One corner of the visible bounds, or why there is no value to show.
  String _cornerLabel(Point? corner) {
    if (!_boundsSupported) return 'n/a on web';
    if (corner == null) return '—';
    return '${corner.coordinates.lng.toStringAsFixed(3)}, '
        '${corner.coordinates.lat.toStringAsFixed(3)}';
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;
    final bounds = _bounds;
    return MapScaffold(
      controlsTitle: 'Camera',
      controlsSheetSize: ControlsSheetSize.large,
      map: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('mapWidget'),
            styleUri: MapboxStyles.STANDARD,
            viewport: CameraViewportState(
              center: Point(
                coordinates: Position(_openingCenter[0], _openingCenter[1]),
              ),
              zoom: _openingZoom,
            ),
            onMapCreated: _onMapCreated,
            onCameraChangeListener: (_) => _syncFromMap(),
          ),
          IgnorePointer(
            child: _PaddingOverlay(
              top: _paddingTop,
              right: _paddingRight,
              bottom: _paddingBottom,
              left: _paddingLeft,
            ),
          ),
          MapHud(
            title: 'getCameraState',
            rows: [
              MapHudRow(
                'center',
                state == null
                    ? '—'
                    : '${state.center.coordinates.lng.toStringAsFixed(4)}, '
                          '${state.center.coordinates.lat.toStringAsFixed(4)}',
                emphasized: true,
              ),
              MapHudRow(
                'zoom',
                state == null ? '—' : state.zoom.toStringAsFixed(2),
              ),
              MapHudRow(
                'pitch',
                state == null ? '—' : '${state.pitch.toStringAsFixed(1)}°',
              ),
              MapHudRow(
                'bearing',
                state == null ? '—' : '${state.bearing.toStringAsFixed(1)}°',
              ),
              MapHudRow(
                'padding T/R/B/L',
                state == null
                    ? '—'
                    : '${state.padding.top.toStringAsFixed(0)}/'
                          '${state.padding.right.toStringAsFixed(0)}/'
                          '${state.padding.bottom.toStringAsFixed(0)}/'
                          '${state.padding.left.toStringAsFixed(0)}',
              ),
              MapHudRow('visible NE', _cornerLabel(bounds?.northeast)),
              MapHudRow('visible SW', _cornerLabel(bounds?.southwest)),
            ],
          ),
        ],
      ),
      controlsBuilder: () => [
        ControlSlider(
          label: 'Zoom',
          value: _zoom,
          min: 0,
          max: 22,
          fractionDigits: 2,
          onChanged: (value) {
            setState(() => _zoom = value);
            _apply();
          },
        ),
        ControlSlider(
          label: 'Pitch',
          value: _pitch,
          min: 0,
          max: 85,
          unit: '°',
          onChanged: (value) {
            setState(() => _pitch = value);
            _apply();
          },
        ),
        ControlSlider(
          label: 'Bearing',
          value: _bearing,
          min: -180,
          max: 180,
          unit: '°',
          onChanged: (value) {
            setState(() => _bearing = value);
            _apply();
          },
        ),
        const Text(
          'PADDING',
          style: TextStyle(
            color: MapboxGlass.labelFaint,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Padding tells the map to treat part of the screen as covered — '
          'by a toolbar, a bottom sheet, a legend — so it centers content '
          'in the space that is left. The shaded bands on the map mark '
          'the padded area on each side; the camera\'s optical center is '
          'the middle of the clear area, not the middle of the screen.',
          style: TextStyle(
            fontSize: 11,
            height: 1.35,
            color: MapboxGlass.labelFaint,
          ),
        ),
        const SizedBox(height: 8),
        ControlSlider(
          label: 'Top',
          value: _paddingTop,
          min: 0,
          max: 300,
          fractionDigits: 0,
          onChanged: (value) {
            setState(() => _paddingTop = value);
            _apply();
          },
        ),
        ControlSlider(
          label: 'Right',
          value: _paddingRight,
          min: 0,
          max: 300,
          fractionDigits: 0,
          onChanged: (value) {
            setState(() => _paddingRight = value);
            _apply();
          },
        ),
        ControlSlider(
          label: 'Bottom',
          value: _paddingBottom,
          min: 0,
          max: 300,
          fractionDigits: 0,
          onChanged: (value) {
            setState(() => _paddingBottom = value);
            _apply();
          },
        ),
        ControlSlider(
          label: 'Left',
          value: _paddingLeft,
          min: 0,
          max: 300,
          fractionDigits: 0,
          onChanged: (value) {
            setState(() => _paddingLeft = value);
            _apply();
          },
        ),
        const SizedBox(height: 4),
        ControlAction(
          label: 'Fit bounds',
          icon: Icons.crop_free,
          onPressed: _frameBounds,
        ),
        ControlAction(
          label: 'Fit geometry, pitched',
          icon: Icons.pentagon_outlined,
          onPressed: _frameGeometry,
        ),
        const SizedBox(height: 4),
        const Text(
          'Sliders write the camera; the readout is what the map reports '
          'back. Drag the map and the sliders follow. Equal padding on '
          'opposite sides cancels out, so try one side at a time to see '
          'the center actually move.',
          style: TextStyle(
            fontSize: 11,
            height: 1.35,
            color: MapboxGlass.labelFaint,
          ),
        ),
      ],
    );
  }
}

/// Shades the area each padding slider covers.
///
/// Draws the same insets the sliders send to `setCamera`, as a stand-in for
/// the UI that would occupy that space.
class _PaddingOverlay extends StatelessWidget {
  const _PaddingOverlay({
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
  });

  final double top;
  final double right;
  final double bottom;
  final double left;

  static const _tint = Color(0x330062CA);
  static const _edge = MapboxColors.blue40;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (top > 0)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: top,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: _tint,
                border: Border(bottom: BorderSide(color: _edge, width: 1)),
              ),
            ),
          ),
        if (bottom > 0)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: bottom,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: _tint,
                border: Border(top: BorderSide(color: _edge, width: 1)),
              ),
            ),
          ),
        if (left > 0)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            width: left,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: _tint,
                border: Border(right: BorderSide(color: _edge, width: 1)),
              ),
            ),
          ),
        if (right > 0)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            width: right,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: _tint,
                border: Border(left: BorderSide(color: _edge, width: 1)),
              ),
            ),
          ),
      ],
    );
  }
}
