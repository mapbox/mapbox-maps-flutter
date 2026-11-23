// ignore_for_file: experimental_member_use

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../platform.dart' show isWeb;
import '../scene_scaffold.dart';

/// Changes source properties after the source is added, with
/// [StyleManager.setStyleSourceProperty]. Each scene adds one source type.
/// The HUD shows the values that [StyleManager.getStyleSourceProperty]
/// returns after each change.
class SourcePropertiesExample extends StatefulWidget {
  const SourcePropertiesExample({super.key});

  @override
  State<SourcePropertiesExample> createState() =>
      _SourcePropertiesExampleState();
}

enum _Source { raster, rasterDem, rasterArray, vector, geojson, image, model }

const _scenes = [
  Scene(
    id: 'raster',
    title: 'Raster',
    subtitle: 'tiles, minzoom, maxzoom',
    icon: Icons.grid_on_outlined,
  ),
  Scene(
    id: 'rasterDem',
    title: 'Raster DEM',
    subtitle: 'url, maxzoom',
    icon: Icons.landscape_outlined,
  ),
  Scene(
    id: 'rasterArray',
    title: 'Raster array',
    subtitle: 'minzoom, maxzoom',
    icon: Icons.air,
  ),
  Scene(
    id: 'vector',
    title: 'Vector',
    subtitle: 'minzoom, maxzoom',
    icon: Icons.terrain_outlined,
  ),
  Scene(
    id: 'geojson',
    title: 'GeoJSON',
    subtitle: 'data',
    icon: Icons.polyline_outlined,
  ),
  Scene(
    id: 'image',
    title: 'Image',
    subtitle: 'url, coordinates',
    icon: Icons.photo_size_select_actual_outlined,
  ),
  Scene(
    id: 'model',
    title: 'Model',
    subtitle: 'models',
    icon: Icons.directions_car_outlined,
  ),
];

/// The properties that the HUD reads back for each scene.
const _readBackPropertyNames = {
  _Source.raster: ['tiles', 'minzoom', 'maxzoom', 'prefetch-zoom-delta'],
  _Source.rasterDem: ['url', 'maxzoom'],
  _Source.rasterArray: ['minzoom', 'maxzoom'],
  _Source.vector: ['minzoom', 'maxzoom'],
  _Source.geojson: ['data'],
  _Source.image: ['url', 'coordinates'],
  _Source.model: ['models'],
};

const _demUrls = {
  'mapbox://mapbox.mapbox-terrain-dem-v1': 'Terrain DEM v1',
  'mapbox://mapbox.terrain-rgb': 'Terrain RGB',
};

/// Routes in Washington, D.C. for the GeoJSON scene.
const _routes = <String, List<List<double>>>{
  'Mall': [
    [-77.0502, 38.8893],
    [-77.0353, 38.8895],
    [-77.0091, 38.8899],
  ],
  'Pennsylvania Ave': [
    [-77.0417, 38.9059],
    [-77.0361, 38.8977],
    [-77.0233, 38.8921],
    [-77.0091, 38.8899],
  ],
  'Rock Creek': [
    [-77.0502, 38.8893],
    [-77.0563, 38.9034],
    [-77.0526, 38.9208],
    [-77.0498, 38.9361],
  ],
};

const _imageCorners = [
  [-80.11725, 25.7836],
  [-80.1397431334, 25.783548],
  [-80.13964, 25.7680],
  [-80.11725, 25.76795],
];

class _Car {
  _Car(this.id, this.lng, this.lat, this.heading);

  final String id;
  final double lng;
  final double lat;
  double heading;
}

class _SourcePropertiesExampleState extends State<SourcePropertiesExample> {
  static const _sourceId = 'live-source';
  static const _layerId = 'live-layer';
  static const _carUri =
      'https://docs.mapbox.com/mapbox-gl-js/assets/ego_car.glb';
  static final _modelCenter = Position(24.944053, 60.170743);

