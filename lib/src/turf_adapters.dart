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
    return Feature.fromJson(jsonDecode(result.first as String));
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

  factory Feature.fromFeature(Map<String?, Object?> feature) {
    var valid = convertToValidMap(feature as Map<Object?, Object?>);
    return Feature.fromJson(valid);
  }
}

Map<String, dynamic> convertToValidMap(Map<Object?, Object?> input) {
  return input.map((key, value) {
    if (key is! String) {
      throw Exception(
          "Invalid key type. Expected String but got ${key.runtimeType}");
    }
    if (value is Map<Object?, Object?>) {
      // Recursively convert nested maps
      return MapEntry(key, convertToValidMap(value));
    }
    return MapEntry(key, value);
  });
}

typedef JSONObject = Map<String, dynamic>;
