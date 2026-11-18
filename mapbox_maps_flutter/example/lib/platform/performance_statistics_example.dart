// ignore_for_file: experimental_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

enum _Tab { collect, snapshot }

const _durations = <int, String>{
  0: 'Every frame',
  250: '250 ms',
  1000: '1 s',
  5000: '5 s',
};

const _circlesSourceId = 'perf-stats-circles';
const _circlesLayerId = 'perf-stats-circles-layer';
const _terrainSourceId = 'perf-stats-terrain';

/// Camera stops for the tour. Mountains and dense cities, so terrain and 3D
/// buildings give the renderer real work.
final _tour = [
  (lng: -122.4194, lat: 37.7749, zoom: 15.5, pitch: 60.0),
  (lng: 7.6586, lat: 45.9763, zoom: 12.5, pitch: 70.0),
  (lng: 139.7671, lat: 35.6812, zoom: 15.5, pitch: 60.0),
  (lng: -73.9857, lat: 40.7484, zoom: 15.5, pitch: 65.0),
  (lng: 2.2945, lat: 48.8584, zoom: 15.5, pitch: 60.0),
];

class _Listener implements PerformanceStatisticsListener {
  _Listener(this.onCollected);

  final ValueChanged<PerformanceStatistics> onCollected;

  @override
  void onPerformanceStatisticsCollected(PerformanceStatistics statistics) =>
      onCollected(statistics);
}

/// Render performance statistics, collected live.
///
/// Pick the samplers and the sampling duration, add rendering load, and read
/// each snapshot field by field: render time, the slowest render groups and
/// layers, and GPU resource counters.
class PerformanceStatisticsExample extends StatefulWidget {
  const PerformanceStatisticsExample({super.key});

  @override
  State<PerformanceStatisticsExample> createState() =>
      _PerformanceStatisticsExampleState();
}

