// This file is generated.
//
// Unit tests for the PolylineAnnotation event projection logic (tap / long
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
    final fake = _FakePolylineAnnotationManagerPI();
    final manager = PolylineAnnotationManager(fake);
    addTearDown(fake.dispose);

    final captured = <PolylineAnnotation>[];
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
    final fake = _FakePolylineAnnotationManagerPI();
    final manager = PolylineAnnotationManager(fake);
    addTearDown(fake.dispose);

    final captured = <PolylineAnnotation>[];
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
    final fake = _FakePolylineAnnotationManagerPI();
    final manager = PolylineAnnotationManager(fake);
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

PolylineAnnotation _makeAnnotation(String id) => PolylineAnnotation(
  id: id,
  geometry: LineString(coordinates: [Position(0, 0), Position(1, 1)]),
);

class _FakePolylineAnnotationManagerPI
    implements PolylineAnnotationManagerPlatformInterface {
  final _tap =
      StreamController<PolylineAnnotationInteractionContext>.broadcast();
  final _longPress =
      StreamController<PolylineAnnotationInteractionContext>.broadcast();
  final _drag =
      StreamController<PolylineAnnotationInteractionContext>.broadcast();

  @override
  String get id => 'fake-polylineAnnotation-manager';

  @override
  Stream<PolylineAnnotationInteractionContext> get tapInteractionStream =>
      _tap.stream;
  @override
  Stream<PolylineAnnotationInteractionContext> get longPressInteractionStream =>
      _longPress.stream;
  @override
  Stream<PolylineAnnotationInteractionContext> get dragInteractionStream =>
      _drag.stream;

  void fireTap(PolylineAnnotation annotation) => _tap.add(
    PolylineAnnotationInteractionContext(
      annotation: annotation,
      gestureState: GestureState.ended,
    ),
  );

  void fireLongPress(PolylineAnnotation annotation) => _longPress.add(
    PolylineAnnotationInteractionContext(
      annotation: annotation,
      gestureState: GestureState.ended,
    ),
  );

  void fireDrag(GestureState state, PolylineAnnotation annotation) => _drag.add(
    PolylineAnnotationInteractionContext(
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
