import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/main.dart';
import 'package:mapbox_maps_example/utils.dart';
import 'package:permission_handler/permission_handler.dart';

import 'page.dart';

class AnimatedRoutePage extends ExamplePage {
  AnimatedRoutePage() : super(const Icon(Icons.map), 'Animated route line');

  @override
  Widget build(BuildContext context) {
    return const AnimatedRoute();
  }
}

class AnimatedRoute extends StatefulWidget {
  const AnimatedRoute();

  @override
  State createState() => AnimatedRouteState();
}

class AnimatedRouteState extends State<AnimatedRoute>
    with TickerProviderStateMixin {
  final defaultEdgeInsets =
      MbxEdgeInsets(top: 100, left: 100, bottom: 100, right: 100);

  late MapboxMap mapboxMap;
  late PointAnnotationManager pointAnnotationManager;
  Timer? timer;
  var trackLocation = true;
  var showAnnotations = false;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    this.pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();

    await _getPermission();
  }

  _getPermission() async {
    await Permission.locationWhenInUse.request();
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    setLocationComponent();
    refreshTrackLocation();
    refreshCarAnnotations();
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
          styleUri: MapboxStyles.LIGHT,
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

  refreshTrackLocation() async {
    timer?.cancel();
    if (trackLocation) {
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        final position = await mapboxMap.style.getPuckPosition();
        setCameraPosition(position);
      });
    }
  }

  // drop 4 random annotations around current location position
  refreshCarAnnotations() async {
    if (showAnnotations) {
      final myCoordinate = await mapboxMap.style.getPuckPosition();
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
        pointAnnotationManager.addAnnotation(imageData, coordinate);
      }

      pointAnnotationManager
          .addOnPointAnnotationClickListener(AnnotationClickListener(this));

      // animate camera to view annotations + puck position
      final camera = await mapboxMap.cameraForCoordinates(
          [...coordinates.map((e) => e), Point(coordinates: myCoordinate)],
          defaultEdgeInsets,
          null,
          null);
      mapboxMap.flyTo(camera, null);
    } else {
      pointAnnotationManager.deleteAll();
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
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  AnimatedRouteState mapState;

  Animation<double>? animation;
  AnimationController? controller;

  AnnotationClickListener(this.mapState);

  @override
  void onPointAnnotationClick(PointAnnotation annotation) async {
    if (await mapState.mapboxMap.style.styleSourceExists("source")) {
      await mapState.mapboxMap.style.removeStyleLayer("layer");
      await mapState.mapboxMap.style.removeStyleSource("source");
    }

    // build route from puck position to the clicked annotation
    final start = await mapState.mapboxMap.style.getPuckPosition();
    final end = annotation.geometry;

    final coordinates = await fetchRouteCoordinates(
        start, end.coordinates, MapsDemo.ACCESS_TOKEN);

    drawRouteLowLevel(coordinates);
  }

  drawRouteLowLevel(List<Position> polyline) async {
    final line = LineString(coordinates: polyline);
    mapState.mapboxMap.style.styleSourceExists("source").then((exists) async {
      if (exists) {
        // if source exists - just update it
        final source = await mapState.mapboxMap.style.getSource("source");
        (source as GeoJsonSource).updateGeoJSON(json.encode(line));
      } else {
        await mapState.mapboxMap.style.addSource(GeoJsonSource(
            id: "source", data: json.encode(line), lineMetrics: true));

        await mapState.mapboxMap.style.addLayer(LineLayer(
          id: 'layer',
          sourceId: 'source',
          lineCap: LineCap.ROUND,
          lineJoin: LineJoin.ROUND,
          lineBlur: 1.0,
          lineColor: Colors.deepOrangeAccent.value,
          lineDasharray: [1.0, 2.0],
          lineTrimOffset: [0.0, 0.0],
          lineWidth: 5.0,
        ));
      }

      // query line layer
      final lineLayer =
          await mapState.mapboxMap.style.getLayer('layer') as LineLayer;

      // draw layer with gradient
      mapState.mapboxMap.style.setStyleLayerProperty("layer", "line-gradient",
          '["interpolate",["linear"],["line-progress"],0.0,["rgb",255,0,0],0.4,["rgb",0,255,0],1.0,["rgb",0,0,255]]');

      // animate layer to reveal it from start to end
      controller?.stop();
      controller = AnimationController(
          duration: const Duration(seconds: 2), vsync: mapState);
      animation = Tween<double>(begin: 0, end: 1.0).animate(controller!)
        ..addListener(() async {
          // set the animated value of lineTrim and update the layer
          lineLayer.lineTrimOffset = [animation?.value, 1.0];
          mapState.mapboxMap.style.updateLayer(lineLayer);
        });
      controller?.forward();
    });
  }
}
