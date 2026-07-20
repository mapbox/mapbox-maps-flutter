import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemMouseCursor;
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:turf/turf.dart' show Point, Position;
import 'patrol.dart';

import 'test_utils.dart';

final _viewport = CameraViewportState(
  center: Point(coordinates: Position(0, 0)),
  zoom: 5,
);

/// Registers a targetless tap interaction and returns a future completing when
/// the map receives a click.
Future<void> _onMapClicked(MapboxMapPlatformInterface controller) {
  final completer = Completer<void>();
  controller.addInteraction(
    TypedInteraction<TypedFeaturesetFeature<FeaturesetDescriptor>>(
      interactionType: InteractionType.tap,
      featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
      action: (feature, context) {
        if (!completer.isCompleted) completer.complete();
      },
    ),
  );
  return completer.future;
}

Future<void> _expectClickReaches(
  MapboxMapPlatformInterface controller,
  double x,
  double y, {
  String? reason,
}) async {
  final clicked = _onMapClicked(controller);
  canvasContainer().dispatchEvent(mouseEvent('click', x, y));
  await clicked.timeout(
    const Duration(seconds: 3),
    onTimeout: () => fail(
      reason ?? 'click at ($x, $y) should have reached the map, but did not',
    ),
  );
}

/// Runs [dispatch], which should trigger some wheel events on the map, and
/// reports whether GL JS's `zoom` event fires within a few seconds
/// afterward.
Future<bool> _zoomFires(JSMap map, void Function() dispatch) {
  final completer = Completer<bool>();
  map.once('zoom', (() => completer.complete(true)).toJS);
  dispatch();
  return completer.future.timeout(
    const Duration(seconds: 3),
    onTimeout: () => false,
  );
}

Future<void> _expectClickBlocked(
  MapboxMapPlatformInterface controller,
  double x,
  double y, {
  String? reason,
}) async {
  final clicked = _onMapClicked(controller);
  canvasContainer().dispatchEvent(mouseEvent('click', x, y));
  await expectLater(
    clicked.timeout(const Duration(seconds: 2)),
    throwsA(isA<TimeoutException>()),
    reason: reason ?? 'click at ($x, $y) should have been blocked from the map',
  );
}

/// An overlay covering the left half of the map, hosting [child].
Widget _leftHalf(Widget child) => Align(
  alignment: Alignment.centerLeft,
  child: FractionallySizedBox(widthFactor: 0.5, heightFactor: 1, child: child),
);

/// Boots the standard harness with [overlay] over the map.
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

/// An overlay whose visible content can be toggled at runtime without touching
/// the map subtree: [State.setState] rebuilds only this widget. Toggle via its
/// [GlobalKey]'s [_ToggleOverlayState].
class _ToggleOverlay extends StatefulWidget {
  const _ToggleOverlay({super.key});
  @override
  State<_ToggleOverlay> createState() => _ToggleOverlayState();
}

class _ToggleOverlayState extends State<_ToggleOverlay> {
  bool _shown = false;
  void toggle(bool shown) => setState(() => _shown = shown);
  @override
  Widget build(BuildContext context) => _shown
      ? _leftHalf(_visibleOverlay)
      // Full-size but non-painting and non-hit-testing: equivalent to no
      // overlay for blocking, while keeping a sized Stack child.
      : const SizedBox.expand();
}

/// A single [MouseRegion] overlay whose cursor can be swapped at runtime,
/// [State.setState] rebuilds only this widget. Drive it via its [GlobalKey]'s
/// [_CursorSwitcherState].
class _CursorSwitcher extends StatefulWidget {
  const _CursorSwitcher({super.key});
  @override
  State<_CursorSwitcher> createState() => _CursorSwitcherState();
}

class _CursorSwitcherState extends State<_CursorSwitcher> {
  MouseCursor _cursor = SystemMouseCursors.basic;
  void setCursor(MouseCursor cursor) => setState(() => _cursor = cursor);
  @override
  Widget build(BuildContext context) =>
      _leftHalf(MouseRegion(cursor: _cursor, child: const SizedBox.expand()));
}

// A transparent, cursor-only overlay: paints nothing but still takes part in
// hit-testing (MouseRegion is opaque), so it covers the map.
const _cursorOverlay = MouseRegion(
  cursor: SystemMouseCursors.text,
  child: SizedBox.expand(),
);
const _visibleOverlay = ColoredBox(
  color: Color(0xFF2196F3),
  child: SizedBox.expand(),
);

