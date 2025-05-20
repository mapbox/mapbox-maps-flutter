import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

extension City on Point {
  static Point get helsinki =>
      Point(coordinates: Position.of([24.941, 60.173]));
  static Point get saigon => Point(coordinates: Position.of([106.700, 10.776]));
}
