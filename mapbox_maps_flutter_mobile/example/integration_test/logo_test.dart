import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Logo settings', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final logo = mapboxMap.logo;
    var settings = LogoSettings(
        enabled: false,
        position: OrnamentPosition.BOTTOM_LEFT,
        marginLeft: 1,
        marginTop: 2,
        marginRight: 3,
        marginBottom: 4);
    await logo.updateSettings(settings);
    var getSettings = await logo.getSettings();
    expect(getSettings.position, OrnamentPosition.BOTTOM_LEFT);
    expect(getSettings.enabled, isFalse);
    if (Platform.isIOS) {
      expect(getSettings.marginLeft, 1);
      expect(getSettings.marginBottom, 4);
    } else {
      expect(getSettings.marginLeft, 1);
      expect(getSettings.marginTop, 2);
      expect(getSettings.marginRight, 3);
      expect(getSettings.marginBottom, 4);
    }
  });
}
