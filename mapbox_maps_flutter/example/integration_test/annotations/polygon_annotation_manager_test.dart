// This file is generated.
// ignore_for_file: experimental_member_use
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart' show Polygon, Position;

import '../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PolygonAnnotationManager custom id and position', skip: kIsWeb, (
    WidgetTester tester,
  ) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final dummyLayer = FillLayer(id: "dummyLayer", sourceId: 'sourceId');
    await mapboxMap.style.addLayer(dummyLayer);
    final id = "PolygonAnnotationManagerId";
    final manager = await mapboxMap.annotations.createPolygonAnnotationManager(
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

  testWidgets('create PolygonAnnotation_manager ', skip: kIsWeb, (
    WidgetTester tester,
  ) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations
        .createPolygonAnnotationManager();

    await manager.setFillConstructBridgeGuardRail(true);
    var fillConstructBridgeGuardRail = await manager
        .getFillConstructBridgeGuardRail();
    expect(true, fillConstructBridgeGuardRail);

    await manager.setFillElevationReference(FillElevationReference.NONE);
    var fillElevationReference = await manager.getFillElevationReference();
    expect(FillElevationReference.NONE, fillElevationReference);

    await manager.setFillSortKey(1.0);
    var fillSortKey = await manager.getFillSortKey();
    expect(1.0, fillSortKey);

    await manager.setFillAntialias(true);
    var fillAntialias = await manager.getFillAntialias();
    expect(true, fillAntialias);

    await manager.setFillBridgeGuardRailColor(Colors.red.value);
    var fillBridgeGuardRailColor = await manager.getFillBridgeGuardRailColor();
    expect(Colors.red.value, fillBridgeGuardRailColor);

    await manager.setFillColor(Colors.red.value);
    var fillColor = await manager.getFillColor();
    expect(Colors.red.value, fillColor);

    await manager.setFillEmissiveStrength(1.0);
    var fillEmissiveStrength = await manager.getFillEmissiveStrength();
    expect(1.0, fillEmissiveStrength);

    await manager.setFillOpacity(1.0);
    var fillOpacity = await manager.getFillOpacity();
    expect(1.0, fillOpacity);

    await manager.setFillOutlineColor(Colors.red.value);
    var fillOutlineColor = await manager.getFillOutlineColor();
    expect(Colors.red.value, fillOutlineColor);

    await manager.setFillPattern("abc");
    var fillPattern = await manager.getFillPattern();
    expect("abc", fillPattern);

    await manager.setFillTranslate([0.0, 1.0]);
    var fillTranslate = await manager.getFillTranslate();
    expect([0.0, 1.0], fillTranslate);

    await manager.setFillTranslateAnchor(FillTranslateAnchor.MAP);
    var fillTranslateAnchor = await manager.getFillTranslateAnchor();
    expect(FillTranslateAnchor.MAP, fillTranslateAnchor);

    await manager.setFillTunnelStructureColor(Colors.red.value);
    var fillTunnelStructureColor = await manager.getFillTunnelStructureColor();
    expect(Colors.red.value, fillTunnelStructureColor);

    await manager.setFillZOffset(1.0);
    var fillZOffset = await manager.getFillZOffset();
    expect(1.0, fillZOffset);
  });

  group('annotation events', () {
    late _FakePolygonAnnotationManagerPI fake;
    late PolygonAnnotationManager manager;

    setUp(() {
      fake = _FakePolygonAnnotationManagerPI();
      // ignore: invalid_use_of_internal_member
      manager = PolygonAnnotationManager(fake);
    });

    tearDown(() => fake.dispose());

    testWidgets('annotation tap events can be listened and canceled', (
      tester,
    ) async {
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

    testWidgets('annotation long press events can be listened and canceled', (
      tester,
    ) async {
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
