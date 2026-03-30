import 'package:turf/turf.dart' show Point, Position;

extension City on Point {
	static Point get helsinki => Point(coordinates: Position.named(lat: 60.1699, lng: 24.9384));
	static Point get newYork => Point(coordinates: Position.named(lat: 40.7128, lng: -74.0060));
	static Point get berlin => Point(coordinates: Position.named(lat: 52.5200, lng: 13.4050));
}