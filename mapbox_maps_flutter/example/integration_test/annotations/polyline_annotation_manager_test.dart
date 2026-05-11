// This file is generated.
// ignore_for_file: experimental_member_use
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart' show LineString, Position;

import '../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'PolylineAnnotationManager custom id and position',
    skip: kIsWeb,
    (WidgetTester tester) async {
      final mapFuture = app.main();
      await tester.pumpAndSettle();
      final mapboxMap = await mapFuture;
      final dummyLayer = LineLayer(id: "dummyLayer", sourceId: 'sourceId');
      await mapboxMap.style.addLayer(dummyLayer);
      final id = "PolylineAnnotationManagerId";
      final manager = await mapboxMap.annotations
          .createPolylineAnnotationManager(id: id, below: 'dummyLayer');

      expect(await mapboxMap.style.styleLayerExists(id), isTrue);
      expect(await mapboxMap.style.styleSourceExists(id), isTrue);
      expect(manager.id, id);
      final layers = await mapboxMap.style.getStyleLayers();
      expect(layers.first?.id, id);
      expect(layers.last?.id, dummyLayer.id);
    },
  );

  testWidgets('create PolylineAnnotation_manager ', skip: kIsWeb, (
    WidgetTester tester,
  ) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations
        .createPolylineAnnotationManager();

    await manager.setLineCap(LineCap.BUTT);
    var lineCap = await manager.getLineCap();
    expect(LineCap.BUTT, lineCap);

    await manager.setLineCrossSlope(1.0);
    var lineCrossSlope = await manager.getLineCrossSlope();
    expect(1.0, lineCrossSlope);

    await manager.setLineElevationGroundScale(1.0);
    var lineElevationGroundScale = await manager.getLineElevationGroundScale();
    expect(1.0, lineElevationGroundScale);

    await manager.setLineElevationReference(LineElevationReference.NONE);
    var lineElevationReference = await manager.getLineElevationReference();
    expect(LineElevationReference.NONE, lineElevationReference);

    await manager.setLineJoin(LineJoin.BEVEL);
    var lineJoin = await manager.getLineJoin();
    expect(LineJoin.BEVEL, lineJoin);

    await manager.setLineMiterLimit(1.0);
    var lineMiterLimit = await manager.getLineMiterLimit();
    expect(1.0, lineMiterLimit);

    await manager.setLineRoundLimit(1.0);
    var lineRoundLimit = await manager.getLineRoundLimit();
    expect(1.0, lineRoundLimit);

    await manager.setLineSortKey(1.0);
    var lineSortKey = await manager.getLineSortKey();
    expect(1.0, lineSortKey);

    await manager.setLineWidthUnit(LineWidthUnit.PIXELS);
    var lineWidthUnit = await manager.getLineWidthUnit();
    expect(LineWidthUnit.PIXELS, lineWidthUnit);

    await manager.setLineZOffset(1.0);
    var lineZOffset = await manager.getLineZOffset();
    expect(1.0, lineZOffset);

    await manager.setLineBlur(1.0);
    var lineBlur = await manager.getLineBlur();
    expect(1.0, lineBlur);

    await manager.setLineBorderColor(Colors.red.value);
    var lineBorderColor = await manager.getLineBorderColor();
    expect(Colors.red.value, lineBorderColor);

    await manager.setLineBorderWidth(1.0);
    var lineBorderWidth = await manager.getLineBorderWidth();
    expect(1.0, lineBorderWidth);

    await manager.setLineColor(Colors.red.value);
    var lineColor = await manager.getLineColor();
    expect(Colors.red.value, lineColor);

    await manager.setLineCutoutFadeWidth(1.0);
    var lineCutoutFadeWidth = await manager.getLineCutoutFadeWidth();
    expect(1.0, lineCutoutFadeWidth);

    await manager.setLineCutoutOpacity(1.0);
    var lineCutoutOpacity = await manager.getLineCutoutOpacity();
    expect(1.0, lineCutoutOpacity);

    await manager.setLineDasharray([1.0, 2.0]);
    var lineDasharray = await manager.getLineDasharray();
    expect([1.0, 2.0], lineDasharray);

    await manager.setLineDepthOcclusionFactor(1.0);
    var lineDepthOcclusionFactor = await manager.getLineDepthOcclusionFactor();
    expect(1.0, lineDepthOcclusionFactor);

    await manager.setLineEmissiveStrength(1.0);
    var lineEmissiveStrength = await manager.getLineEmissiveStrength();
    expect(1.0, lineEmissiveStrength);

    await manager.setLineGapWidth(1.0);
    var lineGapWidth = await manager.getLineGapWidth();
    expect(1.0, lineGapWidth);

    await manager.setLineOcclusionOpacity(1.0);
    var lineOcclusionOpacity = await manager.getLineOcclusionOpacity();
    expect(1.0, lineOcclusionOpacity);

    await manager.setLineOffset(1.0);
    var lineOffset = await manager.getLineOffset();
    expect(1.0, lineOffset);

    await manager.setLineOpacity(1.0);
    var lineOpacity = await manager.getLineOpacity();
    expect(1.0, lineOpacity);

    await manager.setLinePattern("abc");
    var linePattern = await manager.getLinePattern();
    expect("abc", linePattern);

    await manager.setLineTranslate([0.0, 1.0]);
    var lineTranslate = await manager.getLineTranslate();
    expect([0.0, 1.0], lineTranslate);

    await manager.setLineTranslateAnchor(LineTranslateAnchor.MAP);
    var lineTranslateAnchor = await manager.getLineTranslateAnchor();
    expect(LineTranslateAnchor.MAP, lineTranslateAnchor);

    await manager.setLineTrimColor(Colors.red.value);
    var lineTrimColor = await manager.getLineTrimColor();
    expect(Colors.red.value, lineTrimColor);

    await manager.setLineTrimFadeRange([0.5, 0.5]);
    var lineTrimFadeRange = await manager.getLineTrimFadeRange();
    expect([0.5, 0.5], lineTrimFadeRange);

    await manager.setLineTrimOffset([0.5, 0.5]);
    var lineTrimOffset = await manager.getLineTrimOffset();
    expect([0.5, 0.5], lineTrimOffset);

    await manager.setLineWidth(1.0);
    var lineWidth = await manager.getLineWidth();
    expect(1.0, lineWidth);
  });

  group('annotation events', () {
    late _FakePolylineAnnotationManagerPI fake;
    late PolylineAnnotationManager manager;

    setUp(() {
      fake = _FakePolylineAnnotationManagerPI();
      // ignore: invalid_use_of_internal_member
      manager = PolylineAnnotationManager(fake);
    });

    tearDown(() => fake.dispose());

    testWidgets('annotation tap events can be listened and canceled', (
      tester,
    ) async {
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

    testWidgets('annotation long press events can be listened and canceled', (
      tester,
    ) async {
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
