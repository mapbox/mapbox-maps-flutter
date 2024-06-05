import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'page.dart';

class ModelLayerPage extends ExamplePage {
  ModelLayerPage() : super(const Icon(Icons.map), 'Model layer');

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

    var modelId = "model-test-id";
    var uri =
        "https://github.com/KhronosGroup/glTF-Sample-Models/raw/d7a3cc8e51d7c573771ae77a57f16b0662a905c6/2.0/Buggy/glTF/Buggy.gltf";
    await mapboxMap?.style.addStyleModel(modelId, uri);

    await mapboxMap?.style
        .addSource(GeoJsonSource(id: "sourceId", data: json.encode(value)));

    var modelLayer = ModelLayer(id: "modelLayer", sourceId: "sourceId");
    modelLayer.modelId = modelId;
    modelLayer.modelScale = [0.15, 0.15, 0.15];
    modelLayer.modelRotation = [0, 0, 90];
    modelLayer.modelType = ModelType.COMMON_3D;
    mapboxMap?.style.addLayer(modelLayer);
  }
}
