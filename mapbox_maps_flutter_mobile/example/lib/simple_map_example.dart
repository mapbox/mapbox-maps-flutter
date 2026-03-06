import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class SimpleMapExample extends StatefulWidget implements Example {
  const SimpleMapExample({super.key});

  @override
  final Widget leading = const Icon(Icons.map_outlined);
  @override
  final String title = 'Display a simple map';
  @override
  final String subtitle =
      'Create and display a map that uses the default Mapbox Standard style.';

  @override
  State<StatefulWidget> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMapExample> {
  _SimpleMapState();

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      styleUri: MapboxStyles.STANDARD,
      viewport: CameraViewportState(
        center: Point(coordinates: Position(-117.918976, 33.812092)),
        zoom: 15.0,
      ),
    );
  }
}
