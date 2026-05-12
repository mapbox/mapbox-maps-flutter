import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'cities.dart';

enum _DownloadState { idle, downloading, downloaded }

class OfflineMapExample extends StatefulWidget {
  const OfflineMapExample({super.key});

  @override
  State createState() => OfflineMapExampleState();
}

class OfflineMapExampleState extends State<OfflineMapExample> {
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
    } catch (e) {
      // Handle errors from removing tile region and style pack.
    }
  }

  Future<void> _downloadStylePack() async {
    final stylePackLoadOptions = StylePackLoadOptions(
      glyphsRasterizationMode:
          GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY,
      metadata: {"tag": "test"},
      acceptExpired: false,
    );
    _offlineManager
        ?.loadStylePack(MapboxStyles.STANDARD_SATELLITE, stylePackLoadOptions, (
          progress,
        ) {
          final percentage =
              progress.completedResourceCount / progress.requiredResourceCount;
          if (!_stylePackProgress.isClosed) {
            _stylePackProgress.sink.add(percentage);
          }
        })
        .then((value) {
          if (!_stylePackProgress.isClosed) {
            _stylePackProgress.sink.add(1);
            _stylePackProgress.sink.close();
          }
        });
  }

  Future<void> _downloadTileRegion() async {
    final tileRegionLoadOptions = TileRegionLoadOptions(
      geometry: City.helsinki.toJson(),
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
    );

    _tileStore
        ?.loadTileRegion(_tileRegionId, tileRegionLoadOptions, (progress) {
          final percentage =
              progress.completedResourceCount / progress.requiredResourceCount;
          if (!_tileRegionLoadProgress.isClosed) {
            _tileRegionLoadProgress.sink.add(percentage);
          }
        })
        .then((value) {
          if (!_tileRegionLoadProgress.isClosed) {
            _tileRegionLoadProgress.sink.add(1);
            _tileRegionLoadProgress.sink.close();
          }
        });
  }

  Future<void> _initOfflineMap() async {
    _offlineManager = await OfflineManager.create();
    _tileStore = await TileStore.createDefault();

    // Reset disk quota to default value
    _tileStore?.setDiskQuota(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Map'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: _state == _DownloadState.downloaded
                ? MapWidget(
                    key: ValueKey("mapWidget"),
                    styleUri: MapboxStyles.STANDARD_SATELLITE,
                    onMapCreated: (map) async {
                      await map.setCamera(
                        CameraOptions(center: City.helsinki, zoom: 14),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Offline map will be shown here after downloading.",
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _state == _DownloadState.downloading
                              ? null
                              : () async {
                                  setState(
                                    () => _state = _DownloadState.downloading,
                                  );
                                  await _initOfflineMap();
                                  _downloadStylePack();
                                  _downloadTileRegion();
                                  await Future.wait([
                                    _tileRegionLoadProgress.sink.done,
                                    _stylePackProgress.sink.done,
                                  ]);
                                  await OfflineSwitch.shared
                                      .setMapboxStackConnected(false);
                                  if (!mounted) return;
                                  setState(
                                    () => _state = _DownloadState.downloaded,
                                  );
                                },
                          child: const Text("Download Map"),
                        ),
                      ],
                    ),
                  ),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder(
                    stream: _stylePackProgress.stream,
                    initialData: 0.0,
                    builder: (context, snapshot) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Style pack ${snapshot.requireData}"),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(value: snapshot.requireData),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder(
                    stream: _tileRegionLoadProgress.stream,
                    initialData: 0.0,
                    builder: (context, snapshot) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Tile region ${snapshot.requireData}"),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(value: snapshot.requireData),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
