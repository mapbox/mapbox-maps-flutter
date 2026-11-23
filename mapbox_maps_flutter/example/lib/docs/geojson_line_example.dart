import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class DrawGeoJsonLineExample extends StatefulWidget {
  const DrawGeoJsonLineExample({super.key});

  @override
  State<DrawGeoJsonLineExample> createState() => _DrawGeoJsonLineExampleState();
}

class _DrawGeoJsonLineExampleState extends State<DrawGeoJsonLineExample> {
  MapboxMap? _mapboxMap;

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
    final lineGeoJson = await rootBundle.loadString(
      'assets/from_crema_to_council_crest.geojson',
    );

    // `dynamicData` lets the source accept feature updates on web. Android
    // and iOS accept them on all GeoJSON sources and ignore this property.
    await _mapboxMap?.addSource(
      GeoJsonSource(id: "line", data: lineGeoJson, dynamicData: true),
    );
    await _mapboxMap?.addLayer(
      LineLayer(
        id: "line_layer",
        sourceId: "line",
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineColor: Colors.red.toARGB32(),
        lineWidth: 6.0,
      ),
    );
  }

  /// Replaces the line the source holds, without re-adding the source or the
  /// layer that renders it.
  ///
  /// The update replaces the feature that has the same id. The id must be a
  /// number, because web keeps only numeric feature ids.
  Future<void> _updateLine() async {
    await _mapboxMap?.updateGeoJSONSourceFeatures("line", "new_line", [
      Feature(
        id: 1,
        geometry: LineString(
          coordinates: [
            Position(-122.483696, 37.833818),
            Position(-122.4861, 37.828802),
            Position(-122.493782, 37.833683),
            Position(-122.48959, 37.8366109),
            Position(-122.483696, 37.833818),
          ],
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _updateLine,
        tooltip: 'Update the line',
        child: const Icon(Icons.edit_road),
      ),
      body: MapWidget(
        key: ValueKey("mapWidget"),
        styleUri: MapboxStyles.STANDARD,
        viewport: CameraViewportState(
          center: Point(coordinates: Position(-122.486052, 37.830348)),
          zoom: 14.0,
        ),
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoaded,
      ),
    );
  }
}
