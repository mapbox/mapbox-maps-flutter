import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// Exercises both [StyleImage] variants through `addImage`: a runtime
/// [StyleImage.rgba] gradient (mirrors
/// https://docs.mapbox.com/mapbox-gl-js/example/add-image-generated/) and a
/// [StyleImage.bytes] PNG icon loaded from assets. Also verifies
/// `hasStyleImage` for both, and `getImage` where supported (not on web),
/// reporting results in a snackbar.
class GeneratedStyleImageExample extends StatefulWidget {
  const GeneratedStyleImageExample({super.key});

  @override
  State<GeneratedStyleImageExample> createState() =>
      _GeneratedStyleImageExampleState();
}

class _GeneratedStyleImageExampleState
    extends State<GeneratedStyleImageExample> {
  static const _rgbaImageId = 'gradient';
  static const _bytesImageId = 'png-icon';
  static const _sourceId = 'points';
  static const _layerId = 'points';
  static const _size = 64;

  Future<void> _onStyleLoaded(StyleLoadedEventData _) async {
    final map = mapboxMap;
    if (map == null) return;

    await map.addImage(
      _rgbaImageId,
      1.0,
      StyleImage.rgba(
        width: _size,
        height: _size,
        pixels: _gradientRgba(_size),
      ),
    );

    final pngBytes = (await rootBundle.load(
      'assets/symbols/custom-icon.png',
    )).buffer.asUint8List();
    await map.addImage(_bytesImageId, 1.0, StyleImage.bytes(pngBytes));

    await map.addSource(
      GeoJsonSource(
        id: _sourceId,
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
        id: _layerId,
        sourceId: _sourceId,
        iconImageExpression: ['get', 'icon'],
        iconAllowOverlap: true,
      ),
    );

    await _verifyImages();
  }

  /// Confirms both images landed correctly: `hasStyleImage` on every
  /// platform, plus a `getImage` round-trip on mobile (unsupported on web)
  /// to exercise the [StyleImageRgba] read path.
  Future<void> _verifyImages() async {
    final map = mapboxMap;
    if (map == null) return;

    final results = <String>[];
    for (final id in [_rgbaImageId, _bytesImageId]) {
      results.add('$id: hasStyleImage=${await map.hasStyleImage(id)}');
    }
    if (!kIsWeb) {
      final rgba = await map.getImage(_rgbaImageId);
      results.add(
        rgba == null
            ? '$_rgbaImageId: getImage=null'
            : '$_rgbaImageId: getImage=${rgba.width}x${rgba.height}',
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(results.join(' · '))));
    }
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

  MapboxMap? mapboxMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        key: const ValueKey('generatedStyleImageMap'),
        styleUri: MapboxStyles.STANDARD,
        viewport: CameraViewportState(
          center: Point(coordinates: Position(0, 0)),
          zoom: 2,
        ),
        onMapCreated: (map) => mapboxMap = map,
        onStyleLoadedListener: _onStyleLoaded,
      ),
    );
  }
}
