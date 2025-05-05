import 'package:flutter/material.dart' hide Visibility;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'example.dart';

class TrafficLayerExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Traffic Layer';
  @override
  final String? subtitle = "Toggle traffic layer on/off";

  const TrafficLayerExample({super.key});

  @override
  State<StatefulWidget> createState() => TrafficLayerExampleState();
}

class TrafficLayerExampleState extends State<TrafficLayerExample> {
  TrafficLayerExampleState();
  final _sfAirport =
      Point(coordinates: Position(-122.39470445734368, 37.7080221537549));
  MapboxMap? mapboxMap;
  bool? _trafficLayerVisible = true;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) async {
    await addTrafficLayer();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> addTrafficLayer() async {
    // Add the vector source
    await mapboxMap?.style.addSource(VectorSource(
      id: 'traffic-source',
      url: 'mapbox://mapbox.mapbox-traffic-v1',
    ));
    // Add the traffic layer
    await mapboxMap?.style.addLayer(
      LineLayer(
        id: 'traffic-layer',
        sourceId: 'traffic-source',
        sourceLayer: 'traffic',
        visibility: _trafficLayerVisible != null && _trafficLayerVisible!
            ? Visibility.VISIBLE
            : Visibility.NONE,
        lineCap: LineCap.ROUND,
        lineJoin: LineJoin.ROUND,
        lineWidthExpression: [
          'interpolate',
          ['linear'],
          ['zoom'],
          14.0,
          ['*', 2.0, 1.3],
          20.0,
          ['*', 10, 1.2]
        ],
        lineColorExpression: [
          'case',
          [
            '==',
            'low',
            ['get', 'congestion']
          ],
          '#39c66d',
          [
            '==',
            'moderate',
            ['get', 'congestion']
          ],
          '#ff8c1a',
          [
            '==',
            'heavy',
            ['get', 'congestion']
          ],
          '#ff0015',
          [
            '==',
            'severe',
            ['get', 'congestion']
          ],
          '#981b25',
          '#000000'
        ],
        lineOffsetExpression: [
          'interpolate',
          ['linear'],
          ['zoom'],
          14.0,
          ['*', 2, 1.0],
          20.0,
          ['*', 18, 1.0]
        ],
      ),
    );
  }

  Future<void> toggleTrafficLayer() async {
    setState(() {
      _trafficLayerVisible = !_trafficLayerVisible!;
    });
    await mapboxMap!.style.setStyleLayerProperty(
      'traffic-layer',
      'visibility',
      _trafficLayerVisible! ? 'visible' : 'none',
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      cameraOptions: CameraOptions(center: _sfAirport, zoom: 11.0),
      onMapCreated: _onMapCreated,
      onStyleLoadedListener: _onStyleLoadedCallback,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () async {
          await toggleTrafficLayer();
        },
        child: Icon(
          _trafficLayerVisible! ? Icons.visibility_off : Icons.visibility,
        ),
      ),
      body: mapWidget,
    );
  }
}
