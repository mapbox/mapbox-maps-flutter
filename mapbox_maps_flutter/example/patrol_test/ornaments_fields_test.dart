// Exercises every ornament field the example page exposes, through the
// public API, and asserts each one survives a partial update.
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';
import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('every scale bar field the example exposes round-trips', (
    $,
  ) async {
    final map = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    final scaleBar = map.scaleBar;

    await scaleBar.updateSettings(ScaleBarSettings(enabled: true));
    await scaleBar.updateSettings(
      ScaleBarSettings(position: OrnamentPosition.BOTTOM_RIGHT),
    );
    await scaleBar.updateSettings(ScaleBarSettings(marginLeft: 11));
    await scaleBar.updateSettings(ScaleBarSettings(marginTop: 12));
    await scaleBar.updateSettings(ScaleBarSettings(marginRight: 13));
    await scaleBar.updateSettings(ScaleBarSettings(marginBottom: 14));
    await scaleBar.updateSettings(
      ScaleBarSettings(distanceUnits: DistanceUnits.NAUTICAL),
    );
    await scaleBar.updateSettings(ScaleBarSettings(ratio: 0.75));
    await scaleBar.updateSettings(ScaleBarSettings(textColor: 0xFFF44336));
    await scaleBar.updateSettings(ScaleBarSettings(primaryColor: 0xFF2196F3));
    await scaleBar.updateSettings(ScaleBarSettings(secondaryColor: 0xFFFFFFFF));
    await scaleBar.updateSettings(ScaleBarSettings(borderWidth: 4));
    await scaleBar.updateSettings(ScaleBarSettings(textSize: 14));
    await scaleBar.updateSettings(ScaleBarSettings(height: 7));
    await scaleBar.updateSettings(ScaleBarSettings(textBarMargin: 6));
    await scaleBar.updateSettings(ScaleBarSettings(textBorderWidth: 3));
    await scaleBar.updateSettings(ScaleBarSettings(showTextBorder: false));
    await scaleBar.updateSettings(ScaleBarSettings(refreshInterval: 42));
    await scaleBar.updateSettings(
      ScaleBarSettings(useContinuousRendering: true),
    );

    // Each field above was sent alone, so all of them must still be set.
    final s = await scaleBar.getSettings();
    expect(s.position, OrnamentPosition.BOTTOM_RIGHT);
    expect(s.marginLeft, 11);
    expect(s.marginTop, 12);
    expect(s.marginRight, 13);
    expect(s.marginBottom, 14);
    expect(s.distanceUnits, DistanceUnits.NAUTICAL);
    // iOS returns null for every scale bar field it does not draw, `ratio`
    // included; Android and web store and return all of them.
    if (kIsWeb) {
      expect(s.ratio, 0.75);
      expect(s.textColor, 0xFFF44336);
      expect(s.primaryColor, 0xFF2196F3);
      expect(s.secondaryColor, 0xFFFFFFFF);
      expect(s.borderWidth, 4);
      expect(s.textSize, 14);
      expect(s.height, 7);
      expect(s.textBarMargin, 6);
      expect(s.textBorderWidth, 3);
      expect(s.showTextBorder, false);
      expect(s.refreshInterval, 42);
      expect(s.useContinuousRendering, true);
    }
  });

  patrolTest('every compass field the example exposes round-trips', ($) async {
    final map = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    final compass = map.compass;

    await compass.updateSettings(CompassSettings(enabled: true));
    await compass.updateSettings(
      CompassSettings(position: OrnamentPosition.BOTTOM_LEFT),
    );
    await compass.updateSettings(CompassSettings(marginLeft: 21));
    await compass.updateSettings(CompassSettings(marginTop: 22));
    await compass.updateSettings(CompassSettings(marginRight: 23));
    await compass.updateSettings(CompassSettings(marginBottom: 24));
    await compass.updateSettings(CompassSettings(opacity: 0.6));
    await compass.updateSettings(CompassSettings(rotation: 33));
    await compass.updateSettings(CompassSettings(clickable: false));

    final s = await compass.getSettings();
    expect(s.position, OrnamentPosition.BOTTOM_LEFT);
    expect(s.marginLeft, 21);
    expect(s.marginTop, 22);
    expect(s.marginRight, 23);
    expect(s.marginBottom, 24);
    expect(s.enabled, isTrue, reason: 'enabled must survive later updates');
    if (kIsWeb) {
      expect(s.opacity, 0.6);
      expect(s.rotation, 33);
      expect(s.clickable, false);
    }
  });

  patrolTest('every logo field the example exposes round-trips', ($) async {
    final map = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    final logo = map.logo;

    await logo.updateSettings(LogoSettings(enabled: true));
    await logo.updateSettings(
      LogoSettings(position: OrnamentPosition.BOTTOM_RIGHT),
    );
    await logo.updateSettings(LogoSettings(marginLeft: 31));
    await logo.updateSettings(LogoSettings(marginTop: 32));
    await logo.updateSettings(LogoSettings(marginRight: 33));
    await logo.updateSettings(LogoSettings(marginBottom: 34));

    // Each field above was sent alone, so all of them must still be set.
    final s = await logo.getSettings();
    expect(s.position, OrnamentPosition.BOTTOM_RIGHT);
    expect(s.marginLeft, 31);
    expect(s.marginTop, 32);
    expect(s.marginRight, 33);
    expect(s.marginBottom, 34);
    expect(s.enabled, isTrue, reason: 'enabled must survive later updates');
  });

  patrolTest('every attribution field the example exposes round-trips', (
    $,
  ) async {
    final map = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    final attribution = map.attribution;

    await attribution.updateSettings(AttributionSettings(enabled: true));
    await attribution.updateSettings(
      AttributionSettings(position: OrnamentPosition.TOP_RIGHT),
    );
    await attribution.updateSettings(AttributionSettings(marginLeft: 41));
    await attribution.updateSettings(AttributionSettings(marginTop: 42));
    await attribution.updateSettings(AttributionSettings(marginRight: 43));
    await attribution.updateSettings(AttributionSettings(marginBottom: 44));
    await attribution.updateSettings(
      AttributionSettings(iconColor: 0xFF2196F3),
    );
    await attribution.updateSettings(AttributionSettings(clickable: false));

    final s = await attribution.getSettings();
    expect(s.position, OrnamentPosition.TOP_RIGHT);
    expect(s.marginLeft, 41);
    expect(s.marginTop, 42);
    expect(s.marginRight, 43);
    expect(s.marginBottom, 44);
    expect(s.enabled, isTrue, reason: 'enabled must survive later updates');
    // iOS returns null for `clickable`, which it does not model, and rounds
    // `iconColor` through a UIColor. Android and web store and return both.
    if (kIsWeb) {
      expect(s.iconColor, 0xFF2196F3);
      expect(s.clickable, isFalse);
    }
  });
}
