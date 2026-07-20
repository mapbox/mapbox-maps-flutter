// Manual, on-demand performance diagnostic for HitTestGuard's mousemove and
// wheel handling. Deliberately excluded from the CI target list (see
// maps-flutter-ci.yml) and asserts no pass/fail budget — it reports numbers
// for a human to read; headless-Chrome timing has enough run-to-run variance
// to make a hard threshold more flaky than useful.
//
// Why these two event types: `_CursorMirror` (mousemove) and `_ScrollGuard`
// (wheel) are the only guards in hit_test_guard.dart that hit-test Flutter's
// render tree on every DOM event, unconditionally — before the map-covered
// check, not after. `_EventGuard` deliberately skips mousemove/touchmove for
// the same reason (see its doc comment). So the cost measured here is paid
// on every mousemove/wheel event any time a MapWebWidget exists, not only
// when something actually covers the map.
//
// Reading the numbers: each scenario reports min/median/max microseconds per
// dispatched event across 5 timed bursts (after a discarded warm-up burst).
// Trust the median; min/max just bound the noise. The "measurement noise
// floor" group dispatches an event type none of the three guards listen for,
// on the same DOM node — a flat number there is what makes a run trustworthy
// to compare against another one. The one exception is the frame-timing
// scenario below, which reports Stopwatch-measured wall-clock time per paced
// frame rather than a dispatched-event burst (see its own comment).
//
// Running:
//   patrol test --target patrol_test/benchmark/hit_test_guard_benchmark_test.dart \
//     -d chrome \
//     --dart-define=ACCESS_TOKEN=$MAPBOX_ACCESS_TOKEN
//
// Results print via debugPrint only — there is no test_driver/ harness left
// to collect a `reportData` JSON dump into (Patrol replaced flutter_driver
// entirely), so read them from the `patrol test` output.
//
// Comparing against a prior revision: there's no fixed "before" baseline
// checked in, so bring your own —
//   1. git worktree add <path> <ref>
//   2. Copy this file into the worktree's example/patrol_test/benchmark/,
//      and test_utils.dart + patrol.dart into example/patrol_test/
//      (nothing else needs to change, unless MapWebWidget's public API
//      differs between <ref> and HEAD).
//   3. flutter pub get in both mapbox_maps_flutter_web and its example/.
//   4. Run the command above from both checkouts' example/ directories,
//      back to back on the same machine — absolute timings aren't portable
//      across machines or sessions.
//   5. Compare median µs/event per scenario, trusting a delta only if the
//      noise-floor scenario stayed flat between the two runs.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:turf/turf.dart' show Point, Position;
import 'package:web/web.dart' as web;
import '../patrol.dart';

import '../test_utils.dart';

final _viewport = CameraViewportState(
  center: Point(coordinates: Position(0, 0)),
  zoom: 5,
);

const _warmupEvents = 100;
const _timedRuns = 5;

/// Boots the standard harness with [overlay] over the map, mirroring
/// hit_test_guard_test.dart's `_pump` (file-private there, so redefined here
/// rather than shared — keeps the correctness suite untouched).
Future<MapboxMapPlatformInterface> _pump(
  WidgetTester tester, {
  Widget? overlay,
}) => pumpMapTree(
  tester,
  (onCreated) => MaterialApp(
    home: Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MapWebWidget(viewport: _viewport, onMapCreated: onCreated),
          ),
          if (overlay != null) overlay,
        ],
      ),
    ),
  ),
);

/// An overlay covering the left half of the map, hosting [child].
Widget _leftHalf(Widget child) => Align(
  alignment: Alignment.centerLeft,
  child: FractionallySizedBox(widthFactor: 0.5, heightFactor: 1, child: child),
);

({double x, double y}) _leftPoint(web.DOMRect rect) =>
    (x: rect.left + rect.width * 0.25, y: rect.top + rect.height / 2);

/// A ListView.builder of [itemCount] moderately complex rows, covering the
/// left half of the map — the shape of overlay the user actually worries
/// about scrolling on top of the map.
Widget _listOverlay(int itemCount) => _leftHalf(
  ListView.builder(
    itemCount: itemCount,
    itemBuilder: (context, index) => ListTile(
      leading: CircleAvatar(child: Text('$index')),
      title: Text('Item $index'),
      subtitle: const Text('Overlay row for scroll-perf stress'),
    ),
  ),
);

/// A chain of [depth] nested hit-testable boxes over the left half of the
/// map, to see whether hit-test cost scales with path length rather than
/// staying constant.
Widget _deepChain(int depth) {
  Widget child = const ColoredBox(
    color: Colors.transparent,
    child: SizedBox.expand(),
  );
  for (var i = 0; i < depth; i++) {
    child = Padding(padding: EdgeInsets.zero, child: child);
  }
  return _leftHalf(child);
}

/// A sweep of [count] synthetic `mousemove` events across [rect]'s width,
/// alternating two y-offsets so the path isn't a single straight line.
List<web.Event> _mousemoveSweep(web.DOMRect rect, int count) =>
    List.generate(count, (i) {
      final t = count <= 1 ? 0.0 : i / (count - 1);
      final x = rect.left + rect.width * t;
      final y = rect.top + rect.height * (i.isEven ? 0.35 : 0.65);
      return mouseEvent('mousemove', x, y);
    });

/// A burst of [count] `wheel` events at a fixed point.
List<web.Event> _wheelBurst(({double x, double y}) point, int count) =>
    List.generate(count, (_) => wheelEvent(point.x, point.y));

