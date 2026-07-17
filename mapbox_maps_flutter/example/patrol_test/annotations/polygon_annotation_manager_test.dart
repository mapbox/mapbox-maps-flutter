// This file is generated.
// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../patrol.dart';

import '../empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

// Note: the tap / long press / drag event tests for this manager run against a
// fake platform interface (no real map), so they are plain `flutter test` unit
// tests, not part of this on-device / web integration suite. See
// packages/mapbox_maps_flutter/test/annotation/polygon_annotation_manager_events_test.dart
void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('PolygonAnnotationManager custom id and position', skip: kIsWeb, (
    $,
  ) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    final dummyLayer = FillLayer(id: "dummyLayer", sourceId: 'sourceId');
    await mapboxMap.style.addLayer(dummyLayer);
    final id = "PolygonAnnotationManagerId";
    final manager = await mapboxMap.annotations.createPolygonAnnotationManager(
      id: id,
      below: 'dummyLayer',
    );

    expect(await mapboxMap.style.styleLayerExists(id), isTrue);
    expect(await mapboxMap.style.styleSourceExists(id), isTrue);
    expect(manager.id, id);
    final layers = await mapboxMap.style.getStyleLayers();
    expect(layers.first?.id, id);
    expect(layers.last?.id, dummyLayer.id);
  });

  patrolTest('create PolygonAnnotation_manager ', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    final manager = await mapboxMap.annotations
        .createPolygonAnnotationManager();

    await manager.setFillConstructBridgeGuardRail(true);
    var fillConstructBridgeGuardRail = await manager
        .getFillConstructBridgeGuardRail();
    expect(true, fillConstructBridgeGuardRail);

    await manager.setFillElevationReference(FillElevationReference.NONE);
    var fillElevationReference = await manager.getFillElevationReference();
    expect(FillElevationReference.NONE, fillElevationReference);

    await manager.setFillSortKey(1.0);
    var fillSortKey = await manager.getFillSortKey();
    expect(1.0, fillSortKey);

    await manager.setFillAntialias(true);
    var fillAntialias = await manager.getFillAntialias();
    expect(true, fillAntialias);

    await manager.setFillBridgeGuardRailColor(Colors.red.value);
    var fillBridgeGuardRailColor = await manager.getFillBridgeGuardRailColor();
    expect(Colors.red.value, fillBridgeGuardRailColor);

    await manager.setFillColor(Colors.red.value);
    var fillColor = await manager.getFillColor();
    expect(Colors.red.value, fillColor);

    await manager.setFillEmissiveStrength(1.0);
    var fillEmissiveStrength = await manager.getFillEmissiveStrength();
    expect(1.0, fillEmissiveStrength);

    await manager.setFillOpacity(1.0);
    var fillOpacity = await manager.getFillOpacity();
    expect(1.0, fillOpacity);

    await manager.setFillOutlineColor(Colors.red.value);
    var fillOutlineColor = await manager.getFillOutlineColor();
    expect(Colors.red.value, fillOutlineColor);

    await manager.setFillPattern("abc");
    var fillPattern = await manager.getFillPattern();
    expect("abc", fillPattern);

    await manager.setFillTranslate([0.0, 1.0]);
    var fillTranslate = await manager.getFillTranslate();
    expect([0.0, 1.0], fillTranslate);

    await manager.setFillTranslateAnchor(FillTranslateAnchor.MAP);
    var fillTranslateAnchor = await manager.getFillTranslateAnchor();
    expect(FillTranslateAnchor.MAP, fillTranslateAnchor);

    await manager.setFillTunnelStructureColor(Colors.red.value);
    var fillTunnelStructureColor = await manager.getFillTunnelStructureColor();
    expect(Colors.red.value, fillTunnelStructureColor);

    await manager.setFillZOffset(1.0);
    var fillZOffset = await manager.getFillZOffset();
    expect(1.0, fillZOffset);
  });
}

// End of generated file.
