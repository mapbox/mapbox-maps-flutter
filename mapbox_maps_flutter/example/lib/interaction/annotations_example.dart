import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// Every annotation type on one map, with per-type controls. All four
/// managers share the same create, update, delete and drag surface.
///
/// The annotation managers have no web implementation, so web disables the
/// controls.
class AnnotationsExample extends StatefulWidget {
  const AnnotationsExample({super.key});

  @override
  State<AnnotationsExample> createState() => _AnnotationsExampleState();
}

enum _Kind { point, circle, polyline, polygon }

const _scenes = [
  Scene(
    id: 'point',
    title: 'Point annotations',
    subtitle: 'Icon markers with text',
    icon: Icons.location_on_outlined,
  ),
  Scene(
    id: 'circle',
    title: 'Circle annotations',
    subtitle: 'Styled circle overlays',
    icon: Icons.circle_outlined,
  ),
  Scene(
    id: 'polyline',
    title: 'Polyline annotations',
    subtitle: 'Multi-segment lines',
    icon: Icons.timeline_outlined,
  ),
  Scene(
    id: 'polygon',
    title: 'Polygon annotations',
    subtitle: 'Filled areas with vertices',
    icon: Icons.pentagon_outlined,
  ),
];

class _AnnotationsExampleState extends State<AnnotationsExample> {
  final _random = Random();

  Uint8List? _markerImage;

  var _kind = _Kind.point;
  var _draggable = true;
  var _showLabels = false;

  MapboxMap? _mapboxMap;

  PointAnnotationManager? _points;
  CircleAnnotationManager? _circles;
  PolylineAnnotationManager? _polylines;
  PolygonAnnotationManager? _polygons;

  /// How many annotations exist, per type.
  final _created = <_Kind, int>{};

  /// Where each type's most recently created annotation (or batch) sits, so
  /// switching to that scene flies back to it instead of leaving the camera
  /// wherever it happened to be.
  final _lastPosition = <_Kind, Position>{};

  /// One annotation of each type exists from the start, each at a different,
  /// fixed spot worldwide — so a scene switch before the user adds anything
  /// still has somewhere new to fly to.
  static final _seedPositions = {
    _Kind.point: Position(-0.1276, 51.5072), // London
    _Kind.circle: Position(139.6917, 35.6895), // Tokyo
    _Kind.polyline: Position(-74.006, 40.7128), // New York
    _Kind.polygon: Position(151.2093, -33.8688), // Sydney
  };

  Position _randomPosition() => Position(
    _random.nextDouble() * 360.0 - 180.0,
    _random.nextDouble() * 140.0 - 70.0,
  );

  /// A batch of [count] positions clustered within a few degrees of one
  /// random point, so `cameraForCoordinateBounds` over the batch frames a
  /// neighborhood instead of spanning half the globe.
  List<Position> _randomCluster(int count) {
    final anchor = _randomPosition();
    const spread = 3.0;
    return [
      for (var i = 0; i < count; i++)
        Position(
          (anchor.lng + _random.nextDouble() * spread * 2 - spread).clamp(
            -180,
            180,
          ),
          (anchor.lat + _random.nextDouble() * spread * 2 - spread).clamp(
            -85,
            85,
          ),
        ),
    ];
  }

  /// A small ring around [center], used for the line and polygon geometries.
  List<Position> _ring(Position center, {bool close = true}) {
    final ring = [
      for (var i = 0; i < 5; i++)
        Position(
          center.lng + _random.nextDouble() * 12 - 6,
          center.lat + _random.nextDouble() * 12 - 6,
        ),
    ];
    return close ? [...ring, ring.first] : ring;
  }

  int _randomColor() => Color.fromARGB(
    255,
    _random.nextInt(200) + 40,
    _random.nextInt(200) + 40,
    _random.nextInt(200) + 40,
  ).toARGB32();

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
    await mapboxMap.setCamera(
      CameraOptions(center: Point(coordinates: Position(0, 20)), zoom: 1.4),
    );

    final bytes = await rootBundle.load('assets/symbols/custom-icon.png');
    _markerImage = bytes.buffer.asUint8List();

