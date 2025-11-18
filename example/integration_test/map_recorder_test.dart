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
      timeWindow: 60000,
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

    // Get initial state (should be IDLE)
    final state = await mapboxMap.recorder.getState();
    expect(state, isNotNull);
    expect(state, isA<String>());
    expect(state.isNotEmpty, true);
  });

  testWidgets('replay', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;

    // Start recording
    await mapboxMap.recorder.startRecording(
      timeWindow: 60000,
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

    // Test passed if no exception was thrown
  });

  testWidgets('togglePauseReplay', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;

    // Start recording
    await mapboxMap.recorder.startRecording(
      timeWindow: 60000,
      loggingEnabled: false,
      compressed: true,
    );

    // Perform some camera operations
    await mapboxMap.setCamera(CameraOptions(
      center: Point(coordinates: Position(-122.4194, 37.7749)),
      zoom: 11.0,
    ));
    await tester.pumpAndSettle();

    await mapboxMap.setCamera(CameraOptions(
      center: Point(coordinates: Position(-118.2437, 34.0522)),
      zoom: 10.0,
    ));
    await tester.pumpAndSettle();

    // Stop recording
    final sequence = await mapboxMap.recorder.stopRecording();
    expect(sequence.length, greaterThan(0));

    // Start replay (don't await - we want to pause it)
    final replayFuture = mapboxMap.recorder.replay(
      sequence,
      playbackCount: 1,
      playbackSpeedMultiplier: 0.5, // Slow down to give time to pause
      avoidPlaybackPauses: false,
    );

    // Give it a moment to start
    await Future.delayed(const Duration(milliseconds: 100));

    // Toggle pause
    await mapboxMap.recorder.togglePause();

    // Verify state changed to paused
    final pausedState = await mapboxMap.recorder.getState();
    expect(pausedState.toUpperCase().contains('PAUSED'), true);

    // Resume
    await mapboxMap.recorder.togglePause();

    // Wait for replay to complete
    await replayFuture;

    // Test passed if no exception was thrown
  });

  testWidgets('recordingWithOptions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;

    // Test with uncompressed recording
    await mapboxMap.recorder.startRecording(
      timeWindow: 30000,
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
