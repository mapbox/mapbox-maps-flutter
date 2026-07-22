import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart' show Position;

/// Showcases the `ModelSource` API: a single source can hold a collection of
/// 3D models, each with its own `uri`, position, orientation, scale (via
/// `featureProperties` plus a data-driven layer expression), and static
/// `nodeOverrides`/`materialOverrides` - without needing a separate GeoJSON
/// source or `addStyleModel` call per model. Renders several instances of the
/// same car model side by side, each demonstrating one property, plus a
/// differently-shaped model (the Buggy) to show a source can mix models with
/// entirely different `uri`s too.
///
/// A second source/layer pair demonstrates `nodeOverrideNames`/
/// `materialOverrideNames`: a whitelist of node/material names a *layer*
/// paint property can target per model instance (via a `match` expression on
/// `["get", "part"]`), with the actual values supplied dynamically through
/// `setFeatureState` instead of baked into the source. Unlike `nodeOverrides`/
/// `materialOverrides` above, `setFeatureState` merges into existing state and
/// is cheap enough to call repeatedly, so it's animated continuously here
/// rather than set once.
class ModelSourceExample extends StatefulWidget {
  const ModelSourceExample({super.key});

  @override
  State<StatefulWidget> createState() => _ModelSourceExampleState();
}

class _ModelSourceExampleState extends State<ModelSourceExample> {
  MapboxMap? mapboxMap;
  Timer? _interactiveAnimationTimer;

  static const _sourceId = 'model-source';
  static const _layerId = 'model-layer';

  static const _interactiveSourceId = 'model-source-interactive';
  static const _interactiveLayerId = 'model-layer-interactive';
  static const _interactiveCarId = 'car-interactive';

  static const _carUri =
      'https://docs.mapbox.com/mapbox-gl-js/assets/ego_car.glb';
  // jsDelivr, not GitHub's raw content host: raw.githubusercontent.com/
  // .../raw/... sends an empty (invalid) Access-Control-Allow-Origin header,
  // which browsers reject outright, so the fetch never gets past CORS on
  // web (native HTTP clients aren't subject to CORS and never hit this).
  // Since a `ModelSource` only renders once every one of its models has
  // loaded (`ModelSource.loaded()` in gl-js requires it, and `drawModels()`
  // skips the whole source's draw call otherwise), one blocked model here
  // would otherwise blank out every sibling model in this source too, not
  // just the Buggy. jsDelivr mirrors the same pinned commit with a proper
  // `Access-Control-Allow-Origin: *`.
  static const _buggyUri =
      'https://cdn.jsdelivr.net/gh/KhronosGroup/glTF-Sample-Models@d7a3cc8e51d7c573771ae77a57f16b0662a905c6/2.0/Buggy/glTF/Buggy.gltf';

  // `ModelSourceModel` has no `scale` field of its own (unlike position/orientation);
  // scale is a data-driven `ModelLayer` paint property, so per-model scale is set here
  // via `featureProperties` and read back with a `["get", ...]` expression on the layer.
  static const _modelScaleKey = 'model-scale';

