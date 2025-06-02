import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

Future<MapboxMap> main(
    {double? width,
    double? height,
    CameraOptions? camera,
    Alignment alignment = Alignment.topLeft}) {
  final completer = Completer<MapboxMap>();

  MapboxOptions.setAccessToken(ACCESS_TOKEN);

  runApp(MaterialApp(
      home: Align(
    alignment: alignment,
    child: SizedBox(
      width: width,
      height: height,
      child: MapWidget(
        key: ValueKey("mapWidget"),
        cameraOptions: camera,
        onMapCreated: (MapboxMap mapboxMap) {
          completer.complete(mapboxMap);
        },
      ),
    ),
  )));

  return completer.future;
}

void runEmpty() {
  MapboxOptions.setAccessToken(ACCESS_TOKEN);

  runApp(MaterialApp());
}
