import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';
import '_facade_shim.dart';
import 'package:turf/turf.dart' show Position;
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

  final centerPosition = Position(24.9453, 60.1718);
  final buggyModelPosition = Position(24.9453, 60.1716);
  final carModelPosition = Position(24.9453, 60.1720);

  _onStyleLoaded(StyleLoadedEventData data) async {
    addModelLayer();
  }

  addModelLayer() async {
    if (mapboxMap == null) {
      throw Exception("MapboxMap is not ready yet");
    }

    // 1.) Add the two 3D models to the style
    final buggyModelId = "buggy-model-id";
    final buggyModelUri =
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/d7a3cc8e51d7c573771ae77a57f16b0662a905c6/2.0/Buggy/glTF/Buggy.gltf";
    await mapboxMap?.style.addStyleModel(buggyModelId, buggyModelUri);

    final carModelId = "car-model-id";
    final carModelUri = "asset://assets/sportcar.glb";
    await mapboxMap?.style.addStyleModel(carModelId, carModelUri);

    // 2.) Create features with an ID and a Point geometry to represent the location of the models
    var buggyFeature = Feature(
      id: 1, //Feature IDs should be Integers for the Model to be recognised by the Mapbox Interactions API
      geometry: Point(coordinates: buggyModelPosition),
      properties: {"name": "BUGGY", "type": "gltf"},
    );
    var carFeature = Feature(
      id: 2, //Feature IDs should be Integers for the Model to be recognised by the Mapbox Interactions API
      geometry: Point(coordinates: carModelPosition),
      properties: {"name": "CAR", "type": "glb"},
    );

    await mapboxMap?.style.addSource(
      GeoJsonSource(id: "buggySource", data: json.encode(buggyFeature)),
    );
    await mapboxMap?.style.addSource(
      GeoJsonSource(id: "carSource", data: json.encode(carFeature)),
    );

    // 3.) Add the two model layers to the map, specifying the model id and geojson source id
    var buggyModelLayer = ModelLayer(
      id: "modelLayer-buggy",
      sourceId: "buggySource",
    );
    buggyModelLayer.modelId = buggyModelId;
    buggyModelLayer.modelScale = [0.15, 0.15, 0.15];
    buggyModelLayer.modelRotation = [0, 0, 90];
    buggyModelLayer.modelType = ModelType.COMMON_3D;
    mapboxMap?.style.addLayer(buggyModelLayer);

    var carModelLayer = ModelLayer(id: "modelLayer-car", sourceId: "carSource");
    carModelLayer.modelId =
        "asset://assets/sportcar.glb"; // Local assets need to be referenced directly
    carModelLayer.modelScale = [4, 4, 4];
    carModelLayer.modelRotation = [0, 0, 90];
    carModelLayer.modelType = ModelType.COMMON_3D;
    mapboxMap?.style.addLayer(carModelLayer);
  }

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.style;

    // Tap Interaction for Buggy Layer
    var tapInteractionBuggy =
        TypedInteraction<TypedFeaturesetFeature<FeaturesetDescriptor>>(
          featuresetDescriptor: FeaturesetDescriptor(
            layerId: "modelLayer-buggy",
          ),
          interactionType: InteractionType.tap,
          featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
          action: (feature, point) {
            if (feature == null) return;
            _showInteractionDialog("Single Tap Interaction Detected", feature);
          },
          radius: 100,
        );
    mapboxMap.addInteraction(
      tapInteractionBuggy,
      interactionID: "tap_interaction_buggy",
    );

    // Tap Interaction for Car Layer
    var tapInteractionCar =
        TypedInteraction<TypedFeaturesetFeature<FeaturesetDescriptor>>(
          featuresetDescriptor: FeaturesetDescriptor(layerId: "modelLayer-car"),
          interactionType: InteractionType.tap,
          featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
          action: (feature, point) {
            if (feature == null) return;
            _showInteractionDialog("Single Tap Interaction Detected", feature);
          },
          radius: 100,
        );
    mapboxMap.addInteraction(
      tapInteractionCar,
      interactionID: "tap_interaction_car",
    );

    // LongTap Interaction for Car Layer
    var longTapInteractionCar =
        TypedInteraction<TypedFeaturesetFeature<FeaturesetDescriptor>>(
          featuresetDescriptor: FeaturesetDescriptor(layerId: "modelLayer-car"),
          interactionType: InteractionType.longTap,
          featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
          action: (feature, point) {
            if (feature == null) return;
            _showInteractionDialog("Long Tap Interaction Detected", feature);
          },
          radius: 100,
        );
    mapboxMap.addInteraction(
      longTapInteractionCar,
      interactionID: "long_tap_interaction_car",
    );

    // LongTap Interaction for Buggy Layer
    var longTapInteractionBuggy =
        TypedInteraction<TypedFeaturesetFeature<FeaturesetDescriptor>>(
          featuresetDescriptor: FeaturesetDescriptor(
            layerId: "modelLayer-buggy",
          ),
          interactionType: InteractionType.longTap,
          featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
          action: (feature, point) {
            if (feature == null) return;
            _showInteractionDialog("Long Tap Interaction Detected", feature);
          },
          radius: 100,
        );
    mapboxMap.addInteraction(
      longTapInteractionBuggy,
      interactionID: "long_tap_interaction_buggy",
    );
  }

  void _showInteractionDialog(
    String title,
    TypedFeaturesetFeature<FeaturesetDescriptor> feature,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(
              "You clicked on the ${feature.properties['name']} model implemented using the ${feature.properties['type']} type",
            ),
          ),
        );
      },
    );
  }

  Widget _buildDebugPanel() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: Text(
        'Tap or Long Tap on a model!',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: ValueKey("mapWidget"),
            viewport: CameraViewportState(
              center: Point(coordinates: centerPosition),
              bearing: 49.92,
              zoom: 17.5,
              pitch: 60,
            ),
            onStyleLoadedListener: _onStyleLoaded,
            onMapCreated: _onMapCreated,
          ),
          Positioned(
            bottom: 100,
            left: 10,
            right: 10,
            child: _buildDebugPanel(),
          ),
        ],
      ),
    );
  }
}
