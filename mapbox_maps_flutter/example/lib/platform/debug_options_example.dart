import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../platform.dart';
import '../scene_scaffold.dart';

/// Every debug overlay the renderer can draw, grouped for the controls panel.
///
/// Options that a platform does not draw are left out of [_allOptions]
/// rather than shown as a switch that does nothing.
List<MapWidgetDebugOptions> get _allOptions => [
  MapWidgetDebugOptions.tileBorders,
  MapWidgetDebugOptions.parseStatus,
  MapWidgetDebugOptions.timestamps,
  MapWidgetDebugOptions.collision,
  MapWidgetDebugOptions.overdraw,
  if (!isWeb) ...[
    MapWidgetDebugOptions.stencilClip,
    MapWidgetDebugOptions.depthBuffer,
  ],
  MapWidgetDebugOptions.modelBounds,
  if (isAndroid || isWeb) ...[
    MapWidgetDebugOptions.terrainWireframe,
    MapWidgetDebugOptions.layers2DWireframe,
    MapWidgetDebugOptions.layers3DWireframe,
  ],
  MapWidgetDebugOptions.light,
  MapWidgetDebugOptions.camera,
  MapWidgetDebugOptions.padding,
];

extension on MapWidgetDebugOptions {
  String get label {
    switch (this) {
      case MapWidgetDebugOptions.tileBorders:
        return 'Tile borders';
      case MapWidgetDebugOptions.parseStatus:
        return 'Parse status';
      case MapWidgetDebugOptions.timestamps:
        return 'Timestamps';
      case MapWidgetDebugOptions.collision:
        return 'Collision';
      case MapWidgetDebugOptions.overdraw:
        return 'Overdraw';
      case MapWidgetDebugOptions.stencilClip:
        return 'Stencil clip';
      case MapWidgetDebugOptions.depthBuffer:
        return 'Depth buffer';
      case MapWidgetDebugOptions.modelBounds:
        return 'Model bounds';
      case MapWidgetDebugOptions.terrainWireframe:
        return 'Terrain wireframe';
      case MapWidgetDebugOptions.layers2DWireframe:
        return '2D layers wireframe';
      case MapWidgetDebugOptions.layers3DWireframe:
        return '3D layers wireframe';
      case MapWidgetDebugOptions.light:
        return 'Light';
      case MapWidgetDebugOptions.camera:
        return 'Camera';
      case MapWidgetDebugOptions.padding:
        return 'Padding';
      default:
        return 'Unknown';
    }
  }

  IconData get icon {
    switch (this) {
      case MapWidgetDebugOptions.tileBorders:
        return Icons.grid_on_outlined;
      case MapWidgetDebugOptions.parseStatus:
        return Icons.rule_folder_outlined;
      case MapWidgetDebugOptions.timestamps:
        return Icons.schedule_outlined;
      case MapWidgetDebugOptions.collision:
        return Icons.grid_view_outlined;
      case MapWidgetDebugOptions.overdraw:
        return Icons.layers_outlined;
      case MapWidgetDebugOptions.stencilClip:
        return Icons.crop_outlined;
      case MapWidgetDebugOptions.depthBuffer:
        return Icons.view_in_ar_outlined;
      case MapWidgetDebugOptions.modelBounds:
        return Icons.category_outlined;
      case MapWidgetDebugOptions.terrainWireframe:
        return Icons.terrain_outlined;
      case MapWidgetDebugOptions.layers2DWireframe:
        return Icons.filter_2_outlined;
      case MapWidgetDebugOptions.layers3DWireframe:
        return Icons.filter_3_outlined;
      case MapWidgetDebugOptions.light:
        return Icons.wb_sunny_outlined;
      case MapWidgetDebugOptions.camera:
        return Icons.videocam_outlined;
      case MapWidgetDebugOptions.padding:
        return Icons.padding_outlined;
      default:
        return Icons.help_outline;
    }
  }
}

/// Scenes that give each overlay something to draw. Each scene adds its own
/// content to the style and removes it again when the user leaves the scene.
enum _Scene {
  /// Flat streets: tile, timestamp, collision and parse status overlays.
  city('City', 'Tiles, labels and collision', Icons.location_city_outlined),

