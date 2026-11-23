import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart'
    as geolocator
    show Geolocator, LocationPermission, Position;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';
import '../utils.dart';
import '../utils/camera_director.dart';
import '../utils/track_path.dart';

/// The route-line trim animation, in three scenes sharing one map and camera:
///
///  * **Fixed start point** — routes always start from Helsinki.
///  * **Own location as start point** — routes start from the device
///    position, and need geolocation.
///  * **Rainbow road** — animates `LineLayer.lineBorderGradient` along a
///    fixed circuit instead of routing from a tap.
///  * **Free camera drive** — drives a 3D car around the same circuit and
///    moves the camera on every frame with `setFreeCameraOptions`.
///
/// A scene switch flies the camera instead of recreating the map, and removes
/// the previous scene's layers and sources first.
class AnimatedRouteExample extends StatefulWidget {
  const AnimatedRouteExample({super.key});

  @override
  State<AnimatedRouteExample> createState() => _AnimatedRouteExampleState();
}

enum _Mode { fixed, own, rainbow, drive }

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
  Scene(
    id: 'drive',
    title: 'Free camera drive',
    subtitle: 'Follow a car around the Circuit de Monaco',
    icon: Icons.directions_car,
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
  _MonacoDrive? _drive;

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
    _drive?.dispose();
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
    await _addDriveScene();
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
        // Where a 3D bridge or building stands in front of the track, it
        // hides the line, so the line looks like it lies on the street.
        lineOcclusionOpacity: 0,
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

  Future<void> _addDriveScene() async {
    final map = _mapboxMap;
    final coordinates = _rainbowTrackCoordinates;
    if (map == null || coordinates == null) return;
    await _MonacoDrive.addToStyle(map);
    _drive?.dispose();
    _drive = _MonacoDrive(
      map: map,
      track: TrackPath([for (final point in coordinates) point.coordinates]),
      vsync: this,
    );
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
    if (_mode != _Mode.drive) _drive?.stop();
    // The drive reads better in color; the route scenes use a calm,
    // monochrome basemap.
    _mapboxMap?.setStyleImportConfigProperty(
      'basemap',
      'theme',
      _mode == _Mode.drive ? 'default' : 'monochrome',
    );
    _goToModeStart();
  }

  /// Clears the route and markers, then flies to the new scene's start point.
  ///
  /// Runs under the same [_busy] guard as [_showRoute], so a tap during an
  /// unresolved switch cannot draw a route the switch then clears. If the
  /// scene changes while a switch runs, the new scene starts after it.
  Future<void> _goToModeStart() async {
    final map = _mapboxMap;
    if (map == null || _busy) return;
    final mode = _mode;
    setState(() => _busy = true);
    try {
      await _clearRoute();
      await _setMarkers(const []);
      await _goToModeStartBody(map);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (mounted && _mode != mode) await _goToModeStart();
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
      case _Mode.drive:
        await _drive?.start();
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
      case _Mode.drive:
        return null;
    }
  }

  Future<void> _showRoute(Position start, Position end) async {
    final map = _mapboxMap;
    if (map == null || _busy) return;
    final mode = _mode;
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
    // A scene picked while the route loaded starts now and clears the route.
    if (mounted && _mode != mode) await _goToModeStart();
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
      case _Mode.drive:
        final drive = _drive;
        if (drive == null) return const [];
        return [
          ControlAction(
            label: drive.paused ? 'Play' : 'Pause',
            icon: drive.paused ? Icons.play_arrow : Icons.pause,
            onPressed: () => setState(() => drive.paused = !drive.paused),
          ),
          ControlSlider(
            label: 'Speed',
            value: drive.timeScale,
            min: 0.25,
            max: 1.5,
            fractionDigits: 2,
            unit: '×',
            onChanged: (value) => setState(() => drive.timeScale = value),
          ),
          const SizedBox(height: 4),
          const Text(
            'setFreeCameraOptions moves the camera on every frame. While '
            'paused, drag the map to look around.',
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
      controlsTitle: switch (_mode) {
        _Mode.rainbow => 'Rainbow road',
        _Mode.drive => 'Free camera drive',
        _ => 'Route',
      },
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

/// Drives a 3D car around the Circuit de Monaco and moves the camera with it
/// on every frame with `setFreeCameraOptions`.
class _MonacoDrive {
  _MonacoDrive({
    required MapboxMap map,
    required TrackPath track,
    required TickerProvider vsync,
  }) : _map = map,
       _track = track,
       _director = CameraDirector(track: track, zones: _monacoShotZones) {
    _ticker = vsync.createTicker(_onTick);
  }

  static const _modelId = 'drive-car';
  static const _sourceId = 'drive-car-source';
  static const _layerId = 'drive-car-layer';
  static const _modelUri =
      'https://docs.mapbox.com/mapbox-gl-js/assets/ego_car.glb';

  static const _minSpeed = 13.5;
  static const _maxSpeed = 57.0;
  static const _maxLateralAcceleration = 31.5;

  /// How fast the car speeds up and slows down, in meters per second
  /// squared.
  static const _acceleration = 15.75;
  static const _braking = 31.5;

  /// Highest zoom level during the drive.
  static const _maxZoom = 25.5;

  /// Adds the car source and layer to the style, hidden.
  ///
  /// The car is a model source model, not a GeoJSON feature: the map
  /// applies a new model position at once, but parses GeoJSON in the
  /// background, so a GeoJSON car would trail the camera.
  static Future<void> addToStyle(MapboxMap map) async {
    await map.addSource(ModelSource(id: _sourceId));
    await map.addLayer(
      ModelLayer(id: _layerId, sourceId: _sourceId)
        ..modelType = ModelType.COMMON_3D
        ..modelScale = [1.4, 1.4, 1.4]
        ..visibility = Visibility.NONE,
    );
  }

  final MapboxMap _map;
  final TrackPath _track;
  final CameraDirector _director;
  late final Ticker _ticker;

  /// Whether the car stands still. While paused, the scene does not move
  /// the camera, so map gestures can place it.
  bool paused = false;

  /// How fast the scene plays, where 1 is real time.
  double timeScale = 1;

  /// Whether the scene shows. A [stop] during [start] cancels the start.
  var _active = false;
  var _distance = 0.0;
  var _speed = 0.0;

  /// Scene seconds since the last frame that reached the map.
  var _frameDt = 0.0;
  Duration? _lastElapsed;
  var _frameInFlight = false;
  double? _previousMaxZoom;

  /// The last known terrain height under the car. The map returns no height
  /// while the terrain under the car is still loading.
  var _groundElevation = 0.0;

  /// Shows the car and continues the drive from where it stopped.
  Future<void> start() async {
    _active = true;
    // The close chase camera needs zoom levels above 22, the default
    // maximum on web. 25.5 is the default maximum on Android and iOS.
    _previousMaxZoom ??= (await _map.getBounds()).maxZoom;
    if (!_active) return;
    await _map.setBounds(CameraBoundsOptions(maxZoom: _maxZoom));
    await _map.setStyleLayerProperty(_layerId, 'visibility', 'visible');
    if (!_active || _ticker.isActive) return;
    _lastElapsed = null;
    _ticker.start();
  }

  /// Stops the drive and hides the car.
  Future<void> stop() async {
    _active = false;
    _ticker.stop();
    await _map.setStyleLayerProperty(_layerId, 'visibility', 'none');
    final previousMaxZoom = _previousMaxZoom;
    if (previousMaxZoom != null) {
      _previousMaxZoom = null;
      await _map.setBounds(CameraBoundsOptions(maxZoom: previousMaxZoom));
    }
  }

  void dispose() => _ticker.dispose();

  void _onTick(Duration elapsed) {
    final last = _lastElapsed ?? elapsed;
    _lastElapsed = elapsed;
    final dt =
        ((elapsed - last).inMicroseconds / 1e6).clamp(0.0, 0.1) * timeScale;

    if (!paused) {
      final target = _track.cornerSpeedAt(
        _distance,
        minSpeed: _minSpeed,
        maxSpeed: _maxSpeed,
        maxLateralAcceleration: _maxLateralAcceleration,
      );
      _speed += (target - _speed).clamp(-_braking * dt, _acceleration * dt);
      _distance = (_distance + _speed * dt) % _track.length;
    }
    _frameDt += dt;

    // Skip a frame while the previous one is still on its way to the map,
    // so the calls do not queue up.
    if (_frameInFlight) return;
    unawaited(_renderFrame(_distance, _frameDt));
    _frameDt = 0;
  }

  Future<void> _renderFrame(double distance, double dt) async {
    final car = _track.sample(distance);
    _frameInFlight = true;
    try {
      // The calls do not wait for each other, so a frame waits for one round
      // trip to the map, not three. The camera uses the ground height from
      // the previous frame.
      await Future.wait([
        _map.setStyleSourceProperty(_sourceId, 'models', {
          _modelId: ModelSourceModel(
            id: _modelId,
            uri: _modelUri,
            position: [
              car.position.lng.toDouble(),
              car.position.lat.toDouble(),
            ],
            orientation: [0, 0, car.heading],
          ).toJson(),
        }),
        _map.getElevation(Point(coordinates: car.position)).then((elevation) {
          if (elevation != null) _groundElevation = elevation;
        }),
        if (!paused && _active)
          _map.setFreeCameraOptions(
            _director.update(distance, dt, groundElevation: _groundElevation),
          ),
      ]);
    } finally {
      _frameInFlight = false;
    }
  }
}

/// The shots for the Circuit de Monaco, by distance along the track. The
/// track data starts in Casino Square, and the car drives clockwise.
///
/// Tight corners between buildings get the close shots, hairpins get a
/// trackside camera, and the open stretches by the harbor get the wide
/// shots.
final _monacoShotZones = [
  // Out of Casino Square and down to Mirabeau Haute. Low and straight
  // behind the car, so the long building on the left does not hide it.
  const ShotZone(
    start: 30,
    shot: CameraShot.chase,
    back: 50,
    right: 0,
    up: 6.6,
    aim: 0,
  ),
  // Mirabeau Haute. A crane move over the car down to the exit of the
  // corner, then the camera follows the car through it.
  ShotZone(
    start: 90,
    shot: CameraShot.trackside,
    camera: Position(7.42895, 43.74139),
    up: 17,
    blendSeconds: 3,
    arc: 90,
  ),
  // The Fairmont hairpin, the slowest corner of the lap. The camera is low
  // at the bottom of the hairpin, in front of the building behind it, and
  // turns to follow the car around it. The cut passes on the car's right,
  // over the trees.
  ShotZone(
    start: 304,
    shot: CameraShot.trackside,
    camera: Position(7.429633, 43.740122),
    up: 8,
    passRight: true,
    arc: 35,
  ),
  // Mirabeau Bas, in a narrow street. High and straight behind, between the
  // buildings on both sides. It turns with the car, so the building on the
  // left does not cut in before the corner.
  const ShotZone(
    start: 417,
    shot: CameraShot.chase,
    back: 33,
    right: -2,
    up: 24,
    aim: 0.1,
    followsHeading: true,
  ),
  // Portier and the tunnel. The hood camera is the only shot that the
  // tunnel walls and roof do not block.
  const ShotZone(start: 560, shot: CameraShot.hood),
  // Out of the tunnel and down to the Nouvelle Chicane.
  const ShotZone(start: 1010, shot: CameraShot.chase),
  // The Nouvelle Chicane. Nothing stands next to the road here, so a high
  // camera shows the chicane and the harbor.
  const ShotZone(start: 1135, shot: CameraShot.overhead),
  // The open run along the harbor to Tabac, filmed from the side to show the
  // speed.
  const ShotZone(start: 1275, shot: CameraShot.side),
  // Tabac and the entry to the first Swimming Pool chicane.
  const ShotZone(start: 1450, shot: CameraShot.chase),
  // The Swimming Pool chicanes. A high camera shows the left-right shape of
  // the corners.
  const ShotZone(start: 1700, shot: CameraShot.overhead),
  // The exit of the second Swimming Pool chicane, toward La Rascasse.
  const ShotZone(start: 1860, shot: CameraShot.chase),
  // La Rascasse. Above the roofs outside the corner, so both legs of it
  // show.
  ShotZone(
    start: 1960,
    shot: CameraShot.trackside,
    camera: Position(7.423537, 43.731975),
    up: 95,
  ),
  // Anthony Noghes and the start and finish straight. The hood camera
  // shows the speed on the longest straight of the lap.
  const ShotZone(start: 2200, shot: CameraShot.hood),
  // Braking for Sainte Dévote.
  const ShotZone(start: 2560, shot: CameraShot.chase),
  // The climb up Beau Rivage. A wide camera shows the hill and the harbor
  // behind it.
  const ShotZone(start: 2700, shot: CameraShot.wide),
  // The top of Beau Rivage. A side camera, higher than usual, so the low
  // buildings on the right do not hide the car.
  const ShotZone(
    start: 2875,
    shot: CameraShot.side,
    back: 8.5,
    right: 22,
    up: 13.7,
  ),
  // The long left turn of Massenet.
  const ShotZone(start: 3100, shot: CameraShot.chase),
  // The exit of Massenet. Close behind the car, so the cut into the hood
  // camera does not pass through the building at the corner.
  const ShotZone(
    start: 3200,
    shot: CameraShot.chase,
    back: 15,
    right: 5,
    up: 8,
    aim: 0.1,
  ),
  // Into Casino Square. The hood camera continues into the next lap.
  const ShotZone(start: 3258, shot: CameraShot.hood),
];
