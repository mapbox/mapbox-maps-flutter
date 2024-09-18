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

  Polygon.fromPoints({turf.BBox? bbox, required List<List<Point>> points})
      : super.fromPoints(bbox: bbox, points: points);
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

  LineString.fromPoints({turf.BBox? bbox, required List<Point> points})
      : super.fromPoints(bbox: bbox, points: points);
}

final class Feature extends turf.Feature {
  Feature(
      {super.bbox,
      required super.id,
      super.properties,
      required super.geometry,
      super.fields});

  Object encode() {
    return [toJson()];
  }

  static Feature decode(Object result) {
    result as List<Object?>;
    return Feature.fromJson((result.first as Map).cast<String, dynamic>());
  }

  factory Feature.fromJson(Map<String, dynamic> json) {
    final feature = turf.Feature.fromJson(json);
    return Feature(
        bbox: feature.bbox,
        id: feature.id,
        properties: feature.properties,
        geometry: feature.geometry,
        fields: feature.fields);
  }
}
