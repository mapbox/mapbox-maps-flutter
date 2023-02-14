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

  testWidgets('create PolylineAnnotation', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager =
        await mapboxMap.annotations.createPolylineAnnotationManager();
    var geometry =
        LineString(coordinates: [Position(1.0, 2.0), Position(10.0, 20.0)]);

    var polylineAnnotationOptions = PolylineAnnotationOptions(
      geometry: geometry.toJson(),
      lineJoin: LineJoin.BEVEL,
      lineSortKey: 1.0,
      lineBlur: 1.0,
      lineColor: Colors.red.value,
      lineGapWidth: 1.0,
      lineOffset: 1.0,
      lineOpacity: 1.0,
      linePattern: "abc",
      lineWidth: 1.0,
    );
    final annotation = await manager.create(polylineAnnotationOptions);
    var lineString = LineString.fromJson((annotation.geometry)!.cast());
    var points = lineString.coordinates;
    expect(2, points.length);
    expect(1.0, points.first.lng);
    expect(2.0, points.first.lat);
    expect(10.0, points.last.lng);
    expect(20.0, points.last.lat);
    expect(LineJoin.BEVEL, annotation.lineJoin);
    expect(1.0, annotation.lineSortKey);
    expect(1.0, annotation.lineBlur);
    expect(Colors.red.value, annotation.lineColor);
    expect(1.0, annotation.lineGapWidth);
    expect(1.0, annotation.lineOffset);
    expect(1.0, annotation.lineOpacity);
    expect("abc", annotation.linePattern);
    expect(1.0, annotation.lineWidth);
  });

  testWidgets('update and delete PolylineAnnotation',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager =
        await mapboxMap.annotations.createPolylineAnnotationManager();
    var geometry =
        LineString(coordinates: [Position(1.0, 2.0), Position(10.0, 20.0)]);

    var polylineAnnotationOptions = PolylineAnnotationOptions(
      geometry: geometry.toJson(),
    );
    final annotation = await manager.create(polylineAnnotationOptions);
    var lineString = LineString.fromJson((annotation.geometry)!.cast());
    var newlineString = LineString(
        coordinates: lineString.coordinates
            .map((e) => Position(e.lng + 1.0, e.lat + 1.0))
            .toList());
    annotation.geometry = newlineString.toJson();
    await manager.update(annotation);
    await manager.delete(annotation);

    for (var i = 0; i < 10; i++) {
      await manager.create(polylineAnnotationOptions);
    }

    await manager.deleteAll();
    await addDelay(1000);
  });
}
// End of generated file.
