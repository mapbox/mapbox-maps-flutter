import MapboxMaps
import Flutter

final class TileStoreController: _TileStore {

    enum `Error`: Swift.Error {
        case invalidTileRegionLoadOptions
    }

    private let messenger: SuffixBinaryMessenger
    private let tileStore: TileStore

    private lazy var offlineManager = OfflineManager()
    private let cancelableOperationRegistry: CancelableOperationRegistry
    private var tileRegionLoadProgressHandlers: [Int64: AnyFlutterStreamHandler] = [:]
    private var tileRegionEstimateProgressHandlers: [Int64: AnyFlutterStreamHandler] = [:]

    init(messenger: SuffixBinaryMessenger, tileStore: TileStore, cancelableOperationRegistry: CancelableOperationRegistry) {
        self.messenger = messenger
        self.tileStore = tileStore
        self.cancelableOperationRegistry = cancelableOperationRegistry
    }

    func loadTileRegion(id: String, loadOptions: TileRegionLoadOptions, operationId: Int64, completion: @escaping (Result<TileRegion, Swift.Error>) -> Void) {
        guard let loadOptions = offlineManager.tileRegionLoadOptions(loadOptions) else {
            completion(.failure(Error.invalidTileRegionLoadOptions))
            return
        }

        let cancelable = tileStore.loadTileRegion(forId: id, loadOptions: loadOptions) { [weak self] progress in
            DispatchQueue.main.async {
                self?.tileRegionLoadProgressHandlers[operationId]?.eventSink?(progress.toFLTTileRegionLoadProgress().toList())
            }
        } completion: { [weak self] result in
            DispatchQueue.main.async {
                completion(result.map { $0.toFLTTileRegion() }.mapPigeonError())
                self?.cancelableOperationRegistry.unregister(operationId: operationId)
                self?.tileRegionLoadProgressHandlers.removeValue(forKey: operationId)?.eventSink?(FlutterEndOfEventStream)
            }
        }
        cancelableOperationRegistry.register(operationId: operationId, cancelable: cancelable)
    }

    func addTileRegionLoadProgressListener(id: String, operationId: Int64) throws {
        let eventChannel = FlutterEventChannel(name: "com.mapbox.maps.flutter/\(messenger.suffix)/tile-region-\(operationId)", binaryMessenger: messenger.messenger)
        let handler = AnyFlutterStreamHandler { [weak self] in
            self?.tileRegionLoadProgressHandlers.removeValue(forKey: operationId)
            eventChannel.setStreamHandler(nil)
        }
        eventChannel.setStreamHandler(handler)
        tileRegionLoadProgressHandlers[operationId] = handler
    }

    func estimateTileRegion(id: String, loadOptions: TileRegionLoadOptions, estimateOptions: TileRegionEstimateOptions?, operationId: Int64, completion: @escaping (Result<TileRegionEstimateResult, Swift.Error>) -> Void) {

        guard let loadOptions = offlineManager.tileRegionLoadOptions(loadOptions) else {
            completion(.failure(Error.invalidTileRegionLoadOptions))
            return
        }

        let cancelable = tileStore.estimateTileRegion(
            forId: id,
            loadOptions: loadOptions,
            estimateOptions: estimateOptions.map(MapboxCommon.TileRegionEstimateOptions.init(fltValue:))) { [weak self] progress in
                DispatchQueue.main.async {
                    self?.tileRegionEstimateProgressHandlers[operationId]?.eventSink?(progress.toFLTTileRegionEstimateProgress().toList())
                }
            } completion: { [weak self] result in
                DispatchQueue.main.async {
                    completion(result.map { $0.toFLTTileRegionEstimateResult() }.mapPigeonError())
                    self?.cancelableOperationRegistry.unregister(operationId: operationId)
                    self?.tileRegionEstimateProgressHandlers.removeValue(forKey: operationId)?.eventSink?(FlutterEndOfEventStream)
                }
            }
        cancelableOperationRegistry.register(operationId: operationId, cancelable: cancelable)
    }

