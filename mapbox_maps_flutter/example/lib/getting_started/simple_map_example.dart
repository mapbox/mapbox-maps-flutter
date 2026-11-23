import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class SimpleMapExample extends StatelessWidget {
  const SimpleMapExample({super.key});

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
