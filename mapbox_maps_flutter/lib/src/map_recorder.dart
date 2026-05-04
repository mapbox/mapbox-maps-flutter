import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

/// Records and replays API calls on a map instance.
///
/// Recordings can be used to debug issues that require multiple steps to
/// reproduce. Playbacks can also be used for performance testing of custom
/// scenarios.
///
/// Note: the raw format produced by [stopRecording] is experimental and
/// there is no guarantee of version cross-compatibility when feeding it to
/// [replay].
@experimental
class MapRecorder {
  final MapRecorderPlatformInterface _impl;

  @internal
  MapRecorder(this._impl);

  /// Begins a recording session.
  ///
  /// [timeWindow] caps how much of the recent API history is retained.
  /// When null, the entire session is kept in memory.
  /// [loggingEnabled] prints recorded calls to logs.
  /// [compressed] gzips the output of [stopRecording].
  Future<void> startRecording({
    Duration? timeWindow,
    bool loggingEnabled = false,
    bool compressed = false,
  }) => _impl.startRecording(
    timeWindow: timeWindow?.inMilliseconds,
    loggingEnabled: loggingEnabled,
    compressed: compressed,
  );

  /// Stops the current recording session and returns the serialized sequence.
  Future<Uint8List> stopRecording() => _impl.stopRecording();

  /// Replays a previously-recorded sequence.
  Future<void> replay(
    Uint8List recordedSequence, {
    int playbackCount = 1,
    double playbackSpeedMultiplier = 1.0,
    bool avoidPlaybackPauses = false,
  }) => _impl.replay(
    recordedSequence,
    playbackCount: playbackCount,
    playbackSpeedMultiplier: playbackSpeedMultiplier,
    avoidPlaybackPauses: avoidPlaybackPauses,
  );

  /// Pauses or resumes playback.
  Future<void> togglePause() => _impl.togglePause();

  /// Returns a string description of the current playback state.
  Future<String> getState() => _impl.getState();
}
