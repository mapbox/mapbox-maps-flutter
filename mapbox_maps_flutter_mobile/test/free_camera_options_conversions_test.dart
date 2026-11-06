import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

void main() {
  group('FreeCameraOptions wire conversion', () {
    test('keeps position and orientation', () {
      final options = FreeCameraOptions(
        position: const FreeCameraPosition(x: 0.5193, y: 0.2875, z: 0.0000123),
        orientation: const FreeCameraOrientation(
          x: 0.5,
          y: -0.5,
          z: 0.5,
          w: 0.5,
        ),
      );

      final wire = options.toWire();

      expect(wire.position, [0.5193, 0.2875, 0.0000123]);
      expect(wire.orientation, [0.5, -0.5, 0.5, 0.5]);
    });

    test('keeps unset fields unset', () {
      final wire = FreeCameraOptions(
        orientation: const FreeCameraOrientation(x: 0, y: 0, z: 0, w: 1),
      ).toWire();

      expect(wire.position, isNull);
      expect(wire.orientation, [0.0, 0.0, 0.0, 1.0]);
    });

    test('reads position and orientation back from the wire', () {
      final options = FreeCameraOptionsWire(
        position: [0.25, 0.75, 0.001],
        orientation: [0.0, 0.0, 0.7071067811865476, 0.7071067811865476],
      ).toFreeCameraOptions();

      expect(
        options.position,
        const FreeCameraPosition(x: 0.25, y: 0.75, z: 0.001),
      );
      expect(
        options.orientation,
        const FreeCameraOrientation(
          x: 0,
          y: 0,
          z: 0.7071067811865476,
          w: 0.7071067811865476,
        ),
      );
    });

    test('reads unset fields from the wire as null', () {
      final options = FreeCameraOptionsWire().toFreeCameraOptions();

      expect(options.position, isNull);
      expect(options.orientation, isNull);
    });

    test('ignores wire lists with the wrong length', () {
      final options = FreeCameraOptionsWire(
        position: [0.25, 0.75],
        orientation: [0.0, 0.0, 1.0],
      ).toFreeCameraOptions();

      expect(options.position, isNull);
      expect(options.orientation, isNull);
    });
  });
}
