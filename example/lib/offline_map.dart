import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  MapboxMap? mapboxMap;
  final StreamController<double> _stylePackProgress =
      StreamController.broadcast();
  final StreamController<double> _tileRegionLoadProgress =
      StreamController.broadcast();

  _downloadStylePack() async {
    final offlineManager = await OfflineManager.create();
    final stylePackLoadOptions = StylePackLoadOptions(
        glyphsRasterizationMode:
            GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY,
        metadata: {"tag": "test"},
        acceptExpired: false);
    offlineManager.loadStylePack(MapboxStyles.SATELLITE_STREETS, stylePackLoadOptions,
        (progress) {
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
    final path = await getTemporaryDirectory();
    final tileStore = await TileStore.createAt(path.uri);
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

    tileStore.loadTileRegion("my-tile-region", tileRegionLoadOptions,
        (progress) {
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

  @override
  Widget build(BuildContext context) {
    String downloadButtonText = "Download Map";
    final mapIsDownloaded = Future
        .wait([_tileRegionLoadProgress.sink.done, _stylePackProgress.sink.done])
        .whenComplete(() async {
          await OfflineSwitch.shared.setMapboxStackConnected(false);
        });

    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: FutureBuilder(future: mapIsDownloaded, builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MapWidget(
                key: ValueKey("mapWidget"),
                styleUri: MapboxStyles.SATELLITE_STREETS,
                cameraOptions: CameraOptions(center: City.helsinki, zoom: 12.0),
              );
            } else {
              return TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () async {
                  setState(() {
                    downloadButtonText = "Downloading";
                  });
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
