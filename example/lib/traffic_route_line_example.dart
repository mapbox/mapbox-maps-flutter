import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_example/example.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class TrafficRouteLineExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.turn_sharp_left);
  @override
  final String title = 'Style a route showing traffic';
  @override
  final String subtitle =
      "Use LineLayer to style a route line with traffic data.";

  @override
  State createState() => TrafficRouteLineExampleState();
}

class TrafficRouteLineExampleState extends State<TrafficRouteLineExample> {
  late MapboxMap mapboxMap;
  final _sfAirport =
      Point(coordinates: Position(-122.39470445734368, 37.7080221537549));

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) async {
    final data = await rootBundle.loadString('assets/sf_airport_route.geojson');
    await mapboxMap.style.addSource(GeoJsonSource(id: "line", data: data));
    await _addRouteLine();
  }

  _addRouteLine() async {
    await mapboxMap.style.addLayer(LineLayer(
      id: "line-layer",
      sourceId: "line",
      lineBorderColor: Colors.black.value,
      // Defines a line-width, line-border-width and line-color at different zoom extents
      // by interpolating exponentially between stops.
      // Doc: https://docs.mapbox.com/style-spec/reference/expressions/
      lineWidthExpression: [
        'interpolate',
        ['exponential', 1.5],
        ['zoom'],
        4.0,
        6.0,
        10.0,
        7.0,
        13.0,
        9.0,
        16.0,
        3.0,
        19.0,
        7.0,
        22.0,
        21.0,
      ],
      lineBorderWidthExpression: [
        'interpolate',
        ['exponential', 1.5],
        ['zoom'],
        9.0,
        1.0,
        16.0,
        3.0,
      ],
      lineColorExpression: [
        'interpolate',
        ['linear'],
        ['zoom'],
        8.0,
        'rgb(51, 102, 255)',
        11.0,
        [
          'coalesce',
          ['get', 'route-color'],
          'rgb(51, 102, 255)'
        ],
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const SizedBox(height: 10),
            ],
          ),
        ),
        body: MapWidget(
            key: const ValueKey("mapWidget"),
            cameraOptions: CameraOptions(center: _sfAirport, zoom: 11.0),
            textureView: true,
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoadedCallback));
  }
}
