// This file is generated.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> addDelay(int ms) async {
    await Future<void>.delayed(Duration(milliseconds: ms));
  }

  testWidgets('create PolygonAnnotation', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager =
        await mapboxMap.annotations.createPolygonAnnotationManager();
    var geometry = Polygon(coordinates: [
      [
        Position(-3.363937, -10.733102),
        Position(1.754703, -19.716317),
        Position(-15.747196, -21.085074),
        Position(-3.363937, -10.733102)
      ]
    ]);

    var polygonAnnotationOptions = PolygonAnnotationOptions(
      geometry: geometry.toJson(),
      fillSortKey: 1.0,
      fillColor: Colors.red.value,
      fillOpacity: 1.0,
      fillOutlineColor: Colors.red.value,
      fillPattern: "abc",
    );
    final annotation = await manager.create(polygonAnnotationOptions);
    var polygon = Polygon.fromJson((annotation.geometry)!.cast());
    expect(1, polygon.coordinates.length);
    var points = polygon.coordinates.first;
    expect(4, points.length);
    expect(-3.363937, points.first.lng);
    expect(-10.733102, points.first.lat);
    expect(-3.363937, points.last.lng);
    expect(-10.733102, points.last.lat);
    expect(1.0, annotation.fillSortKey);
    expect(Colors.red.value, annotation.fillColor);
    expect(1.0, annotation.fillOpacity);
    expect(Colors.red.value, annotation.fillOutlineColor);
    expect("abc", annotation.fillPattern);
  });

  testWidgets('update and delete PolygonAnnotation',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager =
        await mapboxMap.annotations.createPolygonAnnotationManager();
    var geometry = Polygon(coordinates: [
      [
        Position(-3.363937, -10.733102),
        Position(1.754703, -19.716317),
        Position(-15.747196, -21.085074),
        Position(-3.363937, -10.733102)
      ]
    ]);

    var polygonAnnotationOptions = PolygonAnnotationOptions(
      geometry: geometry.toJson(),
    );
    final annotation = await manager.create(polygonAnnotationOptions);
    var polygon = Polygon.fromJson((annotation.geometry)!.cast());
    var newPolygon = Polygon(
        coordinates: polygon.coordinates
            .map((e) =>
                e.map((e) => Position(e.lng + 1.0, e.lat + 1.0)).toList())
            .toList());
    annotation.geometry = newPolygon.toJson();
    await manager.update(annotation);
    await manager.delete(annotation);

    for (var i = 0; i < 10; i++) {
      await manager.create(polygonAnnotationOptions);
    }

    await manager.deleteAll();
    await addDelay(1000);
  });
}
// End of generated file.
