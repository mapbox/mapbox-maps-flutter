import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// Cities the examples open on.
abstract final class City {
  static final helsinki = Point(coordinates: Position(24.945831, 60.192059));
}

const _directionsEndpoint =
    'https://api.mapbox.com/directions/v5/mapbox/driving/';

/// Requests a driving route between two points and returns its geometry.
///
/// The Directions API returns the route as an encoded polyline, which
/// [Polyline.decode] expands back into coordinates.
Future<List<Position>> fetchRouteCoordinates(
  Position start,
  Position end,
  String accessToken,
) async {
  final uri = Uri.parse(
    '$_directionsEndpoint${start.lng},${start.lat};${end.lng},${end.lat}'
    '?overview=full&access_token=$accessToken',
  );
  final response = await http.get(uri);
  final route = jsonDecode(response.body) as Map<String, dynamic>;
  return Polyline.decode(route['routes'][0]['geometry']);
}
