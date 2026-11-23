import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

final _helsinki = Point(coordinates: Position(24.9384, 60.1699));

enum _DownloadState { idle, downloading, downloaded }

class OfflineMapExample extends StatefulWidget {
  const OfflineMapExample({super.key});

  @override
  State<OfflineMapExample> createState() => _OfflineMapExampleState();
}

class _OfflineMapExampleState extends State<OfflineMapExample> {
  final StreamController<double> _stylePackProgress =
      StreamController.broadcast();
  final StreamController<double> _tileRegionLoadProgress =
      StreamController.broadcast();

  TileStore? _tileStore;
  OfflineManager? _offlineManager;
  final _tileRegionId = "my-tile-region";
  _DownloadState _state = _DownloadState.idle;

  @override
  void dispose() {
    _stylePackProgress.close();
    _tileRegionLoadProgress.close();
    OfflineSwitch.shared.setMapboxStackConnected(true);
    _removeTileRegionAndStylePack();
    super.dispose();
  }

  Future<void> _removeTileRegionAndStylePack() async {
    try {
      // Clean up after the example. Typically, you'll have custom business
      // logic to decide when to evict tile regions and style packs

      // Remove the tile region with the tile region ID.
      // Note this will not remove the downloaded tile packs, instead, it will
      // just mark the tileset as not a part of a tile region. The tiles still
      // exists in a predictive cache in the TileStore.
      if (_tileStore?.tileRegion(_tileRegionId) != null) {
        await _tileStore?.removeRegion(_tileRegionId);
      }

      // Set the disk quota to zero, so that tile regions are fully evicted
      // when removed.
      // This removes the tiles from the predictive cache.
      _tileStore?.setDiskQuota(0);

      // Remove the style pack with the style uri.
      // Note this will not remove the downloaded style pack, instead, it will
      // just mark the resources as not a part of the existing style pack. The
      // resources still exists in the disk cache.
      if (_offlineManager?.stylePack(MapboxStyles.STANDARD_SATELLITE) != null) {
        await _offlineManager?.removeStylePack(MapboxStyles.STANDARD_SATELLITE);
      }
    } catch (_) {
      // This cleanup runs from dispose, where the example is already leaving
      // the screen. A production app reports the failure instead.
    }
  }

  /// Reports download progress on [sink], then completes it at 100%.
  ///
  /// The sink may already be closed if the example was disposed mid-download.
  void _report(StreamController<double> sink, double fraction) {
    if (!sink.isClosed) sink.sink.add(fraction);
  }

  void _finish(StreamController<double> sink) {
    if (!sink.isClosed) {
      sink.sink.add(1);
      sink.sink.close();
    }
  }

  Future<void> _downloadStylePack() async {
    await _offlineManager?.loadStylePack(
      MapboxStyles.STANDARD_SATELLITE,
      StylePackLoadOptions(
        glyphsRasterizationMode:
            GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY,
        metadata: {"tag": "test"},
        acceptExpired: false,
      ),
      (progress) => _report(
        _stylePackProgress,
        progress.completedResourceCount / progress.requiredResourceCount,
      ),
    );
    _finish(_stylePackProgress);
  }

  Future<void> _downloadTileRegion() async {
    await _tileStore?.loadTileRegion(
      _tileRegionId,
      TileRegionLoadOptions(
        geometry: _helsinki.toJson(),
        descriptorsOptions: [
          // If you are using a raster tileset you may need to set a different pixelRatio.
          // The default is UIScreen.main.scale on iOS and displayMetrics's density on Android.
          TilesetDescriptorOptions(
            styleURI: MapboxStyles.STANDARD_SATELLITE,
            minZoom: 0,
            maxZoom: 16,
          ),
        ],
        acceptExpired: true,
        networkRestriction: NetworkRestriction.NONE,
      ),
      (progress) => _report(
        _tileRegionLoadProgress,
        progress.completedResourceCount / progress.requiredResourceCount,
      ),
    );
    _finish(_tileRegionLoadProgress);
  }

  Future<void> _initOfflineMap() async {
    _offlineManager = await OfflineManager.create();
    _tileStore = await TileStore.createDefault();

    // Reset disk quota to default value
    _tileStore?.setDiskQuota(null);
  }

  @override
  Widget build(BuildContext context) {
    final downloaded = _state == _DownloadState.downloaded;
    return Stack(
      children: [
        Positioned.fill(
          child: downloaded
              ? MapWidget(
                  key: const ValueKey('mapWidget'),
                  styleUri: MapboxStyles.STANDARD_SATELLITE,
                  onMapCreated: (map) async {
                    await map.setCamera(
                      CameraOptions(center: _helsinki, zoom: 14),
                    );
                  },
                )
              : const ColoredBox(color: Color(0xFF0E1012)),
        ),
        if (!downloaded)
          Center(
            child: _OfflinePanel(
              children: [
                const Text(
                  'Download the style pack and tiles for Helsinki, then the '
                  'map renders with the network switched off.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xB3FFFFFF),
                  ),
                ),
                const SizedBox(height: 14),
                _OfflineButton(
                  label: _state == _DownloadState.downloading
                      ? 'Downloading…'
                      : 'Download map',
                  onPressed: _state == _DownloadState.downloading
                      ? null
                      : _download,
                ),
              ],
            ),
          ),
        Positioned(
          top: 16,
          right: 16,
          width: 240,
          child: _OfflinePanel(
            children: [
              _progress('Style pack', _stylePackProgress.stream),
              const SizedBox(height: 12),
              _progress('Tile region', _tileRegionLoadProgress.stream),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _download() async {
    setState(() => _state = _DownloadState.downloading);
    await _initOfflineMap();
    _downloadStylePack();
    _downloadTileRegion();
    await Future.wait([
      _tileRegionLoadProgress.sink.done,
      _stylePackProgress.sink.done,
    ]);
    await OfflineSwitch.shared.setMapboxStackConnected(false);
    if (!mounted) return;
    setState(() => _state = _DownloadState.downloaded);
  }

  Widget _progress(String label, Stream<double> stream) {
    return StreamBuilder<double>(
      stream: stream,
      initialData: 0.0,
      builder: (context, snapshot) {
        final value = snapshot.requireData;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0x80FFFFFF),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Text(
                  '${(value * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xB3FFFFFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 4,
                backgroundColor: const Color(0x14FFFFFF),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF007AFC)),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Floating translucent panel matching the rest of the example app.
class _OfflinePanel extends StatelessWidget {
  const _OfflinePanel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: ClipRRect(
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
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class _OfflineButton extends StatelessWidget {
  const _OfflineButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF007AFC),
        disabledForegroundColor: const Color(0x80FFFFFF),
        disabledBackgroundColor: const Color(0x14FFFFFF),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}
