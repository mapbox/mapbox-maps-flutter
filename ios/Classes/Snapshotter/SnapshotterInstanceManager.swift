import Foundation
import MapboxMaps
import Flutter

final class SnapshotterInstanceManager: _SnapshotterInstanceManager {
    private let binaryMessenger: FlutterBinaryMessenger
    private var proxyMessengers = [String: ProxyBinaryMessenger]()

    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
    }

    func setupSnapshotterForSuffix(suffix: String, eventTypes: [Int64], options: MapSnapshotOptions) throws {
        let snapshotter = Snapshotter(options: options.toMapSnapshotOptions())

        let proxyMessenger = ProxyBinaryMessenger(with: binaryMessenger, channelSuffix: suffix)
        let snapshotterController = SnapshotterController(
            snapshotter: snapshotter,
            eventTypes: eventTypes.map(Int.init),
            binaryMessenger: proxyMessenger
        )
        let snapshotStyleController = StyleController(styleManager: snapshotter)

        _SnapshotterMessengerSetup.setUp(binaryMessenger: proxyMessenger, api: snapshotterController)
        StyleManagerSetup.setUp(binaryMessenger: proxyMessenger, api: snapshotStyleController)

        proxyMessengers[suffix] = proxyMessenger
    }

    func tearDownSnapshotterForSuffix(suffix: String) throws {
        guard let proxyMessenger = proxyMessengers.removeValue(forKey: suffix) else {
            return
        }

        StyleManagerSetup.setUp(binaryMessenger: proxyMessenger, api: nil)
        _SnapshotterMessengerSetup.setUp(binaryMessenger: proxyMessenger, api: nil)
    }
}