/// A burst of [count] events of a type none of HitTestGuard's three guards
/// listen for, at a fixed point on the same DOM node the guarded scenarios
/// use — isolates dispatch/JS-interop overhead from hit-test cost.
List<web.Event> _controlBurst(({double x, double y}) point, int count) =>
    List.generate(count, (_) => mouseEvent('pointerover', point.x, point.y));

class _BurstStats {
  const _BurstStats({
    required this.n,
    required this.minMicrosPerEvent,
    required this.medianMicrosPerEvent,
    required this.maxMicrosPerEvent,
  });

  final int n;
  final double minMicrosPerEvent;
  final double medianMicrosPerEvent;
  final double maxMicrosPerEvent;

  @override
  String toString() =>
      'n=$n  min=${minMicrosPerEvent.toStringAsFixed(1)}µs  '
      'median=${medianMicrosPerEvent.toStringAsFixed(1)}µs  '
      'max=${maxMicrosPerEvent.toStringAsFixed(1)}µs (per event)';
}

/// Times [buildEvents] bursts of [eventsPerRun] dispatched on [target]: one
/// discarded warm-up burst, then [_timedRuns] timed bursts, reporting
/// min/median/max microseconds per event across those timed runs.
_BurstStats _measureBurst(
  web.HTMLElement target,
  List<web.Event> Function(int count) buildEvents,
  int eventsPerRun,
) {
  for (final event in buildEvents(math.min(_warmupEvents, eventsPerRun))) {
    target.dispatchEvent(event);
  }

  final microsPerEventByRun = List.generate(_timedRuns, (_) {
    final events = buildEvents(eventsPerRun);
    final stopwatch = Stopwatch()..start();
    for (final event in events) {
      target.dispatchEvent(event);
    }
    stopwatch.stop();
    return stopwatch.elapsedMicroseconds / eventsPerRun;
  })..sort();

  return _BurstStats(
    n: eventsPerRun,
    minMicrosPerEvent: microsPerEventByRun.first,
    medianMicrosPerEvent: microsPerEventByRun[_timedRuns ~/ 2],
    maxMicrosPerEvent: microsPerEventByRun.last,
  );
}

void _report(String key, _BurstStats stats) => debugPrint('[$key] $stats');

void main() {
  group('measurement noise floor', () {
    patrolTest('dispatch-only baseline (event type no guard listens for)', (
      $,
    ) async {
      final tester = $.tester;
      await _pump(tester);
      final rect = mapRect();
      final target = canvasContainer();
      final point = _leftPoint(rect);
      final stats = _measureBurst(target, (n) => _controlBurst(point, n), 1000);
      _report('control_dispatch_floor', stats);
    });
  });

  group('mousemove sweep', () {
    patrolTest('bare map', ($) async {
      final tester = $.tester;
      await _pump(tester);
      final rect = mapRect();
      final target = canvasContainer();
      final stats = _measureBurst(
        target,
        (n) => _mousemoveSweep(rect, n),
        1000,
      );
      _report('mousemove_bare_map', stats);
    });

    patrolTest('wide overlay (ListView) present', ($) async {
      final tester = $.tester;
      await _pump(tester, overlay: _listOverlay(20));
      final rect = mapRect();
      final target = canvasContainer();
      final stats = _measureBurst(
        target,
        (n) => _mousemoveSweep(rect, n),
        1000,
      );
      _report('mousemove_wide_overlay', stats);
    });

    patrolTest('deep nested overlay (40 levels) present', ($) async {
      final tester = $.tester;
      await _pump(tester, overlay: _deepChain(40));
      final rect = mapRect();
      final target = canvasContainer();
      final stats = _measureBurst(
        target,
        (n) => _mousemoveSweep(rect, n),
        1000,
      );
      _report('mousemove_deep_overlay', stats);
    });
  });

  group('wheel burst over ListView overlay', () {
    for (final itemCount in [100, 500]) {
      patrolTest('$itemCount items — dispatch-cost burst', ($) async {
        final tester = $.tester;
        await _pump(tester, overlay: _listOverlay(itemCount));
        final rect = mapRect();
        final target = canvasContainer();
        final point = _leftPoint(rect);
        final stats = _measureBurst(target, (n) => _wheelBurst(point, n), 180);
        _report('wheel_burst_${itemCount}_items', stats);
      });
    }

    // IntegrationTestWidgetsFlutterBinding.watchPerformance's per-frame
    // engine build/raster breakdown isn't available under Patrol's binding
    // (PatrolBinding extends LiveTestWidgetsFlutterBinding, not
    // IntegrationTestWidgetsFlutterBinding), so this measures wall-clock
    // time per paced dispatch+pump cycle instead — coarser than engine
    // FrameTiming, but still enough to eyeball a regression.
    patrolTest(
      '500 items — frame timing while scrolling (paced)',
      framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.benchmarkLive,
      ($) async {
        final tester = $.tester;
        await _pump(tester, overlay: _listOverlay(500));
        final rect = mapRect();
        final target = canvasContainer();
        final point = _leftPoint(rect);

        const frames = 180;
        final microsPerFrame = <double>[];
        for (var i = 0; i < frames; i++) {
          final stopwatch = Stopwatch()..start();
          target.dispatchEvent(wheelEvent(point.x, point.y));
          await tester.pump(const Duration(milliseconds: 16));
          stopwatch.stop();
          microsPerFrame.add(stopwatch.elapsedMicroseconds.toDouble());
        }
        microsPerFrame.sort();

        _report(
          'wheel_scroll_500_frame_timing',
          _BurstStats(
            n: frames,
            minMicrosPerEvent: microsPerFrame.first,
            medianMicrosPerEvent: microsPerFrame[frames ~/ 2],
            maxMicrosPerEvent: microsPerFrame.last,
          ),
        );
      },
    );
  });
}
