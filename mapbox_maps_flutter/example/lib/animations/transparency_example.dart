import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
// The SDK exports its own Size, which shadows the Flutter geometry Size
// used by the CustomPainters below.
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;

import '../scene_scaffold.dart';

/// A transparent map surface compositing with Flutter widgets behind it.
///
/// `MapWidget.isOpaque: false` is required on iOS and
/// `MapWidget.textureView: true` on Android. Both are only read when the
/// platform view is created, so each scene mounts a fresh map.
class TransparencyExample extends StatefulWidget {
  const TransparencyExample({super.key});

  @override
  State<TransparencyExample> createState() => _TransparencyExampleState();
}

enum _Backdrop { globe, sea }

const _scenes = [
  Scene(
    id: 'globe',
    title: 'Globe in space',
    subtitle: 'Starfield behind a transparent globe',
    icon: Icons.public,
  ),
  Scene(
    id: 'sea',
    title: 'Animated sea',
    subtitle: 'Waves show through unpainted water',
    icon: Icons.waves,
  ),
];

class _TransparencyExampleState extends State<TransparencyExample>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  final _random = Random();

  late final List<_Star> _stars = List.generate(
    200,
    (_) => _Star(
      Offset(_random.nextDouble(), _random.nextDouble()),
      _random.nextDouble() * 1.6 + 0.6,
    ),
  );

  late final List<_ShootingStar> _shootingStars = List.generate(
    6,
    (i) => _ShootingStar(
      start: Offset(_random.nextDouble(), _random.nextDouble() * 0.5),
      angle: pi / 4 + _random.nextDouble() * 0.3,
      delay: i / 6,
    ),
  );

  MapboxMap? _mapboxMap;

  var _backdrop = _Backdrop.globe;
  var _showBackdrop = true;

  /// Whether the backdrop behind the map can be shown.
  ///
  /// Waits for `mapLoaded`, the first event that means the style and the first
  /// tiles are in. A timer backs it up, so a stalled style cannot leave the
  /// scene empty.
  var _revealBackdrop = false;
  Timer? _revealTimer;

  @override
  void initState() {
    super.initState();
    _armReveal();
  }

  /// Reveals the backdrop even if no style event arrives.
  void _armReveal() {
    _revealTimer?.cancel();
    _revealTimer = Timer(const Duration(seconds: 4), _reveal);
  }

  @override
  void dispose() {
    _revealTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _reveal() {
    _revealTimer?.cancel();
    if (_revealBackdrop || !mounted) return;
    setState(() => _revealBackdrop = true);
  }

  void _onMapLoaded(MapLoadedEventData _) => _reveal();

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
    final asset = _backdrop == _Backdrop.globe
        ? 'assets/transparent_globe_style.json'
        : 'assets/transparent_style.json';
    await mapboxMap.setStyleJSON(await rootBundle.loadString(asset));

    if (_backdrop == _Backdrop.sea) {
      // Lock the camera so the coastline stays aligned with the waves.
      await mapboxMap.gestures.updateSettings(
        GesturesSettings(
          rotateEnabled: false,
          pinchToZoomEnabled: false,
          scrollEnabled: false,
          pitchEnabled: false,
          doubleTapToZoomInEnabled: false,
          doubleTouchToZoomOutEnabled: false,
          quickZoomEnabled: false,
          pinchPanEnabled: false,
        ),
      );
    }
  }

  Widget _buildBackdrop() {
    if (_backdrop == _Backdrop.sea) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) =>
            CustomPaint(painter: _WavesPainter(_controller.value)),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(painter: _StarfieldPainter(_stars)),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _ShootingStarsPainter(_shootingStars, _controller),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGlobe = _backdrop == _Backdrop.globe;
    return SceneScaffold(
      scenes: _scenes,
      selectedSceneId: _backdrop.name,
      onSceneSelected: (id) => setState(() {
        _backdrop = _Backdrop.values.firstWhere(
          (backdrop) => backdrop.name == id,
        );
        // The map remounts for the new scene, so hide the backdrop until its
        // style loads again.
        _revealBackdrop = false;
        _armReveal();
      }),
      controlsTitle: 'Transparency',
      controlsSheetSize: ControlsSheetSize.small,
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: ColoredBox(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Not built until the map has loaded: hiding it with opacity
            // would still paint one frame on a scene switch.
            if (_showBackdrop && _revealBackdrop)
              // Keyed per scene, so each backdrop runs its own fade-in. The
              // prefix keeps it unique among its siblings.
              _FadeIn(
                key: ValueKey('backdrop-${_backdrop.name}'),
                child: _buildBackdrop(),
              ),
            MapWidget(
              // The key remounts the platform view when the scene changes,
              // because isOpaque and textureView are create-time only.
              key: ValueKey('map-${_backdrop.name}'),
              isOpaque: false,
              textureView: true,
              // Avoid flashing the default style before onMapCreated swaps it.
              styleUri: '',
              onMapCreated: _onMapCreated,
              onMapLoadedListener: _onMapLoaded,
              viewport: isGlobe
                  ? CameraViewportState(
                      center: Point(coordinates: Position(0, 0)),
                      zoom: 0.2,
                    )
                  : CameraViewportState(
                      center: Point(coordinates: Position(21.9081, 60.1936)),
                      zoom: 11,
                    ),
            ),
          ],
        ),
      ),
      controlsBuilder: () => [
        ControlSwitch(
          label: 'Flutter backdrop',
          icon: Icons.layers_outlined,
          value: _showBackdrop,
          onChanged: (value) => setState(() => _showBackdrop = value),
        ),
        const SizedBox(height: 6),
        Text(
          isGlobe
              ? 'The style paints no background or sky, so space around the '
                    'globe is transparent and the starfield shows through.'
              : 'The style leaves the sea unpainted, so the waves show '
                    'through the water while land stays opaque.',
          style: const TextStyle(
            fontSize: 11,
            height: 1.35,
            color: MapboxGlass.labelFaint,
          ),
        ),
      ],
    );
  }
}

