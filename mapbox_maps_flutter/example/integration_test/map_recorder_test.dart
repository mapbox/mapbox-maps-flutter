import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('startRecording', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;

    await mapboxMap.mapRecorder.startRecording(
      timeWindow: const Duration(seconds: 60),
      loggingEnabled: false,
      compressed: true,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    await mapboxMap.setCamera(
      CameraOptions(
        center: Point(coordinates: Position(-74.0060, 40.7128)),
        zoom: 12.0,
      ),
    );
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(milliseconds: 100));

    final sequence = await mapboxMap.mapRecorder.stopRecording();

    expect(sequence, isNotNull);
    expect(sequence, isA<Uint8List>());
    expect(sequence.length, greaterThan(0));
  });

  testWidgets('getState', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;

    final state = await mapboxMap.mapRecorder.getState();
    expect(state, 'stopped');
  });

  testWidgets('replay', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;

    await mapboxMap.mapRecorder.startRecording(
      timeWindow: const Duration(seconds: 60),
      loggingEnabled: false,
      compressed: true,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    await mapboxMap.setCamera(
      CameraOptions(
        center: Point(coordinates: Position(-73.581, 45.4588)),
        zoom: 10.0,
      ),
    );
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(milliseconds: 100));

    final sequence = await mapboxMap.mapRecorder.stopRecording();
    expect(sequence.length, greaterThan(0));

    await mapboxMap.mapRecorder.replay(
      sequence,
      playbackCount: 1,
      playbackSpeedMultiplier: 1.0,
      avoidPlaybackPauses: false,
    );

    final stateAfterReplay = await mapboxMap.mapRecorder.getState();
    expect(stateAfterReplay, 'stopped');
  });

  testWidgets('togglePause', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;

    await mapboxMap.mapRecorder.startRecording(
      timeWindow: const Duration(seconds: 60),
      loggingEnabled: false,
      compressed: true,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    for (int i = 0; i < 5; i++) {
      await mapboxMap.setCamera(
        CameraOptions(
          center: Point(
            coordinates: Position(-122.4194 + (i * 0.1), 37.7749 + (i * 0.05)),
          ),
          zoom: 11.0 + (i * 0.2),
        ),
      );
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final sequence = await mapboxMap.mapRecorder.stopRecording();
    expect(sequence.length, greaterThan(0));

    final replayFuture = mapboxMap.mapRecorder.replay(
      sequence,
      playbackCount: 3,
      playbackSpeedMultiplier: 0.3,
      avoidPlaybackPauses: false,
    );

    await Future.delayed(const Duration(milliseconds: 200));

    final playingState = await mapboxMap.mapRecorder.getState();
    expect(playingState, 'playing');

    await mapboxMap.mapRecorder.togglePause();

    await Future.delayed(const Duration(milliseconds: 50));

    final pausedState = await mapboxMap.mapRecorder.getState();
    expect(pausedState, 'paused');

    await mapboxMap.mapRecorder.togglePause();

    await Future.delayed(const Duration(milliseconds: 50));
    final resumedState = await mapboxMap.mapRecorder.getState();
    expect(resumedState, 'playing');

    await replayFuture;

    final finalState = await mapboxMap.mapRecorder.getState();
    expect(finalState, 'stopped');
  });

  testWidgets('recordingWithOptions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;

    await mapboxMap.mapRecorder.startRecording(
      timeWindow: const Duration(seconds: 30),
      loggingEnabled: false,
      compressed: false,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    await mapboxMap.setCamera(
      CameraOptions(center: Point(coordinates: Position(0.0, 0.0)), zoom: 5.0),
    );
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(milliseconds: 100));

    final sequence = await mapboxMap.mapRecorder.stopRecording();
    expect(sequence.length, greaterThan(0));

    await mapboxMap.mapRecorder.replay(
      sequence,
      playbackCount: 1,
      playbackSpeedMultiplier: 2.0,
      avoidPlaybackPauses: true,
    );
  });
}
