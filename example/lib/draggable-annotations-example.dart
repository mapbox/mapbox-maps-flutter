import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_example/example.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'utils.dart';

class DraggableAnnotationExample extends StatefulWidget implements Example {
  @override
  Widget get leading => Icon(Icons.map);

  @override
  String get subtitle => 'Demonstrates draggable annotations on the map.';

  @override
  String get title => 'Draggable Annotations Example';

  @override
  DraggableAnnotationExampleState createState() =>
      DraggableAnnotationExampleState();
}

class DraggableAnnotationExampleState
    extends State<DraggableAnnotationExample> {
  late final MapboxMap _mapboxMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        onMapCreated: (MapboxMap mapboxMap) {
          _mapboxMap = mapboxMap;
        },
        onStyleLoadedListener: _onStyleLoaded,
      ),
    );
  }

  void _onStyleLoaded(StyleLoadedEventData data) {
    _addPointAnnotation();
    _addCircleAnnotation();
    _addPolylineAnnotation();
    _addPolygonAnnotation();
  }

  void _addPointAnnotation() async {
    final pointAnnotationManager =
        await _mapboxMap.annotations.createPointAnnotationManager();
    final ByteData bytes =
        await rootBundle.load('assets/symbols/custom-icon.png');
    pointAnnotationManager.create(PointAnnotationOptions(
      geometry: City.berlin,
      image: bytes.buffer.asUint8List(),
      isDraggable: true,
    ));
    pointAnnotationManager.dragEvents(
      onBegin: (context) {
        print("point: Drag started");
      },
    );
  }

  void _addCircleAnnotation() async {
    final circleAnnotationManager =
        await _mapboxMap.annotations.createCircleAnnotationManager();
    circleAnnotationManager.create(CircleAnnotationOptions(
      geometry: City.helsinki,
      circleRadius: 10.0,
      circleColor: Colors.red.value,
      isDraggable: true,
    ));
    circleAnnotationManager.dragEvents(
      onBegin: (context) {
        print("circle: Drag started");
      },
    );
  }

  void _addPolylineAnnotation() async {
    final polylineAnnotationManager =
        await _mapboxMap.annotations.createPolylineAnnotationManager();
    polylineAnnotationManager.create(PolylineAnnotationOptions(
      geometry: LineString.fromPoints(points: [
        City.helsinki,
        City.berlin,
      ]),
      lineWidth: 2.0,
      isDraggable: true,
    ));
  }

  void _addPolygonAnnotation() async {
    final polygonAnnotationManager =
        await _mapboxMap.annotations.createPolygonAnnotationManager();
    polygonAnnotationManager.create(PolygonAnnotationOptions(
      geometry: Polygon(coordinates: [
        [
          Position(-77.0369, 38.9072),
          Position(-77.0434, 38.9072),
          Position(-77.0434, 38.9096),
          Position(-77.0369, 38.9096),
          Position(-77.0369, 38.9072),
        ]
      ]),
      fillOpacity: 0.5,
      fillColor: Colors.blue.value,
      isDraggable: true,
    ));
  }
}
