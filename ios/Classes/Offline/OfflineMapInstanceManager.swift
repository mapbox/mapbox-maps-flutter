import Flutter

final class OfflineMapInstanceManager: _OfflineMapInstanceManager {
    private let binaryMessenger: FlutterBinaryMessenger

    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
    }

    func setupOfflineManager(channelSuffix: String) throws {
        let offlineController = OfflineController()
        _OfflineManagerSetup.setUp(binaryMessenger: binaryMessenger, api: offlineController, messageChannelSuffix: channelSuffix)
    }

    func tearDownOfflineManager(channelSuffix: String) throws {
        _OfflineManagerSetup.setUp(binaryMessenger: binaryMessenger, api: nil, messageChannelSuffix: channelSuffix)
    }
}
