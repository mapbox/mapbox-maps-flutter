import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// Two ways to put a custom icon on the map.
///
/// **Runtime images** adds both [StyleImage] variants with `addImage`: an
/// [StyleImage.rgba] gradient, and a [StyleImage.bytes] PNG from the assets.
/// `hasStyleImage` and `getImage` confirm what landed.
///
/// **Vector icons** colors one parameterized SVG from the style per feature,
/// with an image expression.
class StyleImagesExample extends StatefulWidget {
  const StyleImagesExample({super.key});

  @override
  State<StyleImagesExample> createState() => _StyleImagesExampleState();
}

enum _Scene { runtime, vector }

const _scenes = [
  Scene(
    id: 'runtime',
    title: 'Runtime images',
    subtitle: 'addImage with rgba & bytes, hide and re-add',
    icon: Icons.image_outlined,
  ),
  Scene(
    id: 'vector',
    title: 'Vector icons',
    subtitle: 'Colorize a parameterized SVG, tap to grow',
    icon: Icons.flag_outlined,
  ),
];

class _StyleImagesExampleState extends State<StyleImagesExample> {
  static const _rgbaImageId = 'gradient';
  static const _bytesImageId = 'png-icon';
  static const _runtimeSourceId = 'runtime-points';
  static const _runtimeLayerId = 'runtime-points';
  static const _vectorSourceId = 'vector-points';
  static const _vectorLayerId = 'vector-points';
  static const _size = 64;

  final _viewportController = ViewportController();

  MapboxMap? _mapboxMap;
  var _scene = _Scene.runtime;

  final Map<String, String> _status = {};
  final Map<String, bool> _visible = {_rgbaImageId: true, _bytesImageId: true};

  String? _selectedFlagId;

  /// Only read from callbacks that the map itself drives, so it is set by then.
  MapboxMap get map => _mapboxMap!;

  void _onMapCreated(MapboxMap mapboxMap) {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
    final tapInteraction =
        TypedInteraction<TypedFeaturesetFeature<FeaturesetDescriptor>>(
          featuresetDescriptor: FeaturesetDescriptor(layerId: _vectorLayerId),
          interactionType: InteractionType.tap,
          featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
          action: (feature, _) {
            final id = feature?.properties['flagId'];
            if (id is! String) return;
            _selectFlag(id);
          },
        );
    mapboxMap.addInteraction(tapInteraction, interactionID: 'tap_flags');
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData _) async {
    await _addRuntimeSymbols();
    await _addFlagSymbols();
    _flyToScene();
  }

  void _selectScene(String id) {
    setState(() => _scene = _Scene.values.firstWhere((s) => s.name == id));
    _flyToScene();
  }

