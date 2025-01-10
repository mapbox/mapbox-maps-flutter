import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class InteractiveFeaturesExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Interactive Features';
  @override
  final String? subtitle = 'Tap a Buildings to highlight it or a POI to hide it';

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

    // Define a tap interaction targeting the Buildings featureset in the Standard style
    var tapInteraction = TapInteraction(Featureset.standardBuildings());

    // Define a state to highlight the building when it is interacted with
    StandardBuildingState featureState = StandardBuildingState(highlight: true);

    // Add the tap interaction to the map, set the action to occur when a building is tapped (highlight it)
    mapboxMap.addInteraction(tapInteraction, (_, FeaturesetFeature feature) {
      mapboxMap.setFeatureStateForFeaturesetFeature(feature, featureState);
      var buildingFeature = StandardBuildingsFeature(
          feature.geometry, feature.properties, feature.state,
          id: feature.id);
      print("Building feature id: ${buildingFeature.id}");
    });
    
    // On long tap, remove the highlight state
    mapboxMap.addInteraction(LongTapInteraction(Featureset.standardBuildings()), 
    (_, FeaturesetFeature feature) {
      mapboxMap.removeFeatureStateForFeaturesetFeature(feature: feature);
    });

    /// Define interactions for Points of Interest 
    
    // Define a tap interaction targeting the POI featureset in the Standard style, including a click radius
    // Do not stop propagation of the click event to lower layers
    var tapInteractionPOI = TapInteraction(Featureset.standardPoi(),
        radius: 10, stopPropagation: false);

    // Define a state to hide the POI when it is interacted with
    mapboxMap.addInteraction(tapInteractionPOI, (_, FeaturesetFeature feature) {
      mapboxMap.setFeatureStateForFeaturesetFeature(
          feature, StandardPoiState(hide: true));
    });
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
      styleUri: MapboxStyles.STANDARD,
      textureView: true,
      onMapCreated: _onMapCreated,
    ));
  }
}
