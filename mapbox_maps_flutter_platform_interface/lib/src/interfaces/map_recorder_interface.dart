import 'dart:typed_data';

/// MapRecorder provides functions to record and replay API calls of a map instance.
///
/// These recordings can be used to debug issues which require multiple steps to reproduce.
/// Playbacks can also be used for performance testing custom scenarios.
///
/// Note: the raw format produced by [stopRecording] is experimental and there is no
/// guarantee of version cross-compatibility when feeding it to [replay].
abstract interface class MapRecorderPlatformInterface {
  /// Begins a recording session.
  ///
  /// [timeWindow] caps how much of the recent API history is retained, in
  /// milliseconds. When null, the entire session is kept in memory.
  /// [loggingEnabled] prints recorded calls to logs.
  /// [compressed] gzips the output of [stopRecording].
  Future<void> startRecording({
    int? timeWindow,
    required bool loggingEnabled,
    required bool compressed,
  });

  /// Stops the current recording session and returns the serialized sequence.
  Future<Uint8List> stopRecording();

  /// Replays a previously-recorded sequence.
  Future<void> replay(
    Uint8List recordedSequence, {
    required int playbackCount,
    required double playbackSpeedMultiplier,
    required bool avoidPlaybackPauses,
  });

  /// Pauses or resumes playback.
  Future<void> togglePause();

  /// Returns a string description of the current playback state.
  Future<String> getState();
}
