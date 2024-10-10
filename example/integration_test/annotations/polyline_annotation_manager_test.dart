// This file is generated.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PolylineAnnotationManager custom id and position',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final dummyLayer = LineLayer(id: "dummyLayer", sourceId: 'sourceId');
    await mapboxMap.style.addLayer(dummyLayer);
    final id = "PolylineAnnotationManagerId";
    final manager = await mapboxMap.annotations
        .createPolylineAnnotationManager(id: id, below: 'dummyLayer');

    expect(await mapboxMap.style.styleLayerExists(id), isTrue);
    expect(await mapboxMap.style.styleSourceExists(id), isTrue);
    expect(manager.id, id);
    final layers = await mapboxMap.style.getStyleLayers();
    expect(layers.first?.id, id);
    expect(layers.last?.id, dummyLayer.id);
  });

  testWidgets('create PolylineAnnotation_manager ',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager =
        await mapboxMap.annotations.createPolylineAnnotationManager();

    await manager.setLineCap(LineCap.BUTT);
    var lineCap = await manager.getLineCap();
    expect(LineCap.BUTT, lineCap);

    await manager.setLineJoin(LineJoin.BEVEL);
    var lineJoin = await manager.getLineJoin();
    expect(LineJoin.BEVEL, lineJoin);

    await manager.setLineMiterLimit(1.0);
    var lineMiterLimit = await manager.getLineMiterLimit();
    expect(1.0, lineMiterLimit);

    await manager.setLineRoundLimit(1.0);
    var lineRoundLimit = await manager.getLineRoundLimit();
    expect(1.0, lineRoundLimit);

    await manager.setLineSortKey(1.0);
    var lineSortKey = await manager.getLineSortKey();
    expect(1.0, lineSortKey);

    await manager.setLineZOffset(1.0);
    var lineZOffset = await manager.getLineZOffset();
    expect(1.0, lineZOffset);

    await manager.setLineBlur(1.0);
    var lineBlur = await manager.getLineBlur();
    expect(1.0, lineBlur);

    await manager.setLineBorderColor(Colors.red.value);
    var lineBorderColor = await manager.getLineBorderColor();
    expect(Colors.red.value, lineBorderColor);

    await manager.setLineBorderWidth(1.0);
    var lineBorderWidth = await manager.getLineBorderWidth();
    expect(1.0, lineBorderWidth);

    await manager.setLineColor(Colors.red.value);
    var lineColor = await manager.getLineColor();
    expect(Colors.red.value, lineColor);

    await manager.setLineDasharray([1.0, 2.0]);
    var lineDasharray = await manager.getLineDasharray();
    expect([1.0, 2.0], lineDasharray);

    await manager.setLineDepthOcclusionFactor(1.0);
    var lineDepthOcclusionFactor = await manager.getLineDepthOcclusionFactor();
    expect(1.0, lineDepthOcclusionFactor);

    await manager.setLineEmissiveStrength(1.0);
    var lineEmissiveStrength = await manager.getLineEmissiveStrength();
    expect(1.0, lineEmissiveStrength);

    await manager.setLineGapWidth(1.0);
    var lineGapWidth = await manager.getLineGapWidth();
    expect(1.0, lineGapWidth);

    await manager.setLineOcclusionOpacity(1.0);
    var lineOcclusionOpacity = await manager.getLineOcclusionOpacity();
    expect(1.0, lineOcclusionOpacity);

    await manager.setLineOffset(1.0);
    var lineOffset = await manager.getLineOffset();
    expect(1.0, lineOffset);

    await manager.setLineOpacity(1.0);
    var lineOpacity = await manager.getLineOpacity();
    expect(1.0, lineOpacity);

    await manager.setLinePattern("abc");
    var linePattern = await manager.getLinePattern();
    expect("abc", linePattern);

    await manager.setLineTranslate([0.0, 1.0]);
    var lineTranslate = await manager.getLineTranslate();
    expect([0.0, 1.0], lineTranslate);

    await manager.setLineTranslateAnchor(LineTranslateAnchor.MAP);
    var lineTranslateAnchor = await manager.getLineTranslateAnchor();
    expect(LineTranslateAnchor.MAP, lineTranslateAnchor);

    await manager.setLineTrimColor(Colors.red.value);
    var lineTrimColor = await manager.getLineTrimColor();
    expect(Colors.red.value, lineTrimColor);

    await manager.setLineTrimFadeRange([0.0, 1.0]);
    var lineTrimFadeRange = await manager.getLineTrimFadeRange();
    expect([0.0, 1.0], lineTrimFadeRange);

    await manager.setLineTrimOffset([0.0, 1.0]);
    var lineTrimOffset = await manager.getLineTrimOffset();
    expect([0.0, 1.0], lineTrimOffset);

    await manager.setLineWidth(1.0);
    var lineWidth = await manager.getLineWidth();
    expect(1.0, lineWidth);
  });
}
// End of generated file.
