part of mapbox_maps_flutter;

final class Point extends turf.Point {
  Point({super.bbox, required super.coordinates});

  factory Point.fromJson(Map<String, dynamic> json) {
    final turfPoint = turf.Point.fromJson(json);
    return Point(bbox: turfPoint.bbox, coordinates: turfPoint.coordinates);
  }

  static Point decode(Object result) {
    result as List<Object?>;
    return Point.fromJson((result.first as Map).cast<String, dynamic>());
  }

  Object encode() {
    return [toJson()];
  }
}
