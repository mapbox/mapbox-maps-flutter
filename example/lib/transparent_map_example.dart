import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;

import 'example.dart';

class TransparentMapExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.waves);
  @override
  final String title = 'Transparent map background';
  @override
  final String subtitle =
      'isOpaque=false and textureView=true make the map transparent, letting an '
      'animated Flutter wave texture show through the sea while land stays opaque.';

  @override
  State<StatefulWidget> createState() => _TransparentMapExampleState();
}

class _TransparentMapExampleState extends State<TransparentMapExample>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat();

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    final json = await rootBundle.loadString('assets/transparent_style.json');
    await mapboxMap.style.setStyleJSON(json);

    // Lock the map: disable every gesture so the camera can't be moved.
    await mapboxMap.gestures.updateSettings(GesturesSettings(
      rotateEnabled: false,
      pinchToZoomEnabled: false,
      scrollEnabled: false,
      simultaneousRotateAndPinchToZoomEnabled: false,
      pitchEnabled: false,
      doubleTapToZoomInEnabled: false,
      doubleTouchToZoomOutEnabled: false,
      quickZoomEnabled: false,
      pinchPanEnabled: false,
      pinchToZoomDecelerationEnabled: false,
      rotateDecelerationEnabled: false,
      scrollDecelerationEnabled: false,
      increaseRotateThresholdWhenPinchingToZoom: false,
      increasePinchToZoomThresholdWhenRotating: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // The animated waves below are a plain Flutter widget painted *underneath*
    // the map in this Stack. Because the style leaves the sea unpainted and the
    // map surface is transparent (isOpaque=false / textureView=true), the sea
    // shows the Flutter waves through it while the land stays opaque - Flutter
    // widgets and native map content composite together seamlessly.
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _waveController,
          builder: (context, _) =>
              CustomPaint(painter: _WavesPainter(_waveController.value)),
        ),
        MapWidget(
          isOpaque:
              false, // on iOS, isOpaque=false is required for transparency
          textureView:
              true, // on Android, TextureView is required for transparency
          styleUri:
              '', // avoid flashing the default style before onMapCreated swaps it out
          onMapCreated: _onMapCreated,
          viewport: CameraViewportState(
            center: Point(coordinates: Position(21.9081, 60.1936)),
            zoom: 11,
          ),
        ),
      ],
    );
  }
}

class _WavesPainter extends CustomPainter {
  final double t;

  _WavesPainter(this.t);

  // A small wave "cell" that tiles across the whole canvas, giving a fine
  // water texture rather than a few large wallpaper bands.
  static const _cellWidth = 26.0; // horizontal wavelength of one ripple
  static const _rowHeight = 12.0; // vertical spacing between ripple rows
  static const _amplitude = 3.0; // how tall each ripple is

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFF021A30));

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    var row = 0;
    for (double y = _rowHeight; y < size.height; y += _rowHeight, row++) {
      // Alternate drift direction and colour per row for a lively texture.
      final dir = row.isEven ? 1.0 : -1.0;
      final drift = t * _cellWidth * dir;
      stroke.color = row.isEven
          ? const Color(0xFF2E86B8).withOpacity(0.85)
          : const Color(0xFF7FD4F0).withOpacity(0.7);

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
