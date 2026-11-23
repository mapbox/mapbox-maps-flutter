import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class TrafficRouteLineExample extends StatefulWidget {
  const TrafficRouteLineExample({super.key});

  @override
  State<TrafficRouteLineExample> createState() =>
      _TrafficRouteLineExampleState();
}

class _TrafficRouteLineExampleState extends State<TrafficRouteLineExample> {
  MapboxMap? _mapboxMap;
  final _sfAirport = Point(
    coordinates: Position(-122.39470445734368, 37.7080221537549),
  );

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
    final routeGeoJson = await rootBundle.loadString(
      'assets/sf_airport_route.geojson',
    );
    await _mapboxMap?.addSource(GeoJsonSource(id: "line", data: routeGeoJson));
    await _mapboxMap?.addLayer(
      LineLayer(
        id: "line-layer",
        sourceId: "line",
        lineBorderColor: Colors.black.toARGB32(),
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
            'rgb(51, 102, 255)',
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        key: const ValueKey("mapWidget"),
        viewport: CameraViewportState(center: _sfAirport, zoom: 11.0),
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoaded,
      ),
    );
  }
}
