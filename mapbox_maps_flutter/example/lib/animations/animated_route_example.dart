import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart'
    as geolocator
    show Geolocator, LocationPermission, Position;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';
import '../utils.dart';

/// The route-line trim animation, in three scenes sharing one map and camera:
///
///  * **Fixed start point** — routes always start from Helsinki.
///  * **Own location as start point** — routes start from the device
///    position, and need geolocation.
///  * **Rainbow road** — animates `LineLayer.lineBorderGradient` along a
///    fixed circuit instead of routing from a tap.
///
/// A scene switch flies the camera instead of recreating the map, and removes
/// the previous scene's layers and sources first.
class AnimatedRouteExample extends StatefulWidget {
  const AnimatedRouteExample({super.key});

  @override
  State<AnimatedRouteExample> createState() => _AnimatedRouteExampleState();
}

enum _Mode { fixed, own, rainbow }

const _scenes = [
  Scene(
    id: 'fixed',
    title: 'Fixed start point',
    subtitle: 'Tap the map to route from Helsinki',
    icon: Icons.location_pin,
  ),
  Scene(
    id: 'own',
    title: 'Own location as start point',
    subtitle: 'Tap the map to route from your position',
    icon: Icons.my_location,
  ),
  Scene(
    id: 'rainbow',
    title: 'Rainbow road',
    subtitle: 'Animate a gradient border along the Circuit de Monaco',
    icon: Icons.gradient,
  ),
];