    if (kIsWeb) return;

    final annotations = mapboxMap.annotations;
    _points = await annotations.createPointAnnotationManager();
    _circles = await annotations.createCircleAnnotationManager();
    _polylines = await annotations.createPolylineAnnotationManager();
    _polygons = await annotations.createPolygonAnnotationManager();

    _points?.tapEvents(onTap: (a) => _report('Tapped point ${a.id}'));
    _circles?.tapEvents(onTap: (a) => _report('Tapped circle ${a.id}'));
    _polylines?.tapEvents(onTap: (a) => _report('Tapped line ${a.id}'));
    _polygons?.tapEvents(onTap: (a) => _report('Tapped polygon ${a.id}'));

    _points?.dragEvents(onEnd: (a) => _report('Moved point ${a.id}'));
    _circles?.dragEvents(onEnd: (a) => _report('Moved circle ${a.id}'));
    _polylines?.dragEvents(onEnd: (a) => _report('Moved line ${a.id}'));
    _polygons?.dragEvents(onEnd: (a) => _report('Moved polygon ${a.id}'));

    // One annotation of each type from the start, so a scene switch has
    // somewhere to fly to even before the user adds anything.
    for (final kind in _Kind.values) {
      final position = _seedPositions[kind]!;
      await _createAnnotation(kind, position);
      _lastPosition[kind] = position;
    }
    if (mounted) {
      setState(() {
        for (final kind in _Kind.values) {
          _created[kind] = 1;
        }
      });
    }
    await _flyToPosition(_seedPositions[_kind]!);
  }

  void _report(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  /// Flies to the single [position], for one added annotation or a scene
  /// switch back to what is already there.
  Future<void> _flyToPosition(Position position) async {
    final map = _mapboxMap;
    if (map == null) return;
    await map.flyTo(
      CameraOptions(center: Point(coordinates: position), zoom: 4),
      MapAnimationOptions(duration: 1000),
    );
  }

  /// Flies to fit every position in [positions], which must be non-empty.
  ///
  /// Only ever called with one freshly created batch, whose positions are
  /// clustered close together — never the type's whole history, which could
  /// be scattered worldwide and would zoom out to fit all of it.
  Future<void> _flyToFitBatch(_Kind kind, List<Position> positions) async {
    final map = _mapboxMap;
    if (map == null) return;

    var west = positions.first.lng;
    var east = positions.first.lng;
    var south = positions.first.lat;
    var north = positions.first.lat;
    for (final position in positions.skip(1)) {
      west = min(west, position.lng);
      east = max(east, position.lng);
      south = min(south, position.lat);
      north = max(north, position.lat);
    }
    // Line and polygon annotations ring several degrees around their center,
    // so pad the bounds to keep the whole shape in frame, not just its
    // center point.
    const ringPadding = 6.0;
    if (kind == _Kind.polyline || kind == _Kind.polygon) {
      west -= ringPadding;
      east += ringPadding;
      south -= ringPadding;
      north += ringPadding;
    }

    final camera = await map.cameraForCoordinateBounds(
      CoordinateBounds(
        southwest: Point(coordinates: Position(west, south)),
        northeast: Point(coordinates: Position(east, north)),
        infiniteBounds: false,
      ),
      MbxEdgeInsets(top: 40, left: 40, bottom: 40, right: 40),
      0,
      0,
      null,
      null,
    );
    await map.flyTo(camera, MapAnimationOptions(duration: 1000));
  }

  /// Creates one annotation of [kind] at [center], with the current option
  /// values (draggable, labels).
  Future<void> _createAnnotation(_Kind kind, Position center) async {
    switch (kind) {
      case _Kind.point:
        final image = _markerImage;
        if (image == null) return;
        await _points?.create(
          PointAnnotationOptions(
            geometry: Point(coordinates: center),
            image: image,
            iconSize: 1.2,
            isDraggable: _draggable,
            textField: _showLabels ? 'Marker' : null,
            textOffset: const [0, -2.4],
            textColor: Colors.white.toARGB32(),
            textHaloColor: Colors.black.toARGB32(),
            textHaloWidth: 1,
          ),
        );
      case _Kind.circle:
        await _circles?.create(
          CircleAnnotationOptions(
            geometry: Point(coordinates: center),
            circleRadius: 10,
            circleColor: _randomColor(),
            circleStrokeColor: Colors.white.toARGB32(),
            circleStrokeWidth: 2,
            isDraggable: _draggable,
          ),
        );
      case _Kind.polyline:
        await _polylines?.create(
          PolylineAnnotationOptions(
            geometry: LineString(coordinates: _ring(center, close: false)),
            lineColor: _randomColor(),
            lineWidth: 4,
            isDraggable: _draggable,
          ),
        );
      case _Kind.polygon:
        await _polygons?.create(
          PolygonAnnotationOptions(
            geometry: Polygon(coordinates: [_ring(center)]),
            fillColor: _randomColor(),
            fillOpacity: 0.6,
            fillOutlineColor: Colors.white.toARGB32(),
            isDraggable: _draggable,
          ),
        );
    }
  }

  Future<void> _addAnnotations({int count = 1}) async {
    if (kIsWeb) return;
    // A batch is clustered near one point, so multiple additions land near
    // each other instead of scattered worldwide like _randomPosition alone.
    final batch = count == 1 ? [_randomPosition()] : _randomCluster(count);
    for (final center in batch) {
      await _createAnnotation(_kind, center);
    }
    _lastPosition[_kind] = batch.last;
    setState(() => _created[_kind] = (_created[_kind] ?? 0) + count);
    if (batch.length == 1) {
      await _flyToPosition(batch.single);
    } else {
      await _flyToFitBatch(_kind, batch);
    }
  }

  Future<void> _deleteAll() async {
    if (kIsWeb) return;
    switch (_kind) {
      case _Kind.point:
        await _points?.deleteAll();
      case _Kind.circle:
        await _circles?.deleteAll();
      case _Kind.polyline:
        await _polylines?.deleteAll();
      case _Kind.polygon:
        await _polygons?.deleteAll();
    }
    _lastPosition[_kind] = _seedPositions[_kind]!;
    setState(() => _created[_kind] = 0);
  }

  Future<void> _selectKind(String id) async {
    final kind = _Kind.values.firstWhere((kind) => kind.name == id);
    setState(() => _kind = kind);
    final position = _lastPosition[kind] ?? _seedPositions[kind]!;
    await _flyToPosition(position);
  }

  @override
  Widget build(BuildContext context) {
    final count = _created[_kind] ?? 0;
    return SceneScaffold(
      scenes: _scenes,
      selectedSceneId: _kind.name,
      onSceneSelected: _selectKind,
      controlsTitle: 'Annotation options',
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: MapWidget(
        key: const ValueKey('mapWidget'),
        onMapCreated: _onMapCreated,
      ),
      controlsBuilder: () => [
        ControlSwitch(
          label: 'Draggable',
          icon: Icons.open_with,
          value: _draggable,
          onChanged: kIsWeb
              ? null
              : (value) => setState(() => _draggable = value),
        ),
        if (_kind == _Kind.point)
          ControlSwitch(
            label: 'Text labels',
            icon: Icons.title,
            value: _showLabels,
            onChanged: kIsWeb
                ? null
                : (value) => setState(() => _showLabels = value),
          ),
        const SizedBox(height: 10),
        ControlAction(
          label: 'Add one',
          icon: Icons.add,
          onPressed: _addAnnotations,
        ),
        ControlAction(
          label: 'Add 25',
          icon: Icons.library_add_outlined,
          onPressed: () => _addAnnotations(count: 25),
        ),
        ControlAction(
          label: count == 0 ? 'Nothing to remove' : 'Remove all',
          icon: Icons.delete_outline,
          onPressed: count == 0 ? null : _deleteAll,
        ),
        const SizedBox(height: 4),
        const Text(
          'New annotations pick up the options above. Tap or drag one on the '
          'map to see its events.',
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
