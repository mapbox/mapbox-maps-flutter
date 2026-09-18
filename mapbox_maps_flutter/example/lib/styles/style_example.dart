import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// Mutates a loaded style and shows each change on the map.
///
/// Three scenes: swapping the whole style, adding and restyling a layer, and
/// lighting a 3D scene. The HUD counts what the style holds.
class StyleExample extends StatefulWidget {
  const StyleExample({super.key});

  @override
  State<StyleExample> createState() => _StyleExampleState();
}

enum _Scene { basemap, layers, lighting }

const _scenes = [
  Scene(
    id: 'basemap',
    title: 'Basemap',
    subtitle: 'Swap the style and its config',
    icon: Icons.map_outlined,
  ),
  Scene(
    id: 'layers',
    title: 'Your own layer',
    subtitle: 'Add, restyle and reorder a layer',
    icon: Icons.layers_outlined,
  ),
  Scene(
    id: 'lighting',
    title: 'Lighting',
    subtitle: '3D light, shadows and terrain',
    icon: Icons.wb_twilight,
  ),
];

/// Styles the basemap scene cycles through.
const _styles = {
  MapboxStyles.STANDARD: 'Standard',
  MapboxStyles.STANDARD_SATELLITE: 'Satellite',
  MapboxStyles.OUTDOORS: 'Outdoors',
  MapboxStyles.DARK: 'Dark',
};

class _StyleExampleState extends State<StyleExample> {
  static const _sourceId = 'style-example-source';
  static const _layerId = 'style-example-layer';
  static const _terrainSourceId = 'terrain-dem';

  MapboxMap? _mapboxMap;

  var _scene = _Scene.basemap;
  var _styleUri = MapboxStyles.STANDARD;
  var _lightPreset = 'day';
  var _layerColorName = 'Blue';
  var _layerWidth = 8.0;
  var _layerAdded = false;
  var _below = false;
  var _terrain = false;

  int _layerCount = 0;
  int _sourceCount = 0;
  var _styleSize = '—';

  void _onMapCreated(MapboxMap mapboxMap) {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
  }

  /// Re-reads what the style contains. A style swap replaces every layer, so
  /// the counts jump.
  Future<void> _refresh() async {
    final map = _mapboxMap;
    if (map == null) return;
    final layers = await map.getStyleLayers();
    final sources = await map.getStyleSources();
    final json = await map.getStyleJSON();
    if (!mounted) return;
    setState(() {
      _layerCount = layers.length;
      _sourceCount = sources.length;
      _styleSize = '${(json.length / 1024).toStringAsFixed(0)} kB';
      _layerAdded = layers.any((layer) => layer?.id == _layerId);
    });
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData _) async {
    // A new style drops everything the previous one held, so the scene's
    // additions have to be reapplied.
    setState(() => _layerAdded = false);
    if (_scene == _Scene.layers) await _addLayer();
    if (_scene == _Scene.lighting) await _applyLighting();
    await _applyLightPreset();
    await _refresh();
  }

  /// `MapWidget.styleUri` is read once, when the platform view starts, so a
  /// runtime swap must use `setStyleURI`. That fires onStyleLoaded again, and
  /// re-adds this scene's layer.
  Future<void> _setStyle(String uri) async {
    setState(() => _styleUri = uri);
    await _mapboxMap?.setStyleURI(uri);
  }

  Future<void> _applyLightPreset() async {
    // lightPreset is a Standard-style config property; other styles have no
    // such import to configure.
    if (!_styleUri.contains('standard')) return;
    await _mapboxMap?.setStyleImportConfigProperty(
      'basemap',
      'lightPreset',
      _lightPreset,
    );
  }

  /// Adds a line layer with its own source.
  Future<void> _addLayer() async {
    final map = _mapboxMap;
    if (map == null) return;
    if (!await map.styleSourceExists(_sourceId)) {
      await map.addSource(GeoJsonSource(id: _sourceId, data: _routeGeoJson));
    }
    if (!await map.styleLayerExists(_layerId)) {
      await map.addLayer(
        LineLayer(
          id: _layerId,
          sourceId: _sourceId,
          slot: _below ? 'middle' : 'top',
          lineJoin: LineJoin.ROUND,
          lineCap: LineCap.ROUND,
          lineColor: _lineColors[_layerColorName]!.toARGB32(),
          lineWidth: _layerWidth,
        ),
      );
    }
    await _refresh();
  }

