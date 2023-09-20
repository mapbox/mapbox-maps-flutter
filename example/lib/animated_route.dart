import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as MapboxMaps;
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

    mapboxMap.subscribe(_eventObserver, [
      MapEvents.STYLE_LOADED,
      MapEvents.MAP_LOADED,
      MapEvents.MAP_IDLE,
    ]);

    await _getPermission();
  }

  _getPermission() async {
    await Permission.locationWhenInUse.request();
  }

  _eventObserver(Event event) {
    // print("Receive event, type: ${event.type}, data: ${event.data}");
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
          resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
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
      final camera = await mapboxMap.cameraForCoordinates([
        ...coordinates.map((e) => e.toJson()),
        Point(coordinates: myCoordinate).toJson()
      ], defaultEdgeInsets, null, null);
      mapboxMap.flyTo(camera, null);
    } else {
      pointAnnotationManager.deleteAll();
    }
  }

  setCameraPosition(Position position) {
    mapboxMap.flyTo(
        CameraOptions(
          center: Point(coordinates: position).toJson(),
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

    final end = Point.fromJson((annotation.geometry)!.cast());

    showAnimatedCircle(end);
  }

  Layer buildCircleLayer(double radius) {
    return CircleLayer(
      id: 'layer',
      sourceId: 'source',
      circleBlur: 0.1,
      circleColor: Colors.blueAccent.value,
      circleOpacity: 0.3,
      circleRadius: radius,
    );
  }

  void showAnimatedCircle(Point end) async {
    mapState.mapboxMap.style.styleSourceExists("source").then((exists) async {
      if (exists) {
        final source =
            await mapState.mapboxMap.style.getSource("source") as GeoJsonSource;
        source.updateGeoJSON(json.encode(end));
        mapState.mapboxMap.style.updateLayer(buildCircleLayer(0.0));
      } else {
        await mapState.mapboxMap.style
            .addSource(GeoJsonSource(id: "source", data: json.encode(end)));

        await mapState.mapboxMap.style.addLayer(buildCircleLayer(0.0));
      }

      controller?.stop();
      controller = AnimationController(
          duration: const Duration(seconds: 2), vsync: mapState);
      animation = Tween<double>(begin: 0, end: 1.0).animate(controller!)
        ..addListener(() async {
          final radius = animation!.value * 100;
          mapState.mapboxMap.style.updateLayer(buildCircleLayer(radius));
        });
      controller?.forward();
    });
  }
}
