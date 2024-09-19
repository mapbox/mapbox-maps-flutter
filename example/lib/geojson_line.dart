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
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) async {
    var data = await rootBundle
        .loadString('assets/from_crema_to_council_crest.geojson');

    await mapboxMap?.style.addSource(GeoJsonSource(id: "line", data: data));
    await mapboxMap?.style.addLayer(LineLayer(
        id: "line_layer",
        sourceId: "line",
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineColor: Colors.red.value,
        lineWidth: 6.0));

    // Wait 5 seconds, then update the GeoJSONSource with the new line
    await Future.delayed(Duration(seconds: 5));

    var newFeature = Feature(
        id: "featureID",
        geometry: LineString(coordinates: [
          Position(-122.483696, 37.833818),
          Position(-122.4861, 37.828802),
          Position(-122.493782, 37.833683),
          Position(-122.48959, 37.8366109),
          Position(-122.483696, 37.833818)
        ]));
    await mapboxMap?.style
        .updateGeoJSONSourceFeatures("line", "new_line", [newFeature]);
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
            onStyleLoadedListener: _onStyleLoadedCallback));
  }
}
