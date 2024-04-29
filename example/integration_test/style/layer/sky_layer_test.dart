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

  testWidgets('Add SkyLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(SkyLayer(
      id: 'layer',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      skyAtmosphereColor: Colors.red.value,
      skyAtmosphereHaloColor: Colors.red.value,
      skyAtmosphereSun: [0.0, 1.0],
      skyAtmosphereSunIntensity: 1.0,
      skyGradient: Colors.red.value,
      skyGradientCenter: [0.0, 1.0],
      skyGradientRadius: 1.0,
      skyOpacity: 1.0,
      skyType: SkyType.GRADIENT,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as SkyLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.skyAtmosphereColor, Colors.red.value);
    expect(layer.skyAtmosphereHaloColor, Colors.red.value);
    expect(layer.skyAtmosphereSun, [0.0, 1.0]);
    expect(layer.skyAtmosphereSunIntensity, 1.0);
    expect(layer.skyGradient, Colors.red.value);
    expect(layer.skyGradientCenter, [0.0, 1.0]);
    expect(layer.skyGradientRadius, 1.0);
    expect(layer.skyOpacity, 1.0);
    expect(layer.skyType, SkyType.GRADIENT);
  });
}
// End of generated file.
