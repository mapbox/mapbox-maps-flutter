import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/example.dart';
import 'package:mapbox_maps_example/utils.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class EditPolygonExample extends StatefulWidget implements Example {
  @override
  EditPolygonExampleState createState() => EditPolygonExampleState();

  @override
  Widget get leading => const Icon(Icons.map);

  @override
  String? get subtitle => "Edit a polygon by dragging/dropping its legs";

  @override
  String get title => "Edit polygon";
}

class EditPolygonExampleState extends State<EditPolygonExample> {
  late final MapboxMap mapboxMap;
  late final CircleAnnotationManager circleManager;

  Map<String, Point> points = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        cameraOptions: CameraOptions(
            center: Point(coordinates: Position(22.9556, 54.3800)), zoom: 3.5),
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
      final annotation = await circleManager.create(CircleAnnotationOptions(
        geometry: point,
        circleColor: Colors.indigo.value,
        circleRadius: 8.0,
        isDraggable: true,
      ));
      points[annotation.id] = point;
    }

    circleManager.dragEvents(onChanged: (context) async {
      points[context.annotation.id] = context.annotation.geometry;
      await _addOrUpdateFillLayer();
    });

    await _addOrUpdateFillLayer();
  }

  Future<void> _addOrUpdateFillLayer() async {
    final sourceId = "city-fill-source";

    var coordinates = points.values
        .map((e) => Position(e.coordinates.lng, e.coordinates.lat))
        .toList();
    coordinates.add(coordinates.first); // Close the polygon

    if (await mapboxMap.style.styleSourceExists(sourceId) == false) {
      final geoJsonData = {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "id": "editable-polygon-feature",
            "geometry": {
              "type": "Polygon",
              "coordinates": [coordinates],
            }
          }
        ]
      };
      await mapboxMap.style.addSource(
          GeoJsonSource(id: sourceId, data: jsonEncode(geoJsonData)));

      await mapboxMap.style.addLayer(FillLayer(
        id: "city-fill-layer",
        sourceId: "city-fill-source",
        fillColor: Colors.amberAccent.value,
        fillOpacity: 0.3,
      ));
    } else {
      await mapboxMap.style
          .updateGeoJSONSourceFeatures("city-fill-source", "editable-polygon", [
        Feature(
            id: "editable-polygon-feature",
            geometry: Polygon(coordinates: [coordinates]))
      ]);
    }
  }
}
