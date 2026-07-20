import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web';

import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:web/web.dart';

import 'bindings/map_bindings.dart';
import 'hit_test_guard.dart';
import 'event_adapters.dart';
import 'gl_js_loader.dart';
import 'mapbox_map_web.dart';
import 'viewport/viewport_web.dart';

class MapWebWidget extends StatefulWidget {
  final PlatformMapCreatedCallback? onMapCreated;
  final void Function(MapEvent)? onMapEvent;
  final ViewportState? viewport;
  final ViewportTransition? viewportTransition;
  final void Function(bool)? viewportTransitionCompletion;

  const MapWebWidget({
    super.key,
    this.onMapCreated,
    this.onMapEvent,
    this.viewport,
    this.viewportTransition,
    this.viewportTransitionCompletion,
  });

  @override
  State<MapWebWidget> createState() => _MapWebWidgetState();
}

class _MapWebWidgetState extends State<MapWebWidget> {
  static int _nextViewId = 0;

  late final String _viewType;
  late final HTMLDivElement _mapElement;
  final ViewportWeb _viewport = ViewportWeb();
  final GlobalKey _mapViewKey = GlobalKey();
  JSMap? _currentMap;
  MapboxMapWeb? _mapboxMap;
  ResizeObserver? _resizeObserver;
  MapEventBridge? _eventBridge;
  bool _initialViewportApplied = false;
  HitTestGuard? _hitTestGuard;

  @visibleForTesting
  JSMap? get currentMap => _currentMap;

  @override
  void initState() {
    super.initState();

    final viewId = _nextViewId++;
    _viewType = 'mapbox-maps-flutter-web/$viewId';

    platformViewRegistry.registerViewFactory(_viewType, (int id) {
      _mapElement = document.createElement('div') as HTMLDivElement
        ..style.position = 'absolute'
        ..style.top = '0'
        ..style.bottom = '0'
        ..style.height = '100%'
        ..style.width = '100%';
      return _mapElement;
    });
  }

  void _onPlatformViewCreated(int viewId) async {
    await ensureMapboxGlJsLoaded();
    if (!mounted) return;

    // Wait for element to be attached to DOM before creating map.
    // GL JS's _detectMissingCSS() check requires the element to be
    // connected so CSS rules from document.head cascade properly.
    final attachmentCompleter = Completer<void>();

    _resizeObserver = ResizeObserver(
      ((JSArray entries, JSAny observer) {
        if (!attachmentCompleter.isCompleted && _mapElement.isConnected) {
          attachmentCompleter.complete();
        }
        if (attachmentCompleter.isCompleted) {
          _currentMap?.resize();
        }
        if (!_initialViewportApplied &&
            _mapElement.clientWidth != 0 &&
            _mapElement.clientHeight != 0) {
          _initialViewportApplied = true;
          _applyViewport();
        }
      }).toJS,
    );
    _resizeObserver!.observe(_mapElement);
    await attachmentCompleter.future;
    if (!mounted) return;

    final nativeMap = JSMap(JSMapOptions(container: _mapElement, minZoom: 0));
    _currentMap = nativeMap;

    _hitTestGuard = HitTestGuard(
      container: _mapElement,
      mapViewKey: _mapViewKey,
      map: nativeMap,
    );

    // Wire cross-domain dependencies into the viewport before flushing
    // pending viewport state — `FollowPuckViewportState` needs them set
    // or it's silently dropped at apply time.
    final mapboxMap = MapboxMapWeb(nativeMap);
    mapboxMap.attachViewport(_viewport);

    _mapboxMap = mapboxMap;

    final mapCreated = Completer<void>();
    final onMapEvent = widget.onMapEvent;
    if (onMapEvent != null) {
      _eventBridge = MapEventBridge(nativeMap, (event) {
        if (mapCreated.isCompleted) {
          onMapEvent(event);
        } else {
          mapCreated.future.then((_) => onMapEvent(event));
        }
      });
    }

    try {
      widget.onMapCreated?.call(mapboxMap);
    } finally {
      mapCreated.complete();
    }
  }

  @override
  void didUpdateWidget(MapWebWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Before the container is sized, the ResizeObserver applies the latest
    // viewport once it can; after, apply changes directly.
    if (widget.viewport != oldWidget.viewport && _initialViewportApplied) {
      _applyViewport();
    }
  }

  void _applyViewport() {
    final viewport = widget.viewport;
    if (viewport == null) return;
    _viewport.applyIfChanged(
      viewport,
      widget.viewportTransition,
      widget.viewportTransitionCompletion,
    );
  }

  @override
  void dispose() {
    _hitTestGuard?.dispose();
    _hitTestGuard = null;
    _eventBridge?.dispose();
    _eventBridge = null;
    _resizeObserver?.disconnect();
    _resizeObserver = null;
    _currentMap?.remove();
    _currentMap = null;
    _mapboxMap?.dispose();
    _mapboxMap = null;
    _viewport.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      key: _mapViewKey,
      viewType: _viewType,
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }
}
