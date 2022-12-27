import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/main.dart';
import 'package:mapbox_maps_example/page.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart';

class ModelPage extends ExamplePage {
  ModelPage() : super(Icon(Icons.format_shapes), '3d Model');

  @override
  Widget build(BuildContext context) {
    return Model();
  }
}

class Model extends StatefulWidget {
  const Model({Key? key}) : super(key: key);

  @override
  State<Model> createState() => _ModelState();
}

class _ModelState extends State<Model> {
  late MapboxMap _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MapWidget(
      onMapCreated: (mapController) {
        this._mapController = mapController;
      },
      key: ValueKey("mapWidget"),
      resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
      cameraOptions: CameraOptions(
          center: Point(coordinates: Position(50.0249701, 26.1992264)).toJson(),
          zoom: 16.0),
      styleUri: MapboxStyles.LIGHT,
      textureView: true,
      onStyleLoadedListener: (_) async {
        final name = "modelName";
        final key = "model-id-key";

        await _mapController.style.addModel(ModelSource(
            id: name,
            uri: Uri.parse(
                'https://docs.mapbox.com/mapbox-gl-js/assets/34M_17/34M_17.gltf')));
        await _mapController.style.addSource(GeoJsonSource(
            id: name,
            data: jsonEncode(FeatureCollection(features: [
              Feature(
                  id: "source12",
                  geometry:
                      Point(coordinates: Position(50.0249701, 26.1992264)),
                  properties: {key: name}),
            ]).toJson())));
        await _mapController.style.addLayer(ModelLayer(
            id: name, sourceId: name, modelId: name, scale: [1.0, 1.0, 1.0]));

        // _mapController.style.getLayer("source1").then((value) => print(value));
      },
    ));
  }
}
