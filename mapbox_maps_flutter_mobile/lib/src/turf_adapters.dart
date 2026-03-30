part of mapbox_maps_flutter_mobile;

extension type Point._(turf.Point _point) implements turf.Point {
  Point({turf.BBox? bbox, required turf.Position coordinates})
    : _point = turf.Point(bbox: bbox, coordinates: coordinates);

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point._(turf.Point.fromJson(json));
  }

  static Point decode(Object result) {
    var map = (result is List<Object?>) ? result.first : result;
    return Point.fromJson((map as Map).cast<String, dynamic>());
  }

  Object encode() {
    return [toJson()];
  }
}

extension type Polygon._(turf.Polygon _polygon) implements turf.Polygon {
  Polygon({turf.BBox? bbox, required List<List<turf.Position>> coordinates})
    : _polygon = turf.Polygon(bbox: bbox, coordinates: coordinates);

  factory Polygon.fromJson(Map<String, dynamic> json) {
    return Polygon._(turf.Polygon.fromJson(json));
  }

  static Polygon decode(Object result) {
    var map = (result is List<Object?>) ? result.first : result;
    return Polygon.fromJson((map as Map).cast<String, dynamic>());
  }

  Object encode() {
    return [toJson()];
  }

  Polygon.fromPoints({turf.BBox? bbox, required List<List<Point>> points})
    : _polygon = turf.Polygon.fromPoints(bbox: bbox, points: points);
}

extension type LineString._(turf.LineString _line) implements turf.LineString {
  LineString({turf.BBox? bbox, required List<turf.Position> coordinates})
    : _line = turf.LineString(bbox: bbox, coordinates: coordinates);

  factory LineString.fromJson(Map<String, dynamic> json) {
    return LineString._(turf.LineString.fromJson(json));
  }

  static LineString decode(Object result) {
    var map = (result is List<Object?>) ? result.first : result;
    return LineString.fromJson((map as Map).cast<String, dynamic>());
  }

  Object encode() {
    return [toJson()];
  }

  LineString.fromPoints({turf.BBox? bbox, required List<Point> points})
    : _line = turf.LineString.fromPoints(bbox: bbox, points: points);
}

extension type Feature<T extends turf.GeometryObject>._(
  turf.Feature<T> _feature
)
    implements turf.Feature<T> {
  Feature({
    turf.BBox? bbox,
    required Object? id,
    Map<String, Object?>? properties,
    required T geometry,
    Map<String, Object?>? fields,
  }) : _feature = turf.Feature(
         bbox: bbox,
         id: id,
         properties: properties,
         geometry: geometry,
         fields: fields ?? const {},
       );

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature._(turf.Feature.fromJson(json));
  }

  static Feature decode(Object result) {
    result as List<Object?>;
    return Feature.fromJson(jsonDecode(result.first as String));
  }

  Object encode() {
    return [toJson()];
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
        "Invalid key type. Expected String but got ${key.runtimeType}",
      );
    }
    if (value is Map<Object?, Object?>) {
      // Recursively convert nested maps
      return MapEntry(key, convertToValidMap(value));
    }
    return MapEntry(key, value);
  });
}
