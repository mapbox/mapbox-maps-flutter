import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart' show Point, Position;

class ModelLayerExample extends StatefulWidget {
  const ModelLayerExample({super.key});

  @override
  State<StatefulWidget> createState() => _ModelLayerExampleState();
}

class _ModelLayerExampleState extends State<ModelLayerExample> {
  MapboxMap? mapboxMap;

  final centerPosition = Position(24.94329401009505, 60.170820928168155);
  final buggyModelPosition = Position(24.94457012371287, 60.171958417023674);
  final carModelPosition = Position(24.942935425371218, 60.170573924952095);

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      viewport: CameraViewportState(
        center: Point(coordinates: centerPosition),
        zoom: 17,
        bearing: 15,
        pitch: 55,
      ),
      key: const ValueKey<String>('mapWidget'),
      onMapCreated: _onMapCreated,
      onStyleLoadedListener: _onStyleLoaded,
    );
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    addModelLayer();
  }

  addModelLayer() async {
    if (mapboxMap == null) {
      throw Exception("MapboxMap is not ready yet");
    }

    // 1.) Add the two 3D models to the style
    final buggyModelId = "model-buggy-id";
    final buggyModelUri =
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/d7a3cc8e51d7c573771ae77a57f16b0662a905c6/2.0/Buggy/glTF/Buggy.gltf";
    await mapboxMap?.style.addStyleModel(buggyModelId, buggyModelUri);

    final carModelId = "model-car-id";
    final carModelUri = "asset://assets/sportcar.glb";
    await mapboxMap?.style.addStyleModel(carModelId, carModelUri);

    // 2.) Add the two geojson sources to provide coordinates for the models
    var buggyModelLocation = Point(coordinates: buggyModelPosition);
    var carModelLocation = Point(coordinates: carModelPosition);
    await mapboxMap?.style.addSource(
      GeoJsonSource(id: "buggySourceId", data: json.encode(buggyModelLocation)),
    );
    await mapboxMap?.style.addSource(
      GeoJsonSource(id: "carSourceId", data: json.encode(carModelLocation)),
    );

    // 3.) Add the two model layers to the map, specifying the model id and geojson source id
    var buggyModelLayer = ModelLayer(
      id: "modelLayer-buggy",
      sourceId: "buggySourceId",
    );
    buggyModelLayer.modelId = buggyModelId;
    buggyModelLayer.modelScale = [0.25, 0.25, 0.25];
    buggyModelLayer.modelRotation = [0, 0, 90];
    buggyModelLayer.modelType = ModelType.COMMON_3D;
    mapboxMap?.style.addLayer(buggyModelLayer);

    var carModelLayer = ModelLayer(id: "model-car-id", sourceId: "carSourceId");
    carModelLayer.modelId =
        "asset://assets/sportcar.glb"; // Local assets need to be referenced directly
    carModelLayer.modelScale = [4, 4, 4];
    carModelLayer.modelRotation = [0, 0, 90];
    carModelLayer.modelType = ModelType.COMMON_3D;
    mapboxMap?.style.addLayer(carModelLayer);
  }
}
