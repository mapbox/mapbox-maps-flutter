import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:turf/turf.dart' show Point, Position;
import 'patrol.dart';

import 'test_utils.dart';

final _viewport = CameraViewportState(
  center: Point(coordinates: Position(0, 0)),
  zoom: 3,
);

Future<MapboxMapPlatformInterface> _pumpMap(WidgetTester tester) => pumpMapTree(
  tester,
  (onCreated) => MaterialApp(
    home: Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MapWebWidget(
              styleUri: 'mapbox://styles/mapbox/streets-v12',
              viewport: _viewport,
              onMapCreated: onCreated,
            ),
          ),
        ],
      ),
    ),
  ),
);

PerformanceStatisticsOptions _everyFrame(
  List<PerformanceSamplerOptions> samplers,
) => PerformanceStatisticsOptions(
  samplerOptions: samplers,
  samplingDurationMillis: 0,
);

class _Listener implements PerformanceStatisticsListener {
  final snapshots = StreamController<PerformanceStatistics>.broadcast();

  @override
  void onPerformanceStatisticsCollected(PerformanceStatistics statistics) =>
      snapshots.add(statistics);
}

/// Repaints the map and waits for the next snapshot from [listener].
Future<PerformanceStatistics> _nextSnapshot(
  WidgetTester tester,
  _Listener listener,
) {
  final next = listener.snapshots.stream.first.timeout(
    const Duration(seconds: 10),
  );
  currentMap(tester)!.triggerRepaint();
  return next;
}

void main() {
  patrolTest('delivers render statistics for each rendered frame', ($) async {
    final map = await _pumpMap($.tester);
    final listener = _Listener();

    map.startPerformanceStatisticsCollection(_everyFrame([]), listener);
    final statistics = await _nextSnapshot($.tester, listener);
    map.stopPerformanceStatisticsCollection();

    expect(statistics.mapRenderDurationStatistics.maxMillis, greaterThan(0));
    expect(statistics.cumulativeStatistics, isNull);
    expect(statistics.perFrameStatistics, isNull);
  });

  patrolTest('delivers counters and layer timings for the samplers', ($) async {
    final map = await _pumpMap($.tester);
    final listener = _Listener();

    map.startPerformanceStatisticsCollection(
      _everyFrame([
        PerformanceSamplerOptions.CUMULATIVE,
        PerformanceSamplerOptions.PER_FRAME,
      ]),
      listener,
    );
    final statistics = await _nextSnapshot($.tester, listener);
    map.stopPerformanceStatisticsCollection();

    expect(statistics.cumulativeStatistics!.drawCalls, greaterThan(0));
    expect(statistics.cumulativeStatistics!.textureBytes, isNull);
    final layers = statistics.perFrameStatistics!.topRenderLayers;
    expect(layers, isNotEmpty);
    expect(layers.first.durationMillis, greaterThan(0));
  });

  patrolTest('a second start replaces the running collection', ($) async {
    final map = await _pumpMap($.tester);
    final first = _Listener();
    final second = _Listener();
    var firstCalls = 0;
    first.snapshots.stream.listen((_) => firstCalls++);

    map.startPerformanceStatisticsCollection(_everyFrame([]), first);
    map.startPerformanceStatisticsCollection(_everyFrame([]), second);
    await _nextSnapshot($.tester, second);
    map.stopPerformanceStatisticsCollection();

    expect(firstCalls, 0);
  });

  patrolTest('stop ends the snapshots', ($) async {
    final map = await _pumpMap($.tester);
    final listener = _Listener();
    var calls = 0;
    listener.snapshots.stream.listen((_) => calls++);

    map.startPerformanceStatisticsCollection(_everyFrame([]), listener);
    map.stopPerformanceStatisticsCollection();
    final jsMap = currentMap($.tester)!;
    jsMap.triggerRepaint();
    await jsMap.onceAsync('render').toDart;

    expect(calls, 0);
  });
}
