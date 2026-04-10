import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'dart:developer' show log;

class ViewportExample extends StatefulWidget {
  const ViewportExample({super.key});

  @override
  State<ViewportExample> createState() => _ViewportExampleState();
}

class _ViewportExampleState extends State<ViewportExample> {
  final _viewportController = ViewportController();

  List<City> cities = [
    City("Helsinki", helsinki, 180, const Duration(seconds: 4)),
    City("Tallinn", tallinn, 270, const Duration(seconds: 3)),
    City("Stockholm", stockholm, 75, const Duration(seconds: 4)),
  ];
  int _cityIndex = 0;
  int _flying = 0;

  @override
  void dispose() {
    _viewportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentCity = cities[_cityIndex % cities.length];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final nextCity = cities[(_cityIndex + 1) % cities.length];
          setState(() {
            _cityIndex++;
            _flying++;
          });
          _viewportController.moveTo(
            OverviewViewportState(
              geometry: nextCity.bounds,
              bearing: nextCity.bearing,
              pitch: 60,
            ),
            transition: FlyViewportTransition(
              duration: nextCity.animationDuration,
            ),
            completion: (result) {
              log(
                'Animation complete with $result, currentCity ${nextCity.name}',
              );
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
          pitch: 60,
        ),
        viewportController: _viewportController,
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

final Polygon stockholm = Polygon.fromPoints(
  points: [
    [
      Point(coordinates: Position(17.773725938954442, 59.427645823035704)),
      Point(coordinates: Position(17.773725938954442, 59.207635921479124)),
      Point(coordinates: Position(18.3063918953996, 59.207635921479124)),
      Point(coordinates: Position(18.3063918953996, 59.427645823035704)),
      Point(coordinates: Position(17.773725938954442, 59.427645823035704)),
    ],
  ],
);
final Polygon tallinn = Polygon.fromPoints(
  points: [
    [
      Point(coordinates: Position(24.569541031443407, 59.44873684041832)),
      Point(coordinates: Position(24.569541031443407, 59.33393207444456)),
      Point(coordinates: Position(24.948704180931742, 59.33393207444456)),
      Point(coordinates: Position(24.948704180931742, 59.44873684041832)),
      Point(coordinates: Position(24.569541031443407, 59.44873684041832)),
    ],
  ],
);
final Polygon helsinki = Polygon.fromPoints(
  points: [
    [
      Point(coordinates: Position(24.7457836509098, 60.26117083900044)),
      Point(coordinates: Position(24.7457836509098, 60.1615202856936)),
      Point(coordinates: Position(25.111325674190937, 60.1615202856936)),
      Point(coordinates: Position(25.111325674190937, 60.26117083900044)),
      Point(coordinates: Position(24.7457836509098, 60.26117083900044)),
    ],
  ],
);
