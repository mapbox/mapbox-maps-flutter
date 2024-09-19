import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'page.dart';
import 'utils.dart';

class OfflineMapPage extends ExamplePage {
  OfflineMapPage() : super(const Icon(Icons.wifi_off), 'Offline Map');

  @override
  Widget build(BuildContext context) {
    return const OfflineMapWidget();
  }
}

class OfflineMapWidget extends StatefulWidget {
  const OfflineMapWidget();

  @override
  State createState() => OfflineMapWidgetState();
}

class OfflineMapWidgetState extends State<OfflineMapWidget> {
  final StreamController<double> _stylePackProgress =
      StreamController.broadcast();
  final StreamController<double> _tileRegionLoadProgress =
      StreamController.broadcast();

  late final TileStore? tileStore;
  late final OfflineManager? offlineManager;
  final _tileRegionId = "my-tile-region";

  @override
  void dispose() async {
    super.dispose();
    await OfflineSwitch.shared.setMapboxStackConnected(true);
    await _removeTileRegionAndStylePack();
  }

  _removeTileRegionAndStylePack() async {
    // Clean up after the example. Typically, you'll have custom business
    // logic to decide when to evict tile regions and style packs

    // Remove the tile region with the tile region ID.
    // Note this will not remove the downloaded tile packs, instead, it will
    // just mark the tileset as not a part of a tile region. The tiles still
    // exists in a predictive cache in the TileStore.
    await tileStore?.removeRegion(_tileRegionId);

    // Set the disk quota to zero, so that tile regions are fully evicted
    // when removed.
    // This removes the tiles from the predictive cache.
    tileStore?.setDiskQuota(0);

    // Remove the style pack with the style uri.
    // Note this will not remove the downloaded style pack, instead, it will
    // just mark the resources as not a part of the existing style pack. The
    // resources still exists in the disk cache.
    await offlineManager?.removeStylePack(MapboxStyles.SATELLITE_STREETS);
  }

  _downloadStylePack() async {
    final stylePackLoadOptions = StylePackLoadOptions(
        glyphsRasterizationMode:
            GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY,
        metadata: {"tag": "test"},
        acceptExpired: false);
    offlineManager?.loadStylePack(
        MapboxStyles.SATELLITE_STREETS, stylePackLoadOptions, (progress) {
      final percentage =
          progress.completedResourceCount / progress.requiredResourceCount;
      if (!_stylePackProgress.isClosed) {
        _stylePackProgress.sink.add(percentage);
      }
    }).then((value) {
      _stylePackProgress.sink.add(1);
      _stylePackProgress.sink.close();
    });
  }

  _downloadTileRegion() async {
    final tileRegionLoadOptions = TileRegionLoadOptions(
        geometry: City.helsinki.toJson(),
        descriptorsOptions: [
          // If you are using a raster tileset you may need to set a different pixelRatio.
          // The default is UIScreen.main.scale on iOS and displayMetrics's density on Android.
          TilesetDescriptorOptions(
              styleURI: MapboxStyles.SATELLITE_STREETS, minZoom: 0, maxZoom: 16)
        ],
        acceptExpired: true,
        networkRestriction: NetworkRestriction.NONE);

    tileStore?.loadTileRegion(_tileRegionId, tileRegionLoadOptions, (progress) {
      final percentage =
          progress.completedResourceCount / progress.requiredResourceCount;
      if (!_tileRegionLoadProgress.isClosed) {
        _tileRegionLoadProgress.sink.add(percentage);
      }
    }).then((value) {
      _tileRegionLoadProgress.sink.add(1);
      _tileRegionLoadProgress.sink.close();
    });
  }

  _initOfflineMap() async {
    offlineManager = await OfflineManager.create();
    tileStore = await TileStore.createDefault();

    // Reset disk quota to default value
    tileStore?.setDiskQuota(null);
  }

  @override
  Widget build(BuildContext context) {
    String downloadButtonText = "Download Map";
    final mapIsDownloaded = Future.wait(
            [_tileRegionLoadProgress.sink.done, _stylePackProgress.sink.done])
        .whenComplete(() async {
      await OfflineSwitch.shared.setMapboxStackConnected(false);
    });

    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: FutureBuilder(
              future: mapIsDownloaded,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return MapWidget(
                    key: ValueKey("mapWidget"),
                    styleUri: MapboxStyles.SATELLITE_STREETS,
                    cameraOptions:
                        CameraOptions(center: City.helsinki, zoom: 12.0),
                  );
                } else {
                  return TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () async {
                      await _initOfflineMap();
                      await _downloadStylePack();
                      await _downloadTileRegion();
                    },
                    child: Text(downloadButtonText),
                  );
                }
              }),
        ),
        SizedBox(
            height: 100,
            child: Card(
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
                            LinearProgressIndicator(
                              value: snapshot.requireData,
                            )
                          ],
                        );
                      }),
                  StreamBuilder(
                      stream: _tileRegionLoadProgress.stream,
                      initialData: 0.0,
                      builder: (context, snapshot) {
                        return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Tile region ${snapshot.requireData}"),
                              LinearProgressIndicator(
                                value: snapshot.requireData,
                              )
                            ]);
                      }),
                ],
              ),
            ))
      ],
    );
  }
}
