import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter_examples/utils.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;

class AnimatedRouteExample extends StatefulWidget {
  const AnimatedRouteExample({super.key});

  @override
  State createState() => AnimatedRouteExampleState();
}

class AnimatedRouteExampleState extends State<AnimatedRouteExample>
    with TickerProviderStateMixin {
  static const String _accessToken = String.fromEnvironment('ACCESS_TOKEN');

  final defaultEdgeInsets = MbxEdgeInsets(
    top: 100,
    left: 100,
    bottom: 100,
    right: 100,
  );

  late MapboxMap mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  final _viewportController = ViewportController();
  Animation<double>? animation;
  AnimationController? controller;
  var trackLocation = true;
  var showAnnotations = false;

  @override
  void dispose() {
    _viewportController.dispose();
    controller?.dispose();
    super.dispose();
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    pointAnnotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();

    await _getPermission();
  }

  Future<void> _getPermission() async {
    await Geolocator.requestPermission();
  }

  Future<void> _onStyleLoadedCallback(StyleLoadedEventData data) async {
    _addRouteLineLayerAndSource();
    setLocationComponent();
    refreshTrackLocation();
    refreshCarAnnotations();
    await mapboxMap.setStyleImportConfigProperty(
      "basemap",
      "theme",
      "monochrome",
    );
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
              child: Icon(Icons.my_location),
            ),
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
              child: const Icon(CupertinoIcons.car_detailed),
            ),
          ],
        ),
      ),
      body: MapWidget(
        key: const ValueKey("mapWidget"),
        viewportController: _viewportController,
        styleUri: MapboxStyles.STANDARD,
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoadedCallback,
      ),
    );
  }

  Future<void> setLocationComponent() async {
    await mapboxMap.location.updateSettings(
      LocationComponentSettings(enabled: true),
    );
  }

  Future<void> _addRouteLineLayerAndSource() async {
    await mapboxMap.addLayer(
      LineLayer(
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
          ["rgb", 0, 0, 255],
        ],
      ),
    );

    await mapboxMap.addSource(
      GeoJsonSource(id: "source", lineMetrics: true),
    );
  }

  void refreshTrackLocation() {
    // Let the viewport follow the location puck instead of polling its
    // position and moving the camera manually.
    _viewportController.moveTo(
      trackLocation ? FollowPuckViewportState() : const IdleViewportState(),
      transition: const FlyViewportTransition(),
    );
  }

  // drop 4 random annotations around current location position
  Future<void> refreshCarAnnotations() async {
    if (showAnnotations) {
      final myCoordinate = await getCurrentPosition();

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

      final ByteData bytes = await rootBundle.load(
        'assets/symbols/custom-icon.png',
      );
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
        null,
      );
      mapboxMap.flyTo(camera, null);
    } else {
      pointAnnotationManager?.deleteAll();
    }
  }

  void onPointAnnotationClick(PointAnnotation annotation) async {
    // build route from the current location to the clicked annotation
    final start = await getCurrentPosition();

    if (start == null) {
      return;
    }

    final end = annotation.geometry;

    final coordinates = await fetchRouteCoordinates(
      start,
      end.coordinates,
      _accessToken,
    );

    drawRouteLowLevel(coordinates);
  }

  Future<void> drawRouteLowLevel(List<Position> polyline) async {
    final line = LineString(coordinates: polyline);
    final source = await mapboxMap.getSource("source");
    (source as GeoJsonSource).updateGeoJSON(json.encode(line));

    // animate layer to reveal it from start to end
    controller?.stop();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1.0).animate(controller!)
      ..addListener(() async {
        // set the animated value of lineTrim and update the layer
        mapboxMap.setStyleLayerProperty("layer", "line-trim-offset", [
          animation?.value,
          1.0,
        ]);
      });
    controller?.forward();
  }
}
