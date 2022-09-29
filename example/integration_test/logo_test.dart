import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps/mapbox_maps.dart';
import 'package:mapbox_maps_example/empty_mapview.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Logo settings', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final logo = mapboxMap.logo;
    var setttings = LogoSettings(
        enabled: true,
        position: OrnamentPosition.BOTTOM_LEFT,
        marginLeft: 1,
        marginTop: 2,
        marginRight: 3,
        marginBottom: 4);
    await logo.updateSettings(setttings);
    var getSettings = await logo.getSettings();
    expect(getSettings.enabled, true);
    expect(getSettings.position, OrnamentPosition.BOTTOM_LEFT);
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
