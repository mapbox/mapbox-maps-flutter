import 'dart:js_interop';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/src/bindings/binding_adapters.dart';
import 'package:mapbox_maps_flutter_web/src/bindings/camera_bindings.dart';

import 'patrol.dart';

// The conversions create JS objects, so they run in the browser with the
// Patrol tests and not with the unit tests on the Dart VM.
void main() {
  patrolTest('free camera options convert to and from GL JS', ($) async {
    const position = FreeCameraPosition(x: 0.52, y: 0.37, z: 0.001);
    const orientation = FreeCameraOrientation(x: 0.5, y: -0.5, z: 0.5, w: 0.5);

    final js = const FreeCameraOptions(
      position: position,
      orientation: orientation,
    ).toJSFreeCameraOptions();
    expect(js.position?.x, 0.52);
    expect(js.position?.y, 0.37);
    expect(js.position?.z, 0.001);
    expect(js.orientation?.toDart.map((n) => n.toDartDouble), [
      0.5,
      -0.5,
      0.5,
      0.5,
    ]);
    expect(
      js.toFreeCameraOptions(),
      const FreeCameraOptions(position: position, orientation: orientation),
    );

    final unset = const FreeCameraOptions().toJSFreeCameraOptions();
    expect(unset.position, isNull);
    expect(unset.orientation, isNull);
    expect(unset.toFreeCameraOptions(), const FreeCameraOptions());

    final wrongLength = JSFreeCameraOptions(
      orientation: [0.toJS, 0.toJS, 1.toJS].toJS,
    );
    expect(wrongLength.toFreeCameraOptions().orientation, isNull);
  });
}
