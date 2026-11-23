import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// Showcases the two ways to put a 3D model on the map: [ModelLayer] paired
/// with a plain GeoJSON source, and [ModelSource], which carries its models'
/// positions itself.
///
/// One [MapWidget] persists across both scenes: a scene switch flies the
/// shared camera instead of remounting the map.
///
/// - **Model layer**: a Buggy and a car are each registered once with
///   `addStyleModel`, then a GeoJSON `Feature` gives every instance a place
///   on the map and a [ModelLayer] renders them. Placing a second instance
///   of the same model means adding another feature to the source — the
///   model itself is uploaded only once. Tap or long-tap either model to log
///   the interaction.
/// - **Model source**: a single [ModelSource] carries the car's `uri`,
///   position and orientation directly, with no separate GeoJSON source or
///   `addStyleModel` call. It also whitelists node/material names
///   (`nodeOverrideNames`/`materialOverrideNames`) a *layer* paint property
///   can target per model instance, via a `match` expression on
///   `["get", "part"]` — with the actual values supplied dynamically
///   through `setFeatureState`, animated continuously here. Dragging any
///   slider (or the switch) hands control from the animation to the
///   sliders instead.
class ModelComparisonExample extends StatefulWidget {
  const ModelComparisonExample({super.key});

  @override
  State<ModelComparisonExample> createState() => _ModelComparisonExampleState();
}

enum _Scene { modelLayer, modelSource }

const _scenes = [
  Scene(
    id: 'modelSource',
    title: 'Model source',
    subtitle: 'Animate a car with feature-state',
    icon: Icons.view_in_ar,
  ),
  Scene(
    id: 'modelLayer',
    title: 'Model layer',
    subtitle: 'addStyleModel + GeoJSON features',
    icon: Icons.view_in_ar_outlined,
  ),
];

class _ModelComparisonExampleState extends State<ModelComparisonExample> {
  MapboxMap? _mapboxMap;
  final _viewportController = ViewportController();
  Timer? _animationTimer;

  var _scene = _Scene.modelSource;

  // jsDelivr, not GitHub: raw.githubusercontent.com sends an invalid
  // Access-Control-Allow-Origin header, so a browser blocks the fetch.
  static const _buggyUri =
      'https://cdn.jsdelivr.net/gh/KhronosGroup/glTF-Sample-Models@d7a3cc8e51d7c573771ae77a57f16b0662a905c6/2.0/Buggy/glTF/Buggy.gltf';

  // `addStyleModel` resolves a bundled asset itself, but a `ModelSource`
  // fetches its `uri` directly, so it needs a URL every platform can load.
  static const _layerCarUri = 'asset://assets/sportcar.glb';
  static const _sourceCarUri =
      'https://docs.mapbox.com/mapbox-gl-js/assets/ego_car.glb';

  // The two scenes sit ~120 m apart, each with its own camera.
  final _sourceEnd = Position(24.944053, 60.170743);

  // Bearing from one scene to the other, so the models face each other.
  static const _bearingSourceToLayer = 357.77;

  final _modelLayerCamera = CameraViewportState(
    center: Point(coordinates: Position(24.943905127943538, 60.17171072340997)),
    zoom: 19.02,
    bearing: 0,
    pitch: 50.5,
  );
  final _modelSourceCamera = CameraViewportState(
    center: Point(coordinates: Position(24.944052888912722, 60.1707366686787)),
    zoom: 19.87,
    bearing: 177.77,
    pitch: 71.5,
  );

  // Model layer scene: two features on one GeoJSON source.
  final _layerBuggyPosition = Position(24.944086, 60.171703);
  final _layerCarPosition = Position(24.943714, 60.171695);

  static const _sourceId = 'modelSourceScene';
  static const _layerId = 'modelSourceLayer';
  static const _carId = 'source-car';
  static const _buggyLayerId = 'modelLayer-buggy';
  static const _carLayerId = 'modelLayer-car';

  final List<String> _events = [];
  static const _buggyScale = 0.05;

  int _vehicleColor = 0xFF1DB9C3;

  /// Per-part openness in `0..1`, mapped to a rotation by [_MovingPart.rotation].
  /// Written by the animation while it runs, and by the sliders otherwise.
  final Map<_MovingPart, double> _openness = {
    for (final part in _MovingPart.values) part: 0.0,
  };

  bool _animate = true;
  int _animationElapsedMs = 0;

