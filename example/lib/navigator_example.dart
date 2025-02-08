import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/utils.dart';
import 'package:permission_handler/permission_handler.dart';

import 'example.dart';

class NavigatorExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Navigation Component';
  @override
  final String? subtitle = null;

  @override
  State<StatefulWidget> createState() => NavigatorExampleState();
}

class NavigatorExampleState extends State<NavigatorExample>
    with TickerProviderStateMixin {
  NavigatorExampleState();

  late MapboxMap mapboxMap;

  NavigationCameraState navigationCameraState = NavigationCameraState.IDLE;

  Timer? timer;
  Animation<double>? animation;
  AnimationController? controller;

  bool styleLoaded = false;

  bool firstLocationUpdateReceived = false;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) async {
    print("Style loaded");
    styleLoaded = true;
    //await mapboxMap.navigation.startTripSession(true);
    print("Trip navigation started");
    await _start();
    print("Trip started");
  }

  _onNavigationRouteReadyListener() async {
    print("Navigation route ready");
  }

  _onNavigationRouteFailedListener() async {
    print("Navigation route failed");
  }

  _onNewLocationListener(NavigationLocation location) async {
    print("Location updated: (${location.latitude},${location.longitude})");

    if (firstLocationUpdateReceived) {
      if (navigationCameraState == NavigationCameraState.FOLLOWING) {
        // RouteProgress observer might cause a camera issue, that is why we mgiht have to correct camera our own
        await updateCamera(location);
      }

      return;
    }

    firstLocationUpdateReceived = true;

    if (!styleLoaded) {
      return;
    }

    await _start();
  }

  _onFollowingClicked() async {
    await mapboxMap.navigation.requestNavigationCameraToFollowing();
  }

  _onOverviewClicked() async {
    await mapboxMap.navigation.requestNavigationCameraToOverview();
  }

  _onNavigationCameraStateListener(NavigationCameraState state) {
    print("Navigation camera state: $state");
    navigationCameraState = state;
  }

  Future updateCamera(NavigationLocation location) async {
    await mapboxMap.easeTo(
        CameraOptions(
            center: Point(
                coordinates: Position(location.longitude!, location.latitude!)),
            zoom: 17,
            pitch: 45,
            padding: MbxEdgeInsets(top: 300.0, left: 0, bottom: 0, right: 0),
            bearing: location.bearing),
        MapAnimationOptions(duration: 100));
  }

  Future _start() async {
    await Permission.location.request();
    print("Permissions requested");

    final ByteData bytes = await rootBundle.load('assets/puck_icon.png');
    final Uint8List list = bytes.buffer.asUint8List();
    await mapboxMap.location.updateSettings(LocationComponentSettings(
        enabled: true,
        puckBearingEnabled: true,
        locationPuck: LocationPuck(
            locationPuck2D: DefaultLocationPuck2D(
                topImage: list,
                bearingImage: Uint8List.fromList([]),
                shadowImage: Uint8List.fromList([])))));

    print("Puck enabled");
    //var myCoordinate = await mapboxMap.style.getPuckPosition();
    //if (myCoordinate == null) {
      print("Puck location was not defined");
      var lastLocation = await mapboxMap.navigation.lastLocation();
      if (lastLocation == null) {
        print("Current location is not defined");
        return;
      }

    var myCoordinate = Position(lastLocation.longitude!, lastLocation.latitude!);
   // }

    await mapboxMap
        .setCamera(CameraOptions(center: Point(coordinates: myCoordinate)));
    print("Camera centered to the current user location");

    final destinationCoordinate = createRandomPositionAround(myCoordinate);

    await mapboxMap.navigation.setRoute([
      Point(coordinates: myCoordinate),
      Point(coordinates: destinationCoordinate)
    ]);

    await mapboxMap.navigation.startTripSession(true);
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      styleUri: MapboxStyles.MAPBOX_STREETS,
      onMapCreated: _onMapCreated,
      onStyleLoadedListener: _onStyleLoadedCallback,
      onNewLocationListener: _onNewLocationListener,
      onNavigationRouteRenderedListener: _onNavigationRouteReadyListener,
      onNavigationRouteFailedListener: _onNavigationRouteFailedListener,
      onNavigationCameraStateListener: _onNavigationCameraStateListener,
      onRouteProgressListener: (routeProgress) =>
          {print("Distance remaining: ${routeProgress.distanceRemaining}")},
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(children: [
          Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 180,
                child: mapWidget),
          ),
          Padding(
              padding: const EdgeInsets.all(8),
              child: FloatingActionButton(
                elevation: 4,
                heroTag: "following",
                onPressed: _onFollowingClicked,
                child: const Icon(Icons.mode_standby),
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(72, 8, 8, 8),
              child: FloatingActionButton(
                elevation: 5,
                heroTag: "overview",
                onPressed: _onOverviewClicked,
                child: const Icon(Icons.route),
              )),
        ]),
      ],
    );
  }
}
