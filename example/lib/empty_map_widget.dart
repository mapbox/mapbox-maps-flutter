import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'main.dart';

Future<MapboxMap> main() {
  final completer = Completer<MapboxMap>();

  runApp(MaterialApp(
      home: MapWidget(
          key: ValueKey("mapWidget"),
          onMapCreated: (MapboxMap mapboxMap) {
            completer.complete(mapboxMap);
          },
          resourceOptions:
              ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN))));

  return completer.future;
}