  Future<void> _onStyleLoaded(StyleLoadedEventData _) async {
    await _addModelLayerScene();
    await _addModelSourceScene();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
    _addInteractions(mapboxMap);
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  void _selectScene(String id) {
    setState(() => _scene = _Scene.values.firstWhere((s) => s.name == id));
    _flyToScene();
  }

  /// Flies the shared camera to the selected scene.
  ///
  /// Goes through [_viewportController], because [MapWidget] renders
  /// `controller.state` once a controller is attached.
  void _flyToScene() {
    final camera = switch (_scene) {
      _Scene.modelLayer => _modelLayerCamera,
      _Scene.modelSource => _modelSourceCamera,
    };
    _viewportController.moveTo(
      camera,
      transition: FlyViewportTransition(
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  // -- Model layer scene: addStyleModel + a GeoJSON feature per instance --

  Future<void> _addModelLayerScene() async {
    final map = _mapboxMap;
    if (map == null) return;

    const buggyModelId = 'buggy-model-id';
    const carModelId = 'car-model-id';
    await map.addStyleModel(buggyModelId, _buggyUri);
    // Local bundled models need the Flutter asset URI resolved to a
    // platform-native path before the native SDK can load them.
    final carUri = await MapboxMapsOptions.getFlutterAssetPath(_layerCarUri);
    await map.addStyleModel(carModelId, carUri ?? _layerCarUri);

    final buggyFeature = Feature(
      // Feature IDs must be integers for the model to be recognized by the
      // Mapbox Interactions API.
      id: 1,
      geometry: Point(coordinates: _layerBuggyPosition),
      properties: {'name': 'BUGGY', 'type': 'gltf'},
    );
    final carFeature = Feature(
      id: 2,
      geometry: Point(coordinates: _layerCarPosition),
      properties: {'name': 'CAR', 'type': 'glb'},
    );
    await map.addSource(
      GeoJsonSource(id: 'layerSceneSource', data: json.encode(buggyFeature)),
    );
    await map.addSource(
      GeoJsonSource(id: 'carLayerSource', data: json.encode(carFeature)),
    );

    await map.addLayer(
      ModelLayer(id: _buggyLayerId, sourceId: 'layerSceneSource')
        ..modelId = buggyModelId
        ..modelScale = [_buggyScale, _buggyScale, _buggyScale]
        ..modelRotation = [0.0, 0.0, _bearingSourceToLayer]
        ..modelType = ModelType.COMMON_3D,
    );

    await map.addLayer(
      ModelLayer(id: _carLayerId, sourceId: 'carLayerSource')
        // The id registered with addStyleModel, not the asset URI: gl-js
        // resolves modelId against the style's model registry and renders
        // nothing for an unknown id.
        ..modelId = carModelId
        ..modelScale = [4.0, 4.0, 4.0]
        ..modelRotation = [0.0, 0.0, _bearingSourceToLayer]
        ..modelType = ModelType.COMMON_3D,
    );
  }

  // -- Model source scene: one ModelSource, no separate GeoJSON source --
  //
  // The model whitelists node and material names, and the layer targets them
  // through feature-state.

  Future<void> _addModelSourceScene() async {
    final map = _mapboxMap;
    if (map == null) return;

    await map.addSource(
      ModelSource(
        id: _sourceId,
        batched: false,
        models: [
          ModelSourceModel(
            id: _carId,
            uri: _sourceCarUri,
            position: [_sourceEnd.lng.toDouble(), _sourceEnd.lat.toDouble()],
            orientation: [0.0, 0.0, _bearingSourceToLayer],
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

    await map.addLayer(
      ModelLayer(
        id: _layerId,
        sourceId: _sourceId,
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

    await _setVehicleColor(_vehicleColor);
    _startAnimation();
  }

  Future<void> _setVehicleColor(int argb) async {
    setState(() => _vehicleColor = argb);
    final map = _mapboxMap;
    if (map == null) return;
    await map.setFeatureState(
      _sourceId,
      null,
      _carId,
      json.encode({'vehicle-color': '#${argb.toRadixString(16).substring(2)}'}),
    );
  }

  static const _animationTick = Duration(milliseconds: 50);

  /// Starts the ticker that drives every part from one swing value. The parts
  /// snap to the swing on the first tick, so a hand-moved slider rejoins it.
  void _startAnimation() {
    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(_animationTick, (_) {
      _animationElapsedMs += _animationTick.inMilliseconds;
      final swing = (sin(_animationElapsedMs / 1200) + 1) / 2;
      setState(() {
        for (final part in _MovingPart.values) {
          _openness[part] = swing;
        }
      });
      _pushPartState();
    });
  }

  void _stopAnimation() {
    _animationTimer?.cancel();
    _animationTimer = null;
  }

  void _setAnimate(bool animate) {
    if (_animate == animate) return;
    setState(() => _animate = animate);
    if (animate) {
      _startAnimation();
    } else {
      _stopAnimation();
    }
  }

  /// Moves one part by hand, and stops the animation so the next tick does
  /// not overwrite the value.
  void _setOpenness(_MovingPart part, double openness) {
    if (_animate) _setAnimate(false);
    setState(() => _openness[part] = openness);
    _pushPartState();
  }

  /// Sends the openness of every part to the layer, which reads it through
  /// `["feature-state", ...]` in its `modelRotationExpression`.
  void _pushPartState() {
    final map = _mapboxMap;
    if (map == null) return;
    map.setFeatureState(
      _sourceId,
      null,
      _carId,
      json.encode({
        for (final part in _MovingPart.values)
          part.stateKey: part.rotation(_openness[part]!),
      }),
    );
  }

  // -- Shared tap / long-tap interactions, wired to both scenes' layers --

  void _addInteractions(MapboxMap map) {
    for (final layerId in const [_buggyLayerId, _carLayerId, _layerId]) {
      _addTapInteraction(
        map,
        layerId,
        type: InteractionType.tap,
        label: 'Tap',
        interactionID: 'tap_interaction_$layerId',
      );

      // Long tap has no gl-js equivalent.
      if (kIsWeb) continue;

      _addTapInteraction(
        map,
        layerId,
        type: InteractionType.longTap,
        label: 'Long tap',
        interactionID: 'long_tap_interaction_$layerId',
      );
    }
  }

  void _addTapInteraction(
    MapboxMap map,
    String layerId, {
    required InteractionType type,
    required String label,
    required String interactionID,
  }) {
    map.addInteraction(
      TypedInteraction<TypedFeaturesetFeature<FeaturesetDescriptor>>(
        featuresetDescriptor: FeaturesetDescriptor(layerId: layerId),
        interactionType: type,
        featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
        action: (feature, _) => _logEvent(label, feature),
        radius: 100,
      ),
      interactionID: interactionID,
    );
  }

  void _logEvent(
    String kind,
    TypedFeaturesetFeature<FeaturesetDescriptor>? feature,
  ) {
    if (feature == null || !mounted) return;
    setState(() {
      final label = feature.properties['name'] ?? feature.id?.id;
      _events.insert(0, '$kind: $label');
      if (_events.length > 6) _events.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      scenes: _scenes,
      selectedSceneId: _scene.name,
      onSceneSelected: _selectScene,
      controlsTitle: _scene == _Scene.modelLayer
          ? 'Model layer'
          : 'Model source',
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('mapWidget'),
            viewport: _modelSourceCamera,
            viewportController: _viewportController,
            onStyleLoadedListener: _onStyleLoaded,
            onMapCreated: _onMapCreated,
          ),
          MapHud(
            title: kIsWeb ? 'Tap a model' : 'Tap or long tap a model',
            rows: _events.isEmpty
                ? [const MapHudRow('events', 'none yet')]
                : [for (final event in _events) MapHudRow(event, '')],
          ),
        ],
      ),
      controlsBuilder: () => switch (_scene) {
        _Scene.modelLayer => _modelLayerControls(),
        _Scene.modelSource => _modelSourceControls(),
      },
    );
  }

  List<Widget> _modelLayerControls() => [
    const Text(
      'Each model is registered once with addStyleModel; every feature on '
      'the source places another instance of it. Tap either model to log '
      'the interaction. Long tap is Android and iOS only.',
      style: TextStyle(
        fontSize: 11,
        height: 1.35,
        color: MapboxGlass.labelFaint,
      ),
    ),
  ];

  List<Widget> _modelSourceControls() => [
    ControlRow(
      label: 'Car color',
      child: ControlChoices<int>(
        options: const {
          0xFF1DB9C3: 'Teal',
          0xFFFED622: 'Yellow',
          0xFFF13219: 'Red',
        },
        value: _vehicleColor,
        onChanged: _setVehicleColor,
      ),
    ),
    ControlSwitch(
      label: 'Animate all parts',
      value: _animate,
      onChanged: _setAnimate,
    ),
    for (final part in _MovingPart.values)
      ControlSlider(
        label: part.label,
        value: _openness[part]!,
        min: 0,
        max: 1,
        fractionDigits: 2,
        onChanged: (value) => _setOpenness(part, value),
      ),
    const SizedBox(height: 4),
    const Text(
      "ModelSource carries the car's uri and position itself, with no "
      'separate GeoJSON source. Its color and hood/trunk/doors are moved '
      'through setFeatureState, either by the animation or by the sliders '
      "above — using node and material names the model whitelists, which "
      'ModelLayer has no equivalent for. Tap the car to log the '
      'interaction.',
      style: TextStyle(
        fontSize: 11,
        height: 1.35,
        color: MapboxGlass.labelFaint,
      ),
    ),
  ];
}

/// A movable node of the model-source car, with the rotation it needs to look
/// open.
enum _MovingPart {
  hood('hood', 'Hood', [45.0, 0.0, 0.0]),
  trunk('trunk', 'Trunk', [-60.0, 0.0, 0.0]),
  frontLeftDoor('doors-front-left', 'Front left door', [0.0, -80.0, 0.0]),
  frontRightDoor('doors-front-right', 'Front right door', [0.0, 80.0, 0.0]);

  const _MovingPart(this.stateKey, this.label, this._openRotation);

  /// Feature-state key the layer's `modelRotationExpression` reads for this
  /// part. It differs from the node name in the model for the doors.
  final String stateKey;
  final String label;
  final List<double> _openRotation;

  List<double> rotation(double openness) => [
    for (final degrees in _openRotation) degrees * openness,
  ];
}