class _AnimatedRouteExampleState extends State<AnimatedRouteExample>
    with TickerProviderStateMixin {
  static const String _accessToken = String.fromEnvironment('ACCESS_TOKEN');

  static final _fixedStart = Position(24.9384, 60.1699); // Helsinki

  static const _emptyCollection = '{"type":"FeatureCollection","features":[]}';

  static const _rainbowLayerId = 'rainbow-track-line';
  static const _rainbowSourceId = 'rainbow-track-source';

  /// Real circuit outline for the Circuit de Monaco, sourced from
  /// https://github.com/bacinger/f1-circuits (mc-1929.geojson).
  static const _rainbowTrackAsset = 'assets/monaco_gp_circuit.geojson';

  MapboxMap? _mapboxMap;
  AnimationController? _controller;
  Timer? _rainbowTimer;
  var _rainbowPhase = 0.0;
  var _rainbowAnimating = true;
  var _rainbowSpeed = 0.03;
  List<Point>? _rainbowTrackCoordinates;

  var _mode = _Mode.fixed;
  var _busy = false;
  String? _liveStatus;

  /// The device position for the own-location scene. Resolved once, because a
  /// GPS fix can take tens of seconds.
  Position? _ownLocation;

  @override
  void dispose() {
    _controller?.dispose();
    _rainbowTimer?.cancel();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
    mapboxMap.addInteraction(TapInteraction.onMap(_onMapTapped));
  }

  Future<void> _onStyleLoadedCallback(StyleLoadedEventData data) async {
    await _addRouteLineLayerAndSource();
    await _addMarkerLayerAndSource();
    await _addRainbowLayerAndSource();
    await _mapboxMap?.setStyleImportConfigProperty(
      'basemap',
      'theme',
      'monochrome',
    );
    await _goToModeStart();
  }

  Future<void> _addRouteLineLayerAndSource() async {
    final map = _mapboxMap;
    if (map == null) return;
    // The source must exist before the layer that references it: web
    // rejects addLayer with a dangling sourceId, unlike native.
    await map.addSource(GeoJsonSource(id: 'route-source', lineMetrics: true));
    await map.addLayer(
      LineLayer(
        id: 'route-layer',
        sourceId: 'route-source',
        lineCap: LineCap.ROUND,
        lineJoin: LineJoin.ROUND,
        lineWidth: 5.0,
        lineGradientExpression: [
          'interpolate',
          ['linear'],
          ['line-progress'],
          0.0,
          ['rgb', 255, 0, 0],
          0.4,
          ['rgb', 0, 255, 0],
          1.0,
          ['rgb', 0, 0, 255],
        ],
      ),
    );
  }

  // Point annotations are not supported on web, so the markers are a circle
  // layer over a GeoJSON source, which works on every platform.
  Future<void> _addMarkerLayerAndSource() async {
    final map = _mapboxMap;
    if (map == null) return;
    await map.addSource(
      GeoJsonSource(id: 'marker-source', data: _emptyCollection),
    );
    await map.addLayer(
      CircleLayer(
        id: 'marker-layer',
        sourceId: 'marker-source',
        circleRadius: 7,
        circleColor: MapboxColors.blue50.toARGB32(),
        circleStrokeWidth: 2.5,
        circleStrokeColor: Colors.white.toARGB32(),
      ),
    );
  }

  Future<void> _addRainbowLayerAndSource() async {
    final map = _mapboxMap;
    if (map == null) return;
    final trackGeoJson = await rootBundle.loadString(_rainbowTrackAsset);
    final track = json.decode(trackGeoJson);
    final coordinates = track['features'][0]['geometry']['coordinates'] as List;
    _rainbowTrackCoordinates = [
      for (final coordinate in coordinates.cast<List>())
        Point(
          coordinates: Position(coordinate[0] as num, coordinate[1] as num),
        ),
    ];
    await map.addSource(
      GeoJsonSource(
        id: _rainbowSourceId,
        data: trackGeoJson,
        lineMetrics: true,
      ),
    );
    await map.addLayer(
      LineLayer(
        id: _rainbowLayerId,
        sourceId: _rainbowSourceId,
        lineCap: LineCap.ROUND,
        lineJoin: LineJoin.ROUND,
        lineColor: Colors.grey.shade800.toARGB32(),
        lineWidth: 4.0,
        lineBorderWidth: 5.0,
        lineBorderGradientExpression: _rainbowExpression(_rainbowPhase),
      ),
    );
    if (_mode == _Mode.rainbow) {
      _startRainbowAnimation();
    }
  }

  void _startRainbowAnimation() {
    _rainbowTimer?.cancel();
    _rainbowTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final map = _mapboxMap;
      if (map == null) return;
      _rainbowPhase = (_rainbowPhase + _rainbowSpeed) % 1.0;
      map.setStyleLayerProperty(
        _rainbowLayerId,
        'line-border-gradient',
        _rainbowExpression(_rainbowPhase),
      );
    });
  }

  void _toggleRainbowAnimation() {
    setState(() {
      _rainbowAnimating = !_rainbowAnimating;
      if (_rainbowAnimating) {
        _startRainbowAnimation();
      } else {
        _rainbowTimer?.cancel();
      }
    });
  }

  Future<void> _setMarkers(List<Position> positions) async {
    final map = _mapboxMap;
    if (map == null) return;
    final source = await map.getSource('marker-source');
    final collection = {
      'type': 'FeatureCollection',
      'features': [
        for (final position in positions)
          {
            'type': 'Feature',
            'geometry': {
              'type': 'Point',
              'coordinates': [position.lng, position.lat],
            },
            'properties': {},
          },
      ],
    };
    (source as GeoJsonSource).updateGeoJSON(json.encode(collection));
  }

  Future<void> _clearRoute() async {
    _controller?.dispose();
    _controller = null;
    final map = _mapboxMap;
    if (map == null) return;
    final source = await map.getSource('route-source');
    (source as GeoJsonSource).updateGeoJSON(_emptyCollection);
  }

  void _selectMode(String id) {
    setState(() {
      _mode = _Mode.values.firstWhere((mode) => mode.name == id);
      _liveStatus = null;
    });
    if (_mode == _Mode.rainbow) {
      if (_rainbowAnimating) _startRainbowAnimation();
    } else {
      _rainbowTimer?.cancel();
    }
    _goToModeStart();
  }

  /// Clears the route and markers, then flies to the new scene's start point.
  ///
  /// Runs under the same [_busy] guard as [_showRoute], so a tap during an
  /// unresolved switch cannot draw a route the switch then clears.
  Future<void> _goToModeStart() async {
    final map = _mapboxMap;
    if (map == null || _busy) return;
    setState(() => _busy = true);
    try {
      await _clearRoute();
      await _setMarkers(const []);
      await _goToModeStartBody(map);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _goToModeStartBody(MapboxMap map) async {
    switch (_mode) {
      case _Mode.fixed:
        await _setMarkers([_fixedStart]);
        await map.flyTo(
          CameraOptions(center: Point(coordinates: _fixedStart), zoom: 11),
          MapAnimationOptions(duration: 1200),
        );
      case _Mode.own:
        var position = _ownLocation;
        if (position == null) {
          setState(() => _liveStatus = 'Requesting location…');
          position = await _resolveLivePosition();
          if (!mounted || _mode != _Mode.own) return;
          if (position == null) {
            setState(
              () => _liveStatus =
                  'Location unavailable. Allow location access and try '
                  'again.',
            );
            return;
          }
          _ownLocation = position;
        }
        setState(() => _liveStatus = null);
        await map.location.updateSettings(
          LocationComponentSettings(enabled: true),
        );
        await _setMarkers([position]);
        await map.flyTo(
          CameraOptions(center: Point(coordinates: position), zoom: 11),
          MapAnimationOptions(duration: 1200),
        );
      case _Mode.rainbow:
        final coordinates = _rainbowTrackCoordinates;
        if (coordinates == null) return;
        final camera = await map.cameraForCoordinates(
          coordinates,
          MbxEdgeInsets(top: 40, left: 40, bottom: 40, right: 40),
          null,
          null,
        );
        await map.flyTo(camera, MapAnimationOptions(duration: 1200));
    }
  }

  Future<Position?> _resolveLivePosition() async {
    try {
      var permission = await geolocator.Geolocator.checkPermission();
      if (permission == geolocator.LocationPermission.denied) {
        permission = await geolocator.Geolocator.requestPermission();
      }
      if (permission == geolocator.LocationPermission.denied ||
          permission == geolocator.LocationPermission.deniedForever) {
        return null;
      }
      // A cached fix returns at once, and getCurrentPosition() can take tens
      // of seconds. Web has no cached fix and always throws, so this failure
      // does not mean location is unavailable.
      geolocator.Position? cached;
      try {
        cached = await geolocator.Geolocator.getLastKnownPosition();
      } catch (_) {}
      final location =
          cached ?? await geolocator.Geolocator.getCurrentPosition();
      return Position(location.longitude, location.latitude);
    } catch (_) {
      return null;
    }
  }

  Future<void> _onMapTapped(MapContentGestureContext context) async {
    if (_busy) return;
    final start = _currentStart();
    if (start == null) return;
    await _showRoute(start, context.point.coordinates);
  }

  /// The point routes start from. Never resolves the GPS position again: the
  /// scene load does that once. Null in the rainbow scene, which does not
  /// route from taps.
  Position? _currentStart() {
    switch (_mode) {
      case _Mode.fixed:
        return _fixedStart;
      case _Mode.own:
        return _ownLocation;
      case _Mode.rainbow:
        return null;
    }
  }

  Future<void> _showRoute(Position start, Position end) async {
    final map = _mapboxMap;
    if (map == null || _busy) return;
    setState(() => _busy = true);
    try {
      await _setMarkers([start, end]);

      final coordinates = await fetchRouteCoordinates(start, end, _accessToken);
      if (!mounted) return;

      final camera = await map.cameraForCoordinates(
        coordinates.map((position) => Point(coordinates: position)).toList(),
        MbxEdgeInsets(top: 80, left: 60, bottom: 80, right: 60),
        null,
        null,
      );
      await map.flyTo(camera, MapAnimationOptions(duration: 1200));

      await _drawRouteLine(coordinates);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _drawRouteLine(List<Position> polyline) async {
    final map = _mapboxMap;
    if (map == null) return;

    // line-trim-offset makes the segment between its two values transparent,
    // so [0.0, 1.0] hides the whole line before its data updates.
    await map.setStyleLayerProperty('route-layer', 'line-trim-offset', [
      0.0,
      1.0,
    ]);

    final line = LineString(coordinates: polyline);
    final source = await map.getSource('route-source');
    (source as GeoJsonSource).updateGeoJSON(json.encode(line));

    // Disposing, not stopping, drops the old listener, which would otherwise
    // race this one's writes to line-trim-offset.
    _controller?.dispose();
    final controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _controller = controller;
    controller.addListener(() {
      // The transparent tail shrinks from [0, 1], the whole line hidden, to
      // [1, 1], nothing hidden.
      map.setStyleLayerProperty('route-layer', 'line-trim-offset', [
        controller.value,
        1.0,
      ]);
    });
    controller.forward();
  }

  List<Widget> _buildControls() {
    switch (_mode) {
      case _Mode.fixed:
        return const [
          Text(
            'Tap anywhere on the map. A route is fetched from Helsinki to '
            'that point and drawn in with an animated reveal.',
            style: TextStyle(
              fontSize: 11,
              height: 1.35,
              color: MapboxGlass.labelFaint,
            ),
          ),
        ];
      case _Mode.own:
        return [
          if (_liveStatus != null)
            Text(
              _liveStatus!,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: MapboxGlass.labelMuted,
              ),
            )
          else
            const Text(
              'Tap anywhere on the map. A route is fetched from your real '
              'position to that point and drawn in with an animated reveal.',
              style: TextStyle(
                fontSize: 11,
                height: 1.35,
                color: MapboxGlass.labelFaint,
              ),
            ),
        ];
      case _Mode.rainbow:
        return [
          ControlAction(
            label: _rainbowAnimating ? 'Pause' : 'Play',
            icon: _rainbowAnimating ? Icons.pause : Icons.play_arrow,
            onPressed: _toggleRainbowAnimation,
          ),
          ControlSlider(
            label: 'Speed',
            value: _rainbowSpeed,
            min: 0.0,
            max: 0.1,
            fractionDigits: 3,
            onChanged: (value) => setState(() => _rainbowSpeed = value),
          ),
          const SizedBox(height: 4),
          const Text(
            'The gradient phase advances on a timer, which rewrites '
            'line-border-gradient on every tick.',
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
      controlsTitle: _mode == _Mode.rainbow ? 'Rainbow road' : 'Route',
      controlsSheetSize: ControlsSheetSize.small,
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: MapWidget(
        key: const ValueKey('mapWidget'),
        styleUri: MapboxStyles.STANDARD,
        viewport: CameraViewportState(
          center: Point(coordinates: _fixedStart),
          zoom: 11,
        ),
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoadedCallback,
      ),
      controlsBuilder: _buildControls,
    );
  }
}

/// Builds a `line-border-gradient` expression that paints a rainbow along the
/// line, offset by [phase], `0.0` to `1.0`. An incrementing phase makes the
/// colors flow.
List<Object> _rainbowExpression(double phase) {
  const stopCount = 12;
  final stops = <Object>[];
  for (var i = 0; i <= stopCount; i++) {
    final t = i / stopCount;
    final hue = (t + phase) * 360.0 % 360.0;
    final color = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    stops.add(t);
    // The component accessors are normalized, so scale them to 0-255 for the
    // style specification's `rgb` expression.
    stops.add([
      'rgb',
      (color.r * 255).round(),
      (color.g * 255).round(),
      (color.b * 255).round(),
    ]);
  }
  return [
    'interpolate',
    ['linear'],
    ['line-progress'],
    ...stops,
  ];
}