void main() {
  ({double x, double y}) leftPoint() {
    final r = mapRect();
    return (x: r.left + r.width * 0.25, y: r.top + r.height / 2);
  }

  ({double x, double y}) rightPoint() {
    final r = mapRect();
    return (x: r.left + r.width * 0.75, y: r.top + r.height / 2);
  }

  group('event blocking', () {
    patrolTest('transparent cursor-only overlay blocks clicks', ($) async {
      final tester = $.tester;
      final controller = await _pump(
        tester,
        overlay: _leftHalf(_cursorOverlay),
      );
      final p = leftPoint();
      await _expectClickBlocked(
        controller,
        p.x,
        p.y,
        reason:
            'a MouseRegion takes part in hit-testing, so it covers the map '
            'even though it paints nothing',
      );
    });

    patrolTest('scrollable (ListView) overlay blocks clicks', ($) async {
      final tester = $.tester;
      // Scrollables span their whole viewport with an opaque pointer listener,
      // so even blank areas of a list panel must cover the map.
      final controller = await _pump(
        tester,
        overlay: _leftHalf(ListView(children: const [SizedBox(height: 24)])),
      );
      final p = leftPoint();
      await _expectClickBlocked(
        controller,
        p.x,
        p.y,
        reason:
            'a scrollable covers the map across its viewport, even on the '
            'blank area between items',
      );
    });

    patrolTest('visible ColoredBox overlay blocks clicks', ($) async {
      final tester = $.tester;
      final controller = await _pump(
        tester,
        overlay: _leftHalf(_visibleOverlay),
      );
      final p = leftPoint();
      await _expectClickBlocked(
        controller,
        p.x,
        p.y,
        reason: 'a visibly painted overlay should keep the click from the map',
      );
    });

    patrolTest('bare map still receives clicks', ($) async {
      final tester = $.tester;
      final controller = await _pump(
        tester,
        overlay: _leftHalf(_visibleOverlay),
      );
      final p = rightPoint();
      await _expectClickReaches(
        controller,
        p.x,
        p.y,
        reason: 'the uncovered half of the map should stay interactive',
      );
    });

    patrolTest('empty overlay (no paint, no self-hit) does NOT block', (
      $,
    ) async {
      final tester = $.tester;
      final controller = await _pump(
        tester,
        overlay: _leftHalf(const SizedBox.expand()),
      );
      final p = leftPoint();
      await _expectClickReaches(
        controller,
        p.x,
        p.y,
        reason:
            'an empty box never self-hits, so the click should pass through',
      );
    });

    patrolTest('widget behind the map does not block or override cursor', (
      $,
    ) async {
      final tester = $.tester;
      final controller = await pumpMapTree(
        tester,
        (onCreated) => MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                const Positioned.fill(child: _visibleOverlay),
                Positioned.fill(
                  child: MapWebWidget(
                    viewport: _viewport,
                    onMapCreated: onCreated,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final p = leftPoint();
      await _expectClickReaches(
        controller,
        p.x,
        p.y,
        reason: 'a widget painted behind the map must not block it',
      );

      canvasContainer().dispatchEvent(mouseEvent('mousemove', p.x, p.y));
      await tester.pump();
      expect(
        canvasContainer().style.getPropertyValue('cursor'),
        isEmpty,
        reason: 'with only a widget behind it, the map keeps GL JS\'s cursor',
      );
    });
  });

  group('guarded event types', () {
    const guarded = <String>['mousedown', 'click', 'dblclick', 'contextmenu'];

    patrolTest('guarded events are blocked over a visible overlay', ($) async {
      final tester = $.tester;
      await _pump(tester, overlay: _leftHalf(_visibleOverlay));
      final p = leftPoint();
      for (final type in guarded) {
        expect(
          arrivesAtCanvas(mouseEvent(type, p.x, p.y)),
          isFalse,
          reason: '$type should be blocked over a visible overlay',
        );
      }
    });

    patrolTest('guarded events reach the bare map', ($) async {
      final tester = $.tester;
      await _pump(tester, overlay: _leftHalf(_visibleOverlay));
      final p = rightPoint();
      for (final type in guarded) {
        expect(
          arrivesAtCanvas(mouseEvent(type, p.x, p.y)),
          isTrue,
          reason: '$type should reach the bare map',
        );
      }
    });

    patrolTest('non-guarded event (mousemove) is not blocked over an overlay', (
      $,
    ) async {
      final tester = $.tester;
      await _pump(tester, overlay: _leftHalf(_visibleOverlay));
      final p = leftPoint();
      expect(arrivesAtCanvas(mouseEvent('mousemove', p.x, p.y)), isTrue);
    });
  });

  group('touch events', () {
    const guardedTouch = <String>['touchstart', 'touchend'];

    patrolTest('touchstart/touchend are blocked over a visible overlay', (
      $,
    ) async {
      final tester = $.tester;
      await _pump(tester, overlay: _leftHalf(_visibleOverlay));
      final p = leftPoint();
      for (final type in guardedTouch) {
        expect(
          arrivesAtCanvas(touchEvent(type, p.x, p.y)),
          isFalse,
          reason: '$type should be blocked over a visible overlay',
        );
      }
    });

    patrolTest('touchstart/touchend reach the bare map', ($) async {
      final tester = $.tester;
      await _pump(tester, overlay: _leftHalf(_visibleOverlay));
      final p = rightPoint();
      for (final type in guardedTouch) {
        expect(
          arrivesAtCanvas(touchEvent(type, p.x, p.y)),
          isTrue,
          reason: '$type should reach the bare map',
        );
      }
    });

    patrolTest('a touch event with no touch points is not blocked', ($) async {
      final tester = $.tester;
      await _pump(tester, overlay: _leftHalf(_visibleOverlay));
      expect(
        arrivesAtCanvas(emptyTouchEvent('touchstart')),
        isTrue,
        reason:
            'a touch event the guard cannot resolve a position for must '
            'never be treated as covered',
      );
    });
  });

  group('multi-touch', () {
    patrolTest(
      'touchstart is blocked when any touch is over the overlay, not just '
      'the first',
      ($) async {
        final tester = $.tester;
        await _pump(tester, overlay: _leftHalf(_visibleOverlay));
        final onMap = rightPoint();
        final onOverlay = leftPoint();
        expect(
          arrivesAtCanvas(multiTouchEvent('touchstart', [onMap, onOverlay])),
          isFalse,
          reason:
              'a covered second finger should block the touchstart even '
              'though the first finger is on the bare map',
        );
      },
    );
  });

  group('touch gesture ownership', () {
    patrolTest(
      'touchend reaches the map when its touchstart did, even if the finger '
      'ends over an overlay',
      ($) async {
        final tester = $.tester;
        await _pump(tester, overlay: _leftHalf(_visibleOverlay));
        final onMap = rightPoint();
        final onOverlay = leftPoint();
        expect(
          arrivesAtCanvas(touchEvent('touchstart', onMap.x, onMap.y)),
          isTrue,
          reason: 'the touch started on the bare map',
        );
        expect(
          arrivesAtCanvas(touchEvent('touchend', onOverlay.x, onOverlay.y)),
          isTrue,
          reason:
              'GL JS already owns this gesture and must see it end, no '
              'matter where the finger currently sits (eg. a drag pan ending '
              'over an overlay)',
        );
      },
    );

    patrolTest(
      'touchend stays blocked when its touchstart did, even if the finger '
      'ends over the bare map',
      ($) async {
        final tester = $.tester;
        await _pump(tester, overlay: _leftHalf(_visibleOverlay));
        final onMap = rightPoint();
        final onOverlay = leftPoint();
        expect(
          arrivesAtCanvas(touchEvent('touchstart', onOverlay.x, onOverlay.y)),
          isFalse,
          reason: 'the touch started over the overlay',
        );
        expect(
          arrivesAtCanvas(touchEvent('touchend', onMap.x, onMap.y)),
          isFalse,
          reason:
              'GL JS never saw this touch start, so it must not see it '
              'end either',
        );
      },
    );

    patrolTest('touchcancel follows the same ownership as touchend', ($) async {
      final tester = $.tester;
      await _pump(tester, overlay: _leftHalf(_visibleOverlay));
      final onMap = rightPoint();
      final onOverlay = leftPoint();
      expect(
        arrivesAtCanvas(touchEvent('touchstart', onMap.x, onMap.y)),
        isTrue,
      );
      expect(
        arrivesAtCanvas(touchEvent('touchcancel', onOverlay.x, onOverlay.y)),
        isTrue,
        reason: 'a gesture GL JS owns must still see it cancelled',
      );
    });
  });

  group('wheel scroll', () {
    // The guard leaves `wheel` propagating (unlike the blocked events above) so
    // Flutter scrollables painted over the map still receive it. GL JS is kept
    // from zooming a covered map by listening to its own `wheel` event and
    // calling `preventDefault()`, not by touching scrollZoom's enabled state.
    patrolTest('wheel keeps reaching the map so Flutter can receive it', (
      $,
    ) async {
      final tester = $.tester;
      await _pump(tester, overlay: _leftHalf(_visibleOverlay));
      final p = leftPoint();
      expect(
        arrivesAtCanvas(wheelEvent(p.x, p.y)),
        isTrue,
        reason:
            'wheel must keep bubbling so a Flutter scrollable over the map '
            'can receive it; GL JS zoom is silenced via its own wheel event '
            'instead',
      );
    });

    patrolTest(
      'wheel zoom is suppressed over an overlay, works over the bare map',
      ($) async {
        final tester = $.tester;
        await _pump(tester, overlay: _leftHalf(_visibleOverlay));
        final map = currentMap(tester)!;

        final over = leftPoint();
        expect(
          await _zoomFires(map, () {
            // GL JS treats an isolated wheel tick as ambiguous input (mouse
            // wheel vs. trackpad) and defers to a 40ms timer before acting on
            // it; dispatching twice in quick succession resolves that
            // immediately instead of relying on the timer to fire.
            canvasContainer().dispatchEvent(wheelEvent(over.x, over.y));
            canvasContainer().dispatchEvent(wheelEvent(over.x, over.y));
          }),
          isFalse,
          reason: 'a covered map must not zoom on wheel',
        );

        final bare = rightPoint();
        expect(
          await _zoomFires(map, () {
            canvasContainer().dispatchEvent(wheelEvent(bare.x, bare.y));
            canvasContainer().dispatchEvent(wheelEvent(bare.x, bare.y));
          }),
          isTrue,
          reason: 'the exposed map must still zoom on wheel',
        );
      },
    );

    patrolTest(
      'app-disabled scroll-zoom is not silently re-enabled by cover/uncover',
      ($) async {
        final tester = $.tester;
        await _pump(tester, overlay: _leftHalf(_visibleOverlay));
        final map = currentMap(tester)!;
        expect(
          map.scrollZoom.isEnabled(),
          isTrue,
          reason: 'sanity: starts enabled',
        );

        // Cover the map while scrollZoom is still enabled, then have the app
        // disable it directly (eg. from a gesture settings screen) while
        // still covered.
        final over = leftPoint();
        canvasContainer().dispatchEvent(wheelEvent(over.x, over.y));
        map.scrollZoom.disable();

        // Uncover the map.
        final bare = rightPoint();
        canvasContainer().dispatchEvent(wheelEvent(bare.x, bare.y));

        expect(
          map.scrollZoom.isEnabled(),
          isFalse,
          reason:
              'uncovering the map must not silently re-enable scroll-zoom '
              'the app explicitly disabled while it was covered',
        );
      },
    );
  });

  group('coordinate mapping', () {
    patrolTest('inset map maps DOM coordinates correctly', ($) async {
      final tester = $.tester;
      const inset = 40.0;
      final controller = await pumpMapTree(
        tester,
        (onCreated) => MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(left: inset, top: inset),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: MapWebWidget(
                      viewport: _viewport,
                      onMapCreated: onCreated,
                    ),
                  ),
                  _leftHalf(_visibleOverlay),
                ],
              ),
            ),
          ),
        ),
      );

      final over = leftPoint();
      await _expectClickBlocked(
        controller,
        over.x,
        over.y,
        reason:
            'when the map is inset, the guard must still convert DOM '
            'coordinates so the overlay blocks the click',
      );
      final bare = rightPoint();
      await _expectClickReaches(
        controller,
        bare.x,
        bare.y,
        reason: 'the exposed inset map should still receive clicks',
      );
    });

    patrolTest('interior overlay blocks inside and passes outside', ($) async {
      final tester = $.tester;
      final controller = await _pump(
        tester,
        overlay: const Center(
          child: FractionallySizedBox(
            widthFactor: 0.6,
            heightFactor: 0.6,
            child: _visibleOverlay,
          ),
        ),
      );
      final r = mapRect();
      // The box spans 20%–80% of each axis. Sample the middle (inside) and a
      // point at 92% width / mid height (outside), both away from the edges.
      await _expectClickBlocked(
        controller,
        r.left + r.width / 2,
        r.top + r.height / 2,
        reason: 'the click over the centered box should be blocked',
      );
      await _expectClickReaches(
        controller,
        r.left + r.width * 0.92,
        r.top + r.height / 2,
        reason: 'a point outside the centered box should reach the map',
      );
    });
  });

  group('invisible pointer widgets', () {
    patrolTest('AbsorbPointer overlay blocks clicks', ($) async {
      final tester = $.tester;
      final controller = await _pump(
        tester,
        overlay: _leftHalf(const AbsorbPointer(child: SizedBox.expand())),
      );
      final p = leftPoint();
      await _expectClickBlocked(
        controller,
        p.x,
        p.y,
        reason: 'AbsorbPointer intentionally absorbs pointers, so it blocks',
      );
    });

    patrolTest('IgnorePointer overlay passes clicks through', ($) async {
      final tester = $.tester;
      final controller = await _pump(
        tester,
        overlay: _leftHalf(const IgnorePointer(child: _visibleOverlay)),
      );
      final p = leftPoint();
      await _expectClickReaches(
        controller,
        p.x,
        p.y,
        reason:
            'IgnorePointer leaves the hit path, so the click passes through',
      );
    });
  });

  group('cursor mirroring', () {
    patrolTest('transparent MouseRegion overrides cursor to text', ($) async {
      final tester = $.tester;
      await _pump(tester, overlay: _leftHalf(_cursorOverlay));
      final p = leftPoint();
      canvasContainer().dispatchEvent(mouseEvent('mousemove', p.x, p.y));
      await tester.pump();
      expect(
        canvasContainer().style.getPropertyValue('cursor'),
        'text',
        reason:
            'an explicit MouseRegion cursor is honored even when '
            'transparent',
      );
    });

    patrolTest('visible overlay with no cursor region uses default', ($) async {
      final tester = $.tester;
      await _pump(tester, overlay: _leftHalf(_visibleOverlay));
      final p = leftPoint();
      canvasContainer().dispatchEvent(mouseEvent('mousemove', p.x, p.y));
      await tester.pump();
      expect(
        canvasContainer().style.getPropertyValue('cursor'),
        'default',
        reason: 'a visible cover with no cursor region falls back to default',
      );
    });

    patrolTest('bare map leaves cursor to GL JS', ($) async {
      final tester = $.tester;
      await _pump(tester, overlay: _leftHalf(_visibleOverlay));
      final p = rightPoint();
      canvasContainer().dispatchEvent(mouseEvent('mousemove', p.x, p.y));
      await tester.pump();
      expect(
        canvasContainer().style.getPropertyValue('cursor'),
        isEmpty,
        reason: 'over the bare map the guard must not override the cursor',
      );
    });

    patrolTest('visible overlay + cursor region blocks and shows pointer', (
      $,
    ) async {
      final tester = $.tester;
      final controller = await _pump(
        tester,
        overlay: _leftHalf(
          const MouseRegion(
            cursor: SystemMouseCursors.click,
            child: _visibleOverlay,
          ),
        ),
      );
      final p = leftPoint();
      canvasContainer().dispatchEvent(mouseEvent('mousemove', p.x, p.y));
      await tester.pump();
      expect(
        canvasContainer().style.getPropertyValue('cursor'),
        'pointer',
        reason: 'the region cursor should beat the default-cover fallback',
      );
      await _expectClickBlocked(
        controller,
        p.x,
        p.y,
        reason: 'the visible cover should still block the click',
      );
    });

    patrolTest('nested MouseRegions: topmost non-defer wins', ($) async {
      final tester = $.tester;
      await _pump(
        tester,
        overlay: _leftHalf(
          const MouseRegion(
            cursor: SystemMouseCursors.text,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: SizedBox.expand(),
            ),
          ),
        ),
      );
      final p = leftPoint();
      canvasContainer().dispatchEvent(mouseEvent('mousemove', p.x, p.y));
      await tester.pump();
      expect(
        canvasContainer().style.getPropertyValue('cursor'),
        'pointer',
        reason: 'the topmost (inner) non-deferring region should win',
      );
    });

    patrolTest('cursor toggles as the pointer moves on and off the overlay', (
      $,
    ) async {
      final tester = $.tester;
      await _pump(tester, overlay: _leftHalf(_cursorOverlay));
      final over = leftPoint();
      final bare = rightPoint();

      canvasContainer().dispatchEvent(mouseEvent('mousemove', over.x, over.y));
      await tester.pump();
      expect(
        canvasContainer().style.getPropertyValue('cursor'),
        'text',
        reason: 'moving onto the overlay applies its cursor',
      );

      canvasContainer().dispatchEvent(mouseEvent('mousemove', bare.x, bare.y));
      await tester.pump();
      expect(
        canvasContainer().style.getPropertyValue('cursor'),
        isEmpty,
        reason: 'moving back onto the bare map clears the override',
      );

      canvasContainer().dispatchEvent(mouseEvent('mousemove', over.x, over.y));
      await tester.pump();
      expect(
        canvasContainer().style.getPropertyValue('cursor'),
        'text',
        reason: 'moving onto the overlay again re-applies its cursor',
      );
    });
  });

  group('cursor exhaustiveness', () {
    const allCursorsExpectedCss = <(SystemMouseCursor, String)>[
      (SystemMouseCursors.none, 'none'),
      (SystemMouseCursors.basic, 'default'),
      (SystemMouseCursors.click, 'pointer'),
      (SystemMouseCursors.forbidden, 'not-allowed'),
      (SystemMouseCursors.wait, 'wait'),
      (SystemMouseCursors.progress, 'progress'),
      (SystemMouseCursors.contextMenu, 'context-menu'),
      (SystemMouseCursors.help, 'help'),
      (SystemMouseCursors.text, 'text'),
      (SystemMouseCursors.verticalText, 'vertical-text'),
      (SystemMouseCursors.cell, 'cell'),
      (SystemMouseCursors.precise, 'crosshair'),
      (SystemMouseCursors.move, 'move'),
      (SystemMouseCursors.grab, 'grab'),
      (SystemMouseCursors.grabbing, 'grabbing'),
      (SystemMouseCursors.noDrop, 'no-drop'),
      (SystemMouseCursors.alias, 'alias'),
      (SystemMouseCursors.copy, 'copy'),
      (SystemMouseCursors.disappearing, 'default'),
      (SystemMouseCursors.allScroll, 'all-scroll'),
      (SystemMouseCursors.resizeLeftRight, 'ew-resize'),
      (SystemMouseCursors.resizeUpDown, 'ns-resize'),
      (SystemMouseCursors.resizeUpLeftDownRight, 'nwse-resize'),
      (SystemMouseCursors.resizeUpRightDownLeft, 'nesw-resize'),
      (SystemMouseCursors.resizeUp, 'n-resize'),
      (SystemMouseCursors.resizeDown, 's-resize'),
      (SystemMouseCursors.resizeLeft, 'w-resize'),
      (SystemMouseCursors.resizeRight, 'e-resize'),
      (SystemMouseCursors.resizeUpLeft, 'nw-resize'),
      (SystemMouseCursors.resizeUpRight, 'ne-resize'),
      (SystemMouseCursors.resizeDownLeft, 'sw-resize'),
      (SystemMouseCursors.resizeDownRight, 'se-resize'),
      (SystemMouseCursors.resizeColumn, 'col-resize'),
      (SystemMouseCursors.resizeRow, 'row-resize'),
      (SystemMouseCursors.zoomIn, 'zoom-in'),
      (SystemMouseCursors.zoomOut, 'zoom-out'),
    ];

    patrolTest('every SystemMouseCursors constant maps to its CSS value', (
      $,
    ) async {
      final tester = $.tester;
      final key = GlobalKey<_CursorSwitcherState>();
      await _pump(tester, overlay: _CursorSwitcher(key: key));
      final p = leftPoint();

      for (final (cursor, expectedCss) in allCursorsExpectedCss) {
        key.currentState!.setCursor(cursor);
        await tester.pump();
        canvasContainer().dispatchEvent(mouseEvent('mousemove', p.x, p.y));
        await tester.pump();
        expect(
          canvasContainer().style.getPropertyValue('cursor'),
          expectedCss,
          reason: '${cursor.kind} should mirror to CSS cursor "$expectedCss"',
        );
      }
    });
  });

  group('live render tree updates', () {
    patrolTest('adding then removing an overlay updates blocking', ($) async {
      final tester = $.tester;
      final key = GlobalKey<_ToggleOverlayState>();
      final controller = await _pump(tester, overlay: _ToggleOverlay(key: key));

      final p = leftPoint();
      await _expectClickReaches(
        controller,
        p.x,
        p.y,
        reason: 'with the overlay hidden the click should reach the map',
      );

      // Only the overlay rebuilds here; the map subtree is untouched.
      key.currentState!.toggle(true);
      await tester.pumpAndSettle();
      await _expectClickBlocked(
        controller,
        p.x,
        p.y,
        reason: 'after showing the overlay the guard should block the click',
      );

      key.currentState!.toggle(false);
      await tester.pumpAndSettle();
      await _expectClickReaches(
        controller,
        p.x,
        p.y,
        reason: 'after hiding the overlay the click should reach the map again',
      );
    });
  });
}
