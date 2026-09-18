import 'dart:developer';
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class StandardStyleInteractionsExample extends StatefulWidget {
  const StandardStyleInteractionsExample({super.key});

  @override
  State<StandardStyleInteractionsExample> createState() =>
      _StandardStyleInteractionsState();
}

class _StandardStyleInteractionsState
    extends State<StandardStyleInteractionsExample> {
  /// Space the bottom panel takes, so it can be handed to the camera as
  /// padding: without it, the panel would cover whatever sits underneath it.
  static const _controlsHeight = 178.0;

  /// Extra clearance above the panel: its own outer padding.
  static const _controlsClearance = 16.0;

  MapboxMap? _mapboxMap;

  /// Default style import config properties for Mapbox Standard style.
  String lightPreset = 'day';
  String theme = 'default';
  String buildingHighlightColor = 'hsl(214, 94%, 59%)';

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;

    // The Mapbox logo and attribution default to the bottom edge, so they
    // would otherwise sit behind the debug panel.
    const ornamentMargin = _controlsHeight + _controlsClearance;
    mapboxMap.logo.updateSettings(LogoSettings(marginBottom: ornamentMargin));
    mapboxMap.attribution.updateSettings(
      AttributionSettings(marginBottom: ornamentMargin),
    );

    // Tapping a POI in the Standard POIs featureset hides it. Without
    // stopPropagation the tap also reaches the interactions added below.
    mapboxMap.addInteraction(
      TapInteraction(
        StandardPOIs(),
        (feature, _) {
          mapboxMap.setFeatureStateForFeaturesetFeature(
            feature,
            StandardPOIsState(hide: true),
          );
          log("POI feature name: ${feature.name}");
        },
        radius: 10,
        stopPropagation: false,
      ),
      interactionID: "tap_interaction_poi",
    );

    // Tapping a building in the Standard Buildings featureset highlights it.
    mapboxMap.addInteraction(
      TapInteraction(StandardBuildings(), (feature, _) {
        mapboxMap.setFeatureStateForFeaturesetFeature(
          feature,
          StandardBuildingsState(highlight: true),
        );
        log("Building group: ${feature.group}");
      }),
    );

    // Tapping a place label in the Standard Place Labels featureset selects it.
    mapboxMap.addInteraction(
      TapInteraction(StandardPlaceLabels(), (feature, _) {
        mapboxMap.setFeatureStateForFeaturesetFeature(
          feature,
          StandardPlaceLabelsState(select: true),
        );
        log("Place label: ${feature.name}");
      }),
    );

    // On mobile, when the map is long-tapped print the screen coordinates of
    // the tap and reset the state of all features in the Standard POIs,
    // Buildings, and Place Labels featuresets. Long-tap isn't available on web.
    if (!kIsWeb) {
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

  /// One labelled dropdown row inside the floating panel.
  Widget _field(
    String label,
    String value,
    Map<String, String> options,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Color(0x80FFFFFF),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
        DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          underline: const SizedBox.shrink(),
          dropdownColor: const Color(0xFF1C1F24),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
          items: [
            for (final option in options.entries)
              DropdownMenuItem(value: option.key, child: Text(option.value)),
          ],
        ),
      ],
    );
  }

  Widget _buildDebugPanel() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            // Translucent dark panel matching the Mapbox interactive demos.
            color: const Color(0xCC0E1012),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x1FFFFFFF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _field(
                'Building color',
                buildingHighlightColor,
                const {
                  'hsl(214, 94%, 59%)': 'Blue',
                  'yellow': 'Yellow',
                  'red': 'Red',
                },
                (value) => setState(() {
                  buildingHighlightColor = value;
                  _updateMapStyle();
                }),
              ),
              const SizedBox(height: 10),
              _field(
                'Light',
                lightPreset,
                const {
                  'dawn': 'Dawn',
                  'day': 'Day',
                  'dusk': 'Dusk',
                  'night': 'Night',
                },
                (value) => setState(() {
                  lightPreset = value;
                  _updateMapStyle();
                }),
              ),
              const SizedBox(height: 10),
              _field(
                'Theme',
                theme,
                const {
                  'default': 'Default',
                  'faded': 'Faded',
                  'monochrome': 'Monochrome',
                },
                (value) => setState(() {
                  theme = value;
                  _updateMapStyle();
                }),
              ),
            ],
          ),
        ),
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
              // Keeps the map's visual center clear of the bottom debug panel.
              padding: const EdgeInsets.only(bottom: _controlsHeight),
            ),
            styleUri: MapboxStyles.STANDARD,
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
          ),
          // Anchored bottom-center. Width-capped on web, so the panel reads
          // as a floating control rather than a full-width bar on wide
          // screens; full-width on mobile, where the viewport is narrow
          // enough that the cap would not do anything anyway.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: kIsWeb ? 260 : double.infinity,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(_controlsClearance),
                    child: _buildDebugPanel(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateMapStyle() {
    _mapboxMap?.setStyleImportConfigProperties("basemap", {
      "lightPreset": lightPreset,
      "theme": theme,
      "colorBuildingHighlight": buildingHighlightColor,
    });
  }
}
