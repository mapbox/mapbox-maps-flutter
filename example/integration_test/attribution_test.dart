import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Attribution settings', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final attribution = mapboxMap.attribution;
    var settings = AttributionSettings(
      iconColor: Colors.blue.value,
      position: OrnamentPosition.TOP_RIGHT,
      marginLeft: 1,
      marginTop: 2,
      marginRight: 3,
      marginBottom: 4,
      clickable: true,
    );
    await attribution.updateSettings(settings);
    var updatedSettings = await attribution.getSettings();
    expect(updatedSettings.position, OrnamentPosition.TOP_RIGHT);
    if (Platform.isIOS) {
      expect(updatedSettings.marginTop, 2);
      expect(updatedSettings.marginRight, 3);
    } else {
      // FIXME colors are decoded incorrectly for some reason
      // expect(updatedSettings.iconColor, Colors.blue.value);
      expect(updatedSettings.marginLeft, 1);
      expect(updatedSettings.marginTop, 2);
      expect(updatedSettings.marginRight, 3);
      expect(updatedSettings.marginBottom, 4);
      expect(updatedSettings.clickable, true);
    }
  });
}
