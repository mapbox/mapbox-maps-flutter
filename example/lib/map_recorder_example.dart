import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

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
  bool isRecording = false;
  bool isReplaying = false;
  String playbackState = 'IDLE';

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  Future<void> _startRecording() async {
    if (mapboxMap == null) return;

    setState(() {
      isRecording = true;
      recordedSequence = null;
    });

    try {
      await mapboxMap!.recorder.startRecording(
        timeWindow: 60000, // Keep last 60 seconds
        loggingEnabled: true,
        compressed: true,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording started. Interact with the map!'),
          duration: Duration(seconds: 2),
        ),
      );

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting recording: $e')),
      );
      setState(() {
        isRecording = false;
      });
    }
  }

  Future<void> _stopRecording() async {
    if (mapboxMap == null) return;

    try {
      final sequence = await mapboxMap!.recorder.stopRecording();
      setState(() {
        isRecording = false;
        recordedSequence = sequence;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recording stopped. ${sequence.length} bytes recorded.'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error stopping recording: $e')),
      );
      setState(() {
        isRecording = false;
      });
    }
  }

  Future<void> _replayRecording() async {
    if (mapboxMap == null || recordedSequence == null) return;

    setState(() {
      isReplaying = true;
    });

    try {
      // Replay twice at 2x speed
      await mapboxMap!.recorder.replay(
        recordedSequence!,
        playbackCount: 2,
        playbackSpeedMultiplier: 2.0,
        avoidPlaybackPauses: false,
      );

      setState(() {
        isReplaying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Replay completed!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Get final playback state
      final state = await mapboxMap!.recorder.getState();
      setState(() {
        playbackState = state;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during replay: $e')),
      );
      setState(() {
        isReplaying = false;
      });
    }
  }

  Future<void> _togglePause() async {
    if (mapboxMap == null) return;

    try {
      await mapboxMap!.recorder.togglePause();
      final state = await mapboxMap!.recorder.getState();
      setState(() {
        playbackState = state;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Playback state: $state'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error toggling pause: $e')),
      );
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
                  'Status: ${isRecording ? "Recording..." : isReplaying ? "Replaying..." : "Idle"}',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Playback State: $playbackState',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isRecording || isReplaying
                            ? null
                            : _startRecording,
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
                        onPressed:
                            isRecording && !isReplaying ? _stopRecording : null,
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
                                !isRecording &&
                                !isReplaying
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
                        onPressed: isReplaying ? _togglePause : null,
                        icon: const Icon(Icons.pause),
                        label: const Text('Pause'),
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
