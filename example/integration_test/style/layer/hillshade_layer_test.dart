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

  testWidgets('Add HillshadeLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await addDelay(1000);

    await mapboxMap.style.addSource(RasterDemSource(
        id: "source", url: "mapbox://mapbox.mapbox-terrain-dem-v1"));

    await mapboxMap.style.addLayer(HillshadeLayer(
      id: 'layer',
      sourceId: 'source',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      hillshadeAccentColor: Colors.red.value,
      hillshadeExaggeration: 1.0,
      hillshadeHighlightColor: Colors.red.value,
      hillshadeIlluminationAnchor: HillshadeIlluminationAnchor.MAP,
      hillshadeIlluminationDirection: 1.0,
      hillshadeShadowColor: Colors.red.value,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as HillshadeLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.hillshadeAccentColor, Colors.red.value);
    expect(layer.hillshadeExaggeration, 1.0);
    expect(layer.hillshadeHighlightColor, Colors.red.value);
    expect(layer.hillshadeIlluminationAnchor, HillshadeIlluminationAnchor.MAP);
    expect(layer.hillshadeIlluminationDirection, 1.0);
    expect(layer.hillshadeShadowColor, Colors.red.value);
  });
}
// End of generated file.
