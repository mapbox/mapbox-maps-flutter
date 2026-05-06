import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart' show Feature, Point, Polygon, Position;

import 'utils.dart';

class EditPolygonExample extends StatefulWidget {
  const EditPolygonExample({super.key});

  @override
  EditPolygonExampleState createState() => EditPolygonExampleState();
}

class EditPolygonExampleState extends State<EditPolygonExample> {
  late final MapboxMap mapboxMap;
  late final CircleAnnotationManager circleManager;

  static const _sourceId = "editable-polygon-source";
  static const _featureId = "editable-polygon-feature";

  Map<String, Point> points = {};
  List<Position> get coordinates =>
      points.values
          .map((e) => Position(e.coordinates.lng, e.coordinates.lat))
          .toList() +
      [
        Position(
          points.values.first.coordinates.lng,
          points.values.first.coordinates.lat,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        viewport: CameraViewportState(
          center: Point(coordinates: Position(22.9556, 54.3800)),
          zoom: 3.5,
        ),
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: (data) async {
          _onStyleLoaded();
        },
      ),
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  Future<void> _onStyleLoaded() async {
    circleManager = await mapboxMap.annotations.createCircleAnnotationManager();

    final cities = [City.helsinki, City.berlin, City.kyiv];
    for (var point in cities) {
      final annotation = await circleManager.create(
        CircleAnnotationOptions(
          geometry: point,
          circleColor: Colors.indigo.value,
          circleRadius: 8.0,
          isDraggable: true,
        ),
      );
      points[annotation.id] = point;
    }

    circleManager.dragEvents(
      onChanged: (annotation) async {
        points[annotation.id] = annotation.geometry;
        // Update source with new feature.
        await mapboxMap.style.updateGeoJSONSourceFeatures(
          _sourceId,
          "editable-polygon",
          [
            Feature(
              id: _featureId,
              geometry: Polygon(coordinates: [coordinates]),
            ),
          ],
        );
      },
    );

    final geoJsonData = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": _featureId,
          "geometry": {
            "type": "Polygon",
            "coordinates": [coordinates],
          },
        },
      ],
    };
    await mapboxMap.style.addSource(
      GeoJsonSource(id: _sourceId, data: jsonEncode(geoJsonData)),
    );

    await mapboxMap.style.addLayer(
      FillLayer(
        id: "city-fill-layer",
        sourceId: _sourceId,
        fillColor: Colors.pink.value,
        fillOpacity: 0.3,
      ),
    );
  }
}
