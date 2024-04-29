// This file is generated.
import 'dart:convert';
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

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
      iconOpacity: 1.0,
      iconTranslate: [0.0, 1.0],
      iconTranslateAnchor: IconTranslateAnchor.MAP,
      textColor: Colors.red.value,
      textEmissiveStrength: 1.0,
      textHaloBlur: 1.0,
      textHaloColor: Colors.red.value,
      textHaloWidth: 1.0,
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
    expect(layer.iconOpacity, 1.0);
    expect(layer.iconTranslate, [0.0, 1.0]);
    expect(layer.iconTranslateAnchor, IconTranslateAnchor.MAP);
    expect(layer.textColor, Colors.red.value);
    expect(layer.textEmissiveStrength, 1.0);
    expect(layer.textHaloBlur, 1.0);
    expect(layer.textHaloColor, Colors.red.value);
    expect(layer.textHaloWidth, 1.0);
    expect(layer.textOpacity, 1.0);
    expect(layer.textTranslate, [0.0, 1.0]);
    expect(layer.textTranslateAnchor, TextTranslateAnchor.MAP);
  });
}
// End of generated file.