  /// Models from a GeoJSON model layer, a model source and the style's own
  /// tiled 3D models (landmarks and trees).
  models(
    '3D models',
    'Model bounds and 3D wireframes',
    Icons.view_in_ar_outlined,
  ),

  /// Steep terrain for the terrain wireframe.
  terrain('Terrain', 'Terrain wireframe', Icons.terrain_outlined);

  const _Scene(this.title, this.subtitle, this.icon);

  final String title;
  final String subtitle;
  final IconData icon;
}

/// The renderer's debug overlays, toggled live from the controls panel.
///
/// Every switch calls `setDebugOptions` with the full enabled set, so
/// overlays can be combined freely (for example tile borders with the
/// camera readout) to inspect exactly what the renderer is doing.
///
/// The scenes move the camera to content that each overlay needs: 3D models
/// from three kinds of sources, and terrain.
class DebugOptionsExample extends StatefulWidget {
  const DebugOptionsExample({super.key});

  @override
  State<DebugOptionsExample> createState() => _DebugOptionsExampleState();
}

class _DebugOptionsExampleState extends State<DebugOptionsExample> {
  MapboxMap? _mapboxMap;
  final _viewportController = ViewportController();
  var _enabled = <MapWidgetDebugOptions>{};
  var _scene = _Scene.city;
  Future<void> _sceneUpdate = Future.value();

  // Champ de Mars, Paris: the style draws the Eiffel Tower and the trees
  // around it as tiled 3D models.
  static final _modelsCenter = Position(2.2951, 48.8566);
  static final _layerCarPosition = Position(2.29545, 48.85655);
  static final _sourceCarPosition = Position(2.29475, 48.85665);

  static const _carModelId = 'debug-car-model';
  static const _carSourceId = 'debug-car-source';
  static const _carLayerId = 'debug-car-layer';
  static const _modelSourceId = 'debug-model-source';
  static const _modelSourceLayerId = 'debug-model-source-layer';
  static const _carAssetUri = 'asset://assets/sportcar.glb';
  // A model source fetches its URI directly, so it needs a URL that every
  // platform can load.
  static const _sourceCarUri =
      'https://docs.mapbox.com/mapbox-gl-js/assets/ego_car.glb';
  static const _terrainSourceId = 'debug-terrain';

  static final _cameras = {
    _Scene.city: CameraViewportState(
      center: Point(coordinates: Position(2.3417, 48.8575)),
      zoom: 14,
      pitch: 0,
      bearing: 0,
    ),
    _Scene.models: CameraViewportState(
      center: Point(coordinates: _modelsCenter),
      zoom: 17.2,
      pitch: 60,
      bearing: 320,
    ),
    _Scene.terrain: CameraViewportState(
      center: Point(coordinates: Position(7.6586, 45.9763)),
      zoom: 12.5,
      pitch: 70,
      bearing: 240,
    ),
  };

