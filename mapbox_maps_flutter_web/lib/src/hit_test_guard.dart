import 'dart:js_interop';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:web/web.dart';

import 'bindings/map_bindings.dart';

/// Makes GL JS respect Flutter widgets stacked above the map.
///
/// The map lives in a real DOM node ([HtmlElementView]), and GL JS binds its
/// own event and cursor handling to that node. The browser routes native
/// events and cursor styling by DOM position, so both ignore whatever Flutter
/// painted on top. Each behavior below asks Flutter's render tree what is
/// topmost at a point (via [GestureBinding.hitTestInView]) and corrects GL JS
/// when the map is covered: [_GestureEventGuard] blocks gesture events,
/// [_ScrollGuard] suppresses wheel-zoom via GL JS's own `wheel` event,
/// [_CursorMirror] fixes the cursor.
final class HitTestGuard {
  HitTestGuard({
    required HTMLElement container,
    required GlobalKey mapViewKey,
    required JSMap map,
  }) : _guards = [
         _GestureEventGuard(container: container, mapViewKey: mapViewKey),
         _CursorMirror(container: container, mapViewKey: mapViewKey),
         _ScrollGuard(container: container, mapViewKey: mapViewKey, map: map),
       ];

  final List<_EventGuard> _guards;

  void dispose() {
    for (final guard in _guards) {
      guard.dispose();
    }
  }
}

/// Minimal contract every guard [HitTestGuard] owns must satisfy.
abstract interface class _EventGuard {
  void dispose();
}

/// Hit-tests Flutter's render tree at every point a browser event touches.
mixin _MapHitTesting {
  HTMLElement get container;
  GlobalKey get mapViewKey;

  /// Returns `null` when the point can't be resolved: map detached, non-pointer event,
  /// or no enclosing view.
  _MapHitTestResult? hitTestAt(Event event) {
    final mapRenderObject = mapViewKey.currentContext?.findRenderObject();
    if (mapRenderObject == null || !mapRenderObject.attached) return null;

    final clientPoints = _clientPointsOf(event);
    if (clientPoints == null || clientPoints.isEmpty) return null;

    final viewContext = mapViewKey.currentContext;
    if (viewContext == null) return null;

    final view = View.maybeOf(viewContext);
    if (view == null) return null;

    // The map's DOM rect, in browser client-space coordinates.
    final containerRect = container.getBoundingClientRect();
    // The same top-left corner, in Flutter's global coordinate space. DOM and
    // Flutter coordinates don't have to share an origin (e.g. a host page embeds
    // the Flutter view at an offset), so this anchors the conversion below.
    final flutterOrigin = (mapRenderObject as RenderBox).localToGlobal(
      Offset.zero,
    );

    final results = <HitTestResult>[];
    for (final clientPoint in clientPoints) {
      // The event's client point, translated into Flutter's coordinate space.
      final position =
          flutterOrigin +
          Offset(
            clientPoint.x - containerRect.left,
            clientPoint.y - containerRect.top,
          );
      final result = HitTestResult();
      GestureBinding.instance.hitTestInView(result, position, view.viewId);
      results.add(result);
    }
    return _MapHitTestResult(results, mapRenderObject);
  }

  List<({double x, double y})>? _clientPointsOf(Event event) {
    if (event.isA<MouseEvent>()) {
      final mouseEvent = event as MouseEvent;
      return [
        (x: mouseEvent.clientX.toDouble(), y: mouseEvent.clientY.toDouble()),
      ];
    }
    if (event.isA<TouchEvent>()) {
      final touchEvent = event as TouchEvent;
      final touches = touchEvent.touches.length > 0
          ? touchEvent.touches
          : touchEvent.changedTouches;
      if (touches.length == 0) return null;
      return [
        for (var i = 0; i < touches.length; i++)
          (
            x: touches.item(i)!.clientX.toDouble(),
            y: touches.item(i)!.clientY.toDouble(),
          ),
      ];
    }
    return null;
  }
}