  void _flyToScene() {
    final camera = switch (_scene) {
      _Scene.runtime => CameraViewportState(
        center: Point(coordinates: Position(0, 0)),
        zoom: 2,
        pitch: 0,
        bearing: 0,
      ),
      _Scene.vector => CameraViewportState(
        center: Point(coordinates: Position(24.6881, 60.185755)),
        zoom: 16,
        pitch: 0,
        bearing: 0,
      ),
    };
    _viewportController.moveTo(
      camera,
      transition: FlyViewportTransition(
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  // --- Runtime images -------------------------------------------------

  Future<void> _addRuntimeSymbols() async {
    // The images must exist before the layer that references them: gl-js
    // resolves `icon-image` when the layer is added, and does not repaint.
    await _addImage(_rgbaImageId);
    await _addImage(_bytesImageId);

    await map.addSource(
      GeoJsonSource(
        id: _runtimeSourceId,
        data: json.encode({
          'type': 'FeatureCollection',
          'features': [
            {
              'type': 'Feature',
              'geometry': {
                'type': 'Point',
                'coordinates': [-10.0, 0.0],
              },
              'properties': {'icon': _rgbaImageId},
            },
            {
              'type': 'Feature',
              'geometry': {
                'type': 'Point',
                'coordinates': [10.0, 0.0],
              },
              'properties': {'icon': _bytesImageId},
            },
          ],
        }),
      ),
    );
    await map.addLayer(
      SymbolLayer(
        id: _runtimeLayerId,
        sourceId: _runtimeSourceId,
        iconImageExpression: ['get', 'icon'],
        iconAllowOverlap: true,
      ),
    );
  }

  Future<void> _addImage(String id) async {
    if (_mapboxMap == null) return;
    if (id == _rgbaImageId) {
      await map.addImage(
        _rgbaImageId,
        1.0,
        StyleImage.rgba(
          width: _size,
          height: _size,
          pixels: _gradientRgba(_size),
        ),
      );
    } else {
      final pngBytes = (await rootBundle.load(
        'assets/symbols/custom-icon.png',
      )).buffer.asUint8List();
      await map.addImage(_bytesImageId, 1.0, StyleImage.bytes(pngBytes));
    }
    setState(() => _visible[id] = true);
    await _refreshStatus(id);
  }

  /// Removes the image from the style, so the pin referencing it disappears.
  Future<void> _hideImage(String id) async {
    if (_mapboxMap == null) return;
    await map.removeStyleImage(id);
    setState(() => _visible[id] = false);
    await _refreshStatus(id);
  }

  Future<void> _toggleImage(String id) =>
      (_visible[id] ?? false) ? _hideImage(id) : _addImage(id);

  /// Confirms an image's state with `hasStyleImage`, and with a `getImage`
  /// round trip on mobile, which web does not support.
  Future<void> _refreshStatus(String id) async {
    if (_mapboxMap == null) return;
    final hasImage = await map.hasStyleImage(id);
    var line = 'hasStyleImage=$hasImage';
    if (!kIsWeb) {
      final rgba = hasImage ? await map.getImage(id) : null;
      line += rgba == null
          ? ' · getImage=null'
          : ' · getImage=${rgba.width}x${rgba.height}';
    }
    if (!mounted) return;
    setState(() => _status[id] = line);
  }

  /// Premultiplied RGBA gradient matching the GL JS sample.
  static Uint8List _gradientRgba(int width) {
    final data = Uint8List(width * width * 4);
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < width; y++) {
        final offset = (y * width + x) * 4;
        data[offset] = ((y / width) * 255).round(); // red
        data[offset + 1] = ((x / width) * 255).round(); // green
        data[offset + 2] = 128; // blue
        data[offset + 3] = 255; // alpha
      }
    }
    return data;
  }

  // --- Vector icons -----------------------------------------------------

  void _selectFlag(String id) {
    setState(() => _selectedFlagId = (_selectedFlagId == id) ? null : id);
    _mapboxMap?.setStyleLayerProperty(_vectorLayerId, 'icon-size', [
      'case',
      [
        '==',
        ['get', 'flagId'],
        _selectedFlagId ?? '',
      ],
      2.0,
      1.0,
    ]);
  }

  Future<void> _addFlagSymbols() async {
    final geojson = {
      'type': 'FeatureCollection',
      'features': [
        for (var i = 0; i < _flags.length; i++)
          _flagFeature(_flags[i].$1, _flags[i].$3, _flagPositions[i]),
      ],
    };

    await map.addSource(
      GeoJsonSource(id: _vectorSourceId, data: json.encode(geojson)),
    );

    await map.addLayer(
      SymbolLayer(
        id: _vectorLayerId,
        sourceId: _vectorSourceId,
        iconImageExpression: [
          'image',
          'flag',
          {
            'params': {
              'flag_color': ['get', 'flagColor'],
            },
          },
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedFlagName = _flags
        .where((flag) => flag.$1 == _selectedFlagId)
        .map((flag) => flag.$2)
        .firstOrNull;

    return SceneScaffold(
      scenes: _scenes,
      selectedSceneId: _scene.name,
      onSceneSelected: _selectScene,
      controlsTitle: 'Style images',
      controlsSheetSize: ControlsSheetSize.small,
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('styleImagesMap'),
            styleUri:
                'mapbox://styles/mapbox-map-design/cm4r19bcm00ao01qvhp3jc2gi',
            viewport: CameraViewportState(
              center: Point(coordinates: Position(0, 0)),
              zoom: 2,
            ),
            viewportController: _viewportController,
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
          ),
          if (_scene == _Scene.runtime)
            MapHud(
              title: 'Image status',
              rows: [
                MapHudRow(
                  _rgbaImageId,
                  _status[_rgbaImageId] ?? 'not added yet',
                ),
                MapHudRow(
                  _bytesImageId,
                  _status[_bytesImageId] ?? 'not added yet',
                ),
              ],
            )
          else
            MapHud(
              title: 'Vector icons',
              rows: [
                MapHudRow(
                  'selected',
                  selectedFlagName ?? 'none',
                  emphasized: true,
                ),
              ],
            ),
        ],
      ),
      controlsBuilder: () => switch (_scene) {
        _Scene.runtime => _runtimeControls(),
        _Scene.vector => _vectorControls(),
      },
    );
  }

  List<Widget> _runtimeControls() => [
    ControlSwitch(
      label: 'RGBA gradient',
      value: _visible[_rgbaImageId] ?? false,
      onChanged: (_) => _toggleImage(_rgbaImageId),
    ),
    ControlSwitch(
      label: 'Bytes PNG icon',
      value: _visible[_bytesImageId] ?? false,
      onChanged: (_) => _toggleImage(_bytesImageId),
    ),
    const SizedBox(height: 4),
    const Text(
      'The left pin uses a StyleImage.rgba gradient generated at runtime. '
      'The right pin uses StyleImage.bytes from a PNG asset. Turning a '
      'switch off removes that image with removeStyleImage, so the pin '
      'referencing it disappears; turning it back on re-adds it.',
      style: TextStyle(
        fontSize: 11,
        height: 1.35,
        color: MapboxGlass.labelFaint,
      ),
    ),
  ];

  List<Widget> _vectorControls() => [
    for (final flag in _flags)
      ControlAction(
        label: flag.$2,
        icon: Icons.flag,
        onPressed: () => _selectFlag(flag.$1),
      ),
    const SizedBox(height: 4),
    const Text(
      'Each flag is the same parameterized SVG, colored per-feature with '
      'an image expression. Tap a flag or its button to grow it.',
      style: TextStyle(
        fontSize: 11,
        height: 1.35,
        color: MapboxGlass.labelFaint,
      ),
    ),
  ];
}

const _flags = [
  ('flag-red', 'Red flag', 'red'),
  ('flag-yellow', 'Yellow flag', 'yellow'),
  ('flag-purple', 'Purple flag', '#800080'),
];

/// Where each flag sits, in `_flags` order.
const _flagPositions = [
  (24.68727, 60.185755),
  (24.68827, 60.186255),
  (24.68927, 60.186055),
];

Map<String, dynamic> _flagFeature(
  String id,
  String color,
  (double, double) position,
) {
  final (lng, lat) = position;
  return {
    'type': 'Feature',
    'id': id,
    'geometry': {
      'type': 'Point',
      'coordinates': [lng, lat],
    },
    // `flagId` duplicates the feature id as a property, because GL JS keeps
    // only numeric feature ids. A property survives on every platform.
    'properties': {'flagId': id, 'flagColor': color},
  };
}
