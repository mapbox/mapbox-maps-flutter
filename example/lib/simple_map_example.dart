import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart' as turf;
import 'page.dart';

class SimpleMapExample extends StatefulWidget implements Example {
  @override
  Widget get leading => const Icon(Icons.map);
  @override
  String get title => 'Style interface';

  const SimpleMapExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMapExample> {
  _SimpleMapState();

  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.annotations.createCircleAnnotationManager()
  }

  void _onStyleLoaded(StyleLoadedEventData styleLoadedEventData) {

  }
 
  @override
  Widget build(BuildContext context) {
    return MapWidget(
        key: ValueKey("mapWidget"),
        cameraOptions: CameraOptions(center: Point(coordinates: Position.named(lat: 41.879, lng: -87.635)), zoom: 11, bearing: 12, pitch: 60),);
  }
}
