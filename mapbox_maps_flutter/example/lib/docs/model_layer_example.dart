import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ModelLayerExample extends StatefulWidget {
  const ModelLayerExample({super.key});

  @override
  State<ModelLayerExample> createState() => _ModelLayerExampleState();
}

class _ModelLayerExampleState extends State<ModelLayerExample> {
  MapboxMap? _mapboxMap;

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

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
    final mapboxMap = _mapboxMap;
    if (mapboxMap == null) return;

    // 1.) Add the two 3D models to the style
    final buggyModelId = "model-buggy-id";
    // jsDelivr, not raw.githubusercontent.com: that host sends an empty
    // (invalid) Access-Control-Allow-Origin header, so browsers block the
    // fetch on web. jsDelivr mirrors the same pinned commit with a valid one.
    final buggyModelUri =
        "https://cdn.jsdelivr.net/gh/KhronosGroup/glTF-Sample-Models@d7a3cc8e51d7c573771ae77a57f16b0662a905c6/2.0/Buggy/glTF/Buggy.gltf";
    await mapboxMap.addStyleModel(buggyModelId, buggyModelUri);

    final carModelId = "model-car-id";
    const carModelAssetUri = "asset://assets/sportcar.glb";
    // Local bundled models need the Flutter asset URI resolved to a
    // platform-native path before the native SDK can load them.
    final carModelUri =
        await MapboxMapsOptions.getFlutterAssetPath(carModelAssetUri) ??
        carModelAssetUri;
    await mapboxMap.addStyleModel(carModelId, carModelUri);

    // 2.) Add the two geojson sources to provide coordinates for the models
    await mapboxMap.addSource(
      GeoJsonSource(
        id: "buggySourceId",
        data: json.encode(Point(coordinates: buggyModelPosition)),
      ),
    );
    await mapboxMap.addSource(
      GeoJsonSource(
        id: "carSourceId",
        data: json.encode(Point(coordinates: carModelPosition)),
      ),
    );

    // 3.) Add the two model layers to the map, specifying the model id and geojson source id
    await mapboxMap.addLayer(
      ModelLayer(id: "modelLayer-buggy", sourceId: "buggySourceId")
        ..modelId = buggyModelId
        ..modelScale = [0.25, 0.25, 0.25]
        ..modelRotation = [0, 0, 90]
        ..modelType = ModelType.COMMON_3D,
    );

    await mapboxMap.addLayer(
      ModelLayer(id: "modelLayer-car", sourceId: "carSourceId")
        // The id registered with addStyleModel, not the asset URI: gl-js
        // resolves modelId against the style's model registry and renders
        // nothing for an unknown id.
        ..modelId = carModelId
        ..modelScale = [4, 4, 4]
        ..modelRotation = [0, 0, 90]
        ..modelType = ModelType.COMMON_3D,
    );
  }
}
