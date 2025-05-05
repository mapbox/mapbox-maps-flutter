// This file is generated.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('create PointAnnotation', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createPointAnnotationManager();
    var geometry = Point(coordinates: Position(1.0, 2.0));
    final ByteData bytes =
        await rootBundle.load('assets/symbols/custom-icon.png');
    final Uint8List imageData = bytes.buffer.asUint8List();

    var pointAnnotationOptions = PointAnnotationOptions(
      geometry: geometry,
      image: imageData,
      iconAnchor: IconAnchor.CENTER,
      iconImage: "abc",
      iconOffset: [0.0, 1.0],
      iconRotate: 1.0,
      iconSize: 1.0,
      iconTextFit: IconTextFit.NONE,
      iconTextFitPadding: [0.0, 1.0, 2.0, 3.0],
      symbolSortKey: 1.0,
      textAnchor: TextAnchor.CENTER,
      textField: "abc",
      textJustify: TextJustify.AUTO,
      textLetterSpacing: 1.0,
      textLineHeight: 1.0,
      textMaxWidth: 1.0,
      textOffset: [0.0, 1.0],
      textRadialOffset: 1.0,
      textRotate: 1.0,
      textSize: 1.0,
      textTransform: TextTransform.NONE,
      iconColor: Colors.red.value,
      iconEmissiveStrength: 1.0,
      iconHaloBlur: 1.0,
      iconHaloColor: Colors.red.value,
      iconHaloWidth: 1.0,
      iconImageCrossFade: 1.0,
      iconOcclusionOpacity: 1.0,
      iconOpacity: 1.0,
      symbolZOffset: 1.0,
      textColor: Colors.red.value,
      textEmissiveStrength: 1.0,
      textHaloBlur: 1.0,
      textHaloColor: Colors.red.value,
      textHaloWidth: 1.0,
      textOcclusionOpacity: 1.0,
      textOpacity: 1.0,
    );
    final annotation = await manager.create(pointAnnotationOptions);
    var point = annotation.geometry;
    expect(1.0, point.coordinates.lng);
    expect(2.0, point.coordinates.lat);
    expect(annotation.image, isNotNull);
    expect(IconAnchor.CENTER, annotation.iconAnchor);
    expect("abc", annotation.iconImage);
    expect([0.0, 1.0], annotation.iconOffset);
    expect(1.0, annotation.iconRotate);
    expect(1.0, annotation.iconSize);
    expect(IconTextFit.NONE, annotation.iconTextFit);
    expect([0.0, 1.0, 2.0, 3.0], annotation.iconTextFitPadding);
    expect(1.0, annotation.symbolSortKey);
    expect(TextAnchor.CENTER, annotation.textAnchor);
    expect("abc", annotation.textField);
    expect(TextJustify.AUTO, annotation.textJustify);
    expect(1.0, annotation.textLetterSpacing);
    expect(1.0, annotation.textLineHeight);
    expect(1.0, annotation.textMaxWidth);
    expect([0.0, 1.0], annotation.textOffset);
    expect(1.0, annotation.textRadialOffset);
    expect(1.0, annotation.textRotate);
    expect(1.0, annotation.textSize);
    expect(TextTransform.NONE, annotation.textTransform);
    expect(Colors.red.value, annotation.iconColor);
    expect(1.0, annotation.iconEmissiveStrength);
    expect(1.0, annotation.iconHaloBlur);
    expect(Colors.red.value, annotation.iconHaloColor);
    expect(1.0, annotation.iconHaloWidth);
    expect(1.0, annotation.iconImageCrossFade);
    expect(1.0, annotation.iconOcclusionOpacity);
    expect(1.0, annotation.iconOpacity);
    expect(1.0, annotation.symbolZOffset);
    expect(Colors.red.value, annotation.textColor);
    expect(1.0, annotation.textEmissiveStrength);
    expect(1.0, annotation.textHaloBlur);
    expect(Colors.red.value, annotation.textHaloColor);
    expect(1.0, annotation.textHaloWidth);
    expect(1.0, annotation.textOcclusionOpacity);
    expect(1.0, annotation.textOpacity);
  });

  testWidgets('update and delete PointAnnotation', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createPointAnnotationManager();
    var geometry = Point(coordinates: Position(1.0, 2.0));

    var pointAnnotationOptions = PointAnnotationOptions(
      geometry: geometry,
    );
    final annotation = await manager.create(pointAnnotationOptions);
    var point = annotation.geometry;
    var newPoint = Point(
        coordinates:
            Position(point.coordinates.lng + 1.0, point.coordinates.lat + 1.0));
    annotation.geometry = newPoint;
    await manager.update(annotation);
    await manager.delete(annotation);

    for (var i = 0; i < 10; i++) {
      await manager.create(pointAnnotationOptions);
    }

    await manager.deleteAll();
  });
}
// End of generated file.
