// This file is generated.
// ignore_for_file: experimental_member_use
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart' show Point, Position;

import '../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CircleAnnotationManager custom id and position', skip: kIsWeb, (
    WidgetTester tester,
  ) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final dummyLayer = CircleLayer(id: "dummyLayer", sourceId: 'sourceId');
    await mapboxMap.style.addLayer(dummyLayer);
    final id = "CircleAnnotationManagerId";
    final manager = await mapboxMap.annotations.createCircleAnnotationManager(
      id: id,
      below: 'dummyLayer',
    );

    expect(await mapboxMap.style.styleLayerExists(id), isTrue);
    expect(await mapboxMap.style.styleSourceExists(id), isTrue);
    expect(manager.id, id);
    final layers = await mapboxMap.style.getStyleLayers();
    expect(layers.first?.id, id);
    expect(layers.last?.id, dummyLayer.id);
  });

  testWidgets('create CircleAnnotation_manager ', skip: kIsWeb, (
    WidgetTester tester,
  ) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();

    await manager.setCircleElevationReference(CircleElevationReference.NONE);
    var circleElevationReference = await manager.getCircleElevationReference();
    expect(CircleElevationReference.NONE, circleElevationReference);

    await manager.setCircleSortKey(1.0);
    var circleSortKey = await manager.getCircleSortKey();
    expect(1.0, circleSortKey);

    await manager.setCircleBlur(1.0);
    var circleBlur = await manager.getCircleBlur();
    expect(1.0, circleBlur);

    await manager.setCircleColor(Colors.red.value);
    var circleColor = await manager.getCircleColor();
    expect(Colors.red.value, circleColor);

    await manager.setCircleEmissiveStrength(1.0);
    var circleEmissiveStrength = await manager.getCircleEmissiveStrength();
    expect(1.0, circleEmissiveStrength);

    await manager.setCircleOpacity(1.0);
    var circleOpacity = await manager.getCircleOpacity();
    expect(1.0, circleOpacity);

    await manager.setCirclePitchAlignment(CirclePitchAlignment.MAP);
    var circlePitchAlignment = await manager.getCirclePitchAlignment();
    expect(CirclePitchAlignment.MAP, circlePitchAlignment);

    await manager.setCirclePitchScale(CirclePitchScale.MAP);
    var circlePitchScale = await manager.getCirclePitchScale();
    expect(CirclePitchScale.MAP, circlePitchScale);

    await manager.setCircleRadius(1.0);
    var circleRadius = await manager.getCircleRadius();
    expect(1.0, circleRadius);

    await manager.setCircleStrokeColor(Colors.red.value);
    var circleStrokeColor = await manager.getCircleStrokeColor();
    expect(Colors.red.value, circleStrokeColor);

    await manager.setCircleStrokeOpacity(1.0);
    var circleStrokeOpacity = await manager.getCircleStrokeOpacity();
    expect(1.0, circleStrokeOpacity);

    await manager.setCircleStrokeWidth(1.0);
    var circleStrokeWidth = await manager.getCircleStrokeWidth();
    expect(1.0, circleStrokeWidth);

    await manager.setCircleTranslate([0.0, 1.0]);
    var circleTranslate = await manager.getCircleTranslate();
    expect([0.0, 1.0], circleTranslate);

    await manager.setCircleTranslateAnchor(CircleTranslateAnchor.MAP);
    var circleTranslateAnchor = await manager.getCircleTranslateAnchor();
    expect(CircleTranslateAnchor.MAP, circleTranslateAnchor);
  });

  group('annotation events', () {
    late _FakeCircleAnnotationManagerPI fake;
    late CircleAnnotationManager manager;

    setUp(() {
      fake = _FakeCircleAnnotationManagerPI();
      // ignore: invalid_use_of_internal_member
      manager = CircleAnnotationManager(fake);
    });

    tearDown(() => fake.dispose());

    testWidgets('annotation tap events can be listened and canceled', (
      tester,
    ) async {
      final captured = <CircleAnnotation>[];
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

    testWidgets('annotation long press events can be listened and canceled', (
      tester,
    ) async {
      final captured = <CircleAnnotation>[];
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

    testWidgets('annotation drag events can be listened and canceled', (
      tester,
    ) async {
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
  });
}

CircleAnnotation _makeAnnotation(String id) => CircleAnnotation(
  id: id,
  geometry: Point(coordinates: Position(0, 0)),
);

class _FakeCircleAnnotationManagerPI
    implements CircleAnnotationManagerPlatformInterface {
  final _tap = StreamController<CircleAnnotationInteractionContext>.broadcast();
  final _longPress =
      StreamController<CircleAnnotationInteractionContext>.broadcast();
  final _drag =
      StreamController<CircleAnnotationInteractionContext>.broadcast();

  @override
  String get id => 'fake-circleAnnotation-manager';

  @override
  Stream<CircleAnnotationInteractionContext> get tapInteractionStream =>
      _tap.stream;
  @override
  Stream<CircleAnnotationInteractionContext> get longPressInteractionStream =>
      _longPress.stream;
  @override
  Stream<CircleAnnotationInteractionContext> get dragInteractionStream =>
      _drag.stream;

  void fireTap(CircleAnnotation annotation) => _tap.add(
    CircleAnnotationInteractionContext(
      annotation: annotation,
      gestureState: GestureState.ended,
    ),
  );

  void fireLongPress(CircleAnnotation annotation) => _longPress.add(
    CircleAnnotationInteractionContext(
      annotation: annotation,
      gestureState: GestureState.ended,
    ),
  );

  void fireDrag(GestureState state, CircleAnnotation annotation) => _drag.add(
    CircleAnnotationInteractionContext(
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
