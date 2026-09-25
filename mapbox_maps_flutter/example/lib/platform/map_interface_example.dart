import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// Two scenes that query the map's rendered and source content, then feed the
/// result back as feature state.
///
///  * **Tap to flip** — a tap flips the feature's `selected` state, and the
///    layer paints from that state.
///  * **Query box** — a drag defines a box, and `queryRenderedFeatures`
///    counts the circles drawn inside it.
class MapInterfaceExample extends StatefulWidget {
  const MapInterfaceExample({super.key});

  @override
  State<MapInterfaceExample> createState() => _MapInterfaceExampleState();
}

/// Landmarks shared by both scenes.
///
/// The ids are numeric, because GL JS keeps only numeric feature ids.
const _places = [
  (1, 'Ferry Building', -122.3933, 37.7955),
  (2, 'Coit Tower', -122.4058, 37.8024),
  (3, 'Palace of Fine Arts', -122.4485, 37.8029),
  (4, 'Alamo Square', -122.4348, 37.7763),
  (5, 'Oracle Park', -122.3892, 37.7786),
];

const _scenes = [
  Scene(
    id: 'flip',
    title: 'Tap to flip',
    subtitle: 'Query the tap, then toggle feature state',
    icon: Icons.touch_app_outlined,
  ),
  Scene(
    id: 'box',
    title: 'Query box',
    subtitle: 'Draw a box, count what\'s rendered inside it',
    icon: Icons.crop_free,
  ),
];

class _MapInterfaceExampleState extends State<MapInterfaceExample> {
  static const _sourceId = 'places';
  static const _layerId = 'places-layer';

  MapboxMap? _mapboxMap;
  var _sceneId = 'flip';
  var _styleReady = false;

  String? _tappedName;
  String? _featureState;
  int _renderedCount = 0;
  int _sourceCount = 0;
  Size? _size;
  MapOptions? _mapOptions;

