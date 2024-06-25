// This file is generated.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PointAnnotationManager custom id and position',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final dummyLayer = SymbolLayer(id: "dummyLayer", sourceId: 'sourceId');
    await mapboxMap.style.addLayer(dummyLayer);
    final id = "PointAnnotationManagerId";
    final manager = await mapboxMap.annotations
        .createPointAnnotationManager(id: id, below: 'dummyLayer');

    expect(await mapboxMap.style.styleLayerExists(id), isTrue);
    expect(await mapboxMap.style.styleSourceExists(id), isTrue);
    expect(manager.id, id);
    final layers = await mapboxMap.style.getStyleLayers();
    expect(layers.first?.id, id);
    expect(layers.last?.id, dummyLayer.id);
  });

  testWidgets('create PointAnnotation_manager ', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createPointAnnotationManager();

    await manager.setIconAllowOverlap(true);
    var iconAllowOverlap = await manager.getIconAllowOverlap();
    expect(true, iconAllowOverlap);

    await manager.setIconIgnorePlacement(true);
    var iconIgnorePlacement = await manager.getIconIgnorePlacement();
    expect(true, iconIgnorePlacement);

    await manager.setIconKeepUpright(true);
    var iconKeepUpright = await manager.getIconKeepUpright();
    expect(true, iconKeepUpright);

    await manager.setIconOptional(true);
    var iconOptional = await manager.getIconOptional();
    expect(true, iconOptional);

    await manager.setIconPadding(1.0);
    var iconPadding = await manager.getIconPadding();
    expect(1.0, iconPadding);

    await manager.setIconPitchAlignment(IconPitchAlignment.MAP);
    var iconPitchAlignment = await manager.getIconPitchAlignment();
    expect(IconPitchAlignment.MAP, iconPitchAlignment);

    await manager.setIconRotationAlignment(IconRotationAlignment.MAP);
    var iconRotationAlignment = await manager.getIconRotationAlignment();
    expect(IconRotationAlignment.MAP, iconRotationAlignment);

    await manager.setSymbolAvoidEdges(true);
    var symbolAvoidEdges = await manager.getSymbolAvoidEdges();
    expect(true, symbolAvoidEdges);

    await manager.setSymbolPlacement(SymbolPlacement.POINT);
    var symbolPlacement = await manager.getSymbolPlacement();
    expect(SymbolPlacement.POINT, symbolPlacement);

    await manager.setSymbolSpacing(1.0);
    var symbolSpacing = await manager.getSymbolSpacing();
    expect(1.0, symbolSpacing);

    await manager.setSymbolZElevate(true);
    var symbolZElevate = await manager.getSymbolZElevate();
    expect(true, symbolZElevate);

    await manager.setSymbolZOrder(SymbolZOrder.AUTO);
    var symbolZOrder = await manager.getSymbolZOrder();
    expect(SymbolZOrder.AUTO, symbolZOrder);

    await manager.setTextAllowOverlap(true);
    var textAllowOverlap = await manager.getTextAllowOverlap();
    expect(true, textAllowOverlap);

    await manager.setTextFont(["a", "b", "c"]);
    var textFont = await manager.getTextFont();
    expect(["a", "b", "c"], textFont);

    await manager.setTextIgnorePlacement(true);
    var textIgnorePlacement = await manager.getTextIgnorePlacement();
    expect(true, textIgnorePlacement);

    await manager.setTextKeepUpright(true);
    var textKeepUpright = await manager.getTextKeepUpright();
    expect(true, textKeepUpright);

    await manager.setTextMaxAngle(1.0);
    var textMaxAngle = await manager.getTextMaxAngle();
    expect(1.0, textMaxAngle);

    await manager.setTextOptional(true);
    var textOptional = await manager.getTextOptional();
    expect(true, textOptional);

    await manager.setTextPadding(1.0);
    var textPadding = await manager.getTextPadding();
    expect(1.0, textPadding);

    await manager.setTextPitchAlignment(TextPitchAlignment.MAP);
    var textPitchAlignment = await manager.getTextPitchAlignment();
    expect(TextPitchAlignment.MAP, textPitchAlignment);

    await manager.setTextRotationAlignment(TextRotationAlignment.MAP);
    var textRotationAlignment = await manager.getTextRotationAlignment();
    expect(TextRotationAlignment.MAP, textRotationAlignment);

    await manager.setIconColorSaturation(1.0);
    var iconColorSaturation = await manager.getIconColorSaturation();
    expect(1.0, iconColorSaturation);

    await manager.setIconOcclusionOpacity(1.0);
    var iconOcclusionOpacity = await manager.getIconOcclusionOpacity();
    expect(1.0, iconOcclusionOpacity);

    await manager.setIconTranslate([0.0, 1.0]);
    var iconTranslate = await manager.getIconTranslate();
    expect([0.0, 1.0], iconTranslate);

    await manager.setIconTranslateAnchor(IconTranslateAnchor.MAP);
    var iconTranslateAnchor = await manager.getIconTranslateAnchor();
    expect(IconTranslateAnchor.MAP, iconTranslateAnchor);

    await manager.setTextOcclusionOpacity(1.0);
    var textOcclusionOpacity = await manager.getTextOcclusionOpacity();
    expect(1.0, textOcclusionOpacity);

    await manager.setTextTranslate([0.0, 1.0]);
    var textTranslate = await manager.getTextTranslate();
    expect([0.0, 1.0], textTranslate);

    await manager.setTextTranslateAnchor(TextTranslateAnchor.MAP);
    var textTranslateAnchor = await manager.getTextTranslateAnchor();
    expect(TextTranslateAnchor.MAP, textTranslateAnchor);
  });
}
// End of generated file.
