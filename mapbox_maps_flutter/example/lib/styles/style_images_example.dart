import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;

import '../scene_scaffold.dart';

/// Every way to put a custom image on the map, one scene each.
///
/// - **Runtime images** adds both [StyleImage] variants with `addImage`,
///   replaces them in place or with a new size, and reads them back with
///   `getImage`.
/// - **SDF icons** recolors one signed-distance-field image at runtime.
/// - **Stretchable labels** grows a 9-patch bubble around its text with
///   `stretchX`, `stretchY` and `content`.
/// - **Pixel ratio** shows one bitmap added at three `scale` values.
/// - **Missing images** draws icons on demand from `onStyleImageMissing`.
/// - **Vector icons** colors one parameterized SVG from the style per feature.
/// - **Image source** animates an image source with `updateImageForSource`.
class StyleImagesExample extends StatefulWidget {
  const StyleImagesExample({super.key});

  @override
  State<StyleImagesExample> createState() => _StyleImagesExampleState();
}

enum _Scene { runtime, sdf, stretch, pixelRatio, missing, vector, imageSource }

const _scenes = [
  Scene(
    id: 'runtime',
    title: 'Runtime images',
    subtitle: 'Add, replace, remove and read back rgba & bytes',
    icon: Icons.image_outlined,
  ),
  Scene(
    id: 'sdf',
    title: 'SDF icons',
    subtitle: 'Recolor one icon and its halo live',
    icon: Icons.format_color_fill,
  ),
  Scene(
    id: 'stretch',
    title: 'Stretchable labels',
    subtitle: 'A 9-patch bubble that fits its text',
    icon: Icons.chat_bubble_outline,
  ),
  Scene(
    id: 'pixelRatio',
    title: 'Pixel ratio',
    subtitle: 'One bitmap at scale 1, 2 and 3',
    icon: Icons.photo_size_select_large,
  ),
  Scene(
    id: 'missing',
    title: 'Missing images',
    subtitle: 'Draw icons on demand when the style asks',
    icon: Icons.help_outline,
  ),
  Scene(
    id: 'vector',
    title: 'Vector icons',
    subtitle: 'Colorize a parameterized SVG, tap to grow',
    icon: Icons.flag_outlined,
  ),
  Scene(
    id: 'imageSource',
    title: 'Image source',
    subtitle: 'Animate a radar sweep frame by frame',
    icon: Icons.radar,
  ),
];

/// Where each scene sits on the map.
const _sceneCenters = {
  _Scene.runtime: (0.0, 0.0),
  _Scene.sdf: (-60.0, 30.0),
  _Scene.stretch: (60.0, 30.0),
  _Scene.pixelRatio: (0.0, -30.0),
  _Scene.missing: (-60.0, -30.0),
  _Scene.vector: (24.6881, 60.185755),
  _Scene.imageSource: (60.0, -30.0),
};

class _StyleImagesExampleState extends State<StyleImagesExample> {
  static const _rgbaImageId = 'gradient';
  static const _bytesImageId = 'png-icon';
  static const _runtimeLayerId = 'runtime-points';
  static const _sdfImageId = 'sdf-pin';
  static const _sdfLayerId = 'sdf-pins';
  static const _bubbleImageId = 'bubble';
  static const _bubbleLayerId = 'bubbles';
  static const _pixelRatioLayerId = 'pixel-ratio';
  static const _badgePrefix = 'badge-';
  static const _badgeCount = 12;
  static const _missingLayerId = 'badges';
  static const _vectorLayerId = 'vector-points';
  static const _radarSourceId = 'radar';
  static const _radarSize = 192;

  final _viewportController = ViewportController();

  MapboxMap? _mapboxMap;
  var _scene = _Scene.runtime;

  // Runtime images.
  final Map<String, String> _status = {};
  final Map<String, bool> _visible = {_rgbaImageId: true, _bytesImageId: true};
  var _gradientSize = 64;
  var _gradientHue = 0.0;
  ui.Image? _readBack;
  String? _readBackLabel;

  // SDF icons.
  var _sdfColor = _sdfColors.keys.first;
  var _haloWidth = 2.0;

  // Stretchable labels.
  final _bubbleText = TextEditingController(text: 'Hello, stretchy world!');

  // Missing images.
  var _missingCount = 0;
  final List<String> _missingIds = [];

