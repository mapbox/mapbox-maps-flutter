import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class SpinningGlobeExample extends StatefulWidget {
  const SpinningGlobeExample({super.key});

  @override
  State<StatefulWidget> createState() => _SpinningGlobeExampleState();
}

class _SpinningGlobeExampleState extends State<SpinningGlobeExample> {
  late final MapboxMap mapboxMap;
  late final StreamController<CameraOptions> cameras = StreamController(
    onListen: () async {
      _spinGlobe(await mapboxMap.getCameraState());
    },
  );
  late final StreamSubscription subscription;
  var isSpinning = true;

  @override
  void dispose() {
    subscription.cancel();
    cameras.close();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  void _onMapLoaded(_) {
    subscription = cameras.stream.listen((toCamera) async {
      await mapboxMap.easeTo(toCamera, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        onMapCreated: _onMapCreated,
        onMapLoadedListener: _onMapLoaded,
        onCameraChangeListener: (data) {
          _spinGlobe(data.cameraState);
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: () {
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
      ),
    );
  }

  void _spinGlobe(CameraState camera) {
    if (!cameras.hasListener) return;

    final secondsPerRev = 120.0;
    final slowSpinZoom = 3.0;
    final maxSpinZoom = 5.0;

    if (camera.zoom < maxSpinZoom && !cameras.isClosed || !cameras.isPaused) {
      final speedFactor =
          (maxSpinZoom - max(slowSpinZoom, camera.zoom)) /
          (maxSpinZoom - slowSpinZoom);
      final distancePerSecond = speedFactor * 360.0 / secondsPerRev;

      final newCamera = CameraOptions(
        center: Point(
          coordinates: Position(
            camera.center.coordinates.lng - distancePerSecond,
            camera.center.coordinates.lat,
          ),
        ),
      );

      cameras.add(newCamera);
    }
  }
}
