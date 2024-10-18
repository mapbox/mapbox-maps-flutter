import Foundation
@_spi(Experimental) import MapboxMaps
import Flutter

final class SnapshotterController: _SnapshotterMessenger {
    enum Error: Swift.Error {
        case imageConversionFailed
    }

    private var snapshotter: Snapshotter!
    private let eventHandler: MapboxEventHandler

    init(snapshotter: Snapshotter, eventTypes: [Int], binaryMessenger: FlutterBinaryMessenger, channelSuffix: String) {
        self.snapshotter = snapshotter

        eventHandler = MapboxEventHandler(
            eventProvider: snapshotter,
            binaryMessenger: binaryMessenger,
            eventTypes: eventTypes,
            channelSuffix: channelSuffix
        )
    }

    func getCameraState() throws -> CameraState {
        return snapshotter.cameraState.toFLTCameraState()
    }

    func setCamera(cameraOptions: CameraOptions) throws {
        snapshotter.setCamera(to: cameraOptions.toCameraOptions())
    }

    func setSize(size: Size) throws {
        snapshotter.snapshotSize = size.toCGSize()
    }

    func getSize() throws -> Size {
        return snapshotter.snapshotSize.toFLTSize()
    }

    func start(completion: @escaping (Result<FlutterStandardTypedData?, any Swift.Error>) -> Void) {
        snapshotter.start(overlayHandler: nil) { result in
            switch result {
            case .success(let image):
                if let imageData = image.pngData() {
                    completion(.success(.init(bytes: imageData)))
                } else {
                    completion(.failure(Error.imageConversionFailed))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }

    func cancel() throws {
        snapshotter.cancel()
    }

    func coordinateBounds(camera: CameraOptions) throws -> CoordinateBounds {
        return snapshotter.coordinateBounds(for: camera.toCameraOptions()).toFLTCoordinateBounds()
    }

    func camera(coordinates: [Turf.Point], padding: MbxEdgeInsets?, bearing: Double?, pitch: Double?) throws -> CameraOptions {
        return snapshotter.camera(
            for: coordinates.map(\.coordinates),
            padding: padding?.toUIEdgeInsets(),
            bearing: bearing,
            pitch: pitch
        ).toFLTCameraOptions()
    }

    func tileCover(options: TileCoverOptions) throws -> [CanonicalTileID] {
        return snapshotter.tileCover(for: options.toTileCoverOptions())
            .map { $0.toFLTCanonicalTileID() }
    }

    func clearData(completion: @escaping (Result<Void, any Swift.Error>) -> Void) {
        do {
            snapshotter.clearData { error in
                if let error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}
