import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_example/example.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'utils.dart';

class DraggableAnnotationExample extends StatefulWidget implements Example {
  @override
  Widget get leading => Icon(Icons.touch_app);

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
    for (int i = 0; i < 100; i++) {
      pointAnnotationManager.create(PointAnnotationOptions(
        geometry: createRandomPoint(),
        image: bytes.buffer.asUint8List(),
        textField: "point $i",
        isDraggable: true,
      ));
    }
    pointAnnotationManager.dragEvents(
      onBegin: (annotation) {
        print("point: ${annotation.id} Drag started");
      },
    );
  }

  void _addCircleAnnotation() async {
    final circleAnnotationManager =
        await _mapboxMap.annotations.createCircleAnnotationManager();
    for (int i = 0; i < 100; i++) {
      circleAnnotationManager.create(CircleAnnotationOptions(
        geometry: createRandomPoint(),
        circleRadius: 10.0,
        circleColor: createRandomColor(),
        isDraggable: true,
      ));
    }
    circleAnnotationManager.dragEvents(
      onBegin: (annotation) {
        print("circle: ${annotation.id} Drag started");
      },
    );
  }

  void _addPolylineAnnotation() async {
    final polylineAnnotationManager =
        await _mapboxMap.annotations.createPolylineAnnotationManager();
    for (int i = 0; i < 100; i++) {
      polylineAnnotationManager.create(PolylineAnnotationOptions(
        geometry: LineString.fromPoints(points: [
          createRandomPoint(),
          createRandomPoint(),
        ]),
        lineWidth: 5.0,
        lineColor: createRandomColor(),
        isDraggable: true,
      ));
    }
    polylineAnnotationManager.dragEvents(
      onBegin: (annotation) {
        print("polyline: ${annotation.id} Drag started");
      },
    );
  }

  void _addPolygonAnnotation() async {
    final polygonAnnotationManager =
        await _mapboxMap.annotations.createPolygonAnnotationManager();
    polygonAnnotationManager.create(PolygonAnnotationOptions(
        geometry: Polygon(coordinates: [
          [
            Position(24.941024, 60.173324), // Helsinki
            Position(13.404954, 52.520008), // Berlin
            Position(30.523333, 50.450001), // Kyiv
            Position(24.941024, 60.173324) // Back to Helsinki
          ]
        ]),
        fillColor: Colors.blue.value,
        fillOutlineColor: Colors.green.value,
        isDraggable: true));
    polygonAnnotationManager.dragEvents(
      onBegin: (annotation) {
        print("polygon: ${annotation.id} Drag started");
      },
    );
  }
}
