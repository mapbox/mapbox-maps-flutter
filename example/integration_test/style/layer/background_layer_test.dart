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

  testWidgets('Add BackgroundLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(BackgroundLayer(
      id: 'layer',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      backgroundColor: Colors.red.value,
      backgroundEmissiveStrength: 1.0,
      backgroundOpacity: 1.0,
      backgroundPattern: "abc",
    ));
    var layer = await mapboxMap.style.getLayer('layer') as BackgroundLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.backgroundColor, Colors.red.value);
    expect(layer.backgroundEmissiveStrength, 1.0);
    expect(layer.backgroundOpacity, 1.0);
    expect(layer.backgroundPattern, "abc");
  });
}
// End of generated file.
