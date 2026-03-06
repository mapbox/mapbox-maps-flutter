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

    // Start recording
    await mapboxMap.recorder.startRecording(
      timeWindow: Duration(seconds: 60),
      loggingEnabled: false,
      compressed: true,
    );

    // Give recording a moment to initialize
    await Future.delayed(const Duration(milliseconds: 100));

    // Perform some map operations to record
    await mapboxMap.setCamera(CameraOptions(
      center: Point(coordinates: Position(-74.0060, 40.7128)),
      zoom: 12.0,
    ));
    await tester.pumpAndSettle();

    // Give the recorder time to capture the camera change
    await Future.delayed(const Duration(milliseconds: 100));

    // Stop recording and get the sequence
    final sequence = await mapboxMap.recorder.stopRecording();

    // Verify we got a non-empty sequence
    expect(sequence, isNotNull);
    expect(sequence, isA<Uint8List>());
    expect(sequence.length, greaterThan(0));
  });

  testWidgets('getState', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;

    // Get initial state (should be "stopped")
    final state = await mapboxMap.recorder.getState();
    expect(state, 'stopped');
  });

  testWidgets('replay', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;

    // Start recording
    await mapboxMap.recorder.startRecording(
      timeWindow: Duration(seconds: 60),
      loggingEnabled: false,
      compressed: true,
    );

    // Give recording a moment to initialize
    await Future.delayed(const Duration(milliseconds: 100));

    // Perform a camera movement
    await mapboxMap.setCamera(CameraOptions(
      center: Point(coordinates: Position(-73.581, 45.4588)),
      zoom: 10.0,
    ));
    await tester.pumpAndSettle();

    // Give the recorder time to capture the camera change
    await Future.delayed(const Duration(milliseconds: 100));

    // Stop recording
    final sequence = await mapboxMap.recorder.stopRecording();
    expect(sequence.length, greaterThan(0));

    // Replay the sequence
    await mapboxMap.recorder.replay(
      sequence,
      playbackCount: 1,
      playbackSpeedMultiplier: 1.0,
      avoidPlaybackPauses: false,
    );

    // Verify state after replay completes
    final stateAfterReplay = await mapboxMap.recorder.getState();
    expect(stateAfterReplay, 'stopped');
  });

  testWidgets('togglePauseReplay', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;

    // Start recording
    await mapboxMap.recorder.startRecording(
      timeWindow: Duration(seconds: 60),
      loggingEnabled: false,
      compressed: true,
    );

    // Give recording a moment to initialize
    await Future.delayed(const Duration(milliseconds: 100));

    // Perform multiple camera operations to create a longer recording
    for (int i = 0; i < 5; i++) {
      await mapboxMap.setCamera(CameraOptions(
        center: Point(
            coordinates: Position(-122.4194 + (i * 0.1), 37.7749 + (i * 0.05))),
        zoom: 11.0 + (i * 0.2),
      ));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Stop recording
    final sequence = await mapboxMap.recorder.stopRecording();
    expect(sequence.length, greaterThan(0));

    // Start replay with multiple loops and slower speed to ensure enough time
    final replayFuture = mapboxMap.recorder.replay(
      sequence,
      playbackCount: 3, // Multiple loops
      playbackSpeedMultiplier: 0.3, // Slower to give more time
      avoidPlaybackPauses: false,
    );

    // Give it a moment to start
    await Future.delayed(const Duration(milliseconds: 200));

    // Verify state is "playing"
    final playingState = await mapboxMap.recorder.getState();
    expect(playingState, 'playing');

    // Toggle pause
    await mapboxMap.recorder.togglePause();

    // Give pause a moment to take effect
    await Future.delayed(const Duration(milliseconds: 50));

    // Verify state changed to "paused"
    final pausedState = await mapboxMap.recorder.getState();
    expect(pausedState, 'paused');

    // Resume
    await mapboxMap.recorder.togglePause();

    // Check state immediately after resume, it should be "playing"
    await Future.delayed(const Duration(milliseconds: 50));
    final resumedState = await mapboxMap.recorder.getState();
    expect(resumedState, 'playing');

    // Wait for replay to complete
    await replayFuture;

    // Verify state returns to "stopped"
    final finalState = await mapboxMap.recorder.getState();
    expect(finalState, 'stopped');
  });

  testWidgets('recordingWithOptions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;

    // Test with uncompressed recording
    await mapboxMap.recorder.startRecording(
      timeWindow: Duration(seconds: 30),
      loggingEnabled: false,
      compressed: false,
    );

    // Give recording a moment to initialize
    await Future.delayed(const Duration(milliseconds: 100));

    await mapboxMap.setCamera(CameraOptions(
      center: Point(coordinates: Position(0.0, 0.0)),
      zoom: 5.0,
    ));
    await tester.pumpAndSettle();

    // Give the recorder time to capture the camera change
    await Future.delayed(const Duration(milliseconds: 100));

    final sequence = await mapboxMap.recorder.stopRecording();
    expect(sequence.length, greaterThan(0));

    // Verify we can replay the uncompressed sequence
    await mapboxMap.recorder.replay(
      sequence,
      playbackCount: 1,
      playbackSpeedMultiplier: 2.0,
      avoidPlaybackPauses: true,
    );

    // Test passed if no exception was thrown
  });
}
