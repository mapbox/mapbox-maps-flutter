import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

/// Runs the same camera movement against a [MapWidget] and a [MapTexture] and
/// reports what flutter's own instrumentation saw, so the cost of the texture
/// path can be compared rather than argued about.
///
/// Frame times come from `SchedulerBinding.addTimingsCallback`, which is the
/// engine's own measurement, not a stopwatch around the call.
class MapTexturePerfExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.speed);
  @override
  final String title = 'Map texture vs platform view (perf)';
  @override
  final String? subtitle = 'Same camera path, frame times from the engine';

  @override
  State<StatefulWidget> createState() => MapTexturePerfExampleState();
}

class MapTexturePerfExampleState extends State<MapTexturePerfExample> {
  bool _useTexture = false;
  bool _running = false;
  MapboxMap? _map;

  final List<int> _buildMicros = <int>[];
  final List<int> _rasterMicros = <int>[];
  String _result = '';

  void _onTimings(List<FrameTiming> timings) {
    if (!_running) return;
    for (final timing in timings) {
      _buildMicros.add(timing.buildDuration.inMicroseconds);
      _rasterMicros.add(timing.rasterDuration.inMicroseconds);
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
  }

  @override
  void dispose() {
    SchedulerBinding.instance.removeTimingsCallback(_onTimings);
    super.dispose();
  }

  Future<void> _run() async {
    final map = _map;
    if (map == null || _running) return;
    _buildMicros.clear();
    _rasterMicros.clear();
    setState(() {
      _running = true;
      _result = 'running';
    });

    // a fixed path, so both modes do identical work
    for (var i = 0; i < 40; i++) {
      await map.setCamera(CameraOptions(
        center: Point(
          coordinates: Position(-0.0880 + i * 0.0015, 51.5140 + i * 0.0008),
        ),
        zoom: 12.5 + (i % 10) * 0.05,
        bearing: i * 3.0,
      ));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }

    _running = false;
    setState(() => _result = _summary());
  }

  String _summary() {
    if (_buildMicros.isEmpty) return 'no frames';
    List<int> sorted(List<int> v) => List<int>.from(v)..sort();
    int percentile(List<int> v, double p) =>
        sorted(v)[((v.length - 1) * p).round()];
    String ms(int micros) => (micros / 1000).toStringAsFixed(2);

    final mode = _useTexture ? 'MapTexture' : 'MapWidget';
    return '$mode over ${_buildMicros.length} frames\n'
        'build  p50 ${ms(percentile(_buildMicros, 0.5))} ms   '
        'p90 ${ms(percentile(_buildMicros, 0.9))} ms\n'
        'raster p50 ${ms(percentile(_rasterMicros, 0.5))} ms   '
        'p90 ${ms(percentile(_rasterMicros, 0.9))} ms';
  }

  Future<void> _onMapCreated(MapboxMap map) async {
    _map = map;
    await map.setCamera(
      CameraOptions(
        center: Point(coordinates: Position(-0.0880, 51.5140)),
        zoom: 12.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _useTexture
                ? MapTexture(
                    key: const ValueKey('texture'),
                    styleUri: MapboxStyles.MAPBOX_STREETS,
                    onMapCreated: _onMapCreated,
                  )
                : MapWidget(
                    key: const ValueKey('platform'),
                    styleUri: MapboxStyles.MAPBOX_STREETS,
                    onMapCreated: _onMapCreated,
                  ),
          ),
          Positioned(
            left: 12,
            right: 12,
            top: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _result.isEmpty ? 'pick a mode, then run' : _result,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'monospace'),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: _running
                          ? null
                          : () {
                              _map = null;
                              setState(() {
                                _useTexture = false;
                                _result = '';
                              });
                            },
                      child: const Text('MapWidget'),
                    ),
                    ElevatedButton(
                      onPressed: _running
                          ? null
                          : () {
                              _map = null;
                              setState(() {
                                _useTexture = true;
                                _result = '';
                              });
                            },
                      child: const Text('MapTexture'),
                    ),
                    ElevatedButton(
                      onPressed: _running ? null : _run,
                      child: const Text('run'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
