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

final class Polygon extends turf.Polygon {
  Polygon({super.bbox, required super.coordinates});

  Object encode() {
    return [toJson()];
  }

  static Polygon decode(Object result) {
    result as List<Object?>;
    return Polygon.fromJson((result.first as Map).cast<String, dynamic>());
  }

  factory Polygon.fromJson(Map<String, dynamic> json) {
    final polygon = turf.Polygon.fromJson(json);
    return Polygon(bbox: polygon.bbox, coordinates: polygon.coordinates);
  }
}

final class LineString extends turf.LineString {
  LineString({super.bbox, required super.coordinates});

  Object encode() {
    return [toJson()];
  }

  static LineString decode(Object result) {
    result as List<Object?>;
    return LineString.fromJson((result.first as Map).cast<String, dynamic>());
  }

  factory LineString.fromJson(Map<String, dynamic> json) {
    final line = turf.LineString.fromJson(json);
    return LineString(bbox: line.bbox, coordinates: line.coordinates);
  }
}
