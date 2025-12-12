import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

/// Example demonstrating custom vector icons with dynamic styling and interaction.
/// This example shows how to:
/// - Dynamically colorize vector icons based on feature properties using the image expression
/// - Interactively change icon size by tapping on icons
///
/// Vector icons are parameterized SVG images that can be styled at runtime. In this example,
/// three flag icons are colored red, yellow, and purple using the 'flagColor' property.
/// Tap any flag to toggle its size between 1x and 2x.
///
/// For this example to work, the SVGs must live inside the map style. The SVG file was uploaded
/// to Mapbox Studio with the name `flag`, making it available for customization at runtime.
/// You can add vector icons to your own style in Mapbox Studio.
class CustomVectorIconsExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.flag);
  @override
  final String title = 'Custom Vector Icons';
  @override
  final String subtitle =
      'Colorize and interact with vector icons using parameterized SVGs';

  @override
  State<StatefulWidget> createState() => _CustomVectorIconsExampleState();
}

class _CustomVectorIconsExampleState extends State<CustomVectorIconsExample> {
  MapboxMap? mapboxMap;
  String? selectedFlagId;

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

    // Add tap interaction for the symbol layer
    var tapInteraction = TapInteraction(FeaturesetDescriptor(layerId: "points"),
        (feature, point) {
      final id = feature.id?.id;
      if (id == null) return;

      setState(() {
        // Toggle selection: if tapping the same feature, deselect; otherwise select new one
        selectedFlagId = (selectedFlagId == id) ? null : id;
      });

      // Update icon size expression based on selection
      mapboxMap.style.setStyleLayerProperty(
        'points',
        'icon-size',
        [
          'case',
          [
            '==',
            ['id'],
            selectedFlagId ?? ''
          ],
          2.0,
          1.0
        ],
      );
    });
    mapboxMap.addInteraction(tapInteraction,
        interactionID: "tap_interaction_flags");
  }

  _onStyleLoaded(StyleLoadedEventData data) async {
    await _addFlagSymbols();
  }

  /// Creates GeoJSON features with flag locations and colors.
  List<Map<String, dynamic>> _createFlagFeatures() {
    return [
      _createFlagFeature('flag-red', 24.68727, 60.185755, 'red'),
      _createFlagFeature('flag-yellow', 24.68827, 60.186255, 'yellow'),
      _createFlagFeature('flag-purple', 24.68927, 60.186055, '#800080'),
    ];
  }

  /// Creates a feature with a flag at the specified location and color.
  Map<String, dynamic> _createFlagFeature(
      String id, double longitude, double latitude, String color) {
    return {
      'type': 'Feature',
      'id': id, // Feature ID used for selection and icon size expression
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
