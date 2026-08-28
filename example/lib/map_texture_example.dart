import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'dart:ui' as ui;
import 'example.dart';

/// Shows the difference a texture makes: pressing the button captures this
/// page with `RepaintBoundary.toImage`. With [MapTexture] the capture contains
/// the map, because the map is ordinary flutter content. With a [MapWidget]
/// the same capture comes back with a hole where the map is, because a
/// platform view is composited by uikit and is not in flutter's scene.
class MapTextureExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.photo_camera_back);
  @override
  final String title = 'Map in a flutter texture (iOS)';
  @override
  final String? subtitle = 'No platform view, so the map can be captured';

  @override
  State<StatefulWidget> createState() => MapTextureExampleState();
}

class MapTextureExampleState extends State<MapTextureExample> {
  final GlobalKey _boundary = GlobalKey();
  ui.Image? _capture;

  Future<void> _onMapCreated(MapboxMap map) async {
    await map.setCamera(
      CameraOptions(
        center: Point(coordinates: Position(-0.0880, 51.5140)),
        zoom: 12.5,
      ),
    );
  }

  Future<void> _captureThePage() async {
    final object = _boundary.currentContext?.findRenderObject();
    if (object is! RenderRepaintBoundary) return;
    final image = await object.toImage(pixelRatio: 1);
    if (!mounted) return;
    setState(() => _capture = image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _captureThePage,
        label: const Text('RepaintBoundary.toImage'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              key: _boundary,
              child: MapTexture(
                styleUri: MapboxStyles.MAPBOX_STREETS,
                onMapCreated: _onMapCreated,
              ),
            ),
          ),
          if (_capture != null)
            Positioned(
              right: 18,
              bottom: 120,
              child: Container(
                padding: const EdgeInsets.all(3),
                color: Colors.black,
                child: ClipRect(
                  child: SizedBox(
                    width: 150,
                    height: 260,
                    child: ColoredBox(
                      color: Colors.white,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: RawImage(image: _capture),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
