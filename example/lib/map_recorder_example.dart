import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

/// Represents the current state of the map recorder.
enum RecorderState {
  idle,
  recording,
  replaying,
  replayingPaused,
}

/// Example demonstrating the MapRecorder functionality.
///
/// MapRecorder allows you to record and replay map interactions,
/// which is useful for debugging and performance testing.
class MapRecorderExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.fiber_smart_record);
  @override
  final String title = 'Map Recorder';
  @override
  final String? subtitle = 'Record and replay map sessions';

  @override
  State<StatefulWidget> createState() => MapRecorderExampleState();
}

class MapRecorderExampleState extends State<MapRecorderExample> {
  MapboxMap? mapboxMap;
  Uint8List? recordedSequence;
  RecorderState state = RecorderState.idle;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  Future<void> _startRecording() async {
    if (mapboxMap == null) return;

    if (mounted) {
      setState(() {
        state = RecorderState.recording;
        recordedSequence = null;
      });
    }

    try {
      await mapboxMap!.recorder.startRecording(
        timeWindow: 60000, // Keep last 60 seconds
        loggingEnabled: true,
        compressed: true,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recording started. Interact with the map!'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Perform some camera animations to record
      await Future.delayed(const Duration(milliseconds: 500));
      await mapboxMap!.flyTo(
        CameraOptions(
          center: Point(coordinates: Position(-73.581, 45.4588)),
          zoom: 11.0,
          pitch: 35.0,
          bearing: 90.0,
        ),
        MapAnimationOptions(duration: 5000, startDelay: 0),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting recording: $e')),
        );
        setState(() {
          state = RecorderState.idle;
        });
      }
    }
  }

  Future<void> _stopRecording() async {
    if (mapboxMap == null) return;

    try {
      final sequence = await mapboxMap!.recorder.stopRecording();
      if (mounted) {
        setState(() {
          state = RecorderState.idle;
          recordedSequence = sequence;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Recording stopped. ${sequence.length} bytes recorded.'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error stopping recording: $e')),
        );
        setState(() {
          state = RecorderState.idle;
        });
      }
    }
  }

  Future<void> _replayRecording() async {
    if (mapboxMap == null || recordedSequence == null) return;

    if (mounted) {
      setState(() {
        state = RecorderState.replaying;
      });
    }

    try {
      // Replay twice at 2x speed
      await mapboxMap!.recorder.replay(
        recordedSequence!,
        playbackCount: 2,
        playbackSpeedMultiplier: 2.0,
        avoidPlaybackPauses: false,
      );

      if (mounted) {
        setState(() {
          state = RecorderState.idle;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Replay completed!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during replay: $e')),
        );
        setState(() {
          state = RecorderState.idle;
        });
      }
    }
  }

  Future<void> _togglePause() async {
    if (mapboxMap == null) return;

    try {
      await mapboxMap!.recorder.togglePause();
      final playbackState = await mapboxMap!.recorder.getState();

      if (mounted) {
        setState(() {
          state = playbackState.contains('paused')
              ? RecorderState.replayingPaused
              : RecorderState.replaying;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Playback ${state == RecorderState.replayingPaused ? "paused" : "resumed"}'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error toggling pause: $e')),
        );
      }
    }
  }

  String _getStatusText() {
    switch (state) {
      case RecorderState.idle:
        return 'Idle';
      case RecorderState.recording:
        return 'Recording...';
      case RecorderState.replaying:
        return 'Replaying...';
      case RecorderState.replayingPaused:
        return 'Replay Paused';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MapWidget(
              key: const ValueKey("mapWidget"),
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(-74.0060, 40.7128)),
                zoom: 10.0,
              ),
              styleUri: MapboxStyles.STANDARD,
              onMapCreated: _onMapCreated,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Status: ${_getStatusText()}',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: state == RecorderState.idle
                            ? _startRecording
                            : null,
                        icon: const Icon(Icons.fiber_manual_record),
                        label: const Text('Record'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: state == RecorderState.recording
                            ? _stopRecording
                            : null,
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: recordedSequence != null &&
                                state == RecorderState.idle
                            ? _replayRecording
                            : null,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Replay 2x'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: state == RecorderState.replaying ||
                                state == RecorderState.replayingPaused
                            ? _togglePause
                            : null,
                        icon: Icon(
                          state == RecorderState.replayingPaused
                              ? Icons.play_arrow
                              : Icons.pause,
                        ),
                        label: Text(
                          state == RecorderState.replayingPaused
                              ? 'Resume'
                              : 'Pause',
                        ),
                      ),
                    ),
                  ],
                ),
                if (recordedSequence != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Recorded: ${(recordedSequence!.length / 1024).toStringAsFixed(2)} KB',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
