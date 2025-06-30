import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class StandardStyleImportExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.touch_app);
  @override
  final String title = 'Standard Style Import';
  @override
  final String? subtitle = 'Configure the Standard Style and add interactions';

  const StandardStyleImportExample({super.key});

  @override
  State<StatefulWidget> createState() => StandardStyleImportState();
}

class StandardStyleImportState extends State<StandardStyleImportExample> {
  StandardStyleImportState();
  MapboxMap? mapboxMap;

  /// Style import config properties
  String lightPreset = 'day';
  bool labelsSetting = true;
  bool landmarkIconsSetting = false;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.style;

    // Load a style fragment from a JSON file and add it to the map
    var styleJson =
        await rootBundle.loadString("assets/fragment_realestate_NY.json");
    mapboxMap.style.addStyleImportFromJSON("real-estate-fragment", styleJson);

    // When the map is ready, add a tap interaction to show a snackbar with the name of the place that was tapped
    mapboxMap
        .addInteraction(TapInteraction(StandardPlaceLabels(), (feature, _) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tapped place: ${feature.name}")),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'landmarkIcons',
              onPressed: _changeLandmarkIconsSetting,
              child: Icon(Icons.camera_alt_outlined),
            ),
            SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'light',
              onPressed: _changeLightSetting,
              child: Icon(Icons.wb_sunny),
            ),
            SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'labels',
              onPressed: _changeLabelsSetting,
              child: Icon(Icons.label),
            ),
          ],
        ),
        body: Stack(children: [
          MapWidget(
            key: ValueKey("mapWidget"),
            cameraOptions: CameraOptions(
                center: Point(coordinates: Position(-73.99, 40.72)),
                zoom: 11,
                pitch: 45),
            styleUri: MapboxStyles.STANDARD,
            textureView: true,
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
          )
        ]));
  }

  _onStyleLoaded(StyleLoadedEventData styleLoadedEventData) {
    // When the style has finished loading add a line layer representing the border between New York and New Jersey
    _addLineLayer();
  }

  void _addLineLayer() {
    final lineLayer = LineLayer(
      id: 'line-layer',
      sourceId: 'line-layer',
      lineColor: Colors.orange.value,
      lineWidth: 8,
    );

    final line = LineString(coordinates: [
      Position(-73.91912400100642, 40.913503418907936),
      Position(-73.9615887363045, 40.82943110786286),
      Position(-74.01409059085539, 40.75461056309348),
      Position(-74.02798814058939, 40.69522028220487),
      Position(-74.05655532615407, 40.65188756398558),
      Position(-74.13916853846217, 40.64339339389301),
    ]);

    final lineSource = GeoJsonSource(
      id: 'line-layer',
      data: json.encode(line),
    );

    mapboxMap?.style.addSource(lineSource);
    mapboxMap?.style.addLayer(lineLayer);
  }

  void _changeLightSetting() {
    final presets = ['dawn', 'day', 'dusk', 'night'];
    final currentIndex = presets.indexOf(lightPreset);
    setState(() {
      lightPreset = presets[(currentIndex + 1) % presets.length];
      _updateMapStyle();
    });
  }

  // Toggle the visibility of the labels
  void _changeLabelsSetting() {
    setState(() {
      labelsSetting = !labelsSetting;
      _updateMapStyle();
    });
  }

  // Toggle the visibility of the landmark icons
  void _changeLandmarkIconsSetting() {
    setState(() {
      landmarkIconsSetting = !landmarkIconsSetting;
      _updateMapStyle();
    });
  }

  void _updateMapStyle() {
    // Update the map style's config properties based on the selected options
    var configs = {
      "lightPreset": lightPreset,
      "showPointOfInterestLabels": labelsSetting,
      "showTransitLabels": labelsSetting,
      "showPlaceLabels": labelsSetting,
      "showLandmarkIcons": landmarkIconsSetting,
    };
    mapboxMap?.style.setStyleImportConfigProperties("basemap", configs);
  }
}
