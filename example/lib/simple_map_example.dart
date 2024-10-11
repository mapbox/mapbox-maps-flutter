import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart' as turf;
import 'example.dart';

class SimpleMapExample extends StatefulWidget implements Example {
  const SimpleMapExample({super.key});

  @override
  final Widget leading = const Icon(Icons.map_outlined);
  @override
  final String title = 'Display a simple map';

  @override
  State<StatefulWidget> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMapExample> {
  _SimpleMapState();

  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  void _onStyleLoaded(StyleLoadedEventData styleLoadedEventData) {
    
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: ValueKey("mapWidget"),
      cameraOptions: CameraOptions(
          center: Point(
              coordinates: Position.named(lat: 60.167488, lng: 24.942747)),
          zoom: 11,
          bearing: 12,
          pitch: 60),
      onMapCreated: _onMapCreated,
      onStyleLoadedListener: _onStyleLoaded,
    );
  }
}
