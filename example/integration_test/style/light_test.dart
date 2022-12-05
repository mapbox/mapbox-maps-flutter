import 'dart:io';

import 'package:flutter/material.dart' hide Visibility;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> addDelay(int ms) async {
    await Future<void>.delayed(Duration(milliseconds: ms));
  }

  testWidgets('Add Style Light', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await addDelay(1000);

    await mapboxMap.style.setLight(Light(
      anchor: Anchor.MAP,
      color: Colors.red.value,
      intensity: 1.0,
      position: [1.0, 2.0, 3.0],
    ));

    var anchor = await mapboxMap.style.getStyleLightProperty("anchor");
    expect(anchor.value, "map");
    var color = await mapboxMap.style.getStyleLightProperty("color");
    if (Platform.isIOS) {
      expect(
          color.value,
          '(\n'
          '    rgba,\n'
          '    "244.0000152587891",\n'
          '    67,\n'
          '    "54.00000381469727",\n'
          '    1\n'
          ')');
    } else {
      expect(color.value,
          '[rgba, 244.00001525878906, 67.0, 54.000003814697266, 1.0]');
    }
    var intensity = await mapboxMap.style.getStyleLightProperty("intensity");
    if (Platform.isIOS) {
      expect(intensity.value, '1');
    } else {
      expect(intensity.value, '1.0');
    }
    var position = await mapboxMap.style.getStyleLightProperty("position");
    if (Platform.isIOS) {
      expect(
          position.value,
          '(\n'
          '    1,\n'
          '    2,\n'
          '    3\n'
          ')');
    } else {
      expect(position.value, '[1.0, 2.0, 3.0]');
    }
  });
}
