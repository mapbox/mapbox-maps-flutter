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

  testWidgets('create PointAnnotation', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createPointAnnotationManager();
    var geometry = Point(coordinates: Position(1.0, 2.0));

    var pointAnnotationOptions = PointAnnotationOptions(
      geometry: geometry.toJson(),
      iconAnchor: IconAnchor.CENTER,
      iconImage: "abc",
      iconOffset: [0.0, 1.0],
      iconRotate: 1.0,
      iconSize: 1.0,
      symbolSortKey: 1.0,
      textAnchor: TextAnchor.CENTER,
      textField: "abc",
      textJustify: TextJustify.AUTO,
      textLetterSpacing: 1.0,
      textMaxWidth: 1.0,
      textOffset: [0.0, 1.0],
      textRadialOffset: 1.0,
      textRotate: 1.0,
      textSize: 1.0,
      textTransform: TextTransform.NONE,
      iconColor: Colors.red.value,
      iconHaloBlur: 1.0,
      iconHaloColor: Colors.red.value,
      iconHaloWidth: 1.0,
      iconOpacity: 1.0,
      textColor: Colors.red.value,
      textHaloBlur: 1.0,
      textHaloColor: Colors.red.value,
      textHaloWidth: 1.0,
      textOpacity: 1.0,
    );
    final annotation = await manager.create(pointAnnotationOptions);
    var point = Point.fromJson((annotation.geometry)!.cast());
    expect(1.0, point.coordinates.lng);
    expect(2.0, point.coordinates.lat);
    expect(IconAnchor.CENTER, annotation.iconAnchor);
    expect("abc", annotation.iconImage);
    expect([0.0, 1.0], annotation.iconOffset);
    expect(1.0, annotation.iconRotate);
    expect(1.0, annotation.iconSize);
    expect(1.0, annotation.symbolSortKey);
    expect(TextAnchor.CENTER, annotation.textAnchor);
    expect("abc", annotation.textField);
    expect(TextJustify.AUTO, annotation.textJustify);
    expect(1.0, annotation.textLetterSpacing);
    expect(1.0, annotation.textMaxWidth);
    expect([0.0, 1.0], annotation.textOffset);
    expect(1.0, annotation.textRadialOffset);
    expect(1.0, annotation.textRotate);
    expect(1.0, annotation.textSize);
    expect(TextTransform.NONE, annotation.textTransform);
    expect(Colors.red.value, annotation.iconColor);
    expect(1.0, annotation.iconHaloBlur);
    expect(Colors.red.value, annotation.iconHaloColor);
    expect(1.0, annotation.iconHaloWidth);
    expect(1.0, annotation.iconOpacity);
    expect(Colors.red.value, annotation.textColor);
    expect(1.0, annotation.textHaloBlur);
    expect(Colors.red.value, annotation.textHaloColor);
    expect(1.0, annotation.textHaloWidth);
    expect(1.0, annotation.textOpacity);
  });

  testWidgets('update and delete PointAnnotation', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createPointAnnotationManager();
    var geometry = Point(coordinates: Position(1.0, 2.0));

    var pointAnnotationOptions = PointAnnotationOptions(
      geometry: geometry.toJson(),
    );
    final annotation = await manager.create(pointAnnotationOptions);
    var point = Point.fromJson((annotation.geometry)!.cast());
    var newPoint = Point(
        coordinates:
            Position(point.coordinates.lng + 1.0, point.coordinates.lat + 1.0));
    annotation.geometry = newPoint.toJson();
    await manager.update(annotation);
    await manager.delete(annotation);

    for (var i = 0; i < 10; i++) {
      await manager.create(pointAnnotationOptions);
    }

    await manager.deleteAll();
    await addDelay(1000);
  });
}
// End of generated file.