  static final _cameras = {
    _Source.raster: CameraOptions(
      center: Point(coordinates: Position(10, 50)),
      zoom: 4,
    ),
    _Source.rasterDem: CameraOptions(
      center: Point(coordinates: Position(10.8, 46.5)),
      zoom: 9,
    ),
    _Source.rasterArray: CameraOptions(
      center: Point(coordinates: Position(-40, 30)),
      zoom: 2,
    ),
    _Source.vector: CameraOptions(
      center: Point(coordinates: Position(-122.447303, 37.753574)),
      zoom: 12,
    ),
    _Source.geojson: CameraOptions(
      center: Point(coordinates: Position(-77.0365, 38.905)),
      zoom: 12,
    ),
    _Source.image: CameraOptions(
      center: Point(coordinates: Position(-80.1263, 25.7765)),
      zoom: 13.5,
    ),
    _Source.model: CameraOptions(
      center: Point(coordinates: _modelCenter),
      zoom: 18.5,
      pitch: 60,
    ),
  };

  final _random = Random();

  MapboxMap? _mapboxMap;
  var _styleLoaded = false;
  var _source = _Source.raster;
  var _zoom = 0.0;
  Map<String, String> _readBack = {};

  // Raster scene.
  var _satellite = false;
  var _minzoom = 0.0;
  var _maxzoom = 22.0;
  var _prefetchZoomDelta = 4.0;

  // Raster DEM scene.
  var _demUrl = _demUrls.keys.first;

  // GeoJSON scene.
  var _route = _routes.keys.first;

  // Image scene.
  var _imageUrl = '';
  var _imageRotation = 0;

  // Model scene.
  final _cars = <_Car>[];
  var _nextCarId = 0;

  void _onMapCreated(MapboxMap mapboxMap) {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData _) async {
    _styleLoaded = true;
    await _showSource();
  }

  void _onCameraChanged(CameraChangedEventData data) {
    setState(() => _zoom = data.cameraState.zoom);
  }

