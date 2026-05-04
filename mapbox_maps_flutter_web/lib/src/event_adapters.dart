import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart' show Point, Position;

import 'bindings/map_bindings.dart';

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
    final sourceId = data.sourceId;
    if (sourceId == null) return;

    // Mapbox GL JS fires sourcedata twice per load: once with
    // sourceDataType='metadata' (initial spec/JSON download), then once with
    // 'content' once the actual data body is available. `isSourceLoaded`
    // transitions to true on metadata-complete and stays true on subsequent
    // updates. Either signal is "data has loaded enough to be useful", which
    // is the closest analogue to the native onSourceDataLoaded event.
    if (data.isSourceLoaded == true) {
      _onMapEvent(_adaptSourceDataLoaded(data));
    }
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

  CameraChangedEventData _adaptCameraChanged() {
    final center = _map.getCenter();
    return CameraChangedEventData(
      timestamp: _nowMicros(),
      cameraState: CameraState(
        center: Point(coordinates: Position(center.lng, center.lat)),
        // GL JS manages viewport padding per camera command (jumpTo/easeTo)
        // and does not expose a "current padding" getter; zero matches how
        // a non-padded camera is modelled on the native side.
        padding: MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
        zoom: _map.getZoom(),
        bearing: _map.getBearing(),
        pitch: _map.getPitch(),
      ),
    );
  }

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

  SourceDataLoadedEventData _adaptSourceDataLoaded(JSMapDataEvent data) =>
      SourceDataLoadedEventData(
        id: data.sourceId!,
        // GL JS sourcedata events do not carry a tile payload on this path;
        // metadata is the only bucket we can defensibly distinguish.
        type: SourceDataType.METADATA,
        loaded: data.isSourceLoaded,
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