  static const _defaults = {
    MapWidgetDebugOptions.tileBorders,
    MapWidgetDebugOptions.parseStatus,
    MapWidgetDebugOptions.timestamps,
    MapWidgetDebugOptions.camera,
    MapWidgetDebugOptions.padding,
  };

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
    await mapboxMap.setDebugOptions(_defaults.toList());
    setState(() => _enabled = {..._defaults});
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData _) => _applyScene();

  void _selectScene(String id) {
    final scene = _Scene.values.firstWhere((scene) => scene.name == id);
    setState(() => _scene = scene);
    _viewportController.moveTo(
      _cameras[scene]!,
      transition: FlyViewportTransition(
        duration: const Duration(milliseconds: 1500),
      ),
    );
    _applyScene();
  }

  /// Runs scene changes one at a time, so that two changes cannot add the
  /// same source twice. Each run applies the scene selected when it starts,
  /// also after an earlier run failed.
  Future<void> _applyScene() =>
      _sceneUpdate = _sceneUpdate.catchError((Object _) {}).then((_) async {
        final scene = _scene;
        await _setModels(scene == _Scene.models);
        await _setTerrain(scene == _Scene.terrain);
      });

  /// Adds a model layer with a GeoJSON source and a model source that
  /// carries its own model, next to the style's own tiled 3D models.
  Future<void> _setModels(bool enabled) async {
    final map = _mapboxMap;
    if (map == null) return;
    if (!enabled) {
      for (final layerId in [_carLayerId, _modelSourceLayerId]) {
        if (await map.styleLayerExists(layerId)) {
          await map.removeStyleLayer(layerId);
        }
      }
      for (final sourceId in [_carSourceId, _modelSourceId]) {
        if (await map.styleSourceExists(sourceId)) {
          await map.removeStyleSource(sourceId);
        }
      }
      return;
    }
    if (await map.styleLayerExists(_carLayerId)) return;

    final carUri =
        await MapboxMapsOptions.getFlutterAssetPath(_carAssetUri) ??
        _carAssetUri;
    await map.addStyleModel(_carModelId, carUri);
    await map.addSource(
      GeoJsonSource(
        id: _carSourceId,
        data: json.encode(Point(coordinates: _layerCarPosition)),
      ),
    );
    await map.addLayer(
      ModelLayer(id: _carLayerId, sourceId: _carSourceId)
        ..modelId = _carModelId
        ..modelScale = [4.0, 4.0, 4.0]
        ..modelType = ModelType.COMMON_3D,
    );

    await map.addSource(
      ModelSource(
        id: _modelSourceId,
        batched: false,
        models: [
          ModelSourceModel(
            id: 'debug-source-car',
            uri: _sourceCarUri,
            position: [
              _sourceCarPosition.lng.toDouble(),
              _sourceCarPosition.lat.toDouble(),
            ],
            orientation: [0.0, 0.0, 90.0],
          ),
        ],
      ),
    );
    await map.addLayer(
      ModelLayer(
        id: _modelSourceLayerId,
        sourceId: _modelSourceId,
        modelScale: [4.0, 4.0, 4.0],
        modelType: ModelType.COMMON_3D,
      ),
    );
  }

  Future<void> _setTerrain(bool enabled) async {
    final map = _mapboxMap;
    if (map == null) return;
    if (enabled) {
      if (await map.styleSourceExists(_terrainSourceId)) return;
      await map.addStyleSource(
        _terrainSourceId,
        jsonEncode({
          'type': 'raster-dem',
          'url': 'mapbox://mapbox.mapbox-terrain-dem-v1',
          'tileSize': 514,
        }),
      );
      await map.setStyleTerrain(jsonEncode({'source': _terrainSourceId}));
    } else if (await map.styleSourceExists(_terrainSourceId)) {
      await map.removeStyleTerrain();
      await map.removeStyleSource(_terrainSourceId);
    }
  }

  Future<void> _toggle(MapWidgetDebugOptions option, bool value) async {
    setState(() {
      if (value) {
        _enabled.add(option);
      } else {
        _enabled.remove(option);
      }
    });
    await _mapboxMap?.setDebugOptions(_enabled.toList());
  }

  Future<void> _setAll(bool value) async {
    setState(() => _enabled = value ? _allOptions.toSet() : {});
    await _mapboxMap?.setDebugOptions(_enabled.toList());
  }

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      // The camera overlay sits in the top left corner of the map.
      centerPanels: true,
      scenes: [
        for (final scene in _Scene.values)
          Scene(
            id: scene.name,
            title: scene.title,
            subtitle: scene.subtitle,
            icon: scene.icon,
          ),
      ],
      selectedSceneId: _scene.name,
      onSceneSelected: _selectScene,
      map: MapWidget(
        key: const ValueKey('mapWidget'),
        viewport: _cameras[_Scene.city],
        viewportController: _viewportController,
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoaded,
      ),
      controlsTitle: 'Debug overlays (${_enabled.length})',
      controlsSheetSize: ControlsSheetSize.large,
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      controlsBuilder: () => [
        ControlRow(
          label: 'All overlays',
          child: Row(
            children: [
              Expanded(
                child: ControlAction(
                  label: 'Enable all',
                  icon: Icons.select_all,
                  onPressed: () => _setAll(true),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ControlAction(
                  label: 'Clear',
                  icon: Icons.clear_all,
                  onPressed: () => _setAll(false),
                ),
              ),
            ],
          ),
        ),
        for (final option in _allOptions)
          ControlSwitch(
            label: option.label,
            icon: option.icon,
            value: _enabled.contains(option),
            onChanged: _mapboxMap == null
                ? null
                : (value) => _toggle(option, value),
          ),
      ],
    );
  }
}
