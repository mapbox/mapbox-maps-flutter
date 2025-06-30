import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'example.dart';

class VectorTileSourceExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Vector Tile Source';
  @override
  final String? subtitle = null;

  @override
  State createState() => VectorTileSourceExampleState();
}

class VectorTileSourceExampleState extends State<VectorTileSourceExample> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) async {
    await mapboxMap?.style.addSource(VectorSource(
        id: "terrain-data", url: "mapbox://mapbox.mapbox-terrain-v2"));
    await mapboxMap?.style.addLayerAt(
        LineLayer(
            id: "terrain-data",
            sourceId: "terrain-data",
            sourceLayer: "contour",
            lineJoin: LineJoin.ROUND,
            lineCap: LineCap.ROUND,
            lineColor: Colors.red.value,
            lineWidth: 1.9),
        LayerPosition(above: "country-label"));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: MapWidget(
            key: ValueKey("mapWidget"),
            styleUri: MapboxStyles.LIGHT,
            cameraOptions: CameraOptions(
                center: Point(coordinates: Position(-122.447303, 37.753574)),
                zoom: 13.0),
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoadedCallback));
  }
}
