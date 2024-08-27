import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/src/polyline.dart';

extension City on Point {
  static var helsinki = Point(coordinates: Position(24.945831, 60.192059));
}

Point createRandomPoint() {
  return Point(coordinates: createRandomPosition());
}

Position createRandomPosition() {
  var random = Random();
  return Position(random.nextDouble() * -360.0 + 180.0,
      random.nextDouble() * -180.0 + 90.0);
}

List<Position> createRandomPositionList() {
  var random = Random();
  final positions = <Position>[];
  for (int i = 0; i < random.nextInt(6) + 4; i++) {
    positions.add(createRandomPosition());
  }

  return positions;
}

List<List<Position>> createRandomPositionsList() {
  var random = Random();
  final first = createRandomPosition();
  final positions = <Position>[];
  positions.add(first);
  for (int i = 0; i < random.nextInt(6) + 4; i++) {
    positions.add(createRandomPosition());
  }
  positions.add(first);

  return [positions];
}

int createRandomColor() {
  var random = Random();
  return Color.fromARGB(
          255, random.nextInt(255), random.nextInt(255), random.nextInt(255))
      .value;
}

final annotationStyles = [
  MapboxStyles.MAPBOX_STREETS,
  MapboxStyles.OUTDOORS,
  MapboxStyles.LIGHT,
  MapboxStyles.DARK,
  MapboxStyles.SATELLITE_STREETS
];

const MAPBOX_DIRECTIONS_ENDPOINT =
    "https://api.mapbox.com/directions/v5/mapbox/driving/";

Position createRandomPositionAround(Position myPosition) {
  var random = Random();
  return Position(myPosition.lng + random.nextDouble() / 10,
      myPosition.lat + random.nextDouble() / 10);
}

extension AnnotationCreation on PointAnnotationManager {
  addAnnotation(Uint8List imageData, Point position, {String textField = ""}) {
    return create(PointAnnotationOptions(
        geometry: position,
        textField: textField,
        textOffset: [0.0, -2.0],
        textColor: Colors.red.value,
        iconSize: 1.3,
        iconOffset: [0.0, -5.0],
        symbolSortKey: 10,
        image: imageData));
  }
}

extension PuckPosition on StyleManager {
  Future<Position?> getPuckPosition() async {
    Layer? layer;
    if (Platform.isAndroid) {
      layer = await getLayer("mapbox-location-indicator-layer");
    } else {
      layer = await getLayer("puck");
    }
    final location = (layer as LocationIndicatorLayer).location;
    if (location == null) {
      return null;
    }
    return Future.value(Position(location[1]!, location[0]!));
  }
}

extension PolylineCreation on PolylineAnnotationManager {
  addAnnotation(List<Position> coordinates) {
    return PolylineAnnotationOptions(
        geometry: LineString(coordinates: coordinates),
        lineColor: Colors.red.value,
        lineWidth: 2);
  }
}

Future<List<Position>> fetchRouteCoordinates(
    Position start, Position end, String accessToken) async {
  final response = await fetchDirectionRoute(start, end, accessToken);
  Map<String, dynamic> route = jsonDecode(response.body);
  return Polyline.decode(route['routes'][0]['geometry']);
}

Future<http.Response> fetchDirectionRoute(
    Position start, Position end, String accessToken) async {
  final uri = Uri.parse(
      "$MAPBOX_DIRECTIONS_ENDPOINT${start.lng},${start.lat};${end.lng},${end.lat}?overview=full&access_token=$accessToken");
  return http.get(uri);
}
