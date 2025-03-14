import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class ModelLayerInteractionsExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.touch_app);
  @override
  final String title = 'Model Layer Interactions';
  @override
  final String? subtitle =
      'Showcase of Interactions using custom 3D Model Layers';
  const ModelLayerInteractionsExample({super.key});

  @override
  State<ModelLayerInteractionsExample> createState() =>
      _ModelLayerInteractionsExampleState();
}

class _ModelLayerInteractionsExampleState
    extends State<ModelLayerInteractionsExample> {
  MapboxMap? mapboxMap;

  var model1Position = Position(24.9453, 60.1716);
  var model2Position = Position(24.9453, 60.1720);

  addModelLayer() async {
    //Use Feature Colection to add multiple features on the same layer
    var value1 = FeatureCollection(features: [
      Feature(
          id: 1, //Feature IDs should be Integers for the Model to be recognised by the Mapbox Interactions API
          geometry: Point(
            coordinates: model1Position,
          ),
          properties: {"name": "BUGGY", 'type': 'FeatureCollection'}),
    ]);

    var value2 = Feature(
        id: 2, //Feature IDs should be Integers for the Model to be recognised by the Mapbox Interactions API
        geometry: Point(coordinates: model2Position),
        properties: {"name": "CAR", 'type': 'Feature'});
    if (mapboxMap == null) {
      throw Exception("MapboxMap is not ready yet");
    }

    final buggyModelId = "model-test-id";
    final buggyModelUri =
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/d7a3cc8e51d7c573771ae77a57f16b0662a905c6/2.0/Buggy/glTF/Buggy.gltf";
    await mapboxMap?.style.addStyleModel(buggyModelId, buggyModelUri);

    final carModelId = "model-car-id";
    final carModelUri = "asset://flutter_assets/assets/sportcar.glb";
    await mapboxMap?.style.addStyleModel(carModelId, carModelUri);

    await mapboxMap?.style
        .addSource(GeoJsonSource(id: "sourceId1", data: json.encode(value1)));
    await mapboxMap?.style
        .addSource(GeoJsonSource(id: "sourceId2", data: json.encode(value2)));

    var modelLayer = ModelLayer(id: "modelLayer-buggy", sourceId: "sourceId1");
    modelLayer.modelId = buggyModelId;
    modelLayer.modelScale = [0.15, 0.15, 0.15];
    modelLayer.modelRotation = [0, 0, 90];
    modelLayer.modelType = ModelType.COMMON_3D;
    mapboxMap?.style.addLayer(modelLayer);

    var modelLayer1 = ModelLayer(id: "modelLayer-car", sourceId: "sourceId2");
    modelLayer1.modelId = carModelId;
    modelLayer1.modelScale = [7, 7, 7];
    modelLayer1.modelRotation = [0, 0, 90];
    modelLayer1.modelType = ModelType.COMMON_3D;
    mapboxMap?.style.addLayer(modelLayer1);
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    addModelLayer();
  }

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.style;

    //Tap Interaction for FeatureCollection Layer
    var tapInteractionFeatureCollection = TapInteraction(
        FeaturesetDescriptor(layerId: "modelLayer-buggy"), (features, point) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Single Tap Interaction Detected"),
            content: SingleChildScrollView(
              child: Text(
                  "You clicked on the ${features.properties['name'].toString()} model implemented using the ${features.properties['type'].toString()} type"),
            ),
          );
        },
      );
    }, radius: 100);
    mapboxMap.addInteraction(tapInteractionFeatureCollection,
        interactionID: "tap_interaction_buggy");

    //Tap Interaction for Feature Layer
    var tapInteractionFeature = TapInteraction(
        FeaturesetDescriptor(layerId: "modelLayer-car"), (features, point) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Single Tap Interaction Detected'),
            content: SingleChildScrollView(
              child: Text(
                  "You clicked on the ${features.properties['name'].toString()} model implemented using the ${features.properties['type'].toString()} type"),
            ),
          );
        },
      );
    }, radius: 100);
    mapboxMap.addInteraction(tapInteractionFeature,
        interactionID: "tap_interaction_car");

    //LongTap Interaction for Feature Layer
    var longTapInteractionFeature = LongTapInteraction(
        FeaturesetDescriptor(layerId: "modelLayer-car"), (features, point) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Long Tap Interaction Detected'),
            content: SingleChildScrollView(
              child: Text(
                  "You clicked on the ${features.properties['name'].toString()} model implemented using the ${features.properties['type'].toString()} type"),
            ),
          );
        },
      );
    }, radius: 100);
    mapboxMap.addInteraction(longTapInteractionFeature,
        interactionID: "long_tap_interaction_car");

    //Tap Interaction for FeatureCollection Layer
    var longTapInteractionFeatureCollection = LongTapInteraction(
        FeaturesetDescriptor(layerId: "modelLayer-buggy"), (features, point) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Long Tap Interaction Detected'),
            content: SingleChildScrollView(
              child: Text(
                  "You clicked on the ${features.properties['name'].toString()} model implemented using the ${features.properties['type'].toString()} type"),
            ),
          );
        },
      );
    }, radius: 100);
    mapboxMap.addInteraction(longTapInteractionFeatureCollection,
        interactionID: "long_tap_interaction_buggy");
  }

  Widget _buildDebugPanel() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Text(
        'Try clicking on a model!',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      MapWidget(
        key: ValueKey("mapWidget"),
        cameraOptions: CameraOptions(
            center: Point(coordinates: Position(24.9453, 60.1718)),
            bearing: 49.92,
            zoom: 17.5,
            pitch: 60),
        onStyleLoadedListener: _onStyleLoaded,
        onMapCreated: _onMapCreated,
      ),
      Positioned(
        bottom: 10,
        left: 10,
        right: 10,
        child: _buildDebugPanel(),
      ),
    ]));
  }
}
