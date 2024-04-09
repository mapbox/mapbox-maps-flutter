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
  MapboxOptions.setAccessToken(ACCESS_TOKEN);

  events = Events();
  runApp(MaterialApp(
      home: MapWidget(
    key: ValueKey("mapWidget"),
    onMapCreated: (MapboxMap mapboxMap) {
      completer.complete(mapboxMap);
    },
    onMapLoadedListener: (MapLoadedEventData data) {
      if (!events.onMapLoaded.isCompleted) {
        events.onMapLoaded.complete();
      }
    },
    onStyleLoadedListener: (StyleLoadedEventData data) {
      if (!events.onStyleLoaded.isCompleted) {
        events.onStyleLoaded.complete();
      }
    },
    onStyleDataLoadedListener: (StyleDataLoadedEventData data) {
      if (!events.onStyleDataLoaded.isCompleted) {
        events.onStyleDataLoaded.complete();
      }
    },
    onSourceDataLoadedListener: (SourceDataLoadedEventData data) {
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
  MapboxOptions.setAccessToken(ACCESS_TOKEN);

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

void runEmpty() {
  const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');
  MapboxOptions.setAccessToken(ACCESS_TOKEN);

  runApp(MaterialApp());
}
