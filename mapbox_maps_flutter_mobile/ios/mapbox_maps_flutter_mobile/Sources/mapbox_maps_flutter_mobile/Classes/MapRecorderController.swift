import Foundation
@_spi(Experimental) import MapboxMaps
import Flutter

/// Controller for MapRecorder functionality.
///
/// Provides functions to record and replay API calls of a MapboxMap instance.
/// These recordings can be used to debug issues which require multiple steps to reproduce.
/// Additionally, playbacks can be used for performance testing custom scenarios.
class MapRecorderController: _MapRecorderMessenger {
    private let mapboxMap: MapboxMap
    private var recorder: MapRecorder?

    init(mapboxMap: MapboxMap) {
        self.mapboxMap = mapboxMap
    }

    /// Get or create the recorder instance.
    private func getRecorder() throws -> MapRecorder {
        if recorder == nil {
            recorder = try mapboxMap.makeRecorder()
        }
        return recorder!
    }

    func startRecording(timeWindow: Int64?, loggingEnabled: Bool, compressed: Bool) throws {
        let nativeOptions = MapboxMaps.MapRecorderOptions(
            timeWindow: timeWindow.map { Int($0) },
            loggingEnabled: loggingEnabled,
            compressed: compressed
        )

        try getRecorder().start(options: nativeOptions)
    }

    func stopRecording(completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
        do {
            let data = try getRecorder().stop()
            let typedData = FlutterStandardTypedData(bytes: data)
            completion(.success(typedData))
        } catch {
            completion(.failure(error))
        }
    }

    func replay(
        recordedSequence: FlutterStandardTypedData,
        playbackCount: Int64,
        playbackSpeedMultiplier: Double,
        avoidPlaybackPauses: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        do {
            let nativeOptions = MapboxMaps.MapPlayerOptions(
                playbackCount: Int(playbackCount),
                playbackSpeedMultiplier: playbackSpeedMultiplier,
                avoidPlaybackPauses: avoidPlaybackPauses
            )

            try getRecorder().replay(
                recordedSequence: recordedSequence.data,
                options: nativeOptions
            ) {
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func togglePause() throws {
        try getRecorder().togglePauseReplay()
    }

    func getState() throws -> String {
        return try getRecorder().playbackState()
    }
}
