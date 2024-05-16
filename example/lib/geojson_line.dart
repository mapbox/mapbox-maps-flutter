import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'page.dart';

class DrawGeoJsonLinePage extends ExamplePage {
  DrawGeoJsonLinePage() : super(const Icon(Icons.map), 'Draw GeoJson Line');

  @override
  Widget build(BuildContext context) {
    return const DrawGeoJsonLineWidget();
  }
}

class DrawGeoJsonLineWidget extends StatefulWidget {
  const DrawGeoJsonLineWidget();

  @override
  State createState() => DrawGeoJsonLineWidgetState();
}

class DrawGeoJsonLineWidgetState extends State<DrawGeoJsonLineWidget> {
  MapboxMap? mapboxMap;
  var isLight = true;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    var data = await rootBundle
        .loadString('assets/from_crema_to_council_crest.geojson');
    await mapboxMap.style.addSource(GeoJsonSource(id: "line", data: data));
    await mapboxMap.style.addLayer(LineLayer(
        id: "line_layer",
        sourceId: "line",
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineColor: Colors.red.value,
        lineWidth: 6.0));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: MapWidget(
      key: ValueKey("mapWidget"),
      styleUri: MapboxStyles.MAPBOX_STREETS,
      cameraOptions: CameraOptions(
          center: Point(coordinates: Position(-122.486052, 37.830348)),
          zoom: 14.0),
      onMapCreated: _onMapCreated,
    ));
  }
}
