import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ScaleBar settings', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final scaleBar = mapboxMap.scaleBar;
    var settings = ScaleBarSettings(
      enabled: true,
      position: OrnamentPosition.BOTTOM_RIGHT,
      marginLeft: 1,
      marginTop: 2,
      marginRight: 3,
      marginBottom: 4,
      textColor: Colors.black.value,
      primaryColor: Colors.red.value,
      secondaryColor: Colors.blue.value,
      borderWidth: 2,
      height: 10,
      textBarMargin: 1,
      textBorderWidth: 2,
      textSize: 10,
      isMetricUnits: true,
      refreshInterval: 10,
      showTextBorder: true,
      ratio: 1.5,
      useContinuousRendering: true,
    );
    await scaleBar.updateSettings(settings);
    var updatedSettings = await scaleBar.getSettings();
    expect(updatedSettings.position, OrnamentPosition.BOTTOM_RIGHT);
    expect(updatedSettings.isMetricUnits, true);
    if (Platform.isIOS) {
      expect(updatedSettings.marginRight, 3);
      expect(updatedSettings.marginBottom, 4);
    } else {
      expect(updatedSettings.marginLeft, 1);
      expect(updatedSettings.marginTop, 2);
      expect(updatedSettings.marginRight, 3);
      expect(updatedSettings.marginBottom, 4);
      // iOS doesn't support these settings
      expect(updatedSettings.textColor, Colors.black.value);
      expect(updatedSettings.primaryColor, Colors.red.value);
      expect(updatedSettings.secondaryColor, Colors.blue.value);
      expect(updatedSettings.borderWidth, 2);
      expect(updatedSettings.height, 10);
      expect(updatedSettings.textBarMargin, 1);
      expect(updatedSettings.textBorderWidth, 2);
      expect(updatedSettings.textSize, 10);
      expect(updatedSettings.refreshInterval, 10);
      expect(updatedSettings.showTextBorder, true);
      expect(updatedSettings.ratio, 1.5);
      expect(updatedSettings.useContinuousRendering, true);
    }
  });
}
