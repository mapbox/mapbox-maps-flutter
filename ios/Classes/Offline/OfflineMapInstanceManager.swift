import Flutter

final class OfflineMapInstanceManager: _OfflineMapInstanceManager {
    private let binaryMessenger: FlutterBinaryMessenger
    private var proxies: [String: ProxyBinaryMessenger] = [:]

    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
    }

    func setupOfflineManager(channelSuffix: String) throws {
        let proxy = ProxyBinaryMessenger(with: binaryMessenger, channelSuffix: channelSuffix)
        let offlineController = OfflineController(proxy: proxy)
        _OfflineManagerSetup.setUp(binaryMessenger: proxy, api: offlineController)
        proxies[channelSuffix] = proxy
    }

    func tearDownOfflineManager(channelSuffix: String) throws {
        guard let proxy = proxies.removeValue(forKey: channelSuffix) else { return }
        _OfflineManagerSetup.setUp(binaryMessenger: proxy, api: nil)
    }
}