  Future<void> _removeLayer() async {
    final map = _mapboxMap;
    if (map == null) return;
    await _removeLayerIfPresent(map);
    if (await map.styleSourceExists(_sourceId)) {
      await map.removeStyleSource(_sourceId);
    }
    await _refresh();
  }

  Future<void> _removeLayerIfPresent(MapboxMap map) async {
    if (await map.styleLayerExists(_layerId)) {
      await map.removeStyleLayer(_layerId);
    }
  }

  /// Writes one paint property, without rebuilding the layer.
  Future<void> _setLayerProperty(String property, Object value) async {
    final map = _mapboxMap;
    if (map == null || !await map.styleLayerExists(_layerId)) return;
    await map.setStyleLayerProperty(_layerId, property, value);
  }

  /// Moves the layer between two of Standard's slots.
  ///
  /// Standard exposes `bottom`, `middle` and `top`: `middle` sits below the
  /// buildings and labels that `top` sits above.
  ///
  /// `slot` is a root-level layer property with no setter, so a slot change
  /// removes the layer and adds it again. The source stays.
  Future<void> _setSlot(bool below) async {
    final map = _mapboxMap;
    if (map == null) return;
    setState(() => _below = below);
    await _removeLayerIfPresent(map);
    await _addLayer();
  }

  Future<void> _applyLighting() async {
    final map = _mapboxMap;
    if (map == null || kIsWeb) return;
    final directional = DirectionalLight(id: 'directional-light')
      ..intensity = 0.6
      ..direction = [210, 30]
      ..castShadows = true
      ..shadowIntensity = 1;
    final ambient = AmbientLight(id: 'ambient-light')
      ..color = Colors.white.toARGB32()
      ..intensity = 0.4;
    await map.setLights(ambient, directional);
  }