/// Hit-test results, one per point, paired with the map's render object so
/// callers can tell where the map sits in each hit path.
class _MapHitTestResult {
  _MapHitTestResult(this.results, this.mapRenderObject);

  /// Always non-empty.
  final List<HitTestResult> results;
  final RenderObject mapRenderObject;

  /// The event's primary point. Safe only for guards that see mouse-only
  /// (single-point) events.
  HitTestResult get primary => results.first;

  /// Whether any hit-testable widget sits above the map at any of the
  /// event's points.
  bool get mapIsCovered => results.any(_isCoveredAt);

  /// `path` is front-to-back, so a point is covered unless `path.first` is
  /// the map's own subtree.
  bool _isCoveredAt(HitTestResult result) {
    if (result.path.isEmpty) return false;
    final top = result.path.first.target;
    if (top is RenderObject && isMapOrDescendant(top)) return false;
    return true;
  }

  /// Whether [node] is the map's render object or one of its descendants.
  bool isMapOrDescendant(RenderObject node) {
    for (RenderObject? o = node; o != null; o = o.parent) {
      if (identical(o, mapRenderObject)) return true;
    }
    return false;
  }
}

/// Registers and disposes a browser DOM listener for a hit-test-driven guard.
/// `capture` is required, not defaulted: capture-vs-bubble timing matters per
/// guard.
abstract base class _BrowserEventGuard
    with _MapHitTesting
    implements _EventGuard {
  _BrowserEventGuard({
    required this.container,
    required this.mapViewKey,
    required List<String> eventTypes,
    required bool capture,
  }) : _eventTypes = eventTypes,
       _capture = capture {
    _listener = _onEvent.toJS;
    for (final type in _eventTypes) {
      container.addEventListener(
        type,
        _listener,
        EventListenerOptions(capture: capture),
      );
    }
  }

  @override
  final HTMLElement container;
  @override
  final GlobalKey mapViewKey;

  final List<String> _eventTypes;
  // Removal must repeat the same capture flag passed to addEventListener, or
  // it doesn't match the registered listener and silently fails to remove it.
  final bool _capture;
  late final JSFunction _listener;

  void _onEvent(Event event) => handle(event, hitTestAt(event));

  /// React to [event] at the map; [hit] is the precomputed hit-test result,
  /// `null` when the point couldn't be resolved (map detached, unresolvable
  /// event type, or no enclosing view).
  @visibleForOverriding
  void handle(Event event, _MapHitTestResult? hit);

  @override
  @mustCallSuper
  void dispose() {
    for (final type in _eventTypes) {
      container.removeEventListener(
        type,
        _listener,
        EventListenerOptions(capture: _capture),
      );
    }
  }
}

/// Blocks gesture-initiating events from reaching GL JS when a Flutter widget covers
/// the map, so eg. a drag or tap never starts under an overlay.
///
/// GL JS listens in the bubble phase, so a capture-phase listener runs first
/// and `stopPropagation` keeps the event from ever bubbling to it. Flutter is
/// unaffected: it drives its own gestures from pointer events (`pointerdown`
/// etc.), which aren't in this list and keep flowing. Only the initiating
/// events are guarded: hit-testing every `mousemove`/`touchmove` would cost a
/// hit test per frame for no added protection, not a major performance concern
/// but still unnecessary.
///
/// `touchend`/`touchcancel` are the exception to "hit-test decides": once GL
/// JS has seen a touch's `touchstart`, it must see that touch end too,
/// wherever the finger ends up, or eg. a drag pan never finishes on its side.
/// A touch GL JS never started still needs blocking at its end, so
/// ownership, not position, decides for touch.
///
/// `mouseup` skips this entirely: browsers don't guarantee it fires at all
/// (eg. released outside the window), so GL JS doesn't lean on it either,
/// it self-heals via `mousemove`'s button state instead. Tracking ownership
/// of an event that unreliable buys nothing, so `mouseup` stays unguarded.
final class _GestureEventGuard extends _BrowserEventGuard {
  _GestureEventGuard({required super.container, required super.mapViewKey})
    : super(
        eventTypes: _guardedEvents,
        // capture: true. GL JS listens in the bubble phase, so a
        // capture-phase stopPropagation runs first.
        capture: true,
      );

