// This file is generated.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PolygonAnnotationManager custom id and position',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final dummyLayer = FillLayer(id: "dummyLayer", sourceId: 'sourceId');
    await mapboxMap.style.addLayer(dummyLayer);
    final id = "PolygonAnnotationManagerId";
    final manager = await mapboxMap.annotations
        .createPolygonAnnotationManager(id: id, below: 'dummyLayer');

    expect(await mapboxMap.style.styleLayerExists(id), isTrue);
    expect(await mapboxMap.style.styleSourceExists(id), isTrue);
    expect(manager.id, id);
    final layers = await mapboxMap.style.getStyleLayers();
    expect(layers.first?.id, id);
    expect(layers.last?.id, dummyLayer.id);
  });

  testWidgets('create PolygonAnnotation_manager ', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager =
        await mapboxMap.annotations.createPolygonAnnotationManager();

    await manager.setFillElevationReference(FillElevationReference.NONE);
    var fillElevationReference = await manager.getFillElevationReference();
    expect(FillElevationReference.NONE, fillElevationReference);

    await manager.setFillSortKey(1.0);
    var fillSortKey = await manager.getFillSortKey();
    expect(1.0, fillSortKey);

    await manager.setFillAntialias(true);
    var fillAntialias = await manager.getFillAntialias();
    expect(true, fillAntialias);

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

    await manager.setFillZOffset(1.0);
    var fillZOffset = await manager.getFillZOffset();
    expect(1.0, fillZOffset);
  });

  testWidgets('annotation drag events', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;
    final manager =
        await mapboxMap.annotations.createPolygonAnnotationManager();

    final geometry = Polygon(coordinates: [
      [
        Position(0, 0),
        Position(1.754703, -19.716317),
        Position(-15.747196, -21.085074),
        Position(-3.363937, -10.733102)
      ]
    ]);

    final createdAnnotation = await manager.create(PolygonAnnotationOptions(
      geometry: geometry,
      isDraggable: true,
    ));

    // Mock drag events
    final eventChannel = EventChannel(
        "dev.flutter.pigeon.mapbox_maps_flutter.AnnotationInteractions._annotationDragEvents.0/${manager.id}",
        pigeonMethodCodec);
    IntegrationTestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(eventChannel,
            MockStreamHandler.inline(onListen: (arguments, events) {
      events.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.started,
      ));
      events.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.changed,
      ));
      events.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.ended,
      ));
      events.endOfStream();
    }));

    final onDragBegin = Completer();
    final onDragChanged = Completer();
    final onDragEnd = Completer();

    manager.dragEvents(
      onBegin: (annotation) {
        expect(annotation.id, equals(createdAnnotation.id));
        onDragBegin.complete();
      },
      onChanged: (annotation) {
        expect(annotation.id, equals(createdAnnotation.id));
        onDragChanged.complete();
      },
      onEnd: (annotation) {
        expect(annotation.id, equals(createdAnnotation.id));
        onDragEnd.complete();
      },
    );

    await Future.wait(
        [onDragBegin.future, onDragChanged.future, onDragEnd.future]);
  });
}
// End of generated file.
