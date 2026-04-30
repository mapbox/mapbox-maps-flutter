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
  var onMapTapListener = Completer();
  var onMapLongTapListener = Completer();
  List<MapContentGestureContext> mapInteractions = [];
  var sourceDataIDs = [""];

  void resetOnMapLoaded() => onMapLoaded = Completer();
  void resetOnStyleLoaded() => onStyleLoaded = Completer();
  void resetOnStyleDataLoaded() => onStyleDataLoaded = Completer();
  void resetOnSourceDataLoaded() => {
    sourceDataIDs.clear(),
    onSourceDataLoaded = Completer(),
  };
  void resetOnCameraChanged() => onCameraChanged = Completer();
  void resetOnMapIdle() => onMapIdle = Completer();
  void resetOnMapTapListener() => onMapTapListener = Completer();
  void resetOnMapLongTapListener() => onMapLongTapListener = Completer();
  void resetMapInteractions() => mapInteractions.clear();
}

var events = Events();

Future<MapboxMap> main({
  double? width,
  double? height,
  ViewportState? viewport,
  Alignment alignment = Alignment.topLeft,
}) {
  final completer = Completer<MapboxMap>();

  events = Events();
  runApp(
    MaterialApp(
      home: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          height: height,
          child: MapWidget(
            key: const ValueKey("mapWidget"),
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
              final dataID = data.dataId;
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
      ),
    ),
  );

  return Future.wait([
    completer.future,
    events.onStyleLoaded.future,
  ]).then((value) => value.first as MapboxMap);
}

void runEmpty() {
  runApp(const MaterialApp());
}