  final centerPosition = Position(24.944016, 60.171193);

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      viewport: CameraViewportState(
        center: Point(coordinates: centerPosition),
        zoom: 18.6,
        bearing: 15,
        pitch: 55,
      ),
      key: const ValueKey<String>('mapWidget'),
      onMapCreated: _onMapCreated,
      onStyleLoadedListener: _onStyleLoaded,
    );
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    await _addStaticModelLayer();
    await _addInteractiveModelLayer();
  }

  @override
  void dispose() {
    _interactiveAnimationTimer?.cancel();
    super.dispose();
  }

  Future<void> _addStaticModelLayer() async {
    final mapboxMap = this.mapboxMap;
    if (mapboxMap == null) {
      throw Exception('MapboxMap is not ready yet');
    }

    await mapboxMap.style.addSource(
      ModelSource(
        id: _sourceId,
        models: [
          ModelSourceModel(
            id: 'car-default',
            uri: _carUri,
            position: _position(-0.00018, 0),
            orientation: [0.0, 0.0, 90.0],
            featureProperties: {
              _modelScaleKey: [1.0, 1.0, 1.0],
            },
          ),
          ModelSourceModel(
            id: 'car-tinted',
            uri: _carUri,
            position: _position(-0.00006, 0),
            orientation: [0.0, 0.0, 90.0],
            featureProperties: {
              _modelScaleKey: [1.0, 1.0, 1.0],
            },
            materialOverrides: [
              ModelMaterialOverride(
                name: 'body',
                modelColor: Colors.deepPurpleAccent.value,
                modelColorMixIntensity: 1.0,
              ),
            ],
          ),
          ModelSourceModel(
            id: 'car-open',
            uri: _carUri,
            position: _position(0.00006, 0),
            orientation: [0.0, 0.0, 90.0],
            featureProperties: {
              _modelScaleKey: [1.0, 1.0, 1.0],
            },
            nodeOverrides: [
              ModelNodeOverride(name: 'hood', orientation: [45.0, 0.0, 0.0]),
              ModelNodeOverride(
                name: 'doors_front-left',
                orientation: [0.0, -80.0, 0.0],
              ),
              ModelNodeOverride(
                name: 'doors_front-right',
                orientation: [0.0, 80.0, 0.0],
              ),
            ],
          ),
          ModelSourceModel(
            id: 'car-scaled',
            uri: _carUri,
            position: _position(0.00018, 0),
            orientation: [0.0, 0.0, 90.0],
            featureProperties: {
              _modelScaleKey: [2.0, 2.0, 2.0],
            },
          ),
          ModelSourceModel(
            id: 'buggy',
            uri: _buggyUri,
            position: _position(0, 0.00015),
            orientation: [0.0, 0.0, 90.0],
            featureProperties: {
              _modelScaleKey: [0.05, 0.05, 0.05],
            },
          ),
        ],
      ),
    );

    await mapboxMap.style.addLayer(
      ModelLayer(
        id: _layerId,
        sourceId: _sourceId,
        modelScaleExpression: [
          'get',
          _modelScaleKey,
        ], // per-model scale, driven by featureProperties above
      ),
    );
  }

  /// A position offset (in degrees) from [centerPosition], as the
  /// `[lng, lat]` array `ModelSourceModel.position` expects.
  List<double> _position(double lngDelta, double latDelta) => [
    centerPosition.lng.toDouble() + lngDelta,
    centerPosition.lat.toDouble() + latDelta,
  ];

  Future<void> _addInteractiveModelLayer() async {
    final mapboxMap = this.mapboxMap;
    if (mapboxMap == null) {
      return;
    }

    await mapboxMap.style.addSource(
      ModelSource(
        id: _interactiveSourceId,
        batched: false,
        models: [
          ModelSourceModel(
            id: _interactiveCarId,
            uri: _carUri,
            position: _position(0, -0.0002),
            orientation: [0.0, 0.0, 0.0],
            nodeOverrideNames: [
              'hood',
              'trunk',
              'doors_front-left',
              'doors_front-right',
            ],
            materialOverrideNames: ['body'],
          ),
        ],
      ),
    );

    await mapboxMap.style.addLayer(
      ModelLayer(
        id: _interactiveLayerId,
        sourceId: _interactiveSourceId,
        modelType: ModelType.LOCATION_INDICATOR,
        modelScale: [4.0, 4.0, 4.0],
        modelColorExpression: [
          'match',
          ['get', 'part'],
          'body',
          ['feature-state', 'vehicle-color'],
          '#ffffff',
        ],
        modelColorMixIntensityExpression: [
          'match',
          ['get', 'part'],
          'body',
          1.0,
          0.0,
        ],
        modelRotationExpression: [
          'match',
          ['get', 'part'],
          'hood',
          ['feature-state', 'hood'],
          'trunk',
          ['feature-state', 'trunk'],
          'doors_front-left',
          ['feature-state', 'doors-front-left'],
          'doors_front-right',
          ['feature-state', 'doors-front-right'],
          [0.0, 0.0, 0.0],
        ],
      ),
    );

    await mapboxMap.setFeatureState(
      _interactiveSourceId,
      null,
      _interactiveCarId,
      json.encode({'vehicle-color': '#1db9c3'}),
    );

    _startInteractiveAnimation();
  }

  void _startInteractiveAnimation() {
    const tick = Duration(milliseconds: 50);
    var elapsedMs = 0;
    _interactiveAnimationTimer = Timer.periodic(tick, (timer) {
      final mapboxMap = this.mapboxMap;
      if (mapboxMap == null) {
        return;
      }
      elapsedMs += tick.inMilliseconds;
      final swing = (sin(elapsedMs / 1200) + 1) / 2;
      mapboxMap.setFeatureState(
        _interactiveSourceId,
        null,
        _interactiveCarId,
        json.encode({
          'hood': [45.0 * swing, 0.0, 0.0],
          'trunk': [-60.0 * swing, 0.0, 0.0],
          'doors-front-left': [0.0, -80.0 * swing, 0.0],
          'doors-front-right': [0.0, 80.0 * swing, 0.0],
        }),
      );
    });
  }
}
