import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// Expected values come from GL JS `MercatorCoordinate` and
// `FreeCameraOptions` (src/geo/mercator_coordinate.ts, src/ui/free_camera.ts).
const _tolerance = 1e-12;

Point _point(double lng, double lat) => Point(coordinates: Position(lng, lat));

void _expectPosition(FreeCameraPosition? actual, List<double> expected) {
  expect(actual, isNotNull);
  expect(actual!.x, closeTo(expected[0], _tolerance));
  expect(actual.y, closeTo(expected[1], _tolerance));
  expect(actual.z, closeTo(expected[2], _tolerance));
}

void _expectOrientation(FreeCameraOrientation? actual, List<double> expected) {
  expect(actual, isNotNull);
  expect(actual!.x, closeTo(expected[0], _tolerance));
  expect(actual.y, closeTo(expected[1], _tolerance));
  expect(actual.z, closeTo(expected[2], _tolerance));
  expect(actual.w, closeTo(expected[3], _tolerance));
}

void main() {
  group('FreeCameraOptions location and altitude', () {
    // [lng, lat, altitude, x, y, z]
    const fixtures = <List<double>>[
      [24.9384, 60.1699, 0, 0.5692733333333333, 0.28945331830544235, 0],
      [
        24.9384,
        60.1699,
        1000,
        0.5692733333333333,
        0.28945331830544235,
        0.00005022039859092315,
      ],
      [
        24.9384,
        60.1699,
        1e6,
        0.5692733333333333,
        0.28945331830544235,
        0.05022039859092315,
      ],
      [-122.4194, 37.7749, 0, 0.15994611111111112, 0.38652093672172827, 0],
      [
        -122.4194,
        37.7749,
        1000,
        0.15994611111111112,
        0.38652093672172827,
        0.00003160473239000279,
      ],
      [
        -122.4194,
        37.7749,
        1e6,
        0.15994611111111112,
        0.38652093672172827,
        0.03160473239000279,
      ],
      [151.2093, -84.9, 0, 0.9200258333333333, 0.9952063149767321, 0],
      [
        151.2093,
        -84.9,
        1000,
        0.9200258333333333,
        0.9952063149767321,
        0.0002810205164466642,
      ],
      [
        151.2093,
        -84.9,
        1e6,
        0.9200258333333333,
        0.9952063149767321,
        0.2810205164466642,
      ],
    ];

    for (final f in fixtures) {
      final lng = f[0], lat = f[1], altitude = f[2];

      test('withLocation at ($lng, $lat) and $altitude m matches GL JS', () {
        final options = const FreeCameraOptions().withLocation(
          _point(lng, lat),
          altitude: altitude,
        );

        _expectPosition(options.position, [f[3], f[4], f[5]]);
        expect(options.location!.coordinates.lng, closeTo(lng, 1e-9));
        expect(options.location!.coordinates.lat, closeTo(lat, 1e-9));
        expect(options.altitude, closeTo(altitude, 1e-6));
      });
    }

    test('withLocation without an altitude keeps the current altitude', () {
      final options = const FreeCameraOptions()
          .withLocation(_point(24.9384, 60.1699), altitude: 1000)
          .withLocation(_point(-122.4194, 37.7749));

      _expectPosition(options.position, [
        0.15994611111111112,
        0.38652093672172827,
        0.00003160473239000279,
      ]);
    });

    test('withLocation uses altitude 0 when there is no position', () {
      final options = const FreeCameraOptions().withLocation(
        _point(24.9384, 60.1699),
      );

      _expectPosition(options.position, [
        0.5692733333333333,
        0.28945331830544235,
        0,
      ]);
    });

    test('withAltitude keeps the current location', () {
      final options = const FreeCameraOptions()
          .withLocation(_point(151.2093, -84.9))
          .withAltitude(1e6);

      _expectPosition(options.position, [
        0.9200258333333333,
        0.9952063149767321,
        0.2810205164466642,
      ]);
    });

    test('withAltitude keeps a position beyond the mercator latitude', () {
      // y = -0.1 is latitude 87.35866, which withLocation would clamp.
      final options = const FreeCameraOptions(
        position: FreeCameraPosition(x: 0.3, y: -0.1, z: 0.2),
      ).withAltitude(1000);

      _expectPosition(options.position, [0.3, -0.1, 0.0005420811658722027]);
    });

    test('withAltitude throws when there is no position', () {
      final options = const FreeCameraOptions();

      expect(() => options.withAltitude(100), throwsStateError);
    });

    test('location and altitude are null when there is no position', () {
      final options = const FreeCameraOptions();

      expect(options.location, isNull);
      expect(options.altitude, isNull);
    });

    test('altitude reads back like GL JS toAltitude', () {
      // GL JS: new MercatorCoordinate(0.3, 0.4, 0.02).toAltitude().
      final options = FreeCameraOptions(
        position: const FreeCameraPosition(x: 0.3, y: 0.4, z: 0.02),
      );

      expect(options.altitude, closeTo(664969.3832366993, 1e-6));
    });

    test('latitude beyond the mercator limit is clamped', () {
      // GL JS MercatorCoordinate.fromLngLat([10, ±85.051129], 500).
      final north = const FreeCameraOptions().withLocation(
        _point(10, 89),
        altitude: 500,
      );
      final south = const FreeCameraOptions().withLocation(
        _point(10, -89),
        altitude: 500,
      );

      _expectPosition(north.position, [
        0.5277777777777778,
        -7.090199558332541e-9,
        0.00014479000137092903,
      ]);
      _expectPosition(south.position, [
        0.5277777777777778,
        1.0000000070901993,
        0.00014479000137092903,
      ]);
      expect(north.location!.coordinates.lat, closeTo(85.051129, 1e-9));
      expect(south.location!.coordinates.lat, closeTo(-85.051129, 1e-9));
      expect(north.altitude, closeTo(500, 1e-9));
    });
  });

  group('FreeCameraOptions.withPitchBearing', () {
    // [pitch, bearing, x, y, z, w]
    const fixtures = <List<double>>[
      [0, -90, 0, 0, -0.7071067811865475, 0.7071067811865476],
      [0, 0, 0, 0, 0, 1],
      [0, 270, 0, 0, 0.7071067811865476, -0.7071067811865475],
      [
        45,
        -90,
        -0.2705980500730985,
        0.27059805007309845,
        -0.6532814824381882,
        0.6532814824381883,
      ],
      [45, 0, -0.3826834323650898, 0, 0, 0.9238795325112867],
      [
        45,
        270,
        0.27059805007309845,
        -0.2705980500730985,
        0.6532814824381883,
        -0.6532814824381882,
      ],
      [
        85,
        -90,
        -0.4777144171082609,
        0.47771441710826085,
        -0.5213338044735969,
        0.5213338044735969,
      ],
      [85, 0, -0.6755902076156602, 0, 0, 0.7372773368101241],
      [
        85,
        270,
        0.47771441710826085,
        -0.4777144171082609,
        0.5213338044735969,
        -0.5213338044735969,
      ],
    ];

    for (final f in fixtures) {
      test('pitch ${f[0]} and bearing ${f[1]} match GL JS', () {
        final options = const FreeCameraOptions().withPitchBearing(f[0], f[1]);

        _expectOrientation(options.orientation, [f[2], f[3], f[4], f[5]]);
      });
    }

    test('does not change the position', () {
      final options = FreeCameraOptions(
        position: const FreeCameraPosition(x: 0.5, y: 0.5, z: 0.1),
      ).withPitchBearing(45, 90);

      expect(
        options.position,
        const FreeCameraPosition(x: 0.5, y: 0.5, z: 0.1),
      );
    });
  });

  group('FreeCameraOptions.lookingAt', () {
    final helsinki = _point(24.9384, 60.1699);

    test('pitch 45 and bearing 0 match GL JS', () {
      final options = FreeCameraOptions(
        position: const FreeCameraPosition(x: 0.5, y: 0.5, z: 0.5),
      ).lookingAt(_point(0, 85.051128779806604));

      _expectOrientation(options.orientation, [
        -0.3826834323650898,
        0,
        0,
        0.9238795325112867,
      ]);
    });

    test('looking directly to the east matches GL JS', () {
      final options = FreeCameraOptions(
        position: const FreeCameraPosition(x: 0.5, y: 0.5, z: 0),
      ).lookingAt(_point(30, 0));

      _expectOrientation(options.orientation, [
        -0.5,
        -0.4999999999999999,
        0.5,
        0.5000000000000001,
      ]);
    });

    test('looking straight down with an up vector matches GL JS', () {
      final options = const FreeCameraOptions()
          .withLocation(helsinki, altitude: 100)
          .lookingAt(helsinki, up: const FreeCameraPosition(x: 0, y: -1, z: 0));

      _expectOrientation(options.orientation, [0, 0, 0, 1]);
    });

    test('a diagonal up vector gives bearing 45 like GL JS', () {
      final options = const FreeCameraOptions()
          .withLocation(helsinki, altitude: 100)
          .lookingAt(
            helsinki,
            up: const FreeCameraPosition(x: -1, y: -1, z: 0),
          );

      _expectOrientation(options.orientation, [
        0,
        0,
        -0.3826834323650898,
        0.9238795325112867,
      ]);
    });

    test('an up vector almost equal to forward matches GL JS', () {
      final options = const FreeCameraOptions()
          .withLocation(_point(122.4194, 37.7749))
          .lookingAt(
            _point(122.4194, 37.5),
            up: const FreeCameraPosition(x: 0, y: 1, z: 0.00001),
          );

      _expectOrientation(options.orientation, [
        -4.329780281177466e-17,
        -0.7071067811865475,
        0.7071067811865476,
        4.329780281177467e-17,
      ]);
    });

    test('the roll component of the up vector is removed like GL JS', () {
      final options = const FreeCameraOptions()
          .withLocation(_point(151.2093, -33.8688))
          .lookingAt(
            _point(160, -33.8688),
            up: const FreeCameraPosition(x: 0, y: -1, z: 0.1),
          );

      _expectOrientation(options.orientation, [
        -0.5,
        -0.4999999999999999,
        0.5,
        0.5000000000000001,
      ]);
    });

    test('an up vector that points down is flipped like GL JS', () {
      final options =
          FreeCameraOptions(
            position: const FreeCameraPosition(x: 0.5, y: 0.5, z: 0.5),
          ).lookingAt(
            _point(0, 85.051128779806604),
            up: const FreeCameraPosition(x: 0, y: 0, z: -0.5),
          );

      _expectOrientation(options.orientation, [
        -0.3826834323650898,
        0,
        0,
        0.9238795325112867,
      ]);
    });

    test('target altitude matches GL JS with an explicit altitude', () {
      final options = const FreeCameraOptions()
          .withLocation(_point(7.4246, 43.7384), altitude: 300)
          .lookingAt(_point(7.4290, 43.7350), altitude: 120);

      _expectOrientation(options.orientation, [
        -0.21272892467509177,
        -0.5389811035137431,
        0.7581012209536743,
        0.2992128230043545,
      ]);
    });

    test('does not change the position', () {
      final options = FreeCameraOptions(
        position: const FreeCameraPosition(x: 0.5, y: 0.5, z: 0.5),
      ).lookingAt(_point(0, 85.051128779806604));

      expect(
        options.position,
        const FreeCameraPosition(x: 0.5, y: 0.5, z: 0.5),
      );
    });

    group('clears the orientation', () {
      const previous = FreeCameraOrientation.identity;

      test('when there is no position', () {
        final options = FreeCameraOptions(
          orientation: previous,
        ).lookingAt(_point(0, 0));

        expect(options.orientation, isNull);
      });

      test('when the target is the same as the position', () {
        final options = FreeCameraOptions(
          position: const FreeCameraPosition(x: 0.5, y: 0.5, z: 0),
          orientation: previous,
        ).lookingAt(_point(0, 0));

        expect(options.orientation, isNull);
      });

      test('when looking straight down with the default up direction', () {
        final options = FreeCameraOptions(
          position: const FreeCameraPosition(x: 0.5, y: 0.5, z: 0.5),
          orientation: previous,
        ).lookingAt(_point(0, 0));

        expect(options.orientation, isNull);
      });

      test('when the target is straight above the camera', () {
        final options = FreeCameraOptions(orientation: previous)
            .withLocation(_point(7.4246, 43.7384), altitude: 50)
            .lookingAt(_point(7.4246, 43.7384), altitude: 500);

        expect(options.orientation, isNull);
      });

      test('when the up vector has zero length', () {
        final options =
            FreeCameraOptions(
              position: const FreeCameraPosition(x: 0.5, y: 0.5, z: 0.5),
              orientation: previous,
            ).lookingAt(
              _point(0, 0),
              up: const FreeCameraPosition(x: 0, y: 0, z: 0),
            );

        expect(options.orientation, isNull);
      });

      test('when the up vector is the same as the view direction', () {
        final options =
            FreeCameraOptions(
              position: const FreeCameraPosition(x: 0.5, y: 0.5, z: 0.5),
              orientation: previous,
            ).lookingAt(
              _point(0, 0),
              up: const FreeCameraPosition(x: 0, y: 0, z: -1),
            );

        expect(options.orientation, isNull);
      });
    });
  });
}