  void _report(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  /// Sets one property of the current source, then reads the values back.
  Future<void> _set(String property, Object value) async {
    final map = _mapboxMap;
    if (map == null) return;
    try {
      await map.setStyleSourceProperty(_sourceId, property, value);
    } on Object catch (error) {
      _report('Could not set $property: $error');
    }
    await _readBackProperties();
  }

  Future<void> _readBackProperties() async {
    final map = _mapboxMap;
    if (map == null) return;
    final values = <String, String>{};
    for (final property in _readBackPropertyNames[_source]!) {
      if (property == 'prefetch-zoom-delta' && isWeb) continue;
      try {
        final value = await map.getStyleSourceProperty(_sourceId, property);
        values[property] = _describe(value.value);
      } on Object {
        values[property] = '—';
      }
    }
    if (mounted) setState(() => _readBack = values);
  }

  /// A short text for a property value. Access tokens are hidden.
  static String _describe(Object? value) {
    if (value == null) return '—';
    if (value is Map) return value.keys.join(', ');
    final text = (value is String ? value : jsonEncode(value)).replaceAll(
      RegExp(r'access_token=[^"&,\]]+'),
      'access_token=…',
    );
    return text.length > 48 ? '${text.substring(0, 47)}…' : text;
  }

  Future<void> _clear(MapboxMap map) async {
    if (await map.styleLayerExists(_layerId)) {
      await map.removeStyleLayer(_layerId);
    }
    if (await map.styleSourceExists(_sourceId)) {
      await map.removeStyleSource(_sourceId);
    }
  }

  Future<void> _showSource() async {
    final map = _mapboxMap;
    if (map == null || !_styleLoaded) return;
    try {
      await _clear(map);
      switch (_source) {
        case _Source.raster:
          await _addRaster(map);
        case _Source.rasterDem:
          await _addRasterDem(map);
        case _Source.rasterArray:
          await _addRasterArray(map);
        case _Source.vector:
          await _addVector(map);
        case _Source.geojson:
          await _addGeoJson(map);
        case _Source.image:
          await _addImage(map);
        case _Source.model:
          await _addModel(map);
      }
    } on Object catch (error) {
      _report('Could not add the source: $error');
      return;
    }
    await _readBackProperties();
    await map.flyTo(_cameras[_source]!, MapAnimationOptions(duration: 1200));
  }

  void _resetZoomRange(double maxzoom) {
    setState(() {
      _minzoom = 0;
      _maxzoom = maxzoom;
    });
  }

  Future<List<String>> _rasterTiles() async {
    if (!_satellite) return ['https://tile.openstreetmap.org/{z}/{x}/{y}.png'];
    final token = await MapboxOptions.accessToken;
    return [
      'https://api.mapbox.com/v4/mapbox.satellite/{z}/{x}/{y}.jpg90'
          '?access_token=$token',
    ];
  }

  Future<void> _addRaster(MapboxMap map) async {
    _resetZoomRange(18);
    await map.addSource(
      RasterSource(
        id: _sourceId,
        tiles: await _rasterTiles(),
        tileSize: 256,
        maxzoom: _maxzoom,
        attribution: _satellite
            ? '© Mapbox © Maxar'
            : '&copy; OpenStreetMap contributors, CC-BY-SA',
      ),
    );
    await map.addLayer(
      RasterLayer(id: _layerId, sourceId: _sourceId, slot: 'middle'),
    );
  }

  Future<void> _addRasterDem(MapboxMap map) async {
    _resetZoomRange(14);
    await map.addSource(RasterDemSource(id: _sourceId, url: _demUrl));
    await map.addLayer(
      HillshadeLayer(
        id: _layerId,
        sourceId: _sourceId,
        slot: 'middle',
        hillshadeExaggeration: 1,
      ),
    );
  }

  Future<void> _addRasterArray(MapboxMap map) async {
    _resetZoomRange(4);
    await map.addSource(
      RasterArraySource(id: _sourceId, url: 'mapbox://mapbox.gfs-winds'),
    );
    await map.addLayer(
      RasterParticleLayer(
        id: _layerId,
        sourceId: _sourceId,
        sourceLayer: '10winds',
        slot: 'top',
        rasterParticleSpeedFactor: 0.4,
        rasterParticleCount: 4096,
        rasterParticleColor: Colors.white.toARGB32(),
      ),
    );
  }

  Future<void> _addVector(MapboxMap map) async {
    _resetZoomRange(15);
    await map.addSource(
      VectorSource(id: _sourceId, url: 'mapbox://mapbox.mapbox-terrain-v2'),
    );
    await map.addLayer(
      LineLayer(
        id: _layerId,
        sourceId: _sourceId,
        sourceLayer: 'contour',
        slot: 'middle',
        lineColor: const Color(0xFFFC8200).toARGB32(),
        lineWidth: 1.6,
      ),
    );
  }

  String _routeData() => jsonEncode({
    'type': 'Feature',
    'properties': <String, Object>{},
    'geometry': {'type': 'LineString', 'coordinates': _routes[_route]},
  });

  Future<void> _addGeoJson(MapboxMap map) async {
    await map.addSource(GeoJsonSource(id: _sourceId, data: _routeData()));
    await map.addLayer(
      LineLayer(
        id: _layerId,
        sourceId: _sourceId,
        slot: 'top',
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineColor: const Color(0xFF007AFC).toARGB32(),
        lineWidth: 6,
      ),
    );
  }

  Future<String> _imageAsset(String name) async =>
      await MapboxMapsOptions.getFlutterAssetPath('asset://assets/$name') ??
      'asset://assets/$name';

  /// The image corners, turned clockwise by [_imageRotation] quarter turns.
  List<List<double>> _corners() => [
    for (var i = 0; i < 4; i++) _imageCorners[(i + _imageRotation) % 4],
  ];

  Future<void> _addImage(MapboxMap map) async {
    _imageUrl = await _imageAsset('miami_beach.png');
    _imageRotation = 0;
    await map.addSource(
      ImageSource(id: _sourceId, url: _imageUrl, coordinates: _corners()),
    );
    await map.addLayer(
      RasterLayer(
        id: _layerId,
        sourceId: _sourceId,
        slot: 'top',
        rasterEmissiveStrength: 1.0,
      ),
    );
  }

  Map<String, Object> _modelsValue() => {
    for (final car in _cars)
      car.id: ModelSourceModel(
        id: car.id,
        uri: _carUri,
        position: [car.lng, car.lat],
        orientation: [0.0, 0.0, car.heading],
      ).toJson(),
  };

  Future<void> _addModel(MapboxMap map) async {
    _cars
      ..clear()
      ..add(
        _Car(
          'car-0',
          _modelCenter.lng.toDouble(),
          _modelCenter.lat.toDouble(),
          0,
        ),
      );
    _nextCarId = 1;
    await map.addSource(ModelSource(id: _sourceId));
    await map.setStyleSourceProperty(_sourceId, 'models', _modelsValue());
    await map.addLayer(
      ModelLayer(
        id: _layerId,
        sourceId: _sourceId,
        modelType: ModelType.LOCATION_INDICATOR,
        modelScale: [4.0, 4.0, 4.0],
      ),
    );
  }

  Future<void> _addCar() async {
    // About 40 m around the center.
    final lng = _modelCenter.lng + (_random.nextDouble() - 0.5) * 0.0008;
    final lat = _modelCenter.lat + (_random.nextDouble() - 0.5) * 0.0004;
    _cars.add(
      _Car('car-${_nextCarId++}', lng, lat, _random.nextDouble() * 360),
    );
    await _set('models', _modelsValue());
  }

  Future<void> _removeCar() async {
    if (_cars.isEmpty) return;
    _cars.removeLast();
    await _set('models', _modelsValue());
  }

  Future<void> _turnCars() async {
    for (final car in _cars) {
      car.heading = (car.heading + 45) % 360;
    }
    await _set('models', _modelsValue());
  }

  List<Widget> _zoomRangeControls() => [
    ControlSlider(
      label: 'minzoom',
      value: _minzoom,
      min: 0,
      max: 22,
      fractionDigits: 0,
      onChanged: (value) => setState(() => _minzoom = value.roundToDouble()),
      onChangeEnd: (value) => _set('minzoom', value.roundToDouble()),
    ),
    ControlSlider(
      label: 'maxzoom',
      value: _maxzoom,
      min: 0,
      max: 22,
      fractionDigits: 0,
      onChanged: (value) => setState(() => _maxzoom = value.roundToDouble()),
      onChangeEnd: (value) => _set('maxzoom', value.roundToDouble()),
    ),
    const _Note(
      'The source loads no tiles below minzoom, so the layer is not shown. '
      'Above maxzoom, the source scales up the tiles from maxzoom, so the '
      'layer shows less detail. Move a slider past the zoom in the HUD to '
      'see the change.',
    ),
  ];

  List<Widget> _sceneControls() {
    switch (_source) {
      case _Source.raster:
        return [
          ControlRow(
            label: 'tiles',
            child: ControlChoices<bool>(
              options: const {false: 'OpenStreetMap', true: 'Satellite'},
              value: _satellite,
              onChanged: (value) async {
                setState(() => _satellite = value);
                await _set('tiles', await _rasterTiles());
              },
            ),
          ),
          ..._zoomRangeControls(),
          const _Note(
            'This source has 256 px tiles, so it loads tiles one zoom level '
            'above the camera zoom. Raster sources also round the tile zoom. '
            'At zoom 4, the source loads zoom 5 tiles, and minzoom 6 hides '
            'the layer only below zoom 4.5.',
          ),
          if (isWeb)
            const _Note(
              'prefetch-zoom-delta and the other tile loading properties '
              'are not supported on web.',
            )
          else
            ControlSlider(
              label: 'prefetch-zoom-delta',
              value: _prefetchZoomDelta,
              min: 0,
              max: 8,
              fractionDigits: 0,
              onChanged: (value) =>
                  setState(() => _prefetchZoomDelta = value.roundToDouble()),
              onChangeEnd: (value) =>
                  _set('prefetch-zoom-delta', value.roundToDouble()),
            ),
        ];
      case _Source.rasterDem:
        return [
          ControlRow(
            label: 'url',
            child: ControlChoices<String>(
              options: _demUrls,
              value: _demUrl,
              onChanged: (value) {
                setState(() => _demUrl = value);
                _set('url', value);
              },
            ),
          ),
          ControlSlider(
            label: 'maxzoom',
            value: _maxzoom,
            min: 0,
            max: 22,
            fractionDigits: 0,
            onChanged: (value) =>
                setState(() => _maxzoom = value.roundToDouble()),
            onChangeEnd: (value) => _set('maxzoom', value.roundToDouble()),
          ),
          const _Note(
            'Above maxzoom, the source scales up the elevation tiles from '
            'maxzoom, so the hillshade shows less detail.',
          ),
        ];
      case _Source.rasterArray:
      case _Source.vector:
        return _zoomRangeControls();
      case _Source.geojson:
        return [
          ControlRow(
            label: 'data',
            child: ControlChoices<String>(
              options: {for (final name in _routes.keys) name: name},
              value: _route,
              onChanged: (value) {
                setState(() => _route = value);
                _set('data', _routeData());
              },
            ),
          ),
        ];
      case _Source.image:
        return [
          ControlRow(
            label: 'url',
            child: ControlChoices<String>(
              options: const {'miami_beach.png': 'Photo', 'radar.gif': 'Radar'},
              value: _imageUrl.endsWith('miami_beach.png')
                  ? 'miami_beach.png'
                  : 'radar.gif',
              onChanged: (value) async {
                _imageUrl = value == 'radar.gif'
                    ? 'https://docs.mapbox.com/mapbox-gl-js/assets/radar.gif'
                    : await _imageAsset(value);
                setState(() {});
                await _set('url', _imageUrl);
              },
            ),
          ),
          ControlAction(
            label: 'Turn the image a quarter',
            icon: Icons.rotate_90_degrees_cw_outlined,
            onPressed: () {
              _imageRotation = (_imageRotation + 1) % 4;
              _set('coordinates', _corners());
            },
          ),
        ];
      case _Source.model:
        return [
          ControlAction(
            label: 'Add a car',
            icon: Icons.add,
            onPressed: _addCar,
          ),
          ControlAction(
            label: 'Turn all cars',
            icon: Icons.rotate_right,
            onPressed: _cars.isEmpty ? null : _turnCars,
          ),
          ControlAction(
            label: 'Remove a car',
            icon: Icons.remove,
            onPressed: _cars.isEmpty ? null : _removeCar,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      scenes: _scenes,
      selectedSceneId: _source.name,
      onSceneSelected: (id) {
        setState(() {
          _source = _Source.values.firstWhere((source) => source.name == id);
          _readBack = {};
        });
        _showSource();
      },
      controlsTitle: 'Source properties',
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('mapWidget'),
            styleUri: MapboxStyles.STANDARD,
            viewport: CameraViewportState(
              center: Point(coordinates: Position(10, 50)),
              zoom: 4,
            ),
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
            onCameraChangeListener: _onCameraChanged,
          ),
          MapHud(
            title: 'Read back from the source',
            rows: [
              MapHudRow('zoom', _zoom.toStringAsFixed(1), emphasized: true),
              for (final MapEntry(key: property, value: value)
                  in _readBack.entries)
                MapHudRow(property, value),
            ],
          ),
        ],
      ),
      controlsBuilder: () => [
        ..._sceneControls(),
        const _Note(
          'Each control calls setStyleSourceProperty on the source. The '
          'HUD shows what getStyleSourceProperty returns after the change.',
        ),
      ],
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          height: 1.35,
          color: MapboxGlass.labelFaint,
        ),
      ),
    );
  }
}
