import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_web/src/style/lights.dart';

void main() {
  test('the ambient and directional lights have color-use-theme', () {
    expect(lightPropertyNames['ambient'], contains('color-use-theme'));
    expect(lightPropertyNames['directional'], contains('color-use-theme'));
  });

  test('the flat light has no color-use-theme', () {
    expect(lightPropertyNames['flat'], isNot(contains('color-use-theme')));
    expect(flatLightResetValues, isNot(contains('color-use-theme')));
  });
}
