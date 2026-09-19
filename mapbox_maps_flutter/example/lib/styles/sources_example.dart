import 'dart:convert';

import 'package:flutter/material.dart' hide Visibility;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// The source types the SDK can render, on one map. A scene selection swaps
/// the source and layer, then flies the camera to that data.
class SourcesExample extends StatefulWidget {
  const SourcesExample({super.key});

  @override
  State<SourcesExample> createState() => _SourcesExampleState();
}

enum _Source { geojson, vector, raster, image, cluster, traffic }

const _scenes = [
  Scene(
    id: 'geojson',
    title: 'GeoJSON',
    subtitle: 'Inline features as a line',
    icon: Icons.polyline_outlined,
  ),
  Scene(
    id: 'vector',
    title: 'Vector tiles',
    subtitle: 'Terrain contours from a tileset',
    icon: Icons.terrain_outlined,
  ),
  Scene(
    id: 'raster',
    title: 'Raster tiles',
    subtitle: 'An XYZ tile service',
    icon: Icons.grid_on_outlined,
  ),
  Scene(
    id: 'image',
    title: 'Image source',
    subtitle: 'A bitmap pinned to coordinates',
    icon: Icons.photo_size_select_actual_outlined,
  ),
  Scene(
    id: 'cluster',
    title: 'Clustered points',
    subtitle: 'Earthquakes grouped by count',
    icon: Icons.bubble_chart_outlined,
  ),
  Scene(
    id: 'traffic',
    title: 'Traffic',
    subtitle: 'Live congestion on a vector tileset',
    icon: Icons.traffic_outlined,
  ),
];

class _SourcesExampleState extends State<SourcesExample> {
  static const _sourceId = 'example-source';
  static const _layerIds = [
    'example-layer',
    'example-layer-clusters',
    'example-layer-cluster-count',
  ];

  /// Where each source's data lives.
  static final _cameras = {
    _Source.geojson: CameraOptions(
      center: Point(coordinates: Position(-77.0365, 38.8977)),
      zoom: 11,
    ),
    _Source.vector: CameraOptions(
      center: Point(coordinates: Position(-122.447303, 37.753574)),
      zoom: 12,
    ),
    _Source.raster: CameraOptions(
      center: Point(coordinates: Position(-80.1263, 25.7845)),
      zoom: 11,
    ),
    _Source.image: CameraOptions(
      center: Point(coordinates: Position(-80.1263, 25.7845)),
      zoom: 13,
    ),
    _Source.cluster: CameraOptions(
      center: Point(coordinates: Position(-25, 20)),
      zoom: 1.4,
    ),
    _Source.traffic: CameraOptions(
      center: Point(
        coordinates: Position(-122.39470445734368, 37.7080221537549),
      ),
      zoom: 12,
    ),
  };

  MapboxMap? _mapboxMap;
  var _source = _Source.geojson;
  var _lightPreset = 'day';
  var _styleLoaded = false;

  void _onMapCreated(MapboxMap mapboxMap) {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData _) async {
    _styleLoaded = true;
    // The light preset is cosmetic, and only the Standard style has a basemap
    // import to configure. A failure here must not stop the scene's source
    // from being added.
    try {
      await _applyLightPreset();
    } on Object catch (_) {}
    await _showSource();
  }

