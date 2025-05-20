import 'package:mapbox_maps_flutter_v3/mapbox_maps_flutter_v3.dart';

extension City on Point {
  static Point get helsinki =>
      Point(coordinates: Position.of([24.941, 60.173]));
  static Point get saigon => Point(coordinates: Position.of([106.700, 10.776]));
}
