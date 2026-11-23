import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

void main() {
  group('FreeCameraPosition', () {
    test('positions with the same components are equal', () {
      expect(
        const FreeCameraPosition(x: 0.1, y: 0.2, z: 0.3),
        const FreeCameraPosition(x: 0.1, y: 0.2, z: 0.3),
      );
      expect(
        const FreeCameraPosition(x: 0.1, y: 0.2, z: 0.3).hashCode,
        const FreeCameraPosition(x: 0.1, y: 0.2, z: 0.3).hashCode,
      );
      expect(
        const FreeCameraPosition(x: 0.1, y: 0.2, z: 0.3),
        isNot(const FreeCameraPosition(x: 0.1, y: 0.2, z: 0.4)),
      );
    });

    test('copyWith replaces only the given components', () {
      const position = FreeCameraPosition(x: 0.1, y: 0.2, z: 0.3);

      expect(
        position.copyWith(z: 0.5),
        const FreeCameraPosition(x: 0.1, y: 0.2, z: 0.5),
      );
      expect(position.copyWith(), position);
    });

    test('toString shows the components', () {
      expect(
        const FreeCameraPosition(x: 0.5, y: 0.25, z: 0.0).toString(),
        'FreeCameraPosition(x: 0.5, y: 0.25, z: 0.0)',
      );
    });
  });

  group('FreeCameraOrientation', () {
    test('quaternions with the same components are equal', () {
      expect(
        const FreeCameraOrientation(x: 0, y: 0, z: 0, w: 1),
        FreeCameraOrientation.identity,
      );
      expect(
        const FreeCameraOrientation(x: 0, y: 0, z: 0, w: 1).hashCode,
        FreeCameraOrientation.identity.hashCode,
      );
      expect(
        FreeCameraOrientation.identity,
        isNot(const FreeCameraOrientation(x: 0, y: 0, z: 1, w: 0)),
      );
    });

    test('copyWith replaces only the given components', () {
      expect(
        FreeCameraOrientation.identity.copyWith(z: 1, w: 0),
        const FreeCameraOrientation(x: 0, y: 0, z: 1, w: 0),
      );
    });

    test('a quaternion that is not a unit quaternion fails the assert', () {
      expect(
        () => FreeCameraOrientation(x: 0, y: 0, z: 0, w: _notConst(0.9)),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => FreeCameraOrientation.identity.copyWith(x: 1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('toString shows the components', () {
      expect(
        FreeCameraOrientation.identity.toString(),
        'FreeCameraOrientation(x: 0.0, y: 0.0, z: 0.0, w: 1.0)',
      );
    });
  });

  group('FreeCameraOptions', () {
    const position = FreeCameraPosition(x: 0.5, y: 0.5, z: 0.1);

    test('options with the same values are equal', () {
      expect(
        const FreeCameraOptions(position: position),
        const FreeCameraOptions(position: position),
      );
      expect(
        const FreeCameraOptions(position: position).hashCode,
        const FreeCameraOptions(position: position).hashCode,
      );
      expect(
        const FreeCameraOptions(position: position),
        isNot(
          const FreeCameraOptions(orientation: FreeCameraOrientation.identity),
        ),
      );
    });

    test('copyWith replaces only the given values', () {
      const options = FreeCameraOptions(position: position);

      expect(
        options.copyWith(orientation: FreeCameraOrientation.identity),
        const FreeCameraOptions(
          position: position,
          orientation: FreeCameraOrientation.identity,
        ),
      );
      expect(options.copyWith(), options);
    });
  });
}

/// Returns [value] in a way that the compiler cannot evaluate, so a
/// constructor assert runs when the test runs.
double _notConst(double value) => value;
