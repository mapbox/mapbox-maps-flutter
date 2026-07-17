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
// packages/mapbox_maps_flutter/test/annotation/circle_annotation_manager_events_test.dart
void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('CircleAnnotationManager custom id and position', skip: kIsWeb, (
    $,
  ) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    final dummyLayer = CircleLayer(id: "dummyLayer", sourceId: 'sourceId');
    await mapboxMap.style.addLayer(dummyLayer);
    final id = "CircleAnnotationManagerId";
    final manager = await mapboxMap.annotations.createCircleAnnotationManager(
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

  patrolTest('create CircleAnnotation_manager ', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();

    await manager.setCircleElevationReference(CircleElevationReference.NONE);
    var circleElevationReference = await manager.getCircleElevationReference();
    expect(CircleElevationReference.NONE, circleElevationReference);

    await manager.setCircleSortKey(1.0);
    var circleSortKey = await manager.getCircleSortKey();
    expect(1.0, circleSortKey);

    await manager.setCircleBlur(1.0);
    var circleBlur = await manager.getCircleBlur();
    expect(1.0, circleBlur);

    await manager.setCircleColor(Colors.red.value);
    var circleColor = await manager.getCircleColor();
    expect(Colors.red.value, circleColor);

    await manager.setCircleEmissiveStrength(1.0);
    var circleEmissiveStrength = await manager.getCircleEmissiveStrength();
    expect(1.0, circleEmissiveStrength);

    await manager.setCircleOpacity(1.0);
    var circleOpacity = await manager.getCircleOpacity();
    expect(1.0, circleOpacity);

    await manager.setCirclePitchAlignment(CirclePitchAlignment.MAP);
    var circlePitchAlignment = await manager.getCirclePitchAlignment();
    expect(CirclePitchAlignment.MAP, circlePitchAlignment);

    await manager.setCirclePitchScale(CirclePitchScale.MAP);
    var circlePitchScale = await manager.getCirclePitchScale();
    expect(CirclePitchScale.MAP, circlePitchScale);

    await manager.setCircleRadius(1.0);
    var circleRadius = await manager.getCircleRadius();
    expect(1.0, circleRadius);

    await manager.setCircleStrokeColor(Colors.red.value);
    var circleStrokeColor = await manager.getCircleStrokeColor();
    expect(Colors.red.value, circleStrokeColor);

    await manager.setCircleStrokeOpacity(1.0);
    var circleStrokeOpacity = await manager.getCircleStrokeOpacity();
    expect(1.0, circleStrokeOpacity);

    await manager.setCircleStrokeWidth(1.0);
    var circleStrokeWidth = await manager.getCircleStrokeWidth();
    expect(1.0, circleStrokeWidth);

    await manager.setCircleTranslate([0.0, 1.0]);
    var circleTranslate = await manager.getCircleTranslate();
    expect([0.0, 1.0], circleTranslate);

    await manager.setCircleTranslateAnchor(CircleTranslateAnchor.MAP);
    var circleTranslateAnchor = await manager.getCircleTranslateAnchor();
    expect(CircleTranslateAnchor.MAP, circleTranslateAnchor);
  });
}

// End of generated file.