  void _report(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  Future<void> _applyLightPreset() async {
    await _mapboxMap?.setStyleImportConfigProperty(
      'basemap',
      'lightPreset',
      _lightPreset,
    );
  }

  /// Removes whatever the previous scene added. Layers go first: a source
  /// still in use by a layer cannot be removed.
  Future<void> _clear() async {
    final map = _mapboxMap;
    if (map == null) return;
    for (final layerId in _layerIds) {
      if (await map.styleLayerExists(layerId)) {
        await map.removeStyleLayer(layerId);
      }
    }
    if (await map.styleSourceExists(_sourceId)) {
      await map.removeStyleSource(_sourceId);
    }
  }

  Future<void> _showSource() async {
    final map = _mapboxMap;
    if (map == null || !_styleLoaded) return;

    try {
      await _clear();
    } on Object catch (error) {
      _report('Could not clear the previous source: $error');
      return;
    }

    try {
      switch (_source) {
        case _Source.geojson:
          await _addGeoJson(map);
        case _Source.vector:
          await _addVector(map);
        case _Source.raster:
          await _addRaster(map);
        case _Source.image:
          await _addImage(map);
        case _Source.cluster:
          await _addCluster(map);
        case _Source.traffic:
          await _addTraffic(map);
      }
    } on Object catch (error) {
      _report('Could not add the source: $error');
      return;
    }
    await map.flyTo(_cameras[_source]!, MapAnimationOptions(duration: 1200));
  }

  Future<void> _addGeoJson(MapboxMap map) async {
    await map.addSource(
      GeoJsonSource(
        id: _sourceId,
        data: json.encode({
          'type': 'Feature',
          'geometry': {
            'type': 'LineString',
            'coordinates': [
              [-77.0417, 38.9059],
              [-77.0361, 38.8977],
              [-77.0233, 38.8921],
              [-77.0091, 38.8899],
            ],
          },
        }),
      ),
    );
    await map.addLayer(
      LineLayer(
        id: _layerIds.first,
        sourceId: _sourceId,
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineColor: const Color(0xFF007AFC).toARGB32(),
        lineWidth: 6,
      ),
    );
  }

  Future<void> _addVector(MapboxMap map) async {
    await map.addSource(
      VectorSource(id: _sourceId, url: 'mapbox://mapbox.mapbox-terrain-v2'),
    );
    await map.addLayer(
      LineLayer(
        id: _layerIds.first,
        sourceId: _sourceId,
        sourceLayer: 'contour',
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineColor: const Color(0xFFFC8200).toARGB32(),
        lineWidth: 1.6,
      ),
    );
  }

  Future<void> _addRaster(MapboxMap map) async {
    await map.addSource(
      RasterSource(
        id: _sourceId,
        tiles: const ['https://tile.openstreetmap.org/{z}/{x}/{y}.png'],
        tileSize: 256,
        scheme: Scheme.XYZ,
        minzoom: 0,
        maxzoom: 18,
        attribution: '&copy; OpenStreetMap contributors, CC-BY-SA',
      ),
    );
    await map.addLayer(RasterLayer(id: _layerIds.first, sourceId: _sourceId));
  }

  Future<void> _addImage(MapboxMap map) async {
    // The source carries the image url, which keeps mobile and web on one
    // code path.
    final imageUrl = await MapboxMapsOptions.getFlutterAssetPath(
      'asset://assets/miami_beach.png',
    );
    await map.addSource(
      ImageSource(
        id: _sourceId,
        url: imageUrl,
        coordinates: const [
          [-80.11725, 25.7836],
          [-80.1397431334, 25.783548],
          [-80.13964, 25.7680],
          [-80.11725, 25.76795],
        ],
      ),
    );
    await map.addLayer(
      RasterLayer(
        id: _layerIds.first,
        sourceId: _sourceId,
        // An emissive strength keeps the bitmap legible under a dark
        // light preset.
        rasterEmissiveStrength: 1.0,
      ),
    );
  }

  Future<void> _addCluster(MapboxMap map) async {
    await map.addSource(
      GeoJsonSource(
        id: _sourceId,
        data: 'https://docs.mapbox.com/mapbox-gl-js/assets/earthquakes.geojson',
        cluster: true,
        clusterRadius: 50,
        clusterMaxZoom: 14,
      ),
    );
    // Single points go in first, so the cluster bubbles draw over them. The
    // `top` slot lifts every cluster layer above the Standard basemap.
    await map.addLayer(
      CircleLayer(
        id: _layerIds.first,
        sourceId: _sourceId,
        slot: 'top',
        filter: [
          '!',
          ['has', 'point_count'],
        ],
        circleColor: const Color(0xFF007AFC).toARGB32(),
        circleRadius: 5,
        circleStrokeColor: Colors.white.toARGB32(),
        circleStrokeWidth: 1,
      ),
    );
    // Step expressions size and color the clusters by point count.
    await map.addLayer(
      CircleLayer(
        id: _layerIds[1],
        sourceId: _sourceId,
        slot: 'top',
        filter: ['has', 'point_count'],
        // Colors inside an expression must be style-spec color values, not
        // the packed ints the plain `circleColor` setter takes.
        circleColorExpression: const [
          'step',
          ['get', 'point_count'],
          '#3195ff',
          100,
          '#fed622',
          750,
          '#f13219',
        ],
        circleRadiusExpression: [
          'step',
          ['get', 'point_count'],
          18.0,
          100,
          24.0,
          750,
          30.0,
        ],
      ),
    );
    await map.addLayer(
      SymbolLayer(
        id: _layerIds[2],
        sourceId: _sourceId,
        slot: 'top',
        filter: ['has', 'point_count'],
        textFieldExpression: ['get', 'point_count_abbreviated'],
        textSize: 12,
        textColor: Colors.white.toARGB32(),
      ),
    );
  }

  Future<void> _addTraffic(MapboxMap map) async {
    await map.addSource(
      VectorSource(id: _sourceId, url: 'mapbox://mapbox.mapbox-traffic-v1'),
    );
    await map.addLayer(
      LineLayer(
        id: _layerIds.first,
        sourceId: _sourceId,
        sourceLayer: 'traffic',
        lineCap: LineCap.ROUND,
        lineJoin: LineJoin.ROUND,
        lineWidthExpression: [
          'interpolate',
          ['linear'],
          ['zoom'],
          14.0,
          ['*', 2.0, 1.3],
          20.0,
          ['*', 10, 1.2],
        ],
        lineColorExpression: [
          'case',
          [
            '==',
            'low',
            ['get', 'congestion'],
          ],
          '#39c66d',
          [
            '==',
            'moderate',
            ['get', 'congestion'],
          ],
          '#ff8c1a',
          [
            '==',
            'heavy',
            ['get', 'congestion'],
          ],
          '#ff0015',
          [
            '==',
            'severe',
            ['get', 'congestion'],
          ],
          '#981b25',
          '#000000',
        ],
        lineOffsetExpression: [
          'interpolate',
          ['linear'],
          ['zoom'],
          14.0,
          ['*', 2, 1.0],
          20.0,
          ['*', 18, 1.0],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      scenes: _scenes,
      selectedSceneId: _source.name,
      onSceneSelected: (id) {
        setState(
          () => _source = _Source.values.firstWhere(
            (source) => source.name == id,
          ),
        );
        _showSource();
      },
      controlsTitle: 'Source options',
      controlsSheetSize: ControlsSheetSize.small,
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: MapWidget(
        key: const ValueKey('mapWidget'),
        styleUri: MapboxStyles.STANDARD,
        // Start on the first scene's data; _showSource flies from here.
        viewport: CameraViewportState(
          center: Point(coordinates: Position(-77.0365, 38.8977)),
          zoom: 11,
        ),
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoaded,
      ),
      controlsBuilder: () => [
        ControlRow(
          label: 'Lighting',
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
        ControlAction(
          label: 'Reload source',
          icon: Icons.refresh,
          onPressed: _showSource,
        ),
        const SizedBox(height: 4),
        const Text(
          'Each scene adds one source with the layers that render it, then '
          'flies the camera to that data.',
          style: TextStyle(
            fontSize: 11,
            height: 1.35,
            color: MapboxGlass.labelFaint,
          ),
        ),
      ],
    );
  }
}
