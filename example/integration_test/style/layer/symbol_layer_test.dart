// This file is generated.
import 'dart:convert';
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add SymbolLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    final point = Point(coordinates: Position(-77.032667, 38.913175));
    await mapboxMap.style
        .addSource(GeoJsonSource(id: "source", data: json.encode(point)));

    await mapboxMap.style.addLayer(SymbolLayer(
      id: 'layer',
      sourceId: 'source',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
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
    ));
    var layer = await mapboxMap.style.getLayer('layer') as SymbolLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.iconAllowOverlap, true);
    expect(layer.iconAnchor, IconAnchor.CENTER);
    expect(layer.iconIgnorePlacement, true);
    expect(layer.iconImage, "abc");
    expect(layer.iconKeepUpright, true);
    expect(layer.iconOffset, [0.0, 1.0]);
    expect(layer.iconOptional, true);
    expect(layer.iconPadding, 1.0);
    expect(layer.iconPitchAlignment, IconPitchAlignment.MAP);
    expect(layer.iconRotate, 1.0);
    expect(layer.iconRotationAlignment, IconRotationAlignment.MAP);
    expect(layer.iconSize, 1.0);
    expect(layer.iconTextFit, IconTextFit.NONE);
    expect(layer.iconTextFitPadding, [0.0, 1.0, 2.0, 3.0]);
    expect(layer.symbolAvoidEdges, true);
    expect(layer.symbolPlacement, SymbolPlacement.POINT);
    expect(layer.symbolSortKey, 1.0);
    expect(layer.symbolSpacing, 1.0);
    expect(layer.symbolZElevate, true);
    expect(layer.symbolZOrder, SymbolZOrder.AUTO);
    expect(layer.textAllowOverlap, true);
    expect(layer.textAnchor, TextAnchor.CENTER);
    expect(layer.textFieldExpression, ['format', "abc", {}]);
    expect(layer.textFont, ["a", "b", "c"]);
    expect(layer.textIgnorePlacement, true);
    expect(layer.textJustify, TextJustify.AUTO);
    expect(layer.textKeepUpright, true);
    expect(layer.textLetterSpacing, 1.0);
    expect(layer.textLineHeight, 1.0);
    expect(layer.textMaxAngle, 1.0);
    expect(layer.textMaxWidth, 1.0);
    expect(layer.textOffset, [0.0, 1.0]);
    expect(layer.textOptional, true);
    expect(layer.textPadding, 1.0);
    expect(layer.textPitchAlignment, TextPitchAlignment.MAP);
    expect(layer.textRadialOffset, 1.0);
    expect(layer.textRotate, 1.0);
    expect(layer.textRotationAlignment, TextRotationAlignment.MAP);
    expect(layer.textSize, 1.0);
    expect(layer.textTransform, TextTransform.NONE);
    expect(layer.textVariableAnchor, ["center", "left"]);
    expect(layer.textWritingMode, ["horizontal", "vertical"]);
    expect(layer.iconColor, Colors.red.value);
    expect(layer.iconColorSaturation, 1.0);
    expect(layer.iconEmissiveStrength, 1.0);
    expect(layer.iconHaloBlur, 1.0);
    expect(layer.iconHaloColor, Colors.red.value);
    expect(layer.iconHaloWidth, 1.0);
    expect(layer.iconImageCrossFade, 1.0);
    expect(layer.iconOcclusionOpacity, 1.0);
    expect(layer.iconOpacity, 1.0);
    expect(layer.iconTranslate, [0.0, 1.0]);
    expect(layer.iconTranslateAnchor, IconTranslateAnchor.MAP);
    expect(layer.symbolElevationReference, SymbolElevationReference.SEA);
    expect(layer.symbolZOffset, 1.0);
    expect(layer.textColor, Colors.red.value);
    expect(layer.textEmissiveStrength, 1.0);
    expect(layer.textHaloBlur, 1.0);
    expect(layer.textHaloColor, Colors.red.value);
    expect(layer.textHaloWidth, 1.0);
    expect(layer.textOcclusionOpacity, 1.0);
    expect(layer.textOpacity, 1.0);
    expect(layer.textTranslate, [0.0, 1.0]);
    expect(layer.textTranslateAnchor, TextTranslateAnchor.MAP);
  });

  testWidgets('Add SymbolLayer with expressions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    final point = Point(coordinates: Position(-77.032667, 38.913175));
    await mapboxMap.style
        .addSource(GeoJsonSource(id: "source", data: json.encode(point)));

    await mapboxMap.style.addLayer(SymbolLayer(
      id: 'layer',
      sourceId: 'source',
      visibilityExpression: ['string', 'none'],
      filter: [
        "==",
        ["get", "type"],
        "Feature"
      ],
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      iconAllowOverlapExpression: ['==', true, true],
      iconAnchorExpression: ['string', 'center'],
      iconIgnorePlacementExpression: ['==', true, true],
      iconImageExpression: ['image', "abc"],
      iconKeepUprightExpression: ['==', true, true],
      iconOffsetExpression: [
        'literal',
        [0.0, 1.0]
      ],
      iconOptionalExpression: ['==', true, true],
      iconPaddingExpression: ['number', 1.0],
      iconPitchAlignmentExpression: ['string', 'map'],
      iconRotateExpression: ['number', 1.0],
      iconRotationAlignmentExpression: ['string', 'map'],
      iconSizeExpression: ['number', 1.0],
      iconTextFitExpression: ['string', 'none'],
      iconTextFitPaddingExpression: [
        'literal',
        [0.0, 1.0, 2.0, 3.0]
      ],
      symbolAvoidEdgesExpression: ['==', true, true],
      symbolPlacementExpression: ['string', 'point'],
      symbolSortKeyExpression: ['number', 1.0],
      symbolSpacingExpression: ['number', 1.0],
      symbolZElevateExpression: ['==', true, true],
      symbolZOrderExpression: ['string', 'auto'],
      textAllowOverlapExpression: ['==', true, true],
      textAnchorExpression: ['string', 'center'],
      textFieldExpression: ['format', "abc", {}],
      textFontExpression: [
        'literal',
        ["a", "b", "c"]
      ],
      textIgnorePlacementExpression: ['==', true, true],
      textJustifyExpression: ['string', 'auto'],
      textKeepUprightExpression: ['==', true, true],
      textLetterSpacingExpression: ['number', 1.0],
      textLineHeightExpression: ['number', 1.0],
      textMaxAngleExpression: ['number', 1.0],
      textMaxWidthExpression: ['number', 1.0],
      textOffsetExpression: [
        'literal',
        [0.0, 1.0]
      ],
      textOptionalExpression: ['==', true, true],
      textPaddingExpression: ['number', 1.0],
      textPitchAlignmentExpression: ['string', 'map'],
      textRadialOffsetExpression: ['number', 1.0],
      textRotateExpression: ['number', 1.0],
      textRotationAlignmentExpression: ['string', 'map'],
      textSizeExpression: ['number', 1.0],
      textTransformExpression: ['string', 'none'],
      textVariableAnchorExpression: [
        'literal',
        ["center", "left"]
      ],
      textWritingModeExpression: [
        'literal',
        ["horizontal", "vertical"]
      ],
      iconColorExpression: ['rgba', 255, 0, 0, 1],
      iconColorSaturationExpression: ['number', 1.0],
      iconEmissiveStrengthExpression: ['number', 1.0],
      iconHaloBlurExpression: ['number', 1.0],
      iconHaloColorExpression: ['rgba', 255, 0, 0, 1],
      iconHaloWidthExpression: ['number', 1.0],
      iconImageCrossFadeExpression: ['number', 1.0],
      iconOcclusionOpacityExpression: ['number', 1.0],
      iconOpacityExpression: ['number', 1.0],
      iconTranslateExpression: [
        'literal',
        [0.0, 1.0]
      ],
      iconTranslateAnchorExpression: ['string', 'map'],
      symbolElevationReferenceExpression: ['string', 'sea'],
      symbolZOffsetExpression: ['number', 1.0],
      textColorExpression: ['rgba', 255, 0, 0, 1],
      textEmissiveStrengthExpression: ['number', 1.0],
      textHaloBlurExpression: ['number', 1.0],
      textHaloColorExpression: ['rgba', 255, 0, 0, 1],
      textHaloWidthExpression: ['number', 1.0],
      textOcclusionOpacityExpression: ['number', 1.0],
      textOpacityExpression: ['number', 1.0],
      textTranslateExpression: [
        'literal',
        [0.0, 1.0]
      ],
      textTranslateAnchorExpression: ['string', 'map'],
    ));
    var layer = await mapboxMap.style.getLayer('layer') as SymbolLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.filter, [
      "==",
      ["get", "type"],
      "Feature"
    ]);
    expect(layer.iconAllowOverlap, true);
    expect(layer.iconAnchor, IconAnchor.CENTER);
    expect(layer.iconIgnorePlacement, true);
    expect(layer.iconImageExpression, ['image', "abc"]);
    expect(layer.iconKeepUpright, true);
    expect(layer.iconOffset, [0.0, 1.0]);
    expect(layer.iconOptional, true);
    expect(layer.iconPadding, 1.0);
    expect(layer.iconPitchAlignment, IconPitchAlignment.MAP);
    expect(layer.iconRotate, 1.0);
    expect(layer.iconRotationAlignment, IconRotationAlignment.MAP);
    expect(layer.iconSize, 1.0);
    expect(layer.iconTextFit, IconTextFit.NONE);
    expect(layer.iconTextFitPadding, [0.0, 1.0, 2.0, 3.0]);
    expect(layer.symbolAvoidEdges, true);
    expect(layer.symbolPlacement, SymbolPlacement.POINT);
    expect(layer.symbolSortKey, 1.0);
    expect(layer.symbolSpacing, 1.0);
    expect(layer.symbolZElevate, true);
    expect(layer.symbolZOrder, SymbolZOrder.AUTO);
    expect(layer.textAllowOverlap, true);
    expect(layer.textAnchor, TextAnchor.CENTER);
    expect(layer.textFieldExpression, ['format', "abc", {}]);
    expect(layer.textFont, ["a", "b", "c"]);
    expect(layer.textIgnorePlacement, true);
    expect(layer.textJustify, TextJustify.AUTO);
    expect(layer.textKeepUpright, true);
    expect(layer.textLetterSpacing, 1.0);
    expect(layer.textLineHeight, 1.0);
    expect(layer.textMaxAngle, 1.0);
    expect(layer.textMaxWidth, 1.0);
    expect(layer.textOffset, [0.0, 1.0]);
    expect(layer.textOptional, true);
    expect(layer.textPadding, 1.0);
    expect(layer.textPitchAlignment, TextPitchAlignment.MAP);
    expect(layer.textRadialOffset, 1.0);
    expect(layer.textRotate, 1.0);
    expect(layer.textRotationAlignment, TextRotationAlignment.MAP);
    expect(layer.textSize, 1.0);
    expect(layer.textTransform, TextTransform.NONE);
    expect(layer.textVariableAnchor, ["center", "left"]);
    expect(layer.textWritingMode, ["horizontal", "vertical"]);
    expect(layer.iconColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.iconColorSaturation, 1.0);
    expect(layer.iconEmissiveStrength, 1.0);
    expect(layer.iconHaloBlur, 1.0);
    expect(layer.iconHaloColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.iconHaloWidth, 1.0);
    expect(layer.iconImageCrossFade, 1.0);
    expect(layer.iconOcclusionOpacity, 1.0);
    expect(layer.iconOpacity, 1.0);
    expect(layer.iconTranslate, [0.0, 1.0]);
    expect(layer.iconTranslateAnchor, IconTranslateAnchor.MAP);
    expect(layer.symbolElevationReference, SymbolElevationReference.SEA);
    expect(layer.symbolZOffset, 1.0);
    expect(layer.textColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.textEmissiveStrength, 1.0);
    expect(layer.textHaloBlur, 1.0);
    expect(layer.textHaloColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.textHaloWidth, 1.0);
    expect(layer.textOcclusionOpacity, 1.0);
    expect(layer.textOpacity, 1.0);
    expect(layer.textTranslate, [0.0, 1.0]);
    expect(layer.textTranslateAnchor, TextTranslateAnchor.MAP);
  });
}
// End of generated file.