  static const _guardedEvents = <String>[
    'mousedown',
    'click',
    'dblclick',
    'contextmenu',
    'touchstart',
    'touchend',
    'touchcancel',
  ];

  // Ids of touches GL JS has seen a `touchstart` for. `touchend`/`touchcancel`
  // block a touch iff its id is missing here, and remove it either way.
  final Set<int> _touchIdsKnownToGlJs = {};

  @override
  void handle(Event event, _MapHitTestResult? hit) {
    if (event.isA<TouchEvent>()) {
      _handleTouch(event as TouchEvent, hit);

      return;
    }
    if (hit != null && hit.mapIsCovered) {
      event.stopPropagation();
    }
  }

  void _handleTouch(TouchEvent event, _MapHitTestResult? hit) {
    if (event.type == 'touchstart') {
      if (hit != null && hit.mapIsCovered) {
        event.stopPropagation();
      } else {
        _touchIdsKnownToGlJs.addAll(_identifiersOf(event.changedTouches));
      }
      return;
    }

    // Ownership decides here, not the current hit test.
    final endedIds = _identifiersOf(event.changedTouches);
    if (endedIds.isEmpty) return;
    final knownToGlJs = endedIds.any(_touchIdsKnownToGlJs.contains);
    _touchIdsKnownToGlJs.removeAll(endedIds);
    if (!knownToGlJs) {
      event.stopPropagation();
    }
  }

  List<int> _identifiersOf(TouchList touches) => [
    for (var i = 0; i < touches.length; i++) touches.item(i)!.identifier,
  ];
}

/// Shows the cursor Flutter wants when a widget covers the map.
///
/// GL JS styles the cursor with a CSS class on its canvas-container, which the
/// browser keeps applying even under a Flutter overlay. An inline `cursor`
/// beats that class, so writing one on the canvas-container lets us override
/// GL JS's cursor and clear it again to hand control back.
final class _CursorMirror extends _BrowserEventGuard {
  _CursorMirror({required super.container, required super.mapViewKey})
    : super(
        eventTypes: const ['mousemove'],
        // Mirroring doesn't need to preempt GL JS; running in the default
        // bubble phase (after GL JS's own listener on the deeper
        // canvas-container) lets our override win deterministically.
        capture: false,
      );

  HTMLElement? _canvasContainer;

  // The cursor value currently written to the canvas-container's style, or
  // null if nothing is overridden. Doubles as the "is overridden" flag and
  // lets [handle] skip the DOM write entirely on the common case of
  // consecutive mousemove events landing on the same cursor.
  String? _appliedCursor;

  @override
  void dispose() {
    super.dispose();
    if (_appliedCursor != null) {
      _canvasContainer?.style.removeProperty('cursor');
    }
  }

  @override
  void handle(Event event, _MapHitTestResult? hit) {
    final canvasContainer = _canvasContainer ??=
        container.querySelector('.mapboxgl-canvas-container') as HTMLElement?;
    if (canvasContainer == null) return;

    final cursor = hit == null ? null : _flutterCursorAt(hit);
    if (cursor == _appliedCursor) return;
    if (cursor != null) {
      canvasContainer.style.setProperty('cursor', cursor);
    } else {
      canvasContainer.style.removeProperty('cursor');
    }
    _appliedCursor = cursor;
  }

