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

  testWidgets('Add CircleLayer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await addDelay(1000);

    final point = Point(coordinates: Position(-77.032667, 38.913175));
    await mapboxMap.style
        .addSource(GeoJsonSource(id: "source", data: json.encode(point)));

    await mapboxMap.style.addLayer(CircleLayer(
      id: 'layer',
      sourceId: 'source',
      visibility: Visibility.NONE,
      minZoom: 1.0,
      maxZoom: 20.0,
      circleSortKey: 1.0,
      circleBlur: 1.0,
      circleColor: Colors.red.value,
      circleOpacity: 1.0,
      circlePitchAlignment: CirclePitchAlignment.MAP,
      circlePitchScale: CirclePitchScale.MAP,
      circleRadius: 1.0,
      circleStrokeColor: Colors.red.value,
      circleStrokeOpacity: 1.0,
      circleStrokeWidth: 1.0,
      circleTranslate: [0.0, 1.0],
      circleTranslateAnchor: CircleTranslateAnchor.MAP,
    ));
    var layer = await mapboxMap.style.getLayer('layer') as CircleLayer;
    expect('source', layer.sourceId);
    expect(layer.minZoom, 1);
    expect(layer.maxZoom, 20);
    expect(layer.visibility, Visibility.NONE);
    expect(layer.circleSortKey, 1.0);
    expect(layer.circleBlur, 1.0);
    expect(layer.circleColor, Colors.red.value);
    expect(layer.circleOpacity, 1.0);
    expect(layer.circlePitchAlignment, CirclePitchAlignment.MAP);
    expect(layer.circlePitchScale, CirclePitchScale.MAP);
    expect(layer.circleRadius, 1.0);
    expect(layer.circleStrokeColor, Colors.red.value);
    expect(layer.circleStrokeOpacity, 1.0);
    expect(layer.circleStrokeWidth, 1.0);
    expect(layer.circleTranslate, [0.0, 1.0]);
    expect(layer.circleTranslateAnchor, CircleTranslateAnchor.MAP);
  });
}
// End of generated file.
