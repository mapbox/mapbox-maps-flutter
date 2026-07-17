// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';
import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('ScaleBar settings', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
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
      distanceUnits: DistanceUnits.NAUTICAL,
      refreshInterval: 10,
      showTextBorder: true,
      ratio: 1.5,
      useContinuousRendering: true,
    );
    await scaleBar.updateSettings(settings);
    var updatedSettings = await scaleBar.getSettings();
    expect(updatedSettings.position, OrnamentPosition.BOTTOM_RIGHT);
    expect(updatedSettings.distanceUnits, DistanceUnits.NAUTICAL);

    expect(updatedSettings.marginLeft, 1);
    expect(updatedSettings.marginTop, 2);
    expect(updatedSettings.marginRight, 3);
    expect(updatedSettings.marginBottom, 4);
    if (Platform.isAndroid) {
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

  patrolTest(
    'margins are independently tracked across position changes',
    skip: kIsWeb,
    ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      final scaleBar = mapboxMap.scaleBar;

      await scaleBar.updateSettings(
        ScaleBarSettings(
          position: OrnamentPosition.BOTTOM_LEFT,
          marginLeft: 10,
          marginRight: 20,
          marginTop: 30,
          marginBottom: 40,
        ),
      );

      await scaleBar.updateSettings(
        ScaleBarSettings(position: OrnamentPosition.TOP_RIGHT),
      );

      final settings = await scaleBar.getSettings();
      expect(
        settings.marginRight,
        20,
        reason:
            'marginRight should be preserved since it is active in TOP_RIGHT',
      );
      expect(
        settings.marginTop,
        30,
        reason: 'marginTop should be preserved since it is active in TOP_RIGHT',
      );
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
    },
  );

  patrolTest(
    'position and margins are preserved by an empty update',
    skip: kIsWeb,
    ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      final scaleBar = mapboxMap.scaleBar;

      final baseline = ScaleBarSettings(
        position: OrnamentPosition.BOTTOM_RIGHT,
        marginRight: 11,
        marginBottom: 22,
      );
      await scaleBar.updateSettings(baseline);
      expect((await scaleBar.getSettings()).position, baseline.position);

      await scaleBar.updateSettings(ScaleBarSettings());
      final updatedSettings = await scaleBar.getSettings();
      expect(updatedSettings.position, baseline.position);
      expect(updatedSettings.marginRight, baseline.marginRight);
      expect(updatedSettings.marginBottom, baseline.marginBottom);
    },
  );

  patrolTest(
    'position and margins are preserved by a partial update that changes an unrelated field',
    skip: kIsWeb,
    ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      final scaleBar = mapboxMap.scaleBar;

      final baseline = ScaleBarSettings(
        position: OrnamentPosition.BOTTOM_RIGHT,
        marginRight: 11,
        marginBottom: 22,
        isMetricUnits: false,
      );
      await scaleBar.updateSettings(baseline);

      final partialUpdate = ScaleBarSettings(isMetricUnits: true);
      await scaleBar.updateSettings(partialUpdate);
      final updatedSettings = await scaleBar.getSettings();
      expect(updatedSettings.isMetricUnits, partialUpdate.isMetricUnits);
      expect(updatedSettings.position, baseline.position);
      expect(updatedSettings.marginRight, baseline.marginRight);
      expect(updatedSettings.marginBottom, baseline.marginBottom);
    },
  );
}
