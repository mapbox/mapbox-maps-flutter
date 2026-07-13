import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web';

import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:web/web.dart';

import 'bindings/map_bindings.dart';
import 'event_adapters.dart';
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
  JSMap? _currentMap;
  MapboxMapWeb? _mapboxMap;
  ResizeObserver? _resizeObserver;
  MapEventBridge? _eventBridge;

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

  void _onPlatformViewCreated(int viewId) {
    final nativeMap = JSMap(JSMapOptions(container: _mapElement, minZoom: 0));
    _currentMap = nativeMap;

    // The platform view container may not have its layout dimensions yet.
    // Use a ResizeObserver to call map.resize() once it gets real size.
    _resizeObserver = ResizeObserver(
      ((JSArray entries, JSAny observer) {
        nativeMap.resize();
      }).toJS,
    );
    _resizeObserver!.observe(_mapElement);

    // Wire cross-domain dependencies into the viewport before flushing
    // pending viewport state — `FollowPuckViewportState` needs them set
    // or it's silently dropped at apply time.
    final mapboxMap = MapboxMapWeb(nativeMap);
    mapboxMap.attachViewport(_viewport);

    _mapboxMap = mapboxMap;

    // Apply the initial viewport immediately — camera commands like jumpTo
    // and fitBounds work before the style finishes loading.
    _applyViewport();

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
    if (widget.viewport != oldWidget.viewport) {
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
      viewType: _viewType,
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }
}