  // The CSS cursor Flutter wants here, or null to leave it to GL JS.
  //
  // The topmost non-deferring MouseRegion above the map wins. Otherwise a
  // covering widget takes 'default'; a bare map keeps GL JS's cursor.
  //
  // mousemove is mouse-only, so `.primary` (the event's one point) is safe.
  String? _flutterCursorAt(_MapHitTestResult hit) {
    for (final entry in hit.primary.path) {
      final target = entry.target;
      // Stop at the map plane; regions behind it are irrelevant.
      if (target is RenderObject && hit.isMapOrDescendant(target)) break;
      if (target is RenderMouseRegion) {
        final cursor = target.cursor;
        if (cursor is SystemMouseCursor && cursor != MouseCursor.defer) {
          return _kindToCss[cursor.kind] ?? 'default';
        }
      }
    }
    return hit.mapIsCovered ? 'default' : null;
  }

  // Flutter cursor kind to CSS value, copied from the web engine's private
  // _kindToCssValueMap (engine/mouse/cursor.dart). Keep in sync with it.
  static const _kindToCss = <String, String>{
    'alias': 'alias',
    'allScroll': 'all-scroll',
    'basic': 'default',
    'cell': 'cell',
    'click': 'pointer',
    'contextMenu': 'context-menu',
    'copy': 'copy',
    'forbidden': 'not-allowed',
    'grab': 'grab',
    'grabbing': 'grabbing',
    'help': 'help',
    'move': 'move',
    'none': 'none',
    'noDrop': 'no-drop',
    'precise': 'crosshair',
    'progress': 'progress',
    'text': 'text',
    'resizeColumn': 'col-resize',
    'resizeDown': 's-resize',
    'resizeDownLeft': 'sw-resize',
    'resizeDownRight': 'se-resize',
    'resizeLeft': 'w-resize',
    'resizeLeftRight': 'ew-resize',
    'resizeRight': 'e-resize',
    'resizeRow': 'row-resize',
    'resizeUp': 'n-resize',
    'resizeUpDown': 'ns-resize',
    'resizeUpLeft': 'nw-resize',
    'resizeUpRight': 'ne-resize',
    'resizeUpLeftDownRight': 'nwse-resize',
    'resizeUpRightDownLeft': 'nesw-resize',
    'verticalText': 'vertical-text',
    'wait': 'wait',
    'zoomIn': 'zoom-in',
    'zoomOut': 'zoom-out',
  };
}

/// Payload of GL JS's `wheel` event. `preventDefault()` tells GL JS to skip
/// scroll-zoom for this event, without touching scrollZoom's enabled flag.
@JS()
@anonymous
extension type _JSMapWheelEvent._(JSObject _) implements JSObject {
  external WheelEvent get originalEvent;
  external void preventDefault();
}

/// Registers and disposes a GL JS map-event listener for a hit-test-driven
/// guard.
abstract base class _MapEventGuard with _MapHitTesting implements _EventGuard {
  _MapEventGuard({
    required this.container,
    required this.mapViewKey,
    required JSMap map,
    required String eventType,
  }) : _map = map,
       _eventType = eventType {
    _listener = _onEvent.toJS;
    _map.on(_eventType, _listener);
  }

  @override
  final HTMLElement container;
  @override
  final GlobalKey mapViewKey;

  final JSMap _map;
  final String _eventType;
  late final JSFunction _listener;

  void _onEvent(JSAny event) => handle(event);

  /// React to a GL JS map event of [_eventType].
  @visibleForOverriding
  void handle(JSAny event);

  @override
  @mustCallSuper
  void dispose() {
    _map.off(_eventType, _listener);
  }
}

/// Suppresses GL JS's wheel-zoom over a covered map, while leaving `wheel`
/// bubbling so a Flutter scrollable painted over the map still receives it.
///
/// Prevents GL JS's own `wheel` event instead of disabling scrollZoom, so it
/// never fights the app's own gesture settings over that flag.
final class _ScrollGuard extends _MapEventGuard {
  _ScrollGuard({
    required super.container,
    required super.mapViewKey,
    required super.map,
  }) : super(eventType: 'wheel');

  @override
  void handle(JSAny event) {
    final wheelEvent = event as _JSMapWheelEvent;
    final hit = hitTestAt(wheelEvent.originalEvent);
    if (hit != null && hit.mapIsCovered) {
      wheelEvent.preventDefault();
    }
  }
}
