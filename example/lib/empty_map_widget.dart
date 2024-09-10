import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class Events {
  var onMapIdle = Completer();
  var onMapLoaded = Completer();
  var onStyleLoaded = Completer();
  var onStyleDataLoaded = Completer();
  var onSourceDataLoaded = Completer();
  var onCameraChanged = Completer();

  void resetOnMapLoaded() => onMapLoaded = Completer();
  void resetOnStyleLoaded() => onStyleLoaded = Completer();
  void resetOnStyleDataLoaded() => onStyleDataLoaded = Completer();
  void resetOnSourceDataLoaded() => onSourceDataLoaded = Completer();
  void resetOnCameraChanged() => onCameraChanged = Completer();
  void resetOnMapIdle() => onMapIdle = Completer();
}

var events = Events();

Future<MapboxMap> main() {
  final completer = Completer<MapboxMap>();

  const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');
  MapboxOptions.setAccessToken(
      "pk.eyJ1IjoiZXZpbDE1OSIsImEiOiJja3licnp3aW0waWU1MnZuMGFpcXgzMTN5In0.34sUmpVbGc4VEWWXxvWelA");
  print("kkk: running the app");
  events = Events();
  runApp(MaterialApp(
      home: MapWidget(
    key: ValueKey("mapWidget"),
    onMapCreated: (MapboxMap mapboxMap) {
      print("kkk: map created");
      completer.complete(mapboxMap);
    },
    onMapLoadedListener: (MapLoadedEventData data) {
      print("kkk: map loaded");
      if (!events.onMapLoaded.isCompleted) {
        events.onMapLoaded.complete();
      } else {
        throw Exception();
      }
    },
    onStyleLoadedListener: (StyleLoadedEventData data) {
      print("kkk: style loaded");
      if (!events.onStyleLoaded.isCompleted) {
        events.onStyleLoaded.complete();
      } else {
        throw Exception();
      }
    },
    onStyleDataLoadedListener: (StyleDataLoadedEventData data) {
      print("kkk: style data loaded");
      if (!events.onStyleDataLoaded.isCompleted) {
        events.onStyleDataLoaded.complete();
      }
    },
    onSourceDataLoadedListener: (SourceDataLoadedEventData data) {
      print("kkk: source data loaded");
      if (!events.onSourceDataLoaded.isCompleted) {
        events.onSourceDataLoaded.complete();
      }
    },
    onCameraChangeListener: (CameraChangedEventData data) {
      if (!events.onCameraChanged.isCompleted) {
        events.onCameraChanged.complete();
      }
    },
    onMapIdleListener: (MapIdleEventData data) {
      print("kkk: map idle");
      if (!events.onMapIdle.isCompleted) {
        events.onMapIdle.complete();
      }
    },
  )));

  return Future.wait([
    completer.future,
    events.onStyleLoaded.future,
  ]).then((value) => value.first as MapboxMap);
}

Future<MapboxMap> runFixedSizeMap() {
  final completer = Completer<MapboxMap>();

  const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');
  MapboxOptions.setAccessToken(
      "pk.eyJ1IjoiZXZpbDE1OSIsImEiOiJja3licnp3aW0waWU1MnZuMGFpcXgzMTN5In0.34sUmpVbGc4VEWWXxvWelA");

  runApp(MaterialApp(
      home: Align(
    alignment: Alignment.topLeft,
    child: Container(
      width: 300,
      height: 300,
      child: MapWidget(
          key: ValueKey("mapWidget"),
          onMapCreated: (MapboxMap mapboxMap) {
            completer.complete(mapboxMap);
          }),
    ),
  )));

  return completer.future;
}

Future<MapboxMap> runMapWithCustomCamera(CameraOptions camera) {
  final completer = Completer<MapboxMap>();

  const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');
  MapboxOptions.setAccessToken(
      "pk.eyJ1IjoiZXZpbDE1OSIsImEiOiJja3licnp3aW0waWU1MnZuMGFpcXgzMTN5In0.34sUmpVbGc4VEWWXxvWelA");

  runApp(MaterialApp(
    home: MapWidget(
        key: ValueKey("mapWidget"),
        cameraOptions: camera,
        onMapCreated: (MapboxMap mapboxMap) {
          completer.complete(mapboxMap);
        }),
  ));

  return completer.future;
}

void runEmpty() {
  const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');
  MapboxOptions.setAccessToken(
      'pk.eyJ1IjoiZXZpbDE1OSIsImEiOiJja3licnp3aW0waWU1MnZuMGFpcXgzMTN5In0.34sUmpVbGc4VEWWXxvWelA');

  runApp(MaterialApp());
}
