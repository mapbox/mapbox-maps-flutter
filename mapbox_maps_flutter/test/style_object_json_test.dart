// ignore_for_file: experimental_member_use
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  group('Atmosphere.fromJson', () {
    test('decodes rgb, rgba and hex colors', () {
      final atmosphere = Atmosphere.fromJson({
        'color': 'rgba(255, 0, 0, 1)',
        'high-color': 'rgb(0, 255, 0)',
        'space-color': '#0000ff',
        'horizon-blend': 0.1,
      });

      expect(atmosphere.color, 0xFFFF0000);
      expect(atmosphere.highColor, 0xFF00FF00);
      expect(atmosphere.spaceColor, 0xFF0000FF);
    });

    test('decodes short and alpha hex colors', () {
      final atmosphere = Atmosphere.fromJson({
        'color': '#f00',
        'high-color': '#00ff0080',
      });

      expect(atmosphere.color, 0xFFFF0000);
      expect(atmosphere.highColor, 0x8000FF00);
    });

    test('returns null for a color form that it cannot decode', () {
      final atmosphere = Atmosphere.fromJson({
        'color': 'hsl(220, 50%, 10%)',
        'high-color': 'white',
      });

      expect(atmosphere.color, isNull);
      expect(atmosphere.colorExpression, isNull);
      expect(atmosphere.highColor, isNull);
    });

    test('keeps a color expression with a sub-expression', () {
      final expression = [
        'rgba',
        [
          '*',
          20,
          ['zoom'],
        ],
        0,
        0,
        1,
      ];
      final atmosphere = Atmosphere.fromJson({'color': expression});

      expect(atmosphere.color, isNull);
      expect(atmosphere.colorExpression, expression);
    });

    test('decodes a constant color list as a color', () {
      final atmosphere = Atmosphere.fromJson({
        'color': ['rgba', 255, 0, 0, 1],
      });

      expect(atmosphere.color, 0xFFFF0000);
      expect(atmosphere.colorExpression, isNull);
    });
  });

  group('Layer decode', () {
    test('decodes rgba, hex and list colors', () {
      for (final (color, expected) in <(Object, int)>[
        ('rgba(255, 0, 0, 1)', 0xFFFF0000),
        ('#00ff00', 0xFF00FF00),
        (['rgba', 0, 0, 255, 1], 0xFF0000FF),
      ]) {
        final layer = FillLayer.decode(
          json.encode({
            'id': 'layer',
            'source': 'source',
            'type': 'fill',
            'paint': {'fill-color': color},
          }),
        );
        expect(layer.fillColor, expected, reason: '$color');
      }
    });

    test('decodes a color form that it cannot decode as null', () {
      final layer = FillLayer.decode(
        json.encode({
          'id': 'layer',
          'source': 'source',
          'type': 'fill',
          'paint': {'fill-color': 'red'},
        }),
      );

      expect(layer.fillColor, isNull);
    });
  });
}
