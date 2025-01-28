import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class InteractiveFeaturesExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.touch_app);
  @override
  final String title = 'Interactive Features';
  @override
  final String? subtitle = 'Tap a building to highlight it or a POI to hide it';

  const InteractiveFeaturesExample({super.key});

  @override
  State<StatefulWidget> createState() => InteractiveFeaturesState();
}

class InteractiveFeaturesState extends State<InteractiveFeaturesExample> {
  InteractiveFeaturesState();
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.style;

    /// Define interactions for 3D Buildings

    // Define a state to highlight the building when it is interacted with
    StandardBuildingState featureState = StandardBuildingState(highlight: true);

    // Define a tap interaction targeting the Buildings featureset in the Standard style
    // Set the action to occur when a building is tapped (highlight it)
    var tapInteraction = TapInteraction(StandardBuildings(), (_, feature) {
      mapboxMap.setFeatureStateForFeaturesetFeature(feature, featureState);
      log("Building group: ${feature.group}");
    });

    // Add the tap interaction to the map
    mapboxMap.addInteraction(tapInteraction);

    // On long tap, remove the highlight state
    mapboxMap
        .addInteraction(LongTapInteraction(StandardBuildings(), (_, feature) {
      mapboxMap
          .removeFeatureStateForFeaturesetFeature(feature: feature)
          .then((value) => log("Feature state removed for: ${feature.id?.id}."))
          .catchError((error) => log(
              "Error removing feature state for ${feature.id?.id}, error: $error"));
    }));

    /// Define interactions for Points of Interest

    // Define a tap interaction targeting the POI featureset in the Standard style, including a click radius
    // Do not stop propagation of the click event to lower layers
    var tapInteractionPOI = TapInteraction(StandardPOIs(), (_, feature) {
      mapboxMap.setFeatureStateForFeaturesetFeature(
          feature, StandardPOIsState(hide: true));
      log("POI feature name: ${feature.name}");
    }, radius: 10, stopPropagation: false);

    // Define a state to hide the POI when it is interacted with
    mapboxMap.addInteraction(tapInteractionPOI);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MapWidget(
      key: ValueKey("mapWidget"),
      cameraOptions: CameraOptions(
          center: Point(coordinates: Position(24.9453, 60.1718)),
          bearing: 49.92,
          zoom: 16.35,
          pitch: 40),
      styleUri: MapboxStyles.STANDARD_EXPERIMENTAL,
      textureView: true,
      onMapCreated: _onMapCreated,
    ));
  }
}
