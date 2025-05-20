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

    await manager.deleteAll();
  });
}
// End of generated file.
