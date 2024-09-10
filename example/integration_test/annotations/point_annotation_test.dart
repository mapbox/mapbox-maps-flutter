// This file is generated.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

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
      iconAllowOverlap: true,
      iconAnchor: IconAnchor.CENTER,
      iconIgnorePlacement: true,
      iconImage: "abc",
      iconKeepUpright: true,
      iconOffset: [0.0, 1.0],
      iconOptional: true,
      iconPadding: 1.0,
      iconPitchAlignment: IconPitchAlignment.MAP,
      iconRotate: 1.0,
      iconRotationAlignment: IconRotationAlignment.MAP,
      iconSize: 1.0,
      iconTextFit: IconTextFit.NONE,
      iconTextFitPadding: [0.0, 1.0, 2.0, 3.0],
      symbolAvoidEdges: true,
      symbolPlacement: SymbolPlacement.POINT,
      symbolSortKey: 1.0,
      symbolSpacing: 1.0,
      symbolZElevate: true,
      symbolZOrder: SymbolZOrder.AUTO,
      textAllowOverlap: true,
      textAnchor: TextAnchor.CENTER,
      textField: "abc",
      textFont: ["a", "b", "c"],
      textIgnorePlacement: true,
      textJustify: TextJustify.AUTO,
      textKeepUpright: true,
      textLetterSpacing: 1.0,
      textLineHeight: 1.0,
      textMaxAngle: 1.0,
      textMaxWidth: 1.0,
      textOffset: [0.0, 1.0],
      textOptional: true,
      textPadding: 1.0,
      textPitchAlignment: TextPitchAlignment.MAP,
      textRadialOffset: 1.0,
      textRotate: 1.0,
      textRotationAlignment: TextRotationAlignment.MAP,
      textSize: 1.0,
      textTransform: TextTransform.NONE,
      textVariableAnchor: ["center", "left"],
      textWritingMode: ["horizontal", "vertical"],
      iconColor: Colors.red.value,
      iconColorSaturation: 1.0,
      iconEmissiveStrength: 1.0,
      iconHaloBlur: 1.0,
      iconHaloColor: Colors.red.value,
      iconHaloWidth: 1.0,
      iconImageCrossFade: 1.0,
      iconOcclusionOpacity: 1.0,
      iconOpacity: 1.0,
      iconTranslate: [0.0, 1.0],
      iconTranslateAnchor: IconTranslateAnchor.MAP,
      symbolElevationReference: SymbolElevationReference.SEA,
      symbolZOffset: 1.0,
      textColor: Colors.red.value,
      textEmissiveStrength: 1.0,
      textHaloBlur: 1.0,
      textHaloColor: Colors.red.value,
      textHaloWidth: 1.0,
      textOcclusionOpacity: 1.0,
      textOpacity: 1.0,
      textTranslate: [0.0, 1.0],
      textTranslateAnchor: TextTranslateAnchor.MAP,
    );
    final annotation = await manager.create(pointAnnotationOptions);
    var point = annotation.geometry;
    expect(1.0, point.coordinates.lng);
    expect(2.0, point.coordinates.lat);
    expect(annotation.image, isNotNull);
    expect(true, annotation.iconAllowOverlap);
    expect(IconAnchor.CENTER, annotation.iconAnchor);
    expect(true, annotation.iconIgnorePlacement);
    expect("abc", annotation.iconImage);
    expect(true, annotation.iconKeepUpright);
    expect([0.0, 1.0], annotation.iconOffset);
    expect(true, annotation.iconOptional);
    expect(1.0, annotation.iconPadding);
    expect(IconPitchAlignment.MAP, annotation.iconPitchAlignment);
    expect(1.0, annotation.iconRotate);
    expect(IconRotationAlignment.MAP, annotation.iconRotationAlignment);
    expect(1.0, annotation.iconSize);
    expect(IconTextFit.NONE, annotation.iconTextFit);
    expect([0.0, 1.0, 2.0, 3.0], annotation.iconTextFitPadding);
    expect(true, annotation.symbolAvoidEdges);
    expect(SymbolPlacement.POINT, annotation.symbolPlacement);
    expect(1.0, annotation.symbolSortKey);
    expect(1.0, annotation.symbolSpacing);
    expect(true, annotation.symbolZElevate);
    expect(SymbolZOrder.AUTO, annotation.symbolZOrder);
    expect(true, annotation.textAllowOverlap);
    expect(TextAnchor.CENTER, annotation.textAnchor);
    expect("abc", annotation.textField);
    expect(["a", "b", "c"], annotation.textFont);
    expect(true, annotation.textIgnorePlacement);
    expect(TextJustify.AUTO, annotation.textJustify);
    expect(true, annotation.textKeepUpright);
    expect(1.0, annotation.textLetterSpacing);
    expect(1.0, annotation.textLineHeight);
    expect(1.0, annotation.textMaxAngle);
    expect(1.0, annotation.textMaxWidth);
    expect([0.0, 1.0], annotation.textOffset);
    expect(true, annotation.textOptional);
    expect(1.0, annotation.textPadding);
    expect(TextPitchAlignment.MAP, annotation.textPitchAlignment);
    expect(1.0, annotation.textRadialOffset);
    expect(1.0, annotation.textRotate);
    expect(TextRotationAlignment.MAP, annotation.textRotationAlignment);
    expect(1.0, annotation.textSize);
    expect(TextTransform.NONE, annotation.textTransform);
    expect(["center", "left"], annotation.textVariableAnchor);
    expect(["horizontal", "vertical"], annotation.textWritingMode);
    expect(Colors.red.value, annotation.iconColor);
    expect(1.0, annotation.iconColorSaturation);
    expect(1.0, annotation.iconEmissiveStrength);
    expect(1.0, annotation.iconHaloBlur);
    expect(Colors.red.value, annotation.iconHaloColor);
    expect(1.0, annotation.iconHaloWidth);
    expect(1.0, annotation.iconImageCrossFade);
    expect(1.0, annotation.iconOcclusionOpacity);
    expect(1.0, annotation.iconOpacity);
    expect([0.0, 1.0], annotation.iconTranslate);
    expect(IconTranslateAnchor.MAP, annotation.iconTranslateAnchor);
    expect(SymbolElevationReference.SEA, annotation.symbolElevationReference);
    expect(1.0, annotation.symbolZOffset);
    expect(Colors.red.value, annotation.textColor);
    expect(1.0, annotation.textEmissiveStrength);
    expect(1.0, annotation.textHaloBlur);
    expect(Colors.red.value, annotation.textHaloColor);
    expect(1.0, annotation.textHaloWidth);
    expect(1.0, annotation.textOcclusionOpacity);
    expect(1.0, annotation.textOpacity);
    expect([0.0, 1.0], annotation.textTranslate);
    expect(TextTranslateAnchor.MAP, annotation.textTranslateAnchor);
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
