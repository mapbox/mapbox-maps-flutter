import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'page.dart';

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

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    final offlineManager = await OfflineManager.create();
    final stylePackLoadOptions = StylePackLoadOptions(
        glyphsRasterizationMode:
            GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY,
        acceptExpired: false);
    offlineManager.loadStylePack(
        MapboxStyles.STANDARD, StylePackLoadOptions(acceptExpired: false),
        (progress) {
      print("Progressing...${progress.loadedResourceSize}");
    }).then((value) => print("MMM downloaded"));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: MapWidget(
      key: ValueKey("mapWidget"),
      styleUri: MapboxStyles.DARK,
      cameraOptions: CameraOptions(
          center: Point(coordinates: Position(-80.1263, 25.7845)), zoom: 12.0),
      onMapCreated: _onMapCreated,
    ));
  }
}
