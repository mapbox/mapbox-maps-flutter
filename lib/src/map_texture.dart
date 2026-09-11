part of '../mapbox_maps_flutter.dart';

/// A map that is not a platform view.
///
/// [MapWidget] puts a `UiKitView` in the tree. UIKit composites that view, not
/// flutter, so nothing painted above it can read it: backdrop filters, shaders
/// and `toImageSync` captures all come back empty. Android avoids this by
/// rendering the map into a `TextureView`.
///
/// [MapTexture] is that mode for ios. The map is created without a platform
/// view and its frames go to a flutter texture, so the widget tree contains a
/// [Texture] and composites like any other widget.
///
/// The trade is that flutter owns the hit test, so gestures are forwarded
/// rather than handled by the map's own recognisers. Pan and pinch are wired;
/// rotate and pitch are not yet.
class MapTexture extends StatefulWidget {
  const MapTexture({
    super.key,
    this.styleUri,
    this.onMapCreated,
    this.gesturesEnabled = true,
  });

  /// Style to load, defaults to the sdk's standard style.
  final String? styleUri;

  /// Called once with a [MapboxMap] bound to this map. Same api surface as the
  /// one [MapWidget] hands back.
  final void Function(MapboxMap map)? onMapCreated;

  /// Forward pan and pinch to the map. Turn off to drive the camera yourself.
  final bool gesturesEnabled;

  @override
  State<MapTexture> createState() => _MapTextureState();
}

class _MapTextureState extends State<MapTexture> {
  static const _channel =
      MethodChannel('plugins.flutter.io/mapbox_maps_headless');
  static int _nextSuffix = 90000;

  int? _textureId;
  ui.Size? _size;
  Timer? _pump;
  bool _creating = false;
  double _lastRotation = 0;
  Offset? _lastFocal;
  Uint8List? _ornaments;

  @override
  void dispose() {
    _pump?.cancel();
    final id = _textureId;
    if (id != null) {
      _channel.invokeMethod<void>('dispose', {'textureId': id});
    }
    super.dispose();
  }

  Future<void> _create(ui.Size size) async {
    _creating = true;
    final suffix = _nextSuffix++;
    final id = await _channel.invokeMethod<int>('create', {
      'width': size.width,
      'height': size.height,
      'styleUri': widget.styleUri,
      'channelSuffix': suffix,
    });
    if (!mounted || id == null || id < 0) return;
    setState(() {
      _textureId = id;
      _size = size;
    });
    widget.onMapCreated?.call(MapboxMap.headless(channelSuffix: suffix));
    _loadOrnaments(id);
    // the map draws on demand, so a still map stops vending frames and the
    // texture freezes on whatever it last published.
    _pump = Timer.periodic(const Duration(milliseconds: 33), (_) {
      _channel.invokeMethod<void>('pump', {'textureId': id});
    });
  }

  /// The logo and attribution are UIKit views, so they are not in the map's
  /// Metal output. Mapbox's terms require them on screen, so they are
  /// rasterised on the host and drawn here over the texture.
  Future<void> _loadOrnaments(int id) async {
    // the ornaments are laid out by uikit, so wait for a frame rather than
    // guessing at a delay
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    final bytes = await _channel
        .invokeMethod<Uint8List>('ornaments', {'textureId': id});
    if (!mounted || bytes == null) return;
    setState(() => _ornaments = bytes);
  }

  void _resize(ui.Size size) {
    _size = size;
    _channel.invokeMethod<void>('resize', {
      'textureId': _textureId,
      'width': size.width,
      'height': size.height,
    });
  }

  void _send(String method, [Map<String, Object?> extra = const {}]) {
    _channel.invokeMethod<void>(method, {'textureId': _textureId, ...extra});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = ui.Size(constraints.maxWidth, constraints.maxHeight);
        if (_textureId == null) {
          if (!_creating && size.width > 0 && size.height > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _create(size));
          }
          return const SizedBox.expand();
        }
        if (_size != size) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _resize(size));
        }
        final ornaments = _ornaments;
        final texture = ornaments == null
            ? Texture(textureId: _textureId!)
            : Stack(
                fit: StackFit.expand,
                children: [
                  Texture(textureId: _textureId!),
                  IgnorePointer(child: Image.memory(ornaments)),
                ],
              );
        if (!widget.gesturesEnabled) return texture;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: (d) {
            _lastRotation = 0;
            _lastFocal = d.localFocalPoint;
            _send('panBegin', {
              'x': d.localFocalPoint.dx,
              'y': d.localFocalPoint.dy,
            });
          },
          onScaleUpdate: (d) {
            final x = d.localFocalPoint.dx;
            final y = d.localFocalPoint.dy;

            // two fingers moving together, vertically, with no spread and no
            // twist, is the sdk's pitch gesture. checked first because the
            // same fingers would otherwise read as an ordinary pan.
            final twoFingers = d.pointerCount >= 2;
            final still = (d.scale - 1).abs() < 0.02 && d.rotation.abs() < 0.02;
            if (twoFingers && still && _lastFocal != null) {
              final dy = y - _lastFocal!.dy;
              if (dy.abs() > 0.5) {
                _send('pitchBy', {'delta': -dy * 0.25});
                _lastFocal = Offset(x, y);
                return;
              }
            }
            _lastFocal = Offset(x, y);

            _send('panUpdate', {'x': x, 'y': y});
            if ((d.scale - 1).abs() > 0.01) {
              _send('zoomBy', {'delta': (d.scale - 1) * 0.5, 'x': x, 'y': y});
            }
            if (d.rotation.abs() > 0.01) {
              _send('rotateBy',
                  {'radians': d.rotation - _lastRotation, 'x': x, 'y': y});
              _lastRotation = d.rotation;
            }
          },
          onScaleEnd: (_) => _send('panEnd'),
          child: texture,
        );
      },
    );
  }
}
