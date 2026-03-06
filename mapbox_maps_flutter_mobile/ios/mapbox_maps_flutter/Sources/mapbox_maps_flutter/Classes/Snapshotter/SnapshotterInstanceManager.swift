import Foundation
import MapboxMaps
import Flutter

final class SnapshotterInstanceManager: _SnapshotterInstanceManager {
    private let binaryMessenger: FlutterBinaryMessenger

    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
    }

    func setupSnapshotterForSuffix(suffix: String, eventTypes: [Int64], options: MapSnapshotOptions) throws {
        let snapshotter = Snapshotter(options: options.toMapSnapshotOptions())

        let snapshotterController = SnapshotterController(
            snapshotter: snapshotter,
            eventTypes: eventTypes.map(Int.init),
            binaryMessenger: binaryMessenger,
            channelSuffix: suffix
        )
        let snapshotStyleController = StyleController(styleManager: snapshotter)

        _SnapshotterMessengerSetup.setUp(binaryMessenger: binaryMessenger, api: snapshotterController, messageChannelSuffix: suffix)
        StyleManagerSetup.setUp(binaryMessenger: binaryMessenger, api: snapshotStyleController, messageChannelSuffix: suffix)

    }

    func tearDownSnapshotterForSuffix(suffix: String) throws {
        StyleManagerSetup.setUp(binaryMessenger: binaryMessenger, api: nil, messageChannelSuffix: suffix)
        _SnapshotterMessengerSetup.setUp(binaryMessenger: binaryMessenger, api: nil, messageChannelSuffix: suffix)
    }
}
