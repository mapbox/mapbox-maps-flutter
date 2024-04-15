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

  testWidgets('Add LineLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    var line =
        LineString(coordinates: [Position(1.0, 2.0), Position(10.0, 20.0)]);
    await mapboxMap.style
        .addSource(GeoJsonSource(id: "source", data: json.encode(line)));

    await mapboxMap.style.addLayer(LineLayer(
      id: 'layer',
      sourceId: 'source',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      lineCap: LineCap.BUTT,
      lineJoin: LineJoin.BEVEL,
      lineMiterLimit: 1.0,
      lineRoundLimit: 1.0,
      lineSortKey: 1.0,
      lineBlur: 1.0,
      lineBorderColor: Colors.red.value,
      lineBorderWidth: 1.0,
      lineColor: Colors.red.value,
      lineDasharray: [1.0, 2.0],
      lineDepthOcclusionFactor: 1.0,
      lineEmissiveStrength: 1.0,
      lineGapWidth: 1.0,
      lineGradient: Colors.red.value,
      lineOffset: 1.0,
      lineOpacity: 1.0,
      linePattern: "abc",
      lineTranslate: [0.0, 1.0],
      lineTranslateAnchor: LineTranslateAnchor.MAP,
      lineTrimOffset: [0.0, 1.0],
      lineWidth: 1.0,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as LineLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.lineCap, LineCap.BUTT);
    expect(layer.lineJoin, LineJoin.BEVEL);
    expect(layer.lineMiterLimit, 1.0);
    expect(layer.lineRoundLimit, 1.0);
    expect(layer.lineSortKey, 1.0);
    expect(layer.lineBlur, 1.0);
    expect(layer.lineBorderColor, Colors.red.value);
    expect(layer.lineBorderWidth, 1.0);
    expect(layer.lineColor, Colors.red.value);
    expect(layer.lineDasharray, [1.0, 2.0]);
    expect(layer.lineDepthOcclusionFactor, 1.0);
    expect(layer.lineEmissiveStrength, 1.0);
    expect(layer.lineGapWidth, 1.0);
    expect(layer.lineGradient, Colors.red.value);
    expect(layer.lineOffset, 1.0);
    expect(layer.lineOpacity, 1.0);
    expect(layer.linePattern, "abc");
    expect(layer.lineTranslate, [0.0, 1.0]);
    expect(layer.lineTranslateAnchor, LineTranslateAnchor.MAP);
    expect(layer.lineTrimOffset, [0.0, 1.0]);
    expect(layer.lineWidth, 1.0);
  });
}
// End of generated file.
