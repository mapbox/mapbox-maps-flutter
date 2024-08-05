import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'page.dart';

class ModelLayerPage extends ExamplePage {
  ModelLayerPage() : super(const Icon(Icons.view_in_ar), 'Model layer');

  @override
  Widget build(BuildContext context) {
    return ModelLayerWidget();
  }
}

class ModelLayerWidget extends StatefulWidget {
  ModelLayerWidget();

  final _state = _ModelLayerState();
  MapboxMap? getMapboxMap() => _state.mapboxMap;

  @override
  State<StatefulWidget> createState() {
    return _state;
  }
}

class _ModelLayerState extends State<ModelLayerWidget> {
  MapboxMap? mapboxMap;

  var position = Position(24.9458, 60.17180);
  var modelPosition = Position(24.94457012371287, 60.171958417023674);

  @override
  Widget build(BuildContext context) {
    return MapWidget(
        cameraOptions: CameraOptions(
            center: Point(coordinates: position),
            zoom: 18.5,
            bearing: 98.82,
            pitch: 85),
        key: const ValueKey<String>('mapWidget'),
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoaded);
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    addModelLayer();
  }

  addModelLayer() async {
    var value = Point(coordinates: modelPosition);
    if (mapboxMap == null) {
      throw Exception("MapboxMap is not ready yet");
    }

    final buggyModelId = "model-test-id";
    final buggyModelUri =
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/d7a3cc8e51d7c573771ae77a57f16b0662a905c6/2.0/Buggy/glTF/Buggy.gltf";
    await mapboxMap?.style.addStyleModel(buggyModelId, buggyModelUri);

    final carModelId = "model-car-id";
    final carModelUri = "asset://assets/sportcar.glb";
    await mapboxMap?.style.addStyleModel(carModelId, carModelUri);

    await mapboxMap?.style
        .addSource(GeoJsonSource(id: "sourceId", data: json.encode(value)));

    var modelLayer = ModelLayer(id: "modelLayer-buggy", sourceId: "sourceId");
    modelLayer.modelId = buggyModelId;
    modelLayer.modelScale = [0.15, 0.15, 0.15];
    modelLayer.modelRotation = [0, 0, 90];
    modelLayer.modelType = ModelType.COMMON_3D;
    mapboxMap?.style.addLayer(modelLayer);

    var modelLayer1 = ModelLayer(id: "modelLayer-car", sourceId: "sourceId");
    modelLayer1.modelId = carModelId;
    modelLayer1.modelScale = [0.15, 0.15, 0.15];
    modelLayer1.modelRotation = [0, 0, 90];
    modelLayer1.modelType = ModelType.COMMON_3D;
    mapboxMap?.style.addLayer(modelLayer1);
  }
}
