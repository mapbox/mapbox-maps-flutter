import Flutter
import MapboxMaps

final class OfflineMapInstanceManager: _OfflineMapInstanceManager, _TileStoreInstanceManager {
    enum `Error`: Swift.Error {
        case invalidTileStorePath
    }

    private let binaryMessenger: FlutterBinaryMessenger
    private var proxies: [String: ProxyBinaryMessenger] = [:]

    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
    }

    func setupOfflineManager(channelSuffix: String) throws {
        let proxy = ProxyBinaryMessenger(with: binaryMessenger, channelSuffix: channelSuffix)
        let offlineController = OfflineController(messenger: binaryMessenger)
        _OfflineManagerSetup.setUp(binaryMessenger: proxy, api: offlineController)
        proxies["offline-manager/\(channelSuffix)"] = proxy
    }

    func tearDownOfflineManager(channelSuffix: String) throws {
        guard let proxy = proxies.removeValue(forKey: "offline-manager/\(channelSuffix)") else { return }
        _OfflineManagerSetup.setUp(binaryMessenger: proxy, api: nil)
    }

    func setupTileStore(channelSuffix: String, filePath: String?) throws {
        let proxy = ProxyBinaryMessenger(with: binaryMessenger, channelSuffix: channelSuffix)
        let tileStore: TileStore
        if let filePath {
            tileStore = .shared(for: URL(fileURLWithPath: filePath))
        } else {
            tileStore = .default
        }

        MapboxMapsOptions.tileStore = tileStore
        let tileStoreController = TileStoreController(proxy: proxy, tileStore: tileStore)

        _TileStoreSetup.setUp(binaryMessenger: proxy, api: tileStoreController)
        proxies["tilestore/\(channelSuffix)"] = proxy
    }

    func tearDownTileStore(channelSuffix: String) throws {
        guard let proxy = proxies.removeValue(forKey: "tilestore/\(channelSuffix)") else { return }
        _TileStoreSetup.setUp(binaryMessenger: proxy, api: nil)
        MapboxMapsOptions.tileStore = nil
    }
}
