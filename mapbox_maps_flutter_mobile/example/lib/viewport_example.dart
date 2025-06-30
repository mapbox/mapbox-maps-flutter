import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class ViewportExample extends StatefulWidget implements Example {
  const ViewportExample({super.key});

  @override
  final Widget leading = const Icon(Icons.flight_takeoff);
  @override
  final String title = 'Move camera with viewport';
  @override
  final String subtitle =
      'Move the camera to different cities with viewport animations.';

  @override
  State<StatefulWidget> createState() => _ViewportExampleState();
}

class _ViewportExampleState extends State<ViewportExample> {
  _ViewportExampleState();

  List<City> cities = [
    City("Helsinki", helsinki, 180, const Duration(seconds: 4)),
    City("Tallinn", tallinn, 270, const Duration(seconds: 3)),
    City("Stockholm", stockholm, 75, const Duration(seconds: 4)),
  ];
  int _cityIndex = 0;
  int _flying = 0;

  @override
  Widget build(BuildContext context) {
    final currentCity = cities[_cityIndex % cities.length];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setStateWithViewportAnimation(
            () {
              _cityIndex++;
              _flying++;
            },
            transition: FlyViewportTransition(
              duration:
                  cities[(_cityIndex + 1) % cities.length].animationDuration,
            ),
            completion: (result) {
              print(
                  'Animation complete with $result, currentCity ${currentCity.name}');
              setState(() => _flying--);
            },
          );
        },
        child: _flying == 0
            ? const Icon(Icons.flight_takeoff)
            : const Icon(Icons.flight),
      ),
      body: MapWidget(
        key: ValueKey("mapWidget"),
        viewport: OverviewViewportState(
            geometry: currentCity.bounds,
            bearing: currentCity.bearing,
            pitch: 60),
      ),
    );
  }
}

final class City {
  final String name;
  final Polygon bounds;
  final double bearing;
  final Duration animationDuration;
  const City(this.name, this.bounds, this.bearing, this.animationDuration);
}

final Polygon stockholm = Polygon.fromPoints(points: [
  [
    Point(coordinates: Position(17.773725938954442, 59.427645823035704)),
    Point(coordinates: Position(17.773725938954442, 59.207635921479124)),
    Point(coordinates: Position(18.3063918953996, 59.207635921479124)),
    Point(coordinates: Position(18.3063918953996, 59.427645823035704)),
    Point(coordinates: Position(17.773725938954442, 59.427645823035704)),
  ]
]);
final Polygon tallinn = Polygon.fromPoints(points: [
  [
    Point(coordinates: Position(24.569541031443407, 59.44873684041832)),
    Point(coordinates: Position(24.569541031443407, 59.33393207444456)),
    Point(coordinates: Position(24.948704180931742, 59.33393207444456)),
    Point(coordinates: Position(24.948704180931742, 59.44873684041832)),
    Point(coordinates: Position(24.569541031443407, 59.44873684041832)),
  ]
]);
final Polygon helsinki = Polygon.fromPoints(points: [
  [
    Point(coordinates: Position(24.7457836509098, 60.26117083900044)),
    Point(coordinates: Position(24.7457836509098, 60.1615202856936)),
    Point(coordinates: Position(25.111325674190937, 60.1615202856936)),
    Point(coordinates: Position(25.111325674190937, 60.26117083900044)),
    Point(coordinates: Position(24.7457836509098, 60.26117083900044)),
  ]
]);
