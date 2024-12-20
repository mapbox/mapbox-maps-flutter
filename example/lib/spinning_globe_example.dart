import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/example.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class SpinningGlobeExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.threesixty_outlined);
  @override
  final String title = 'Spinning Globe';
  @override
  final String? subtitle =
      'Display your map as an interactive, rotating globe.';

  @override
  State<StatefulWidget> createState() => SpinningGlobeExampleState();
}

class SpinningGlobeExampleState extends State<SpinningGlobeExample> {
  late final MapboxMap mapboxMap;
  late final StreamController<CameraOptions> cameras;
  late final StreamSubscription subscription;
  var isSpinning = true; // Auto-spinning

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    cameras = StreamController(
      onListen: () async {
        _spinGlobe(await mapboxMap.getCameraState());
      },
    );
  }

  void _onStyleLoaded(_) {
    subscription = cameras.stream.listen((toCamera) async {
      await mapboxMap.easeTo(toCamera, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MapWidget(
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
            onCameraChangeListener: (data) {
              _spinGlobe(data.cameraState);
            }),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: FloatingActionButton(
            onPressed: () async {
              setState(() {
                isSpinning = !isSpinning;
                if (!isSpinning) {
                  subscription.pause();
                } else {
                  subscription.resume();
                }
              });
            },
            child: Icon(isSpinning ? Icons.pause : Icons.play_arrow),
          ),
        ));
  }

  void _spinGlobe(CameraState camera) {
    final secondsPerRev = 120.0;
    final slowSpinZoom = 3.0;
    final maxSpinZoom = 5.0;

    // Above zoom level 5, do not rotate.
    if (camera.zoom < maxSpinZoom && !cameras.isClosed || !cameras.isPaused) {
      // Rotate at intermediate speeds between zoom levels 3 and 5.
      final speedFactor = (maxSpinZoom - max(slowSpinZoom, camera.zoom)) /
          (maxSpinZoom - slowSpinZoom);
      final distancePerSecond = speedFactor * 360.0 / secondsPerRev;

      final newCamera = CameraOptions(
        center: Point(
            coordinates: Position(
                camera.center.coordinates.lng - distancePerSecond,
                camera.center.coordinates.lat)),
      );

      cameras.add(newCamera);
    }
  }
}
