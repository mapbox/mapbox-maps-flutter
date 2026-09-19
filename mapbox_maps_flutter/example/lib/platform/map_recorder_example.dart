// ignore_for_file: experimental_member_use

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

enum RecorderState { idle, recording, replaying, replayingPaused }

/// Records and replays map interactions, which is useful when debugging or
/// performance testing.
class MapRecorderExample extends StatefulWidget {
  const MapRecorderExample({super.key});

  @override
  State<MapRecorderExample> createState() => _MapRecorderExampleState();
}

class _MapRecorderExampleState extends State<MapRecorderExample> {
  MapboxMap? _mapboxMap;
  Uint8List? _recordedSequence;
  RecorderState _state = RecorderState.idle;

  void _onMapCreated(MapboxMap mapboxMap) {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
  }

  @override
  void dispose() {
    final map = _mapboxMap;
    if (map != null && _state == RecorderState.recording) {
      map.recorder.stopRecording();
    } else if (map != null && _state == RecorderState.replaying) {
      map.recorder.togglePause();
    }
    super.dispose();
  }

  void _snack(String message, {int seconds = 2}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds),
      ),
    );
  }

  /// Reports a failed recorder call and returns the controls to idle.
  void _fail(String message) {
    if (!mounted) return;
    _snack(message);
    setState(() => _state = RecorderState.idle);
  }

  Future<void> _startRecording() async {
    final map = _mapboxMap;
    if (map == null) return;

    setState(() {
      _state = RecorderState.recording;
      _recordedSequence = null;
    });

    try {
      await map.recorder.startRecording(
        timeWindow: const Duration(seconds: 60),
        loggingEnabled: true,
        compressed: true,
      );
      _snack('Recording started. Interact with the map!');
    } catch (e) {
      _fail('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    final map = _mapboxMap;
    if (map == null) return;

    try {
      final sequence = await map.recorder.stopRecording();
      if (!mounted) return;
      setState(() {
        _state = RecorderState.idle;
        _recordedSequence = sequence;
      });
      _snack('Recording stopped. ${sequence.length} bytes recorded.');
    } catch (e) {
      _fail('Error stopping recording: $e');
    }
  }

  Future<void> _replayRecording() async {
    final map = _mapboxMap;
    final sequence = _recordedSequence;
    if (map == null || sequence == null) return;

    setState(() => _state = RecorderState.replaying);

    try {
      await map.recorder.replay(
        sequence,
        playbackCount: 2,
        playbackSpeedMultiplier: 2.0,
        avoidPlaybackPauses: false,
      );
      if (!mounted) return;
      setState(() => _state = RecorderState.idle);
      _snack('Replay completed!');
    } catch (e) {
      _fail('Error during replay: $e');
    }
  }

  Future<void> _togglePause() async {
    final map = _mapboxMap;
    if (map == null) return;

    try {
      await map.recorder.togglePause();
      final playbackState = await map.recorder.getState();
      if (!mounted) return;
      final paused = playbackState == 'paused';
      setState(() {
        _state = paused
            ? RecorderState.replayingPaused
            : RecorderState.replaying;
      });
      _snack('Playback ${paused ? 'paused' : 'resumed'}', seconds: 1);
    } catch (e) {
      if (mounted) _snack('Error toggling pause: $e');
    }
  }

  String get _statusText => switch (_state) {
    RecorderState.idle => 'Idle',
    RecorderState.recording => 'Recording...',
    RecorderState.replaying => 'Replaying...',
    RecorderState.replayingPaused => 'Replay Paused',
  };

  @override
  Widget build(BuildContext context) {
    final idle = _state == RecorderState.idle;
    final replaying =
        _state == RecorderState.replaying ||
        _state == RecorderState.replayingPaused;
    final recorded = _recordedSequence;

    return MapScaffold(
      controlsTitle: 'Recorder',
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: MapWidget(
        key: const ValueKey('mapWidget'),
        viewport: CameraViewportState(
          center: Point(coordinates: Position(-74.0060, 40.7128)),
          zoom: 10.0,
        ),
        styleUri: MapboxStyles.STANDARD,
        onMapCreated: _onMapCreated,
      ),
      controlsBuilder: () => [
        ControlRow(
          label: 'Status',
          child: Text(
            _statusText,
            style: const TextStyle(fontSize: 13, color: MapboxGlass.label),
          ),
        ),
        ControlAction(
          label: 'Record',
          icon: Icons.fiber_manual_record,
          onPressed: idle ? _startRecording : null,
        ),
        ControlAction(
          label: 'Stop',
          icon: Icons.stop,
          onPressed: _state == RecorderState.recording ? _stopRecording : null,
        ),
        ControlAction(
          label: 'Replay at 2x',
          icon: Icons.play_arrow,
          onPressed: recorded != null && idle ? _replayRecording : null,
        ),
        ControlAction(
          label: _state == RecorderState.replayingPaused ? 'Resume' : 'Pause',
          icon: _state == RecorderState.replayingPaused
              ? Icons.play_arrow
              : Icons.pause,
          onPressed: replaying ? _togglePause : null,
        ),
        if (recorded != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Recorded ${(recorded.length / 1024).toStringAsFixed(2)} KB',
              style: const TextStyle(
                fontSize: 11,
                color: MapboxGlass.labelFaint,
              ),
            ),
          ),
      ],
    );
  }
}
