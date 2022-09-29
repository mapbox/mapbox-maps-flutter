import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps/mapbox_maps.dart';
import 'package:turf/helpers.dart';

import 'main.dart';
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
        lineOpacity: 0.7,
        lineColor: Colors.red.value,
        lineWidth: 8.0));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: MapView(
      key: ValueKey("mapView"),
      resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
      styleUri: Styles.MAPBOX_STREETS,
      cameraOptions: CameraOptions(
          center: Point(coordinates: Position(-122.486052, 37.830348)).toJson(),
          zoom: 14.0),
      onMapCreated: _onMapCreated,
    ));
  }
}
