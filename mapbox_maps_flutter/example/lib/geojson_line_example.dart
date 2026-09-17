import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart' show Feature, LineString, Point, Position;

class DrawGeoJsonLineExample extends StatefulWidget {
  const DrawGeoJsonLineExample({super.key});

  @override
  State createState() => DrawGeoJsonLineExampleState();
}

class DrawGeoJsonLineExampleState extends State<DrawGeoJsonLineExample> {
  MapboxMap? mapboxMap;
  var isLight = true;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) async {
    var data = await rootBundle.loadString(
      'assets/from_crema_to_council_crest.geojson',
    );

    // `dynamicData` lets the source accept feature updates on web. Android
    // and iOS accept them on all GeoJSON sources and ignore this property.
    await mapboxMap?.addSource(
      GeoJsonSource(id: "line", data: data, dynamicData: true),
    );
    await mapboxMap?.addLayer(
      LineLayer(
        id: "line_layer",
        sourceId: "line",
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineColor: Colors.red.value,
        lineWidth: 6.0,
      ),
    );

    // Wait 5 seconds, then update the GeoJSONSource with the new line
    await Future.delayed(Duration(seconds: 5));

    // The update replaces the feature that has the same id. The id must be a
    // number, because web keeps only numeric feature ids.
    var newFeature = Feature(
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
    );
    await mapboxMap?.updateGeoJSONSourceFeatures("line", "new_line", [
      newFeature,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: MapWidget(
        key: ValueKey("mapWidget"),
        styleUri: MapboxStyles.STANDARD,
        viewport: CameraViewportState(
          center: Point(coordinates: Position(-122.486052, 37.830348)),
          zoom: 14.0,
        ),
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoadedCallback,
      ),
    );
  }
}
