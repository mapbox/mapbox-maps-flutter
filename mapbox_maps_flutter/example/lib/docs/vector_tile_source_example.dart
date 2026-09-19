import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class VectorTileSourceExample extends StatefulWidget {
  const VectorTileSourceExample({super.key});

  @override
  State<VectorTileSourceExample> createState() =>
      _VectorTileSourceExampleState();
}

class _VectorTileSourceExampleState extends State<VectorTileSourceExample> {
  MapboxMap? _mapboxMap;

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    mapboxMap.setStyleImportConfigProperty("basemap", "lightPreset", "day");
    mapboxMap.setStyleImportConfigProperty("basemap", "theme", "monochrome");
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData data) async {
    await _mapboxMap?.addSource(
      VectorSource(
        id: "terrain-data",
        url: "mapbox://mapbox.mapbox-terrain-v2",
      ),
    );
    await _mapboxMap?.addLayer(
      LineLayer(
        id: "terrain-data",
        sourceId: "terrain-data",
        sourceLayer: "contour",
        lineJoin: LineJoin.ROUND,
        lineCap: LineCap.ROUND,
        lineColor: Colors.red.toARGB32(),
        lineWidth: 1.9,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        key: ValueKey("mapWidget"),
        styleUri: MapboxStyles.STANDARD,
        viewport: CameraViewportState(
          center: Point(coordinates: Position(-122.447303, 37.753574)),
          zoom: 13.0,
        ),
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoaded,
      ),
    );
  }
}
