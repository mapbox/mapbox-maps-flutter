// This file is generated.
// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../patrol.dart';

import '../../empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  // These generated addLayer/getLayer tests run on web too. Only a limited
  // set of known Mapbox GL JS parity gaps are gated: some properties are
  // excluded from round-trip assertions, and a few unsupported layer types
  // may still be skipped separately by the template.
  patrolTest('Add SlotLayer', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    await mapboxMap.style.addLayer(
      SlotLayer(
        id: 'layer',
        visibility: Visibility.NONE,
        minZoom: 1.0,
        maxZoom: 20.0,
        slot: LayerSlot.BOTTOM,
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as SlotLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
  });

  patrolTest('Add SlotLayer with expressions', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    await mapboxMap.style.addLayer(
      SlotLayer(
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
      ),
    );
    var layer = await mapboxMap.style.getLayer('layer') as SlotLayer;
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.slot, LayerSlot.BOTTOM);
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
  });
}

// End of generated file.
