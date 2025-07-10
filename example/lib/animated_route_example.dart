import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/main.dart';
import 'package:mapbox_maps_example/utils.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;

import 'example.dart';

class AnimatedRouteExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'High level animation';
  @override
  final String? subtitle = null;

  @override
  State createState() => AnimatedRouteExampleState();
}

class AnimatedRouteExampleState extends State<AnimatedRouteExample>
    with TickerProviderStateMixin {
  final defaultEdgeInsets =
      MbxEdgeInsets(top: 100, left: 100, bottom: 100, right: 100);

  late MapboxMap mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  Timer? timer;
  Animation<double>? animation;
  AnimationController? controller;
  var trackLocation = true;
  var showAnnotations = false;

  @override
  void dispose() {
    timer?.cancel();
    controller?.dispose();
    super.dispose();
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    this.pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();

    await _getPermission();
  }

  _getPermission() async {
    await Geolocator.requestPermission();
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    _addRouteLineLayerAndSource();
    setLocationComponent();
    refreshTrackLocation();
    refreshCarAnnotations();
    mapboxMap.style.setStyleImportConfigProperty("basemap", "theme", "monochrome");
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
                  onPressed: () {
                    setState(() {
                      trackLocation = !trackLocation;
                      refreshTrackLocation();
                    });
                  },
                  backgroundColor: trackLocation ? Colors.blue : Colors.grey,
                  child: const Icon(FontAwesomeIcons.locationCrosshairs)),
              const SizedBox(height: 10),
              FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    setState(() {
                      showAnnotations = !showAnnotations;
                      refreshCarAnnotations();
                      if (showAnnotations) {
                        trackLocation = false;
                        refreshTrackLocation();
                      }
                    });
                  },
                  backgroundColor: showAnnotations ? Colors.blue : Colors.grey,
                  child: const Icon(CupertinoIcons.car_detailed)),
            ],
          ),
        ),
        body: MapWidget(
          key: const ValueKey("mapWidget"),
          cameraOptions: CameraOptions(zoom: 3.0),
          styleUri: MapboxStyles.STANDARD,
          textureView: true,
          onMapCreated: _onMapCreated,
          onStyleLoadedListener: _onStyleLoadedCallback,
        ));
  }

  setLocationComponent() async {
    await mapboxMap.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
      ),
    );
  }

  void _addRouteLineLayerAndSource() async {
    await mapboxMap.style.addLayer(LineLayer(
      id: 'layer',
      sourceId: 'source',
      lineCap: LineCap.ROUND,
      lineJoin: LineJoin.ROUND,
      lineBlur: 1.0,
      lineColor: Colors.deepOrangeAccent.value,
      lineDasharray: [1.0, 2.0],
      lineWidth: 5.0,
      // draw layer with gradient
      lineGradientExpression: [
        "interpolate",
        ["linear"],
        ["line-progress"],
        0.0,
        ["rgb", 255, 0, 0],
        0.4,
        ["rgb", 0, 255, 0],
        1.0,
        ["rgb", 0, 0, 255]
      ],
    ));

    await mapboxMap.style
        .addSource(GeoJsonSource(id: "source", lineMetrics: true));
  }

  refreshTrackLocation() async {
    timer?.cancel();
    if (trackLocation) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        try {
          final position = await mapboxMap.style.getPuckPosition();
          if (position != null) {
            setCameraPosition(position);
          }
        } catch (e) {
          print(e);
        }
      });
    }
  }

  // drop 4 random annotations around current location position
  refreshCarAnnotations() async {
    if (showAnnotations) {
      final myCoordinate = await mapboxMap.style.getPuckPosition();

      if (myCoordinate == null) {
        return;
      }
      // shows bunch of random points around puck position
      List<Point> coordinates = [
        Point(coordinates: createRandomPositionAround(myCoordinate)),
        Point(coordinates: createRandomPositionAround(myCoordinate)),
        Point(coordinates: createRandomPositionAround(myCoordinate)),
        Point(coordinates: createRandomPositionAround(myCoordinate)),
      ];

      final ByteData bytes =
          await rootBundle.load('assets/symbols/custom-icon.png');
      final Uint8List imageData = bytes.buffer.asUint8List();

      for (Point coordinate in coordinates) {
        pointAnnotationManager?.addAnnotation(imageData, coordinate);
      }

      pointAnnotationManager?.tapEvents(onTap: onPointAnnotationClick);

      // animate camera to view annotations + puck position
      final camera = await mapboxMap.cameraForCoordinates(
          [...coordinates.map((e) => e), Point(coordinates: myCoordinate)],
          defaultEdgeInsets,
          null,
          null);
      mapboxMap.flyTo(camera, null);
    } else {
      pointAnnotationManager?.deleteAll();
    }
  }

  setCameraPosition(Position position) {
    mapboxMap.flyTo(
        CameraOptions(
          center: Point(coordinates: position),
          padding: defaultEdgeInsets,
          zoom: 10,
        ),
        null);
  }

  void onPointAnnotationClick(PointAnnotation annotation) async {
    // build route from puck position to the clicked annotation
    final start = await mapboxMap.style.getPuckPosition();

    if (start == null) {
      return;
    }

    final end = annotation.geometry;

    final coordinates = await fetchRouteCoordinates(
        start, end.coordinates, MapsDemo.ACCESS_TOKEN);

    drawRouteLowLevel(coordinates);
  }

  drawRouteLowLevel(List<Position> polyline) async {
    final line = LineString(coordinates: polyline);
    final source = await mapboxMap.style.getSource("source");
    (source as GeoJsonSource).updateGeoJSON(json.encode(line));

    // animate layer to reveal it from start to end
    controller?.stop();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 1.0).animate(controller!)
      ..addListener(() async {
        // set the animated value of lineTrim and update the layer
        mapboxMap.style.setStyleLayerProperty(
            "layer", "line-trim-offset", [animation?.value, 1.0]);
      });
    controller?.forward();
  }
}
