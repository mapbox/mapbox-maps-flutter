import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class SimpleMapExample extends StatefulWidget implements Example {
  const SimpleMapExample({super.key});

  @override
  final Widget leading = const Icon(Icons.map_outlined);
  @override
  final String title = 'Display a simple map';
  @override
  final String subtitle =
      'Create and display a map that uses the default Mapbox Standard style.';

  @override
  State<StatefulWidget> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMapExample> {
  _SimpleMapState();

  late ViewportTransition _immediateTransition;
  late ViewportTransition _defaultTransition;
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _isFollowing = !_isFollowing;
          });
        },
        child: _isFollowing
            ? const Icon(Icons.my_location)
            : const Icon(Icons.zoom_out_map),
      ),
      body: MapWidget(
        key: ValueKey("mapWidget"),
        viewport: _isFollowing
            ? const FollowPuckViewportState(bearing: FollowPuckViewportStateBearingCourse())
            : OverviewViewportState(geometry: helsinki),
      ),
    );
  }
}

final Polygon helsinki = Polygon.fromPoints(points: [
  [
    Point(
        coordinates:
            Position.named(lat: 60.26117083900044, lng: 24.7457836509098)),
    Point(
        coordinates:
            Position.named(lat: 60.1615202856936, lng: 24.7457836509098)),
    Point(
        coordinates:
            Position.named(lat: 60.1615202856936, lng: 25.111325674190937)),
    Point(
        coordinates:
            Position.named(lat: 60.26117083900044, lng: 25.111325674190937)),
    Point(
        coordinates:
            Position.named(lat: 60.26117083900044, lng: 24.7457836509098)),
  ]
]);
