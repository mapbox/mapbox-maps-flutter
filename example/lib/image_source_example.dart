import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'example.dart';

class ImageSourceExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Image source';

  @override
  State createState() => ImageSourceExampleState();
}

class ImageSourceExampleState extends State<ImageSourceExample> {
  MapboxMap? mapboxMap;
  var isLight = true;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    await mapboxMap?.style
        .addSource(ImageSource(id: "image_source-id", coordinates: [
      [-80.11725, 25.7836],
      [-80.1397431334, 25.783548],
      [-80.13964, 25.7680],
      [-80.11725, 25.76795]
    ]));
    await mapboxMap?.style.addLayer(RasterLayer(
      id: "image_layer-id",
      sourceId: "image_source-id",
    ));
    var imageSource =
        await mapboxMap?.style.getSource("image_source-id") as ImageSource;
    final ByteData bytes = await rootBundle.load('assets/miami_beach.png');
    final Uint8List list = bytes.buffer.asUint8List();
    imageSource.updateImage(MbxImage(width: 280, height: 203, data: list));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: MapWidget(
      key: ValueKey("mapWidget"),
      styleUri: MapboxStyles.DARK,
      cameraOptions: CameraOptions(
          center: Point(coordinates: Position(-80.1263, 25.7845)), zoom: 12.0),
      onMapCreated: _onMapCreated,
      onStyleLoadedListener: _onStyleLoaded,
    ));
  }
}
