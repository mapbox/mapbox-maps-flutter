import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

/// Example demonstrating custom colorized vector icons using parameterized SVG icons.
/// This example shows how to dynamically color vector icons based on feature properties
/// using the image expression with color parameters.
///
/// For this example to work, the SVGs must live inside the map style, like in the custom style
/// used here. The SVG file was uploaded to Mapbox Studio with the name `flag`,
/// making it available for customization at runtime.
/// You can add vector icons to your own style in Mapbox Studio.
class CustomColorizedVectorIconsExample extends StatefulWidget
    implements Example {
  @override
  final Widget leading = const Icon(Icons.flag);
  @override
  final String title = 'Custom Colorized Vector Icons';
  @override
  final String subtitle =
      'Dynamically color vector icons using parameterized SVGs';

  @override
  State<StatefulWidget> createState() =>
      _CustomColorizedVectorIconsExampleState();
}

class _CustomColorizedVectorIconsExampleState
    extends State<CustomColorizedVectorIconsExample> {
  MapboxMap? mapboxMap;

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      cameraOptions: CameraOptions(
        center: Point(coordinates: Position(24.6881, 60.185755)),
        zoom: 16.0,
      ),
      styleUri: 'mapbox://styles/mapbox-map-design/cm4r19bcm00ao01qvhp3jc2gi',
      key: ValueKey<String>('mapWidget'),
      onMapCreated: _onMapCreated,
      onStyleLoadedListener: _onStyleLoaded,
    );
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    await _addFlagSymbols();
  }

  /// Creates GeoJSON features with flag locations and colors.
  List<Map<String, dynamic>> _createFlagFeatures() {
    return [
      _createFlagFeature(24.68727, 60.185755, 'red'),
      _createFlagFeature(24.68827, 60.186255, 'yellow'),
      _createFlagFeature(24.68927, 60.186055, '#800080'),
    ];
  }

  /// Creates a feature with a flag at the specified location and color.
  Map<String, dynamic> _createFlagFeature(
      double longitude, double latitude, String color) {
    return {
      'type': 'Feature',
      'geometry': {
        'type': 'Point',
        'coordinates': [longitude, latitude],
      },
      'properties': {
        'flagColor': color,
      },
    };
  }

  Future<void> _addFlagSymbols() async {
    if (mapboxMap == null) {
      throw Exception("MapboxMap is not ready yet");
    }

    // Create GeoJSON FeatureCollection
    final geojson = {
      'type': 'FeatureCollection',
      'features': _createFlagFeatures(),
    };

    // Add GeoJSON source with flag locations
    await mapboxMap?.style.addSource(
      GeoJsonSource(
        id: 'points',
        data: json.encode(geojson),
      ),
    );

    // Create symbol layer with parameterized icon
    // The expression uses the 'image' operator with a params object
    // that maps the 'flag_color' parameter to the 'flagColor' property
    final layer = SymbolLayer(
      id: 'points',
      sourceId: 'points',
      iconImageExpression: [
        'image',
        'flag',
        {
          'params': {
            'flag_color': ['get', 'flagColor']
          }
        }
      ],
    );

    await mapboxMap?.style.addLayer(layer);
  }
}
