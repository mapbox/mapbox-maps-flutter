// This file is generated.
//
// Unit tests for the PolygonAnnotation event projection logic (tap / long
// press / drag). They run against a fake platform interface with no real map,
// so they exercise only shared Dart logic and belong in `flutter test` rather
// than the on-device / web integration (patrol) suite.
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
// Geometry types (Point / LineString / Polygon / Position) are re-exported by
// the meta-package barrel, so no separate turf import is needed.
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  test('annotation tap events can be listened and canceled', () async {
    final fake = _FakePolygonAnnotationManagerPI();
    final manager = PolygonAnnotationManager(fake);
    addTearDown(fake.dispose);

    final captured = <PolygonAnnotation>[];
    final token = manager.tapEvents(onTap: captured.add);

    fake.fireTap(_makeAnnotation('id-1'));
    await Future<void>.delayed(Duration.zero);
    expect(captured.length, 1);
    expect(captured.single.id, 'id-1');

    token.cancel();
    fake.fireTap(_makeAnnotation('id-2'));
    await Future<void>.delayed(Duration.zero);
    expect(captured.length, 1);
  });

  test('annotation long press events can be listened and canceled', () async {
    final fake = _FakePolygonAnnotationManagerPI();
    final manager = PolygonAnnotationManager(fake);
    addTearDown(fake.dispose);

    final captured = <PolygonAnnotation>[];
    final token = manager.longPressEvents(onLongPress: captured.add);

    fake.fireLongPress(_makeAnnotation('id-1'));
    await Future<void>.delayed(Duration.zero);
    expect(captured.length, 1);
    expect(captured.single.id, 'id-1');

    token.cancel();
    fake.fireLongPress(_makeAnnotation('id-2'));
    await Future<void>.delayed(Duration.zero);
    expect(captured.length, 1);
  });

  test('annotation drag events can be listened and canceled', () async {
    final fake = _FakePolygonAnnotationManagerPI();
    final manager = PolygonAnnotationManager(fake);
    addTearDown(fake.dispose);

    final beginIds = <String>[];
    final changedIds = <String>[];
    final endIds = <String>[];

    final token = manager.dragEvents(
      onBegin: (a) => beginIds.add(a.id),
      onChanged: (a) => changedIds.add(a.id),
      onEnd: (a) => endIds.add(a.id),
    );

    fake.fireDrag(GestureState.started, _makeAnnotation('a1'));
    fake.fireDrag(GestureState.changed, _makeAnnotation('a1'));
    fake.fireDrag(GestureState.ended, _makeAnnotation('a1'));
    await Future<void>.delayed(Duration.zero);

    expect(beginIds, ['a1']);
    expect(changedIds, ['a1']);
    expect(endIds, ['a1']);

    token.cancel();
    fake.fireDrag(GestureState.started, _makeAnnotation('a2'));
    fake.fireDrag(GestureState.changed, _makeAnnotation('a2'));
    fake.fireDrag(GestureState.ended, _makeAnnotation('a2'));
    await Future<void>.delayed(Duration.zero);

    expect(beginIds, ['a1']);
    expect(changedIds, ['a1']);
    expect(endIds, ['a1']);
  });
}

PolygonAnnotation _makeAnnotation(String id) => PolygonAnnotation(
  id: id,
  geometry: Polygon(
    coordinates: [
      [Position(0, 0), Position(1, 0), Position(1, 1), Position(0, 0)],
    ],
  ),
);

class _FakePolygonAnnotationManagerPI
    implements PolygonAnnotationManagerPlatformInterface {
  final _tap =
      StreamController<PolygonAnnotationInteractionContext>.broadcast();
  final _longPress =
      StreamController<PolygonAnnotationInteractionContext>.broadcast();
  final _drag =
      StreamController<PolygonAnnotationInteractionContext>.broadcast();

  @override
  String get id => 'fake-polygonAnnotation-manager';

  @override
  Stream<PolygonAnnotationInteractionContext> get tapInteractionStream =>
      _tap.stream;
  @override
  Stream<PolygonAnnotationInteractionContext> get longPressInteractionStream =>
      _longPress.stream;
  @override
  Stream<PolygonAnnotationInteractionContext> get dragInteractionStream =>
      _drag.stream;

  void fireTap(PolygonAnnotation annotation) => _tap.add(
    PolygonAnnotationInteractionContext(
      annotation: annotation,
      gestureState: GestureState.ended,
    ),
  );

  void fireLongPress(PolygonAnnotation annotation) => _longPress.add(
    PolygonAnnotationInteractionContext(
      annotation: annotation,
      gestureState: GestureState.ended,
    ),
  );

  void fireDrag(GestureState state, PolygonAnnotation annotation) => _drag.add(
    PolygonAnnotationInteractionContext(
      annotation: annotation,
      gestureState: state,
    ),
  );

  void dispose() {
    _tap.close();
    _longPress.close();
    _drag.close();
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// End of generated file.
