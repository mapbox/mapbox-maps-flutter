import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Attribution settings', skip: kIsWeb, (
    WidgetTester tester,
  ) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final attribution = mapboxMap.attribution;
    var settings = AttributionSettings(
      enabled: false,
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
    expect(updatedSettings.enabled, isFalse);
    expect(updatedSettings.position, OrnamentPosition.TOP_RIGHT);
    expect(updatedSettings.iconColor, Colors.blue.value);

    expect(
      updatedSettings.marginLeft,
      1,
      reason:
          'marginLeft should be preserved even though it is not active in TOP_RIGHT',
    );
    expect(
      updatedSettings.marginBottom,
      4,
      reason:
          'marginBottom should be preserved even though it is not active in TOP_RIGHT',
    );
    expect(
      updatedSettings.marginTop,
      2,
      reason: 'marginTop should be preserved as it is active in TOP_RIGHT',
    );
    expect(
      updatedSettings.marginRight,
      3,
      reason: 'marginRight should be preserved as it is active in TOP_RIGHT',
    );

    if (Platform.isAndroid) {
      expect(updatedSettings.clickable, true);
    }
  });

  testWidgets('margins are independently tracked across position changes',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final attribution = mapboxMap.attribution;

    await attribution.updateSettings(AttributionSettings(
      position: OrnamentPosition.BOTTOM_LEFT,
      marginLeft: 10,
      marginRight: 20,
      marginTop: 30,
      marginBottom: 40,
    ));

    await attribution.updateSettings(
        AttributionSettings(position: OrnamentPosition.TOP_RIGHT));

    final settings = await attribution.getSettings();
    expect(settings.marginRight, 20);
    expect(settings.marginTop, 30);
    expect(
      settings.marginLeft,
      10,
      reason:
          'marginLeft should be preserved even though it is not active in TOP_RIGHT',
    );
    expect(
      settings.marginBottom,
      40,
      reason:
          'marginBottom should be preserved even though it is not active in TOP_RIGHT',
    );
  });

  testWidgets('enabled, position and margins are preserved by an empty update',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final attribution = mapboxMap.attribution;

    final baseline = AttributionSettings(
      enabled: false,
      position: OrnamentPosition.TOP_LEFT,
      marginLeft: 11,
      marginTop: 22,
    );
    await attribution.updateSettings(baseline);
    var updatedSettings = await attribution.getSettings();
    expect(updatedSettings.enabled, baseline.enabled);
    expect(updatedSettings.position, baseline.position);

    await attribution.updateSettings(AttributionSettings());
    updatedSettings = await attribution.getSettings();
    expect(updatedSettings.enabled, baseline.enabled);
    expect(updatedSettings.position, baseline.position);
    expect(updatedSettings.marginLeft, baseline.marginLeft);
    expect(updatedSettings.marginTop, baseline.marginTop);
  });

  testWidgets(
      'enabled, position and margins are preserved by a partial update that changes an unrelated field',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final attribution = mapboxMap.attribution;

    final baseline = AttributionSettings(
      enabled: false,
      position: OrnamentPosition.TOP_LEFT,
      marginLeft: 11,
      marginTop: 22,
    );
    await attribution.updateSettings(baseline);

    final partialUpdate = AttributionSettings(
      iconColor: Colors.green.value,
    );
    await attribution.updateSettings(partialUpdate);
    final updatedSettings = await attribution.getSettings();
    expect(updatedSettings.iconColor, partialUpdate.iconColor);
    expect(updatedSettings.enabled, baseline.enabled);
    expect(updatedSettings.position, baseline.position);
    expect(updatedSettings.marginLeft, baseline.marginLeft);
    expect(updatedSettings.marginTop, baseline.marginTop);
  });
}
