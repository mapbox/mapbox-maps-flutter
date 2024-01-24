import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'page.dart';

class TileJsonPage extends ExamplePage {
  TileJsonPage() : super(const Icon(Icons.map), 'Tile Json');

  @override
  Widget build(BuildContext context) {
    return const TileJsonWidget();
  }
}

class TileJsonWidget extends StatefulWidget {
  const TileJsonWidget();

  @override
  State createState() => TileJsonWidgetState();
}

class TileJsonWidgetState extends State<TileJsonWidget> {
  MapboxMap? mapboxMap;
  var isLight = true;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.style.setStyleJSON("{}");
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    await mapboxMap?.style.addSource(RasterSource(
        id: "source",
        tiles: ["https://tile.openstreetmap.org/{z}/{x}/{y}.png"],
        tileSize: 256,
        scheme: Scheme.XYZ,
        minzoom: 0,
        maxzoom: 18,
        bounds: [-180.0, -85.0, 180.0, 85.0],
        attribution: "&copy; OpenStreetMap contributors, CC-BY-SA"));
    await mapboxMap?.style
        .addLayer(RasterLayer(id: "layer", sourceId: "source"));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: MapWidget(
      key: ValueKey("mapWidget"),
      cameraOptions: CameraOptions(
          center: Point(coordinates: Position(-80.1263, 25.7845)), zoom: 12.0),
      onMapCreated: _onMapCreated,
      onStyleLoadedListener: _onStyleLoaded,
    ));
  }
}
