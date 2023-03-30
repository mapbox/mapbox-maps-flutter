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
  final name = "modelName";
  final key = "model-id-key";
  final modelIdKey = "model-id-key";
  final sourceId = "source-id";
  final modelId = "model-id";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        MapWidget(
          onMapCreated: (mapController) {
            this._mapController = mapController;
          },
          key: ValueKey("mapWidget"),
          resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
          cameraOptions: CameraOptions(
              center:
                  Point(coordinates: Position(50.0249701, 26.1992264)).toJson(),
              zoom: 18.0),
          styleUri: MapboxStyles.LIGHT,
          textureView: true,
          onStyleLoadedListener: (_) async {
            // _mapController.style.getLayer("source1").then((value) => print(value));
          },
        ),
        Row(
          children: [
            ElevatedButton(onPressed: _addModel, child: Text('Add model')),
            ElevatedButton(
                onPressed: () async {
                  var styleManager = _mapController.style;
                  var hasModel = await styleManager.hasModel(modelId);
                  var hasLayer =
                      await styleManager.styleLayerExists("model-layer-id");
                  print(hasModel);
                  print(hasLayer);
                  if (hasModel && hasLayer) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Removing model")));
                    await styleManager.removeStyleLayer("model-layer-id");
                    await styleManager.removeModel(modelId);
                    await styleManager.removeStyleSource(sourceId);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Model not added")));
                  }
                },
                child: Text('Remove model')),
            ElevatedButton(
                onPressed: () async {
                  var styleManager = _mapController.style;

                  var hasModel = await styleManager.hasModel(modelId);
                  var hasGeojson =
                      await styleManager.styleSourceExists(sourceId);
                  var hasLayer =
                      await styleManager.styleLayerExists("model-layer-id");
                  print(hasModel);
                  print(hasLayer);
                  print(hasGeojson);
                  if (hasModel && hasLayer) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Model exists")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Model not found")));
                  }
                },
                child: Text('has model')),
            ElevatedButton(
                onPressed: () async {
                  var styleManager = _mapController.style;
                  styleManager.getLayer('model-layer-id').then((value) =>
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("""
                  Model layer :
                  modelId: ${(value as ModelLayer?)?.modelId}
                  visibility: ${(value)?.visibility}
                  modelType: ${(value)?.modelType}
                  sourceLayer: ${(value)?.sourceLayer}
                  modelOpacity: ${(value)?.modelOpacity}
                  modelColor: ${(value)?.modelColor}
                  modelTranslation: ${(value)?.modelTranslation}
                  modelColorMixIntensity: ${(value)?.modelColorMixIntensity}
                  modelScale: ${(value)?.modelScale}
                  modelRotation: ${(value)?.modelRotation}
                  minZoom: ${(value)?.minZoom}
                  maxZoom: ${(value)?.maxZoom}"""
                            .trim()),
                        backgroundColor: Theme.of(context).primaryColor,
                        duration: Duration(seconds: 2),
                      )));
                },
                child: Text('model details')),
          ],
        )
      ],
    ));
  }

  void _addModel() async {
    print("addModel");
    try {
      await _mapController.style.addModel(modelId,
          'https://docs.mapbox.com/mapbox-gl-js/assets/34M_17/34M_17.gltf');

      var geoJsonSource = GeoJsonSource(
          id: sourceId,
          data: jsonEncode(FeatureCollection(features: [
            Feature(
                id: "feature1",
                geometry: Point(coordinates: Position(50.0249701, 26.1992264)),
                properties: {modelIdKey: modelId}),
          ]).toJson()));
      await _mapController.style.addSource(geoJsonSource);

      var modelLayer = ModelLayer(
          id: "model-layer-id",
          sourceId: sourceId,
          modelType: ModelType.COMMON_3D,
          modelId: modelId,
          modelTranslation: [1.2,1.5,1.5],
          modelRotation: [1.0,1.0,1.0],
          modelScale: [1.0, 1.0, 1.0]);
      await _mapController.style.addLayer(modelLayer);
    } catch (error) {
      print(error);
    }
  }
}
