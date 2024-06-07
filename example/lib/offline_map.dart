import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'page.dart';
import 'utils.dart';

class OfflineMapPage extends ExamplePage {
  OfflineMapPage() : super(const Icon(Icons.map), 'Offline Map');

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

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    await _downloadStylePack();
    await _downloadTileRegion();
  }

  _downloadStylePack() async {
    final offlineManager = await OfflineManager.create();
    final stylePackLoadOptions = StylePackLoadOptions(
        glyphsRasterizationMode:
            GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY,
        metadata: {"tag": "test"},
        acceptExpired: false);
    offlineManager.loadStylePack(MapboxStyles.OUTDOORS, stylePackLoadOptions,
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
    final tmpDir = await getTemporaryDirectory();
    final tileStore = await TileStore.createAt(await tmpDir.uri);
    final tileRegionLoadOptions = TileRegionLoadOptions(
        geometry: Point(coordinates: Position(-80.1263, 25.7845)).toJson(),
        descriptorsOptions: [
          TilesetDescriptorOptions(
              styleURI: MapboxStyles.OUTDOORS, minZoom: 0, maxZoom: 16)
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
    final mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      styleUri: MapboxStyles.OUTDOORS,
      cameraOptions: CameraOptions(center: City.helsinki, zoom: 2.0),
      onMapCreated: _onMapCreated,
    );

    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: mapWidget,
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