    func addTileRegionEstimateProgressListener(id: String, operationId: Int64) throws {
        let eventChannel = FlutterEventChannel(name: "com.mapbox.maps.flutter/\(messenger.suffix)/tile-region-estimate-\(operationId)", binaryMessenger: messenger.messenger)
        let handler = AnyFlutterStreamHandler { [weak self] in
            self?.tileRegionEstimateProgressHandlers.removeValue(forKey: operationId)
            eventChannel.setStreamHandler(nil)
        }
        eventChannel.setStreamHandler(handler)
        tileRegionEstimateProgressHandlers[operationId] = handler
    }

    func tileRegionMetadata(id: String, completion: @escaping (Result<[String: Any], Swift.Error>) -> Void) {
        tileStore.tileRegionMetadata(forId: id) { result in
            completion(result.map { $0 as? [String: Any] ?? [:] }.mapPigeonError())
        }
    }

    func tileRegionContainsDescriptor(id: String, options: [TilesetDescriptorOptions], completion: @escaping (Result<Bool, Swift.Error>) -> Void) {
        let descriptors = options
            .compactMap(MapboxCoreMaps.TilesetDescriptorOptions.init(fltValue:))
            .map(offlineManager.createTilesetDescriptor(for:))

        tileStore.tileRegionContainsDescriptors(forId: id, descriptors: descriptors) { result in
            executeOnMainThread(completion)(result.mapPigeonError())
        }
    }

    func allTileRegions(completion: @escaping (Result<[TileRegion], Swift.Error>) -> Void) {
        tileStore.allTileRegions { result in
            let result = result.map { regions in
                regions.map { $0.toFLTTileRegion() }
            }.mapPigeonError()
            completion(result)
        }
    }

    func tileRegion(id: String, completion: @escaping (Result<TileRegion, Swift.Error>) -> Void) {
        tileStore.tileRegion(forId: id) { result in
            executeOnMainThread(completion)(result.map { $0.toFLTTileRegion() }.mapPigeonError())
        }
    }

    func removeRegion(id: String, completion: @escaping (Result<TileRegion, Swift.Error>) -> Void) {
        tileStore.removeRegion(forId: id) { result in
            executeOnMainThread(completion)(result.map { $0.toFLTTileRegion() }.mapPigeonError())
        }
    }

    func setOptionForKey(key: _KeyedTileStoreOptions, domain: TileDataDomain?, value: Any?) throws {
        let resolvedKey: String
        switch key {
        case let predefinedKey as _PredefinedTileStoreOptionsKey:
            resolvedKey = predefinedKey.key.toTileStoreOptionsKey()
        case let customKey as _CustomTileStoreOptionsKey:
            resolvedKey = customKey.key
        default:
            fatalError("unexpected _KeyedTileStoreOptions subtype: \(key)")
        }
        if let domain {
            tileStore.setOptionForKey(resolvedKey, domain: domain.toTileDataDomain(), value: value as Any)
        } else {
            tileStore.setOptionForKey(resolvedKey, value: value as Any)
        }
    }
}

extension OfflineManager {

    fileprivate func tileRegionLoadOptions(_ fltValue: TileRegionLoadOptions) -> MapboxCommon.TileRegionLoadOptions? {
        .init(
            geometry: convertDictionaryToGeometry(dict: fltValue.geometry),
            descriptors: fltValue.descriptorsOptions?.compactMap { descriptorOptions in
                guard let descriptorOptions else { return nil }
                return MapboxCoreMaps.TilesetDescriptorOptions(fltValue: descriptorOptions).map(createTilesetDescriptor(for:))
            },
            metadata: fltValue.metadata,
            acceptExpired: fltValue.acceptExpired,
            networkRestriction: MapboxCommon.NetworkRestriction(fltValue: fltValue.networkRestriction),
            averageBytesPerSecond: fltValue.averageBytesPerSecond.map(Int.init),
            extraOptions: fltValue.extraOptions
        )
    }
}
