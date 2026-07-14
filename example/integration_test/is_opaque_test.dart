import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;

const _accessToken = String.fromEnvironment('ACCESS_TOKEN');

/// No sources, no layers, so nothing is painted and the whole surface
/// is left to the map background.
const _emptyStyle = '{"version": 8, "sources": {}, "layers": []}';

/// Pumps a full-screen [MapWidget] over a solid [background] and returns the
/// [MapboxMap] once the style is loaded and the map has gone idle (rendered).
Future<MapboxMap> _pumpMap(
  WidgetTester tester, {
  required bool isOpaque,
  required bool textureView,
  required Color background,
}) async {
  MapboxOptions.setAccessToken(_accessToken);

  final created = Completer<MapboxMap>();
  final styleLoaded = Completer<void>();
  final idle = Completer<void>();

  runApp(MaterialApp(
    home: Stack(
      fit: StackFit.expand,
      children: [
        // Solid backdrop that should show through a transparent map surface.
        ColoredBox(color: background),
        MapWidget(
          key: ValueKey('isOpaque=$isOpaque,textureView=$textureView'),
          isOpaque: isOpaque,
          textureView: textureView,
          // Empty styleUri so the default style never flashes; we load the
          // transparent style ourselves in onMapCreated.
          styleUri: '',
          viewport: CameraViewportState(
            center: Point(coordinates: Position(0, 0)),
            zoom: 1,
          ),
          onMapCreated: (map) async {
            await map.style.setStyleJSON(_emptyStyle);
            if (!created.isCompleted) created.complete(map);
          },
          onStyleLoadedListener: (_) {
            if (!styleLoaded.isCompleted) styleLoaded.complete();
          },
          onMapIdleListener: (_) {
            if (!idle.isCompleted) idle.complete();
          },
        ),
      ],
    ),
  ));

  await tester.pumpAndSettle();
  final map = await created.future;
  await styleLoaded.future;
  await idle.future;
  return map;
}

/// Decodes PNG [bytes] and returns the fraction of pixels that are fully
/// transparent (alpha == 0).
Future<double> _transparentFraction(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  final byteData =
      await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
  final pixels = byteData!.buffer.asUint8List();

  var transparent = 0;
  final total = pixels.length ~/ 4;
  for (var i = 0; i < pixels.length; i += 4) {
    if (pixels[i + 3] == 0) transparent++;
  }
  return total == 0 ? 0 : transparent / total;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('isOpaque:false renders a transparent surface',
      (WidgetTester tester) async {
    final map = await _pumpMap(
      tester,
      isOpaque: false,
      textureView: true,
      background: const Color(0xFFFF0000),
    );

    final snapshot = await map.snapshot();
    final fraction = await _transparentFraction(snapshot);

    // An empty style over a transparent surface should render fully
    // transparent on both platforms: on iOS this needs isOpaque:false, on
    // Android transparency is governed by textureView:true.
    expect(fraction, equals(1.0));
  });

  testWidgets('isOpaque:true renders an opaque surface',
      (WidgetTester tester) async {
    final map = await _pumpMap(
      tester,
      isOpaque: true,
      textureView: true,
      background: const Color(0xFFFF0000),
    );

    final snapshot = await map.snapshot();
    final fraction = await _transparentFraction(snapshot);

    // iOS-only. isOpaque has no effect on Android (the factory ignores it),
    // and map.snapshot() captures the map's own framebuffer - which clears
    // transparent for an empty style regardless of textureView/SurfaceView
    // (that only affects on-screen compositing, not the snapshot). So there
    // is no opaque baseline observable via snapshot() on Android.
    if (Platform.isIOS) {
      expect(fraction, equals(0.0));
    }
  });
}
