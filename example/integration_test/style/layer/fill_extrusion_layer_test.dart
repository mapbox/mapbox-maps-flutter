// This file is generated.
import 'dart:convert';
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;
import 'package:turf/helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> addDelay(int ms) async {
    await Future<void>.delayed(Duration(milliseconds: ms));
  }

  testWidgets('Add FillExtrusionLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await addDelay(1000);

    await mapboxMap.style.addLayer(FillExtrusionLayer(
      id: 'layer',
      sourceId: "composite",
      sourceLayer: "building",
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      fillExtrusionBase: 1.0,
      fillExtrusionColor: Colors.red.value,
      fillExtrusionHeight: 1.0,
      fillExtrusionOpacity: 1.0,
      fillExtrusionPattern: "abc",
      fillExtrusionTranslate: [0.0, 1.0],
      fillExtrusionTranslateAnchor: FillExtrusionTranslateAnchor.MAP,
      fillExtrusionVerticalGradient: true,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as FillExtrusionLayer;
    expect('composite', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.fillExtrusionBase, 1.0);
    expect(layer.fillExtrusionColor, Colors.red.value);
    expect(layer.fillExtrusionHeight, 1.0);
    expect(layer.fillExtrusionOpacity, 1.0);
    expect(layer.fillExtrusionPattern, "abc");
    expect(layer.fillExtrusionTranslate, [0.0, 1.0]);
    expect(
        layer.fillExtrusionTranslateAnchor, FillExtrusionTranslateAnchor.MAP);
    expect(layer.fillExtrusionVerticalGradient, true);
  });
}
// End of generated file.
