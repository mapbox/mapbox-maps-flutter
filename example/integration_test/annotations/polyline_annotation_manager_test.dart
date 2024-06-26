// This file is generated.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

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

    await manager.setLineMiterLimit(1.0);
    var lineMiterLimit = await manager.getLineMiterLimit();
    expect(1.0, lineMiterLimit);

    await manager.setLineRoundLimit(1.0);
    var lineRoundLimit = await manager.getLineRoundLimit();
    expect(1.0, lineRoundLimit);

    await manager.setLineDasharray([1.0, 2.0]);
    var lineDasharray = await manager.getLineDasharray();
    expect([1.0, 2.0], lineDasharray);

    await manager.setLineDepthOcclusionFactor(1.0);
    var lineDepthOcclusionFactor = await manager.getLineDepthOcclusionFactor();
    expect(1.0, lineDepthOcclusionFactor);

    await manager.setLineEmissiveStrength(1.0);
    var lineEmissiveStrength = await manager.getLineEmissiveStrength();
    expect(1.0, lineEmissiveStrength);

    await manager.setLineOcclusionOpacity(1.0);
    var lineOcclusionOpacity = await manager.getLineOcclusionOpacity();
    expect(1.0, lineOcclusionOpacity);

    await manager.setLineTranslate([0.0, 1.0]);
    var lineTranslate = await manager.getLineTranslate();
    expect([0.0, 1.0], lineTranslate);

    await manager.setLineTranslateAnchor(LineTranslateAnchor.MAP);
    var lineTranslateAnchor = await manager.getLineTranslateAnchor();
    expect(LineTranslateAnchor.MAP, lineTranslateAnchor);

    await manager.setLineTrimOffset([0.0, 1.0]);
    var lineTrimOffset = await manager.getLineTrimOffset();
    expect([0.0, 1.0], lineTrimOffset);
  });
}
// End of generated file.