  // Vector icons.
  String? _selectedFlagId;

  // Image source.
  Timer? _radarTimer;
  var _radarPlaying = true;
  var _radarSpeed = 1.0;
  var _radarAngle = 0.0;
  var _radarFrames = 0;
  var _radarBusy = false;

  /// Only read from callbacks that the map itself drives, so it is set by then.
  MapboxMap get map => _mapboxMap!;

  @override
  void dispose() {
    _radarTimer?.cancel();
    _bubbleText.dispose();
    _readBack?.dispose();
    super.dispose();
  }

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
    await _addSdfSymbols();
    await _addBubbleSymbols();
    await _addPixelRatioSymbols();
    await _addMissingSymbols();
    await _addFlagSymbols();
    await _addRadar();
    _flyToScene();
  }

  void _selectScene(String id) {
    setState(() => _scene = _Scene.values.firstWhere((s) => s.name == id));
    _flyToScene();
  }

  void _flyToScene() {
    final (lng, lat) = _sceneCenters[_scene]!;
    _viewportController.moveTo(
      CameraViewportState(
        center: Point(coordinates: Position(lng, lat)),
        zoom: _scene == _Scene.vector ? 16 : 3,
        pitch: 0,
        bearing: 0,
      ),
      transition: FlyViewportTransition(
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  /// Adds a GeoJSON source with one point per entry of [points], at an
  /// offset in degrees from the center of [scene].
  Future<void> _addPoints(
    String sourceId,
    _Scene scene,
    List<((double, double), Map<String, Object>)> points,
  ) {
    final (lng, lat) = _sceneCenters[scene]!;
    return map.addSource(
      GeoJsonSource(
        id: sourceId,
        data: json.encode({
          'type': 'FeatureCollection',
          'features': [
            for (final ((dx, dy), properties) in points)
              {
                'type': 'Feature',
                'geometry': {
                  'type': 'Point',
                  'coordinates': [lng + dx, lat + dy],
                },
                'properties': properties,
              },
          ],
        }),
      ),
    );
  }

  // --- Runtime images -------------------------------------------------

  Future<void> _addRuntimeSymbols() async {
    // The images must exist before the layer that references them: gl-js
    // resolves `icon-image` when the layer is added, and does not repaint.
    await _addImage(_rgbaImageId);
    await _addImage(_bytesImageId);

    await _addPoints(_runtimeLayerId, _Scene.runtime, [
      ((-6, 0), {'icon': _rgbaImageId}),
      ((6, 0), {'icon': _bytesImageId}),
    ]);
    await map.addLayer(
      SymbolLayer(
        id: _runtimeLayerId,
        sourceId: _runtimeLayerId,
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
        _gradient(_gradientSize, _gradientHue),
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

  /// Replaces the gradient with new colors and the same size.
  Future<void> _recolorGradient() async {
    _gradientHue = (_gradientHue + 60) % 360;
    await _addImage(_rgbaImageId);
  }

  /// Replaces the gradient with a new size, between 32 and 128 pixels.
  Future<void> _resizeGradient() async {
    _gradientSize = _gradientSize >= 128 ? 32 : _gradientSize * 2;
    await _addImage(_rgbaImageId);
  }

  /// Confirms an image's state with `hasStyleImage` and `getImage`.
  Future<void> _refreshStatus(String id) async {
    if (_mapboxMap == null) return;
    final hasImage = await map.hasStyleImage(id);
    final rgba = hasImage ? await map.getImage(id) : null;
    final line =
        'hasStyleImage=$hasImage · getImage='
        '${rgba == null ? 'null' : '${rgba.width}x${rgba.height}'}';
    if (!mounted) return;
    setState(() => _status[id] = line);
  }

  /// Reads [id] back with `getImage` and shows the pixels on screen.
  Future<void> _inspect(String id) async {
    final rgba = await map.getImage(id);
    final image = rgba == null ? null : await _decodeRgba(rgba);
    if (!mounted) {
      image?.dispose();
      return;
    }
    setState(() {
      _readBack?.dispose();
      _readBack = image;
      _readBackLabel = rgba == null
          ? '$id: getImage returned null'
          : '$id: ${rgba.width}x${rgba.height} px';
    });
  }

  // --- SDF icons ------------------------------------------------------

  Future<void> _addSdfSymbols() async {
    // An SDF image stores distance to the shape edge in alpha. A soft edge
    // works as a simple approximation for a solid shape.
    final pin = await _paint(48, 48, (canvas, size) {
      canvas.drawCircle(
        size.center(Offset.zero),
        18,
        Paint()
          ..color = Colors.white
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    });
    await map.addImage(_sdfImageId, 1.0, pin, sdf: true);

    await _addPoints(_sdfLayerId, _Scene.sdf, [
      for (var i = 0; i < 5; i++) ((i * 4.0 - 8, (i.isEven ? 2.0 : -2.0)), {}),
    ]);
    await map.addLayer(
      SymbolLayer(
        id: _sdfLayerId,
        sourceId: _sdfLayerId,
        iconImage: _sdfImageId,
        iconAllowOverlap: true,
        iconSize: 1.5,
      ),
    );
    await _applySdfPaint();
  }

  Future<void> _applySdfPaint() async {
    await map.setStyleLayerProperty(
      _sdfLayerId,
      'icon-color',
      _sdfColors[_sdfColor]!,
    );
    await map.setStyleLayerProperty(_sdfLayerId, 'icon-halo-color', '#ffffff');
    await map.setStyleLayerProperty(_sdfLayerId, 'icon-halo-width', _haloWidth);
  }

  // --- Stretchable labels ---------------------------------------------

  Future<void> _addBubbleSymbols() async {
    // A 48x48 rounded rectangle. Only the middle band stretches, so the
    // rounded corners keep their shape at any size. The text goes inside
    // the content box.
    final bubble = await _paint(48, 48, (canvas, size) {
      final rect = RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(12),
      );
      canvas.drawRRect(rect, Paint()..color = MapboxColors.blue50);
      canvas.drawRRect(
        rect.deflate(2),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    });
    await map.addImage(
      _bubbleImageId,
      1.0,
      bubble,
      stretchX: [ImageStretches(first: 14, second: 34)],
      stretchY: [ImageStretches(first: 14, second: 34)],
      content: ImageContent(left: 10, top: 10, right: 38, bottom: 38),
    );

    await _addPoints(_bubbleLayerId, _Scene.stretch, [((0, 0), {})]);
    await map.addLayer(
      SymbolLayer(
        id: _bubbleLayerId,
        sourceId: _bubbleLayerId,
        iconImage: _bubbleImageId,
        iconTextFit: IconTextFit.BOTH,
        textField: _bubbleText.text,
        textColor: Colors.white.toARGB32(),
        textSize: 18,
        iconAllowOverlap: true,
        textAllowOverlap: true,
      ),
    );
  }

  Future<void> _setBubbleText(String text) => map.setStyleLayerProperty(
    _bubbleLayerId,
    'text-field',
    text.isEmpty ? ' ' : text,
  );

  // --- Pixel ratio ----------------------------------------------------

  Future<void> _addPixelRatioSymbols() async {
    final pixelRatios = [1.0, 2.0, 3.0];
    final checker = await _paint(48, 48, (canvas, size) {
      const cells = 6;
      final cell = size.width / cells;
      for (var x = 0; x < cells; x++) {
        for (var y = 0; y < cells; y++) {
          canvas.drawRect(
            Rect.fromLTWH(x * cell, y * cell, cell, cell),
            Paint()
              ..color = (x + y).isEven ? MapboxColors.blue50 : Colors.white,
          );
        }
      }
    });
    for (final ratio in pixelRatios) {
      await map.addImage('checker@${ratio.toInt()}x', ratio, checker);
    }

    await _addPoints(_pixelRatioLayerId, _Scene.pixelRatio, [
      for (var i = 0; i < pixelRatios.length; i++)
        (
          (i * 8.0 - 8, 0.0),
          {
            'icon': 'checker@${pixelRatios[i].toInt()}x',
            'label': 'scale ${pixelRatios[i].toInt()}',
          },
        ),
    ]);
    await map.addLayer(
      SymbolLayer(
        id: _pixelRatioLayerId,
        sourceId: _pixelRatioLayerId,
        iconImageExpression: ['get', 'icon'],
        textFieldExpression: ['get', 'label'],
        textOffset: [0, 3],
        textSize: 14,
        iconAllowOverlap: true,
        textAllowOverlap: true,
      ),
    );
  }

  // --- Missing images -------------------------------------------------

  Future<void> _addMissingSymbols() async {
    await _addPoints(_missingLayerId, _Scene.missing, [
      for (var i = 0; i < _badgeCount; i++)
        (((i % 4) * 4.0 - 6, (i ~/ 4) * -4.0 + 4), {'n': i + 1}),
    ]);
    await map.addLayer(
      SymbolLayer(
        id: _missingLayerId,
        sourceId: _missingLayerId,
        // None of these images exist: each one fires onStyleImageMissing.
        iconImageExpression: [
          'concat',
          _badgePrefix,
          [
            'to-string',
            ['get', 'n'],
          ],
        ],
        iconAllowOverlap: true,
      ),
    );
  }

  /// Draws the badge that the style asks for, so the symbol can render.
  Future<void> _onStyleImageMissing(StyleImageMissingEventData event) async {
    final id = event.id;
    if (!id.startsWith(_badgePrefix)) return;
    final n = int.tryParse(id.substring(_badgePrefix.length)) ?? 0;
    setState(() {
      _missingCount++;
      _missingIds.insert(0, id);
      if (_missingIds.length > 4) _missingIds.removeLast();
    });

    final color = HSVColor.fromAHSV(1, (n * 30) % 360, 0.7, 0.9).toColor();
    final badge = await _paint(40, 40, (canvas, size) {
      final center = size.center(Offset.zero);
      canvas.drawCircle(center, 18, Paint()..color = color);
      canvas.drawCircle(
        center,
        18,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      final text = TextPainter(
        text: TextSpan(
          text: '$n',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(canvas, center - Offset(text.width / 2, text.height / 2));
    });
    await map.addImage(id, 1.0, badge);
  }

  /// Removes every badge, so the style asks for them again.
  Future<void> _resetBadges() async {
    setState(() {
      _missingCount = 0;
      _missingIds.clear();
    });
    for (var n = 1; n <= _badgeCount; n++) {
      final id = '$_badgePrefix$n';
      if (await map.hasStyleImage(id)) await map.removeStyleImage(id);
    }
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
      GeoJsonSource(id: _vectorLayerId, data: json.encode(geojson)),
    );

    await map.addLayer(
      SymbolLayer(
        id: _vectorLayerId,
        sourceId: _vectorLayerId,
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

  // --- Image source ---------------------------------------------------

  Future<void> _addRadar() async {
    final (lng, lat) = _sceneCenters[_Scene.imageSource]!;
    // Web Mercator stretches latitude away from the equator. Span the same
    // projected distance on both axes, so the image stays square on screen.
    const half = 8.0;
    double mercatorY(double lat) =>
        math.log(math.tan(math.pi / 4 + lat * math.pi / 360));
    double latitude(double y) =>
        (2 * math.atan(math.exp(y)) - math.pi / 2) * 180 / math.pi;
    final halfY = half * math.pi / 180;
    final north = latitude(mercatorY(lat) + halfY);
    final south = latitude(mercatorY(lat) - halfY);
    await map.addSource(
      ImageSource(
        id: _radarSourceId,
        coordinates: [
          [lng - half, north],
          [lng + half, north],
          [lng + half, south],
          [lng - half, south],
        ],
      ),
    );
    await map.addLayer(
      RasterLayer(
        id: _radarSourceId,
        sourceId: _radarSourceId,
        rasterFadeDuration: 0,
      ),
    );
    await _drawRadarFrame();
    _startRadar();
  }

  void _startRadar() {
    _radarTimer?.cancel();
    if (!_radarPlaying) return;
    _radarTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _drawRadarFrame(),
    );
  }

  /// Draws the next frame and sends it as raw RGBA, which needs no image
  /// encoding in Flutter.
  Future<void> _drawRadarFrame() async {
    if (_radarBusy || !mounted) return;
    _radarBusy = true;
    try {
      _radarAngle = (_radarAngle + 0.15 * _radarSpeed) % (2 * math.pi);
      final picture = _radarPicture(_radarAngle);
      final image = await picture.toImage(_radarSize, _radarSize);
      picture.dispose();
      // `rawRgba` is premultiplied, as StyleImage.rgba expects.
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      image.dispose();
      await map.updateImageForSource(
        _radarSourceId,
        StyleImage.rgba(
          width: _radarSize,
          height: _radarSize,
          pixels: data!.buffer.asUint8List(),
        ),
      );
      if (mounted) setState(() => _radarFrames++);
    } finally {
      _radarBusy = false;
    }
  }

  ui.Picture _radarPicture(double angle) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size.square(_radarSize.toDouble());
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 4;
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xCC062A1A));
    for (final r in [radius / 3, radius * 2 / 3, radius]) {
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..color = const Color(0xFF2EE68A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
    // A sweep gradient takes angles in [0, 2π] only, so the sweep is drawn
    // at a fixed angle and the canvas turns instead. This avoids a seam
    // where the angle wraps around.
    const trail = 0.8;
    canvas
      ..translate(center.dx, center.dy)
      ..rotate(angle - trail);
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: radius),
      0,
      trail,
      true,
      Paint()
        ..shader = ui.Gradient.sweep(
          Offset.zero,
          const [Color(0x002EE68A), Color(0xCC2EE68A)],
          null,
          TileMode.clamp,
          0,
          trail,
        ),
    );
    return recorder.endRecording();
  }

  // --- Build ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      scenes: _scenes,
      selectedSceneId: _scene.name,
      onSceneSelected: _selectScene,
      controlsTitle: 'Style images',
      controlsSheetSize: ControlsSheetSize.medium,
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
              zoom: 3,
            ),
            viewportController: _viewportController,
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
            onStyleImageMissingListener: _onStyleImageMissing,
          ),
          _hud(),
        ],
      ),
      controlsBuilder: () => switch (_scene) {
        _Scene.runtime => _runtimeControls(),
        _Scene.sdf => _sdfControls(),
        _Scene.stretch => _stretchControls(),
        _Scene.pixelRatio => _pixelRatioControls(),
        _Scene.missing => _missingControls(),
        _Scene.vector => _vectorControls(),
        _Scene.imageSource => _imageSourceControls(),
      },
    );
  }

  Widget _hud() => switch (_scene) {
    _Scene.runtime => MapHud(
      title: 'Image status',
      rows: [
        MapHudRow(_rgbaImageId, _status[_rgbaImageId] ?? 'not added yet'),
        MapHudRow(_bytesImageId, _status[_bytesImageId] ?? 'not added yet'),
        if (_readBackLabel != null)
          MapHudRow('read back', _readBackLabel!, emphasized: true),
      ],
    ),
    _Scene.missing => MapHud(
      title: 'onStyleImageMissing',
      rows: [
        MapHudRow('events', '$_missingCount', emphasized: true),
        MapHudRow(
          'latest',
          _missingIds.isEmpty ? 'none yet' : _missingIds.join(', '),
        ),
      ],
    ),
    _Scene.vector => MapHud(
      title: 'Vector icons',
      rows: [
        MapHudRow(
          'selected',
          _flags
                  .where((flag) => flag.$1 == _selectedFlagId)
                  .map((flag) => flag.$2)
                  .firstOrNull ??
              'none',
          emphasized: true,
        ),
      ],
    ),
    _Scene.imageSource => MapHud(
      title: 'updateImageForSource',
      rows: [MapHudRow('frames', '$_radarFrames', emphasized: true)],
    ),
    _ => const SizedBox.shrink(),
  };

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
    ControlAction(
      label: 'Recolor gradient (same size)',
      icon: Icons.palette_outlined,
      onPressed: _recolorGradient,
    ),
    ControlAction(
      label: 'Resize gradient ($_gradientSize px)',
      icon: Icons.open_in_full,
      onPressed: _resizeGradient,
    ),
    ControlAction(
      label: 'Read back gradient',
      icon: Icons.visibility_outlined,
      onPressed: () => _inspect(_rgbaImageId),
    ),
    ControlAction(
      label: 'Read back PNG icon',
      icon: Icons.visibility_outlined,
      onPressed: () => _inspect(_bytesImageId),
    ),
    if (_readBack != null)
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: SizedBox.square(
          dimension: 64,
          child: RawImage(image: _readBack, fit: BoxFit.contain),
        ),
      ),
    _hint(
      'The left pin is a StyleImage.rgba gradient made at runtime, the '
      'right pin a StyleImage.bytes PNG asset. addImage on an existing id '
      'replaces the image. "Read back" shows the getImage pixels.',
    ),
  ];

  List<Widget> _sdfControls() => [
    ControlChoices<String>(
      options: {for (final name in _sdfColors.keys) name: name},
      value: _sdfColor,
      columns: 4,
      onChanged: (name) {
        setState(() => _sdfColor = name);
        _applySdfPaint();
      },
    ),
    ControlSlider(
      label: 'Halo width',
      value: _haloWidth,
      min: 0,
      max: 6,
      onChanged: (value) {
        setState(() => _haloWidth = value);
        _applySdfPaint();
      },
    ),
    _hint(
      'One white image added with sdf: true. icon-color and the halo '
      'restyle it with no new image.',
    ),
  ];

  List<Widget> _stretchControls() => [
    TextField(
      controller: _bubbleText,
      onChanged: _setBubbleText,
      decoration: const InputDecoration(labelText: 'Bubble text'),
    ),
    _hint(
      'stretchX and stretchY mark the middle band of the image, so the '
      'corners keep their shape. content is the box that the text fills, '
      'with icon-text-fit: both.',
    ),
  ];

  List<Widget> _pixelRatioControls() => [
    _hint(
      'The same 48 px checkerboard, added three times with scale 1, 2 and 3. '
      'A higher scale draws the image smaller and sharper.',
    ),
  ];

  List<Widget> _missingControls() => [
    ControlAction(
      label: 'Remove all badges',
      icon: Icons.refresh,
      onPressed: _resetBadges,
    ),
    _hint(
      'The layer refers to badge-1 … badge-12, which the style does not '
      'contain. onStyleImageMissing draws each badge when the map asks for '
      'it. Remove them to see the events again.',
    ),
  ];

  List<Widget> _vectorControls() => [
    for (final flag in _flags)
      ControlAction(
        label: flag.$2,
        icon: Icons.flag,
        onPressed: () => _selectFlag(flag.$1),
      ),
    _hint(
      'Each flag is the same parameterized SVG, colored per-feature with '
      'an image expression. Tap a flag or its button to grow it.',
    ),
  ];

  List<Widget> _imageSourceControls() => [
    ControlSwitch(
      label: 'Play',
      value: _radarPlaying,
      onChanged: (value) {
        setState(() => _radarPlaying = value);
        _startRadar();
      },
    ),
    ControlSlider(
      label: 'Speed',
      value: _radarSpeed,
      min: 0.25,
      max: 4,
      onChanged: (value) => setState(() => _radarSpeed = value),
    ),
    _hint(
      'Each frame is drawn in Flutter and sent as StyleImage.rgba with '
      'updateImageForSource.',
    ),
  ];

  Widget _hint(String text) => Padding(
    padding: const EdgeInsets.only(top: 4),
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

const _sdfColors = {
  'Blue': '#4264fb',
  'Coral': '#ff6f61',
  'Lime': '#7bd148',
  'Gold': '#f5c518',
};

/// Premultiplied RGBA gradient that turns its colors by [hue] degrees.
StyleImageRgba _gradient(int size, double hue) {
  final data = Uint8List(size * size * 4);
  for (var x = 0; x < size; x++) {
    for (var y = 0; y < size; y++) {
      final color = HSVColor.fromAHSV(
        1,
        (hue + 120 * x / size) % 360,
        0.4 + 0.6 * y / size,
        0.9,
      ).toColor();
      final offset = (y * size + x) * 4;
      data[offset] = (color.r * 255).round();
      data[offset + 1] = (color.g * 255).round();
      data[offset + 2] = (color.b * 255).round();
      data[offset + 3] = 255;
    }
  }
  return StyleImageRgba(width: size, height: size, pixels: data);
}

/// Paints a [width] x [height] image and returns its premultiplied pixels.
Future<StyleImageRgba> _paint(
  int width,
  int height,
  void Function(Canvas canvas, Size size) painter,
) async {
  final recorder = ui.PictureRecorder();
  painter(Canvas(recorder), Size(width.toDouble(), height.toDouble()));
  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  picture.dispose();
  // `rawRgba` is premultiplied, as StyleImage.rgba expects.
  final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  image.dispose();
  return StyleImageRgba(
    width: width,
    height: height,
    pixels: data!.buffer.asUint8List(),
  );
}

Future<ui.Image> _decodeRgba(StyleImageRgba rgba) {
  final completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    rgba.pixels,
    rgba.width,
    rgba.height,
    ui.PixelFormat.rgba8888,
    completer.complete,
  );
  return completer.future;
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
