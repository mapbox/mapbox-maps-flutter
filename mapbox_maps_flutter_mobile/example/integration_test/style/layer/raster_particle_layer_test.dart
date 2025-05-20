// This file is generated.
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add RasterParticleLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(RasterParticleLayer(
      id: 'layer',
      sourceId: 'source',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      rasterParticleArrayBand: "abc",
      rasterParticleColor: Colors.red.value,
      rasterParticleCount: 1.0,
      rasterParticleFadeOpacityFactor: 1.0,
      rasterParticleMaxSpeed: 1.0,
      rasterParticleResetRateFactor: 1.0,
      rasterParticleSpeedFactor: 1.0,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as RasterParticleLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.rasterParticleArrayBand, "abc");
    expect(layer.rasterParticleColor, Colors.red.value);
    expect(layer.rasterParticleCount, 1.0);
    expect(layer.rasterParticleFadeOpacityFactor, 1.0);
    expect(layer.rasterParticleMaxSpeed, 1.0);
    expect(layer.rasterParticleResetRateFactor, 1.0);
    expect(layer.rasterParticleSpeedFactor, 1.0);
  });

  testWidgets('Add RasterParticleLayer with expressions',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(RasterParticleLayer(
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
      rasterParticleArrayBandExpression: ['string', "abc"],
      rasterParticleColorExpression: ['rgba', 255, 0, 0, 1],
      rasterParticleCountExpression: ['number', 1.0],
      rasterParticleFadeOpacityFactorExpression: ['number', 1.0],
      rasterParticleMaxSpeedExpression: ['number', 1.0],
      rasterParticleResetRateFactorExpression: ['number', 1.0],
      rasterParticleSpeedFactorExpression: ['number', 1.0],
    ));
    var layer = await mapboxMap.style.getLayer('layer') as RasterParticleLayer;
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
    expect(layer.rasterParticleArrayBand, "abc");
    expect(layer.rasterParticleColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.rasterParticleCount, 1.0);
    expect(layer.rasterParticleFadeOpacityFactor, 1.0);
    expect(layer.rasterParticleMaxSpeed, 1.0);
    expect(layer.rasterParticleResetRateFactor, 1.0);
    expect(layer.rasterParticleSpeedFactor, 1.0);
  });
}
// End of generated file.
