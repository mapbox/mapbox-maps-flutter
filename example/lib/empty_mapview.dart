import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps/mapbox_maps.dart';

import 'main.dart';

Future<MapboxMap> main() {
  final completer = Completer<MapboxMap>();

  runApp(MaterialApp(
      home: MapView(
          key: ValueKey("mapView"),
          onMapCreated: (MapboxMap mapboxMap) {
            completer.complete(mapboxMap);
          },
          resourceOptions:
              ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN))));

  return completer.future;
}
