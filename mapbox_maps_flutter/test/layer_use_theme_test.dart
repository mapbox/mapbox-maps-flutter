// ignore_for_file: experimental_member_use, invalid_use_of_internal_member
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  group('Layer use-theme', () {
    test('encodes the typed value as a paint property', () async {
      final layer = FillLayer(
        id: 'layer',
        sourceId: 'source',
        fillColorUseTheme: ColorUseTheme.none,
      );

      final encoded = json.decode(await layer.encode());

      expect(encoded['paint']['fill-color-use-theme'], 'none');
    });

    test('encodes the expression instead of the typed value', () async {
      final layer = FillLayer(
        id: 'layer',
        sourceId: 'source',
        fillColorUseTheme: ColorUseTheme.useDefault,
        fillColorUseThemeExpression: ['string', 'none'],
      );

      final encoded = json.decode(await layer.encode());

      expect(encoded['paint']['fill-color-use-theme'], ['string', 'none']);
    });

    test('decodes an unknown value as null', () {
      final layer = FillLayer.decode(
        json.encode({
          'id': 'layer',
          'source': 'source',
          'type': 'fill',
          'paint': {'fill-color-use-theme': 'future-value'},
        }),
      );

      expect(layer.fillColorUseTheme, isNull);
      expect(layer.fillColorUseThemeExpression, isNull);
    });

    test('decodes a named value as the named constant', () {
      final layer = FillLayer.decode(
        json.encode({
          'id': 'layer',
          'source': 'source',
          'type': 'fill',
          'paint': {'fill-color-use-theme': 'none'},
        }),
      );

      expect(layer.fillColorUseTheme, ColorUseTheme.none);
    });

    test('decodes an expression into the expression field', () {
      final layer = FillLayer.decode(
        json.encode({
          'id': 'layer',
          'source': 'source',
          'type': 'fill',
          'paint': {
            'fill-color-use-theme': ['string', 'none'],
          },
        }),
      );

      expect(layer.fillColorUseTheme, isNull);
      expect(layer.fillColorUseThemeExpression, ['string', 'none']);
    });
  });
}
