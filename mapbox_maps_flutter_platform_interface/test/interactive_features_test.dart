import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

void main() {
  group('RenderedQueryGeometry.fromScreenCoordinate', () {
    test('equality and hashCode are value-based', () {
      final a = RenderedQueryGeometry.fromScreenCoordinate(
        ScreenCoordinate(x: 1, y: 2),
      );
      final b = RenderedQueryGeometry.fromScreenCoordinate(
        ScreenCoordinate(x: 1, y: 2),
      );
      final c = RenderedQueryGeometry.fromScreenCoordinate(
        ScreenCoordinate(x: 3, y: 4),
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
    });

    test('deprecated value/type getters encode the point', () {
      final geometry = RenderedQueryGeometry.fromScreenCoordinate(
        ScreenCoordinate(x: 1, y: 2),
      );
      expect(geometry.type, Type.SCREEN_COORDINATE);
      expect(jsonDecode(geometry.value), {'x': 1, 'y': 2});
    });
  });

  group('RenderedQueryGeometry.fromScreenBox', () {
    test('equality and hashCode are value-based', () {
      final a = RenderedQueryGeometry.fromScreenBox(
        ScreenBox(
          min: ScreenCoordinate(x: 0, y: 0),
          max: ScreenCoordinate(x: 10, y: 10),
        ),
      );
      final b = RenderedQueryGeometry.fromScreenBox(
        ScreenBox(
          min: ScreenCoordinate(x: 0, y: 0),
          max: ScreenCoordinate(x: 10, y: 10),
        ),
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('deprecated value/type getters encode the box', () {
      final geometry = RenderedQueryGeometry.fromScreenBox(
        ScreenBox(
          min: ScreenCoordinate(x: 0, y: 0),
          max: ScreenCoordinate(x: 10, y: 10),
        ),
      );
      expect(geometry.type, Type.SCREEN_BOX);
      expect(jsonDecode(geometry.value), {
        'min': {'x': 0, 'y': 0},
        'max': {'x': 10, 'y': 10},
      });
    });
  });

  group('RenderedQueryGeometry.fromList', () {
    test('equality and hashCode are value-based', () {
      final a = RenderedQueryGeometry.fromList([
        ScreenCoordinate(x: 1, y: 1),
        ScreenCoordinate(x: 2, y: 2),
      ]);
      final b = RenderedQueryGeometry.fromList([
        ScreenCoordinate(x: 1, y: 1),
        ScreenCoordinate(x: 2, y: 2),
      ]);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('deprecated value/type getters encode the points', () {
      final geometry = RenderedQueryGeometry.fromList([
        ScreenCoordinate(x: 1, y: 1),
        ScreenCoordinate(x: 2, y: 2),
      ]);
      expect(geometry.type, Type.LIST);
      expect(jsonDecode(geometry.value), [
        {'x': 1, 'y': 1},
        {'x': 2, 'y': 2},
      ]);
    });

    test('is unaffected by later mutation of the source list', () {
      final source = [ScreenCoordinate(x: 1, y: 1)];
      final geometry =
          RenderedQueryGeometry.fromList(source)
              as ScreenCoordinateListRenderedQueryGeometry;

      source.add(ScreenCoordinate(x: 2, y: 2));

      expect(geometry.points, [ScreenCoordinate(x: 1, y: 1)]);
    });

    test('points getter is unmodifiable', () {
      final geometry =
          RenderedQueryGeometry.fromList([ScreenCoordinate(x: 1, y: 1)])
              as ScreenCoordinateListRenderedQueryGeometry;

      expect(
        () => geometry.points.add(ScreenCoordinate(x: 2, y: 2)),
        throwsUnsupportedError,
      );
    });
  });
}
