import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class DebugMap extends StatelessWidget {
  late final MapboxMap mapboxMap;
  static const String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");

  final helsinki = Point(coordinates: Position(24.93545, 60.16952));
  final padding = MbxEdgeInsets(top: 100, left: 100, bottom: 100, right: 100);
  late final List<Point> coordinates;

  _showCamera1() {
    mapboxMap.cameraForCoordinates(
        [...coordinates.map((e) => e.toJson()), helsinki.toJson()],
        MbxEdgeInsets(top: 100, left: 100, bottom: 100, right: 100),
        null, null
    ).then((value) => mapboxMap.flyTo(value, null));
  }

  _showCamera2() {
    mapboxMap.cameraForGeometry(
        Polygon.fromPoints(points: [[...coordinates, helsinki]]).toJson(),
        padding,
        null, null
    ).then((value) => mapboxMap.flyTo(value, null));
  }

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    coordinates = [
      Point(coordinates: createRandomPositionAround(helsinki.coordinates)),
      Point(coordinates: createRandomPositionAround(helsinki.coordinates)),
      Point(coordinates: createRandomPositionAround(helsinki.coordinates)),
      Point(coordinates: createRandomPositionAround(helsinki.coordinates)),
    ];
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    final annotationsManager = await mapboxMap.annotations.createCircleAnnotationManager(id: "test-points");
    annotationsManager.create(CircleAnnotationOptions(
        geometry: helsinki.toJson(),
        circleColor: Colors.red.value,
        circleRadius: 10.0));
    annotationsManager.createMulti(coordinates.map((e) => CircleAnnotationOptions(
        geometry: Point(coordinates: e.coordinates).toJson(),
        circleColor: Colors.blue.value,
        circleRadius: 6.0)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
                heroTag: null,
                onPressed: _showCamera1,
                child: const Icon(FontAwesomeIcons.one)),
            const SizedBox(height: 10),
            FloatingActionButton(
                heroTag: null,
                onPressed: _showCamera2,
                child: const Icon(FontAwesomeIcons.two)),
          ],
        ),
      ),
      body: Stack(
        children: [
          MapWidget(
            key: ValueKey("mapWidget"),
            cameraOptions: CameraOptions(center: helsinki.toJson()),
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(padding.left, padding.top, padding.right, padding.bottom),
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.blueAccent),
            ),
          )
        ],
      )
    );
  }
}

Position createRandomPositionAround(Position myPosition) {
  var random = Random();
  return Position(myPosition.lng + random.nextDouble() / 10,
      myPosition.lat + random.nextDouble() / 10);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Alternatively you can replace `String.fromEnvironment("ACCESS_TOKEN")`
  // in the following line with your access token directly.
  MapboxOptions.setAccessToken(DebugMap.ACCESS_TOKEN);
  runApp(MaterialApp(home: DebugMap()));
}