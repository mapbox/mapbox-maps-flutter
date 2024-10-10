// This file is generated.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../empty_map_widget.dart' as app;

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

    await manager.setIconAnchor(IconAnchor.CENTER);
    var iconAnchor = await manager.getIconAnchor();
    expect(IconAnchor.CENTER, iconAnchor);

    await manager.setIconIgnorePlacement(true);
    var iconIgnorePlacement = await manager.getIconIgnorePlacement();
    expect(true, iconIgnorePlacement);

    await manager.setIconImage("abc");
    var iconImage = await manager.getIconImage();
    expect("abc", iconImage);

    await manager.setIconKeepUpright(true);
    var iconKeepUpright = await manager.getIconKeepUpright();
    expect(true, iconKeepUpright);

    await manager.setIconOffset([0.0, 1.0]);
    var iconOffset = await manager.getIconOffset();
    expect([0.0, 1.0], iconOffset);

    await manager.setIconOptional(true);
    var iconOptional = await manager.getIconOptional();
    expect(true, iconOptional);

    await manager.setIconPadding(1.0);
    var iconPadding = await manager.getIconPadding();
    expect(1.0, iconPadding);

    await manager.setIconPitchAlignment(IconPitchAlignment.MAP);
    var iconPitchAlignment = await manager.getIconPitchAlignment();
    expect(IconPitchAlignment.MAP, iconPitchAlignment);

    await manager.setIconRotate(1.0);
    var iconRotate = await manager.getIconRotate();
    expect(1.0, iconRotate);

    await manager.setIconRotationAlignment(IconRotationAlignment.MAP);
    var iconRotationAlignment = await manager.getIconRotationAlignment();
    expect(IconRotationAlignment.MAP, iconRotationAlignment);

    await manager.setIconSize(1.0);
    var iconSize = await manager.getIconSize();
    expect(1.0, iconSize);

    await manager.setIconTextFit(IconTextFit.NONE);
    var iconTextFit = await manager.getIconTextFit();
    expect(IconTextFit.NONE, iconTextFit);

    await manager.setIconTextFitPadding([0.0, 1.0, 2.0, 3.0]);
    var iconTextFitPadding = await manager.getIconTextFitPadding();
    expect([0.0, 1.0, 2.0, 3.0], iconTextFitPadding);

    await manager.setSymbolAvoidEdges(true);
    var symbolAvoidEdges = await manager.getSymbolAvoidEdges();
    expect(true, symbolAvoidEdges);

    await manager.setSymbolPlacement(SymbolPlacement.POINT);
    var symbolPlacement = await manager.getSymbolPlacement();
    expect(SymbolPlacement.POINT, symbolPlacement);

    await manager.setSymbolSortKey(1.0);
    var symbolSortKey = await manager.getSymbolSortKey();
    expect(1.0, symbolSortKey);

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

    await manager.setTextAnchor(TextAnchor.CENTER);
    var textAnchor = await manager.getTextAnchor();
    expect(TextAnchor.CENTER, textAnchor);

    await manager.setTextField("abc");
    var textField = await manager.getTextField();
    expect("abc", textField);

    await manager.setTextFont(["a", "b", "c"]);
    var textFont = await manager.getTextFont();
    expect(["a", "b", "c"], textFont);

    await manager.setTextIgnorePlacement(true);
    var textIgnorePlacement = await manager.getTextIgnorePlacement();
    expect(true, textIgnorePlacement);

    await manager.setTextJustify(TextJustify.AUTO);
    var textJustify = await manager.getTextJustify();
    expect(TextJustify.AUTO, textJustify);

    await manager.setTextKeepUpright(true);
    var textKeepUpright = await manager.getTextKeepUpright();
    expect(true, textKeepUpright);

    await manager.setTextLetterSpacing(1.0);
    var textLetterSpacing = await manager.getTextLetterSpacing();
    expect(1.0, textLetterSpacing);

    await manager.setTextLineHeight(1.0);
    var textLineHeight = await manager.getTextLineHeight();
    expect(1.0, textLineHeight);

    await manager.setTextMaxAngle(1.0);
    var textMaxAngle = await manager.getTextMaxAngle();
    expect(1.0, textMaxAngle);

    await manager.setTextMaxWidth(1.0);
    var textMaxWidth = await manager.getTextMaxWidth();
    expect(1.0, textMaxWidth);

    await manager.setTextOffset([0.0, 1.0]);
    var textOffset = await manager.getTextOffset();
    expect([0.0, 1.0], textOffset);

    await manager.setTextOptional(true);
    var textOptional = await manager.getTextOptional();
    expect(true, textOptional);

    await manager.setTextPadding(1.0);
    var textPadding = await manager.getTextPadding();
    expect(1.0, textPadding);

    await manager.setTextPitchAlignment(TextPitchAlignment.MAP);
    var textPitchAlignment = await manager.getTextPitchAlignment();
    expect(TextPitchAlignment.MAP, textPitchAlignment);

    await manager.setTextRadialOffset(1.0);
    var textRadialOffset = await manager.getTextRadialOffset();
    expect(1.0, textRadialOffset);

    await manager.setTextRotate(1.0);
    var textRotate = await manager.getTextRotate();
    expect(1.0, textRotate);

    await manager.setTextRotationAlignment(TextRotationAlignment.MAP);
    var textRotationAlignment = await manager.getTextRotationAlignment();
    expect(TextRotationAlignment.MAP, textRotationAlignment);

    await manager.setTextSize(1.0);
    var textSize = await manager.getTextSize();
    expect(1.0, textSize);

    await manager.setTextTransform(TextTransform.NONE);
    var textTransform = await manager.getTextTransform();
    expect(TextTransform.NONE, textTransform);

    await manager.setIconColor(Colors.red.value);
    var iconColor = await manager.getIconColor();
    expect(Colors.red.value, iconColor);

    await manager.setIconColorSaturation(1.0);
    var iconColorSaturation = await manager.getIconColorSaturation();
    expect(1.0, iconColorSaturation);

    await manager.setIconEmissiveStrength(1.0);
    var iconEmissiveStrength = await manager.getIconEmissiveStrength();
    expect(1.0, iconEmissiveStrength);

    await manager.setIconHaloBlur(1.0);
    var iconHaloBlur = await manager.getIconHaloBlur();
    expect(1.0, iconHaloBlur);

    await manager.setIconHaloColor(Colors.red.value);
    var iconHaloColor = await manager.getIconHaloColor();
    expect(Colors.red.value, iconHaloColor);

    await manager.setIconHaloWidth(1.0);
    var iconHaloWidth = await manager.getIconHaloWidth();
    expect(1.0, iconHaloWidth);

    await manager.setIconImageCrossFade(1.0);
    var iconImageCrossFade = await manager.getIconImageCrossFade();
    expect(1.0, iconImageCrossFade);

    await manager.setIconOcclusionOpacity(1.0);
    var iconOcclusionOpacity = await manager.getIconOcclusionOpacity();
    expect(1.0, iconOcclusionOpacity);

    await manager.setIconOpacity(1.0);
    var iconOpacity = await manager.getIconOpacity();
    expect(1.0, iconOpacity);

    await manager.setIconTranslate([0.0, 1.0]);
    var iconTranslate = await manager.getIconTranslate();
    expect([0.0, 1.0], iconTranslate);

    await manager.setIconTranslateAnchor(IconTranslateAnchor.MAP);
    var iconTranslateAnchor = await manager.getIconTranslateAnchor();
    expect(IconTranslateAnchor.MAP, iconTranslateAnchor);

    await manager.setSymbolElevationReference(SymbolElevationReference.SEA);
    var symbolElevationReference = await manager.getSymbolElevationReference();
    expect(SymbolElevationReference.SEA, symbolElevationReference);

    await manager.setSymbolZOffset(1.0);
    var symbolZOffset = await manager.getSymbolZOffset();
    expect(1.0, symbolZOffset);

    await manager.setTextColor(Colors.red.value);
    var textColor = await manager.getTextColor();
    expect(Colors.red.value, textColor);

    await manager.setTextEmissiveStrength(1.0);
    var textEmissiveStrength = await manager.getTextEmissiveStrength();
    expect(1.0, textEmissiveStrength);

    await manager.setTextHaloBlur(1.0);
    var textHaloBlur = await manager.getTextHaloBlur();
    expect(1.0, textHaloBlur);

    await manager.setTextHaloColor(Colors.red.value);
    var textHaloColor = await manager.getTextHaloColor();
    expect(Colors.red.value, textHaloColor);

    await manager.setTextHaloWidth(1.0);
    var textHaloWidth = await manager.getTextHaloWidth();
    expect(1.0, textHaloWidth);

    await manager.setTextOcclusionOpacity(1.0);
    var textOcclusionOpacity = await manager.getTextOcclusionOpacity();
    expect(1.0, textOcclusionOpacity);

    await manager.setTextOpacity(1.0);
    var textOpacity = await manager.getTextOpacity();
    expect(1.0, textOpacity);

    await manager.setTextTranslate([0.0, 1.0]);
    var textTranslate = await manager.getTextTranslate();
    expect([0.0, 1.0], textTranslate);

    await manager.setTextTranslateAnchor(TextTranslateAnchor.MAP);
    var textTranslateAnchor = await manager.getTextTranslateAnchor();
    expect(TextTranslateAnchor.MAP, textTranslateAnchor);
  });
}
// End of generated file.
