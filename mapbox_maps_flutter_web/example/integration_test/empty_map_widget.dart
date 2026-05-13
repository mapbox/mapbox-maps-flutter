import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';

const _accessTokenValue = String.fromEnvironment('ACCESS_TOKEN');

void main({
  ViewportState? viewport,
  PlatformMapCreatedCallback? onMapCreated,
}) {
  accessToken = _accessTokenValue;

  runApp(
    MaterialApp(
      home: Scaffold(
        body: MapWebWidget(
          viewport: viewport,
          onMapCreated: onMapCreated,
        ),
      ),
    ),
  );
}
