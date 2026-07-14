import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;

import 'example.dart';

class TransparentGlobeExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.language);
  @override
  final String title = 'Transparent globe';
  @override
  final String subtitle =
      'isOpaque=false and textureView=true makes the map transparent, letting an animated Flutter-rendered space background show behind the globe.';

  @override
  State<StatefulWidget> createState() => _TransparentGlobeExampleState();
}

class _TransparentGlobeExampleState extends State<TransparentGlobeExample>
    with SingleTickerProviderStateMixin {
  late final AnimationController _skyController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  final List<_Star> _stars = List.generate(
    200,
    (_) => _Star(
      Offset(Random().nextDouble(), Random().nextDouble()),
      Random().nextDouble() * 1.6 + 0.6,
    ),
  );

  final List<_ShootingStar> _shootingStars = List.generate(
    6,
    (i) => _ShootingStar(
      start: Offset(Random().nextDouble(), Random().nextDouble() * 0.5),
      angle: pi / 4 + Random().nextDouble() * 0.3,
      delay: i / 6,
    ),
  );

  @override
  void dispose() {
    _skyController.dispose();
    super.dispose();
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    final json =
        await rootBundle.loadString('assets/transparent_globe_style.json');
    await mapboxMap.style.setStyleJSON(json);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      // The starfield and shooting stars below are plain Flutter widgets
      // painted *underneath* the map in this Stack. Because the map style
      // has no background/sky layers, when `MapWidget.isOpaque` is false, the
      // globe's surrounding space is transparent and the starfield shows through.
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _StarfieldPainter(_stars)),
          AnimatedBuilder(
            animation: _skyController,
            builder: (context, _) => CustomPaint(
              painter: _ShootingStarsPainter(_shootingStars, _skyController),
            ),
          ),
          // isOpaque is only read when the platform view is created, so the
          // ValueKey forces a remount whenever the switch below is toggled.
          MapWidget(
            isOpaque:
                false, // on iOS, isOpaque=false is required for transparency
            textureView:
                true, // on Android, TextureView is required for transparency
            styleUri:
                '', // avoid flashing the default style before onMapCreated swaps it out
            onMapCreated: _onMapCreated,
            viewport: CameraViewportState(
              center: Point(coordinates: Position(0, 0)),
              zoom: 0.2,
            ),
          ),
        ],
      ),
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
      final opacity = t < 0.15
          ? t / 0.15
          : t > 0.85
              ? (1.0 - t) / 0.15
              : 1.0;
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
