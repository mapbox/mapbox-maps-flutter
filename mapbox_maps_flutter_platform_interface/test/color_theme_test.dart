import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

void main() {
  group('ColorUseTheme', () {
    test('named constants carry the style-spec values', () {
      expect(ColorUseTheme.useDefault.value, 'default');
      expect(ColorUseTheme.none.value, 'none');
    });

    test('fromValue returns the named constant for a known value', () {
      expect(ColorUseTheme.fromValue('default'), same(ColorUseTheme.useDefault));
      expect(ColorUseTheme.fromValue('none'), same(ColorUseTheme.none));
    });

    test('fromValue returns null for an unknown value', () {
      expect(ColorUseTheme.fromValue('future'), isNull);
      expect(ColorUseTheme.fromValue(['get', 'theme']), isNull);
      expect(ColorUseTheme.fromValue(null), isNull);
    });
  });

  group('ColorTheme', () {
    test('a base64 LUT encodes as the color-theme data string', () {
      expect(const ColorTheme.base64('iVBORw0KGgo=').toJson(), {
        'data': 'iVBORw0KGgo=',
      });
    });

    test('an expression LUT encodes as the color-theme data expression', () {
      final theme = ColorTheme.expression(['config', 'theme-data']);
      expect(theme.toJson(), {
        'data': ['config', 'theme-data'],
      });
    });
  });
}
