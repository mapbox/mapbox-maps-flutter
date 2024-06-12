import MapboxMaps
import Flutter

final class TileStoreController: _TileStore {

    enum `Error`: Swift.Error {
        case invalidTileRegionLoadOptions
    }

    private let proxy: ProxyBinaryMessenger
    private let tileStore: TileStore

    private lazy var offlineManager = OfflineManager()
    private var tileRegionLoadProgressHandlers: [String: AnyFlutterStreamHandler] = [:]
    private var tileRegionEstimateProgressHandlers: [String: AnyFlutterStreamHandler] = [:]

    init(proxy: ProxyBinaryMessenger, tileStore: TileStore) {
        self.proxy = proxy
        self.tileStore = tileStore
    }

    func loadTileRegion(id: String, loadOptions: TileRegionLoadOptions, completion: @escaping (Result<TileRegion, Swift.Error>) -> Void) {
        guard let loadOptions = offlineManager.tileRegionLoadOptions(loadOptions) else {
            completion(.failure(Error.invalidTileRegionLoadOptions))
            return
        }

        tileStore.loadTileRegion(forId: id, loadOptions: loadOptions) { [weak self] progress in
            guard let self else { return }
            self.tileRegionLoadProgressHandlers[id]?.eventSink?(progress.toFLTTileRegionLoadProgress().toList())
        } completion: { [weak self] result in
            executeOnMainThread(completion)(result.map { $0.toFLTTileRegion() })
            self?.tileRegionLoadProgressHandlers.removeValue(forKey: id)
        }
    }

    func addTileRegionLoadProgressListener(id: String) throws {
        let handler = AnyFlutterStreamHandler()
        let eventChannel = FlutterEventChannel(name: "com.mapbox.maps.flutter/tilestore/tile-region-\(id)", binaryMessenger: proxy.messenger)
        eventChannel.setStreamHandler(handler)
        tileRegionLoadProgressHandlers[id] = handler
    }

    func estimateTileRegion(id: String, loadOptions: TileRegionLoadOptions, estimateOptions: TileRegionEstimateOptions?, completion: @escaping (Result<TileRegionEstimateResult, Swift.Error>) -> Void) {

        guard let loadOptions = offlineManager.tileRegionLoadOptions(loadOptions) else {
            completion(.failure(Error.invalidTileRegionLoadOptions))
            return
        }

        tileStore.estimateTileRegion(
            forId: id,
            loadOptions: loadOptions,
            estimateOptions: estimateOptions.map(MapboxCommon.TileRegionEstimateOptions.init(fltValue:))) { [weak self] progress in
                guard let self else { return }
                self.tileRegionEstimateProgressHandlers[id]?.eventSink?(progress.toFLTTileRegionEstimateProgress().toList())
            } completion: { [weak self] result in
                executeOnMainThread(completion)(result.map { $0.toFLTTileRegionEstimateResult() })
                self?.tileRegionEstimateProgressHandlers.removeValue(forKey: id)
            }
    }

    func addTileRegionEstimateProgressListener(id: String) throws {
        let handler = AnyFlutterStreamHandler()
        let eventChannel = FlutterEventChannel(name: "com.mapbox.maps.flutter/tilestore/tile-region-estimate-\(id)", binaryMessenger: proxy.messenger)
        eventChannel.setStreamHandler(handler)
        tileRegionEstimateProgressHandlers[id] = handler
    }

    func tileRegionMetadata(id: String, completion: @escaping (Result<[String: Any], Swift.Error>) -> Void) {
        tileStore.tileRegionMetadata(forId: id) { result in
            completion(result.map { $0 as? [String: Any] ?? [:] })
        }
    }

    func tileRegionContainsDescriptor(id: String, options: [TilesetDescriptorOptions], completion: @escaping (Result<Bool, Swift.Error>) -> Void) {
        let descriptors = options
            .map(MapboxCoreMaps.TilesetDescriptorOptions.init(fltValue:))
            .map(offlineManager.createTilesetDescriptor(for:))

        tileStore.tileRegionContainsDescriptors(forId: id, descriptors: descriptors, completion: executeOnMainThread(completion))
    }

    func allTileRegions(completion: @escaping (Result<[TileRegion], Swift.Error>) -> Void) {
        tileStore.allTileRegions { result in
            let result = result.map { regions in
                regions.map { $0.toFLTTileRegion() }
            }
            completion(result)
        }
    }

    func tileRegion(id: String, completion: @escaping (Result<TileRegion, Swift.Error>) -> Void) {
        tileStore.tileRegion(forId: id) { result in
            executeOnMainThread(completion)(result.map { $0.toFLTTileRegion() })
        }
    }

    func removeRegion(id: String, completion: @escaping (Result<TileRegion, Swift.Error>) -> Void) {
        tileStore.removeRegion(forId: id) { result in
            executeOnMainThread(completion)(result.map { $0.toFLTTileRegion() })
        }
    }
}

extension OfflineManager {

    fileprivate func tileRegionLoadOptions(_ fltValue: TileRegionLoadOptions) -> MapboxCommon.TileRegionLoadOptions? {
        .init(
            geometry: convertDictionaryToGeometry(dict: fltValue.geometry),
            descriptors: fltValue.descriptorsOptions?.compactMap { descriptorOptions in
                guard let descriptorOptions else { return nil }
                return createTilesetDescriptor(for: MapboxCoreMaps.TilesetDescriptorOptions(fltValue: descriptorOptions))
            },
            metadata: fltValue.metadata,
            acceptExpired: fltValue.acceptExpired,
            networkRestriction: MapboxCommon.NetworkRestriction(other: fltValue.networkRestriction) ?? .none,
            averageBytesPerSecond: fltValue.averageBytesPerSecond.map(Int.init),
            extraOptions: fltValue.extraOptions
        )
    }
}
