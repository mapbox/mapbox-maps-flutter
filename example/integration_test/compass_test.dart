import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Compass settings', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final compass = mapboxMap.compass;
    final ByteData bytes =
        await rootBundle.load('assets/symbols/custom-icon.png');
    final Uint8List iconData = bytes.buffer.asUint8List();
    var settings = CompassSettings(
      enabled: true,
      position: OrnamentPosition.TOP_LEFT,
      marginLeft: 1,
      marginTop: 2,
      marginRight: 3,
      marginBottom: 4,
      opacity: 0.5,
      rotation: 10,
      visibility: true,
      fadeWhenFacingNorth: true,
      clickable: true,
      image: iconData,
    );
    await compass.updateSettings(settings);
    var updatedSettings = await compass.getSettings();
    expect(updatedSettings.position, OrnamentPosition.TOP_LEFT);
    expect(updatedSettings.fadeWhenFacingNorth, true);
    expect(updatedSettings.visibility, true);
    if (Platform.isIOS) {
      expect(updatedSettings.marginLeft, 1);
      expect(updatedSettings.marginTop, 2);
    } else {
      expect(updatedSettings.enabled, true);
      expect(updatedSettings.marginLeft, 1);
      expect(updatedSettings.marginTop, 2);
      expect(updatedSettings.marginRight, 3);
      expect(updatedSettings.marginBottom, 4);
      expect(updatedSettings.clickable, true);
      expect(updatedSettings.opacity, 0.5);
      expect(updatedSettings.rotation, 10);
      expect(updatedSettings.clickable, true);
      // FIXME failing test
      // expect(updatedSettings.image, iconData);
    }
  });
}
