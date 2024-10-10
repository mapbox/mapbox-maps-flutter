// This file is generated.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CircleAnnotationManager custom id and position',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final dummyLayer = CircleLayer(id: "dummyLayer", sourceId: 'sourceId');
    await mapboxMap.style.addLayer(dummyLayer);
    final id = "CircleAnnotationManagerId";
    final manager = await mapboxMap.annotations
        .createCircleAnnotationManager(id: id, below: 'dummyLayer');

    expect(await mapboxMap.style.styleLayerExists(id), isTrue);
    expect(await mapboxMap.style.styleSourceExists(id), isTrue);
    expect(manager.id, id);
    final layers = await mapboxMap.style.getStyleLayers();
    expect(layers.first?.id, id);
    expect(layers.last?.id, dummyLayer.id);
  });

  testWidgets('create CircleAnnotation_manager ', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();

    await manager.setCircleSortKey(1.0);
    var circleSortKey = await manager.getCircleSortKey();
    expect(1.0, circleSortKey);

    await manager.setCircleBlur(1.0);
    var circleBlur = await manager.getCircleBlur();
    expect(1.0, circleBlur);

    await manager.setCircleColor(Colors.red.value);
    var circleColor = await manager.getCircleColor();
    expect(Colors.red.value, circleColor);

    await manager.setCircleEmissiveStrength(1.0);
    var circleEmissiveStrength = await manager.getCircleEmissiveStrength();
    expect(1.0, circleEmissiveStrength);

    await manager.setCircleOpacity(1.0);
    var circleOpacity = await manager.getCircleOpacity();
    expect(1.0, circleOpacity);

    await manager.setCirclePitchAlignment(CirclePitchAlignment.MAP);
    var circlePitchAlignment = await manager.getCirclePitchAlignment();
    expect(CirclePitchAlignment.MAP, circlePitchAlignment);

    await manager.setCirclePitchScale(CirclePitchScale.MAP);
    var circlePitchScale = await manager.getCirclePitchScale();
    expect(CirclePitchScale.MAP, circlePitchScale);

    await manager.setCircleRadius(1.0);
    var circleRadius = await manager.getCircleRadius();
    expect(1.0, circleRadius);

    await manager.setCircleStrokeColor(Colors.red.value);
    var circleStrokeColor = await manager.getCircleStrokeColor();
    expect(Colors.red.value, circleStrokeColor);

    await manager.setCircleStrokeOpacity(1.0);
    var circleStrokeOpacity = await manager.getCircleStrokeOpacity();
    expect(1.0, circleStrokeOpacity);

    await manager.setCircleStrokeWidth(1.0);
    var circleStrokeWidth = await manager.getCircleStrokeWidth();
    expect(1.0, circleStrokeWidth);

    await manager.setCircleTranslate([0.0, 1.0]);
    var circleTranslate = await manager.getCircleTranslate();
    expect([0.0, 1.0], circleTranslate);

    await manager.setCircleTranslateAnchor(CircleTranslateAnchor.MAP);
    var circleTranslateAnchor = await manager.getCircleTranslateAnchor();
    expect(CircleTranslateAnchor.MAP, circleTranslateAnchor);
  });
}
// End of generated file.