class _PerformanceStatisticsExampleState
    extends State<PerformanceStatisticsExample> {
  MapboxMap? _mapboxMap;
  var _tab = _Tab.collect;

  var _collecting = false;
  var _cumulative = true;
  var _perFrame = true;
  var _durationMs = 1000;

  PerformanceStatistics? _latest;
  var _snapshotCount = 0;

  var _terrain = false;
  var _circles = false;
  var _tourRunning = false;
  var _tourStop = 0;
  var _show3dObjects = true;
  Timer? _tourTimer;

  static const _maxLogEntries = 200;
  final List<String> _log = [];

  @override
  void dispose() {
    _tourTimer?.cancel();
    if (_collecting) _mapboxMap?.stopPerformanceStatisticsCollection();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    setState(() => _mapboxMap = mapboxMap);
  }

  // ===== Collection =====

  /// Starts collection with the current options. A start while collection
  /// runs replaces it, so this also applies changed options.
  void _start() {
    _mapboxMap?.startPerformanceStatisticsCollection(
      PerformanceStatisticsOptions(
        samplerOptions: [
          if (_cumulative) PerformanceSamplerOptions.CUMULATIVE,
          if (_perFrame) PerformanceSamplerOptions.PER_FRAME,
        ],
        samplingDurationMillis: _durationMs.toDouble(),
      ),
      _Listener(_onCollected),
    );
  }

  void _setCollecting(bool enabled) {
    setState(() => _collecting = enabled);
    if (enabled) {
      _start();
    } else {
      _mapboxMap?.stopPerformanceStatisticsCollection();
    }
  }

  void _updateOptions(VoidCallback change) {
    setState(change);
    if (_collecting) _start();
  }

  void _onCollected(PerformanceStatistics statistics) {
    if (!mounted) return;
    final render = statistics.mapRenderDurationStatistics;
    final time = DateTime.now().toIso8601String().substring(11, 19);
    setState(() {
      _latest = statistics;
      _snapshotCount++;
      _log.add(
        '$time  render ${_ms(render.medianMillis)} median, '
        '${_ms(render.maxMillis)} max',
      );
      if (_log.length > _maxLogEntries) {
        _log.removeRange(0, _log.length - _maxLogEntries);
      }
    });
  }

  // ===== Rendering load =====

  Future<void> _setTerrain(bool enabled) async {
    final map = _mapboxMap;
    if (map == null) return;
    setState(() => _terrain = enabled);
    if (enabled) {
      if (!await map.styleSourceExists(_terrainSourceId)) {
        await map.addStyleSource(
          _terrainSourceId,
          jsonEncode({
            'type': 'raster-dem',
            'url': 'mapbox://mapbox.mapbox-terrain-dem-v1',
            'tileSize': 514,
          }),
        );
      }
      await map.setStyleTerrain(
        jsonEncode({'source': _terrainSourceId, 'exaggeration': 2}),
      );
    } else if (await map.styleSourceExists(_terrainSourceId)) {
      await map.removeStyleTerrain();
      await map.removeStyleSource(_terrainSourceId);
    }
  }

  /// Adds 20 000 random circles around the camera. The layer shows up in
  /// the per-layer timings under its id.
  Future<void> _setCircles(bool enabled) async {
    final map = _mapboxMap;
    if (map == null) return;
    setState(() => _circles = enabled);
    if (enabled) {
      final center = (await map.getCameraState()).center.coordinates;
      final random = math.Random(42);
      final features = [
        for (var i = 0; i < 20000; i++)
          {
            'type': 'Feature',
            'properties': {},
            'geometry': {
              'type': 'Point',
              'coordinates': [
                center.lng + (random.nextDouble() - 0.5) * 0.2,
                center.lat + (random.nextDouble() - 0.5) * 0.2,
              ],
            },
          },
      ];
      await map.addStyleSource(
        _circlesSourceId,
        jsonEncode({
          'type': 'geojson',
          'data': {'type': 'FeatureCollection', 'features': features},
        }),
      );
      await map.addLayer(
        CircleLayer(
          id: _circlesLayerId,
          sourceId: _circlesSourceId,
          slot: 'top',
          circleRadius: 4,
          circleColor: MapboxColors.orange50.toARGB32(),
          circleStrokeColor: Colors.white.toARGB32(),
          circleStrokeWidth: 1,
        ),
      );
    } else {
      if (await map.styleLayerExists(_circlesLayerId)) {
        await map.removeStyleLayer(_circlesLayerId);
      }
      if (await map.styleSourceExists(_circlesSourceId)) {
        await map.removeStyleSource(_circlesSourceId);
      }
    }
  }

  void _setTour(bool enabled) {
    setState(() => _tourRunning = enabled);
    _tourTimer?.cancel();
    if (!enabled) return;
    _flyToNextStop();
    _tourTimer = Timer.periodic(
      const Duration(seconds: 7),
      (_) => _flyToNextStop(),
    );
  }

  void _flyToNextStop() {
    final stop = _tour[_tourStop++ % _tour.length];
    _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(stop.lng, stop.lat)),
        zoom: stop.zoom,
        pitch: stop.pitch,
        bearing: math.Random().nextDouble() * 360,
      ),
      MapAnimationOptions(duration: 6000),
    );
  }

  void _set3dObjects(bool enabled) {
    setState(() => _show3dObjects = enabled);
    _mapboxMap?.setStyleImportConfigProperty(
      'basemap',
      'show3dObjects',
      enabled,
    );
  }

  // ===== Formatting =====

  static String _ms(double value) => '${value.toStringAsFixed(2)} ms';

  static String _bytes(int? value) {
    if (value == null) return '—';
    if (value < 1024 * 1024) return '${(value / 1024).toStringAsFixed(1)} KiB';
    return '${(value / (1024 * 1024)).toStringAsFixed(1)} MiB';
  }

  // ===== Panels =====

  List<Widget> _collectPanel() {
    final ready = _mapboxMap != null;
    return [
      ControlSwitch(
        label: 'Collect statistics',
        icon: Icons.speed,
        value: _collecting,
        onChanged: ready ? _setCollecting : null,
      ),
      const GlassSectionLabel('Samplers'),
      ControlSwitch(
        label: 'Cumulative: GPU counters',
        icon: Icons.memory,
        value: _cumulative,
        onChanged: (value) => _updateOptions(() => _cumulative = value),
      ),
      ControlSwitch(
        label: 'Per-frame: CPU timings',
        icon: Icons.timer_outlined,
        value: _perFrame,
        onChanged: (value) => _updateOptions(() => _perFrame = value),
      ),
      const GlassSectionLabel('Sampling duration'),
      ControlChoices<int>(
        options: _durations,
        value: _durationMs,
        onChanged: (value) => _updateOptions(() => _durationMs = value),
      ),
      const GlassSectionLabel('Rendering load'),
      ControlSwitch(
        label: 'Camera tour',
        icon: Icons.flight_takeoff,
        value: _tourRunning,
        onChanged: ready ? _setTour : null,
      ),
      ControlSwitch(
        label: 'Terrain',
        icon: Icons.terrain_outlined,
        value: _terrain,
        onChanged: ready ? _setTerrain : null,
      ),
      ControlSwitch(
        label: '20 000 circles',
        icon: Icons.bubble_chart_outlined,
        value: _circles,
        onChanged: ready ? _setCircles : null,
      ),
      ControlSwitch(
        label: '3D objects',
        icon: Icons.apartment,
        value: _show3dObjects,
        onChanged: ready ? _set3dObjects : null,
      ),
    ];
  }

  List<Widget> _snapshotPanel({required bool includeLog}) {
    final latest = _latest;
    if (latest == null) {
      return const [
        _Note('No snapshot yet. Start collection and move the map.'),
      ];
    }
    final render = latest.mapRenderDurationStatistics;
    final cumulative = latest.cumulativeStatistics;
    final perFrame = latest.perFrameStatistics;

    return [
      const GlassSectionLabel('Render time'),
      _Field('Window', _ms(latest.collectionDurationMillis)),
      _Field('Median', _ms(render.medianMillis)),
      _Field('Max', _ms(render.maxMillis)),
      if (cumulative != null) ...[
        const GlassSectionLabel('Cumulative statistics'),
        _Field('Draw calls (last frame)', '${cumulative.drawCalls ?? '—'}'),
        _Field('Texture memory', _bytes(cumulative.textureBytes)),
        _Field('Vertex memory', _bytes(cumulative.vertexBytes)),
        _Field('Programs', '${cumulative.graphicsPrograms ?? '—'}'),
        _Field(
          'Program creation',
          cumulative.graphicsProgramsCreationTimeMillis == null
              ? '—'
              : _ms(cumulative.graphicsProgramsCreationTimeMillis!),
        ),
        _Field('FBO switches', '${cumulative.fboSwitchCount ?? '—'}'),
      ],
      if (perFrame != null) ...[
        const GlassSectionLabel('Passes'),
        _Field(
          'Upload median / max',
          '${_ms(perFrame.uploadDurationStatistics.medianMillis)} / '
              '${_ms(perFrame.uploadDurationStatistics.maxMillis)}',
        ),
        const GlassSectionLabel('Slowest render groups'),
        _GroupBars(perFrame.topRenderGroups),
        const GlassSectionLabel('Slowest layers'),
        _GroupBars(perFrame.topRenderLayers),
      ],
      if (includeLog) ...[
        const GlassSectionLabel('Snapshots'),
        for (final entry in _log.reversed.take(20))
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              entry,
              style: const TextStyle(
                fontSize: 11,
                color: MapboxGlass.labelMuted,
              ),
            ),
          ),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    // On a narrow viewport the log gets the pinned strip, so the controls
    // sheet does not hide the map the snapshots come from.
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final showsLogStrip = _tab == _Tab.snapshot && !isWide;
    final render = _latest?.mapRenderDurationStatistics;
    final topLayer = _latest?.perFrameStatistics?.topRenderLayers.firstOrNull;

    return SceneScaffold(
      log: showsLogStrip ? _log : null,
      logTitle: 'Snapshots',
      scenes: const [
        Scene(
          id: 'collect',
          title: 'Collect',
          subtitle: 'Samplers, sampling duration and rendering load',
          icon: Icons.tune,
        ),
        Scene(
          id: 'snapshot',
          title: 'Snapshot',
          subtitle: 'Every field of the latest snapshot',
          icon: Icons.analytics_outlined,
        ),
      ],
      selectedSceneId: _tab.name,
      onSceneSelected: (id) => setState(
        () => _tab = _Tab.values.firstWhere((tab) => tab.name == id),
      ),
      controlsTitle: _tab == _Tab.collect ? 'Collection' : 'Latest snapshot',
      controlsSheetSize: ControlsSheetSize.large,
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('mapWidget'),
            viewport: CameraViewportState(
              center: Point(coordinates: Position(_tour[0].lng, _tour[0].lat)),
              zoom: _tour[0].zoom,
              pitch: _tour[0].pitch,
            ),
            onMapCreated: _onMapCreated,
          ),
          MapHud(
            title: _collecting ? 'Collecting' : 'Not collecting',
            rows: [
              MapHudRow(
                'render median',
                render == null ? '—' : _ms(render.medianMillis),
                emphasized: true,
              ),
              MapHudRow(
                'render max',
                render == null ? '—' : _ms(render.maxMillis),
              ),
              MapHudRow(
                'slowest layer',
                topLayer == null ? '—' : topLayer.name,
              ),
              MapHudRow('snapshots', '$_snapshotCount'),
            ],
          ),
        ],
      ),
      controlsBuilder: () => switch (_tab) {
        _Tab.collect => _collectPanel(),
        _Tab.snapshot => _snapshotPanel(includeLog: !showsLogStrip),
      },
    );
  }
}

/// Horizontal bars for a list of group or layer timings, scaled to the
/// slowest entry.
class _GroupBars extends StatelessWidget {
  const _GroupBars(this.groups);

  final List<GroupPerformanceStatistics> groups;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) return const _Note('None in this window.');
    final slowest = groups
        .map((group) => group.durationMillis)
        .reduce(math.max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final group in groups)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Field(
                  group.name,
                  '${group.durationMillis.toStringAsFixed(2)} ms',
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: slowest == 0 ? 0 : group.durationMillis / slowest,
                    minHeight: 3,
                    backgroundColor: MapboxGlass.fillRaised,
                    color: MapboxColors.blue40,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// One labelled value of the snapshot.
class _Field extends StatelessWidget {
  const _Field(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: MapboxGlass.labelMuted,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              color: MapboxGlass.label,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          height: 1.4,
          color: MapboxGlass.labelFaint,
        ),
      ),
    );
  }
}
