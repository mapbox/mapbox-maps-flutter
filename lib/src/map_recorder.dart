part of mapbox_maps_flutter;

/// MapRecorder provides functions to record and replay API calls of a [MapboxMap] instance.
///
/// These recordings can be used to debug issues which require multiple steps to reproduce.
/// Additionally, playbacks can be used for performance testing custom scenarios.
///
/// **Note**: The raw format produced by [stopRecording] is experimental and there is no guarantee
/// for version cross-compatibility when feeding it to [replay].
///
/// **Warning**: This API is experimental and may change in future releases.
///
/// **Example**:
/// ```dart
/// // Start recording
/// await mapboxMap.recorder.startRecording(
///   timeWindow: 60000, // 60 seconds
///   loggingEnabled: true,
///   compressed: true,
/// );
///
/// // ... perform some map interactions ...
///
/// // Stop recording and get the recorded sequence
/// final recordedSequence = await mapboxMap.recorder.stopRecording();
///
/// // Replay the sequence twice at 2x speed
/// await mapboxMap.recorder.replay(
///   recordedSequence,
///   playbackCount: 2,
///   playbackSpeedMultiplier: 2.0,
///   avoidPlaybackPauses: false,
/// );
/// ```
@experimental
class MapRecorder {
  final _MapRecorderMessenger _messenger;

  MapRecorder._(this._messenger);

  /// Begins the recording session.
  ///
  /// [timeWindow] - The maximum duration (in milliseconds) from the current time until API calls are kept.
  /// If not specified, all API calls will be kept during the recording, which can lead to significant memory consumption for long sessions.
  ///
  /// [loggingEnabled] - If set to true, the recorded API calls will be printed in the logs. Default value: false.
  ///
  /// [compressed] - If set to true, the recorded output will be compressed with gzip. Default value: false.
  Future<void> startRecording({
    int? timeWindow,
    bool loggingEnabled = false,
    bool compressed = false,
  }) {
    return _messenger.startRecording(
      MapRecorderOptions(
        timeWindow: timeWindow,
        loggingEnabled: loggingEnabled,
        compressed: compressed,
      ),
    );
  }

  /// Stops the current recording session.
  ///
  /// Recorded section can be replayed with [replay] method.
  /// Returns a [Uint8List] containing the recorded sequence in raw format.
  Future<Uint8List> stopRecording() {
    return _messenger.stopRecording();
  }

  /// Replay a supplied sequence.
  ///
  /// [recordedSequence] - Sequence recorded with [stopRecording] method.
  ///
  /// [playbackCount] - The number of times the sequence is played. If negative, the playback loops indefinitely. Default value: 1.
  ///
  /// [playbackSpeedMultiplier] - Multiplies the speed of playback for faster or slower replays. 1.0 means no change. Default value: 1.0.
  ///
  /// [avoidPlaybackPauses] - When set to true, the player will try to interpolate actions between short wait actions,
  /// to continuously render during the playback. This can help to maintain a consistent load during performance testing. Default value: false.
  Future<void> replay(
    Uint8List recordedSequence, {
    int playbackCount = 1,
    double playbackSpeedMultiplier = 1.0,
    bool avoidPlaybackPauses = false,
  }) {
    return _messenger.replay(
      recordedSequence,
      MapPlayerOptions(
        playbackCount: playbackCount,
        playbackSpeedMultiplier: playbackSpeedMultiplier,
        avoidPlaybackPauses: avoidPlaybackPauses,
      ),
    );
  }

  /// Temporarily pauses or resumes playback if already paused.
  Future<void> togglePause() {
    return _messenger.togglePauseReplay();
  }

  /// Returns the string description of the current state of playback (e.g., "IDLE", "PLAYING", "PAUSED").
  Future<String> getState() {
    return _messenger.getPlaybackState();
  }
}
