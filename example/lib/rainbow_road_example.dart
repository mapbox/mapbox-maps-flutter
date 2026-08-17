// ignore_for_file: experimental_member_use

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_example/example.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

const _layerId = 'rainbow-track-line';
const _sourceId = 'rainbow-track-source';

const _trackAsset = 'assets/monaco_gp_circuit.geojson';

class RainbowRoadExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.gradient);
  @override
  final String title = 'Rainbow road';
  @override
  final String subtitle =
      'Animate LineLayer.lineBorderGradient along the Circuit de Monaco using line-progress.';

  const RainbowRoadExample({super.key});

  @override
  State createState() => RainbowRoadExampleState();
}

class RainbowRoadExampleState extends State<RainbowRoadExample> {
  MapboxMap? mapboxMap;
  Timer? _animationTimer;
  var _phase = 0.0;
  var _animating = true;

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  Future<void> _onStyleLoadedCallback(StyleLoadedEventData data) async {
    final mapboxMap = this.mapboxMap;
    if (mapboxMap == null) {
      return;
    }

    final trackGeoJson = await rootBundle.loadString(_trackAsset);
    await mapboxMap.style.addSource(
      GeoJsonSource(id: _sourceId, data: trackGeoJson, lineMetrics: true),
    );
    await mapboxMap.style.addLayer(
      LineLayer(
        id: _layerId,
        sourceId: _sourceId,
        lineCap: LineCap.ROUND,
        lineJoin: LineJoin.ROUND,
        lineColor: Colors.grey.shade800.toARGB32(),
        lineWidth: 4.0,
        lineBorderWidth: 5.0,
        lineBorderGradientExpression: _rainbowExpression(_phase),
      ),
    );

    await _frameTrack(mapboxMap, trackGeoJson);
    _startAnimation();
  }

  /// Fits the camera to the track's real coordinates so the rainbow border
  /// lines up with the actual road, regardless of screen size.
  Future<void> _frameTrack(MapboxMap mapboxMap, String trackGeoJson) async {
    final coordinates = (json.decode(trackGeoJson)['features'][0]['geometry']
            ['coordinates'] as List)
        .map(
          (c) => Point(
            coordinates: Position((c as List)[0] as num, c[1] as num),
          ),
        )
        .toList();
    final camera = await mapboxMap.cameraForCoordinatesPadding(
      coordinates,
      CameraOptions(),
      MbxEdgeInsets(top: 40, left: 40, bottom: 40, right: 40),
      null,
      null,
    );
    await mapboxMap.setCamera(camera);
  }

  void _startAnimation() {
    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      final mapboxMap = this.mapboxMap;
      if (mapboxMap == null) {
        return;
      }
      _phase = (_phase + 0.03) % 1.0;
      mapboxMap.style.setStyleLayerProperty(
        _layerId,
        'line-border-gradient',
        _rainbowExpression(_phase),
      );
    });
  }

  void _toggleAnimation() {
    setState(() {
      _animating = !_animating;
      if (_animating) {
        _startAnimation();
      } else {
        _animationTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleAnimation,
        child: Icon(_animating ? Icons.pause : Icons.play_arrow),
      ),
      body: MapWidget(
        key: const ValueKey('mapWidget'),
        // Refined to the real track bounds once the style loads; this is
        // just a reasonable starting point over Monaco.
        viewport: CameraViewportState(
          center: Point(coordinates: Position(7.4258, 43.7367)),
          zoom: 15.0,
        ),
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoadedCallback,
      ),
    );
  }
}

/// Builds a `line-border-gradient` expression that paints a full rainbow
/// spectrum along the line, offset by [phase] (0.0-1.0) so repeated calls
/// with a slowly incrementing phase make the colors appear to flow along
/// the line.
List<Object> _rainbowExpression(double phase) {
  const stopCount = 12;
  final stops = <Object>[];
  for (var i = 0; i <= stopCount; i++) {
    final t = i / stopCount;
    final hue = (t + phase) * 360.0 % 360.0;
    final color = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    stops.add(t);
    stops.add([
      'rgb',
      (color.r * 255.0).round().clamp(0, 255),
      (color.g * 255.0).round().clamp(0, 255),
      (color.b * 255.0).round().clamp(0, 255),
    ]);
  }
  return [
    'interpolate',
    ['linear'],
    ['line-progress'],
    ...stops,
  ];
}
