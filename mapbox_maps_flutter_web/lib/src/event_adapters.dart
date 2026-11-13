import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import 'bindings/binding_adapters.dart';
import 'bindings/map_bindings.dart';
import 'bindings/style_bindings.dart';

/// Bridges Mapbox GL JS events to platform-interface [MapEvent] subclasses.
///
/// Owns the subscription lifecycle: constructor wires every GL JS event the
/// facade cares about; [dispose] tears them down. Per the WS2.5 plan the
/// following native-only events have no GL JS equivalent and are intentionally
/// never emitted — the facade's listener slots remain so the cross-platform
/// API shape is parity-preserving, but web callers will simply never be
/// invoked for them:
///
///  * `onMapLoadError` — GL JS has `error` events, but shape differs enough
///    that adapting into `MapLoadingErrorEventData` would mint every field.
///  * `onStyleImageMissing` / `onStyleImageUnused` — GL JS surfaces these via
///    `styleimagemissing` only; "unused" is not emitted.
///  * `onResourceRequest` — GL JS `resourcerequest` has a different
///    request/response shape that would require a dedicated adapter epic.
///  * `onSourceAdded` / `onSourceRemoved` — GL JS has no source-lifecycle
///    events. Sources fire `data`/`sourcedata` when their content arrives
///    and stop emitting on removal; correlating those signals back to
///    native add/remove timing would require an external diff and risks
///    drifting from native semantics, so they stay unwired.
///
/// See the web-parity follow-up epic referenced from the migration plan for
/// the path to filling these in.
class MapEventBridge {
  final JSMap _map;
  final void Function(MapEvent) _onMapEvent;
  final List<_Subscription> _subscriptions = [];
  final Map<String, ({String loadKey, DateTime time})> _lastTileEvents = {};

  static const _tileCopyWindow = Duration(seconds: 1);

  MapEventBridge(this._map, this._onMapEvent) {
    // GL JS `data` is filtered by the Map into `styledata` and `sourcedata`
    // (re-fired by ui/map.ts based on `dataType`), so we subscribe to those
    // directly instead of filtering `data` ourselves.
    _on(JSMapEvents.load, (_) => _onMapEvent(_adaptLoad()));
    _on(JSMapEvents.styleLoad, (_) => _onMapEvent(_adaptStyleLoad()));
    _on(JSMapEvents.styleData, (_) => _onMapEvent(_adaptStyleDataLoaded()));
    _on(JSMapEvents.sourceData, _handleSourceData);
    _on(JSMapEvents.idle, (_) => _onMapEvent(_adaptIdle()));
    _on(JSMapEvents.cameraMove, (_) => _onMapEvent(_adaptCameraChanged()));
    _on(JSMapEvents.renderStart, (_) => _onMapEvent(_adaptRenderStart()));
    _on(JSMapEvents.render, (_) => _onMapEvent(_adaptRenderFinished()));
  }

  void dispose() {
    for (final sub in _subscriptions) {
      _map.off(sub.name, sub.fn);
    }
    _subscriptions.clear();
  }

  void _on(String name, void Function(JSAny event) handler) {
    final fn = handler.toJS;
    _map.on(name, fn);
    _subscriptions.add(_Subscription(name, fn));
  }

  // ===== Dispatch helpers =====

  void _handleSourceData(JSAny event) {
    final data = event as JSMapDataEvent;
    if (data.dataType != 'source') return;
    final sourceId = data.sourceId;
    if (sourceId == null) return;
    // The native SDKs do not report sources of imported styles.
    if (data.style?.scope?.isNotEmpty ?? false) return;

    if (data.coord case final coord?) {
      // Keep a copy that reports the end of the source load, so that the
      // `loaded` flag still becomes true.
      final isCopy = _isTileCopy(sourceId, coord, data.sourceCacheId);
      if (isCopy && data.isSourceLoaded != true) return;
      _onMapEvent(_adaptTileLoaded(sourceId, coord.canonical, data));
    } else if (_isMetadataLoad(sourceId, data.sourceDataType)) {
      _onMapEvent(_adaptMetadataLoaded(sourceId));
    }
  }

