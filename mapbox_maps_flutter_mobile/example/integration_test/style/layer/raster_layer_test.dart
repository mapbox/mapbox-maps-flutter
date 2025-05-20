// This file is generated.
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add RasterLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style
        .addSource(RasterSource(id: "source", tileSize: 256, tiles: [
      "https://img.nj.gov/imagerywms/Natural2015?bbox={bbox-epsg-3857}" +
          "&format=image/png&service=WMS&version=1.1.1&request=GetMap&srs=EPSG:3857" +
          "&transparent=true&width=256&height=256&layers=Natural2015"
    ]));

    await mapboxMap.style.addLayer(RasterLayer(
      id: 'layer',
      sourceId: 'source',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      slot: LayerSlot.BOTTOM,
      rasterArrayBand: "abc",
      rasterBrightnessMax: 1.0,
      rasterBrightnessMin: 1.0,
      rasterColor: Colors.red.value,
      rasterColorMix: [0.0, 1.0, 2.0, 3.0],
      rasterColorRange: [0.0, 1.0],
      rasterContrast: 1.0,
      rasterElevation: 1.0,
      rasterEmissiveStrength: 1.0,
      rasterFadeDuration: 1.0,
      rasterHueRotate: 1.0,
      rasterOpacity: 1.0,
      rasterResampling: RasterResampling.LINEAR,
      rasterSaturation: 1.0,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as RasterLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.rasterArrayBand, "abc");
    expect(layer.rasterBrightnessMax, 1.0);
    expect(layer.rasterBrightnessMin, 1.0);
    expect(layer.rasterColor, Colors.red.value);
    expect(layer.rasterColorMix, [0.0, 1.0, 2.0, 3.0]);
    expect(layer.rasterColorRange, [0.0, 1.0]);
    expect(layer.rasterContrast, 1.0);
    expect(layer.rasterElevation, 1.0);
    expect(layer.rasterEmissiveStrength, 1.0);
    expect(layer.rasterFadeDuration, 1.0);
    expect(layer.rasterHueRotate, 1.0);
    expect(layer.rasterOpacity, 1.0);
    expect(layer.rasterResampling, RasterResampling.LINEAR);
    expect(layer.rasterSaturation, 1.0);
  });

  testWidgets('Add RasterLayer with expressions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style
        .addSource(RasterSource(id: "source", tileSize: 256, tiles: [
      "https://img.nj.gov/imagerywms/Natural2015?bbox={bbox-epsg-3857}" +
          "&format=image/png&service=WMS&version=1.1.1&request=GetMap&srs=EPSG:3857" +
          "&transparent=true&width=256&height=256&layers=Natural2015"
    ]));

    await mapboxMap.style.addLayer(RasterLayer(
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
      rasterArrayBandExpression: ['string', "abc"],
      rasterBrightnessMaxExpression: ['number', 1.0],
      rasterBrightnessMinExpression: ['number', 1.0],
      rasterColorExpression: ['rgba', 255, 0, 0, 1],
      rasterColorMixExpression: [
        'literal',
        [0.0, 1.0, 2.0, 3.0]
      ],
      rasterColorRangeExpression: [
        'literal',
        [0.0, 1.0]
      ],
      rasterContrastExpression: ['number', 1.0],
      rasterElevationExpression: ['number', 1.0],
      rasterEmissiveStrengthExpression: ['number', 1.0],
      rasterFadeDurationExpression: ['number', 1.0],
      rasterHueRotateExpression: ['number', 1.0],
      rasterOpacityExpression: ['number', 1.0],
      rasterResamplingExpression: ['string', 'linear'],
      rasterSaturationExpression: ['number', 1.0],
    ));
    var layer = await mapboxMap.style.getLayer('layer') as RasterLayer;
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
    expect(layer.rasterArrayBand, "abc");
    expect(layer.rasterBrightnessMax, 1.0);
    expect(layer.rasterBrightnessMin, 1.0);
    expect(layer.rasterColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.rasterColorMix, [0.0, 1.0, 2.0, 3.0]);
    expect(layer.rasterColorRange, [0.0, 1.0]);
    expect(layer.rasterContrast, 1.0);
    expect(layer.rasterElevation, 1.0);
    expect(layer.rasterEmissiveStrength, 1.0);
    expect(layer.rasterFadeDuration, 1.0);
    expect(layer.rasterHueRotate, 1.0);
    expect(layer.rasterOpacity, 1.0);
    expect(layer.rasterResampling, RasterResampling.LINEAR);
    expect(layer.rasterSaturation, 1.0);
  });
}
// End of generated file.
