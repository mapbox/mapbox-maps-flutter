import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

import 'ornament_test_utils.dart';
import 'patrol.dart';

void main() {
  patrolTest('scale bar fields GL JS cannot apply still round-trip', ($) async {
    final platformMap = await pumpOrnamentMap($.tester);
    final scaleBar = platformMap.scaleBar;

    await scaleBar.updateSettings(
      ScaleBarSettings(
        height: 6,
        textBarMargin: 9,
        textBorderWidth: 3,
        refreshInterval: 30,
        showTextBorder: false,
        useContinuousRendering: true,
      ),
    );

    final settings = await scaleBar.getSettings();
    expect(settings.height, 6);
    expect(settings.textBarMargin, 9);
    expect(settings.textBorderWidth, 3);
    expect(settings.refreshInterval, 30);
    expect(settings.showTextBorder, false);
    expect(settings.useContinuousRendering, true);
  });
}
