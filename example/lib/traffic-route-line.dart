import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_example/page.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class TrafficRouteLinePage extends ExamplePage {
  TrafficRouteLinePage()
      : super(
            const Icon(Icons.turn_sharp_left), 'Style a route showing traffic');

  @override
  Widget build(BuildContext context) {
    return const RouteLine();
  }
}

class RouteLine extends StatefulWidget {
  const RouteLine();

  @override
  State createState() => RouteLineState();
}

class RouteLineState extends State<RouteLine> {
  late MapboxMap mapboxMap;
  final _sfAirport =
      Point(coordinates: Position(-122.39470445734368, 37.7080221537549));

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    final data = await rootBundle.loadString('assets/sf_airport_route.geojson');
    await mapboxMap.style.addSource(GeoJsonSource(id: "line", data: data));
    await _addRouteLine();
  }

  _addRouteLine() async {
    await mapboxMap.style.addLayer(LineLayer(
      id: "line-layer",
      sourceId: "line",
      lineBorderColor: Colors.black.value,
    ));
    // Defines a line-width, line-border-width and line-color at different zoom extents
    // by interpolating exponentially between stops.
    // Doc: https://docs.mapbox.com/style-spec/reference/expressions/
    await mapboxMap.style.setStyleLayerProperty(
        "line-layer",
        "line-width",
        '''
        ["interpolate", ["exponential", 1.5], ["zoom"],
        4.0, ["*", 6.0, 1.0],
        10.0, ["*", 7.0, 1.0],
        13.0, ["*", 9.0, 1.0],
        16.0, ["*", 13.0, 1.0],
        19.0, ["*", 17.0, 1.0],
        22.0, ["*", 21.0, 1.0]
        ]
        '''
            .trim()
            .replaceAll("\n", ""));
    await mapboxMap.style.setStyleLayerProperty(
        "line-layer",
        "line-border-width",
        '''
        ["interpolate", ["exponential", 1.5], ["zoom"],
        9.0, ["*", 1.0, 1.0],
        16.0, ["*", 3.0, 1.0]
        ]
        '''
            .trim()
            .replaceAll("\n", ""));
    await mapboxMap.style.setStyleLayerProperty(
        "line-layer",
        "line-color",
        '''
        ["interpolate", ["linear"], ["zoom"],
        8.0, "rgb(51, 102, 255)",
        11.0, ["coalesce", ["get", "route-color"], "rgb(51, 102, 255)"]
        ]
        '''
            .trim()
            .replaceAll("\n", ""));
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
        ));
  }
}