  /// GL JS sends `'metadata'` for the first load of a source only. GeoJSON
  /// and image sources send later data updates as `'content'`, which the
  /// native SDKs report as a metadata load. Other sources send `'content'`
  /// together with the first `'metadata'`, so it is not sent again.
  bool _isMetadataLoad(String sourceId, String? sourceDataType) {
    if (sourceDataType == 'metadata') return true;
    if (sourceDataType != 'content') return false;
    final type = _map.getSource(sourceId)?.type;
    return type == 'geojson' || type == 'image';
  }

  /// GL JS can keep up to three tile caches for one source, and each cache
  /// sends its own event for a tile. It also loads the same tile again for
  /// each copy of the world that is in view. The native SDKs send one event
  /// for each tile, so an event for the same tile from a different cache or
  /// world copy shortly after the first is a copy. GL JS sets
  /// `isSourceLoaded` only on the last of these events.
  bool _isTileCopy(String sourceId, JSOverscaledTileID coord, String? cacheId) {
    final tile = coord.canonical;
    final tileKey = '$sourceId/${tile.z}/${tile.x}/${tile.y}';
    final loadKey = '$cacheId/${coord.key}';
    final now = DateTime.now();
    final last = _lastTileEvents[tileKey];
    _lastTileEvents.removeWhere(
      (_, event) => now.difference(event.time) > _tileCopyWindow,
    );
    if (last != null &&
        last.loadKey != loadKey &&
        now.difference(last.time) <= _tileCopyWindow) {
      return true;
    }
    _lastTileEvents[tileKey] = (loadKey: loadKey, time: now);
    return false;
  }

  // ===== Adapters =====

  MapLoadedEventData _adaptLoad() =>
      MapLoadedEventData(timeInterval: _nowInterval());

  StyleLoadedEventData _adaptStyleLoad() =>
      StyleLoadedEventData(timeInterval: _nowInterval());

  StyleDataLoadedEventData _adaptStyleDataLoaded() => StyleDataLoadedEventData(
    timeInterval: _nowInterval(),
    // GL JS does not subdivide style-data events into sprite/sources/style
    // the way the native SDK does. STYLE is the broadest match and what
    // the native emitter defaults to for top-level style-ready signals.
    type: StyleDataType.STYLE,
  );

  CameraChangedEventData _adaptCameraChanged() => CameraChangedEventData(
    timestamp: _nowMicros(),
    cameraState: _map.getCameraState(),
  );

  MapIdleEventData _adaptIdle() => MapIdleEventData(timestamp: _nowMicros());

  RenderFrameStartedEventData _adaptRenderStart() =>
      RenderFrameStartedEventData(timestamp: _nowMicros());

  RenderFrameFinishedEventData _adaptRenderFinished() =>
      RenderFrameFinishedEventData(
        timeInterval: _nowInterval(),
        // GL JS renders one frame at a time and does not surface a
        // partial-vs-full distinction. Reporting FULL matches what a
        // synchronous browser render is guaranteed to produce.
        renderMode: RenderMode.FULL,
        // GL JS does not report these; callers on the native side read them
        // to decide whether to request another frame — on web GL JS schedules
        // repaint internally, so `false` is the honest default.
        needsRepaint: false,
        placementChanged: false,
      );

  SourceDataLoadedEventData _adaptTileLoaded(
    String sourceId,
    JSCanonicalTileID tile,
    JSMapDataEvent data,
  ) => SourceDataLoadedEventData(
    id: sourceId,
    type: SourceDataType.TILE,
    loaded: data.isSourceLoaded,
    tileID: TileID(z: tile.z, x: tile.x, y: tile.y),
    // GL JS has no data ids for GeoJSON updates.
    dataId: null,
    timeInterval: _nowInterval(),
  );

  SourceDataLoadedEventData _adaptMetadataLoaded(String sourceId) =>
      SourceDataLoadedEventData(
        id: sourceId,
        type: SourceDataType.METADATA,
        loaded: null,
        tileID: null,
        dataId: null,
        timeInterval: _nowInterval(),
      );
}

int _nowMicros() => DateTime.now().microsecondsSinceEpoch;

// GL JS events do not carry a start/end timestamp; we mint a point-in-time
// interval so the platform-interface shape is satisfiable without faking a
// duration the web implementation has not actually measured.
EventTimeInterval _nowInterval() {
  final now = DateTime.now();
  return EventTimeInterval(begin: now, end: now);
}

class _Subscription {
  final String name;
  final JSFunction fn;
  _Subscription(this.name, this.fn);
}
