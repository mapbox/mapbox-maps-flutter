import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class InteractiveFeaturesExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Interactive Features';
  @override
  final String? subtitle = 'Click to select buildings, long-click to unselect';

  @override
  State<StatefulWidget> createState() => InteractiveFeaturesState();
}

class InteractiveFeaturesState extends State<InteractiveFeaturesExample> {
  InteractiveFeaturesState();
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.style;
  }

  _onTap(context) async {
    // Define the geometry to query, in this case the point where the user clicked.
    var clicked = await mapboxMap?.pixelForCoordinate(context.point);
    var renderedQueryGeometry =
        RenderedQueryGeometry.fromScreenCoordinate(clicked!);

    // Define the featureset to query. In this case "buildings", which is defined in the
    // Standard Experimental style.
    var featureset =
        FeaturesetDescriptor(featuresetId: "buildings", importId: "basemap");

    // Query the featureset for the geometry
    var queriedFeatures = await mapboxMap?.queryRenderedFeaturesForFeatureset(
        geometry: renderedQueryGeometry, featureset: featureset);
    var featuresetFeature = queriedFeatures?.first;

    if (featuresetFeature != null) {
      // Define the state to set for the feature, in this case highlighting
      // Set that featurestate on that featuresetFeature
      Map<String, Object?> state = {
        "highlight": true,
      };
      mapboxMap?.setFeatureStateForFeaturesetFeature(featuresetFeature, state);
    }
  }

  _onLongTap(context) async {
    // Define the geometry to query, in this case the point where the user clicked.
    var clicked = await mapboxMap?.pixelForCoordinate(context.point);
    var renderedQueryGeometry =
        RenderedQueryGeometry.fromScreenCoordinate(clicked!);

    // Query the featureset for the geometry
    var featureset =
        FeaturesetDescriptor(featuresetId: "buildings", importId: "basemap");
    var queriedFeatures = await mapboxMap?.queryRenderedFeaturesForFeatureset(
        geometry: renderedQueryGeometry, featureset: featureset);
    var featuresetFeatureId = queriedFeatures?.first.id;

    // Remove that feature state
    if (featuresetFeatureId != null) {
      mapboxMap?.removeFeatureStateForFeaturesetFeatureDescriptor(
          featureId: featuresetFeatureId, featureset: featureset);
    }
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

      /// DON'T USE Standard Experimental style in production, it will break over time.
      /// Currently this feature is in preview.
      styleUri: MapboxStyles.STANDARD_EXPERIMENTAL,
      textureView: true,
      onMapCreated: _onMapCreated,
      onTapListener: _onTap,
      onLongTapListener: _onLongTap,
    ));
  }
}
