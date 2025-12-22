// This file is generated.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('create PolylineAnnotation', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager =
        await mapboxMap.annotations.createPolylineAnnotationManager();
    var geometry =
        LineString(coordinates: [Position(1.0, 2.0), Position(10.0, 20.0)]);

    var polylineAnnotationOptions = PolylineAnnotationOptions(
      geometry: geometry,
      lineJoin: LineJoin.BEVEL,
      lineSortKey: 1.0,
      lineZOffset: 1.0,
      lineBlur: 1.0,
      lineBorderColor: Colors.red.value,
      lineBorderWidth: 1.0,
      lineColor: Colors.red.value,
      lineEmissiveStrength: 1.0,
      lineGapWidth: 1.0,
      lineOffset: 1.0,
      lineOpacity: 1.0,
      linePattern: "abc",
      lineWidth: 1.0,
      customData: {'foo': 'bar'},
    );
    final annotation = await manager.create(polylineAnnotationOptions);
    var lineString = annotation.geometry;
    var points = lineString.coordinates;
    expect(2, points.length);
    expect(1.0, points.first.lng);
    expect(2.0, points.first.lat);
    expect(10.0, points.last.lng);
    expect(20.0, points.last.lat);
    expect(LineJoin.BEVEL, annotation.lineJoin);
    expect(1.0, annotation.lineSortKey);
    expect(1.0, annotation.lineZOffset);
    expect(1.0, annotation.lineBlur);
    expect(Colors.red.value, annotation.lineBorderColor);
    expect(1.0, annotation.lineBorderWidth);
    expect(Colors.red.value, annotation.lineColor);
    expect(1.0, annotation.lineEmissiveStrength);
    expect(1.0, annotation.lineGapWidth);
    expect(1.0, annotation.lineOffset);
    expect(1.0, annotation.lineOpacity);
    expect("abc", annotation.linePattern);
    expect(1.0, annotation.lineWidth);
    expect({'foo': 'bar'}, annotation.customData);

    // Print memory usage after test
    await app.printMemoryUsage('create PolylineAnnotation');
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
      geometry: geometry,
    );
    final annotation = await manager.create(polylineAnnotationOptions);
    var lineString = annotation.geometry;
    var newlineString = LineString(
        coordinates: lineString.coordinates
            .map((e) => Position(e.lng + 1.0, e.lat + 1.0))
            .toList());
    annotation.geometry = newlineString;
    await manager.update(annotation);
    await manager.delete(annotation);

    for (var i = 0; i < 10; i++) {
      await manager.create(polylineAnnotationOptions);
    }

    final annotations = await manager.getAnnotations();
    expect(annotations.length, equals(10));

    await manager.deleteAll();

    // Print memory usage after test
    await app.printMemoryUsage('update and delete PolylineAnnotation');
  });

  testWidgets('deleteMulti PolylineAnnotation', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager =
        await mapboxMap.annotations.createPolylineAnnotationManager();
    var geometry =
        LineString(coordinates: [Position(1.0, 2.0), Position(10.0, 20.0)]);

    var polylineAnnotationOptions = PolylineAnnotationOptions(
      geometry: geometry,
    );

    // Create 10 annotations
    var createdAnnotations = <PolylineAnnotation>[];
    for (var i = 0; i < 10; i++) {
      final annotation = await manager.create(polylineAnnotationOptions);
      createdAnnotations.add(annotation);
    }

    var allAnnotations = await manager.getAnnotations();
    expect(allAnnotations.length, equals(10));

    // Delete first 5 annotations
    final toDelete = createdAnnotations.take(5).toList();
    await manager.deleteMulti(toDelete);

    allAnnotations = await manager.getAnnotations();
    expect(allAnnotations.length, equals(5));

    // Delete remaining annotations plus some already deleted (partial deletion)
    await manager.deleteMulti(createdAnnotations);

    allAnnotations = await manager.getAnnotations();
    expect(allAnnotations.length, equals(0));

    // Delete empty list should succeed
    await manager.deleteMulti([]);

    allAnnotations = await manager.getAnnotations();
    expect(allAnnotations.length, equals(0));

    // Print memory usage after test
    await app.printMemoryUsage('deleteMulti PolylineAnnotation');
  });
}
// End of generated file.
