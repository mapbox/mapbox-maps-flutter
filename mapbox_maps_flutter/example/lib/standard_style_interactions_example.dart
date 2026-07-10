import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:turf/turf.dart' show Position;

import 'platform.dart';

class StandardStyleInteractionsExample extends StatefulWidget {
  const StandardStyleInteractionsExample({super.key});

  @override
  State<StatefulWidget> createState() => StandardStyleInteractionsState();
}

class StandardStyleInteractionsState
    extends State<StandardStyleInteractionsExample> {
  StandardStyleInteractionsState();
  MapboxMap? mapboxMap;

  /// Default style import config properties for Mapbox Standard style.
  String lightPreset = 'day';
  String theme = 'default';
  String buildingHighlightColor = 'hsl(214, 94%, 59%)';

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;

    /// When a POI feature in the Standard POI featureset is tapped hide the POI
    var tapInteractionPOI = TapInteraction(
      StandardPOIs(),
      (feature, _) {
        mapboxMap.setFeatureStateForFeaturesetFeature(
          feature,
          StandardPOIsState(hide: true),
        );
        log("POI feature name: ${feature.name}");

        /// Not stopping propagation means that the tap event will be propagated to other interactions.
      },
      radius: 10,
      stopPropagation: false,
    );
    mapboxMap.addInteraction(
      tapInteractionPOI,
      interactionID: "tap_interaction_poi",
    );

    /// When a building in the Standard Buildings featureset is tapped, set that building as highlighted to color it.
    var tapInteractionBuildings = TapInteraction(StandardBuildings(), (
      feature,
      _,
    ) {
      mapboxMap.setFeatureStateForFeaturesetFeature(
        feature,
        StandardBuildingsState(highlight: true),
      );
      log("Building group: ${feature.group}");
    });
    mapboxMap.addInteraction(tapInteractionBuildings);

    /// When a place label in the Standard Place Labels featureset is tapped, set that place label as selected.
    var tapInteractionPlaceLabel = TapInteraction(StandardPlaceLabels(), (
      feature,
      _,
    ) {
      mapboxMap.setFeatureStateForFeaturesetFeature(
        feature,
        StandardPlaceLabelsState(select: true),
      );
      log("Place label: ${feature.name}");
    });
    mapboxMap.addInteraction(tapInteractionPlaceLabel);

    // On mobile, when the map is long-tapped print the screen coordinates of
    // the tap and reset the state of all features in the Standard POIs,
    // Buildings, and Place Labels featuresets. Long-tap isn't available on web.
    if (isMobile) {
      mapboxMap.addInteraction(
        LongTapInteraction.onMap((context) {
          log(
            "Long tap at: ${context.touchPosition.x}, ${context.touchPosition.y}",
          );
          mapboxMap.resetFeatureStatesForFeatureset(StandardPOIs());
          mapboxMap.resetFeatureStatesForFeatureset(StandardBuildings());
          mapboxMap.resetFeatureStatesForFeatureset(StandardPlaceLabels());
        }),
      );
    }
  }

  // The Standard style's "basemap" import is only available once the style has
  // loaded, then we can update the map style import's config properties.
  void _onStyleLoaded(StyleLoadedEventData data) {
    _updateMapStyle();
  }

  Widget _buildDebugPanel() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Building Color'),
          DropdownButton<String>(
            value: buildingHighlightColor,
            items: [
              DropdownMenuItem(
                value: 'hsl(214, 94%, 59%)',
                child: Text('Blue'),
              ),
              DropdownMenuItem(value: 'yellow', child: Text('Yellow')),
              DropdownMenuItem(value: 'red', child: Text('Red')),
            ],
            onChanged: (value) {
              setState(() {
                buildingHighlightColor = value!;
                _updateMapStyle();
              });
            },
          ),
          SizedBox(height: 10),
          Text('Light'),
          DropdownButton<String>(
            value: lightPreset,
            items: [
              DropdownMenuItem(value: 'dawn', child: Text('Dawn')),
              DropdownMenuItem(value: 'day', child: Text('Day')),
              DropdownMenuItem(value: 'dusk', child: Text('Dusk')),
              DropdownMenuItem(value: 'night', child: Text('Night')),
            ],
            onChanged: (value) {
              setState(() {
                lightPreset = value!;
                _updateMapStyle();
              });
            },
          ),
          SizedBox(height: 10),
          Text('Theme'),
          DropdownButton<String>(
            value: theme,
            items: [
              DropdownMenuItem(value: 'default', child: Text('Default')),
              DropdownMenuItem(value: 'faded', child: Text('Faded')),
              DropdownMenuItem(value: 'monochrome', child: Text('Monochrome')),
            ],
            onChanged: (value) {
              setState(() {
                theme = value!;
                _updateMapStyle();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            key: ValueKey("mapWidget"),
            viewport: CameraViewportState(
              center: Point(coordinates: Position(24.9453, 60.1718)),
              bearing: 49.92,
              zoom: 16.35,
              pitch: 40,
            ),
            styleUri: MapboxStyles.STANDARD,
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: _buildDebugPanel(),
          ),
        ],
      ),
    );
  }

  void _updateMapStyle() {
    // Update the map style's config properties based on the selected options
    var configs = {
      "lightPreset": lightPreset,
      "theme": theme,
      "colorBuildingHighlight": buildingHighlightColor,
    };
    mapboxMap?.style.setStyleImportConfigProperties("basemap", configs);
  }
}
