import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/helpers.dart';

import 'main.dart';
import 'page.dart';

class VectorTileSourcePage extends ExamplePage {
  VectorTileSourcePage() : super(const Icon(Icons.map), 'Vector Tile Source');

  @override
  Widget build(BuildContext context) {
    return const VectorTileSourceWidget();
  }
}

class VectorTileSourceWidget extends StatefulWidget {
  const VectorTileSourceWidget();

  @override
  State createState() => VectorTileSourceWidgetState();
}

class VectorTileSourceWidgetState extends State<VectorTileSourceWidget> {
  MapboxMap? mapboxMap;
  var isLight = true;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    await mapboxMap.style.addSource(VectorSource(
        id: "terrain-data", url: "mapbox://mapbox.mapbox-terrain-v2"));
    await mapboxMap.style.addLayerAt(
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
      resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
      styleUri: MapboxStyles.LIGHT,
      cameraOptions: CameraOptions(
          center: Point(coordinates: Position(-122.447303, 37.753574)).toJson(),
          zoom: 13.0),
      onMapCreated: _onMapCreated,
    ));
  }
}
