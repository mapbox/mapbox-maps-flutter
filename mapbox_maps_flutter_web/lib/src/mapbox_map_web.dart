import 'dart:convert';
import 'dart:async';
import 'dart:js_interop';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show UniqueKey;
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';
import 'package:turf/turf.dart'
    show GeometryObject, Point, Position, bbox, bearing;

import 'bindings/binding_adapters.dart';
import 'bindings/map_bindings.dart';
import 'gestures_controller.dart';
import 'interaction_handler.dart';
import 'location/location_controller.dart';
import 'style_controller_web.dart';
import 'unsupported_sub_interfaces.dart';
import 'viewport/viewport_web.dart';

/// Web [MapboxMapPlatformInterface] implementation backed by Mapbox GL JS.
///
/// The WS2.5 scope is deliberately narrow: this class exists to give
/// `onMapCreated` a non-null controller so the facade integration suite can
/// run on Chrome. Only the handful of methods used by the passing tests
/// (camera read/write, style load) are backed by GL JS. Everything else
/// throws [UnimplementedError] for "GL JS has an analogue we haven't wired
/// yet" or [UnsupportedError] for "web does not support this by design".
///
/// Sub-interface getters return the throwing stubs in
/// [unsupported_sub_interfaces.dart]. Gesture listener slots round-trip the
/// caller's value but never fire — GL JS has gesture events we could adapt,
/// but wiring them is web-parity follow-up work.
base class MapboxMapWeb implements MapboxMapPlatformInterface {
  final JSMap _map;
  final _disposables = DisposeBag();

  MapboxMapWeb(this._map);

  /// Wires [viewport] with cross-domain dependencies from this map.
  @internal
  void attachViewport(ViewportWeb viewport) {
    viewport.onMapCreated(_map);
    viewport.positionStreamProvider = () =>
        (location as LocationController).locationUpdates;
  }

  // ===== Sub-interfaces =====

  @override
  late final StylePlatformInterface style = StyleController(_map);
  @override
  late final GesturesSettingsPlatformInterface gestures = GesturesController(
    _map,
  );
  @override
  late final LocationSettingsPlatformInterface location = LocationController(
    _map,
  ).addToDisposeBag(_disposables);
  @override
  late final ScaleBarSettingsPlatformInterface scaleBar =
      UnsupportedScaleBarSettingsWeb();
  @override
  late final CompassSettingsPlatformInterface compass =
      UnsupportedCompassSettingsWeb();
  @override
  late final AttributionSettingsPlatformInterface attribution =
      UnsupportedAttributionSettingsWeb();
  @override
  late final LogoSettingsPlatformInterface logo = UnsupportedLogoSettingsWeb();
  @override
  late final IndoorSelectorSettingsPlatformInterface indoorSelector =
      UnsupportedIndoorSelectorSettingsWeb();
  @override
  late final AnnotationManagerPlatformInterface annotations =
      UnsupportedAnnotationManagerWeb();
  @override
  late final MapboxHttpServicePlatformInterface httpService =
      UnsupportedHttpServiceWeb();
  @override
  late final ProjectionPlatformInterface projection =
      UnsupportedProjectionWeb();
  @override
  @experimental
  late final MapRecorderPlatformInterface mapRecorder =
      UnsupportedMapRecorderWeb();

  // ===== Performance statistics =====
  //
  // GL JS exposes a performance API but wiring it up sits in the
  // web-parity follow-up epic; throw until then.

  @override
  void startPerformanceStatisticsCollection(
    PerformanceStatisticsOptions options,
    PerformanceStatisticsListener listener,
  ) => throw UnimplementedError(
    'startPerformanceStatisticsCollection is not yet implemented on web.',
  );

  @override
  void stopPerformanceStatisticsCollection() => throw UnimplementedError(
    'stopPerformanceStatisticsCollection is not yet implemented on web.',
  );

  // ===== Style loading =====

  @override
  Future<void> loadStyleURI(String styleURI) async {
    _map.setStyle(styleURI.toJS);
  }

  @override
  Future<void> loadStyleJson(String styleJson) =>
      throw UnimplementedError('loadStyleJson is not yet implemented on web.');

  // ===== Camera =====

  @override
  Future<CameraState> getCameraState() async {
    final center = _map.getCenter();
    return CameraState(
      center: Point(coordinates: Position(center.lng, center.lat)),
      padding: MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
      zoom: _map.getZoom(),
      bearing: _map.getBearing(),
      pitch: _map.getPitch(),
    );
  }

  @override
  Future<void> setCamera(CameraOptions cameraOptions) async => _map.jumpTo(
    JSCameraOptions()
      ..withCenter(cameraOptions.center?.toJSLngLat())
      ..withZoom(cameraOptions.zoom)
      ..withBearing(cameraOptions.bearing)
      ..withPitch(cameraOptions.pitch)
      ..withPadding(cameraOptions.padding?.toJSPadding())
      ..withAnchor(
        cameraOptions.anchor != null
            ? _map.unproject(cameraOptions.anchor!.toJSScreenPoint())
            : null,
      ),
  );

  // ===== Camera convenience =====

  @override
  Future<CameraOptions> cameraForCoordinatesPadding(
    List<Point> coordinates,
    CameraOptions camera,
    MbxEdgeInsets? coordinatesPadding,
    double? maxZoom,
    ScreenCoordinate? offset,
  ) async {
    final result = _map.cameraForBounds(
      coordinates.toJSLngLatBounds(),
      JSCameraForBoundsOptions()
        ..withPadding(coordinatesPadding?.toJSPadding())
        ..withBearing(camera.bearing)
        ..withPitch(camera.pitch)
        ..withMaxZoom(maxZoom)
        ..withOffset(offset?.toJSScreenPoint()),
    );
    return CameraOptions(
      center: result?.center?.toPoint(),
      zoom: result?.zoom,
      bearing: result?.bearing,
      pitch: result?.pitch,
      padding: coordinatesPadding,
    );
  }

  @override
  Future<CameraOptions> cameraForCoordinateBounds(
    CoordinateBounds bounds,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
    double? maxZoom,
    ScreenCoordinate? offset,
  ) async {
    final result = _map.cameraForBounds(
      bounds.toJSLngLatBounds(),
      JSCameraForBoundsOptions()
        ..withPadding(padding.toJSPadding())
        ..withBearing(bearing)
        ..withPitch(pitch)
        ..withMaxZoom(maxZoom)
        ..withOffset(offset?.toJSScreenPoint()),
    );
    return CameraOptions(
      center: result?.center?.toPoint(),
      zoom: result?.zoom,
      bearing: result?.bearing,
      pitch: result?.pitch,
    );
  }

  @override
  Future<CameraOptions> cameraForCoordinates(
    List<Point> coordinates,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
  ) async {
    final result = _map.cameraForBounds(
      coordinates.toJSLngLatBounds(),
      JSCameraForBoundsOptions()
        ..withPadding(padding.toJSPadding())
        ..withBearing(bearing)
        ..withPitch(pitch),
    );
    return CameraOptions(
      center: result?.center?.toPoint(),
      zoom: result?.zoom,
      bearing: result?.bearing,
      pitch: result?.pitch,
    );
  }

  @override
  Future<CameraOptions> cameraForCoordinatesCameraOptions(
    List<Point> coordinates,
    CameraOptions camera,
    ScreenBox box,
  ) async {
    final container = _map.getContainer();
    final padTop = box.min.y;
    final padLeft = box.min.x;
    final padRight = container.clientWidth - box.max.x;
    final padBottom = container.clientHeight - box.max.y;
    final result = _map.cameraForBounds(
      coordinates.toJSLngLatBounds(),
      JSCameraForBoundsOptions()
        ..padding = JSPadding(
          top: padTop,
          left: padLeft,
          right: padRight,
          bottom: padBottom,
        )
        ..withBearing(camera.bearing)
        ..withPitch(camera.pitch)
        ..withMaxZoom(camera.zoom),
    );
    return CameraOptions(
      center: result?.center?.toPoint(),
      zoom: result?.zoom,
      bearing: result?.bearing,
      pitch: result?.pitch,
      padding: MbxEdgeInsets(
        top: padTop,
        left: padLeft,
        right: padRight,
        bottom: padBottom,
      ),
    );
  }

  @override
  Future<CameraOptions> cameraForGeometry(
    Map<String?, Object?> geometry,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
  ) async {
    final geo = GeometryObject.deserialize(geometry.cast<String, dynamic>());
    final result = _map.cameraForBounds(
      bbox(geo).toJSLngLatBounds(),
      JSCameraForBoundsOptions()
        ..withPadding(padding.toJSPadding())
        ..withBearing(bearing)
        ..withPitch(pitch),
    );
    return CameraOptions(
      center: result?.center?.toPoint(),
      zoom: result?.zoom,
      bearing: result?.bearing,
      pitch: result?.pitch,
    );
  }

  @override
  Future<CoordinateBounds> coordinateBoundsForCamera(CameraOptions camera) =>
      throw _ni('coordinateBoundsForCamera');

  @override
  Future<CoordinateBounds> coordinateBoundsForCameraUnwrapped(
    CameraOptions camera,
  ) => throw _ni('coordinateBoundsForCameraUnwrapped');

  @override
  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCamera(
    CameraOptions camera,
  ) => throw _ni('coordinateBoundsZoomForCamera');

  @override
  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCameraUnwrapped(
    CameraOptions camera,
  ) => throw _ni('coordinateBoundsZoomForCameraUnwrapped');

  // ===== Camera bounds =====

  @override
  Future<void> setBounds(CameraBoundsOptions options) async {
    final bounds = options.bounds;
    if (bounds != null) {
      _map.setMaxBounds(
        bounds.infiniteBounds
            ? null
            : JSLngLatBounds(
                bounds.southwest.toJSLngLat(),
                bounds.northeast.toJSLngLat(),
              ),
      );
    }
    if (options.minZoom != null) _map.setMinZoom(options.minZoom);
    if (options.maxZoom != null) _map.setMaxZoom(options.maxZoom);
    if (options.minPitch != null) _map.setMinPitch(options.minPitch);
    if (options.maxPitch != null) _map.setMaxPitch(options.maxPitch);
  }

  @override
  Future<CameraBounds> getBounds() async {
    final maxBounds = _map.getMaxBounds();
    final CoordinateBounds coordinateBounds;
    if (maxBounds == null) {
      coordinateBounds = CoordinateBounds(
        southwest: Point(coordinates: Position(-180, -90)),
        northeast: Point(coordinates: Position(180, 90)),
        infiniteBounds: true,
      );
    } else {
      final sw = maxBounds.getSouthWest();
      final ne = maxBounds.getNorthEast();
      coordinateBounds = CoordinateBounds(
        southwest: Point(coordinates: Position(sw.lng, sw.lat)),
        northeast: Point(coordinates: Position(ne.lng, ne.lat)),
        infiniteBounds: false,
      );
    }
    return CameraBounds(
      bounds: coordinateBounds,
      maxZoom: _map.getMaxZoom(),
      minZoom: _map.getMinZoom(),
      maxPitch: _map.getMaxPitch(),
      minPitch: _map.getMinPitch(),
    );
  }

  // ===== Animation =====

  @override
  Future<void> easeTo(
    CameraOptions cameraOptions,
    MapAnimationOptions? mapAnimationOptions,
  ) async => _map.easeTo(
    JSCameraOptions()
      ..essential = true
      ..withCenter(cameraOptions.center?.toJSLngLat())
      ..withZoom(cameraOptions.zoom)
      ..withBearing(cameraOptions.bearing)
      ..withPitch(cameraOptions.pitch)
      ..withPadding(cameraOptions.padding?.toJSPadding())
      ..withAnchor(
        cameraOptions.anchor != null
            ? _map.unproject(cameraOptions.anchor!.toJSScreenPoint())
            : null,
      )
      ..withDurationMs(mapAnimationOptions?.duration),
  );

  @override
  Future<void> flyTo(
    CameraOptions cameraOptions,
    MapAnimationOptions? mapAnimationOptions,
  ) async => _map.flyTo(
    JSCameraOptions()
      ..essential = true
      ..withCenter(cameraOptions.center?.toJSLngLat())
      ..withZoom(cameraOptions.zoom)
      ..withBearing(cameraOptions.bearing)
      ..withPitch(cameraOptions.pitch)
      ..withPadding(cameraOptions.padding?.toJSPadding())
      ..withAnchor(
        cameraOptions.anchor != null
            ? _map.unproject(cameraOptions.anchor!.toJSScreenPoint())
            : null,
      )
      ..withDurationMs(mapAnimationOptions?.duration),
  );

  @override
  Future<void> pitchBy(
    double pitch,
    MapAnimationOptions? mapAnimationOptions,
  ) async => _map.easeTo(
    JSCameraOptions()
      ..essential = true
      ..pitch = _map.getPitch() + pitch
      ..withDurationMs(mapAnimationOptions?.duration),
  );

  @override
  Future<void> scaleBy(
    double amount,
    ScreenCoordinate? anchor,
    MapAnimationOptions? mapAnimationOptions,
  ) async => _map.zoomTo(
    _map.getZoom() + math.log(amount) / math.ln2,
    JSCameraOptions()
      ..essential = true
      ..withAnchor(
        anchor != null ? _map.unproject(anchor.toJSScreenPoint()) : null,
      )
      ..withDurationMs(mapAnimationOptions?.duration),
  );

  @override
  Future<void> moveBy(
    ScreenCoordinate screenCoordinate,
    MapAnimationOptions? mapAnimationOptions,
  ) async => _map.panBy(
    JSScreenPoint(screenCoordinate.x, screenCoordinate.y),
    JSCameraOptions()
      ..essential = true
      ..withDurationMs(mapAnimationOptions?.duration),
  );

  @override
  Future<void> rotateBy(
    ScreenCoordinate first,
    ScreenCoordinate second,
    MapAnimationOptions? mapAnimationOptions,
  ) async {
    final lngLat1 = _map.unproject(JSScreenPoint(first.x, first.y));
    final lngLat2 = _map.unproject(JSScreenPoint(second.x, second.y));
    final p1 = Point(coordinates: Position(lngLat1.lng, lngLat1.lat));
    final p2 = Point(coordinates: Position(lngLat2.lng, lngLat2.lat));
    _map.rotateTo(
      bearing(p1, p2).toDouble(),
      JSCameraOptions()
        ..essential = true
        ..withDurationMs(mapAnimationOptions?.duration),
    );
  }

  @override
  Future<void> cancelCameraAnimation() async => _map.stop();

  // ===== Coordinate / pixel conversion =====

  @override
  Future<ScreenCoordinate> pixelForCoordinate(Point coordinate) async {
    final point = _map.project(coordinate.toJSLngLat());
    return ScreenCoordinate(x: point.x, y: point.y);
  }

  @override
  Future<Point> coordinateForPixel(ScreenCoordinate pixel) async {
    final lngLat = _map.unproject(JSScreenPoint(pixel.x, pixel.y));
    return Point(coordinates: Position(lngLat.lng, lngLat.lat));
  }

  @override
  Future<List<ScreenCoordinate>> pixelsForCoordinates(
    List<Point> coordinates,
  ) async => [for (final c in coordinates) await pixelForCoordinate(c)];

  @override
  Future<List<Point>> coordinatesForPixels(
    List<ScreenCoordinate> pixels,
  ) async => [for (final p in pixels) await coordinateForPixel(p)];

  // ===== Map state =====

  @override
  Future<Size> getSize() async {
    final container = _map.getContainer();
    return Size(
      width: container.clientWidth.toDouble(),
      height: container.clientHeight.toDouble(),
    );
  }

  @override
  Future<void> triggerRepaint() async => _map.triggerRepaint();

  @override
  Future<double?> getElevation(Point coordinate) async =>
      _map.queryTerrainElevation(coordinate.toJSLngLat(), null);

  @override
  Future<void> reduceMemoryUse() => throw _ni('reduceMemoryUse');

  @override
  Future<void> setTileCacheBudget(
    TileCacheBudgetInMegabytes? tileCacheBudgetInMegabytes,
    TileCacheBudgetInTiles? tileCacheBudgetInTiles,
  ) => throw _ni('setTileCacheBudget');

  @override
  Future<void> clearData() {
    final completer = Completer<void>();

    clearStorage(
      ([JSAny? error]) {
        if (error != null) {
          completer.completeError(error);
        } else {
          completer.complete();
        }
      }.toJS,
    );
    return completer.future;
  }

  @override
  Future<MapOptions> getMapOptions() => throw _ni('getMapOptions');

  @override
  Future<Uint8List> snapshot() => throw _ni('snapshot');

  // ===== Gesture / animation flags =====

  @override
  Future<void> setGestureInProgress(bool inProgress) =>
      throw _ni('setGestureInProgress');

  @override
  Future<bool> isGestureInProgress() => throw _ni('isGestureInProgress');

  @override
  Future<void> setUserAnimationInProgress(bool inProgress) =>
      throw _ni('setUserAnimationInProgress');

  @override
  Future<bool> isUserAnimationInProgress() =>
      throw _ni('isUserAnimationInProgress');

  @override
  Future<void> setPrefetchZoomDelta(int delta) =>
      throw _ni('setPrefetchZoomDelta');

  @override
  Future<int> getPrefetchZoomDelta() => throw _ni('getPrefetchZoomDelta');

  @override
  Future<void> dispatch(
    String gesture,
    ScreenCoordinate screenCoordinate,
  ) async {
    final eventType = switch (gesture) {
      'click' => 'click',
      'drag' => 'drag',
      'dragBegin' => 'dragstart',
      'dragEnd' => 'dragend',
      _ => throw ArgumentError.value(gesture, 'gesture', 'Invalid gesture'),
    };
    final point = JSScreenPoint(screenCoordinate.x, screenCoordinate.y);
    final lngLat = _map.unproject(point);
    _map.fire(
      eventType,
      {'point': point, 'lngLat': lngLat}.jsify() as JSObject,
    );
  }

  // ===== Snapshotter / glyphs =====

  @override
  Future<void> setSnapshotLegacyMode(bool enabled) =>
      throw _ni('setSnapshotLegacyMode');

  @override
  Future<String> styleGlyphURL() => throw _ni('styleGlyphURL');

  @override
  Future<void> setStyleGlyphURL(String glyphURL) =>
      throw _ni('setStyleGlyphURL');

  // ===== Orientation =====

  @override
  Future<void> setNorthOrientation(NorthOrientation orientation) =>
      throw _ni('setNorthOrientation');

  @override
  Future<void> setConstrainMode(ConstrainMode mode) =>
      throw _ni('setConstrainMode');

  @override
  Future<void> setViewportMode(ViewportMode mode) =>
      throw _ni('setViewportMode');

  // ===== Interactions =====

  late final _interactionHandler = InteractionHandler();

  @override
  void addInteraction<T extends TypedFeaturesetFeature<FeaturesetDescriptor>>(
    TypedInteraction<T> interaction, {
    String? interactionID,
  }) {
    final id = interactionID ?? UniqueKey().toString();
    final filter = interaction.filter;

    final handler = ((JSInteractionEvent event) => _interactionHandler(
      interaction,
      event,
    )).toJS;

    _map.addInteraction(
      id,
      JSInteraction(
        type: interaction.interactionType.jsInteractionType,
        target: interaction.featuresetDescriptor?.toJSTargetDescriptor(),
        filter: filter == null ? null : jsonDecode(filter).jsify() as JSObject?,
        handler: handler,
      ),
    );
  }

  @override
  void removeInteraction(String interactionID) =>
      _map.removeInteraction(interactionID);

  // ===== Feature queries =====

  @override
  Future<List<QueriedRenderedFeature?>> queryRenderedFeatures(
    RenderedQueryGeometry geometry,
    RenderedQueryOptions options,
  ) async {
    final layerIds = options.layerIds?.nonNulls.toList();
    final filter = options.filter?.trim();
    final jsOpts = JSQueryRenderedFeaturesOptions(
      layers: (layerIds != null && layerIds.isNotEmpty)
          ? layerIds.map((e) => e.toJS).toList().toJS
          : null,
      filter: (filter != null && filter.isNotEmpty)
          ? FilterSpecification.fromJson(filter)
          : null,
    );

    return _map
        .queryRenderedFeatures(geometry.toJS(), jsOpts)
        .toDart
        .map(
          (f) => QueriedRenderedFeature(
            queriedFeature: f.toQueriedFeature(
              source: f.source,
              sourceLayer: f.sourceLayer,
            ),
            layers: f.layer != null ? [f.layer!.id] : [],
          ),
        )
        .toList();
  }

  @override
  Future<List<QueriedSourceFeature?>> querySourceFeatures(
    String sourceId,
    SourceQueryOptions options,
  ) async {
    final sourceLayerIds = options.sourceLayerIds?.nonNulls.toList();
    final layersToQuery = (sourceLayerIds == null || sourceLayerIds.isEmpty)
        ? <String?>[null]
        : sourceLayerIds.map<String?>((e) => e).toList();
    final filter = options.filter.trim();
    final jsFilter = filter.isNotEmpty
        ? FilterSpecification.fromJson(filter)
        : null;

    final results = <QueriedSourceFeature?>[];
    for (final layerId in layersToQuery) {
      final jsOpts = JSQuerySourceFeaturesOptions(
        sourceLayer: layerId,
        filter: jsFilter,
      );
      results.addAll(
        _map
            .querySourceFeatures(sourceId, jsOpts)
            .toDart
            .map(
              (f) => QueriedSourceFeature(
                queriedFeature: f.toQueriedFeature(
                  source: sourceId,
                  sourceLayer: layerId,
                ),
              ),
            ),
      );
    }
    return results;
  }

  @override
  Future<FeatureExtensionValue> getGeoJsonClusterLeaves(
    String sourceIdentifier,
    Map<String?, Object?> cluster,
    int? limit,
    int? offset,
  ) => throw _ni('getGeoJsonClusterLeaves');

  @override
  Future<FeatureExtensionValue> getGeoJsonClusterChildren(
    String sourceIdentifier,
    Map<String?, Object?> cluster,
  ) => throw _ni('getGeoJsonClusterChildren');

  @override
  Future<FeatureExtensionValue> getGeoJsonClusterExpansionZoom(
    String sourceIdentifier,
    Map<String?, Object?> cluster,
  ) => throw _ni('getGeoJsonClusterExpansionZoom');

  @override
  Future<List<FeaturesetFeature>> queryRenderedFeaturesForFeatureset({
    required FeaturesetDescriptor featureset,
    RenderedQueryGeometry? geometry,
    String? filter,
  }) => throw _ni('queryRenderedFeaturesForFeatureset');

  // ===== Source-feature state (pre-Featureset shapes) =====

  @override
  Future<void> setFeatureState(
    String sourceId,
    String? sourceLayerId,
    String featureId,
    String state,
  ) async => _map.setFeatureState(
    JSFeatureSelector(
      source: sourceId,
      sourceLayer: sourceLayerId,
      id: featureId,
    ),
    JSDictionary<String, Object?>.fromJson(state),
  );

  @override
  Future<String> getFeatureState(
    String sourceId,
    String? sourceLayerId,
    String featureId,
  ) async => json.encode(
    _map
            .getFeatureState(
              JSFeatureSelector(
                source: sourceId,
                sourceLayer: sourceLayerId,
                id: featureId,
              ),
            )
            ?.toDart() ??
        <String, Object?>{},
  );

  @override
  Future<void> removeFeatureState(
    String sourceId,
    String? sourceLayerId,
    String featureId,
    String? stateKey,
  ) async => _map.removeFeatureState(
    JSFeatureSelector(
      source: sourceId,
      sourceLayer: sourceLayerId,
      id: featureId,
    ),
    stateKey,
  );

  // ===== Featureset state =====

  @override
  Future<void> setFeatureStateForFeaturesetDescriptor(
    FeaturesetDescriptor featureset,
    FeaturesetFeatureId featureId,
    FeatureState state,
  ) async => _map.setFeatureState(
    featureId.toJSTargetFeature(featureset),
    JSDictionary<String, Object?>.fromDart(state.map),
  );

  @override
  Future<void> setFeatureStateForFeaturesetFeature(
    FeaturesetFeature feature,
    FeatureState state,
  ) async => _map.setFeatureState(
    feature.toJSTargetFeature(),
    JSDictionary<String, Object?>.fromDart(state.map),
  );

  @override
  Future<Map<String, Object?>> getFeatureStateForFeaturesetDescriptor(
    FeaturesetDescriptor featureset,
    FeaturesetFeatureId featureId,
  ) async =>
      _map.getFeatureState(featureId.toJSTargetFeature(featureset))?.toDart() ??
      <String, Object?>{};

  @override
  Future<Map<String, Object?>> getFeatureStateForFeaturesetFeature(
    FeaturesetFeature feature,
  ) async =>
      _map.getFeatureState(feature.toJSTargetFeature())?.toDart() ??
      <String, Object?>{};

  @override
  Future<void> removeFeatureStateForFeaturesetDescriptor({
    required FeaturesetDescriptor featureset,
    required FeaturesetFeatureId featureId,
    String? stateKey,
  }) async => _map.removeFeatureState(
    featureId.toJSTargetFeature(featureset),
    stateKey,
  );

  @override
  Future<void> removeFeatureStateForFeaturesetFeature({
    required FeaturesetFeature feature,
    String? stateKey,
  }) async => _map.removeFeatureState(feature.toJSTargetFeature(), stateKey);

  @override
  Future<void> resetFeatureStatesForFeatureset(
    FeaturesetDescriptor featureset,
  ) => throw UnimplementedError(
    'resetFeatureStatesForFeatureset is not yet implemented on web.',
  );

  // ===== Debug options =====

  @override
  Future<List<MapWidgetDebugOptions>> getDebugOptions() =>
      throw UnsupportedError('MapWidgetDebugOptions is not supported on web.');

  @override
  Future<void> setDebugOptions(List<MapWidgetDebugOptions> options) =>
      throw UnsupportedError('MapWidgetDebugOptions is not supported on web.');

  // ===== Lifecycle =====

  @override
  void dispose() {
    // The JSMap instance is owned by `_MapWebWidgetState` and torn down in
    // its own `dispose()` (see map_widget.dart).
    _disposables.dispose();
  }
}

UnimplementedError _ni(String method) =>
    UnimplementedError('MapboxMap.$method is not yet implemented on web.');