  Future<void> _setTerrain(bool enabled) async {
    final map = _mapboxMap;
    if (map == null) return;
    setState(() => _terrain = enabled);
    if (enabled) {
      if (!await map.styleSourceExists(_terrainSourceId)) {
        await map.addStyleSource(
          _terrainSourceId,
          json.encode({
            'type': 'raster-dem',
            'url': 'mapbox://mapbox.mapbox-terrain-dem-v1',
            'tileSize': 514,
          }),
        );
      }
      await map.setStyleTerrain(
        json.encode({'source': _terrainSourceId, 'exaggeration': 1.5}),
      );
    } else if (await map.styleSourceExists(_terrainSourceId)) {
      await map.removeStyleSource(_terrainSourceId);
    }
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      scenes: _scenes,
      selectedSceneId: _scene.name,
      onSceneSelected: (id) {
        setState(() => _scene = _Scene.values.firstWhere((s) => s.name == id));
        if (_scene == _Scene.layers) _addLayer();
        if (_scene == _Scene.lighting) _applyLighting();
      },
      controlsTitle: 'Style',
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('mapWidget'),
            // The initial style only; later swaps go through setStyleURI.
            styleUri: MapboxStyles.STANDARD,
            viewport: CameraViewportState(
              center: Point(coordinates: Position(-122.4194, 37.7749)),
              zoom: 12.5,
              pitch: 55,
            ),
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
          ),
          MapHud(
            title: 'Loaded style',
            rows: [
              MapHudRow(
                'style',
                _styles[_styleUri] ?? 'Custom',
                emphasized: true,
              ),
              MapHudRow('layers', '$_layerCount'),
              MapHudRow('sources', '$_sourceCount'),
              MapHudRow('style JSON', _styleSize),
              MapHudRow('your layer', _layerAdded ? 'added' : 'not added'),
            ],
          ),
        ],
      ),
      controlsBuilder: () => switch (_scene) {
        _Scene.basemap => _basemapControls(),
        _Scene.layers => _layerControls(),
        _Scene.lighting => _lightingControls(),
      },
    );
  }

  List<Widget> _basemapControls() => [
    ControlRow(
      label: 'Style',
      child: ControlChoices<String>(
        options: _styles,
        value: _styleUri,
        onChanged: _setStyle,
      ),
    ),
    if (_styleUri.contains('standard'))
      ControlRow(
        label: 'Light preset',
        child: ControlChoices<String>(
          options: const {
            'dawn': 'Dawn',
            'day': 'Day',
            'dusk': 'Dusk',
            'night': 'Night',
          },
          value: _lightPreset,
          onChanged: (value) {
            setState(() => _lightPreset = value);
            _applyLightPreset();
          },
        ),
      ),
    const SizedBox(height: 4),
    const Text(
      'Each style is a different set of layers and sources — watch the counts '
      'change as you swap. The light preset is a config property of the '
      'Standard style import, not a separate style.',
      style: TextStyle(
        fontSize: 11,
        height: 1.35,
        color: MapboxGlass.labelFaint,
      ),
    ),
  ];

  List<Widget> _layerControls() => [
    ControlRow(
      label: 'Line color',
      child: ControlChoices<String>(
        options: const {
          'Blue': 'Blue',
          'Orange': 'Orange',
          'Green': 'Green',
          'Purple': 'Purple',
        },
        value: _layerColorName,
        onChanged: (value) {
          setState(() => _layerColorName = value);
          // A packed int is not a style-spec color: the property has to carry
          // an rgba() string for the update to apply on every platform.
          _setLayerProperty(
            'line-color',
            _lineColors[value]!.toARGB32().toRGBA(),
          );
        },
      ),
    ),
    ControlSlider(
      label: 'Line width',
      value: _layerWidth,
      min: 1,
      max: 24,
      onChanged: (value) {
        setState(() => _layerWidth = value);
        _setLayerProperty('line-width', value);
      },
    ),
    ControlSwitch(
      label: 'Draw under buildings & labels',
      value: _below,
      onChanged: _setSlot,
    ),
    ControlAction(
      label: _layerAdded ? 'Remove layer & source' : 'Add layer & source',
      icon: _layerAdded ? Icons.layers_clear_outlined : Icons.add,
      onPressed: _layerAdded ? _removeLayer : _addLayer,
    ),
    const SizedBox(height: 4),
    const Text(
      'The color and width controls write single paint properties to the '
      'existing layer. The switch moves it between the Standard slots: '
      "'middle' draws under trees, 3D buildings and road labels, 'top' draws "
      'over them. Pitch the map to see the difference.',
      style: TextStyle(
        fontSize: 11,
        height: 1.35,
        color: MapboxGlass.labelFaint,
      ),
    ),
  ];

  List<Widget> _lightingControls() => [
    ControlSwitch(
      label: 'Terrain exaggeration',
      value: _terrain,
      // Terrain has no web implementation, so the switch is inert there.
      onChanged: kIsWeb ? null : _setTerrain,
    ),
    if (!kIsWeb)
      ControlAction(
        label: 'Apply 3D lights & shadows',
        icon: Icons.wb_sunny_outlined,
        onPressed: _applyLighting,
      ),
    const SizedBox(height: 4),
    Text(
      kIsWeb
          ? 'Directional and ambient lights, and terrain, are native-only.'
          : 'Directional and ambient lights give finer control over shadow '
                'direction and intensity. Terrain lifts the basemap into '
                'real elevation.',
      style: const TextStyle(
        fontSize: 11,
        height: 1.35,
        color: MapboxGlass.labelFaint,
      ),
    ),
  ];
}

/// Selectable line colors, keyed by their label.
const _lineColors = {
  'Blue': MapboxColors.blue50,
  'Orange': MapboxColors.orange50,
  'Green': MapboxColors.green50,
  'Purple': MapboxColors.purple50,
};

/// A short route through San Francisco, used as the added layer's data.
const _routeGeoJson =
    '{"type":"Feature","geometry":{"type":"LineString","coordinates":'
    '[[-122.4833,37.7694],[-122.4550,37.7706],[-122.4330,37.7625],'
    '[-122.4194,37.7599],[-122.4050,37.7850],[-122.3933,37.7955]]}}';
