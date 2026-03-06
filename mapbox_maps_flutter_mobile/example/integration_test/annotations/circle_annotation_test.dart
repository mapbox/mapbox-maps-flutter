// This file is generated.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('create CircleAnnotation', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();
    var geometry = Point(coordinates: Position(1.0, 2.0));

    var circleAnnotationOptions = CircleAnnotationOptions(
      geometry: geometry,
      circleSortKey: 1.0,
      circleBlur: 1.0,
      circleColor: Colors.red.value,
      circleOpacity: 1.0,
      circleRadius: 1.0,
      circleStrokeColor: Colors.red.value,
      circleStrokeOpacity: 1.0,
      circleStrokeWidth: 1.0,
      customData: {'foo': 'bar'},
    );
    final annotation = await manager.create(circleAnnotationOptions);
    var point = annotation.geometry;
    expect(1.0, point.coordinates.lng);
    expect(2.0, point.coordinates.lat);
    expect(1.0, annotation.circleSortKey);
    expect(1.0, annotation.circleBlur);
    expect(Colors.red.value, annotation.circleColor);
    expect(1.0, annotation.circleOpacity);
    expect(1.0, annotation.circleRadius);
    expect(Colors.red.value, annotation.circleStrokeColor);
    expect(1.0, annotation.circleStrokeOpacity);
    expect(1.0, annotation.circleStrokeWidth);
    expect({'foo': 'bar'}, annotation.customData);
  });

  testWidgets('update and delete CircleAnnotation',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();
    var geometry = Point(coordinates: Position(1.0, 2.0));

    var circleAnnotationOptions = CircleAnnotationOptions(
      geometry: geometry,
    );
    final annotation = await manager.create(circleAnnotationOptions);
    var point = annotation.geometry;
    var newPoint = Point(
        coordinates:
            Position(point.coordinates.lng + 1.0, point.coordinates.lat + 1.0));
    annotation.geometry = newPoint;
    await manager.update(annotation);
    await manager.delete(annotation);

    for (var i = 0; i < 10; i++) {
      await manager.create(circleAnnotationOptions);
    }

    final annotations = await manager.getAnnotations();
    expect(annotations.length, equals(10));

    await manager.deleteAll();
  });

  testWidgets('deleteMulti CircleAnnotation', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();
    var geometry = Point(coordinates: Position(1.0, 2.0));

    var circleAnnotationOptions = CircleAnnotationOptions(
      geometry: geometry,
    );

    // Create 10 annotations
    var createdAnnotations = <CircleAnnotation>[];
    for (var i = 0; i < 10; i++) {
      final annotation = await manager.create(circleAnnotationOptions);
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
  });
}
// End of generated file.
