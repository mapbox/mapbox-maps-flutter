import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

final onMapLoaded = Completer();

Future<MapboxMap> main() {
  final completer = Completer<MapboxMap>();

  runApp(MaterialApp(
      home: MapWidget(
    key: ValueKey("mapWidget"),
    onMapCreated: (MapboxMap mapboxMap) {
      completer.complete(mapboxMap);
    },
    onMapLoadedListener: (MapLoadedEventData data) {
      if (!onMapLoaded.isCompleted) {
        onMapLoaded.complete();
      }
    },
  )));

  return completer.future;
}

Future<MapboxMap> runFixedSizeMap() {
  final completer = Completer<MapboxMap>();

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