  // Query-box state.
  bool _boxToolActive = false;
  Rect? _box;
  Offset? _dragStart;
  Offset? _dragCurrent;
  int? _boxRenderedCount;

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
    // Targets the layer's own featureset, because a map-level tap can be
    // claimed by a basemap POI at the same pixel.
    mapboxMap.addInteraction(
      TapInteraction(FeaturesetDescriptor(layerId: _layerId), _onTap),
      interactionID: 'tap_places',
    );
    mapboxMap.addInteraction(
      TapInteraction.onMap(_onMapTap),
      interactionID: 'tap_map',
    );
  }

  /// Adds the source and layer on every style load.
  ///
  /// A style load clears every source and layer that the style JSON does not
  /// contain, so these must be added here and not in [_onMapCreated].
  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
    final map = _mapboxMap;
    if (map == null) return;

    _styleReady = false;
    await map.addSource(GeoJsonSource(id: _sourceId, data: _placesGeoJson()));
    // Radius and color read from feature state, so setFeatureState alone
    // repaints the circle — no source update needed.
    await map.addLayer(
      CircleLayer(
        id: _layerId,
        sourceId: _sourceId,
        slot: 'top',
        circleRadiusExpression: [
          'case',
          [
            'boolean',
            ['feature-state', 'selected'],
            false,
          ],
          16.0,
          9.0,
        ],
        circleColorExpression: [
          'case',
          [
            'boolean',
            ['feature-state', 'selected'],
            false,
          ],
          '#fed622',
          '#007afc',
        ],
        circleStrokeWidth: 2,
        circleStrokeColor: Colors.white.toARGB32(),
      ),
    );
    _styleReady = true;
    final options = await map.getMapOptions();
    if (mounted) setState(() => _mapOptions = options);
    await _refreshCounts();
  }

  void _selectScene(String id) {
    if (id == _sceneId) return;
    if (_boxToolActive) unawaited(_setBoxToolActive(false));
    setState(() => _sceneId = id);
  }

  // --- Scene 1: tap to flip -------------------------------------------------

  /// Fires only for taps on this example's circles, through a layer-targeted
  /// interaction.
  Future<void> _onTap(
    TypedFeaturesetFeature<FeaturesetDescriptor> feature,
    MapContentGestureContext context,
  ) async {
    final map = _mapboxMap;
    if (map == null || !_styleReady) return;

    final id = feature.id?.id;
    if (id == null) return;
    final name = feature.properties['name'] as String? ?? id;

    // Read the current state to decide the next one, so a second tap clears it.
    final raw = await map.getFeatureState(_sourceId, null, id);
    final wasSelected =
        (jsonDecode(raw) as Map<String, Object?>)['selected'] == true;

    await map.setFeatureState(
      _sourceId,
      null,
      id,
      json.encode({'selected': !wasSelected}),
    );
    final updated = await map.getFeatureState(_sourceId, null, id);

    if (!mounted) return;
    setState(() {
      _tappedName = name;
      _featureState = updated;
    });
    await _refreshCounts();
  }

  Future<void> _onMapTap(MapContentGestureContext context) async {
    _clearHud();
    await _refreshCounts();
  }

  void _clearHud() {
    if (!mounted) return;
    setState(() {
      _tappedName = null;
      _featureState = null;
    });
  }

  /// `queryRenderedFeatures` sees only what is drawn, and
  /// `querySourceFeatures` sees the whole source.
  Future<void> _refreshCounts() async {
    final map = _mapboxMap;
    if (map == null || !_styleReady) return;

    // Not implemented on iOS. The HUD shows '—' for the size and the
    // rendered count when it is unavailable, rather than crashing the
    // example over one platform gap.
    Size? size;
    try {
      size = await map.getSize();
    } on PlatformException {
      size = null;
    }

    final rendered = size == null
        ? null
        : await _queryRenderedIn(
            map,
            Rect.fromLTWH(0, 0, size.width, size.height),
          );
    final source = await map.querySourceFeatures(
      _sourceId,
      SourceQueryOptions(filter: ''),
    );
    if (!mounted) return;
    setState(() {
      _size = size;
      _renderedCount = rendered ?? 0;
      _sourceCount = source.length;
    });
  }

  /// Clears every feature's state, so all circles return to the base style.
  Future<void> _clearStates() async {
    final map = _mapboxMap;
    if (map == null || !_styleReady) return;
    for (final place in _places) {
      await map.setFeatureState(
        _sourceId,
        null,
        place.$1.toString(),
        json.encode({'selected': false}),
      );
    }
    _clearHud();
  }

  // --- Scene 2: query box ----------------------------------------------------

  /// Drops the drawn box when the camera moves.
  ///
  /// The box is an overlay in screen space and does not track the map, so it
  /// would misreport what it queried after a camera move.
  void _clearBoxOnCameraMove() {
    if (_boxToolActive || _box == null) return;
    setState(() {
      _box = null;
      _boxRenderedCount = null;
    });
  }

  /// Toggles the selector tool. While active, the map gestures are disabled,
  /// so a drag draws a box.
  Future<void> _setBoxToolActive(bool active) async {
    final map = _mapboxMap;
    setState(() {
      _boxToolActive = active;
      if (active) {
        _box = null;
        _boxRenderedCount = null;
      }
      _dragStart = null;
      _dragCurrent = null;
    });
    if (map == null) return;
    await map.gestures.updateSettings(
      GesturesSettings(
        scrollEnabled: !active,
        pinchToZoomEnabled: !active,
        rotateEnabled: !active,
        pitchEnabled: !active,
        doubleTapToZoomInEnabled: !active,
      ),
    );
  }

  void _onDragStart(Offset position) {
    if (!_boxToolActive) return;
    setState(() {
      _dragStart = position;
      _dragCurrent = position;
    });
  }

  void _onDragUpdate(Offset position) {
    if (!_boxToolActive || _dragStart == null) return;
    setState(() => _dragCurrent = position);
  }

  Future<void> _onDragEnd() async {
    final start = _dragStart;
    final current = _dragCurrent;
    if (!_boxToolActive || start == null || current == null) return;

    final box = Rect.fromPoints(start, current);
    // A box under a few pixels is a stray tap, not a deliberate drag.
    final tooSmall = box.width < 4 || box.height < 4;
    setState(() {
      _box = tooSmall ? null : box;
      _dragStart = null;
      _dragCurrent = null;
    });

    if (!tooSmall) await _refreshBoxCounts();
    await _setBoxToolActive(false);
  }

  Future<void> _refreshBoxCounts() async {
    final map = _mapboxMap;
    final box = _box;
    if (map == null || !_styleReady || box == null) return;
    final rendered = await _queryRenderedIn(map, box);

    if (!mounted) return;
    setState(() => _boxRenderedCount = rendered);
  }

  /// Counts this example's rendered circles inside [rect], in screen pixels.
  Future<int> _queryRenderedIn(MapboxMap map, Rect rect) async {
    final features = await map.queryRenderedFeatures(
      RenderedQueryGeometry.fromScreenBox(
        ScreenBox(
          min: ScreenCoordinate(x: rect.left, y: rect.top),
          max: ScreenCoordinate(x: rect.right, y: rect.bottom),
        ),
      ),
      RenderedQueryOptions(layerIds: [_layerId], filter: null),
    );
    return features.length;
  }

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      scenes: _scenes,
      selectedSceneId: _sceneId,
      onSceneSelected: _selectScene,
      controlsTitle: _scenes.firstWhere((s) => s.id == _sceneId).title,
      controlsSheetSize: ControlsSheetSize.small,
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('mapWidget'),
            styleUri: MapboxStyles.STANDARD,
            viewport: CameraViewportState(
              center: Point(coordinates: Position(-122.4194, 37.7899)),
              zoom: 12,
            ),
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
            onCameraChangeListener: (_) {
              _refreshCounts();
              _clearBoxOnCameraMove();
            },
          ),
          if (_sceneId == 'box')
            _BoxSelector(
              active: _boxToolActive,
              box: _box,
              dragStart: _dragStart,
              dragCurrent: _dragCurrent,
              onDragStart: _onDragStart,
              onDragUpdate: _onDragUpdate,
              onDragEnd: _onDragEnd,
            ),
          if (_sceneId == 'flip') _buildHud(),
        ],
      ),
      controlsBuilder: () => switch (_sceneId) {
        'box' => _boxControls(),
        _ => _flipControls(),
      },
    );
  }

  Widget _buildHud() {
    final size = _size;
    return MapHud(
      title: _tappedName == null ? 'Tap a circle' : 'Tapped feature',
      rows: [
        MapHudRow('feature', _tappedName ?? '—', emphasized: true),
        MapHudRow('featureState', _featureState ?? '—'),
        MapHudRow('rendered in view', '$_renderedCount'),
        MapHudRow('in source', '$_sourceCount'),
        MapHudRow(
          'map size',
          size == null
              ? '—'
              : '${size.width.toStringAsFixed(0)}×'
                    '${size.height.toStringAsFixed(0)}',
        ),
        MapHudRow(
          'pixel ratio',
          _mapOptions?.pixelRatio.toStringAsFixed(2) ?? '—',
        ),
        MapHudRow('constrain mode', _mapOptions?.constrainMode?.name ?? '—'),
      ],
    );
  }

  List<Widget> _flipControls() => [
    ControlAction(
      label: 'Clear feature states',
      icon: Icons.layers_clear_outlined,
      onPressed: _clearStates,
    ),
    const SizedBox(height: 4),
    const Text(
      'Tapping runs queryRenderedFeatures at the touch point, then '
      'toggles that feature\'s state. The layer paints from the state, so '
      'the circle reacts. Zoom out past a marker and the rendered count '
      'drops while the source count stays the same.',
      style: TextStyle(
        fontSize: 11,
        height: 1.35,
        color: MapboxGlass.labelFaint,
      ),
    ),
  ];

  List<Widget> _boxControls() => [
    ControlAction(
      label: _boxToolActive ? 'Cancel' : 'Draw a box',
      icon: _boxToolActive ? Icons.close : Icons.crop_free,
      onPressed: () => _setBoxToolActive(!_boxToolActive),
    ),
    const SizedBox(height: 4),
    Text(
      _boxToolActive
          ? 'Map panning is off. Drag anywhere on the map to draw the box; '
                'release to run the query and get the map back.'
          : 'Activate the tool, then drag out a box. The count comes from '
                'queryRenderedFeatures over the box in screen space — only '
                'circles currently drawn on screen inside it are counted.',
      style: const TextStyle(
        fontSize: 11,
        height: 1.35,
        color: MapboxGlass.labelFaint,
      ),
    ),
    if (_box != null) ...[
      const SizedBox(height: 10),
      _CountRow(label: 'rendered in box', value: _boxRenderedCount ?? 0),
    ],
  ];
}

