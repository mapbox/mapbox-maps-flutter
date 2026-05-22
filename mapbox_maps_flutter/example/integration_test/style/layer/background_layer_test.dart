// This file is generated.
// ignore_for_file: experimental_member_use
import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // These generated addLayer/getLayer tests run on web too. Only a limited
  // set of known Mapbox GL JS parity gaps are gated: some properties are
  // excluded from round-trip assertions, and a few unsupported layer types
  // may still be skipped separately by the template.
  testWidgets('Add BackgroundLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(
      BackgroundLayer(
        id: 'layer',
        visibility: Visibility.NONE,
        minZoom: 1.0,
        maxZoom: 20.0,
        slot: LayerSlot.BOTTOM,
        backgroundColor: Colors.red.value,
        backgroundEmissiveStrength: 1.0,
        backgroundOpacity: 1.0,
        backgroundPattern: "abc",
        backgroundPitchAlignment: BackgroundPitchAlignment.MAP,
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as BackgroundLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.backgroundColor, Colors.red.value);
    expect(layer.backgroundEmissiveStrength, 1.0);
    expect(layer.backgroundOpacity, 1.0);
    expect(layer.backgroundPattern, "abc");
    expect(layer.backgroundPitchAlignment, BackgroundPitchAlignment.MAP);
  });

  testWidgets('Add BackgroundLayer with expressions', (
    WidgetTester tester,
  ) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.style.addLayer(
      BackgroundLayer(
        id: 'layer',
        visibilityExpression: ['string', 'none'],
        filter: [
          "==",
          ["get", "type"],
          "Feature",
        ],
        minZoom: 1.0,
        maxZoom: 20.0,
        slot: LayerSlot.BOTTOM,
        backgroundColorExpression: ['rgba', 255, 0, 0, 1],
        backgroundEmissiveStrengthExpression: ['number', 1.0],
        backgroundOpacityExpression: ['number', 1.0],
        backgroundPatternExpression: ['image', "abc"],
        backgroundPitchAlignmentExpression: ['string', 'map'],
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as BackgroundLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
    expect(layer.visibility, Visibility.NONE);
    // gl-js's base StyleLayer constructor skips `filter` for sourceless
    // layer types (background/sky/slot — style_layer.ts:127), so the
    // filter we set is dropped before serialize() and the readback is
    // null. gl-native preserves it; gate just this assertion on web.
    if (!kIsWeb) {
      expect(layer.filter, [
        "==",
        ["get", "type"],
        "Feature",
      ]);
    }
    expect(layer.backgroundColorExpression, ['rgba', 255, 0, 0, 1]);
    expect(layer.backgroundEmissiveStrength, 1.0);
    expect(layer.backgroundOpacity, 1.0);
    expect(layer.backgroundPatternExpression, ['image', "abc"]);
    expect(layer.backgroundPitchAlignment, BackgroundPitchAlignment.MAP);
  });
}

// End of generated file.