class _Star {
  final Offset position;
  final double radius;

  _Star(this.position, this.radius);
}

class _StarfieldPainter extends CustomPainter {
  final List<_Star> stars;

  _StarfieldPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    for (final star in stars) {
      canvas.drawCircle(
        Offset(star.position.dx * size.width, star.position.dy * size.height),
        star.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => false;
}

class _ShootingStar {
  final Offset start;
  final double angle;
  final double delay;

  _ShootingStar({
    required this.start,
    required this.angle,
    required this.delay,
  });
}

class _ShootingStarsPainter extends CustomPainter {
  final List<_ShootingStar> stars;
  final Animation<double> animation;

  _ShootingStarsPainter(this.stars, this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final t = (animation.value + star.delay) % 1.0;
      // Fade in over the first 15% of the flight and out over the last 15%.
      final double opacity;
      if (t < 0.15) {
        opacity = t / 0.15;
      } else if (t > 0.85) {
        opacity = (1.0 - t) / 0.15;
      } else {
        opacity = 1.0;
      }
      if (opacity <= 0) continue;

      final travel = size.longestSide * 1.3;
      final dx = cos(star.angle);
      final dy = sin(star.angle);
      final headX = star.start.dx * size.width + dx * travel * t;
      final headY = star.start.dy * size.height + dy * travel * t;
      final tailX = headX - dx * 90;
      final tailY = headY - dy * 90;

      final paint = Paint()
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.linear(
          Offset(tailX, tailY),
          Offset(headX, headY),
          [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: opacity),
          ],
        );
      canvas.drawLine(Offset(tailX, tailY), Offset(headX, headY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ShootingStarsPainter oldDelegate) => true;
}

class _WavesPainter extends CustomPainter {
  final double t;

  _WavesPainter(this.t);

  // A small wave cell that tiles across the canvas, for a fine texture.
  static const _cellWidth = 26.0; // horizontal wavelength of one ripple
  static const _rowHeight = 12.0; // vertical spacing between ripple rows
  static const _amplitude = 3.0; // how tall each ripple is

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF021A30),
    );

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    var row = 0;
    for (double y = _rowHeight; y < size.height; y += _rowHeight, row++) {
      // Alternate drift direction and color per row.
      final dir = row.isEven ? 1.0 : -1.0;
      final drift = t * _cellWidth * dir;
      stroke.color = row.isEven
          ? const Color(0xFF2E86B8).withValues(alpha: 0.85)
          : const Color(0xFF7FD4F0).withValues(alpha: 0.7);

      final path = Path();
      for (double x = -_cellWidth; x <= size.width + _cellWidth; x += 3) {
        final phase = ((x + drift) / _cellWidth) * 2 * pi;
        final wy = y + sin(phase) * _amplitude;
        if (x <= -_cellWidth) {
          path.moveTo(x, wy);
        } else {
          path.lineTo(x, wy);
        }
      }
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _WavesPainter oldDelegate) => oldDelegate.t != t;
}

/// Fades its child in once, on first build.
///
/// An [AnimatedOpacity] would instead flash when it animates back down on a
/// scene change.
class _FadeIn extends StatefulWidget {
  const _FadeIn({super.key, required this.child});

  final Widget child;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> {
  var _opaque = false;

  @override
  void initState() {
    super.initState();
    // Next frame, so the transition has a 0 -> 1 change to animate.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _opaque = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opaque ? 1 : 0,
      duration: const Duration(milliseconds: 400),
      child: widget.child,
    );
  }
}
