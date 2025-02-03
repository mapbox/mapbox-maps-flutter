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
  var sourceDataIDs = [""];

  void resetOnMapLoaded() => onMapLoaded = Completer();
  void resetOnStyleLoaded() => onStyleLoaded = Completer();
  void resetOnStyleDataLoaded() => onStyleDataLoaded = Completer();
  void resetOnSourceDataLoaded() =>
      {sourceDataIDs.clear(), onSourceDataLoaded = Completer()};
  void resetOnCameraChanged() => onCameraChanged = Completer();
  void resetOnMapIdle() => onMapIdle = Completer();
}

var events = Events();
const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

Future<MapboxMap> main(
    {double? width,
    double? height,
    CameraOptions? camera,
    ViewportState? viewport,
    Alignment alignment = Alignment.topLeft}) {
  final completer = Completer<MapboxMap>();

  MapboxOptions.setAccessToken(ACCESS_TOKEN);

  events = Events();
  runApp(MaterialApp(
      home: Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      width: width,
      height: height,
      child: MapWidget(
        key: ValueKey("mapWidget"),
        androidHostingMode: AndroidPlatformViewHostingMode.VD,
        cameraOptions: camera,
        viewport: viewport,
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
          var dataID = data.dataId;
          if (dataID != null) {
            events.sourceDataIDs.add(dataID);
          }
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
      ),
    ),
  )));

  return Future.wait([
    completer.future,
    events.onStyleLoaded.future,
  ]).then((value) => value.first as MapboxMap);
}

void runEmpty() {
  MapboxOptions.setAccessToken(ACCESS_TOKEN);

  runApp(MaterialApp());
}
