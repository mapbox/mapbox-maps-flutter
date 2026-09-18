import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class SnapshotterExample extends StatefulWidget {
  const SnapshotterExample({super.key});

  @override
  State<SnapshotterExample> createState() => _SnapshotterExampleState();
}

class _SnapshotterExampleState extends State<SnapshotterExample> {
  final _snapshotKey = GlobalKey();
  MapboxMap? _mapboxMap;
  Image? _snapshotImage;
  Snapshotter? _snapshotter;
  bool _snapshotting = false;

  @override
  void dispose() {
    _snapshotter?.dispose();
    super.dispose();
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    // Web has no standalone Snapshotter; _captureMapSnapshot covers it.
    if (kIsWeb) return;

    final snapshotter = await Snapshotter.create(
      options: MapSnapshotOptions(
        size: Size(width: 400, height: 400),
        pixelRatio: MediaQuery.of(context).devicePixelRatio,
      ),
    );
    _snapshotter = snapshotter;
    await snapshotter.setStyleURI(MapboxStyles.STANDARD);
    await snapshotter.setStyleImportConfigProperty("basemap", "theme", "faded");
    await snapshotter.setStyleImportConfigProperty(
      "basemap",
      "lightPreset",
      "night",
    );
  }

  Future<void> _onMapIdle(MapIdleEventData data) async {
    final map = _mapboxMap;
    final snapshotter = _snapshotter;
    if (_snapshotting || map == null || snapshotter == null) return;
    _snapshotting = true;

    final snapshotBox =
        _snapshotKey.currentContext?.findRenderObject() as RenderBox?;
    if (snapshotBox != null && snapshotBox.hasSize) {
      snapshotter.setSize(
        Size(width: snapshotBox.size.width, height: snapshotBox.size.height),
      );
    }

    final cameraState = await map.getCameraState();
    snapshotter.setCamera(cameraState.toCameraOptions());

    try {
      final snapshot = await snapshotter.start();
      if (snapshot != null && mounted) {
        setState(() => _snapshotImage = Image.memory(snapshot));
      }
    } finally {
      _snapshotting = false;
    }
  }

  Future<void> _captureMapSnapshot() async {
    final map = _mapboxMap;
    if (map == null) return;
    final snapshot = await map.snapshot();
    if (!mounted) return;
    setState(() => _snapshotImage = Image.memory(snapshot));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: MapWidget(
            key: const ValueKey('mapWidget'),
            onMapCreated: _onMapCreated,
            onMapIdleListener: _onMapIdle,
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          width: 240,
          child: _SnapshotPanel(
            key: _snapshotKey,
            snapshot: _snapshotImage,
            // Web has no standalone Snapshotter, so the snapshot is taken on
            // demand from the live map instead of on every idle.
            onCapture: kIsWeb ? _captureMapSnapshot : null,
          ),
        ),
      ],
    );
  }
}

/// Floating translucent panel previewing the most recent snapshot.
class _SnapshotPanel extends StatelessWidget {
  const _SnapshotPanel({
    super.key,
    required this.snapshot,
    required this.onCapture,
  });

  final Image? snapshot;
  final VoidCallback? onCapture;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xCC0E1012),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x1FFFFFFF)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'SNAPSHOT',
                style: TextStyle(
                  color: Color(0x80FFFFFF),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      snapshot ??
                      const ColoredBox(
                        color: Color(0x14FFFFFF),
                        child: Center(
                          child: Text(
                            'No snapshot yet',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0x80FFFFFF),
                            ),
                          ),
                        ),
                      ),
                ),
              ),
              if (onCapture != null) ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onCapture,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0x14FFFFFF),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Capture snapshot',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