class _CountRow extends StatelessWidget {
  const _CountRow({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: MapboxGlass.labelFaint,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
              color: MapboxGlass.label,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Selector tool for the query-box scene.
///
/// While [active], a drag surface over the map captures the drag and draws the
/// rectangle. The last completed [box] stays drawn, so the result stays
/// visible.
class _BoxSelector extends StatelessWidget {
  const _BoxSelector({
    required this.active,
    required this.box,
    required this.dragStart,
    required this.dragCurrent,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final bool active;
  final Rect? box;
  final Offset? dragStart;
  final Offset? dragCurrent;
  final ValueChanged<Offset> onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final start = dragStart;
    final current = dragCurrent;
    final shown = start != null && current != null
        ? Rect.fromPoints(start, current)
        : box;

    return Stack(
      children: [
        if (active)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (details) => onDragStart(details.localPosition),
              onPanUpdate: (details) => onDragUpdate(details.localPosition),
              onPanEnd: (_) => onDragEnd(),
              child: MouseRegion(cursor: SystemMouseCursors.precise),
            ),
          ),
        if (shown != null)
          Positioned(
            left: shown.left,
            top: shown.top,
            width: shown.width,
            height: shown.height,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: MapboxColors.blue40, width: 2),
                  color: MapboxColors.blue40.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

String _placesGeoJson() => json.encode({
  'type': 'FeatureCollection',
  'features': [
    for (final (id, name, lng, lat) in _places)
      {
        'type': 'Feature',
        'id': id,
        'geometry': {
          'type': 'Point',
          'coordinates': [lng, lat],
        },
        'properties': {'name': name},
      },
  ],
});
