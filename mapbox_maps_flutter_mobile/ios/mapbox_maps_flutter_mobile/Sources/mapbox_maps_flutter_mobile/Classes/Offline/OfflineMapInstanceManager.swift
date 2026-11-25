import Flutter
import MapboxMaps

final class OfflineMapInstanceManager: _OfflineMapInstanceManager, _TileStoreInstanceManager {
    enum `Error`: Swift.Error {
        case invalidTileStorePath
    }

    private let binaryMessenger: FlutterBinaryMessenger
    private let cancelableOperationRegistry: CancelableOperationRegistry

    init(binaryMessenger: FlutterBinaryMessenger, cancelableOperationRegistry: CancelableOperationRegistry) {
        self.binaryMessenger = binaryMessenger
        self.cancelableOperationRegistry = cancelableOperationRegistry
    }

    func setupOfflineManager(channelSuffix: String) throws {
        let offlineController = OfflineController(
            messenger: SuffixBinaryMessenger(messenger: binaryMessenger, suffix: channelSuffix),
            cancelableOperationRegistry: cancelableOperationRegistry
        )
        _OfflineManagerSetup.setUp(binaryMessenger: binaryMessenger, api: offlineController, messageChannelSuffix: channelSuffix)
    }

    func tearDownOfflineManager(channelSuffix: String) throws {
        _OfflineManagerSetup.setUp(binaryMessenger: binaryMessenger, api: nil, messageChannelSuffix: channelSuffix)
    }

    func setupTileStore(channelSuffix: String, filePath: String?) throws {
        let tileStore: TileStore
        if let filePath {
            tileStore = .shared(for: URL(fileURLWithPath: filePath))
        } else {
            tileStore = .default
        }

        MapboxMapsOptions.tileStore = tileStore
        let tileStoreController = TileStoreController(
            messenger: SuffixBinaryMessenger(messenger: binaryMessenger, suffix: channelSuffix),
            tileStore: tileStore,
            cancelableOperationRegistry: cancelableOperationRegistry
        )

        _TileStoreSetup.setUp(binaryMessenger: binaryMessenger, api: tileStoreController, messageChannelSuffix: channelSuffix)
    }

    func tearDownTileStore(channelSuffix: String) throws {
        _TileStoreSetup.setUp(binaryMessenger: binaryMessenger, api: nil, messageChannelSuffix: channelSuffix)
        MapboxMapsOptions.tileStore = nil
    }
}
