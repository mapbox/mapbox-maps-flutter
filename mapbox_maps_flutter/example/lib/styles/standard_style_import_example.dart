import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// Configures the Standard style's import config properties and adds a style
/// fragment on top of it.
///
/// The controls drive `setStyleImportConfigProperties` on the `basemap`
/// import, and the HUD shows the last feature tapped through either the
/// Standard style's built-in `place-labels` featureset or the style
/// fragment's own `hotels-price` featureset.
class StandardStyleImportExample extends StatefulWidget {
  const StandardStyleImportExample({super.key});

  @override
  State<StandardStyleImportExample> createState() =>
      _StandardStyleImportExampleState();
}

class _StandardStyleImportExampleState
    extends State<StandardStyleImportExample> {
  MapboxMap? _mapboxMap;

  String lightPreset = 'day';
  bool labelsSetting = true;
  bool landmarkIconsSetting = false;
  bool fragmentLoaded = false;
  String? tappedPlace;
  bool _styleSetupDone = false;

  void _onMapCreated(MapboxMap mapboxMap) {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
    final map = _mapboxMap;
    if (map == null) return;

    // A style load can happen more than once per map instance, and this
    // setup adds an import, a source, and a layer that must not be added
    // twice.
    if (_styleSetupDone) return;
    _styleSetupDone = true;

    // A style fragment layered on top of the basemap, defining its own
    // source and layer independent of the Standard style's own content.
    final styleJson = await rootBundle.loadString(
      'assets/fragment_realestate_NY.json',
    );
    await map.addStyleImportFromJSON('real-estate-fragment', styleJson);
    if (mounted) setState(() => fragmentLoaded = true);

    await _addLineLayer(map);

    // The `place-labels` featureset comes from the basemap import, so the
    // interaction can only be registered once the style has finished
    // loading and the import is in place.
    map.addInteraction(
      TypedInteraction<TypedFeaturesetFeature<FeaturesetDescriptor>>(
        featuresetDescriptor: FeaturesetDescriptor(
          featuresetId: 'place-labels',
          importId: 'basemap',
        ),
        interactionType: InteractionType.tap,
        featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
        action: (feature, _) {
          if (feature == null) return;
          if (mounted) {
            setState(() => tappedPlace = feature.properties['name'] as String?);
          }
        },
      ),
    );

    // The real-estate fragment defines its own `hotels-price` featureset
    // for the price bubbles, scoped to the fragment's own import.
    map.addInteraction(
      TypedInteraction<TypedFeaturesetFeature<FeaturesetDescriptor>>(
        featuresetDescriptor: FeaturesetDescriptor(
          featuresetId: 'hotels-price',
          importId: 'real-estate-fragment',
        ),
        interactionType: InteractionType.tap,
        featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
        action: (feature, _) {
          if (feature == null) return;
          if (mounted) {
            setState(() => tappedPlace = '\$${feature.properties['price']}');
          }
        },
      ),
    );
  }

  Future<void> _addLineLayer(MapboxMap map) async {
    final line = LineString(
      coordinates: [
        Position(-73.91912400100642, 40.913503418907936),
        Position(-73.9615887363045, 40.82943110786286),
        Position(-74.01409059085539, 40.75461056309348),
        Position(-74.02798814058939, 40.69522028220487),
        Position(-74.05655532615407, 40.65188756398558),
        Position(-74.13916853846217, 40.64339339389301),
      ],
    );
    await map.addSource(
      GeoJsonSource(id: 'ny-nj-border', data: json.encode(line)),
    );
    await map.addLayer(
      LineLayer(
        id: 'ny-nj-border',
        sourceId: 'ny-nj-border',
        lineColor: Colors.orange.toARGB32(),
        lineWidth: 8,
      ),
    );
  }

  void _updateImportConfig() {
    _mapboxMap?.setStyleImportConfigProperties('basemap', {
      'lightPreset': lightPreset,
      'showPointOfInterestLabels': labelsSetting,
      'showTransitLabels': labelsSetting,
      'showPlaceLabels': labelsSetting,
      'showLandmarkIcons': landmarkIconsSetting,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MapScaffold(
      controlsTitle: 'Standard style import',
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('mapWidget'),
            viewport: CameraViewportState(
              center: Point(coordinates: Position(-73.99, 40.72)),
              zoom: 11,
              pitch: 45,
            ),
            styleUri: MapboxStyles.STANDARD,
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
          ),
          MapHud(
            title: 'Basemap config',
            rows: [
              MapHudRow('lightPreset', lightPreset, emphasized: true),
              MapHudRow('fragment loaded', fragmentLoaded ? 'yes' : 'no'),
              MapHudRow('last tapped', tappedPlace ?? '—'),
            ],
          ),
        ],
      ),
      controlsBuilder: () => [
        ControlRow(
          label: 'Lighting',
          child: ControlChoices<String>(
            options: const {
              'dawn': 'Dawn',
              'day': 'Day',
              'dusk': 'Dusk',
              'night': 'Night',
            },
            value: lightPreset,
            onChanged: (value) {
              setState(() => lightPreset = value);
              _updateImportConfig();
            },
          ),
        ),
        ControlSwitch(
          label: 'Show labels',
          value: labelsSetting,
          onChanged: (value) {
            setState(() => labelsSetting = value);
            _updateImportConfig();
          },
        ),
        ControlSwitch(
          label: 'Show landmark icons',
          value: landmarkIconsSetting,
          onChanged: (value) {
            setState(() => landmarkIconsSetting = value);
            _updateImportConfig();
          },
        ),
        const SizedBox(height: 4),
        const Text(
          'Tap a town or neighborhood label, or a price bubble, to see it '
          'in the HUD. A style fragment adds the price bubbles, subway '
          'lines, and the orange NY/NJ border on top of the basemap.',
          style: TextStyle(
            fontSize: 11,
            height: 1.35,
            color: MapboxGlass.labelFaint,
          ),
        ),
      ],
    );
  }
}
